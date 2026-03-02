-- =====================================================================
-- Walmart Sales Forecasting Project
-- 03_feature_engineering.sql
-- Author: Waldo Ketonou | WaldoSphere Group LLC
-- Purpose: Create feature-engineered dataset for modeling
-- Notes: This reflects the exact workflow used in PostgreSQL
-- =====================================================================


/*
    Create a feature-engineered materialized view.
    This combines:
      - Lag features (1-week, 4-week)
      - Rolling averages (4-week, 12-week)
      - Holiday indicator
      - Weather & economic data
      - Store metadata
      - Date-based features (week, month, year)
    Source tables:
      walmart_master (cleaned sales)
      features_clean (weather/economic)
      store_clean (store metadata)
*/

CREATE MATERIALIZED VIEW walmart_master_fe AS
SELECT
    -- Core identifiers
    wm.store,
    wm.dept,
    wm.date,
    wm.weekly_sales,

    /* 
       Lag Features
       ---------------------------------------------------------------
       lag_1_week  = previous week's sales
       lag_4_weeks = sales from 4 weeks prior
       --------------------------------------------------------------- */
    LAG(wm.weekly_sales, 1) OVER (
        PARTITION BY wm.store, wm.dept
        ORDER BY wm.date
    ) AS lag_1_week,

    LAG(wm.weekly_sales, 4) OVER (
        PARTITION BY wm.store, wm.dept
        ORDER BY wm.date
    ) AS lag_4_weeks,

    /* 
       Rolling Averages
       ---------------------------------------------------------------
       rolling_4_week  = average of current + previous 3 weeks
       rolling_12_week = average of current + previous 11 weeks
       --------------------------------------------------------------- */
    AVG(wm.weekly_sales) OVER (
        PARTITION BY wm.store, wm.dept
        ORDER BY wm.date
        ROWS BETWEEN 3 PRECEDING AND CURRENT ROW
    ) AS rolling_4_week,

    AVG(wm.weekly_sales) OVER (
        PARTITION BY wm.store, wm.dept
        ORDER BY wm.date
        ROWS BETWEEN 11 PRECEDING AND CURRENT ROW
    ) AS rolling_12_week,

    /* 
       Holiday Flag
       --------------------------------------------------------------- */
    wm.feature_is_holiday,

    /* ---------------------------------------------------------------
       Weather & Economic Features
       --------------------------------------------------------------- */
    f.temperature,
    f.fuel_price,
    f.cpi,
    f.unemployment,

    /* ---------------------------------------------------------------
       Store Metadata
       --------------------------------------------------------------- */
    wm.store_type,
    wm.store_size,

    /* ---------------------------------------------------------------
       Date Features
       --------------------------------------------------------------- */
    EXTRACT(WEEK FROM wm.date) AS week,
    EXTRACT(MONTH FROM wm.date) AS month,
    EXTRACT(YEAR FROM wm.date) AS year

FROM walmart_master AS wm
LEFT JOIN features_clean AS f
    ON wm.date = f.date
LEFT JOIN store_clean AS s
    ON wm.store = s.store;

-- =====================================================================
-- END OF FEATURE ENGINEERING SCRIPT
-- =====================================================================
