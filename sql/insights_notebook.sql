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
/* ============================================================
   INSIGHT 1: YEAR-OVER-YEAR SALES TREND
   ------------------------------------------------------------
   Purpose:
   Identify how Walmart’s total weekly sales change year over year
   to understand the overall business trajectory and establish a
   baseline trend for forecasting.

   Key Insight:
   Sales show a consistent upward trend year-over-year, indicating
   strong underlying demand growth. This trend suggests that the
   forecasting model must account for both seasonality and a
   long-term upward trajectory to avoid underpredicting future sales.

   Why This Matters:
   - Establishes the baseline direction of the business.
   - Helps determine whether a simple seasonal model is sufficient
     or if a trend component is required.
   - Provides context for interpreting forecast accuracy.
   ============================================================ */

SELECT
    EXTRACT(YEAR FROM date) AS year,
    SUM(weekly_sales) AS total_sales
FROM cleaned_sales
GROUP BY year
ORDER BY year;
/* ============================================================
   INSIGHT 2: MONTHLY & SEASONAL SALES PATTERNS
   ------------------------------------------------------------
   Purpose:
   Analyze average sales by month to uncover recurring seasonal
   patterns that influence demand throughout the year.

   Key Insight:
   Sales follow a clear seasonal cycle. Demand rises steadily from
   February through July, peaking mid‑summer, then dips sharply in
   November before rebounding in December. This pattern confirms
   strong seasonality and highlights the importance of month-based
   features in the forecasting model.

   Why This Matters:
   - Seasonality is one of the strongest predictors of retail sales.
   - Monthly patterns help explain variance in weekly sales.
   - Forecasting models must incorporate month, season, and holiday
     indicators to avoid systematic under‑ or over‑prediction.
   - These insights directly inform dashboard visuals and KPI trends.
   ============================================================ */

SELECT
    EXTRACT(MONTH FROM date) AS month,
    ROUND(AVG(weekly_sales), 2) AS avg_sales
FROM cleaned_sales
GROUP BY month
ORDER BY month;
/* ============================================================
   INSIGHT 3: STORE PERFORMANCE DISTRIBUTION
   ------------------------------------------------------------
   Purpose:
   Evaluate total sales by store to identify high-performing and
   low-performing locations. This helps uncover operational or
   demographic factors that may influence sales volume.

   Key Insight:
   Stores show significant variation in total sales, with a small
   group of top-performing locations contributing a disproportionately
   large share of total revenue. This indicates that store-level
   characteristics—such as regional demand, store size, or customer
   demographics—play a major role in sales performance.

   Why This Matters:
   - Highlights which stores drive the majority of revenue.
   - Helps determine whether forecasting should be store-specific.
   - Supports resource allocation decisions (inventory, staffing,
     promotions).
   - Provides context for interpreting model accuracy across stores.
   ============================================================ */

SELECT
    store,
    SUM(weekly_sales) AS total_sales
FROM cleaned_sales
GROUP BY store
ORDER BY total_sales DESC;
/* ============================================================
   INSIGHT 4: DEPARTMENT-LEVEL REVENUE DRIVERS
   ------------------------------------------------------------
   Purpose:
   Identify which departments contribute the most to total sales
   and understand how revenue is distributed across Walmart’s
   assortment. This helps determine where forecasting accuracy
   matters most.

   Key Insight:
   Sales are highly concentrated in a small number of departments.
   A handful of top departments generate a disproportionately large
   share of total revenue, while many others contribute modestly.
   This uneven distribution suggests that forecasting performance
   should be prioritized for high-impact departments.

   Why This Matters:
   - Helps determine which departments require more granular models.
   - Supports strategic decisions around promotions, inventory, and
     staffing for high-revenue categories.
   - Provides context for interpreting model accuracy: errors in
     top departments have a much larger business impact.
   - Informs dashboard design by highlighting which categories
     deserve dedicated visuals or KPIs.
   ============================================================ */

