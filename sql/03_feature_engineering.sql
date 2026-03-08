/* ============================================================
   03_feature_engineering.sql
   Walmart Weekly Sales Forecasting
   Author: Waldo Ketonou
   Purpose: Create modeling-ready feature table aligned with R scripts
   ============================================================ */

-- 1. Create feature-engineered table
DROP TABLE IF EXISTS walmart_master_fe;
CREATE TABLE walmart_master_fe AS
WITH base AS (
    SELECT
        wm.store,
        wm.dept,
        wm.date,
        wm.weekly_sales AS actual_sales,

        /* ============================
           TIME FEATURES
        ============================ */
        EXTRACT(YEAR  FROM wm.date) AS year,
        EXTRACT(MONTH FROM wm.date) AS month,
        EXTRACT(WEEK  FROM wm.date) AS week,

        CASE 
            WHEN f.is_holiday = 1 THEN 1 
            ELSE 0 
        END AS feature_is_holiday,

        /* ============================
           MARKDOWN FEATURES
        ============================ */
        COALESCE(f.markdown1, 0) +
        COALESCE(f.markdown2, 0) +
        COALESCE(f.markdown3, 0) +
        COALESCE(f.markdown4, 0) +
        COALESCE(f.markdown5, 0) AS markdown_total,

        /* ============================
           EXTERNAL FEATURES
        ============================ */
        f.temperature,
        f.fuel_price,
        f.cpi,
        f.unemployment

    FROM walmart_master wm
    LEFT JOIN features_clean f
        ON wm.store = f.store
       AND wm.date  = f.date
)

SELECT
    *,
    
    /* ============================
       LAG FEATURES (MATCH R SCRIPT)
       ============================ */
    LAG(actual_sales, 1) OVER (
        PARTITION BY store, dept
        ORDER BY date
    ) AS lag_1_week,

    /* ============================
       ROLLING FEATURES (MATCH R SCRIPT)
       ============================ */
    AVG(actual_sales) OVER (
        PARTITION BY store, dept
        ORDER BY date
        ROWS BETWEEN 3 PRECEDING AND 1 PRECEDING
    ) AS rolling_mean_3,

    AVG(actual_sales) OVER (
        PARTITION BY store, dept
        ORDER BY date
        ROWS BETWEEN 5 PRECEDING AND 1 PRECEDING
    ) AS rolling_mean_5

FROM base
ORDER BY store, dept, date;
