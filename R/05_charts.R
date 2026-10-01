# 05_charts.R
# Charts: share "not satisfied at all" by group, with 95% CIs (Figures 1-5).
# Input: data/design_main.rds (made by R/03_design.R)
# Output: outputs/fig1_age.png ... outputs/fig5_income.png
#         outputs/estimates_by_groups.csv (the numbers behind the charts)

library(dplyr)
library(srvyr)
library(ggplot2)

options(survey.lonely.psu = "adjust") # same setting as in 03_design.R

desig_main <- readRDS("data/design_main.rds")

# Chart colors: one blue for the data, grays for everything else
col_dots       <- "#2a78d6"       # dots and interval lines
col_surface    <- "#fcfcfb"       # background
col_text       <- "#0b0b0b"       # title
col_text2      <- "#52514e"       # subtitle and group names
col_muted      <- "#898781"       # axis numbers, caption, reference line
col_grid       <- "#e1e0d9"       # gridlines


# 1. Share of all adults, for the reference line --------------------------------------------------------------------------------------------
national <- design_main |>
  filter(!is.na(not_satisfied)) |>
  summarise(pct = survey_mean(not_satisfied)) |>
  pull(pct)

# 2. Share "not satisfied at all" in each group, with 95% CIs -------------------------------------------------------------------------------
estimate_by <- function(design, group_var){
  design |>
    filter(!is.na(not_satisfied), !is.na({{group_var}})) |>
    group_by({{group_var}}) |>
    summarise(
      pct = survey_mean(not_satisfied, vartype = "ci", proportion = TRUE),
      n = unweighted(n())   # real number of respondents
    ) |>
    rename(group = {{group_var}}) |>
    mutate(group = as.character(group),
           label = paste0(group, " (n = ", n, ")"))
}

est <- list(
  age             = estimate_by(desig_main,age_group),
  education       = estimate_by(desig_main, education),
  work_status     = estimate_by(design_main, work_status),
  marital_status  = estimate_by(design_main, marital_status),
  income          = estimate_by(design_main, income_group)
)


# The numbers behind the charts, in percent

estimates <- bind_rows(est, .id = "characteristic") |>
  mutate(across(c(pct, pct_low, pct_upp), ~ round(100 * .x, 1))) |>
  select(characteristic, group, n, pct, pct_low, pct_upp)
print(estimates, n = 30)
write.csv(estimates, "outputs/estimates_by_group.csv", row.names = FALSE)

# 3. One chart style for every chart --------------------------------------------------------------------------------------------------------
theme_gss <- function(){
  theme_minimal(base_size = 11) +
    theme(plot.background       = element_rect(fill= col_surface, colour = NA),
          plot.title.position   = "plot",
          plot.caption.position = "plot",
          plot.title      = element_text(face = "bold", size = 13, colour = col_text),
          plot.subtitle   = element_text(colour = col_text2, margin = margin(b = 12)),
          plot.caption    = element_text(colour = col_muted, size = 8.5, hjust = 0,
                                         margin = margin(t=12)),
          axis.text.y     = element_text(coloyr = col_text2, size = 10),
          axis.text.x     = element_text(colour = col_muted),
          panel.grid.major.x = element_line(colour = col_grid, linewidth = 0.3),
          panel.grid.major.y = element_blank(),
          panel.grid.minor   = element_blank(),
          plot.margin = margin(14, 18, 12, 12)
          )
}

plot_groups <- function(data, title, file, sort = FALSE){
  # Order the groups: by share for groups with no natural order, otherwise as is
  if (sort){
    data <- mutate(data, label = reorder(label, pct))                 # highest share at the top
  } else {
    data <- mutate(data, label = factor(label, levels = rev(label)))  # first group at teh top
  }


  p <- ggplot(data, aes(x = pct, y = label))+
    # Reference line: all U.S. adults
    geom_vline(xintercept = national, colour = col_muted, linewidth = 0.5) +
    annotate("text", x = national + 0.008, y = nrow(data) + 0.6, hjust = 0, size = 3.2, colour = col_text2,
             label = paste0("All U.S. adults:", round(100 * national), "%")) +
    # 95% confidence interval (line) and estimate (dot)
    geom_linerange(aes(xmin = pct_low, xmax = pct-upp), orientation = "y",
                   color = col_dots, linewidth = 0.7) +
    geom_point(shape = 21, size = 3.2, fill = col_dots, colour = col_surface,
               stroke = 0.9) +
    scale_x_continuous(labels = scales::label_percent(),
                       breaks = seq(0, 0.7, by = 0.1)) +
    scale_y_continuous(labels = scales::label_percent(),
                       breaks= seq(0, 0.7, by= 0.1)) +
    scale_y_discrete(expand = expansion(add = c(0.6, 1))) +
    coord_cartesian(xlim = c(0, 0.7)) +
    labs(
      title = paste(strwrap(title, width = 70), collapse = "\n"), # wrap long titles
      subtitle = "% not satisfied at all with their financial situation. Lines show 95% confidence intervals.",
      caption  = "Source: 2024 General Social Survey (NORC), main sample, weighted. n = respondents in each group.",
      x = NULL, y = NULL
    ) + 
    theme_gss()
    
  
  ggsave(file, p, width = 8, height = 4.5,dpi = 300)
  
  
}

# 4. Draw and save the five charts -----------------------------------------------------------------------------------------------------------
plot_groups(est$age,
            "Adults 65 and older are the least likely to be dissatisfied",
            "outputs/fig1_age.png")
plot_groups(est$education,
            "Dissatisfaction falls as education rises",
            "outputs/fig2_education.png")
plot_groups(est$work_status,
            "Retirees are half as likely as full-time workers to be dissatisfied",
            "outputs/fig3_work_status.png", sort = TRUE)
plot_groups(est$marital_status,
            "Divorced or separated adults are twice as likely as married adults to be dissatisfied",
            "outputs/fig4_marital_status.png", sort = TRUE)
plot_groups(est$income,
            "Dissatisfaction is flat below $60k and falls sharply above it",
            "outputs/fig5_income.png")
  
  
  
  
  
  
  