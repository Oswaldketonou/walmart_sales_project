# 📘 Notebooks Overview  
### *Walmart Sales Forecasting Project*

This folder contains all analysis notebooks used to build, evaluate, interpret, and apply the forecasting models for the Walmart Sales Forecasting Project.  
Each notebook builds on the previous one, forming a complete, end‑to‑end analytics workflow.

---

## 🧭 Notebook Index

---

### **01 — Modeling Setup**

**Purpose:**  
Prepare the modeling environment, load cleaned datasets, and perform initial preprocessing required for downstream modeling.

**Key Outputs:**  
- Cleaned training and test datasets  
- Prepared modeling objects  

---

### **02 — Model Training**

**Purpose:**  
Train all forecasting models, including:  
- Linear Regression  
- Random Forest (Small: 200k rows)  
- Random Forest (Medium: 500k rows)  
- Random Forest (Large: 1M rows)

**Key Outputs:**  
- Saved model objects (`.rds` files)  
- Training diagnostics  

---

### **03 — Model Comparison & Visualization**

**Purpose:**  
Evaluate all trained models using RMSE, MAE, MAPE, and SMAPE.  
Generate visual diagnostics to assess predictive performance:

- Actual vs Predicted  
- Residual Distribution  
- Predicted vs Actual Scatter  

**Key Outputs:**  
- Model comparison table  
- Best model selection  
- Visual evaluation plots  

---

### **04 — Feature Importance & Model Insights**

**Purpose:**  
Analyze feature importance across all Random Forest models to understand which variables drive sales predictions and how importance changes with sample size.

**Key Outputs:**  
- Feature importance plots  
- Normalized importance tables  
- Business interpretation of key drivers  

---

### **05 — Scenario Simulation & What‑If Analysis**

**Purpose:**  
Use the final Random Forest model (1M rows) to simulate how changes in key drivers affect predicted sales:

- Fuel price +10%  
- CPI −10%  
- Temperature +5°F  
- Holiday promotion  
- Combined shock  

**Key Outputs:**  
- Scenario predictions  
- Delta vs baseline  
- Summary table for dashboard and case study  

---

## 🔗 Workflow Summary

The notebooks should be run **in order**, as each depends on outputs from the previous step:
01_setup → 02_training → 03_comparison → 04_feature_importance → 05_simulation


---

## 📝 Notes

- All trained models are saved in:  
  `outputs/models/`

- Prepared datasets are stored in:  
  `outputs/prepared_data/`

- Visuals and tables generated in each notebook support the final case study, dashboard, and scenario analysis.

---



