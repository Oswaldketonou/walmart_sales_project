# =====================================================================
# Walmart Sales Forecasting Project
# 06_model_evaluation.R
# Author: Waldo Ketonou | WaldoSphere Group
# Purpose: Connect to PostgreSQL, load modeling_clean, save CSV, evaluate
# =====================================================================

# -----------------------------
# Load libraries
# -----------------------------
library(DBI)
library(RPostgres)
library(dplyr)

# -----------------------------
# Connect to PostgreSQL
# -----------------------------
con <- dbConnect(
  RPostgres::Postgres(),
  dbname   = "walmart_sales",
  host     = "localhost",
  port     = 5432,
  user     = "postgres",
  password = "mypasswordtopostegresql"
)

###############################################
# Time‑based train/test split for modeling
###############################################

#---------------------------------------------
# 1. Load modeling_clean table
#---------------------------------------------
model_df <- dbReadTable(con, "modeling_clean")

#---------------------------------------------
# 2. Save a copy of modeling_clean to project
#---------------------------------------------
dir.create("data", showWarnings = FALSE)
dir.create("data/cleaned", showWarnings = FALSE)

write.csv(model_df, "data/cleaned/modeling_clean.csv", row.names = FALSE)

#---------------------------------------------
# 3. Quick uniqueness check
#---------------------------------------------
sapply(model_df, function(x) length(unique(x)))

# Inspect structure and preview
str(model_df)
head(model_df)

#---------------------------------------------
# 4. Prepare categorical variables
#---------------------------------------------
model_df$store_type <- as.factor(model_df$store_type)
model_df$feature_is_holiday <- as.factor(model_df$feature_is_holiday)

#---------------------------------------------
# 5. Prepare date + rename target variable
#---------------------------------------------
model_df$date <- as.Date(model_df$date)

# Rename weekly_sales → actual_sales
names(model_df)[names(model_df) == "weekly_sales"] <- "actual_sales"

#---------------------------------------------
# 6. Time‑based train/test split
#    Train: all data before 2012
#    Test:  all data in 2012
#---------------------------------------------
train_df <- model_df %>% filter(year < 2012)
test_df  <- model_df %>% filter(year == 2012)

#---------------------------------------------
# 7. Validation checks
#---------------------------------------------
nrow(train_df)
nrow(test_df)

range(train_df$date)
range(test_df$date)

###############################################
# End of script
###############################################
