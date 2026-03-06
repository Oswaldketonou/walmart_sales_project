# 📂 modeling_clean_sample  
### *Walmart Sales Forecasting Project — Cleaned Data Sample*

This folder contains a **small sample extract** of the full `modeling_clean` dataset used for model development in the Walmart Sales Forecasting Project.  
It is included for **demonstration, documentation, and lightweight testing** without requiring the full 190k+ row dataset.

---

## 🎯 Purpose of This Folder

The `modeling_clean_sample` directory provides a **compact version** of the modeling dataset that allows:

- Quick inspection of the cleaned feature structure  
- Fast testing of notebook code  
- Sharing a lightweight dataset on GitHub  
- Demonstrating the modeling pipeline without uploading large files  

This sample is especially useful for environments where the full dataset is too large to store or process.

---

## 📄 What This Sample Contains

- A small subset of rows from the full `modeling_clean.csv`  
- All columns used in the modeling pipeline, including:  
  - Store and department identifiers  
  - Engineered features  
  - Macroeconomic variables  
  - Seasonal and holiday indicators  
  - Target variable (`weekly_sales`)  

The structure mirrors the full dataset exactly.

---

## 🚫 What This Sample Is *Not* For

This sample **should not** be used for:

- Training final models  
- Scenario simulations  
- Feature importance analysis  
- Model comparison  

Those steps require the **full modeling dataset**, which is generated through the SQL + R preprocessing pipeline.

---

## 🔗 How This Sample Fits Into the Workflow

data/raw
↓ (SQL cleaning + feature engineering)
data/cleaned/modeling_clean.csv
↓ (sample extracted for GitHub)
data/cleaned/modeling_clean_sample/
↓ (used for documentation + lightweight testing)
notebooks/

---

## 📝 Notes

- The full `modeling_clean.csv` is **not stored in the repository** due to size constraints.  
- This sample ensures the project remains reproducible and transparent.  
- All modeling notebooks expect the full dataset unless explicitly pointed to this sample.

---

