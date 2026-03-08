# =====================================================================
# Walmart Sales Forecasting Project
# 07_model_training.R
# Author: Waldo Ketonou | WaldoSphere Group LLC
# Purpose: Train baseline linear model + RF scaling experiments
# =====================================================================

library(dplyr)
library(ranger)

# =====================================================================
# 0A. Clear environment, console, and plots
# =====================================================================

rm(list = ls())
gc()
cat("\014")
if (!is.null(dev.list())) dev.off()

cat("Environment cleared. Ready to load train/test CSVs.\n")

# =====================================================================
# 1. Baseline Linear Regression Model (Unified Predictors)
# =====================================================================

cat("\n===== Linear Regression: BASELINE MODEL =====\n")

# 1. Load cleaned training data
train_clean <- readr::read_csv("outputs/prepared_data/train_df.csv")

# 2. Load test set
test_df <- readr::read_csv("outputs/prepared_data/test_df.csv")

# Clean test set
test_clean <- test_df %>% dplyr::filter(complete.cases(.))

# 3. SMAPE definition
smape <- function(actual, predicted) {
  mean(2 * abs(predicted - actual) / (abs(actual) + abs(predicted))) * 100
}

# 4. Linear Regression Formula (Unified Predictors)
lm_formula <- actual_sales ~ 
  lag_4_weeks + rolling_4_week + rolling_12_week +
  feature_is_holiday + temperature + fuel_price + cpi + unemployment +
  store_type + store_size + week + month + year

# 5. Train Linear Regression Model
lm_model <- lm(lm_formula, data = train_clean)

# 6. Predict on test_clean
lm_pred <- predict(lm_model, newdata = test_clean)

# Filter valid predictions
eval_idx    <- !is.na(lm_pred)
eval_pred   <- lm_pred[eval_idx]
eval_actual <- test_clean$actual_sales[eval_idx]

# 7. Metrics
rmse_lm  <- sqrt(mean((eval_pred - eval_actual)^2))
mae_lm   <- mean(abs(eval_pred - eval_actual))
mape_lm  <- mean(abs((eval_pred - eval_actual) / eval_actual)) * 100
smape_lm <- smape(eval_actual, eval_pred)

# Ensure output directories exist
dir.create("outputs/models", recursive = TRUE, showWarnings = FALSE)
dir.create("outputs/predictions", recursive = TRUE, showWarnings = FALSE)
dir.create("outputs/evaluation", recursive = TRUE, showWarnings = FALSE)

# 8. Save model
saveRDS(lm_model, "outputs/models/lm_baseline_model.rds")

# 9. Save predictions
pred_df <- data.frame(
  actual = eval_actual,
  predicted = eval_pred
)
readr::write_csv(pred_df, "outputs/predictions/lm_baseline_predictions.csv")

# 10. Save metrics
metrics_df <- data.frame(
  rmse  = rmse_lm,
  mae   = mae_lm,
  mape  = mape_lm,
  smape = smape_lm
)
readr::write_csv(metrics_df, "outputs/evaluation/lm_baseline_metrics.csv")

# 11. Print metrics
cat("RMSE :", rmse_lm, "\n")
cat("MAE  :", mae_lm, "\n")
cat("MAPE :", mape_lm, "%\n")
cat("SMAPE:", smape_lm, "%\n")

# 12. Clear memory
rm(list = ls())
gc()

# =====================================================================
# 2. Random Forest Scaling Experiments (Unified Predictors)
# =====================================================================

# ============================================
# 2.A RF SMALL1 (10k rows) -SMALL2 (100K rows)- SMALL3 (200K rows)— Memory‑Safe Training
# ============================================

cat("\n===== Random Forest: SMALL1 (10k rows) =====\n")

# 1. Load cleaned training data
train_clean <- readr::read_csv("outputs/prepared_data/train_df.csv")

# 2. Load test set
test_df <- readr::read_csv("outputs/prepared_data/test_df.csv")

# Clean test set
test_clean <- test_df %>% dplyr::filter(complete.cases(.))

# 3. SMAPE definition
smape <- function(actual, predicted) {
  mean(2 * abs(predicted - actual) / (abs(actual) + abs(predicted))) * 100
}

# 4. Sample 10k rows
set.seed(123)
sampled_train <- train_clean %>%
  dplyr::filter(complete.cases(.)) %>%
  dplyr::sample_n(10000)

