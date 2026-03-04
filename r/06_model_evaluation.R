# =====================================================================
# Walmart Sales Forecasting Project
# 06_model_evaluation.R
# Author: Waldo Ketonou | WaldoSphere Group LLC
# Purpose: Load modeling_clean (CSV-first), evaluate model
# =====================================================================

# -----------------------------
# Load libraries
# -----------------------------
library(DBI)
library(RPostgres)
library(dplyr)

###############################################
# Time‑based train/test split for modeling
###############################################

#---------------------------------------------
# 1. Load modeling_clean table (CSV-first)
#---------------------------------------------
csv_path <- "data/cleaned/modeling_clean.csv"

if (file.exists(csv_path)) {

  message("✔ Loading modeling_clean from CSV...")
  model_df <- read.csv(csv_path)

} else {

  message("⚠ CSV not found. Connecting to PostgreSQL...")

  con <- dbConnect(
    RPostgres::Postgres(),
    dbname   = "walmart_sales",
    host     = "localhost",
    port     = 5432,
    user     = "postgres",
    password = "mypostegresqlpassword"
  )

  model_df <- dbReadTable(con, "modeling_clean")
  dbDisconnect(con)

  message("✔ Loaded modeling_clean from PostgreSQL.")
}

# Quick uniqueness check
sapply(model_df, function(x) length(unique(x)))

# Inspect structure and preview
str(model_df)
head(model_df)

#---------------------------------------------
# 2. Prepare categorical variables
#---------------------------------------------
model_df$store_type <- as.factor(model_df$store_type)
model_df$feature_is_holiday <- as.factor(model_df$feature_is_holiday)

#---------------------------------------------
# 3. Prepare date + rename target variable
#---------------------------------------------
model_df$date <- as.Date(model_df$date)

# Rename weekly_sales → actual_sales
names(model_df)[names(model_df) == "weekly_sales"] <- "actual_sales"

#---------------------------------------------
# 4. Time‑based train/test split
#    Train: all data before 2012
#    Test:  all data in 2012
#---------------------------------------------
train_df <- model_df %>% filter(year < 2012)
test_df  <- model_df %>% filter(year == 2012)

#---------------------------------------------
# 5. Validation checks
#---------------------------------------------
nrow(train_df)
nrow(test_df)

range(train_df$date)
range(test_df$date)

###############################################
# End of script
###############################################
