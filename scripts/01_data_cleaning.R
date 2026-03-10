source("R/utils.R")

suppressPackageStartupMessages({
  library(haven)
  library(janitor)
  library(here)
})

check_packages()

mapping <- load_variable_mapping()

brazil_path <- here("data", "raw", "lapop_brazil_2018_2019.dta")
argentina_path <- here("data", "raw", "lapop_argentina_2023.dta")

if (!file.exists(brazil_path) || !file.exists(argentina_path)) {
  stop("Upload raw LAPOP files to data/raw/ before running this script.")
}

brazil_raw <- read_dta(brazil_path) %>% clean_names()
argentina_raw <- read_dta(argentina_path) %>% clean_names()

extract_standardized <- function(data, country_name, mapping_df) {
  map_row <- mapping_df %>% filter(country == country_name)
  if (nrow(map_row) == 0) stop("Missing mapping row for ", country_name)

  # Replace placeholders in config/variable_mapping.csv with real LAPOP variable names.
  cols <- c(
    id = map_row$id_var,
    vote = map_row$vote_choice_var,
    ideology = map_row$ideology_var,
    income = map_row$income_var,
    education = map_row$education_var,
    weight = map_row$weight_var,
    urban = map_row$urban_var,
    gender = map_row$gender_var,
    age = map_row$age_var
  )

  renamed <- data %>%
    safe_select(unname(cols)) %>%
    rename(!!!setNames(names(cols), unname(cols))) %>%
    mutate(country = country_name)

  renamed
}

brazil <- extract_standardized(brazil_raw, "Brazil", mapping)
argentina <- extract_standardized(argentina_raw, "Argentina", mapping)

# Update target labels after reviewing LAPOP codebooks.
brazil <- brazil %>%
  mutate(target_vote = binary_vote_target(vote, c("Bolsonaro", "Jair Bolsonaro")))

argentina <- argentina %>%
  mutate(target_vote = binary_vote_target(vote, c("Milei", "Javier Milei")))

combined <- bind_rows(brazil, argentina)

write_csv(brazil, here("data", "processed", "brazil_2018_clean.csv"))
write_csv(argentina, here("data", "processed", "argentina_2023_clean.csv"))
write_csv(combined, here("data", "processed", "brazil_argentina_combined.csv"))

message("Data cleaning complete. Processed files saved in data/processed/.")
