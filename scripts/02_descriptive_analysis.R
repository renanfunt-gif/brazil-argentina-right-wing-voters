source("R/utils.R")

suppressPackageStartupMessages({
  library(ggplot2)
  library(here)
})

input_path <- here("data", "processed", "brazil_argentina_combined.csv")
if (!file.exists(input_path)) {
  stop("Run scripts/01_data_cleaning.R first.")
}

data <- read_csv(input_path, show_col_types = FALSE)

summary_table <- data %>%
  group_by(country) %>%
  summarize(
    n = n(),
    target_vote_share = mean(target_vote, na.rm = TRUE),
    avg_ideology = mean(as.numeric(ideology), na.rm = TRUE),
    avg_age = mean(as.numeric(age), na.rm = TRUE)
  )

write_csv(summary_table, here("outputs", "tables", "descriptive_summary.csv"))

plot_vote <- data %>%
  filter(!is.na(target_vote)) %>%
  ggplot(aes(x = country, fill = factor(target_vote))) +
  geom_bar(position = "fill") +
  scale_y_continuous(labels = scales::percent_format()) +
  labs(
    title = "Share of Bolsonaro/Milei Voters by Country",
    x = NULL,
    y = "Share of respondents",
    fill = "Target vote"
  ) +
  theme_minimal()

ggsave(
  filename = here("outputs", "figures", "target_vote_share_by_country.png"),
  plot = plot_vote,
  width = 8,
  height = 5
)

message("Descriptive analysis complete. Outputs in outputs/tables and outputs/figures.")
