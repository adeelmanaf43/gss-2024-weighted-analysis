# 04_crosstabs.R
# Weighted crosstabs: financial satisfaction by group, with
# Rao-Scott chi-square tests (Table 2)
# Input: data/design_main.rds (made by R/03_design.R)
# Output: outputs/table2_crosstabs.html

library(srvyr)
library(gtsummary)
options(survey.lonely.psu = "adjust") # same settings as in 03_design.R

design_main <- readRDS("data/design_main.rds")

# 1. Build the table ------------------------------------------------------------------
table2 <- design_main |>
  tbl_svysummary(
    by = fin_sat, #columns: the 3 answers
    include = c(age_group, education, work_status, marital_status, income_group), # rows: the 5 groups
    percent = "row",
    statistic = all_categorical() ~ "{p}%", # show weighted % only
    digits = all_categorical() ~ 1, # one decimal
    missing = "no", # hide missing-answer rows
    label = list(
      age_group ~ "Age", education ~ "Education", work_status ~ "Work status",
      marital_status ~ "Marital status", income_group ~ "Family income"
    )
  ) |>
  add_p(test = all_categorical() ~ "svy.chisq.test") |>   # Rao-Scott test
  bold_labels() |>
  modify_header(label ~ "**Group**", all_stat_cols() ~ "**{level}**") |>
  modify_spanning_header(all_stat_cols() ~ "**Satisfaction with financial situation**") |>
  modify_footnote(all_stat_cols() ~ "Weighted row percentages") |>
  modify_caption("**Table 2. Financial satisfaction by group, U.S. adults, 2024**")

print(table2) # opens in Rstudio's Viewer pane

# 2. Save as a web page -----------------------------------------------------------------
table2_gt <- as_gt(table2) |>
  gt::tab_source_note("Source: 2024 General Social Survey (NORC), main sample.")
  gt::gtsave(table2_gt, "outputs/table2_crosstabs.html")
  
  # 3. Save the table for the Quarto report --------------------------------------------
  saveRDS(table2_gt, "data/table2_gt.rds")