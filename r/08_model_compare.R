############################################################
# Walmart Sales Forecasting Project
# 08_model_compare.R
# Author: Waldo Ketonou | WaldoSphere Group LLC
# Compare LM baseline vs. RF models (200k, 500k, 1M)
############################################################

library(dplyr)
library(ggplot2)
library(tidyr)

############################################################
# 1. Build comparison table
############################################################

model_compare <- tibble(
  model = c("Linear Regression",
            "RF Small (200k)",
            "RF Medium (500k)",
            "RF Large (1M)"),

  sample_size = c(NA, 200000, 500000, 1000000),

  rmse  = c(rmse_lm,
            rf_small$rmse,
            rf_medium$rmse,
            rf_large$rmse),

  mae   = c(mae_lm,
            rf_small$mae,
            rf_medium$mae,
            rf_large$mae),

  mape  = c(mape_lm,
            rf_small$mape,
            rf_medium$mape,
            rf_large$mape),

  smape = c(smape_lm,
            rf_small$smape,
            rf_medium$smape,
            rf_large$smape)
)

print(model_compare)


############################################################
# 2. Convert to long format for plotting
############################################################

compare_long <- model_compare %>%
  pivot_longer(cols = c(rmse, mae, mape, smape),
               names_to = "metric",
               values_to = "value")


############################################################
# 3. Plot RMSE, MAE, SMAPE vs sample size
############################################################

# Only RF models have sample sizes → filter out LM for plots
rf_long <- compare_long %>% filter(!is.na(sample_size))

# RMSE plot
p_rmse <- ggplot(rf_long %>% filter(metric == "rmse"),
                 aes(x = sample_size, y = value)) +
  geom_line(color = "steelblue", linewidth = 1.2) +
  geom_point(size = 3, color = "steelblue") +
  scale_x_continuous(labels = scales::comma) +
  labs(title = "RMSE vs Sample Size (Random Forest)",
       x = "Training Sample Size",
       y = "RMSE") +
  theme_minimal()

print(p_rmse)

# MAE plot
p_mae <- ggplot(rf_long %>% filter(metric == "mae"),
                aes(x = sample_size, y = value)) +
  geom_line(color = "darkgreen", linewidth = 1.2) +
  geom_point(size = 3, color = "darkgreen") +
  scale_x_continuous(labels = scales::comma) +
  labs(title = "MAE vs Sample Size (Random Forest)",
       x = "Training Sample Size",
       y = "MAE") +
  theme_minimal()

print(p_mae)

# SMAPE plot
p_smape <- ggplot(rf_long %>% filter(metric == "smape"),
                  aes(x = sample_size, y = value)) +
  geom_line(color = "firebrick", linewidth = 1.2) +
  geom_point(size = 3, color = "firebrick") +
  scale_x_continuous(labels = scales::comma) +
  labs(title = "SMAPE vs Sample Size (Random Forest)",
       x = "Training Sample Size",
       y = "SMAPE (%)") +
  theme_minimal()

print(p_smape)


############################################################
# 4. Clean printed summary for case study
############################################################

cat("\n================ Model Comparison Summary ================\n")

cat("\nLinear Regression:\n")
cat("  RMSE :", rmse_lm, "\n")
cat("  MAE  :", mae_lm, "\n")
cat("  MAPE :", mape_lm, "%\n")
cat("  SMAPE:", smape_lm, "%\n")

cat("\nRandom Forest (200k rows):\n")
cat("  RMSE :", rf_small$rmse, "\n")
cat("  MAE  :", rf_small$mae, "\n")
cat("  MAPE :", rf_small$mape, "%\n")
cat("  SMAPE:", rf_small$smape, "%\n")

cat("\nRandom Forest (500k rows):\n")
cat("  RMSE :", rf_medium$rmse, "\n")
cat("  MAE  :", rf_medium$mae, "\n")
cat("  MAPE :", rf_medium$mape, "%\n")
cat("  SMAPE:", rf_medium$smape, "%\n")

cat("\nRandom Forest (1M rows):\n")
cat("  RMSE :", rf_large$rmse, "\n")
cat("  MAE  :", rf_large$mae, "\n")
cat("  MAPE :", rf_large$mape, "%\n")
cat("  SMAPE:", rf_large$smape, "%\n")

cat("\n==========================================================\n")
