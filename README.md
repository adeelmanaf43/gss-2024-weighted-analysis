# Weighted Survey Analysis of the 2024 General Social Survey

_One-line summary and link to the live report (Session 6)_

## The question

Which U.S. adults were most and least satisfied with their financial situation in 2024, and which characteristics are still linked to financial dissatisfaction once income is taken into account?

## Data

- 2024 General Social Survey cross-section, NORC (Release 3a): [GSS data downloads](https://gss.norc.org/get-the-data.html)
- Raw data is not stored in this repo. Download steps: [data-raw/README.md](data-raw/README.md)
- Variable details: [data_dictionary.md](data_dictionary.md)

Expectations below were written on 29 September 2026, before any results were seen.

| Role      | GSS variable | What it measures                      | Asked of in 2024 | What I expect                                                                      |
| --------- | ------------ | ------------------------------------- | ---------------- | ---------------------------------------------------------------------------------- |
| Outcome   | SATFIN       | Satisfaction with financial situation | Ballots A, B, C  | –                                                                                  |
| Predictor | AGE          | Age group                             | Ballots A, B, C  | Older people may have higher financial satisfaction levels.                        |
| Predictor | DEGREE       | Highest degree                        | Ballots A, B, C  | People with higher degrees will have higher financial satisfaction levels          |
| Predictor | WRKSTAT      | Employment status                     | Ballots A, B, C  | People with good employment status have higher financial satisfaction levels.      |
| Predictor | MARITAL      | Marital status                        | Ballots A, B, C  | People with married marital status have higher financial satisfaction levels.      |
| Predictor | INCOME16     | Family income, banded                 | Ballots A, B, C  | People with higher family income banded have higher financial satisfaction levels. |

Weighting decision: the main analysis uses the 3,309 main-sample respondents with WTSSNRPS, NORC's recommended weight. All 3,986 respondents (including the AmeriSpeak oversample, weight WTSSNRPS_AS) are used as a sensitivity check.

## Approach

## Key findings

## How to reproduce

## Repo map

## Limitations and next steps

## Contact
