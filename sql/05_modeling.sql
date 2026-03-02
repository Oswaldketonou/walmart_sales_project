-- =====================================================================
-- Walmart Sales Forecasting Project
-- 05_modeling.sql
-- Author: Waldo Ketonou | WaldoSphere Group LLC
-- Purpose: Create clean modeling dataset for R modeling
-- =====================================================================


/* 
   Creating a clean modeling table (materialized view)
   This table includes only the features used in the R modeling workflow.
   All modeling (lm, predict, RMSE, MAE, MAPE, SMAPE) is done in R.
*/

CREATE MATERIALIZED VIEW modeling_clean AS
SELECT
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

    /* Holiday */
    feature_is_holiday,

    /* Weather & economic */
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
