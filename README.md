# 🛒 Walmart Sales Forecasting Project  
**Author:** Waldo Ketonou | WaldoSphere Group LLC  
**Location:** Springfield, MO  
**Tech Stack:** PostgreSQL • R • dplyr • ranger • ggplot2 • Power BI • GitHub  

A full end‑to‑end forecasting pipeline built to model Walmart weekly sales using real‑world data engineering, machine learning, and scenario simulation techniques. This project mirrors a production analytics workflow: SQL for data engineering, R for modeling and evaluation, and Power BI for business storytelling.

---

## 📌 Project Overview  
This project forecasts Walmart weekly sales using:

- **PostgreSQL** for data cleaning, feature engineering, and time‑based splitting  
- **R** for modeling, evaluation, visualization, and scenario simulation  
- **Random Forest scaling experiments** (200k → 500k → 1M rows)  
- **Power BI** for business insights and dashboarding  

The pipeline is modular, reproducible, and hardware‑aware, reflecting real analytics engineering practices.

---

## 🏗️ Architecture & Workflow  
The project follows a structured, multi‑stage workflow:

### **1. Data Engineering (SQL)**
- Clean raw data  
- Create lag features  
- Create rolling windows  
- Encode holiday effects  
- Join store metadata  
- Produce final modeling dataset: **`modeling_clean`**

### **2. Modeling Pipeline (R)**  
Scripts must be run in order:

| Step | Script | Purpose |
|------|--------|---------|
| 06 | `06_model_evaluation.R` | Load `modeling_clean`, prepare `train_df` and `test_df` |
| 07 | `07_model_training.R` | Train Linear Regression + RF scaling models |
| 08 | `08_model_compare_and_visualize.R` | Compare models and generate evaluation visuals |
| 09 | `09_feature_importance.R` | Extract and visualize feature importance |
| 10 | `10_simulation_scenarios.R` | Run business scenario simulations |

This structure ensures clean separation of concerns and reproducibility.

---

## 📊 Modeling Approach

### **Baseline Model**
- Linear Regression  
- Provides interpretability and a benchmark  

### **Random Forest Scaling Experiments**
To respect hardware limits, models are trained on:

- **200k rows** → RF Small  
- **500k rows** → RF Medium  
- **1M rows** → RF Large (final model)  

All RF models use:
- `num.trees = 200`  
- `num.threads = 1`  
- `importance = "impurity"`  

This approach demonstrates how model performance scales with data volume.

---

## 📈 Model Evaluation  
Metrics computed:

- **RMSE**  
- **MAE**  
- **MAPE**  
- **SMAPE**  

Visualizations include:

- Actual vs Predicted  
- Residual distribution  
- Predicted vs Actual scatter  

These outputs support both technical evaluation and business interpretation.

---

## 🔍 Feature Importance  
Using the final RF model (1M rows):

- Extract impurity‑based importance  
- Normalize importance per model  
- Visualize importance for each RF model  
- Compare importance across models  
- Produce a summary table for the case study  

This step supports interpretability and stakeholder communication.

---

## 🧪 Scenario Simulations  
Using the final RF model, the following business scenarios are simulated:

| Scenario | Description |
|----------|-------------|
| Fuel +10% | Rising transportation costs |
| CPI –10% | Economic relief |
| Temp +5°F | Heat wave |
| Holiday Promotion | All holiday flags set to 1 |
| Combined Shock | Fuel ↑10%, CPI ↓10%, Temp ↑5°F |

Outputs include:

- Predicted sales under each scenario  
- Delta vs baseline  
- Percentage change  
- Summary table for dashboard  

This demonstrates how forecasting models support **strategic decision‑making**.

---

## 📁 Repository Structure  

---

## 🛠️ Tools & Technologies  
- **PostgreSQL** — Data engineering  
- **R (dplyr, ranger, ggplot2)** — Modeling & visualization  
- **Power BI** — Dashboard & business insights  
- **GitHub** — Version control & portfolio hosting  

---

## 🎯 Key Business Insights  
This section summarizes insights derived from the modeling and scenario simulations.  
(You will fill this in once your dashboard is finalized.)

Examples:
- Fuel price increases have the largest negative impact on weekly sales  
- Holiday promotions significantly boost sales across all store types  
- CPI decreases improve sales, especially in lower‑income regions  
- Temperature increases have a moderate but consistent effect  

---

## 🚀 How to Run the Project

### **Prerequisites**
- PostgreSQL installed  
- R + required packages  
- Power BI Desktop (optional for dashboard)

### **Execution Order**
1. Run SQL scripts to build `modeling_clean`  
2. Run `06_model_evaluation.R`  
3. Run `07_model_training.R`  
4. Run `08_model_compare_and_visualize.R`  
5. Run `09_feature_importance.R`  
6. Run `10_simulation_scenarios.R`  

---

## 📌 Author  
**Waldo Ketonou**  
WaldoSphere Group LLC  
Springfield, MO  

