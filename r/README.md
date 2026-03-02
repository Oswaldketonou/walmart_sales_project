# 📁 R Modeling & Evaluation Scripts

This folder contains all R scripts used for modeling, evaluation, and visualization in the Walmart Sales Forecasting project. These scripts operate on the modeling dataset generated in PostgreSQL (`modeling_clean`) and represent the full machine‑learning workflow performed outside the database.

The SQL pipeline ends with the creation of the modeling dataset. All statistical modeling, predictions, metrics, and visualizations are performed in R.

---

## 📄 File Overview

### **06_model_evaluation.R**
Evaluates the baseline forecasting model using:
- Linear regression (`lm`)
- Predictions on the test set
- Custom error metrics:
  - RMSE  
  - MAE  
  - MAPE  
  - SMAPE  
- Handling NA predictions
- Comparing actual vs predicted values
- Preparing evaluation tables for the case study

This script reflects the exact evaluation workflow used during model development.

---

### **07_model_training.R**
Trains the final model using the cleaned modeling dataset. Includes:
- Model specification
- Training on the full training set
- Saving the model object
- Exporting predictions for dashboarding or reporting

This script isolates the training logic from evaluation for clarity and reproducibility.

---

### **08_visualizations.R**
Generates visual outputs for the case study and dashboard:
- Time‑series plots
- Actual vs predicted charts
- Error distribution plots
- Store and department trend visuals

All plots are saved to the `/visuals` folder.

---

### **utils_metrics.R**
Contains reusable custom metric functions:
- `rmse()`
- `mae()`
- `mape()`
- `smape()`

These functions keep the evaluation scripts clean and modular.

---

## 🔗 Workflow Summary

1. **PostgreSQL**
   - Clean data  
   - Engineer features  
   - Build modeling dataset (`modeling_clean`)

2. **R (this folder)**
   - Load modeling dataset  
   - Train model  
   - Generate predictions  
   - Evaluate performance  
   - Produce visualizations  

This separation mirrors real analytics engineering practices and keeps the project organized and easy to navigate.
