# 06_model.R
# Weighted logistic regression: which characteristics are linked to being "not satisfied at all", before and 
# after holding income constant (Table 3)
# Input: data/design_main.rds (made by R/03_design.R)
# Output: outputs/table3_model.html


library(survey)
library(srvyr)
library(gtsummary)

options(survey.lonely.psu = "adjust") # same setting as in 03_design.R

design_main <- readRDS("data/design_main.rds")


# 1. Fit the two models -----------------------------------------------------------------------------------
# Model A: the four characteristics together without income
model_a <- svyglm(
  not_satisfied ~ age_group + education + work_status + marital_status, 
  design = design_main, family = quasibinomial()
)

# Model B: the same model with income added
model_b <- svyglm(
  not_satisfied ~ age_group + education + work_status + marital_status + income_group,
  design = design_main, family = quasibinomial()
)

cat("Respondents in each model:", nobs(model_a), "and", nobs(model_b), "\n")


# 2. Is each characteristic still linked once income is held constant? -------------------------------------
# One overall test per characteristic in Model B: like the Rao-Scott test in 
# Table 2, but now holding everything else in the model constant

tests_b <- c(
  age            = regTermTest(model_b, ~ age_group)$p,
  education      = regTermTest(model_b, ~ education)$p,
  work_status    = regTermTest(model_b, ~ work_status)$p,
  marital_status = regTermTest(model_b, ~ marital_status)$p,
  income         = regTermTest(model_b, ~ income_group)$p
)

print(data.frame(p_value = format.pval(tests_b, digits = 2, eps = 0.0001),
                 row.names = names(tests_b)))

# 3. Table 3: odds ratios, without and with income ----------------------------------------------------------
labels_a <- list(age_group ~ "Age", education ~ "Education",
                 work_status ~ "Work status", marital_status ~ "Marital status")
labels_b <- c(labels_a, list(income_group ~ "Family income"))

table3 <- tbl_merge(
  tbls = list(
    tbl_regression(model_a, exponentiate = TRUE, label = labels_a),
    tbl_regression(model_b, exponentiate = TRUE, label = labels_b)
  ),
  tab_spanner = c("**Without income**", "**With income**")
) |>
  bold_labels() |>
  modify_caption("**Table 3. Odds of being not satisfied at all with one's financial situation, U.S. adults, 2024**")

print(table3)   # Opens in Rstudio's viewer pane

table3_gt <- as_gt(table3) |>
  gt::tab_source_note(paste0(
    "Weighted logisitc regression (svyglm, quasibinomial). OR = odds ratio;",
    "above 1 = higher odds of dissatisfaction then the reference group (shown as -).",
    "Source: 2024 General Social Survey (NORC), main sample, n = ", nobs(model_b), "."
  ))


gt::gtsave(table3_gt, "outputs/table3_model.html")

# 4. Save results for the Quarto report -------------------------------------------
saveRDS(model_b,   "data/model_b.rds")
saveRDS(tests_b,   "data/model_tests.rds")
saveRDS(table3_gt, "data/table3_gt.rds")