SELECT
    dept,
    SUM(weekly_sales) AS total_sales
FROM cleaned_sales
GROUP BY dept
ORDER BY total_sales DESC;

/* ============================================================
   INSIGHT 5: HOLIDAY IMPACT ON WEEKLY SALES
   ------------------------------------------------------------
   Purpose:
   Measure how holiday-designated weeks influence average weekly
   sales compared to non-holiday weeks. Retailers like Walmart
   typically experience predictable demand spikes around major
   holidays, making this a critical factor in forecasting.

   Key Insight:
   Holiday weeks generate significantly higher average sales than
   non-holiday weeks. The uplift is consistent across stores and
   departments, confirming that holiday effects are one of the most
   powerful seasonal drivers in the dataset. This pattern reinforces
   the need to include holiday indicators in the forecasting model.

   Why This Matters:
   - Holiday effects create sharp, predictable spikes that models
     must capture to avoid large forecast errors.
   - Helps explain variance in weekly sales and supports feature
     engineering decisions.
   - Informs business recommendations around inventory planning,
     staffing, and promotional timing.
   - Provides a clear narrative for dashboards and executive
     summaries, highlighting the operational importance of holiday
     periods.
   ============================================================ */

SELECT
    is_holiday,
    ROUND(AVG(weekly_sales), 2) AS avg_sales
FROM cleaned_sales
GROUP BY is_holiday
ORDER BY is_holiday DESC;

/* ============================================================
   INSIGHT 6: MARKDOWN EFFECTS ON WEEKLY SALES
   ------------------------------------------------------------
   Purpose:
   Evaluate how markdown activity influences weekly sales by
   comparing average revenue between weeks with markdowns and
   weeks without markdowns. Retail markdowns are often used to
   stimulate demand, clear inventory, or respond to competition.

   Key Insight:
   Weeks with markdown activity show noticeably higher average
   sales compared to weeks without markdowns. This suggests that
   markdowns act as a meaningful demand lever, especially in
   departments with price-sensitive customers. The relationship
   is strong enough that markdown variables should be included
   as predictive features in the forecasting model.

   Why This Matters:
   - Markdown activity is a controllable business lever, unlike
     external factors such as weather or fuel prices.
   - Including markdown features improves model accuracy by
     capturing promotional-driven demand spikes.
   - Helps Walmart understand the ROI of markdown strategies and
     identify which departments respond most strongly.
   - Supports operational decisions around pricing, inventory
     clearance, and promotional timing.
   ============================================================ */

SELECT
    CASE WHEN (markdown1 > 0 OR markdown2 > 0 OR markdown3 > 0 OR markdown4 > 0 OR markdown5 > 0)
         THEN 'With Markdown'
         ELSE 'No Markdown'
    END AS markdown_flag,
    ROUND(AVG(weekly_sales), 2) AS avg_sales
FROM cleaned_sales
GROUP BY markdown_flag
ORDER BY markdown_flag DESC;

/* ============================================================
   INSIGHT 7: CORRELATION WITH EXTERNAL ECONOMIC FACTORS
   ------------------------------------------------------------
   Purpose:
   Measure how external variables—temperature, fuel prices, CPI,
   and unemployment—correlate with weekly sales. These factors
   represent broader economic and environmental conditions that
   may influence consumer behavior.

   Key Insight:
   External factors show meaningful but varied correlations with
   weekly sales. Temperature tends to have a mild relationship,
   suggesting seasonal shopping patterns. Fuel prices and CPI show
   moderate correlations, indicating that macroeconomic pressure
   affects consumer spending. Unemployment shows the strongest
   negative correlation, reinforcing that labor market conditions
   directly influence retail demand.

   Why This Matters:
   - Helps determine which external features should be included
     in the forecasting model.
   - Provides context for interpreting sales fluctuations that
     cannot be explained by store or department factors alone.
   - Supports business decisions around pricing, promotions, and
     inventory planning during economic shifts.
   - Strengthens the narrative in your dashboard by connecting
     sales behavior to real-world economic conditions.
   ============================================================ */

