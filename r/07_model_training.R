# =====================================================================
# Walmart Sales Forecasting Project
# 07_model_training.R
# Author: Waldo Ketonou | WaldoSphere Group LLC
# Purpose: Train baseline linear model + RF scaling experiments
# Requires: 06_model_evaluation.R to be run first
# =====================================================================

library(dplyr)
library(ranger)

# =====================================================================
# 1. Baseline Linear Regression Model
# =====================================================================

lm_model <- lm(
  actual_sales ~ lag_4_weeks + rolling_4_week + rolling_12_week +
    feature_is_holiday + temperature + fuel_price + cpi + unemployment +
    store_type + store_size + week + month + year,
  data = train_df
)

summary(lm_model)

lm_pred <- predict(lm_model, newdata = test_df)

eval_idx    <- !is.na(lm_pred)
eval_pred   <- lm_pred[eval_idx]
eval_actual <- test_df$actual_sales[eval_idx]

rmse_lm <- sqrt(mean((eval_pred - eval_actual)^2))
mae_lm  <- mean(abs(eval_pred - eval_actual))
mape_lm <- mean(abs((eval_pred - eval_actual) / eval_actual)) * 100

smape <- function(actual, predicted) {
  mean(2 * abs(predicted - actual) / (abs(actual) + abs(predicted))) * 100
}

smape_lm <- smape(eval_actual, eval_pred)

cat("\n===== Linear Regression Results =====\n")
cat("RMSE :", rmse_lm, "\n")
cat("MAE  :", mae_lm, "\n")
cat("MAPE :", mape_lm, "%\n")
cat("SMAPE:", smape_lm, "%\n")


# =====================================================================
# 2. Random Forest Scaling Experiments
#    Small (200k) → Medium (500k) → Large (1M)
# =====================================================================

train_clean <- train_df %>% filter(complete.cases(.))
test_clean  <- test_df  %>% filter(complete.cases(.))

eval_actual <- test_clean$actual_sales

train_rf_model <- function(sample_size, num_trees = 200) {

  set.seed(123)
  sampled_df <- train_clean %>% sample_n(sample_size)

  rf_model <- ranger(
    formula        = actual_sales ~ lag_4_weeks + feature_is_holiday + temperature +
                       fuel_price + cpi + store_type + store_size + week + month + year,
    data           = sampled_df,
    num.trees      = num_trees,
    write.forest   = TRUE,
    num.threads    = 1,
    importance     = "impurity"
  )

  rf_pred <- predict(rf_model, data = test_clean)$predictions

  rmse_val  <- sqrt(mean((rf_pred - eval_actual)^2))
  mae_val   <- mean(abs(rf_pred - eval_actual))
  mape_val  <- mean(abs((rf_pred - eval_actual) / eval_actual)) * 100
  smape_val <- smape(eval_actual, rf_pred)

  list(
    model = rf_model,
    rmse  = rmse_val,
    mae   = mae_val,
    mape  = mape_val,
    smape = smape_val
  )
}

# =====================================================================
# 2A. Small Model — 200,000 rows
# =====================================================================

cat("\n===== Random Forest: SMALL (200k rows) =====\n")
rf_small <- train_rf_model(200000)

cat("RMSE :", rf_small$rmse, "\n")
cat("MAE  :", rf_small$mae, "\n")
cat("MAPE :", rf_small$mape, "%\n")
cat("SMAPE:", rf_small$smape, "%\n")


# =====================================================================
# 2B. Medium Model — 500,000 rows
# =====================================================================

cat("\n===== Random Forest: MEDIUM (500k rows) =====\n")
rf_medium <- train_rf_model(500000)

cat("RMSE :", rf_medium$rmse, "\n")
cat("MAE  :", rf_medium$mae, "\n")
cat("MAPE :", rf_medium$mape, "%\n")
cat("SMAPE:", rf_medium$smape, "%\n")


# =====================================================================
# 2C. Large Model — 1,000,000 rows
# =====================================================================

cat("\n===== Random Forest: LARGE (1M rows) =====\n")
rf_large <- train_rf_model(1000000)

cat("RMSE :", rf_large$rmse, "\n")
cat("MAE  :", rf_large$mae, "\n")
cat("MAPE :", rf_large$mape, "%\n")
cat("SMAPE:", rf_large$smape, "%\n")


# =====================================================================
# End of Script
# =====================================================================
