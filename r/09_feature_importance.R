# =====================================================================
# Walmart Sales Forecasting Project
# 09_feature_importance.R
# Author: Waldo Ketonou | WaldoSphere Group LLC
# Purpose: Extract and visualize feature importance from RF models
# Requires: 06_model_evaluation.R and 07_model_training.R
# =====================================================================

library(dplyr)
library(tidyr)
library(ggplot2)

# =====================================================================
# 0. Load trained Random Forest models
# =====================================================================

rf_small  <- readRDS("outputs/models/rf_small.rds")
rf_medium <- readRDS("outputs/models/rf_medium.rds")
rf_large  <- readRDS("outputs/models/rf_large.rds")

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

imp_small  <- get_importance(rf_small,  "RF Small (200k)")
imp_medium <- get_importance(rf_medium, "RF Medium (500k)")
imp_large  <- get_importance(rf_large,  "RF Large (1M)")

importance_all <- bind_rows(imp_small, imp_medium, imp_large)

print(importance_all)

# =====================================================================
# 2. Normalize Importance Values
# =====================================================================

importance_norm <- importance_all %>%
  group_by(model) %>%
  mutate(norm_importance = importance / max(importance)) %>%
  ungroup()

print(importance_norm)

# =====================================================================
# 3. Plot Importance for Each Model Separately
# =====================================================================

plot_importance <- function(df, model_name) {
  ggplot(df %>% filter(model == model_name),
         aes(x = reorder(feature, norm_importance),
             y = norm_importance)) +
    geom_col(fill = "steelblue") +
    coord_flip() +
    labs(
      title = paste("Variable Importance —", model_name),
      x = "Feature",
      y = "Normalized Importance"
    ) +
    theme_minimal()
}

p_small  <- plot_importance(importance_norm, "RF Small (200k)")
p_medium <- plot_importance(importance_norm, "RF Medium (500k)")
p_large  <- plot_importance(importance_norm, "RF Large (1M)")

print(p_small)
print(p_medium)
print(p_large)

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
  theme_minimal()

print(p_compare)

# =====================================================================
# 5. Summary Table for Case Study
# =====================================================================

importance_summary <- importance_norm %>%
  select(feature, model, norm_importance) %>%
  pivot_wider(names_from = model, values_from = norm_importance) %>%
  arrange(desc(`RF Large (1M)`))

print(importance_summary)

# =====================================================================
# End of Script
# =====================================================================
