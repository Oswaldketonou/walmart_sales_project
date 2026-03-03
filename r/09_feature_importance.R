############################################################
## Walmart Sales Forecasting Project
# 09_feature_importance.R
# Author: Waldo Ketonou | WaldoSphere Group LLC
# Variable importance for RF_small, RF_medium, RF_large
############################################################

library(dplyr)
library(tidyr)
library(ggplot2)

############################################################
# 1. Extract variable importance from each model
############################################################

get_importance <- function(model, model_name) {
  tibble(
    feature = names(model$variable.importance),
    importance = as.numeric(model$variable.importance),
    model = model_name
  )
}

imp_small  <- get_importance(rf_small$model,  "RF Small (200k)")
imp_medium <- get_importance(rf_medium$model, "RF Medium (500k)")
imp_large  <- get_importance(rf_large$model,  "RF Large (1M)")

# Combine into one table
importance_all <- bind_rows(imp_small, imp_medium, imp_large)

print(importance_all)


############################################################
# 2. Normalize importance values (optional but recommended)
############################################################

importance_norm <- importance_all %>%
  group_by(model) %>%
  mutate(norm_importance = importance / max(importance)) %>%
  ungroup()

print(importance_norm)


############################################################
# 3. Plot importance for each model separately
############################################################

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


############################################################
# 4. Combined comparison plot (all models)
############################################################

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


############################################################
# 5. Summary table for case study
############################################################

importance_summary <- importance_norm %>%
  group_by(feature) %>%
  summarize(
    small  = norm_importance[model == "RF Small (200k)"],
    medium = norm_importance[model == "RF Medium (500k)"],
    large  = norm_importance[model == "RF Large (1M)"]
  ) %>%
  arrange(desc(large))

print(importance_summary)

############################################################
# End of Script
############################################################
