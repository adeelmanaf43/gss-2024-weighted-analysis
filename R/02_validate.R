# 02_validate.R
# Checks the clean file before any analysis
# Stops with an error message if any check fails
# Input: data/gss2024_clean.rds (made by R/01_clean.R)


library(dplyr)
clean <- readRDS("data/gss2024_clean.rds")


# 1.Rows and IDS ------------------------------------------------------------------------------------------
stopifnot(
  "Expected 3.986 rows"         = nrow(clean) == 3986,
  "Respondes IDs must be unique" = !anyDuplicated(clean$id)
)


# 2. Allowed valus ----------------------------------------------------------------------------------------
stopifnot(
  "Age must be between 18 and 89"    = all(between(clean$age, 18, 89), na.rm = TRUE),
  "not_satisfied must be 0 or 1"     = all(clean$not_satisfied %in% c(0, 1, NA)),
  identical(levels(clean$income_group),
  c("Under $30k", "$30k-$59k", "$60k-$109k", "$110k+", "Not reported")
))

# 3. No one lost in recording: every valid answer got a group ---------------------------------------------
stopifnot(
  "fin_sat lost answers"               = sum(!is.na(clean$fin_sat)) == sum(!is.na(clean$satfin)),
  "age_group lost answers"             = sum(!is.na(clean$age_group)) == sum(!is.na(clean$age)),
  "education lost answers"             = sum(!is.na(clean$education)) == sum(!is.na(clean$degree)),
  "marital_status lost answers"        = sum(!is.na(clean$marital_status)) == sum(!is.na(clean$marital)),
  "income_group has blanks"            = !anyNA(clean$income_group)
  
)

# 4. Old codes vs new groups: read these once by eye ------------------------------------------------------
print(count(clean, wrkstat, work_status))
print(count(clean, marital, marital_status))
print(count(clean, income16, income_group), n = 30)


# 5. Percent missing per variable (copy into data_dictionary.md)-------------------------------------------
print(round(100 & colMeans(is.na(clean)),1))
cat("All checks passed.\n")