# 5. Train RF model
library(ranger)

rf_small1_model <- ranger(
  formula = actual_sales ~ lag_4_weeks + rolling_4_week + rolling_12_week +
    feature_is_holiday + temperature + fuel_price + cpi + unemployment +
    store_type + store_size + week + month + year,
  data = sampled_train,
  num.trees = 200,
  write.forest = TRUE,
  num.threads = 1,
  importance = "impurity"
)

# 6. Predict
rf_small1_pred <- predict(rf_small1_model, data = test_clean)$predictions
rf_small1_actual <- test_clean$actual_sales

# 7. Metrics
rf_small1_rmse  <- sqrt(mean((rf_small1_pred - rf_small1_actual)^2))
rf_small1_mae   <- mean(abs(rf_small1_pred - rf_small1_actual))
rf_small1_mape  <- mean(abs((rf_small1_pred - rf_small1_actual) / rf_small1_actual)) * 100
rf_small1_smape <- smape(rf_small1_actual, rf_small1_pred)

# Ensure output directories exist
dir.create("outputs/models", recursive = TRUE, showWarnings = FALSE)
dir.create("outputs/predictions", recursive = TRUE, showWarnings = FALSE)
dir.create("outputs/evaluation", recursive = TRUE, showWarnings = FALSE)

# 8. Save model
saveRDS(rf_small1_model, "outputs/models/rf_small1_model.rds")

# 9. Save predictions
pred_df <- data.frame(
  actual = rf_small1_actual,
  predicted = rf_small1_pred
)
readr::write_csv(pred_df, "outputs/predictions/rf_small1_predictions.csv")

# 10. Save metrics
metrics_df <- data.frame(
  rmse  = rf_small1_rmse,
  mae   = rf_small1_mae,
  mape  = rf_small1_mape,
  smape = rf_small1_smape
)
readr::write_csv(metrics_df, "outputs/evaluation/rf_small1_metrics.csv")

# 11. Print metrics
cat("RMSE :", rf_small1_rmse, "\n")
cat("MAE  :", rf_small1_mae, "\n")
cat("MAPE :", rf_small1_mape, "%\n")
cat("SMAPE:", rf_small1_smape, "%\n")

# 12. Clear memory
rm(list = ls())
gc()

cat("\n===== Random Forest: SMALL2 (100k rows) =====\n")

# 1. Load cleaned training data
train_clean <- readr::read_csv("outputs/prepared_data/train_df.csv")

# 2. Load test set
test_df <- readr::read_csv("outputs/prepared_data/test_df.csv")

# Clean test set (remove rows with missing values)
test_clean <- test_df %>% dplyr::filter(complete.cases(.))

# 3. SMAPE definition
smape <- function(actual, predicted) {
  mean(2 * abs(predicted - actual) / (abs(actual) + abs(predicted))) * 100
}

# 4. Sample 100k rows
set.seed(123)
sampled_train <- train_clean %>%
  dplyr::filter(complete.cases(.)) %>%
  dplyr::sample_n(100000)

# 5. Train RF model
library(ranger)

rf_small2_model <- ranger(
  formula = actual_sales ~ lag_4_weeks + rolling_4_week + rolling_12_week +
    feature_is_holiday + temperature + fuel_price + cpi + unemployment +
    store_type + store_size + week + month + year,
  data = sampled_train,
  num.trees = 200,
  write.forest = TRUE,
  num.threads = 1,
  importance = "impurity"
)

# 6. Predict on test_clean
rf_small2_pred <- predict(rf_small2_model, data = test_clean)$predictions
rf_small2_actual <- test_clean$actual_sales

# 7. Metrics
rf_small2_rmse  <- sqrt(mean((rf_small2_pred - rf_small2_actual)^2))
rf_small2_mae   <- mean(abs(rf_small2_pred - rf_small2_actual))
rf_small2_mape  <- mean(abs((rf_small2_pred - rf_small2_actual) / rf_small2_actual)) * 100
rf_small2_smape <- smape(rf_small2_actual, rf_small2_pred)

# Ensure output directories exist
dir.create("outputs/models", recursive = TRUE, showWarnings = FALSE)
dir.create("outputs/predictions", recursive = TRUE, showWarnings = FALSE)
dir.create("outputs/evaluation", recursive = TRUE, showWarnings = FALSE)

