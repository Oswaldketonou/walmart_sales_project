# 🗄️ SQL Scripts Overview  
### *Walmart Sales Forecasting Project*

This folder contains all SQL scripts used to prepare, clean, engineer, and explore the Walmart sales dataset.  
These scripts form the foundation of the modeling pipeline and ensure that all downstream notebooks operate on clean, consistent, and reproducible data.

---

## 📁 SQL Script Index

---

### **01_data_validation.sql**

**Purpose:**  
Validate raw input data before cleaning. Checks include:

- Missing values  
- Invalid data types  
- Out‑of‑range values  
- Duplicate rows  
- Unexpected category levels  

**Outputs:**  
- Validation tables  
- Flags for data quality issues  

---

### **02_data_cleaning.sql**

**Purpose:**  
Clean and standardize the dataset for modeling. Operations include:

- Handling missing values  
- Fixing inconsistent formats  
- Removing invalid rows  
- Standardizing categorical fields  
- Ensuring date formats are consistent  

**Outputs:**  
- Cleaned dataset stored in `data/cleaned/`  

---

### **03_feature_engineering.sql**

**Purpose:**  
Create new features that improve model performance, including:

- Holiday flags  
- Temperature bins  
- Lag features  
- Rolling averages  
- Store‑level and department‑level aggregates  

**Outputs:**  
- Feature‑enhanced dataset for modeling  

---

### **04_eda_queries.sql**

**Purpose:**  
Perform SQL‑based exploratory data analysis (EDA), including:

- Summary statistics  
- Store‑level trends  
- Department‑level patterns  
- Correlation checks  
- Seasonal and holiday effects  

**Outputs:**  
- EDA tables and insights used in Notebook 03  

---

### **insights_notebook.sql**

**Purpose:**  
A dedicated SQL notebook for:

- Annotated queries  
- Observations  
- Insights  
- Commentary  
- Business logic notes  

This file acts as the **SQL narrative companion** to the modeling notebooks.

---

## 🔗 Workflow Summary

The SQL scripts should be executed **in order**, as each step builds on the previous one:

01_data_validation → 02_data_cleaning → 03_feature_engineering → 04_eda_queries → insights_notebook

---

## 📝 Notes

- All SQL scripts are written for **PostgreSQL**.  
- Outputs feed directly into the R modeling pipeline (`notebooks/` folder).  
- SQL ensures reproducibility and separation of concerns between data prep and modeling.  
- The `insights_notebook.sql` file is intentionally narrative and may include comments, notes, and exploratory queries.

---


