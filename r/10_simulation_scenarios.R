# =====================================================================
# Walmart Sales Forecasting Project
# 10_simulation_scenarios.R
# Author: Waldo Ketonou | WaldoSphere Group LLC
# Purpose: Run scenario simulations using final RF model (1M sample)
# Requires: 06_model_evaluation.R and 07_model_training.R
# =====================================================================

library(dplyr)

# =====================================================================
# 1. Load Final Model
# =====================================================================

# If saved externally:
# final_model <- readRDS("models/final_rf_model.rds")

# If running in the same R session:
final_model <- rf_large$model

# =====================================================================
# 2. Prepare Clean Test Data for Simulation
# =====================================================================

test_sim <- test_df %>% filter(complete.cases(.))

baseline_pred <- predict(final_model, data = test_sim)$predictions
test_sim$baseline_pred <- baseline_pred

# =====================================================================
# 3. Define Simulation Scenarios
# =====================================================================

# Scenario A: +10% fuel price increase
scenario_A <- test_sim %>%
  mutate(fuel_price = fuel_price * 1.10)

# Scenario B: -10% CPI decrease (economic relief)
scenario_B <- test_sim %>%
  mutate(cpi = cpi * 0.90)

# Scenario C: +5°F temperature increase (heat wave)
scenario_C <- test_sim %>%
  mutate(temperature = temperature + 5)

# Scenario D: Holiday promotion boost (set all holiday flags to 1)
scenario_D <- test_sim %>%
  mutate(feature_is_holiday = factor(1, levels = levels(test_sim$feature_is_holiday)))

# Scenario E: Combined shock (fuel ↑10%, CPI ↓10%, temp ↑5°F)
scenario_E <- test_sim %>%
  mutate(
    fuel_price  = fuel_price * 1.10,
    cpi         = cpi * 0.90,
    temperature = temperature + 5
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
# 7. Optional: Export Scenario Results for Dashboard
# =====================================================================

# write.csv(test_sim, "outputs/scenario_predictions.csv", row.names = FALSE)
# write.csv(scenario_summary, "outputs/scenario_summary.csv", row.names = FALSE)

# =====================================================================
# End of Script
# =====================================================================
