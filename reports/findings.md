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
