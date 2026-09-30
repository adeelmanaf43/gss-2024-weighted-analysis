# 01_clean.R
# Builds the clean analysis file from the raw 2024 GSS file.
# Input: data-raw/GSS2024.dta (not in Git: download steps in data-raw/README.md)
# Output: data/gss2024_clean.rds (not in Git: this script rebuilds it)

library(haven)
library(dplyr)

raw_file <- "data-raw/GSS2024.dta"


# 1. Read the raw file and keep only the columns we need ----------------
gss <- read_dta(raw_file)
names(gss) <- tolower(names(gss))

keep <- c(
  "id","ballot", "mode", "satfin", "age", "degree", "wrkstat", "marital",
  "income16", "vstrat", "vpsu","wtssps", "wtssnrps", "wtssnrps_as"
)

gss <- select(gss, all_of(keep))


# 2. Missing codes-> NA, then drop the Stata labels ---------------------
# zap_missing(): every GSS missing code (don't know, not asked, 
#  no answer, skipped on web) becomes R's plain NA
# zap_labels(): keeps the numeric codes: we write our own labels below
gss <- gss |> zap_missing() |> zap_labels()


# 3. Recode into analysis groups ----------------------------------------
clean <- gss |>
  mutate(
    # Outcome: 1 pretty well, 2 more or less, 3 not satisfied at all
    fin_sat = factor(satfin, levels = 1:3, 
                     labels = c("Pretty well satisfied", "More or less satisfied",
                                "Not satisfied at all")),
    # Yes/no version for the model in Session 4 (1 = not satisfied at all)
    not_satisfied = as.integer(satfin == 3),
    
    # Age in years(89 = 89 or older) -> 4 groups
    age_group= cut(age, breaks = c(17, 29, 44, 64, Inf),
                   labels = c("18-29", "30-44", "45-64", "65+")),
    
    # 0 less than HS, 1 high school, 2 associate, 3 bachelor's, 4 graduate
    education = factor(degree, levels = 0:4,
                       labels = c("Less than high school", "High school",
                                  "Associate/junior college", "Bachelor's", "Graduate")),
    
    # 1 full time, 2 part time, 3 temporarily off work, 4 unemployed, 5 retired,
    # 6 in school, 7 keeping house, 8 other -> "Other"
    work_status = factor(case_when(
      wrkstat == 1 ~ "Full time", 
      wrkstat == 2 ~ "Part time",
      wrkstat == 4 ~ "Unemployed",
      wrkstat == 5 ~ "Retired",
      wrkstat %in% c(3, 6, 7, 8) ~ "Other"
    ), levels = c("Full time", "Part time", "Unemployed", "Retired", "Other")),
    
    # 1 married, 2 widowed 3 divorced 4 separated 5 never married
    marital_status = factor(case_when(
      marital == 1 ~ "Married",
      marital == 2 ~ "Widowed",
      marital %in% 3:4 ~ "Divorced or separated",
      marital == 5 ~ "Never married"
    ), levels = c("Married", "Widowed", "Divorced or separated",
                  "Never married")),
    
    # INCOME16 bands: 1-15 under $30k, 16-19 $30k-$59k
    # 20-22 $60k-$109k, 23-26 $100k or more: no answer -> own group
    income_group = factor(
      case_when(
        income16 %in% 1:15 ~ "Under $30k",
        income16 %in% 16:19 ~ "$30k-$59k",
        income16 %in% 20:22 ~ "$60k-$109k",
        income16 %in% 23:26 ~ "$110k+",
        is.na(income16) ~ "Not reported"
      ), levels = c("Under $30k", "$30k-$59k", "$60k-$109k",
                    "$110k+", "Not reported")
    )
  )



# 4. Save -----------------------------------------------------------

dir.create("data", showWarnings = FALSE)
saveRDS(clean, "data/gss2024_clean.rds")
cat("Saved", nrow(clean), "rows and", ncol(clean), "columns to data/gss2024_clean.rds\n")

#The original columns (satfin, wrkstat and so on) stay in the file next to the new ones. In Hour 4, you'll cross-check old against new to 
#prove every recode is correct.
# In work_status, code 3 means "has a job but temporarily off work". It's a small group, so it goes in "Other". Write that down; it's
# another documented decision.
#.rds is R's own file format. Unlike CSV, it keeps factor levels in the order you set them.