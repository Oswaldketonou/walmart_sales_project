# =====================================================================
# Walmart Sales Forecasting Project
# 10_simulation_scenarios.R
# Author: Waldo Ketonou | WaldoSphere Group LLC
# Purpose: Run scenario simulations using final RF model (1M sample)
# Requires: 06_model_evaluation.R and 07_model_training.R
# =====================================================================

library(dplyr)

# =====================================================================
# 1. Load Final Model + Test Data
# =====================================================================

final_model <- readRDS("outputs/models/rf_large.rds")
test_df     <- read.csv("outputs/prepared_data/test_df.csv")

# =====================================================================
# 2. Prepare Clean Test Data for Simulation
# =====================================================================

test_sim <- test_df %>% filter(complete.cases(.))

baseline_pred <- predict(final_model, data = test_sim)$predictions
test_sim$baseline_pred <- baseline_pred

# =====================================================================
# 3. Define Simulation Scenarios
# =====================================================================

scenario_A <- test_sim %>%
  mutate(fuel_price = fuel_price * 1.10)

scenario_B <- test_sim %>%
  mutate(cpi = cpi * 0.90)

scenario_C <- test_sim %>%
  mutate(temperature = temperature + 5)

scenario_D <- test_sim %>%
  mutate(feature_is_holiday = factor("1", levels = levels(test_sim$feature_is_holiday)))

scenario_E <- test_sim %>%
  mutate(
    fuel_price         = fuel_price * 1.10,
    cpi                = cpi * 0.90,
    temperature        = temperature + 5,
    feature_is_holiday = factor("1", levels = levels(test_sim$feature_is_holiday))
  )

# =====================================================================
# 4. Predict for Each Scenario
# =====================================================================

predict_scenario <- function(df) {
  predict(final_model, data = df)$predictions
}

test_sim$pred_A <- predict_scenario(scenario_A)
test_sim$pred_B <- predict_scenario(scenario_B)
test_sim$pred_C <- predict_scenario(scenario_C)
test_sim$pred_D <- predict_scenario(scenario_D)
test_sim$pred_E <- predict_scenario(scenario_E)

# =====================================================================
# 5. Compute Deltas vs Baseline
# =====================================================================

test_sim <- test_sim %>%
  mutate(
    delta_A = pred_A - baseline_pred,
    delta_B = pred_B - baseline_pred,
    delta_C = pred_C - baseline_pred,
    delta_D = pred_D - baseline_pred,
    delta_E = pred_E - baseline_pred
  )

# =====================================================================
# 6. Summary Table for Dashboard / Case Study
# =====================================================================

scenario_summary <- tibble(
  scenario = c(
    "Fuel +10%",
    "CPI -10%",
    "Temp +5°F",
    "Holiday Promotion",
    "Combined Shock"
  ),
  avg_change = c(
    mean(test_sim$delta_A),
    mean(test_sim$delta_B),
    mean(test_sim$delta_C),
    mean(test_sim$delta_D),
    mean(test_sim$delta_E)
  ),
  pct_change = c(
    mean(test_sim$delta_A / test_sim$baseline_pred) * 100,
    mean(test_sim$delta_B / test_sim$baseline_pred) * 100,
    mean(test_sim$delta_C / test_sim$baseline_pred) * 100,
    mean(test_sim$delta_D / test_sim$baseline_pred) * 100,
    mean(test_sim$delta_E / test_sim$baseline_pred) * 100
  )
)

print(scenario_summary)

# =====================================================================
# End of Script
# =====================================================================
