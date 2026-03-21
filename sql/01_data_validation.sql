-- Walmart Sales Forecasting: Data Validation Script
-- Author: Waldo Ketonou | WaldoSphere Group
-- Purpose: Validate schema, data types, nulls, and key constraints before cleaning

-- 1. Inspect table structure
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'walmart_sales';

-- 2. Count total rows
SELECT COUNT(*) AS total_rows
FROM walmart_sales;

-- 3. Check for NULLs in key columns
SELECT
  SUM(CASE WHEN store_id IS NULL THEN 1 ELSE 0 END) AS null_store_id,
  SUM(CASE WHEN dept_id IS NULL THEN 1 ELSE 0 END) AS null_dept_id,
  SUM(CASE WHEN date IS NULL THEN 1 ELSE 0 END) AS null_date,
  SUM(CASE WHEN weekly_sales IS NULL THEN 1 ELSE 0 END) AS null_weekly_sales
FROM walmart_sales;

-- 4. Validate date range
SELECT
  MIN(date) AS earliest_date,
  MAX(date) AS latest_date
FROM walmart_sales;
