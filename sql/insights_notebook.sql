/* ============================================================
   INSIGHTS NOTEBOOK – Walmart Sales Forecasting Project
   Author: Waldo Ketonou
   Purpose: Store insight-driven SQL queries and commentary
   ============================================================ */

/* ------------------------------------------------------------
   1. Yearly Sales Trends
   ------------------------------------------------------------ */

-- Insight: Identify how total sales change year over year.
-- Why it matters: Establishes baseline trend and helps explain
-- model behavior and forecasting difficulty.

SELECT
    EXTRACT(YEAR FROM date) AS year,
    SUM(weekly_sales) AS total_sales
FROM cleaned_sales
GROUP BY year
ORDER BY year;


/* ------------------------------------------------------------
   2. Monthly / Seasonal Patterns
   ------------------------------------------------------------ */

-- Insight: Detect seasonality and recurring spikes/dips.
-- Why it matters: Seasonality is a major driver in forecasting.

SELECT
    EXTRACT(MONTH FROM date) AS month,
    AVG(weekly_sales) AS avg_sales
FROM cleaned_sales
GROUP BY month
ORDER BY month;


/* ------------------------------------------------------------
   3. Store Performance Distribution
   ------------------------------------------------------------ */

-- Insight: Which stores consistently outperform or underperform?
-- Why it matters: Helps identify operational differences.

SELECT
    store,
    SUM(weekly_sales) AS total_sales
FROM cleaned_sales
GROUP BY store
ORDER BY total_sales DESC;


/* ------------------------------------------------------------
   4. Department-Level Drivers
   ------------------------------------------------------------ */

-- Insight: Which departments contribute most to revenue?
-- Why it matters: Useful for forecasting granularity decisions.

SELECT
    dept,
    SUM(weekly_sales) AS total_sales
FROM cleaned_sales
GROUP BY dept
ORDER BY total_sales DESC;


/* ------------------------------------------------------------
   5. Impact of Holidays
   ------------------------------------------------------------ */

-- Insight: Quantify how holiday weeks affect sales.
-- Why it matters: Holidays create predictable spikes.

SELECT
    is_holiday,
    AVG(weekly_sales) AS avg_sales
FROM cleaned_sales
GROUP BY is_holiday;


/* ------------------------------------------------------------
   6. Markdown Effects
   ------------------------------------------------------------ */

-- Insight: Do markdowns increase or decrease sales?
-- Why it matters: Markdown variables are key model features.

SELECT
    CASE WHEN markdown1 > 0 THEN 'With Markdown' ELSE 'No Markdown' END AS markdown_flag,
    AVG(weekly_sales) AS avg_sales
FROM cleaned_sales
GROUP BY markdown_flag;


/* ------------------------------------------------------------
   7. Temperature / Fuel / CPI / Unemployment Correlations
   ------------------------------------------------------------ */

-- Insight: Explore external factors that may influence sales.
-- Why it matters: Helps justify feature engineering choices.

SELECT
    ROUND(CORR(weekly_sales, temperature), 3) AS corr_temp,
    ROUND(CORR(weekly_sales, fuel_price), 3) AS corr_fuel,
    ROUND(CORR(weekly_sales, cpi), 3) AS corr_cpi,
    ROUND(CORR(weekly_sales, unemployment), 3) AS corr_unemp
FROM cleaned_sales;


/* ------------------------------------------------------------
   8. Forecast vs Actual (after modeling is complete)
   ------------------------------------------------------------ */

-- Insight: Compare model predictions to actual sales.
-- Why it matters: Supports evaluation and dashboard visuals.

SELECT
    date,
    store,
    dept,
    weekly_sales AS actual,
    predicted_sales AS forecast
FROM model_output
ORDER BY date, store, dept;

