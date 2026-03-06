# 📂 Raw Data  
### *Walmart Sales Forecasting Project*

This folder contains the **original, unmodified datasets** used in the Walmart Sales Forecasting Project.  
Files in this directory are loaded directly into the SQL and R preprocessing pipelines.

---

## 📁 Purpose of This Folder

The `data/raw/` directory serves as the **single source of truth** for all input data.  
These files are intentionally kept in their **original state** to ensure:

- Full reproducibility  
- Transparent data lineage  
- Clear separation between raw, cleaned, and engineered datasets  

---

## 📄 What Belongs Here

Only **original input files**, such as:

- `features.csv`  
- `sales.csv`  
- `stores.csv`  
- Any other raw extracts from Kaggle or internal sources  

These files should remain **unchanged** after being added.

---

## 🚫 What Should *Not* Be Stored Here

Do **not** place:

- Cleaned datasets  
- Transformed or engineered datasets  
- Intermediate SQL outputs  
- Notebook‑generated files  
- Model outputs  

Those belong in:

- `data/cleaned/`  
- `outputs/prepared_data/`  
- `outputs/models/`  

---

## 🔗 How This Folder Fits Into the Pipeline
data/raw
↓ (SQL validation & cleaning)
data/cleaned
↓ (feature engineering)
outputs/prepared_data
↓ (model training)
outputs/models
↓ (scenario simulation)
notebooks/


---

## 📝 Notes

- Files in this folder should **never be edited manually**.  
- If new raw data is added, update the SQL validation script (`01_data_validation.sql`).  
- The modeling notebooks assume these files exist and are unchanged.

---
