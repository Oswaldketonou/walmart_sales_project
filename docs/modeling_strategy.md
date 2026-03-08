<!-- ========================= -->
<!-- TITLE PAGE -->
<!-- ========================= -->

# Modeling Strategy  
### Walmart Weekly Sales Forecasting

**Author:** Waldo KETONOU  
**Tools:** PostgreSQL, SQL, R  
**Objective:** Forecast weekly sales at the store–department level  
**Document Type:** Modeling Strategy (PDF‑Optimized)

---

<div style="page-break-after: always;"></div>

# 1. Problem Framing

The objective of this modeling phase is to **forecast weekly sales at the store–department level** using Walmart’s historical retail dataset.  
This is a **panel time‑series regression problem**, where each store–department pair forms its own temporal sequence.

The model must capture:

- seasonality  
- holiday effects  
- markdown promotions  
- store and department structural differences  
- lagged sales patterns  
- nonlinear interactions  

The final model will support scenario simulation and dashboard integration.

---

# 2. Target Variable

### **Weekly_Sales**

A continuous numeric variable representing total sales for a given **store × department × week**.  
This is a **supervised regression task** with temporal dependencies.

---

# 3. Feature Engineering

The following engineered features will be used as predictors.

## 3.1 Time‑Based Features
- year  
- month  
- week  
- season  
- is_holiday  

## 3.2 Lag & Rolling Features
- lagged_sales_1 (previous week’s sales)  
- rolling_mean_3 (3‑week average)  
- rolling_mean_5 (5‑week average)  

These features capture short‑term momentum and stabilize volatility.

## 3.3 Markdown Features
- markdown_total  
- markdown_1–5  

Markdowns are sparse but meaningful during promotional periods.

## 3.4 Store & Department Identifiers
- store  
- dept  

These encode structural differences across locations and product categories.

## 3.5 External Features
- temperature  
- fuel_price  
- CPI  
- unemployment  

These variables have **weak but non‑zero** predictive value and are retained for completeness.

## 3.6 Interaction Features
To reflect real retail dynamics:

- store × dept  
- is_holiday × markdown_total  
- season × dept  

These interactions improve nonlinear capture, especially for tree‑based models.

---

# 4. Train/Test Split Strategy

A **chronological panel split** is used to prevent leakage:

- **Training:** 2010–2011  
- **Testing:** 2012  

Splits are performed **within each store–department group** to preserve temporal order.

---

# 5. Baseline Models

Baselines establish the minimum acceptable performance.

## 5.1 Naïve Lag Model


\[
\hat{y}_t = y_{t-1}
\]



## 5.2 Rolling Mean Baseline


\[
\hat{y}_t = \text{mean}(y_{t-3:t-1})
\]



All advanced models must outperform both baselines.

---

# 6. Candidate Models

These models align with the actual workflow and dataset structure.

## 6.1 Linear Regression
- interpretable  
- fast  
- strong structural baseline  

## 6.2 Regularized Linear Models
- Ridge  
- Lasso  
- Elastic Net  

Useful for multicollinearity and feature selection.

## 6.3 Tree‑Based Models
- Random Forest  
- Gradient Boosting  
- XGBoost  

These capture nonlinearities, interactions, and sparse markdown effects.

**Note:**  
ARIMA/SARIMA are intentionally excluded because they do not scale to panel data and cannot incorporate markdowns or external features effectively.

---

# 7. Evaluation Metrics

The following KPIs will be computed **per store–department** and **overall**:

- Mean Absolute Error (MAE)  
- Mean Absolute Percentage Error (MAPE)  
- Symmetric MAPE (SMAPE)  
- Root Mean Squared Error (RMSE)  
- R²  

### **Primary Business Metric: MAPE**  
Chosen for interpretability and comparability across departments.

### Additional Analysis
- error distribution plots  
- residual seasonality checks  
- department‑level performance variance  

---

# 8. Assumptions & Constraints

### Sales Drivers
- Seasonality and holidays strongly influence sales  
- Markdown effects are positive but vary by department  
- External variables (fuel, CPI, unemployment) have **weak but non‑zero** impact  

### Data Characteristics
- Non‑stationary across years  
- Sparse markdowns  
- Some store–department combinations have limited history  
- No future markdowns or holiday schedules beyond the dataset  

These constraints inform model selection and feature engineering.

---

# 9. Risks & Limitations

- Missing markdown and weather data  
- Structural changes in 2012 may reduce accuracy  
- Sparse departments may underperform  
- Holiday effects vary year‑to‑year  
- Markdown data lacks promotion context  

These risks will be mitigated through model comparison, regularization, and tree‑based methods.

---

# 10. Workflow & Next Steps

1. Build baseline models  
2. Train linear and regularized models  
3. Train tree‑based models  
4. Evaluate using MAE, MAPE, RMSE, R²  
5. Select best model based on MAPE + stability  
6. Generate scenario simulations (markdown, holiday, fuel price)  
7. Export predictions for dashboard integration  
8. Document results in the case study  

---
