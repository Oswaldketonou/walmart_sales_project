# ===============================
# utils_metrics.R
# Custom Error Metric Functions
# ===============================

# Root Mean Squared Error
rmse <- function(actual, predicted) {
  sqrt(mean((actual - predicted)^2, na.rm = TRUE))
}

# Mean Absolute Error
mae <- function(actual, predicted) {
  mean(abs(actual - predicted), na.rm = TRUE)
}

# Mean Absolute Percentage Error
mape <- function(actual, predicted) {
  mean(abs((actual - predicted) / actual), na.rm = TRUE) * 100
}

# Symmetric Mean Absolute Percentage Error
smape <- function(actual, predicted) {
  numerator <- abs(actual - predicted)
  denominator <- (abs(actual) + abs(predicted)) / 2
  mean(numerator / denominator, na.rm = TRUE) * 100
}

