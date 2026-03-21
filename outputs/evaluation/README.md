### `/outputs/evaluation`
This folder contains all model evaluation outputs generated during the forecasting pipeline.  
It includes performance metrics for each model variant (Linear Regression, Random Forest Small/Medium/Large) as well as scenario simulation summaries.

Files include:
- `lm_baseline_metrics.csv` — Baseline Linear Regression performance  
- `rf_small1_metrics.csv`, `rf_small2_metrics.csv`, `rf_small3_metrics.csv` — Random Forest (small dataset) metrics  
- `rf_medium_metrics.csv` — Random Forest (medium dataset) metrics  
- `rf_large_metrics.csv` — Final Random Forest (1M rows) metrics  
- `rf_feature_importance_summary.csv` — Consolidated feature importance across RF models  
- `rf_large_scenario_summary.csv` — Scenario simulation results for the final model  

These outputs feed into the case study, Power BI dashboard, and final business recommendations.

