# 🛒 Walmart Sales Forecasting & Analytics Project  
End-to-end SQL + Analytics case study using Walmart weekly sales data.

---

# 📁 Project Structure

---

# 🎯 Project Overview

This project analyzes Walmart’s weekly sales across 45 stores and multiple departments to uncover:

- Key drivers of weekly sales  
- Store and department performance  
- Holiday and markdown impact  
- Weather and economic influence  
- Feature importance for forecasting  

The workflow includes data cleaning, feature engineering, EDA, KPI development, and business insights — all executed in PostgreSQL.

---

# 🧹 Data Cleaning & Preparation

### ✔ Missing Value Handling  
- Imputed markdowns  
- Filled missing temperature, CPI, and unemployment  
- Standardized date formats  

### ✔ Data Type Corrections  
- Converted numeric fields  
- Ensured consistent store/department keys  

### ✔ Dataset Integration  
Created unified tables:

- `walmart_master`  
- `walmart_master_fe` (feature engineered)

### ✔ Engineered Features  
- `year`, `month`, `week`  
- `is_holiday`  
- `season`  
- `markdown_total`  
- `lagged_sales`  

---

# 🔍 Exploratory Data Analysis (EDA)

### ⭐ Yearly Trends  
- 2010 → 2011: **+7% growth**  
- 2011 → 2012: **–18% decline**

### ⭐ Holiday Impact  
Holiday weeks show a **+7.1% lift** in weekly sales.

### ⭐ Top-Performing Stores  
Store **20** leads all stores in total revenue.

### ⭐ Top-Performing Departments  
Departments **92** and **95** generate nearly **$1B combined**.

### ⭐ Markdown Impact  
Markdown correlations with weekly sales:

- Markdown5: **+0.0505**  
- Markdown1: **+0.0472**

### ⭐ Weather & Economic Impact  
Minimal correlation:

- Temperature: –0.0023  
- Fuel price: –0.0001  
- CPI: –0.0209  
- Unemployment: –0.0259  

---

# 📊 Key Performance Indicators (KPIs)

## 🔵 Forecasting KPIs

### **Mean Absolute Error (MAE)**  
\[
MAE = \frac{1}{n} \sum |y - \hat{y}|
\]

---

### **Mean Absolute Percentage Error (MAPE)**  
\[
MAPE = \frac{100}{n} \sum \left| \frac{y - \hat{y}}{y} \right|
\]

---

### **Root Mean Squared Error (RMSE)**  
\[
RMSE = \sqrt{ \frac{1}{n} \sum (y - \hat{y})^2 }
\]

---

### **R² (Coefficient of Determination)**  
\[
R^2 = 1 - \frac{SS_{res}}{SS_{tot}}
\]

---

## 🟢 Business KPIs

### **Year-over-Year Growth (YoY)**  
\[
YoY = \frac{Sales_{current} - Sales_{previous}}{Sales_{previous}} \times 100
\]

---

### **Holiday Sales Lift**  
\[
Holiday\ Lift = \frac{Avg\ Holiday\ Sales - Avg\ NonHoliday\ Sales}{Avg\ NonHoliday\ Sales} \times 100
\]

---

### **Markdown Impact**  
Correlation between markdown activity and weekly sales.

---

### **Top Stores & Departments**  
Ranked by total revenue.

---

### **Weather & Economic Impact**  
Correlation analysis to determine external influence.

---

# 🧠 Insights Summary

- Sales are **highly seasonal**, with strong holiday performance.  
- Markdown promotions help, but the effect is **modest**.  
- Weather and economic variables have **minimal impact**.  
- A small number of departments drive the majority of revenue.  
- Store-level performance varies significantly across regions.

---

# 📈 Dashboard (Coming Soon)

The dashboard will include:

- KPI cards  
- Store performance map  
- Department revenue ranking  
- Markdown impact visualization  
- Seasonal trends  

---

# 🛠 Tools & Technologies

- PostgreSQL  
- SQL  
- Tableau / Power BI  
- GitHub  

---

# 👤 About the Analyst

Waldo KETONOU — Business/Data Analyst transitioning from 18+ years in retail operations management into analytics.  
Focused on SQL, dashboard design, and end-to-end analytics workflows.

---

# 🚀 Next Steps

- Build forecasting model  
- Add dashboard visualizations  
- Publish full case study  
- Add modeling results and performance KPIs  
