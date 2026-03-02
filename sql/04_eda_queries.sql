-- =====================================================================
-- Walmart Sales Forecasting Project
-- 04_eda.sql
-- Author: Waldo Ketonou | WaldoSphere Group LLC
-- Purpose: Exploratory Data Analysis on walmart_master_fe_final
-- =====================================================================


-- 1. BASIC ROW COUNT
SELECT COUNT(*) AS total_rows
FROM walmart_master_fe_final;



-- 2. SUMMARY STATISTICS FOR WEEKLY SALES
SELECT
    MIN(weekly_sales) AS min_sales,
    MAX(weekly_sales) AS max_sales,
    AVG(weekly_sales) AS avg_sales,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY weekly_sales) AS median_sales,
    STDDEV(weekly_sales) AS stddev_sales
FROM walmart_master_fe_final;



-- 3. SALES DISTRIBUTION BY STORE
SELECT
    store_id,
    COUNT(*) AS row_count,
    AVG(weekly_sales) AS avg_sales,
    MIN(weekly_sales) AS min_sales,
    MAX(weekly_sales) AS max_sales
FROM walmart_master_fe_final
GROUP BY store_id
ORDER BY store_id;



-- 4. SALES DISTRIBUTION BY DEPARTMENT
SELECT
    dept_id,
    COUNT(*) AS row_count,
    AVG(weekly_sales) AS avg_sales,
    MIN(weekly_sales) AS min_sales,
    MAX(weekly_sales) AS max_sales
FROM walmart_master_fe_final
GROUP BY dept_id
ORDER BY dept_id;



-- 5. HOLIDAY VS NON-HOLIDAY SALES
SELECT
    holiday_flag,
    COUNT(*) AS row_count,
    AVG(weekly_sales) AS avg_sales,
    MIN(weekly_sales) AS min_sales,
    MAX(weekly_sales) AS max_sales
FROM walmart_master_fe_final
GROUP BY holiday_flag
ORDER BY holiday_flag;



-- 6. MONTHLY SALES TRENDS
SELECT
    year,
    month,
    AVG(weekly_sales) AS avg_monthly_sales
FROM walmart_master_fe_final
GROUP BY year, month
ORDER BY year, month;



-- 7. WEEKLY SALES TRENDS
SELECT
    year,
    week,
    AVG(weekly_sales) AS avg_weekly_sales
FROM walmart_master_fe_final
GROUP BY year, week
ORDER BY year, week;



-- 8. STORE + DEPARTMENT COMBINED PERFORMANCE
SELECT
    store_id,
    dept_id,
    AVG(weekly_sales) AS avg_sales
FROM walmart_master_fe_final
GROUP BY store_id, dept_id
ORDER BY store_id, dept_id;



-- 9. CORRELATION CHECK BETWEEN FEATURES
-- PostgreSQL CORR() function used for numeric relationships

SELECT
    CORR(weekly_sales, lag_1) AS corr_sales_lag1,
    CORR(weekly_sales, lag_2) AS corr_sales_lag2,
    CORR(weekly_sales, lag_3) AS corr_sales_lag3,
    CORR(weekly_sales, roll_avg_3) AS corr_sales_roll3,
    CORR(weekly_sales, roll_avg_5) AS corr_sales_roll5
FROM walmart_master_fe_final;



-- 10. YEARLY SALES SUMMARY
SELECT
    year,
    SUM(weekly_sales) AS total_sales,
    AVG(weekly_sales) AS avg_sales
FROM walmart_master_fe_final
GROUP BY year
ORDER BY year;

-- =====================================================================
-- END OF EDA SCRIPT
-- =====================================================================
