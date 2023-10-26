<img src="https://github.com/a-vishniavetski/SQL-Tableau-COVID-analysis/assets/132013288/84a615e7-afbe-42b5-86ec-8f370e42257b" align="right" height="70"></img>

# SQL-Tableau-COVID-analysis
> An analysis of the statistics related to COVID-19 Pandemic, using SQL for Data Exploration and Tableau for visualizing.
> 
> ***An interactive version of all graphs is available at my [*"Tableau Public" Portfolio*](https://public.tableau.com/app/profile/aliaksei.vishniavetski/viz/COVID19DataAnalysis_16981729659990/Dashboard1#1).***

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Navigation

- [Overview](#overview)
- [Visualizations](#Visualizations)
- [Conclusion](#Conclusion)

## Overview

### Goals

- To understand the scale of the pandemic.
- To figure out which countries have been the most affected.
- To gather other possible insights that can be extracted from the data.

### Dataset 

- [**COVID-19 Dataset**](https://github.com/owid/covid-19-data) provided by "Our World in Data".
- **Analyzed timeframe**: 01.03.2020 - 24.09.2023.

## Visualizations

> #### **All of the visualizations are available in interactive mode and high resolution at my [*"Tableau Public" Portfolio*](https://public.tableau.com/app/profile/aliaksei.vishniavetski/viz/COVID19DataAnalysis_16981729659990/Dashboard1#1)**

### Scale: Main Worldwide numbers

![global numbers](https://github.com/a-vishniavetski/SQL-Tableau-COVID-analysis/assets/132013288/a24414b0-0745-4819-a94a-405485091bb2)

### Scale: Growth of the total number of cases in 6 selected European countries as a percentage of the total population
> As an example of the general dynamic.

![perc_pop](https://github.com/a-vishniavetski/SQL-Tableau-COVID-analysis/assets/132013288/de5368bd-df14-47ff-9856-6776d7576d8f)


### Most affected: 20 countries with the most *Cases* of COVID-19
![Cases](https://github.com/a-vishniavetski/SQL-Tableau-COVID-analysis/assets/132013288/2b195af6-bd92-4862-8512-b0e16534fa42)


### Most affected: 20 countries with the most *Deaths* from COVID-19
![Deaths](https://github.com/a-vishniavetski/SQL-Tableau-COVID-analysis/assets/132013288/d410aa1e-9906-4c30-bde4-420b6aeab2fd)


### Most affected: World map
> ### The interactive version of the map is available [*here*](https://public.tableau.com/app/profile/aliaksei.vishniavetski/viz/COVID19DataAnalysis_16981729659990/Dashboard1#1)
> Gradient colormap is used to represent how much countries have been affected in relation to each other. The more red - the bigger portion of the total population had/has COVID-19.

![map](https://github.com/a-vishniavetski/SQL-Tableau-COVID-analysis/assets/132013288/9c463aba-343d-4fea-9538-4e01800c94ae)


### Insights: Correlation between the stringency of the anti-COVID-19 policies (Stringency Index) and the percentage of people who have contracted COVID-19
> The most notable data point is China. The most strict anti-COVID measures in the world have also allowed China to have a low sick percentage.

![index](https://github.com/a-vishniavetski/SQL-Tableau-COVID-analysis/assets/132013288/d7f9a0c8-e306-458c-9c00-6a391423c582)

## Conclusion

The pandemic has _770 million_ people affected, with _0.9%_ mortality, and necessitated _70%_ of the World's population to vaccinate themselves.

_The US and China_ are the leading countries both in terms of the _amount of cases and deaths_, and European countries, notably _France and Italy_, rank highest in terms of _the percentage_ of the population who contracted the disease.

The correlation between _the stringency index_ and _the percentage of the population affected_ is rather inconclusive, with China ranking the highest both in terms of stringency and efficiency of the measures taken.
