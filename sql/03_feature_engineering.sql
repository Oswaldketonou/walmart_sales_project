-- =====================================================================
-- Walmart Sales Forecasting Project
-- 03_feature_engineering.sql
-- Author: Waldo Ketonou | WaldoSphere Group LLC
-- Purpose: Create engineered features for modeling
-- =====================================================================


-- 1. CREATE BASE TABLE FROM CLEAN SALES DATA
-- This ensures we start from the cleaned dataset

CREATE TABLE walmart_master_fe AS
SELECT
    store_id,
    dept_id,
    date,
    weekly_sales,
    holiday_flag
FROM walmart_sales_clean
ORDER BY store_id, dept_id, date;



-- 2. ADD DATE-BASED FEATURES
-- Extracts year, month, week, and day for seasonality patterns

ALTER TABLE walmart_master_fe
ADD COLUMN year INT,
ADD COLUMN month INT,
ADD COLUMN week INT;

UPDATE walmart_master_fe
SET
    year = EXTRACT(YEAR FROM date),
    month = EXTRACT(MONTH FROM date),
    week = EXTRACT(WEEK FROM date);



-- 3. ADD LAG FEATURES
-- Lag 1, 2, and 3 weeks of sales for forecasting

ALTER TABLE walmart_master_fe
ADD COLUMN lag_1 NUMERIC,
ADD COLUMN lag_2 NUMERIC,
ADD COLUMN lag_3 NUMERIC;

UPDATE walmart_master_fe fe
SET lag_1 = sub.lag_1,
    lag_2 = sub.lag_2,
    lag_3 = sub.lag_3
FROM (
    SELECT
        store_id,
        dept_id,
        date,
        LAG(weekly_sales, 1) OVER (PARTITION BY store_id, dept_id ORDER BY date) AS lag_1,
        LAG(weekly_sales, 2) OVER (PARTITION BY store_id, dept_id ORDER BY date) AS lag_2,
        LAG(weekly_sales, 3) OVER (PARTITION BY store_id, dept_id ORDER BY date) AS lag_3
    FROM walmart_master_fe
) sub
WHERE fe.store_id = sub.store_id
  AND fe.dept_id = sub.dept_id
  AND fe.date = sub.date;



-- 4. ADD ROLLING AVERAGE FEATURES
-- 3-week and 5-week rolling averages

ALTER TABLE walmart_master_fe
ADD COLUMN roll_avg_3 NUMERIC,
ADD COLUMN roll_avg_5 NUMERIC;

UPDATE walmart_master_fe fe
SET roll_avg_3 = sub.roll_avg_3,
    roll_avg_5 = sub.roll_avg_5
FROM (
    SELECT
        store_id,
        dept_id,
        date,
        AVG(weekly_sales) OVER (
            PARTITION BY store_id, dept_id
            ORDER BY date
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ) AS roll_avg_3,
        AVG(weekly_sales) OVER (
            PARTITION BY store_id, dept_id
            ORDER BY date
            ROWS BETWEEN 4 PRECEDING AND CURRENT ROW
        ) AS roll_avg_5
    FROM walmart_master_fe
) sub
WHERE fe.store_id = sub.store_id
  AND fe.dept_id = sub.dept_id
  AND fe.date = sub.date;



-- 5. FINAL CLEAN FEATURE TABLE
-- Removes rows where lag/rolling features are NULL (first few weeks)

CREATE TABLE walmart_master_fe_final AS
SELECT *
FROM walmart_master_fe
WHERE lag_3 IS NOT NULL
  AND roll_avg_5 IS NOT NULL
ORDER BY store_id, dept_id, date;

-- =====================================================================
-- END OF FEATURE ENGINEERING SCRIPT
-- =====================================================================