# 8. Save model object
saveRDS(rf_small2_model, "outputs/models/rf_small2_model.rds")

# 9. Save predictions
pred_df <- data.frame(
  actual = rf_small2_actual,
  predicted = rf_small2_pred   # <-- FIXED TYPO
)
readr::write_csv(pred_df, "outputs/predictions/rf_small2_predictions.csv")

# 10. Save metrics
metrics_df <- data.frame(
  rmse  = rf_small2_rmse,
  mae   = rf_small2_mae,
  mape  = rf_small2_mape,
  smape = rf_small2_smape
)
readr::write_csv(metrics_df, "outputs/evaluation/rf_small2_metrics.csv")

# 11. Print metrics
cat("RMSE :", rf_small2_rmse, "\n")
cat("MAE  :", rf_small2_mae, "\n")
cat("MAPE :", rf_small2_mape, "%\n")
cat("SMAPE:", rf_small2_smape, "%\n")

# 12. Clear memory
rm(list = ls())
gc()

cat("\n===== Random Forest: SMALL3 (200k rows) =====\n")

# 1. Load cleaned training data
train_clean <- readr::read_csv("outputs/prepared_data/train_df.csv")

# 2. Load test set
test_df <- readr::read_csv("outputs/prepared_data/test_df.csv")

# Clean test set (remove rows with missing values)
test_clean <- test_df %>% dplyr::filter(complete.cases(.))

# 3. SMAPE definition
smape <- function(actual, predicted) {
  mean(2 * abs(predicted - actual) / (abs(actual) + abs(predicted))) * 100
}

# 4. Sample 200k rows
set.seed(123)
sampled_train <- train_clean %>%
  dplyr::filter(complete.cases(.)) %>%
  dplyr::sample_n(200000)

# 5. Train RF model
library(ranger)

rf_small3_model <- ranger(
  formula = actual_sales ~ lag_4_weeks + rolling_4_week + rolling_12_week +
    feature_is_holiday + temperature + fuel_price + cpi + unemployment +
    store_type + store_size + week + month + year,
  data = sampled_train,
  num.trees = 200,
  write.forest = TRUE,
  num.threads = 1,
  importance = "impurity"
)

# 6. Predict on test_clean
rf_small3_pred <- predict(rf_small3_model, data = test_clean)$predictions
rf_small3_actual <- test_clean$actual_sales

# 7. Metrics
rf_small3_rmse  <- sqrt(mean((rf_small3_pred - rf_small3_actual)^2))
rf_small3_mae   <- mean(abs(rf_small3_pred - rf_small3_actual))
rf_small3_mape  <- mean(abs((rf_small3_pred - rf_small3_actual) / rf_small3_actual)) * 100
rf_small3_smape <- smape(rf_small3_actual, rf_small3_pred)

# Ensure output directories exist
dir.create("outputs/models", recursive = TRUE, showWarnings = FALSE)
dir.create("outputs/predictions", recursive = TRUE, showWarnings = FALSE)
dir.create("outputs/evaluation", recursive = TRUE, showWarnings = FALSE)

# 8. Save model object
saveRDS(rf_small3_model, "outputs/models/rf_small3_model.rds")

# 9. Save predictions
pred_df <- data.frame(
  actual = rf_small3_actual,
  predicted = rf_small3_pred
)
readr::write_csv(pred_df, "outputs/predictions/rf_small3_predictions.csv")

# 10. Save metrics
metrics_df <- data.frame(
  rmse  = rf_small3_rmse,
  mae   = rf_small3_mae,
  mape  = rf_small3_mape,
  smape = rf_small3_smape
)
readr::write_csv(metrics_df, "outputs/evaluation/rf_small3_metrics.csv")

# 11. Print metrics
cat("RMSE :", rf_small3_rmse, "\n")
cat("MAE  :", rf_small3_mae, "\n")
cat("MAPE :", rf_small3_mape, "%\n")
cat("SMAPE:", rf_small3_smape, "%\n")

# 12. Clear memory
rm(list = ls())
gc()


# =====================================================================
# 2B. Medium Model — 500,000 rows
# =====================================================================

cat("\n===== Random Forest: MEDIUM (500k rows) =====\n")

