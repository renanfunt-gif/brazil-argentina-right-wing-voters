# brazil-argentina-right-wing-voters

Comparative analysis of the 2018 Brazilian and 2023 Argentine elections using LAPOP survey data, focused on predictors of voting for Jair Bolsonaro (Brazil) and Javier Milei (Argentina).

## Project structure

```text
.
├── config/
│   └── variable_mapping.csv         # map LAPOP variable names to standardized fields
├── data/
│   ├── raw/
│   │   └── README.md                # upload instructions for LAPOP files
│   └── processed/                   # generated clean datasets
├── outputs/
│   ├── figures/                     # generated charts
│   └── tables/                      # descriptive + regression outputs
├── R/
│   └── utils.R                      # helper functions
└── scripts/
    ├── 00_run_all.R
    ├── 01_data_cleaning.R
    ├── 02_descriptive_analysis.R
    └── 03_regression_models.R
```

## Setup

1. Install R (>= 4.2 recommended).
2. Install packages:
   ```r
   install.packages(c(
     "tidyverse", "haven", "janitor", "broom", "modelsummary", "here", "scales"
   ))
   ```
3. Upload raw LAPOP files into `data/raw/` following `data/raw/README.md`.
4. Edit `config/variable_mapping.csv` and replace placeholders with real LAPOP variable names from your questionnaires/codebooks.

## Workflow

Run scripts in order:

```bash
Rscript scripts/01_data_cleaning.R
Rscript scripts/02_descriptive_analysis.R
Rscript scripts/03_regression_models.R
```

Or run everything at once:

```bash
Rscript scripts/00_run_all.R
```

## Outputs

- `data/processed/brazil_2018_clean.csv`
- `data/processed/argentina_2023_clean.csv`
- `data/processed/brazil_argentina_combined.csv`
- `outputs/tables/descriptive_summary.csv`
- `outputs/figures/target_vote_share_by_country.png`
- `outputs/tables/regression_results.html`
- `outputs/tables/regression_tidy_coefficients.csv`

## Notes

- The scripts are scaffolded for LAPOP 2018/19 Brazil and 2023 Argentina and require variable mapping before first run.
- The target vote coding in `scripts/01_data_cleaning.R` should be adjusted to match your exact vote response labels/codes.
