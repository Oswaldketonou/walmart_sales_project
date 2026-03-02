-- =====================================================================
-- Walmart Sales Forecasting Project
-- 02_data_cleaning.sql
-- Author: Waldo Ketonou | WaldoSphere Group LLC
-- Purpose: Clean raw walmart_sales table before feature engineering
-- =====================================================================


-- 1. STANDARDIZE COLUMN NAMES
-- (Skip any line if your column is already correct)

ALTER TABLE walmart_sales RENAME COLUMN Store TO store_id;
ALTER TABLE walmart_sales RENAME COLUMN Dept TO dept_id;
ALTER TABLE walmart_sales RENAME COLUMN Date TO date;
ALTER TABLE walmart_sales RENAME COLUMN Weekly_Sales TO weekly_sales;
ALTER TABLE walmart_sales RENAME COLUMN IsHoliday TO holiday_flag;



-- 2. REMOVE DUPLICATE ROWS
-- Uses PostgreSQL ctid method to delete duplicates based on store_id, dept_id, date

DELETE FROM walmart_sales a
USING walmart_sales b
WHERE a.ctid < b.ctid
  AND a.store_id = b.store_id
  AND a.dept_id = b.dept_id
  AND a.date = b.date;



-- 3. REMOVE ROWS WITH MISSING KEY VALUES
-- Ensures no NULLs in required fields

DELETE FROM walmart_sales
WHERE store_id IS NULL
   OR dept_id IS NULL
   OR date IS NULL
   OR weekly_sales IS NULL;



-- 4. CONVERT DATE COLUMN TO PROPER DATE TYPE
-- Converts text dates to DATE format (PostgreSQL will ignore if already DATE)

UPDATE walmart_sales
SET date = TO_DATE(date, 'YYYY-MM-DD')
WHERE date IS NOT NULL;



-- 5. ENSURE WEEKLY_SALES IS NUMERIC
-- Converts weekly_sales to NUMERIC using PostgreSQL casting

ALTER TABLE walmart_sales
ALTER COLUMN weekly_sales TYPE NUMERIC
USING weekly_sales::NUMERIC;



-- 6. CREATE CLEAN VERSION OF THE TABLE
-- Final cleaned dataset for analysis, EDA, and modeling

CREATE TABLE walmart_sales_clean AS
SELECT
    store_id,
    dept_id,
    date,
    weekly_sales,
    holiday_flag
FROM walmart_sales
ORDER BY store_id, dept_id, date;

-- =====================================================================
-- END OF DATA CLEANING SCRIPT
-- =====================================================================
