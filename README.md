# Weighted Survey Analysis of the 2024 General Social Survey

In 2024, 31% of U.S. adults were not satisfied at all with their finances. This project asks who they are, and whether it comes down to income, using design-based survey methods in R.

**[Read the report](https://adeelmanaf43.github.io/gss-2024-weighted-analysis/)** · R · survey · srvyr · gtsummary · ggplot2 · Quarto · renv

## The question

Which U.S. adults were most and least satisfied with their financial situation in 2024, and which characteristics are still linked to financial dissatisfaction once income is taken into account?

## Data

- **Source:** 2024 General Social Survey cross-section (Release 3a) from NORC at the University of Chicago, a national survey of U.S. adults. The analysis uses the 3,309 respondents in the main sample.
- **Terms:** free public-use data. NORC asks users to cite it; the citation is at the end of the report.
- **Download:** the raw data isn't stored in this repo. Follow [data-raw/README.md](data-raw/README.md).
- **Variables:** the outcome (satisfaction with financial situation, SATFIN) and five characteristics: age, highest degree, work status, marital status and family income, all asked of every respondent. Details: [data_dictionary.md](data_dictionary.md).

## Approach

1. **Clean and check.** Turn the GSS missing-value codes into missing values, recode the characteristics into groups, and run automated checks that stop the pipeline if anything is off.
2. **Survey design.** Use NORC's nonresponse-adjusted weight (WTSSNRPS) with the survey's strata and clusters, so estimates represent U.S. adults and confidence intervals reflect how the sample was drawn.
3. **Weighting decision.** Analyze the 3,309 main-sample respondents. NORC's 677-person AmeriSpeak oversample is used only as a sensitivity check; including it changed the estimates by less than 1 point.
4. **Compare groups.** Weighted crosstabs with Rao-Scott chi-square tests, and charts of each group with 95% confidence intervals.
5. **Model.** Weighted logistic regression of being "not satisfied at all", fitted without and with income, to see which links remain once income is held constant.
6. **Report.** A Quarto report that rebuilds from one command, published with GitHub Pages.

## Key findings

- **Income makes the biggest difference at the top.** Adults with family incomes under $30k and $30k-$59k were about equally likely to be not satisfied at all (43.1% and 42.5%); the share fell to 12.8% at $110k or more (odds ratio 0.25, 95% CI 0.16 to 0.39, compared with under $30k).
- **Retirees are far less dissatisfied than workers, even at the same income.** 14.9% of retirees were not satisfied at all, compared with 30.6% of full-time workers. Holding age, education, marital status and income constant, retirees had about a third of the odds (OR 0.33, 95% CI 0.22 to 0.50).
- **Divorced and separated adults are much more likely to be dissatisfied.** 46.3% were not satisfied at all, twice the share of married adults (22.7%). At the same age, education, work status and income, they had about 2.3 times the odds (OR 2.29, 95% CI 1.70 to 3.08).

These are associations, not causes. See [Limitations](reports/limitations.md).

## What I expected vs what I found

I wrote my expectations down before seeing the results, and committed both sets to this repo before the results they predict.

**Before any analysis (29 September 2026)**

| Characteristic | I expected                                                                         | What I found                                                                                                                                        |
| -------------- | ---------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------- |
| Age            | Older people may have higher financial satisfaction levels.                        | Mostly right: adults 65+ were the least dissatisfied (19.0%), but the younger age groups didn't clearly differ.                                     |
| Education      | People with higher degrees will have higher financial satisfaction levels          | Right: dissatisfaction fell from 42.5% to 14.8% as education rose.                                                                                  |
| Work status    | People with good employment status have higher financial satisfaction levels.      | Partly right: unemployed adults were the most dissatisfied (51.2%), but retirees (14.9%) were far less dissatisfied than full-time workers (30.6%). |
| Marital status | People with married marital status have higher financial satisfaction levels.      | Right: 22.7% of married adults vs 46.3% of divorced or separated adults.                                                                            |
| Income         | People with higher family income banded have higher financial satisfaction levels. | Right, with a twist: the two lowest bands were about the same; the big drop came at $110k+.                                                         |

**After the crosstabs, before the model (1 October 2026): what happens once income is held constant?**

| Characteristic | I expected | What the model showed                                                           |
| -------------- | ---------- | ------------------------------------------------------------------------------- |
| Age            | Weakens    | Not supported: the age differences didn't weaken.                               |
| Education      | Stays      | Partly right: it weakened a lot; only a graduate degree still clearly mattered. |
| Work status    | Stays      | Right, because of retirees; the unemployed no longer clearly differed.          |
| Marital status | Stays      | Right: divorced or separated and never-married adults still had higher odds.    |

## How to reproduce

You need R (this project used 4.2.1), [Quarto](https://quarto.org) 1.3 or later, and Git.

1. Clone this repo.
2. Download the 2024 GSS data as described in [data-raw/README.md](data-raw/README.md).
3. From the project folder, install the exact package versions used:
   `Rscript -e "renv::restore()"`
4. Rebuild everything: `Rscript run_all.R`

`run_all.R` reruns the cleaning, checks, tables, charts and model, renders the
report, and copies it to `docs/index.html`, which GitHub Pages publishes.

## Repo map

| Path                 | What it holds                                                                |
| -------------------- | ---------------------------------------------------------------------------- |
| `run_all.R`          | Rebuilds everything with one command                                         |
| `R/`                 | The analysis scripts, run in order from `01_clean.R` to `06_model.R`         |
| `reports/`           | The report source (`report.qmd`), the limitations section and a findings log |
| `docs/`              | The published report (`index.html`), served by GitHub Pages                  |
| `outputs/`           | Tables (CSV and HTML) and charts (PNG)                                       |
| `data-raw/`          | Download instructions; the raw data isn't in Git                             |
| `data/`              | Working files the scripts create (not in Git)                                |
| `data_dictionary.md` | Every variable in the clean analysis file                                    |
| `renv.lock`, `renv/` | The exact package versions used                                              |

## Limitations and next steps

- These are associations from a one-time survey, not causes.
- The 2024 GSS mixed web, in-person and phone interviews, and changes since 2021 may partly reflect method changes, so comparisons with earlier years need care.
- Small groups, such as the 165 unemployed respondents, have wide confidence intervals.
- Next: use all three satisfaction answers in an ordinal model, and add home ownership and health, which were asked of only part of the sample.

Full details: [reports/limitations.md](reports/limitations.md), also in the report.

## Contact

Adeel Manaf · [your email] · [your LinkedIn URL]
