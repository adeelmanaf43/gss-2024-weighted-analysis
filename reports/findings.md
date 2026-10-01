# Findings log

Draft results, collected as the analysis runs. They feed the Quarto report
(Session 5) and the README's key findings (Session 6).

## Overall financial satisfaction

Source: Table 1 (`outputs/table1_satfin_estimates.csv`, made by `R/03_design.R`)

- In 2024, 31% of U.S. adults (95% CI: 28% to 33%) were not satisfied at all
  with their financial situation, and only 23% were pretty well satisfied.
- Weighting changed the estimates by up to 2.4 percentage points; including the
  AmeriSpeak oversample changed them by less than 1 point.

## Financial satisfaction by group

Source: Table 2 (`outputs/table2_crosstabs.html`, made by `R/04_crosstabs.R`)

- Every characteristic was linked to financial satisfaction (Rao-Scott tests, all p < 0.001).
- Most dissatisfied ("not satisfied at all"): unemployed (51.2%, from only 165 people),
  divorced or separated (46.3%), family income under $30k (43.1%), less than high
  school (42.5%).
- Least dissatisfied: family income $110k+ (12.8%), graduate degree (14.8%), retired
  (14.9%), age 65+ (19.0%).
- Education: dissatisfaction falls steadily, from 42.5% (less than high school) to
  14.8% (graduate degree).
- Income: the two lowest bands are almost the same (43.1% and 42.5%); dissatisfaction
  drops to 31.2% at $60k-$109k and 12.8% at $110k+. Non-reporters: 35.5%.
- Retirees (14.9%) were about half as likely as full-time workers (30.6%) to be not
  satisfied at all.
- Still to check: these compare one characteristic at a time, and groups overlap
  (retired and 65+; education and income). The model (Hour 8) separates them. Small
  groups such as the unemployed (n = 165) are less precise; the charts (Hour 7)
  show their 95% CIs.

## Dissatisfaction by group, with 95% CIs

Source: Figures 1-5 (`outputs/fig1_age.png` to `outputs/fig5_income.png`) and
`outputs/estimates_by_group.csv`, made by `R/05_charts.R`

- Age: adults 65+ are clearly the least dissatisfied (19.0%, 95% CI 15.2-23.4). The
  three younger groups overlap (31.5%, 37.4%, 31.9%), so they don't clearly differ.
- Education: the clear drops come with a bachelor's degree (23.8%, CI 19.9-28.2) and a
  graduate degree (14.8%, CI 11.0-19.7). High school (35.0%) and associate (34.0%)
  are about the same.
- Work status: retirees (14.9%, CI 11.8-18.5) are half as likely as full-time workers
  (30.6%, CI 27.3-34.2) to be dissatisfied. Unemployed adults are clearly above
  full-time workers (51.2%, CI 38.2-64.1), but with only 165 respondents they can't
  be ranked against part-time or "other" workers.
- Marital status: divorced or separated adults (46.3%, CI 41.4-51.3) are twice as
  likely as married adults (22.7%, CI 19.9-25.8) to be dissatisfied. The widowed
  estimate is too uncertain to interpret (28.8%, CI 19.7-40.2; n = 247).
- Income: dissatisfaction is flat below $60k (43.1% and 42.5%), then falls to 31.2%
  at $60k-$109k and 12.8% at $110k+, with no overlap between these steps.
- Check: the chart estimates match Table 2 exactly, from a different script.

## Model: which characteristics are still linked once income is held constant?

Source: Table 3 (`outputs/table3_model.html`, made by `R/06_model.R`). Weighted logistic
regression of "not satisfied at all", n = 3,173. Odds ratios are from the model with
income, so each one holds all the other characteristics constant.

- All four characteristics stay linked to dissatisfaction once income is held constant
  (overall tests: age p = 0.006, education p = 0.011, work status and marital status
  p < 0.0001).
- At the same age, education, marital status and income, retirees had about a third of
  the odds of full-time workers of being not satisfied at all with their finances
  (OR 0.33, 95% CI 0.22 to 0.50).
- At the same age, education, work status and income, divorced or separated adults had
  about 2.3 times the odds of married adults of being not satisfied at all with their
  finances (OR 2.29, 95% CI 1.70 to 3.08).
- At the same age, work status, marital status and income, adults with a graduate degree
  had about half the odds of adults without a high school diploma of being not satisfied
  at all with their finances (OR 0.48, 95% CI 0.30 to 0.78).
- At the same age, education, work status and marital status, adults with a family income
  of $110k or more had a quarter of the odds of adults with under $30k of being not
  satisfied at all with their finances (OR 0.25, 95% CI 0.16 to 0.39).
- At the same education, work status, marital status and income, adults aged 30-44 had
  about twice the odds of adults aged 18-29 of being not satisfied at all with their
  finances (OR 2.01, 95% CI 1.34 to 3.01).
- Adults aged 65+ were the least dissatisfied age group in the crosstabs (19.0%), but once
  work status is held constant, they no longer clearly differ from adults aged 18-29
  (OR 1.30, 95% CI 0.75 to 2.27). Most adults aged 65+ are retired, so the model credits
  their advantage to retirement rather than age. Because age and retirement overlap so
  much, this is the most likely reading, not a proven one.

### Predictions vs results (predictions written 1 October 2026, before the model)

- Age, predicted to weaken: not supported. The age differences did not weaken when income
  was added; the odds ratios for ages 30-44 and 45-64 moved slightly away from 1.
- Education, predicted to stay: partly right. It weakened a lot once income was added: the
  bachelor's degree no longer clearly differs, but a graduate degree still does (OR 0.48).
- Work status, predicted to stay: right, but because of retirees (OR 0.33, even stronger
  once income is held constant), not the unemployed (OR 1.66, no longer clear) or
  part-time workers (OR 1.02).
- Marital status, predicted to stay: right. Divorced or separated (OR 2.29) and never
  married (OR 1.41) weakened a little but stayed clear.
