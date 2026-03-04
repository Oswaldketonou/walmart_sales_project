# =====================================================================
# Walmart Sales Forecasting Project
# 08_model_compare_and_visualize.R
# Author: Waldo Ketonou | WaldoSphere Group LLC
# Purpose: Compare model performance + generate evaluation visualizations
# Requires: 06_model_evaluation.R and 07_model_training.R
# =====================================================================

library(dplyr)
library(ggplot2)

# =====================================================================
# 1. Prepare Evaluation Data
# =====================================================================

# Clean test set (same logic used in 07_model_training.R)
test_clean <- test_df %>% filter(complete.cases(.))
eval_actual <- test_clean$actual_sales

# Predictions from trained models
lm_pred      <- predict(lm_model, newdata = test_clean)
rf_small_pred  <- predict(rf_small$model,  data = test_clean)$predictions
rf_medium_pred <- predict(rf_medium$model, data = test_clean)$predictions
rf_large_pred  <- predict(rf_large$model,  data = test_clean)$predictions

# =====================================================================
# 2. Define Metrics
# =====================================================================

rmse <- function(a, p) sqrt(mean((p - a)^2))
mae  <- function(a, p) mean(abs(p - a))
mape <- function(a, p) mean(abs((p - a) / a)) * 100
smape <- function(a, p) mean(2 * abs(p - a) / (abs(a) + abs(p))) * 100

# =====================================================================
# 3. Build Comparison Table
# =====================================================================

compare_tbl <- tibble(
  model = c("Linear Regression", "RF Small (200k)", "RF Medium (500k)", "RF Large (1M)"),
  RMSE  = c(
    rmse(eval_actual, lm_pred),
    rmse(eval_actual, rf_small_pred),
    rmse(eval_actual, rf_medium_pred),
    rmse(eval_actual, rf_large_pred)
  ),
  MAE   = c(
    mae(eval_actual, lm_pred),
    mae(eval_actual, rf_small_pred),
    mae(eval_actual, rf_medium_pred),
    mae(eval_actual, rf_large_pred)
  ),
  MAPE  = c(
    mape(eval_actual, lm_pred),
    mape(eval_actual, rf_small_pred),
    mape(eval_actual, rf_medium_pred),
    mape(eval_actual, rf_large_pred)
  ),
  SMAPE = c(
    smape(eval_actual, lm_pred),
    smape(eval_actual, rf_small_pred),
    smape(eval_actual, rf_medium_pred),
    smape(eval_actual, rf_large_pred)
  )
)

print(compare_tbl)

# =====================================================================
# 4. Visualization: Actual vs Predicted (Best Model)
# =====================================================================

# Identify best model by RMSE
best_model_name <- compare_tbl$model[which.min(compare_tbl$RMSE)]

if (best_model_name == "Linear Regression") {
  best_pred <- lm_pred
} else if (best_model_name == "RF Small (200k)") {
  best_pred <- rf_small_pred
} else if (best_model_name == "RF Medium (500k)") {
  best_pred <- rf_medium_pred
} else {
  best_pred <- rf_large_pred
}

viz_df <- tibble(
  date = test_clean$date,
  actual = eval_actual,
  predicted = best_pred
)

p1 <- ggplot(viz_df, aes(x = date)) +
  geom_line(aes(y = actual, color = "Actual")) +
  geom_line(aes(y = predicted, color = "Predicted")) +
  labs(
    title = paste("Actual vs Predicted Sales —", best_model_name),
    x = "Date",
    y = "Sales"
  ) +
  scale_color_manual(values = c("Actual" = "black", "Predicted" = "blue")) +
  theme_minimal()

print(p1)

# =====================================================================
# 5. Visualization: Residual Distribution
# =====================================================================

viz_df$residuals <- viz_df$actual - viz_df$predicted

p2 <- ggplot(viz_df, aes(x = residuals)) +
  geom_histogram(bins = 50, fill = "steelblue", color = "white") +
  labs(
    title = paste("Residual Distribution —", best_model_name),
    x = "Residuals",
    y = "Count"
  ) +
  theme_minimal()

print(p2)

# =====================================================================
# 6. Visualization: Predicted vs Actual Scatter
# =====================================================================

p3 <- ggplot(viz_df, aes(x = actual, y = predicted)) +
  geom_point(alpha = 0.4, color = "darkgreen") +
  geom_abline(slope = 1, intercept = 0, color = "red") +
  labs(
    title = paste("Predicted vs Actual Scatter —", best_model_name),
    x = "Actual Sales",
    y = "Predicted Sales"
  ) +
  theme_minimal()

print(p3)

# =====================================================================
# End of Script
# =====================================================================
