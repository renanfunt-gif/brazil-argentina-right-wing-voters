suppressPackageStartupMessages({
  library(dplyr)
  library(readr)
  library(stringr)
  library(tidyr)
})

required_packages <- c(
  "tidyverse",
  "haven",
  "janitor",
  "broom",
  "modelsummary",
  "here"
)

check_packages <- function(pkgs = required_packages) {
  missing <- pkgs[!vapply(pkgs, requireNamespace, FUN.VALUE = logical(1), quietly = TRUE)]
  if (length(missing) > 0) {
    message("Install missing packages with:\ninstall.packages(c(",
            paste(sprintf('"%s"', missing), collapse = ", "), "))")
  }
  invisible(missing)
}

load_variable_mapping <- function(path = "config/variable_mapping.csv") {
  read_csv(path, show_col_types = FALSE) %>%
    mutate(across(everything(), as.character))
}

safe_select <- function(data, columns) {
  keep <- intersect(columns, names(data))
  data %>% select(all_of(keep))
}

binary_vote_target <- function(vote_vector, target_labels) {
  ifelse(vote_vector %in% target_labels, 1L, 0L)
}
