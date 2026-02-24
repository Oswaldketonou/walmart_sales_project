<!-- ========================= -->
<!--        TITLE PAGE         -->
<!-- ========================= -->

# Modeling Strategy  
### Walmart Weekly Sales Forecasting

**Author:** Waldo KETONOU  
**Tools:** PostgreSQL, SQL  
**Objective:** Forecast weekly sales at the store‑department level  
**Document Type:** Modeling Strategy (PDF‑Optimized)

---

<div style="page-break-after: always;"></div>

# 1. Problem Framing

The objective of this modeling phase is to forecast weekly sales at the store‑department level using historical Walmart data.  
The model must capture:

- seasonality  
- holiday effects  
- markdown promotions  
- store and department differences  
- lagged sales patterns  

This is a time‑series regression forecasting problem using structured retail data.

---

# 2. Target Variable

**Weekly_Sales**  
A continuous numeric variable representing total sales for a given store, department, and week.

This makes the task a supervised regression problem with temporal dependencies.

---

# 3. Feature Selection

The following engineered features will be used as predictors.

## 3.1 Time‑Based Features
- year  
- month  
- week  
- season  
- is_holiday  

## 3.2 Lag Features
- lagged_sales (previous week’s sales)  
- optional: rolling averages (3‑week, 5‑week)

## 3.3 Markdown Features
- markdown_total  
- individual markdown columns (1–5)

## 3.4 Store & Department Identifiers
- store  
- dept  

These capture structural differences across locations and product categories.

## 3.5 External Features
- temperature  
- fuel price  
- CPI  
- unemployment  

Although these have low correlation, they may still provide marginal predictive value.

---

<div style="page-break-after: always;"></div>

# 4. Train/Test Split Strategy

Because this is time‑series data, a random split is not allowed.

A chronological split will be used:

- Training: 2010–2011  
- Testing: 2012  

This preserves temporal order and simulates real‑world forecasting conditions.

---

# 5. Baseline Model

A baseline model establishes the minimum performance threshold.

## 5.1 Naïve Lag Model

\[
\hat{y}_t = y_{t-1}
\]

This uses last week’s sales as the prediction for the current week.  
All advanced models must outperform this baseline to be considered useful.

---

# 6. Candidate Models

The following models will be evaluated.

## 6.1 Linear Regression
- interpretable  
- fast  
- strong baseline for comparison  

## 6.2 Regularized Models
- Ridge  
- Lasso  
- Elastic Net  

Useful for handling multicollinearity and reducing overfitting.

## 6.3 Tree‑Based Models
- Random Forest  
- Gradient Boosting  
- XGBoost  

These capture nonlinear relationships and interactions between features.

## 6.4 Optional Time‑Series Models
- ARIMA  
- SARIMA  

Useful for pure time‑series patterns but less flexible with many features.

---

<div style="page-break-after: always;"></div>

# 7. Evaluation Metrics

The following KPIs will be used to evaluate model performance:

- Mean Absolute Error (MAE)  
- Mean Absolute Percentage Error (MAPE)  
- Root Mean Squared Error (RMSE)  
- R²  

MAPE will be the primary business metric due to its interpretability.

---

# 8. Assumptions & Constraints

- Sales patterns are influenced by seasonality and holidays  
- Markdown effects are modest but positive  
- Weather and economic variables have minimal impact  
- Data is non‑stationary across years  
- Some store‑department combinations have sparse history  
- No future markdowns or holiday schedules beyond the dataset are known  

These constraints guide model selection and feature engineering.

---

# 9. Risks & Limitations

- Missing markdown and weather data  
- Structural changes in 2012 may reduce accuracy  
- Sparse data for certain departments  
- Holiday effects vary year‑to‑year  
- Markdown data lacks promotion context  

These risks will be addressed through model comparison and feature engineering.

---

<div style="page-break-after: always;"></div>

# 10. Next Steps

1. Build the baseline model  
2. Train and evaluate candidate models  
3. Compare performance using MAE, MAPE, RMSE, R²  
4. Select the best model  
5. Document results in the case study  
6. Integrate results into the dashboard  

---

# End of Document
