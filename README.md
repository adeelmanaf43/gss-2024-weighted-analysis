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

**After holding income constant** (written 1 October 2026, after the crosstabs and before the model), I expect:

**After holding income constant** (written 1 October 2026, after the crosstabs and before the model), I expect:

- Age: weakens, because I expect a younger and an older person with the same income to feel about the same.
- Education: stays, because at the same income, people with more education may have easier, more comfortable jobs, while people with less education may have to work harder to earn the same.
- Work status: stays, because unemployed and part-time workers may feel insecure about their future earnings, while full-time workers feel more secure in their jobs.
- Marital status: stays, because a married person's partner can keep earning if they lose their job, while a single person who loses their job has no one to fall back on.

## Approach

## Key findings

## How to reproduce

## Repo map

## Limitations and next steps

## Limitations

**Survey mode.** The 2024 GSS was collected in several ways: about half of the
main-sample respondents answered online, about a third in person, and the rest by
phone or a mix of modes. People can answer the same question differently depending
on how it's asked; on the web, for example, opinion questions like this one don't
offer a "Don't know" option. NORC advises analyzing the sample as a whole rather than
by mode, and its weights are designed only for the whole sample. This analysis follows
that advice and never splits results by mode, but its estimates still reflect this mix
of modes.

**Comparing with earlier years.** The GSS changed its methods during the COVID-19
pandemic: it was collected mostly online in 2021 and in a mix of modes from 2022.
This analysis uses only 2024 data and makes no claims about change over time. Anyone
comparing these results with GSS figures from before 2020 should keep NORC's caution
in mind:

> Changes in opinions, attitudes, and behaviors observed in 2021, 2022, and 2024
> relative to historical trends may be due to actual change in concept over time
> and/or may have resulted from methodological changes made to the survey methodology
> during the COVID-19 global pandemic.

**Who answered: weights and nonresponse.** Only 44.6% of the people sampled for the
main survey took part. The weight used here (WTSSNRPS) adjusts for this nonresponse
and matches the sample to Census population figures, but weights can only correct for
differences in known characteristics, such as age and region, not for unknown ones.
Weighting changed the estimates by up to 2.4 percentage points. The 677 respondents
from NORC's AmeriSpeak oversample were left out of the main analysis: all of them
answered online, and their response rate was 3.5% once panel recruitment is counted.
Including them changed the estimates by less than 1 point.

**Questions asked of only part of the sample.** The GSS splits respondents into three
ballots, and most of its core questions go to only two of them. This analysis uses
only questions asked on all three ballots, and checks that each ballot has answers for
every variable. The cost is that some relevant measures, such as home ownership and
self-rated health, were asked on only two ballots and were left out.

**Missing answers.** About 1 in 10 respondents didn't report their family income.
Rather than dropping them, this analysis keeps them as a "Not reported" income group;
this is a simple fix, not a full statistical method for missing data. The model uses
3,173 of the 3,309 main-sample respondents (96%); the rest skipped at least one
question, most often their age. If people who skip questions differ from those who
answer, the estimates could be slightly off.

**Small groups.** Some groups have few respondents, so their estimates are imprecise.
Unemployed adults (165 respondents) have a 95% confidence interval of 38% to 64%, and
widowed adults (247) of 20% to 40%. These groups shouldn't be ranked against similar
groups; in the model, the difference for unemployed adults is also no longer clear
(OR 1.66, 95% CI 0.94 to 2.95).

**Associations, not causes.** The GSS is a one-time survey, so these results show
which groups are more or less dissatisfied, not what causes dissatisfaction. Divorce
may lead to money worries, for example, but money worries can also contribute to
divorce. Age and retirement also overlap so much that the model can't fully separate
them: that the advantage of adults aged 65+ comes from retirement rather than age is
the most likely reading, not a proven one.

**How things were measured.** Income is last year's total family income, reported in
bands. It doesn't capture savings, debts, household size or local living costs, and
the top band ($110k+) includes all higher incomes. The outcome compares "not satisfied
at all" with the other two answers, and a different split might give somewhat
different results. Some groups also combine different situations: "Other" work status
includes people temporarily off work, in school or keeping house, and divorced and
separated adults are combined into one group.

## Next steps

- **Use all three satisfaction answers.** Fit an ordinal model (`svyolr()` in the
  survey package) to check that the results don't depend on how the outcome was split.
- **Add wealth and health measures.** Analyze ballots A and B on their own, adding
  home ownership and self-rated health, to test the "security" idea suggested by the
  retiree results.
- **Check results by mode** once NORC releases mode-specific weights, which it plans
  for future releases.
- **Compare with the 2022 GSS,** keeping NORC's caution about method changes in mind.

## Contact
