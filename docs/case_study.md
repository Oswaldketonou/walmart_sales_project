<!-- ========================= -->
<!--        TITLE PAGE         -->
<!-- ========================= -->

# Walmart Sales Forecasting & Analytics Case Study
### End-to-End SQL Analysis Using Walmart Weekly Sales Data

**Author:** Waldo KETONOU  
**Tools:** PostgreSQL, SQL, GitHub  
**Dataset Size:** 420,000+ weekly sales records  
**Stores:** 45  
**Departments:** 99  

---

<div style="page-break-after: always;"></div>

# 1. Introduction

Walmart operates one of the largest retail networks in the United States, with weekly sales influenced by seasonality, holidays, markdowns, weather, and economic conditions.  
This case study analyzes over 420,000 weekly sales records across 45 stores and 99 departments using SQL to uncover business insights and prepare the foundation for forecasting.

Objectives:

- Understand what drives weekly sales  
- Identify top-performing stores and departments  
- Quantify the impact of holidays and markdowns  
- Evaluate the influence of weather and economic conditions  
- Engineer features for forecasting  
- Define KPIs for model evaluation and business interpretation  

All analysis was performed in PostgreSQL.

---

<div style="page-break-after: always;"></div>

# 2. Data Sources

The project uses three raw datasets:

- **stores.csv** — store metadata  
- **features.csv** — weather, fuel price, CPI, unemployment, markdowns  
- **train.csv** — weekly sales by store and department  

These datasets were cleaned, validated, and merged into:

- `walmart_master` — unified dataset  
- `walmart_master_fe` — feature-engineered dataset  

---

# 3. Data Cleaning & Validation

## 3.1 Missing Values
- Imputed missing markdown values  
- Filled missing CPI and unemployment using median values  
- Forward-filled temperature gaps  
- Standardized date formats  

## 3.2 Data Type Corrections
- Converted numeric columns  
- Ensured consistent store/department keys  
- Validated row counts and duplicates  

## 3.3 Dataset Integration
Datasets were joined using:
store -> department -> date

This produced a unified analytical dataset ready for feature engineering and EDA.

---

<div style="page-break-after: always;"></div>

# 4. Feature Engineering

To support deeper analysis and forecasting, the following features were created:

- year, month, week  
- is_holiday (binary flag)  
- season (Winter, Spring, Summer, Fall)  
- markdown_total (sum of all markdowns)  
- lagged_sales (previous week’s sales)  
- rolling averages (optional future step)  

These engineered features improved interpretability and model readiness.

---

# 5. Exploratory Data Analysis (EDA)

All EDA was performed using SQL queries in PostgreSQL.

## 5.1 Yearly Sales Trends
- 2010 → 2011: +7% growth  
- 2011 → 2012: –18% decline  

## 5.2 Holiday Impact
Holiday weeks show a 7.1% lift in weekly sales:

- Non-holiday avg: 15,901  
- Holiday avg: 17,036  

## 5.3 Store Performance
Store 20 is the top performer, followed by Stores 4, 14, and 2.

## 5.4 Department Performance
Departments 92 and 95 dominate revenue, generating nearly $1B combined.

## 5.5 Markdown Impact

| Markdown  | Correlation |
|-----------|-------------|
| Markdown1 | 0.0472      |
| Markdown2 | 0.0207      |
| Markdown3 | 0.0386      |
| Markdown4 | 0.0375      |
| Markdown5 | 0.0505      |

Markdowns have a small but positive effect on sales.

## 5.6 Weather & Economic Impact

| Feature      | Correlation |
|--------------|-------------|
| Temperature  | –0.0023     |
| Fuel Price   | –0.0001     |
| CPI          | –0.0209     |
| Unemployment | –0.0259     |

Weather and economic variables show minimal influence on weekly sales.

---

<div style="page-break-after: always;"></div>

# 6. Key Insights

1. **Sales Are Highly Seasonal**  
   Holiday periods significantly boost demand.

2. **A Few Departments Drive Most Revenue**  
   Departments 92 and 95 generate nearly $1B combined.

3. **Store Performance Varies Widely**  
   Store 20 consistently outperforms others.

4. **Markdown Promotions Help, but Modestly**  
   Correlations are positive but small.

5. **Weather Has No Meaningful Impact**  
   Temperature and fuel price correlations are near zero.

6. **Economic Conditions Have Minimal Short-Term Influence**  
   CPI and unemployment show slight negative correlations.

7. **Year-Over-Year Trends Reveal a Shift**  
   The sharp decline in 2012 suggests structural or macroeconomic changes.

8. **Engineered Features Improve Interpretability**  
   Seasonality, holiday flags, markdown totals, and lagged sales provide strong predictive signals.

---

# 7. KPI Summary

## Forecasting KPIs
- Mean Absolute Error (MAE)  
- Mean Absolute Percentage Error (MAPE)  
- Root Mean Squared Error (RMSE)  
- R²  

## Business KPIs
- Year-over-Year Growth  
- Holiday Sales Lift  
- Markdown Impact  
- Top Stores  
- Top Departments  
- Weather/Economic Influence  

---

<div style="page-break-after: always;"></div>

# 8. Recommendations

1. Strengthen holiday inventory and staffing.  
2. Prioritize high-impact departments (92 and 95).  
3. Optimize markdown strategy with targeted promotions.  
4. De-prioritize weather in forecasting models.  
5. Build models using high-signal features such as lagged sales, seasonality, and markdown totals.

---

## 9. Next Steps

With the baseline model established, the next phase of the project focuses on building progressively stronger forecasting models and evaluating their performance against the baseline benchmark.

**Upcoming tasks include:**

- Developing forecasting models, starting with linear regression and advancing to regularized and tree‑based methods  
- Evaluating each model using MAE, MAPE, RMSE, and R²  
- Comparing model performance against the baseline to determine meaningful improvement  
- Integrating the best‑performing model into the analytics workflow  
- Designing and deploying a dashboard to visualize KPIs, model performance, and business insights  

---

## Baseline Model Results

The baseline model uses the previous week’s sales as the prediction for the current week.  
This provides a simple but essential benchmark for evaluating more advanced models.

**Baseline Performance:**

- **MAE:** _X_  
- **MAPE:** _X%_  
- **RMSE:** _X_  
- **R²:** _X_  

These values represent the minimum performance that future models must exceed to be considered effective.  
A model that does not outperform the baseline does not add predictive value.

---

## 10. Conclusion

The baseline model establishes a strong foundation for the forecasting workflow.  
With this benchmark in place, the next steps will focus on developing and evaluating more sophisticated models to improve predictive accuracy and support data‑driven decision‑making.


