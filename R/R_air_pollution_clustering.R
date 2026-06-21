############################################################
# Project: Clustering Polish voivodeships by air pollution profile
# Data source: Statistics Poland, Local Data Bank (BDL)
# Year: 2024
# Method: PAM clustering and silhouette analysis
#
# Input files:
# - data/raw/emisje_do_powietrza.xlsx
# - data/raw/zaklady_uciazliwe.xlsx
# - data/raw/zanieczyszczenia_zatrzymane.xlsx
#
# Output files:
# - output/silhouette_plot.png
# - output/silhouette_results.csv
# - data/processed/voivodeship_clusters.csv
# - output/cluster_summary.csv
############################################################

# --- 0) Packages ---
# Required packages:
# install.packages(c("readxl", "dplyr", "cluster", "here", "ggplot2"))
#
# readxl: loading data from Excel
# dplyr: cleaning and merging data
# cluster: PAM + silhouette analysis
# here: project-root relative file paths
# ggplot2: data visualization
# readxl: loading data from Excel

library(readxl)
library(dplyr)
library(cluster)
library(here)
library(ggplot2)

dir.create(here("data", "processed"), recursive = TRUE, showWarnings = FALSE)
dir.create(here("output"), recursive = TRUE, showWarnings = FALSE)

# --- 1) Function for loading BDL Excel tables ---
# BDL Excel files contain multiple sheets. This function loads the sheet named "TABLICA".
# The function checks whether the sheet exists, imports the data, and converts numeric columns.

read_bdl_table <- function(path, sheet_name = "TABLICA") {
  sheets <- excel_sheets(path)
  
  if (!sheet_name %in% sheets) {
    stop(
      paste0(
        "The file '", path, "' does not contain the sheet '", sheet_name,
        "'. Available sheets: ", paste(sheets, collapse = ", ")
      )
    )
  }
  
  read_excel(path, sheet = sheet_name) |>
    filter(!is.na(Kod)) |>
    mutate(
      Kod = as.integer(Kod),
      across(-c(Kod, Nazwa), ~ as.numeric(.x))
    )
}

# --- 2) Load input data from Excel files ---

emissions <- read_bdl_table(here("data", "raw", "emisje_do_powietrza.xlsx"))
plants <- read_bdl_table(here("data", "raw", "zaklady_uciazliwe.xlsx"))
retained <- read_bdl_table(here("data", "raw", "zanieczyszczenia_zatrzymane.xlsx"))

# --- 3) Join datasets and create analytical variables ---

data_joined <- emissions |>
  inner_join(plants, by = c("Kod", "Nazwa"), suffix = c("", "_plants")) |>
  inner_join(retained, by = c("Kod", "Nazwa"))

analysis_data <- data_joined |>
  transmute(
    voivodeship = Nazwa,
    
    emission_per_km2 = `emisja ogółem na km2`,
    so2_per_capita = `dwutlenek siarki na 1 mieszkańca`,
    nox_per_capita = `tlenki azotu na 1 mieszkańca`,
    
    plants_total = `ogółem_plants`,
    dust_reduction_share = `wyposażone w urządzenia do redukcji zanieczyszczeń pyłowych` / `ogółem_plants`,
    gas_reduction_share = `wyposażone w urządzenia do redukcji zanieczyszczeń gazowych` / `ogółem_plants`,
    
    retained_dust_per_plant = pyłowe / `ogółem_plants`,
    retained_gas_per_plant = gazowe / `ogółem_plants`
  )

# --- 4) Prepare data for clustering ---
# PAM clustering is performed on numeric variables only.
# Variables are standardized because they are measured on different scales.

clustering_variables <- analysis_data |>
  select(
    emission_per_km2,
    so2_per_capita,
    nox_per_capita,
    plants_total,
    dust_reduction_share,
    gas_reduction_share,
    retained_dust_per_plant,
    retained_gas_per_plant
  )

clustering_scaled <- scale(clustering_variables)

# --- 5) Select the number of clusters using silhouette analysis ---
# - output/silhouette_results.csv

set.seed(123)

k_values <- 2:8

silhouette_scores <- sapply(k_values, function(k) {
  pam_fit <- pam(clustering_scaled, k = k)
  pam_fit$silinfo$avg.width
})

silhouette_results <- data.frame(
  k = k_values,
  average_silhouette_width = silhouette_scores
)

best_k <- silhouette_results$k[
  which.max(silhouette_results$average_silhouette_width)
]

silhouette_results
best_k

write.csv(
  silhouette_results,
  here("output", "silhouette_results.csv"),
  row.names = FALSE
)

# --- 6) Plot silhouette scores ---

silhouette_plot <- ggplot(
  silhouette_results,
  aes(x = k, y = average_silhouette_width)
) +
  geom_line() +
  geom_point() +
  geom_vline(xintercept = best_k, linetype = "dashed") +
  scale_x_continuous(breaks = k_values) +
  labs(
    title = "Selection of the number of clusters using silhouette analysis",
    x = "Number of clusters (k)",
    y = "Average silhouette width"
  ) +
  theme_minimal()

silhouette_plot

ggsave(
  filename = here("output", "silhouette_plot.png"),
  plot = silhouette_plot,
  width = 8,
  height = 5,
  dpi = 300
)

# --- 7) Run final PAM clustering ---

final_pam <- pam(clustering_scaled, k = best_k)

clustering_output <- analysis_data |>
  mutate(cluster = factor(final_pam$clustering))

clustering_output |>
  select(voivodeship, cluster)

# --- 8) Save clustering results ---

write.csv(
  clustering_output |> select(voivodeship, cluster),
  here("data", "processed", "voivodeship_clusters.csv"),
  row.names = FALSE
)

# --- 9) Summarise cluster profiles ---

cluster_summary <- clustering_output |>
  group_by(cluster) |>
  summarise(
    n = n(),
    across(
      where(is.numeric),
      ~ mean(.x, na.rm = TRUE)
    ),
    .groups = "drop"
  )

cluster_summary

write.csv(
  cluster_summary,
  here("output", "cluster_summary.csv"),
  row.names = FALSE
)

############################################################
# End of script.
# Next step: prepare the project report and README file.
############################################################

