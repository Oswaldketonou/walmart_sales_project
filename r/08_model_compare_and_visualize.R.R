# ============================================
# Walmart Sales Forecasting Project
# 08_model_compare_and_visualize.R
# Author: Waldo Ketonou | WaldoSphere Group LLC
# Model Comparison + Visualizations
# ============================================

library(dplyr)
library(ggplot2)
library(readr)

# --------------------------------------------
# 1. Load data, predictions, and utilities
# --------------------------------------------

source("utils_metrics.R")

actuals <- read_csv("data/actuals_test.csv")
pred_small  <- read_csv("data/pred_rf_small.csv")
pred_medium <- read_csv("data/pred_rf_medium.csv")
pred_large  <- read_csv("data/pred_rf_large.csv")

# Merge predictions with actuals
df <- actuals %>%
  left_join(pred_small,  by = "id") %>%
  left_join(pred_medium, by = "id") %>%
  left_join(pred_large,  by = "id")

# --------------------------------------------
# 2. Compute metrics + comparison table
# --------------------------------------------

compare_tbl <- tibble(
  model = c("RF_small", "RF_medium", "RF_large"),
  RMSE  = c(
    rmse(df$actual, df$pred_small),
    rmse(df$actual, df$pred_medium),
    rmse(df$actual, df$pred_large)
  ),
  MAE   = c(
    mae(df$actual, df$pred_small),
    mae(df$actual, df$pred_medium),
    mae(df$actual, df$pred_large)
  ),
  MAPE  = c(
    mape(df$actual, df$pred_small),
    mape(df$actual, df$pred_medium),
    mape(df$actual, df$pred_large)
  ),
  SMAPE = c(
    smape(df$actual, df$pred_small),
    smape(df$actual, df$pred_medium),
    smape(df$actual, df$pred_large)
  )
)

write_csv(compare_tbl, "outputs/model_comparison.csv")

# --------------------------------------------
# 3. Visualizations
# --------------------------------------------

# Actual vs Predicted (best model)
best_model <- compare_tbl %>% arrange(RMSE) %>% slice(1) %>% pull(model)

df$best_pred <- dplyr::case_when(
  best_model == "RF_small"  ~ df$pred_small,
  best_model == "RF_medium" ~ df$pred_medium,
  best_model == "RF_large"  ~ df$pred_large
)

p1 <- ggplot(df, aes(x = actual, y = best_pred)) +
  geom_point(alpha = 0.4, color = "#2C7BB6") +
  geom_abline(linetype = "dashed", color = "red") +
  labs(
    title = paste("Actual vs Predicted —", best_model),
    x = "Actual Sales",
    y = "Predicted Sales"
  ) +
  theme_minimal()

ggsave("visuals/actual_vs_predicted.png", p1, width = 8, height = 5)

# Residual distribution
df$residuals <- df$actual - df$best_pred

p2 <- ggplot(df, aes(x = residuals)) +
  geom_histogram(bins = 40, fill = "#1B9E77", alpha = 0.7) +
  labs(
    title = paste("Residual Distribution —", best_model),
    x = "Residuals",
    y = "Count"
  ) +
  theme_minimal()

ggsave("visuals/residual_distribution.png", p2, width = 8, height = 5)

# Time-series plot
p3 <- ggplot(df, aes(x = date)) +
  geom_line(aes(y = actual, color = "Actual")) +
  geom_line(aes(y = best_pred, color = "Predicted")) +
  labs(
    title = paste("Actual vs Predicted Over Time —", best_model),
    x = "Date",
    y = "Sales"
  ) +
  scale_color_manual(values = c("Actual" = "#D95F02", "Predicted" = "#1B9E77")) +
  theme_minimal()

ggsave("visuals/time_series.png", p3, width = 10, height = 5)

# --------------------------------------------
# 4. Save combined output
# --------------------------------------------

saveRDS(list(
  comparison = compare_tbl,
  best_model = best_model
), "outputs/model_compare_and_visualize.rds")
