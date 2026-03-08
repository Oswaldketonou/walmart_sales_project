# =====================================================================
# Walmart Sales Forecasting Project
# 10_simulation_scenarios.R
# Author: Waldo Ketonou | WaldoSphere Group LLC
# Purpose: Run scenario simulations using final RF model (1M sample)
# Requires: 07_model_training.R
# =====================================================================

library(dplyr)
library(readr)
library(ranger)

cat("\n===== Scenario Simulation: RF Large (1M rows) =====\n")

# 1. Load final model and test data
final_model <- readRDS("outputs/models/rf_large_model.rds")
test_df     <- readr::read_csv("outputs/prepared_data/test_df.csv")
test_clean  <- test_df %>% filter(complete.cases(.))

# 2. Baseline prediction
baseline_pred <- predict(final_model, data = test_clean)$predictions
test_clean$baseline_pred <- baseline_pred

# 3. Define simulation scenarios
scenario_A <- test_clean %>% mutate(fuel_price = fuel_price * 1.10)
scenario_B <- test_clean %>% mutate(cpi = cpi * 0.90)
scenario_C <- test_clean %>% mutate(temperature = temperature + 5)
scenario_D <- test_clean %>% mutate(feature_is_holiday = factor("1", levels = levels(test_clean$feature_is_holiday)))
scenario_E <- test_clean %>% mutate(
  fuel_price         = fuel_price * 1.10,
  cpi                = cpi * 0.90,
  temperature        = temperature + 5,
  feature_is_holiday = factor("1", levels = levels(test_clean$feature_is_holiday))
)

# 4. Predict for each scenario
predict_scenario <- function(df) {
  predict(final_model, data = df)$predictions
}

test_clean$pred_A <- predict_scenario(scenario_A)
test_clean$pred_B <- predict_scenario(scenario_B)
test_clean$pred_C <- predict_scenario(scenario_C)
test_clean$pred_D <- predict_scenario(scenario_D)
test_clean$pred_E <- predict_scenario(scenario_E)

# 5. Compute deltas vs baseline
test_clean <- test_clean %>%
  mutate(
    delta_A = pred_A - baseline_pred,
    delta_B = pred_B - baseline_pred,
    delta_C = pred_C - baseline_pred,
    delta_D = pred_D - baseline_pred,
    delta_E = pred_E - baseline_pred
  )

# 6. Summary table for dashboard / case study
scenario_summary <- tibble(
  scenario = c(
    "Fuel +10%",
    "CPI -10%",
    "Temp +5°F",
    "Holiday Promotion",
    "Combined Shock"
  ),
  avg_change = c(
    mean(test_clean$delta_A),
    mean(test_clean$delta_B),
    mean(test_clean$delta_C),
    mean(test_clean$delta_D),
    mean(test_clean$delta_E)
  ),
  pct_change = c(
    mean(test_clean$delta_A / test_clean$baseline_pred) * 100,
    mean(test_clean$delta_B / test_clean$baseline_pred) * 100,
    mean(test_clean$delta_C / test_clean$baseline_pred) * 100,
    mean(test_clean$delta_D / test_clean$baseline_pred) * 100,
    mean(test_clean$delta_E / test_clean$baseline_pred) * 100
  )
)

print(scenario_summary)

# Optional: Save summary to disk
readr::write_csv(scenario_summary, "outputs/evaluation/rf_large_scenario_summary.csv")

cat("\nScenario simulation complete. Summary saved to /outputs/evaluation/\n")
