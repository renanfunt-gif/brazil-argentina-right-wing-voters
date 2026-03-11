source("R/utils.R")

suppressPackageStartupMessages({
  library(broom)
  library(modelsummary)
  library(here)
})

input_path <- here("data", "processed", "brazil_argentina_combined.csv")
if (!file.exists(input_path)) {
  stop("Run scripts/01_data_cleaning.R first.")
}

data <- read_csv(input_path, show_col_types = FALSE) %>%
  mutate(
    ideology = as.numeric(ideology),
    income = as.numeric(income),
    education = as.numeric(education),
    age = as.numeric(age),
    country = factor(country)
  )

model_brazil <- glm(
  target_vote ~ ideology + income + education + age + gender + urban,
  data = filter(data, country == "Brazil"),
  family = binomial(link = "logit")
)

model_argentina <- glm(
  target_vote ~ ideology + income + education + age + gender + urban,
  data = filter(data, country == "Argentina"),
  family = binomial(link = "logit")
)

model_pooled <- glm(
  target_vote ~ country * ideology + income + education + age + gender + urban,
  data = data,
  family = binomial(link = "logit")
)

modelsummary(
  list(
    "Brazil (Bolsonaro)" = model_brazil,
    "Argentina (Milei)" = model_argentina,
    "Pooled Interaction" = model_pooled
  ),
  output = here("outputs", "tables", "regression_results.html")
)

bind_rows(
  tidy(model_brazil) %>% mutate(model = "brazil"),
  tidy(model_argentina) %>% mutate(model = "argentina"),
  tidy(model_pooled) %>% mutate(model = "pooled")
) %>%
  write_csv(here("outputs", "tables", "regression_tidy_coefficients.csv"))

message("Regression models complete. Results saved in outputs/tables/.")
