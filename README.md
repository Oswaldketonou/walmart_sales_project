# 🛒 Walmart Sales Forecasting Project  
**Author:** Waldo Ketonou | WaldoSphere Group LLC  
**Location:** Springfield, MO  
**Tech Stack:** PostgreSQL • R • dplyr • ranger • ggplot2 • Power BI • GitHub  

A full end‑to‑end forecasting pipeline built to model Walmart weekly sales using real‑world data engineering, machine learning, and scenario simulation techniques. This project mirrors a production analytics workflow: SQL for data engineering, R for modeling and evaluation, and Power BI for business storytelling.

---

## 📊 Interactive Tableau Dashboard  
Explore the full Walmart Sales Performance Dashboard (2010–2012):

👉 **[View on Tableau Public](https://public.tableau.com/views/walmartSalesPerformanceDashoard2010-2012/KeyPerformanceIndicators2010-2012)**

This dashboard visualizes key performance indicators, seasonal patterns, holiday effects, and store‑level trends.  
A `/tableau_eda` folder in this repository contains supporting snapshots and exploratory visuals.

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

walmart_sales_project/
│

├── data/                     # Raw and cleaned datasets (excluded from GitHub if large)

│

├── notebooks/                # R Markdown notebooks for modeling, evaluation, and case study

│   ├── 06_final_case_study.Rmd

│   ├── 06_model_evaluation.R

│   ├── 07_model_training.R

│   ├── 08_model_compare_and_visualize.R

│   ├── 09_feature_importance.R

│   └── 10_simulation_scenarios.R

│

├── sql/                      # SQL scripts for data engineering and feature creation

│   ├── 03_feature_engineering.sql

│   └── other SQL scripts...

│

├── visuals/                  # Model diagnostics + final storytelling visuals

│   ├── actual_vs_predicted.png

│   ├── residuals.png

│   ├── feature_importance.png

│   └── comparison_plots.png

│

├── tableau_eda/              # Tableau exploratory analysis snapshots + EDA visuals

│   └── readme.md

│

├── outputs/                  # Evaluation outputs, metrics, and scenario results

│   └── evaluation/

│       ├── rf_small3_metrics.csv

│       └── other evaluation files...

│

├── models/                   # Model artifacts or documentation (no large binaries)

│   └── README.md

│

├── docs/                     # Documentation files

│   └── case_study.md         # Full narrative case study

|   └── modeling_strategy.md  # detailed modeling strategy document

├── .gitignore                # Git ignore rules

│

└── README.md                 # Main project documentation


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

## 🧭 Final Business Recommendations

### 1. Strengthen Inventory and Staffing Around Seasonal Peaks  
Sales rise steadily from late Q1 through mid‑summer and surge again in December. Increasing inventory buffers, optimizing replenishment cycles, and adjusting staffing levels during these periods will reduce stockouts and improve customer experience.

### 2. Prioritize High‑Revenue Departments in Forecasting and Operations  
A small number of departments generate most of Walmart’s revenue. These categories should receive more granular forecasting, targeted promotions, and tighter inventory controls to maximize ROI and reduce lost sales opportunities.

### 3. Expand Holiday‑Focused Promotions and Preparedness  
Holiday weeks consistently produce the strongest sales spikes. Walmart should intensify promotional activity, expand holiday‑specific assortments, and position inventory earlier to fully capture these high‑margin periods.

### 4. Deploy Markdown Strategies More Strategically  
Markdown weeks show higher average sales, especially in price‑sensitive categories. Walmart should time markdowns around seasonal transitions and inventory clearance windows to stimulate demand without unnecessary margin loss.

### 5. Adjust Pricing and Promotions Based on Economic Conditions  
Fuel prices, CPI, and unemployment show meaningful correlations with sales. Walmart should incorporate these indicators into pricing and promotional strategies to maintain customer traffic during periods of economic pressure.

### 6. Improve Forecast Accuracy for Extreme Demand Weeks  
The model underpredicts holiday spikes and overpredicts low‑demand weeks. Enhancing features related to holidays, markdown intensity, and store‑level effects will improve accuracy where it matters most for operations.

### 7. Use Scenario Simulations for Strategic Planning  
Scenario testing (fuel +10%, CPI –10%, temperature shifts, holiday promotions, combined shocks) shows how external conditions impact sales. Walmart can use these simulations to plan for economic shifts, optimize pricing, and prepare for market disruptions.

---

## 🧾 Executive Summary  
This project delivers a full end‑to‑end forecasting pipeline designed to model Walmart’s weekly sales using production‑grade analytics practices. The workflow integrates PostgreSQL for data engineering, R for modeling and scenario simulation, and Power BI for business storytelling. The final model—built through linear regression and scaled Random Forest experiments up to 1M rows—captures long‑term trends, seasonal patterns, holiday effects, markdown impacts, and macroeconomic conditions.

The analysis reveals strong seasonal cycles, significant holiday-driven demand spikes, and meaningful sensitivity to markdown activity and economic indicators such as fuel prices, CPI, and unemployment. Scenario simulations demonstrate how external shocks and promotional strategies influence sales, providing actionable insights for operational planning.

This forecasting system equips Walmart with a data-driven foundation for inventory optimization, pricing strategy, promotional timing, and strategic decision-making across stores and departments. The recommendations that follow translate these insights into clear business actions that support revenue growth, operational efficiency, and resilience under changing economic conditions.

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
WaldoSphere Group
Springfield, MO

