# =====================================================================
# Walmart Sales Forecasting Project
# 06_model_evaluation.R
# Author: Waldo Ketonou | WaldoSphere Group LLC
# Purpose: Connect to PostgreSQL, load modeling_clean, evaluate model
# =====================================================================

# -----------------------------
# Load libraries
# -----------------------------
library(DBI)
library(RPostgres)
library(dplyr)

# -----------------------------
# Connect to PostgreSQL
# -----------------------------
con <- dbConnect(
  RPostgres::Postgres(),
  dbname   = "postgres",
  host     = "localhost",
  port     = 5432,
  user     = "postgres",
  password = "mypasswordtopostegresql"
)

# -----------------------------
# Load modeling_clean table
# -----------------------------
modeling <- dbGetQuery(con, "SELECT * FROM modeling_clean")

# -----------------------------
# Train/Test Split
# -----------------------------
modeling$date <- as.Date(modeling$date)

max_date <- max(modeling$date)
cutoff_date <- max_date - 42   # last 6 weeks = test set

train <- modeling %>% filter(date < cutoff_date)
test  <- modeling %>% filter(date >= cutoff_date)

# -----------------------------
# Custom metric functions
# -----------------------------
rmse <- function(actual, predicted) sqrt(mean((actual - predicted)^2))
mae  <- function(actual, predicted) mean(abs(actual - predicted))
mape <- function(actual, predicted) mean(abs((actual - predicted) / actual)) * 100
smape <- function(actual, predicted) {
  mean(2 * abs(predicted - actual) / (abs(actual) + abs(predicted))) * 100
}

# -----------------------------
# Fit baseline linear regression model
# -----------------------------
model <- lm(
  actual_sales ~ lag_1_week + lag_4_weeks +
    rolling_4_week + rolling_12_week +
    feature_is_holiday + temperature + fuel_price +
    cpi + unemployment + store_type + store_size +
    week + month + year,
  data = train
)

# -----------------------------
# Generate predictions
# -----------------------------
test$predicted_sales <- predict(model, newdata = test)

# -----------------------------
# Fix NA predictions (if any)
# -----------------------------
test$predicted_sales[is.na(test$predicted_sales)] <- 
  mean(train$actual_sales, na.rm = TRUE)

# -----------------------------
# Calculate evaluation metrics
# -----------------------------
rmse_value  <- rmse(test$actual_sales, test$predicted_sales)
mae_value   <- mae(test$actual_sales, test$predicted_sales)
mape_value  <- mape(test$actual_sales, test$predicted_sales)
smape_value <- smape(test$actual_sales, test$predicted_sales)

metrics <- data.frame(
  Metric = c("RMSE", "MAE", "MAPE", "SMAPE"),
  Value  = c(rmse_value, mae_value, mape_value, smape_value)
)

print(metrics)

# -----------------------------
# Save evaluation results
# -----------------------------
write.csv(metrics, "model_evaluation_results.csv", row.names = FALSE)

# -----------------------------
# Close database connection
# -----------------------------
dbDisconnect(con)

# =====================================================================
# END OF MODEL EVALUATION SCRIPT
# =====================================================================