train_clean <- readr::read_csv("outputs/prepared_data/train_df.csv")
test_df <- readr::read_csv("outputs/prepared_data/test_df.csv")
test_clean <- test_df %>% dplyr::filter(complete.cases(.))

smape <- function(actual, predicted) {
  mean(2 * abs(predicted - actual) / (abs(actual) + abs(predicted))) * 100
}

set.seed(123)
sampled_train <- train_clean %>%
  dplyr::filter(complete.cases(.)) %>%
  dplyr::sample_n(500000)

library(ranger)

rf_medium_model <- ranger(
  formula = actual_sales ~ lag_4_weeks + rolling_4_week + rolling_12_week +
    feature_is_holiday + temperature + fuel_price + cpi + unemployment +
    store_type + store_size + week + month + year,
  data = sampled_train,
  num.trees = 200,
  write.forest = TRUE,
  num.threads = 1,
  importance = "impurity"
)

rf_medium_pred <- predict(rf_medium_model, data = test_clean)$predictions
rf_medium_actual <- test_clean$actual_sales

rf_medium_rmse  <- sqrt(mean((rf_medium_pred - rf_medium_actual)^2))
rf_medium_mae   <- mean(abs(rf_medium_pred - rf_medium_actual))
rf_medium_mape  <- mean(abs((rf_medium_pred - rf_medium_actual) / rf_medium_actual)) * 100
rf_medium_smape <- smape(rf_medium_actual, rf_medium_pred)

dir.create("outputs/models", recursive = TRUE, showWarnings = FALSE)
dir.create("outputs/predictions", recursive = TRUE, showWarnings = FALSE)
dir.create("outputs/evaluation", recursive = TRUE, showWarnings = FALSE)

saveRDS(rf_medium_model, "outputs/models/rf_medium_model.rds")

pred_df <- data.frame(
  actual = rf_medium_actual,
  predicted = rf_medium_pred
)
readr::write_csv(pred_df, "outputs/predictions/rf_medium_predictions.csv")

metrics_df <- data.frame(
  rmse  = rf_medium_rmse,
  mae   = rf_medium_mae,
  mape  = rf_medium_mape,
  smape = rf_medium_smape
)
readr::write_csv(metrics_df, "outputs/evaluation/rf_medium_metrics.csv")

cat("RMSE :", rf_medium_rmse, "\n")
cat("MAE  :", rf_medium_mae, "\n")
cat("MAPE :", rf_medium_mape, "%\n")
cat("SMAPE:", rf_medium_smape, "%\n")

rm(list = ls())
gc()

# =====================================================================
# 2C. Large Model — 1M rows
# =====================================================================
cat("\n===== Random Forest: LARGE (1M rows) =====\n")

train_clean <- readr::read_csv("outputs/prepared_data/train_df.csv")
test_df <- readr::read_csv("outputs/prepared_data/test_df.csv")
test_clean <- test_df %>% dplyr::filter(complete.cases(.))

smape <- function(actual, predicted) {
  mean(2 * abs(predicted - actual) / (abs(actual) + abs(predicted))) * 100
}

set.seed(123)
sampled_train <- train_clean %>%
  dplyr::filter(complete.cases(.)) %>%
  dplyr::sample_n(1000000)

library(ranger)

rf_large_model <- ranger(
  formula = actual_sales ~ lag_4_weeks + rolling_4_week + rolling_12_week +
    feature_is_holiday + temperature + fuel_price + cpi + unemployment +
    store_type + store_size + week + month + year,
  data = sampled_train,
  num.trees = 200,
  write.forest = TRUE,
  num.threads = 1,
  importance = "impurity"
)

rf_large_pred <- predict(rf_large_model, data = test_clean)$predictions
rf_large_actual <- test_clean$actual_sales

rf_large_rmse  <- sqrt(mean((rf_large_pred - rf_large_actual)^2))
rf_large_mae   <- mean(abs(rf_large_pred - rf_large_actual))
rf_large_mape  <- mean(abs((rf_large_pred - rf_large_actual) / rf_large_actual)) * 100
rf_large_smape <- smape(rf_large_actual, rf_large_pred)

dir.create("outputs/models", recursive = TRUE, showWarnings = FALSE)
dir.create("outputs/predictions", recursive = TRUE, showWarnings = FALSE)
dir.create("outputs/evaluation", recursive = TRUE, showWarnings = FALSE)

