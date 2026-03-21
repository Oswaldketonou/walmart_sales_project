# 📁 R Modeling & Evaluation Scripts

This folder contains all R scripts used for modeling, evaluation, visualization, feature importance analysis, and scenario simulation in the **Walmart Sales Forecasting Project**. These scripts operate on the modeling dataset created in PostgreSQL (`modeling_clean`) and represent the full machine‑learning workflow performed outside the database.

The SQL pipeline ends with the creation of the modeling dataset.  
All statistical modeling, predictions, metrics, visualizations, and simulations are performed in R.

---

## 📄 Script Overview

### **06_model_evaluation.R**
Connects to PostgreSQL, loads the `modeling_clean` table, **exports it to CSV**, prepares the modeling dataset, and performs a **time‑based train/test split**.

Key steps:
- Load modeling dataset from PostgreSQL  
- Save `modeling_clean.csv` into the project  
- Convert categorical variables  
- Rename `weekly_sales` → `actual_sales`  
- Split data into:
  - **Train:** all years before 2012  
  - **Test:** year 2012  
- Export `train_df.csv` and `test_df.csv` for downstream scripts  

This script is the **foundation** of the modeling workflow.

---

### **07_model_training.R**
Trains the baseline and Random Forest models using the prepared datasets.

Inputs:
- `train_df.csv`  
- `test_df.csv`  

Models trained:
- **Linear Regression** (baseline)  
- **Random Forest scaling experiments**:
  - RF Small (200k rows)  
  - RF Medium (500k rows)  
  - RF Large (1M rows — final model)  

Outputs:
- `lm_model.rds`  
- `rf_small.rds`, `rf_medium.rds`, `rf_large.rds`  
- Baseline predictions and evaluation metrics  

---

### **08_model_compare_and_visualize.R**
Loads trained models and compares performance across all models.

Includes:
- RMSE, MAE, MAPE, SMAPE for each model  
- Comparison table  
- Best model selection  
- Visualizations:
  - Actual vs Predicted  
  - Residual distribution  
  - Predicted vs Actual scatter  

These visuals support the case study and Power BI dashboard.

---

### **09_feature_importance.R**
Loads all Random Forest models and extracts normalized feature importance.

Outputs:
- Normalized feature importance for:
  - RF Small  
  - RF Medium  
  - RF Large  
- Individual importance plots  
- Combined comparison plot  
- Summary table for case study  

This script supports interpretability and business storytelling.

---

### **10_simulation_scenarios.R**
Runs business‑focused scenario simulations using the **final RF model (1M rows)**.

Inputs:
- `rf_large.rds`  
- `test_df.csv`  

Scenarios:
- Fuel price +10%  
- CPI –10%  
- Temperature +5°F  
- Holiday promotion boost  
- Combined shock  

Outputs:
- Predicted sales under each scenario  
- Delta vs baseline  
- Percentage change  
- Summary table for dashboard  

This script demonstrates how forecasting models support **strategic decision‑making**.

---

### **utils_metrics.R**
Reusable custom metric functions:
- `rmse()`  
- `mae()`  
- `mape()`  
- `smape()`  

These functions keep evaluation scripts clean and modular.

---

## 🔗 Workflow Summary

### **1. PostgreSQL (SQL folder)**
- Clean raw data  
- Engineer features  
- Build final modeling dataset (`modeling_clean`)  

### **2. R (this folder)**
- Load modeling dataset  
- Export modeling CSV  
- Train models  
- Compare performance  
- Visualize results  
- Extract feature importance  
- Run scenario simulations  

This separation mirrors real analytics engineering practices and keeps the project organized and easy to navigate.

---

## 🛠️ Tools & Technologies
- **PostgreSQL** — Data engineering  
- **R (dplyr, ranger, ggplot2)** — Modeling & visualization  
- **Power BI** — Dashboard & business insights  
- **GitHub** — Version control & portfolio hosting  

---

## 📌 Author
**Waldo Ketonou**  
WaldoSphere Group

Springfield, MO
