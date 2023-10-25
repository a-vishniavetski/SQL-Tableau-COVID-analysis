<img src="https://github.com/a-vishniavetski/SQL-Tableau-COVID-analysis/assets/132013288/84a615e7-afbe-42b5-86ec-8f370e42257b" align="right" height="70"></img>

# SQL-Tableau-COVID-analysis
> An analysis of the statistics related to COVID-19 Pandemic, using SQL for Data Exploration and Tableau for visualizing.
> 
> ***An interactive version of all graphs is available at my [*"Tableau Public" Portfolio*](https://public.tableau.com/app/profile/aliaksei.vishniavetski/viz/COVID19DataAnalysis_16981729659990/Dashboard1#1).***

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Navigation

- [Overview](#overview)
- [Statistics](#statistics)
- []()
- []()
- []()

## Overview

### Goals

- To understand the scale of the pandemic.
- To figure out which countries have been the most affected.
- To gather other possible insights that can be extracted from the data.

### Dataset 

- [**COVID-19 Dataset**](https://github.com/owid/covid-19-data) provided by "Our World in Data".
- **Analyzed timeframe**: 01.03.2020 - 24.09.2023.

## Statistics

![global numbers](https://github.com/a-vishniavetski/SQL-Tableau-COVID-analysis/assets/132013288/a24414b0-0745-4819-a94a-405485091bb2)

![Cases](https://github.com/a-vishniavetski/SQL-Tableau-COVID-analysis/assets/132013288/2b195af6-bd92-4862-8512-b0e16534fa42)

![Deaths](https://github.com/a-vishniavetski/SQL-Tableau-COVID-analysis/assets/132013288/d410aa1e-9906-4c30-bde4-420b6aeab2fd)
![Deaths](https://github.com/a-vishniavetski/SQL-Tableau-COVID-analysis/assets/132013288/c0e7b2dc-4314-41c0-8559-bb7832c2bae3)

![map](https://github.com/a-vishniavetski/SQL-Tableau-COVID-analysis/assets/132013288/9c463aba-343d-4fea-9538-4e01800c94ae)

![perc_pop](https://github.com/a-vishniavetski/SQL-Tableau-COVID-analysis/assets/132013288/de5368bd-df14-47ff-9856-6776d7576d8f)

![index](https://github.com/a-vishniavetski/SQL-Tableau-COVID-analysis/assets/132013288/288716ae-aafa-4ddf-9b71-16ced3dd36e9)

















  
## Usage 
The file `data_exploration.sql` contains the SQL queries for:
- Data Exploration
- Normalizing some of the statistics(mainly indexes related to country's living conditions)
- Creation of *views* , which can be used as a data source for vizualizing with your preferred method (Tableau, PowerBI, Python, etc...).

Example queries:
- Normalizing the `human_development_index`, `handwashing_facilities` and `stringency_index`. Combining them into a single `combined_index`.
  
  ```sql
  SELECT location
  	,(max(total_cases) / max(population) * 100.0) AS sick_percentage_total
  	,avg(normalized_stringency) AS avg_stringency
  	,avg(normalized_handwash) AS avg_handwash
  	,avg(normalized_hdi) AS avg_hdi
  	,((avg(normalized_handwash) + avg(normalized_stringency) + avg(normalized_hdi)) / 3) AS combined_index
  FROM (
  	SELECT location
  		,DATE
  		,total_cases
  		,population
  		,(stringency_index - min_str) / (max_str - min_str) AS normalized_stringency
  		,(handwashing_facilities - min_hand) / (max_hand - min_hand) AS normalized_handwash
  		,(human_development_index - min_hdi) / (max_hdi - min_hdi) AS normalized_hdi
  	FROM covidata
  	CROSS JOIN (
  		SELECT min(stringency_index) AS min_str
  			,max(stringency_index) AS max_str
  			,min(handwashing_facilities) AS min_hand
  			,max(handwashing_facilities) AS max_hand
  			,min(human_development_index) AS min_hdi
  			,max(human_development_index) AS max_hdi
  		FROM covidata
  		) AS minmax
  	) AS norm
  GROUP BY location;
  ```

- Absolute cumulative excess mortality and total deaths
  ```sql
  SELECT location
  	,DATE
  	,total_deaths
  	,avg(excess_mortality_cumulative_absolute) OVER (
  		PARTITION BY location ORDER BY DATE rows BETWEEN 10 preceding
  				AND 10 following
  		) AS excess_mort_cumul_abs
  FROM covidata;
  ```
