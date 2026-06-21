# Clustering Polish Voivodeships by Air Pollution Profile

This project applies cluster analysis to classify Polish voivodeships according to their air pollution profile from particularly burdensome industrial plants.

The analysis was performed in R using PAM clustering and silhouette analysis.

## Data

The analysis uses data from Statistics Poland, Local Data Bank (BDL), for 2024.

The input datasets include:

- emissions to air,
- number of particularly burdensome industrial plants,
- retained air pollutants.

The raw data files are stored in:

```text
data/raw/
```

## Methods

The analysis includes:

- loading Excel files from BDL,
- joining datasets by voivodeship code and name,
- creating emission intensity indicators,
- standardizing numerical variables,
- selecting the number of clusters using average silhouette width,
- applying PAM clustering.


The following variables were used in the clustering procedure:

- emission per km²,
- SO₂ emission per capita,
- NOx emission per capita,
- total number of particularly burdensome plants,
- share of plants equipped with dust reduction devices,
- share of plants equipped with gas reduction devices,
- retained dust pollutants per plant,
- retained gas pollutants per plant.

## Results

The highest average silhouette width was obtained for `k = 2`.

The final PAM clustering divided the 16 Polish voivodeships into two clusters:

- Cluster 1: 13 voivodeships with lower average emission intensity,
- Cluster 2: 3 voivodeships with substantially higher emission intensity per km² and higher SO₂ and NOx emissions per capita.

The average silhouette width for `k = 2` was approximately 0.397, which indicates moderate cluster separation. Therefore, the results should be interpreted with caution.

## Report

A more detailed interpretation of the results is available in:

```text
reports/air_pollution_clustering_report.md
```

## Output files

The script generates the following output files:

```text
output/silhouette_plot.png
output/silhouette_results.csv
output/cluster_summary.csv
data/processed/voivodeship_clusters.csv
```

## How to run the analysis

Install the required R packages:

```r
install.packages(c("readxl", "dplyr", "cluster", "here", "ggplot2"))
```

Run the analysis script:

```r
source("R/R_air_pollution_clustering.R")
```

## Limitations

The analysis covers only emissions from particularly burdensome industrial plants. It does not include all emission sources, such as transport, residential heating, agriculture, or municipal sources.

The clustering result is based on cross-sectional data for one year only. Future work could extend the analysis by including multiple years and additional environmental indicators.
