# =====================================================================
# Walmart Sales Forecasting Project
# 08_model_compare_and_visualize.R
# Author: Waldo Ketonou | WaldoSphere Group LLC
# Purpose: Compare model performance + generate evaluation visualizations
# Requires: 06_model_evaluation.R and 07_model_training.R
# =====================================================================

library(dplyr)
library(ggplot2)
library(readr)

cat("\n===== Model Comparison and Visualization =====\n")

# =====================================================================
# 1. Load Evaluation Data
# =====================================================================

test_df <- readr::read_csv("outputs/prepared_data/test_df.csv")
test_clean <- test_df %>% filter(complete.cases(.))
eval_actual <- test_clean$actual_sales

# =====================================================================
# 2. Load Predictions from Disk
# =====================================================================

lm_pred        <- readr::read_csv("outputs/predictions/lm_baseline_predictions.csv")$predicted
rf_small1_pred <- readr::read_csv("outputs/predictions/rf_small1_predictions.csv")$predicted
rf_small2_pred <- readr::read_csv("outputs/predictions/rf_small2_predictions.csv")$predicted
rf_small3_pred <- readr::read_csv("outputs/predictions/rf_small3_predictions.csv")$predicted
rf_medium_pred <- readr::read_csv("outputs/predictions/rf_medium_predictions.csv")$predicted
rf_large_pred  <- readr::read_csv("outputs/predictions/rf_large_predictions.csv")$predicted

# =====================================================================
# 3. Define Metrics
# =====================================================================

rmse <- function(a, p) sqrt(mean((p - a)^2))
mae  <- function(a, p) mean(abs(p - a))
mape <- function(a, p) mean(abs((p - a) / a)) * 100
smape <- function(a, p) mean(2 * abs(p - a) / (abs(a) + abs(p))) * 100

# =====================================================================
# 4. Build Comparison Table
# =====================================================================

compare_tbl <- tibble(
  model = c(
    "Linear Regression",
    "RF Small1 (10k)",
    "RF Small2 (100k)",
    "RF Small3 (200k)",
    "RF Medium (500k)",
    "RF Large (1M)"
  ),
  RMSE  = c(
    rmse(eval_actual, lm_pred),
    rmse(eval_actual, rf_small1_pred),
    rmse(eval_actual, rf_small2_pred),
    rmse(eval_actual, rf_small3_pred),
    rmse(eval_actual, rf_medium_pred),
    rmse(eval_actual, rf_large_pred)
  ),
  MAE   = c(
    mae(eval_actual, lm_pred),
    mae(eval_actual, rf_small1_pred),
    mae(eval_actual, rf_small2_pred),
    mae(eval_actual, rf_small3_pred),
    mae(eval_actual, rf_medium_pred),
    mae(eval_actual, rf_large_pred)
  ),
  MAPE  = c(
    mape(eval_actual, lm_pred),
    mape(eval_actual, rf_small1_pred),
    mape(eval_actual, rf_small2_pred),
    mape(eval_actual, rf_small3_pred),
    mape(eval_actual, rf_medium_pred),
    mape(eval_actual, rf_large_pred)
  ),
  SMAPE = c(
    smape(eval_actual, lm_pred),
    smape(eval_actual, rf_small1_pred),
    smape(eval_actual, rf_small2_pred),
    smape(eval_actual, rf_small3_pred),
    smape(eval_actual, rf_medium_pred),
    smape(eval_actual, rf_large_pred)
  )
)

print(compare_tbl)

# =====================================================================
# 5. Identify Best Model by RMSE
# =====================================================================

best_model_name <- compare_tbl$model[which.min(compare_tbl$RMSE)]

best_pred <- case_when(
  best_model_name == "Linear Regression" ~ lm_pred,
  best_model_name == "RF Small1 (10k)"   ~ rf_small1_pred,
  best_model_name == "RF Small2 (100k)"  ~ rf_small2_pred,
  best_model_name == "RF Small3 (200k)"  ~ rf_small3_pred,
  best_model_name == "RF Medium (500k)" ~ rf_medium_pred,
  TRUE                                   ~ rf_large_pred
)

# =====================================================================
# 6. Prepare Visualization Data
# =====================================================================

viz_df <- tibble(
  date      = test_clean$date,
  actual    = eval_actual,
  predicted = best_pred,
  residuals = eval_actual - best_pred
)

dir.create("visuals", recursive = TRUE, showWarnings = FALSE)

# =====================================================================
# 7. Visualization: Actual vs Predicted
# =====================================================================

p1 <- ggplot(viz_df, aes(x = date)) +
  geom_line(aes(y = actual, color = "Actual"), linewidth = 1.2) +
  geom_line(aes(y = predicted, color = "Predicted"), linewidth = 1.2) +
  labs(
    title = paste("Actual vs Predicted Sales —", best_model_name),
    x = "Date", y = "Sales"
  ) +
  scale_color_manual(values = c("Actual" = "black", "Predicted" = "blue")) +
  theme_minimal(base_size = 14)

ggsave("visuals/best_model_actual_vs_predicted.png", p1, width = 10, height = 6)

# =====================================================================
# 8. Visualization: Residual Distribution
# =====================================================================

p2 <- ggplot(viz_df, aes(x = residuals)) +
  geom_histogram(bins = 50, fill = "steelblue", color = "white") +
  labs(
    title = paste("Residual Distribution —", best_model_name),
    x = "Residuals", y = "Count"
  ) +
  theme_minimal(base_size = 14)

ggsave("visuals/best_model_residual_distribution.png", p2, width = 8, height = 5)

# =====================================================================
# 9. Visualization: Predicted vs Actual Scatter
# =====================================================================

p3 <- ggplot(viz_df, aes(x = actual, y = predicted)) +
  geom_point(alpha = 0.4, color = "darkgreen") +
  geom_abline(slope = 1, intercept = 0, color = "red", linewidth = 1.2) +
  labs(
    title = paste("Predicted vs Actual Scatter —", best_model_name),
    x = "Actual Sales", y = "Predicted Sales"
  ) +
  theme_minimal(base_size = 14)

ggsave("visuals/best_model_pred_vs_actual_scatter.png", p3, width = 8, height = 5)

cat("\nSaved visualizations to /visuals/\n")
