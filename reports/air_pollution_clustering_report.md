# Air Pollution Profile Clustering of Polish Voivodeships

## 1. Aim of the analysis

The aim of this project was to classify Polish voivodeships according to their air pollution profile from particularly burdensome industrial plants.

The analysis was based on selected indicators describing emission intensity, the number of industrial plants, and pollution reduction capacity. Cluster analysis was used to identify groups of voivodeships with similar environmental and industrial emission characteristics.

## 2. Data

The analysis was performed using cross-sectional data for 16 Polish voivodeships for the year 2024.

The data were obtained from Statistics Poland, Local Data Bank (BDL), and stored in three Excel files:

- `emisje_do_powietrza.xlsx`,
- `zaklady_uciazliwe.xlsx`,
- `zanieczyszczenia_zatrzymane.xlsx`.

After joining the datasets, eight numerical variables were used in the clustering procedure:

- emission per km²,
- SO₂ emission per capita,
- NOx emission per capita,
- total number of particularly burdensome industrial plants,
- share of plants equipped with dust pollution reduction devices,
- share of plants equipped with gas pollution reduction devices,
- retained dust pollutants per plant,
- retained gas pollutants per plant.

Indicators expressed per km² and per capita were used to reduce the influence of regional size and population on the comparison of voivodeships. This makes it possible to compare regions in terms of emission intensity rather than only total emission volume.

## 3. Methodology

Before clustering, all numerical variables were standardized using z-score standardization. This transformation converts each variable to a mean of 0 and a standard deviation of 1.

Standardization was necessary because the variables were measured on different scales, including emission indicators, shares, and counts of industrial plants. Without standardization, variables with larger numerical values could dominate the clustering result.

The similarity between voivodeships was assessed using Euclidean distance calculated on standardized data.

The final clustering was performed using the PAM method, which stands for Partitioning Around Medoids. PAM is a clustering algorithm similar to k-means, but instead of using centroids, it represents each cluster by an actual observation called a medoid.

The number of clusters was selected using average silhouette width for values of `k` from 2 to 8. The highest average silhouette width was obtained for `k = 2`, so the final solution was based on two clusters.

However, the average silhouette width for `k = 2` was approximately 0.397, which indicates moderate rather than strong cluster separation. Therefore, the results should be interpreted with caution.

## 4. Results

The PAM clustering divided the 16 voivodeships into two clusters.

### Cluster 1

Cluster 1 included 13 voivodeships:

- Dolnośląskie,
- Kujawsko-Pomorskie,
- Lubelskie,
- Lubuskie,
- Mazowieckie,
- Małopolskie,
- Podkarpackie,
- Podlaskie,
- Pomorskie,
- Warmińsko-Mazurskie,
- Wielkopolskie,
- Zachodniopomorskie,
- Śląskie.

This group was characterized by lower average emission intensity compared with Cluster 2.

### Cluster 2

Cluster 2 included 3 voivodeships:

- Opolskie,
- Łódzkie,
- Świętokrzyskie.

This group was characterized by substantially higher emission intensity per km² and higher SO₂ and NOx emissions per capita.

## 5. Interpretation of clusters

The comparison of average variable values between clusters indicates that Cluster 2 represents voivodeships with a higher emission pressure relative to both area and population.

The average emission per km² in Cluster 2 was approximately 1412, compared with approximately 442 in Cluster 1. This means that the average emission intensity in Cluster 2 was more than three times higher.

SO₂ and NOx emissions per capita were also considerably higher in Cluster 2. The average SO₂ emission per capita was approximately 8.47 in Cluster 2 and 2.15 in Cluster 1. The average NOx emission per capita was approximately 10.5 in Cluster 2 and 2.56 in Cluster 1.

These differences do not appear to result only from the number of industrial plants. The average number of particularly burdensome plants was higher in Cluster 1, at approximately 118, than in Cluster 2, at approximately 88. This may suggest that voivodeships in Cluster 2 have more emission-intensive industrial structures or a higher concentration of emissions in fewer plants.

The share of plants equipped with dust pollution reduction devices was similar in both clusters. However, the share of plants equipped with gas pollution reduction devices was lower in Cluster 2 than in Cluster 1.

The amount of retained pollutants per plant was also higher in Cluster 2, especially for dust pollutants. This may indicate a higher scale of industrial emissions and/or more intensive operation of pollution control installations in these voivodeships.

## 6. Limitations

This analysis is based only on emissions from particularly burdensome industrial plants. It does not include all sources of air pollution, such as transport, residential heating, agriculture, or municipal sources.

The analysis is cross-sectional and covers only one year. As a result, it does not show changes over time or long-term trends in regional emission profiles.

The clustering result should also be interpreted with caution because the silhouette value indicates moderate cluster separation. The identified clusters should therefore be treated as an exploratory classification rather than a definitive typology of Polish voivodeships.

## 7. Conclusions

The analysis identified two groups of Polish voivodeships with different air pollution profiles from particularly burdensome industrial plants.

Cluster 2, consisting of Opolskie, Łódzkie, and Świętokrzyskie, was characterized by higher emission intensity per km² and higher SO₂ and NOx emissions per capita, despite having a lower average number of particularly burdensome industrial plants.

This suggests that emission pressure in these regions may be related not only to the number of plants, but also to the type, scale, and emission intensity of industrial activity.

Future work could extend the analysis by including multiple years, additional environmental indicators, and other emission sources.