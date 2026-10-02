# run_all.R
# Rebuilds the whole project from the raw data with one command
# Rscript run_all.R
# Run it from the project folder. It need the raw GSS file
# (download steps in data-raw/README.md)


# 0. Check we are in right place and the raw data is there ----------------------------------
if (!file.exists("_quarto.yml")) {
  stop("Run this script from the project folder.")
}
if (!file.exists("data-raw/GSS2024.dta")) {
  stop("data-raw/GSS2024.dta not found. Follow the steps in data-raw/README.md first.")
}


# 1. Run the analysis scripts in order ------------------------------------------------------
scripts <- c(
  "R/01_clean.R",          # raw file -> clean analysis file
  "R/02_validate.R",       # checks; stops if anything is wrong
  "R/03_design.R",         # survey design and table 1
  "R/04_crosstabs.R",      # Table 2
  "R/05_charts.R",         # Figures 1-5
  "R/06_model.R"           # Table 3
)

for (script in scripts) {
  message("\n==Running ", script)
  source(script, local = new.env()) # each script runs in a clean workspace
}


# 2. Render the report -----------------------------------------------------------------------
message("\n== Rendering reports/report.qmd")
exit_code <- system2("quarto", c("render", "reports/report.qmd"))
if (exit_code != 0) stop("Quarto could not render the report.")


# 3. Copy the report to docs/, which Github Pages publishes ----------------------------------
dir.create("docs", showWarnings = FALSE)
invisible(file.copy("reports/report.html", "docs/index.html", overwrite = TRUE))
invisible(file.create("docs/.nojeky11"))   # tells Github Pages to publish the file as it is

message("\nDone: report rebuild and copied to docs/index.html")