saveRDS(rf_large_model, "outputs/models/rf_large_model.rds")

pred_df <- data.frame(
  actual = rf_large_actual,
  predicted = rf_large_pred
)
readr::write_csv(pred_df, "outputs/predictions/rf_large_predictions.csv")

metrics_df <- data.frame(
  rmse  = rf_large_rmse,
  mae   = rf_large_mae,
  mape  = rf_large_mape,
  smape = rf_large_smape
)
readr::write_csv(metrics_df, "outputs/evaluation/rf_large_metrics.csv")

cat("RMSE :", rf_large_rmse, "\n")
cat("MAE  :", rf_large_mae, "\n")
cat("MAPE :", rf_large_mape, "%\n")
cat("SMAPE:", rf_large_smape, "%\n")

rm(list = ls())
gc()

# =====================================================================
# 3. Save Diagnostic Visuals to /visuals
# =====================================================================

# Create folder if missing
if (!dir.exists("visuals")) dir.create("visuals")

# -----------------------------
# Linear Model: Predicted vs Actual
# -----------------------------
png("visuals/lm_pred_vs_actual.png", width = 1200, height = 800)
plot(eval_actual, eval_pred,
     main = "Linear Model: Predicted vs Actual",
     xlab = "Actual Sales",
     ylab = "Predicted Sales",
     pch = 16, col = rgb(0, 0, 1, 0.4))
abline(0, 1, col = "red", lwd = 2)
dev.off()

# -----------------------------
# Linear Model: Residuals
# -----------------------------
png("visuals/lm_residuals.png", width = 1200, height = 800)
plot(eval_pred - eval_actual,
     main = "Linear Model Residuals",
     xlab = "Index",
     ylab = "Residual",
     pch = 16, col = rgb(1, 0, 0, 0.4))
abline(h = 0, col = "blue", lwd = 2)
dev.off()

# -----------------------------
# RF Small: Predicted vs Actual
# -----------------------------
cat("\n===== Visualization: SMALL Models Predicted vs Actual =====\n")

library(ggplot2)
library(readr)
library(dplyr)

# Ensure visuals directory exists
dir.create("visuals", recursive = TRUE, showWarnings = FALSE)

# 1. Load predictions for all SMALL models
small1 <- readr::read_csv("outputs/predictions/rf_small1_predictions.csv") %>%
  mutate(model = "SMALL1 (10k)")

small2 <- readr::read_csv("outputs/predictions/rf_small2_predictions.csv") %>%
  mutate(model = "SMALL2 (100k)")

small3 <- readr::read_csv("outputs/predictions/rf_small3_predictions.csv") %>%
  mutate(model = "SMALL3 (200k)")

# 2. Combine into one dataframe
pred_all <- bind_rows(small1, small2, small3)

# 3. Plot Predicted vs Actual for all SMALL models
p <- ggplot(pred_all, aes(x = actual, y = predicted, color = model)) +
  geom_point(alpha = 0.35, size = 1.8) +
  geom_abline(intercept = 0, slope = 1, color = "red",
              linetype = "dashed", linewidth = 1.2) +   # <-- FIXED HERE
  labs(
    title = "Predicted vs Actual Sales — SMALL Models (10k, 100k, 200k)",
    x = "Actual Sales",
    y = "Predicted Sales",
    color = "Model"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(face = "bold"),
    legend.position = "bottom"
  )

# 4. Save plot
ggsave("visuals/small_models_pred_vs_actual.png", p, width = 10, height = 7)

cat("\nSaved: visuals/small_models_pred_vs_actual.png\n")
# -----------------------------
# RF Small: Feature Importance
# -----------------------------
png("visuals/rf_small_importance.png", width = 1200, height = 800)
barplot(rf_small$model$variable.importance,
        las = 2,
        main = "RF Small: Feature Importance",
        col = "steelblue")
dev.off()

# -----------------------------
# RF Small: Error Distribution
# -----------------------------
png("visuals/rf_small_error_dist.png", width = 1200, height = 800)
hist(rf_small$model$predictions - eval_actual,
     breaks = 50,
     main = "RF Small: Error Distribution",
     xlab = "Prediction Error",
     col = "darkorange")
dev.off()
# =====================================================================
# End of Script
# =====================================================================
