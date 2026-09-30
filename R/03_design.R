# 03_design.R
# Builds the survey design and compares unweighted and weighted
# estimates of financial satisfaction (Table 1)
# Input: data/gss2024_clean.rds (made by R/01_clean.R)
# Output: data/design_main.rds (not in Git)
#         outputs/table1_satfin_estimates.csv


library(dplyr)
library(tidyr)
library(srvyr)


# If a strtum ends up with only one PSU, use a conservative variance fix
options(survey.lonely.psu = "adjust")

clean <- readRDS("data/gss2024_clean.rds")

# 1. Flag AmeriSpeak cases: they have no main-sample weight ---------------------------------
clean <- mutate(clean, amerispeak = is.na(wtssnrps))
print(count(clean, amerispeak, mode)) # expect 677 True all with mode 4 (web)

# 2. Survey designs --------------------------------------------------------------------------
main <- filter(clean, !amerispeak) # 3,309 main-sample respondents


# Main analysis: main sample, NORC's recommended weight
design_main <- main |>
  as_survey_design(ids = vpsu, strata = vstrat, weights = wtssnrps, nest = TRUE)

# Sensitivity check: all 3,986 people, with the AmeriSpeak weight
design_all <- clean |>
  as_survey_design(ids = vpsu, strata = vstrat, weights = wtssnrps_as, nest = TRUE)

# Unweighted comparsion: same 3,309 people, no weights, no clusters
design_unweighted <- as_survey_design(main, ids = 1)

# Share in each satisfaction levels
estimate_satfin <- function(design, label) {
  design |>
    filter(!is.na(satfin)) |>
    group_by(fin_sat) |>
    summarise(pct = survey_prop(vartype = "ci", proportion = TRUE)) |>
    mutate(result = sprintf("%.1f (%.1f to %.1f)",
                            100 * pct, 100*pct_low, 100*pct_upp),
           estimate = label) |>
    select(fin_sat, estimate, result)
}

table1 <- bind_rows(
  estimate_satfin(design_unweighted, "Unweighted"),
  estimate_satfin(design_main, "Weighted, main sample"),
  estimate_satfin(design_all, "Weighted, all cases") 
)|>
  pivot_wider(names_from = estimate, values_from = result)
print(table1)

# 4. Save ----------------------------------------------------------------------
saveRDS(design_main, "data/design_main.rds")
write.csv(table1, "outputs/table1_satfin_estimates.csv", row.names = FALSE)

