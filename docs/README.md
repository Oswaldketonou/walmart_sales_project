## Modeling Strategy (Summary)

- **Target:** Weekly_Sales (store × department × week)

- **Features:**
  - Time‑based: year, month, week, season, is_holiday
  - Lag features: lagged_sales_1
  - Rolling features: rolling_mean_3, rolling_mean_5
  - Markdown features: markdown_total, markdown_1–5
  - External variables: temperature, fuel_price, CPI, unemployment
  - Identifiers: store, dept
  - Interaction terms: store × dept, holiday × markdown_total, season × dept

- **Split:** Chronological panel split  
  - Train: 2010–2011  
  - Test: 2012  
  - Performed within each store–department group to avoid leakage

- **Baselines:**  
  - Naïve lag model (t‑1)  
  - Rolling mean baseline (3‑week)

- **Models:**  
  - Linear regression  
  - Regularized models (Ridge, Lasso, Elastic Net)  
  - Tree‑based models (Random Forest, Gradient Boosting, XGBoost)

- **Metrics:**  
  - MAE  
  - MAPE (primary business metric)  
  - SMAPE  
  - RMSE  
  - R²  