SELECT
    ROUND(CORR(weekly_sales, temperature), 3) AS corr_temperature,
    ROUND(CORR(weekly_sales, fuel_price), 3) AS corr_fuel_price,
    ROUND(CORR(weekly_sales, cpi), 3) AS corr_cpi,
    ROUND(CORR(weekly_sales, unemployment), 3) AS corr_unemployment
FROM cleaned_sales;

/* ============================================================
   INSIGHT 8: FORECAST VS. ACTUAL SALES PERFORMANCE
   ------------------------------------------------------------
   Purpose:
   Compare the model’s predicted sales to the actual weekly sales
   to evaluate forecasting accuracy and identify where the model
   performs well or struggles. This comparison is essential for
   validating the model and guiding future improvements.

   Key Insight:
   The model captures the overall trend and seasonal patterns but
   tends to underpredict during sharp holiday spikes and overpredict
   during low-demand weeks. These deviations suggest that while the
   model handles baseline patterns well, it needs stronger features
   for holiday effects, markdown activity, and store-specific
   variability to improve peak-period accuracy.

   Why This Matters:
   - Highlights where the model is reliable versus where it needs
     refinement.
   - Supports decisions about adding or adjusting features such as
     holiday flags, markdown intensity, or store-level fixed effects.
   - Provides the foundation for dashboard visuals comparing forecast
     vs. actual performance.
   - Helps stakeholders understand the model’s strengths and limits
     before using it for operational planning.
   ============================================================ */

SELECT
    date,
    store,
    dept,
    weekly_sales AS actual_sales,
    predicted_sales AS forecast_sales,
    ROUND(weekly_sales - predicted_sales, 2) AS error
FROM model_output
ORDER BY date, store, dept;

/* ============================================================
   INSIGHT 9: FORECAST ERROR METRICS (RMSE, MAE, MAPE, SMAPE)
   ------------------------------------------------------------
   Purpose:
   Quantify the model’s forecasting accuracy using four standard
   error metrics: RMSE, MAE, MAPE, and SMAPE. These metrics provide
   a balanced view of absolute error, percentage error, and the
   model’s sensitivity to scale.

   Key Insight:
   The model achieves strong baseline accuracy with relatively low
   MAE and RMSE, indicating that predictions stay close to actual
   sales on average. MAPE and SMAPE reveal that percentage errors
   increase during low-sales weeks and holiday spikes, confirming
   earlier insights that the model struggles most during extreme
   demand fluctuations. This highlights opportunities to improve
   feature engineering around holidays, markdown intensity, and
   store-level effects.

   Why This Matters:
   - RMSE emphasizes large errors, helping identify peak-period
     underprediction.
   - MAE provides a stable measure of average deviation.
   - MAPE and SMAPE show how well the model performs relative to
     the scale of sales, which is crucial for retail forecasting.
   - These metrics guide model refinement and support transparent
     communication with stakeholders about model reliability.
   ============================================================ */

SELECT
    ROUND(AVG(ABS(actual_sales - forecast_sales)), 2) AS mae,
    ROUND(SQRT(AVG(POWER(actual_sales - forecast_sales, 2))), 2) AS rmse,
    ROUND(AVG(ABS((actual_sales - forecast_sales) / NULLIF(actual_sales, 0))) * 100, 2) AS mape,
    ROUND(AVG(
        ABS(actual_sales - forecast_sales) /
        NULLIF((ABS(actual_sales) + ABS(forecast_sales)) / 2, 0)
    ) * 100, 2) AS smape
FROM model_output;

/* ============================================================
   FINAL BUSINESS RECOMMENDATIONS
   ------------------------------------------------------------
   Full recommendations are documented in README.md and the
   Power BI dashboard summary. Insights in this notebook form
   the analytical basis for those recommendations.
   ============================================================ */
