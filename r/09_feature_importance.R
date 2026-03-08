# =====================================================================
# Walmart Sales Forecasting Project
# 09_feature_importance.R
# Author: Waldo Ketonou | WaldoSphere Group LLC
# Purpose: Extract and visualize feature importance from RF models
# Requires: 07_model_training.R
# =====================================================================

library(dplyr)
library(tidyr)
library(ggplot2)
library(readr)

cat("\n===== Feature Importance Extraction and Visualization =====\n")

dir.create("visuals", recursive = TRUE, showWarnings = FALSE)

# =====================================================================
# 0. Load trained Random Forest models (aligned with 07_model_training.R)
# =====================================================================

rf_small1_model <- readRDS("outputs/models/rf_small1_model.rds")
rf_small2_model <- readRDS("outputs/models/rf_small2_model.rds")
rf_small3_model <- readRDS("outputs/models/rf_small3_model.rds")
rf_medium_model <- readRDS("outputs/models/rf_medium_model.rds")
rf_large_model  <- readRDS("outputs/models/rf_large_model.rds")

# =====================================================================
# 1. Extract Variable Importance from Each Model
# =====================================================================

get_importance <- function(model, model_name) {
  if (is.null(model$variable.importance)) {
    stop(paste("Variable importance not found for model:", model_name))
  }
  
  tibble(
    feature    = names(model$variable.importance),
    importance = as.numeric(model$variable.importance),
    model      = model_name
  )
}

imp_small1 <- get_importance(rf_small1_model, "RF Small1 (10k)")
imp_small2 <- get_importance(rf_small2_model, "RF Small2 (100k)")
imp_small3 <- get_importance(rf_small3_model, "RF Small3 (200k)")
imp_medium <- get_importance(rf_medium_model, "RF Medium (500k)")
imp_large  <- get_importance(rf_large_model,  "RF Large (1M)")

importance_all <- bind_rows(
  imp_small1, imp_small2, imp_small3, imp_medium, imp_large
)

# =====================================================================
# 2. Normalize Importance Values
# =====================================================================

importance_norm <- importance_all %>%
  group_by(model) %>%
  mutate(norm_importance = importance / max(importance)) %>%
  ungroup()

# =====================================================================
# 3. Plot Importance for Each Model Separately (saved to /visuals)
# =====================================================================

plot_importance <- function(df, model_name, file_name) {
  p <- ggplot(df %>% filter(model == model_name),
              aes(x = reorder(feature, norm_importance),
                  y = norm_importance)) +
    geom_col(fill = "steelblue") +
    coord_flip() +
    labs(
      title = paste("Variable Importance —", model_name),
      x = "Feature",
      y = "Normalized Importance"
    ) +
    theme_minimal(base_size = 14)
  
  ggsave(file.path("visuals", file_name), p, width = 9, height = 6)
}

plot_importance(importance_norm, "RF Small1 (10k)",  "rf_small1_importance.png")
plot_importance(importance_norm, "RF Small2 (100k)", "rf_small2_importance.png")
plot_importance(importance_norm, "RF Small3 (200k)", "rf_small3_importance.png")
plot_importance(importance_norm, "RF Medium (500k)", "rf_medium_importance.png")
plot_importance(importance_norm, "RF Large (1M)",    "rf_large_importance.png")

# =====================================================================
# 4. Combined Comparison Plot (All Models)
# =====================================================================

p_compare <- ggplot(importance_norm,
                    aes(x = feature,
                        y = norm_importance,
                        fill = model)) +
  geom_col(position = "dodge") +
  coord_flip() +
  labs(
    title = "Variable Importance Comparison Across RF Models",
    x = "Feature",
    y = "Normalized Importance"
  ) +
  theme_minimal(base_size = 14)

ggsave("visuals/rf_all_models_importance_comparison.png", p_compare,
       width = 11, height = 7)

# =====================================================================
# 5. Summary Table for Case Study
# =====================================================================

importance_summary <- importance_norm %>%
  select(feature, model, norm_importance) %>%
  pivot_wider(names_from = model, values_from = norm_importance) %>%
  arrange(desc(`RF Large (1M)`))

readr::write_csv(importance_summary,
                 "outputs/evaluation/rf_feature_importance_summary.csv")

print(importance_summary)

cat("\nFeature importance visuals saved to /visuals and summary to /outputs/evaluation/.\n")
# =====================================================================
# End of Script
# =====================================================================
