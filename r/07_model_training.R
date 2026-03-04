# ======================================================
# 07 MODEL TRAINING
# Random Forest Model Training for Walmart Sales Forecasting
# ======================================================

# -------------------------------
# 1. Load Libraries
# -------------------------------
library(dplyr)
library(readr)
library(ranger)

# Ensure reproducibility
set.seed(123)

# -------------------------------
# 2. Load Training & Test Data
# -------------------------------
# Requires: SQL preprocessing pipeline completed and CSVs exported

train_df <- read_csv("data/train_clean.csv")
test_df  <- read_csv("data/test_clean.csv")

# -------------------------------
# 3. Define Feature Set
# -------------------------------
feature_cols <- setdiff(names(train_df), c("weekly_sales", "id"))

# -------------------------------
# 4. Train Random Forest Models
# -------------------------------
# NOTE: Tree counts are intentionally kept low due to hardware limits.

# Small model (baseline)
model_rf_small <- ranger(
  formula = weekly_sales ~ .,
  data = train_df[, c("weekly_sales", feature_cols)],
  num.trees = 100,
  mtry = floor(length(feature_cols) * 0.3),
  min.node.size = 5,
  importance = "impurity",
  write.forest = TRUE,
  num.threads = 1
)

# Medium model (safe upper limit for your machine)
model_rf_medium <- ranger(
  formula = weekly_sales ~ .,
  data = train_df[, c("weekly_sales", feature_cols)],
  num.trees = 200,
  mtry = floor(length(feature_cols) * 0.5),
  min.node.size = 5,
  importance = "impurity",
  write.forest = TRUE,
  num.threads = 1
)

# Large model removed — your system cannot handle 800 trees reliably.

cat("Models trained successfully.\n")

# -------------------------------
# 5. Generate Predictions
# -------------------------------
pred_rf_small  <- predict(model_rf_small,  data = test_df)$predictions
pred_rf_medium <- predict(model_rf_medium, data = test_df)$predictions

# -------------------------------
# 6. Save Predictions
# -------------------------------
pred_out <- test_df %>%
  select(id, weekly_sales) %>%
  mutate(
    pred_small  = pred_rf_small,
    pred_medium = pred_rf_medium
  )

write_csv(pred_out, "outputs/predictions_rf_all_models.csv")

cat("Predictions saved to outputs/predictions_rf_all_models.csv\n")

# -------------------------------
# 7. Save Model Objects
# -------------------------------
saveRDS(model_rf_small,  "models/model_rf_small.rds")
saveRDS(model_rf_medium, "models/model_rf_medium.rds")

cat("Models saved to /models folder.\n")

# -------------------------------
# 8. Completion Message
# -------------------------------
cat("07_model_training.R completed successfully.\n")
