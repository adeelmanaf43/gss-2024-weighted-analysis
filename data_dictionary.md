# Data Dictionary

## Dataset Overview

| Attribute               | Description                                                      |
| ----------------------- | ---------------------------------------------------------------- |
| Source                  | 2024 General Social Survey (GSS) cross-section, NORC, Release 3a |
| Clean analysis file     | `data/gss2024_clean.rds`                                         |
| Data preparation script | `R/01_clean.R`                                                   |
| Number of respondents   | 3,986                                                            |
| Unit of observation     | One row per respondent                                           |

## Analysis Variables

| Variable         | GSS source variable | Values / coding                                                                    | Missing (%) | Role and recoding notes                                                                             |
| ---------------- | ------------------- | ---------------------------------------------------------------------------------- | ----------- | --------------------------------------------------------------------------------------------------- |
| `fin_sat`        | `SATFIN`            | Pretty well satisfied; More or less satisfied; Not satisfied at all                | 0.6%        | Financial satisfaction outcome.                                                                     |
| `not_satisfied`  | `SATFIN`            | `1` = Not satisfied at all; `0` = Otherwise                                        | 0.6%        | Binary outcome for the model. Missing source responses remain `NA`.                                 |
| `age_group`      | `AGE`               | 18–29; 30–44; 45–64; 65+                                                           | 3.2%        | Age categories. The source variable is top-coded at 89; no-answer responses are treated as missing. |
| `education`      | `DEGREE`            | Less than high school; High school; Associate/junior college; Bachelor's; Graduate | 0.2%        | Educational attainment.                                                                             |
| `work_status`    | `WRKSTAT`           | Full time; Part time; Unemployed; Retired; Other                                   | 0.3%        | “Other” combines temporarily off work, in school, keeping house, and other work statuses.           |
| `marital_status` | `MARITAL`           | Married; Widowed; Divorced or separated; Never married                             | 0.4%        | Divorced and separated responses are combined.                                                      |
| `income_group`   | `INCOME16`          | Under $30k; $30k–$59k; $60k–$109k; $110k+; Not reported                            | 0.0%        | Family income. Non-response is retained as the separate “Not reported” category.                    |

## Survey Design Variables

The following variables are retained for survey design specification beginning in Session 3.

| Variable                            | Description                     | Use                                                    |
| ----------------------------------- | ------------------------------- | ------------------------------------------------------ |
| `vstrat`                            | Variance stratum                | Identifies survey strata.                              |
| `vpsu`                              | Primary sampling unit (cluster) | Identifies sampling clusters.                          |
| `wtssps`, `wtssnrps`, `wtssnrps_as` | Survey weights                  | The weight used for analysis is selected in Session 3. |

## Additional Retained Variables

| Variable(s)                                                 | Description              | Purpose                                          |
| ----------------------------------------------------------- | ------------------------ | ------------------------------------------------ |
| `id`                                                        | Respondent identifier    | Identifies each respondent.                      |
| `ballot`                                                    | Question set: A, B, or C | Records the questionnaire ballot.                |
| `mode`                                                      | Interview mode           | Records how the interview was conducted.         |
| `satfin`, `age`, `degree`, `wrkstat`, `marital`, `income16` | Original GSS codes       | Retained to support verification of each recode. |

## Missing-Value Handling

GSS missing-value codes—including don't know, not asked, no answer, and skipped on web—are stored as `NA`.

**Income exception:** Income non-response is retained as the “Not reported” category in `income_group`. Its reported missing percentage is therefore 0.0%; this does not mean that all respondents reported their income.

For `not_satisfied`, missing `SATFIN` responses remain `NA` and are not assigned to the `0` category.
