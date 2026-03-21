-- =====================================================================
-- Walmart Sales Forecasting Project
-- 05_modeling.sql
-- Author: Waldo Ketonou | WaldoSphere Group
-- Purpose: Create clean modeling dataset for R modeling
-- Notes: This reflects the exact workflow used in PostgreSQL
-- =====================================================================


/*
    Create a clean modeling materialized view.
    This dataset includes:
      - Actual weekly sales
      - Lag features (1-week, 4-week)
      - Rolling averages (4-week, 12-week)
      - Holiday indicator
      - Weather & economic features
      - Store metadata
      - Date-based features (week, month, year)

    All modeling (lm, predict, RMSE, MAE, MAPE, SMAPE)
    is performed in R, not in SQL.
*/

CREATE MATERIALIZED VIEW modeling_clean AS
SELECT
    -- Core identifiers
    store,
    dept,
    date,
    weekly_sales AS actual_sales,

    /* Lag features */
    lag_1_week,
    lag_4_weeks,

    /* Rolling averages */
    rolling_4_week,
    rolling_12_week,

    /* Holiday flag */
    feature_is_holiday,

    /* Weather & economic features */
    temperature,
    fuel_price,
    cpi,
    unemployment,

    /* Store metadata */
    store_type,
    store_size,

    /* Date features */
    week,
    month,
    year

FROM walmart_master_fe
WHERE weekly_sales IS NOT NULL
  AND lag_1_week IS NOT NULL
  AND lag_4_weeks IS NOT NULL
  AND rolling_4_week IS NOT NULL
  AND rolling_12_week IS NOT NULL;

-- =====================================================================
-- END OF MODELING PREPARATION SCRIPT
-- =====================================================================
