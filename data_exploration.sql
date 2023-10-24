-- "Our World in Data" COVID-19 dataset analysis. Cut-off date is September 24th, 2023.
-- Author: Aliaksei Vishniavetski
-- Date: 24.09.2023
-- Description: This SQL file contains a set of data exploration queries for analyzing the COVID-19 dataset provided by "Our World In Data". The queries provide insights and summary statistics to gain a better understanding of the data.
-- Dataset link: https://github.com/owid/covid-19-data

-------------------------------------------------- VIEWS FOR TABLEAU --------------------------------------------------


-- Total cases/deaths, people vaccinated + percentages, stringency
CREATE VIEW cases_deaths_vaccs
AS
WITH cte_for_total_cases
AS (
	SELECT location
		,DATE
		,sum(new_cases) OVER (
			PARTITION BY location ORDER BY location
				,DATE
			) AS total_cases
	FROM covidata
	WHERE continent IS NOT NULL
	)
SELECT c.Location
	,c.DATE
	,c.population
	,cte.total_cases
	,total_deaths
	,(cte.total_cases / c.population * 100.0) AS sick_percentage
	,CASE 
		WHEN cte.total_cases = 0
			THEN 0
		ELSE (total_deaths / cte.total_cases * 100.0)
		END AS dead_percentage
	,new_cases
	,new_deaths
	,(people_vaccinated / c.population * 100) AS vaccinated_percentage
FROM covidata AS c
INNER JOIN cte_for_total_cases AS cte ON cte.location = c.location
	AND cte.DATE = c.DATE
WHERE continent IS NOT NULL;
--order by 1, 2

-- Total numbers worldwide
create view total as
select location, max(total_cases) as total_cases, max(total_deaths) as total_deaths, max(people_vaccinated) as total_vaccinated,
(max(total_deaths) / max(total_cases) * 100.0) as dead_percentage,
(max(people_vaccinated) / max(population) * 100.0) as vaccinated_percentage
from covidata
--where continent is not null
group by location
order by max(total_cases) desc


-- Total cases and % of population who have been infected at the time of dataset cut-off
CREATE VIEW current_total
AS
SELECT location
	,population
	,max(total_cases) AS current_total_cases
	,max(total_cases / population * 100) AS current_sick_percentage
FROM covidata
GROUP BY location
	,population;
--order by current_sick_percentage desc


-- Stringency, handwashing facilities, human development index normalized and combined into single index
CREATE VIEW indexes
AS
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


-- Absolute cumulative excess mortality and total deaths
CREATE VIEW excess_mortality
AS
SELECT location
	,DATE
	,total_deaths
	,avg(excess_mortality_cumulative_absolute) OVER (
		PARTITION BY location ORDER BY DATE rows BETWEEN 10 preceding
				AND 10 following
		) AS excess_mort_cumul_abs
FROM covidata;
--order by location, date


-- Reproduction rate VS new_cases
CREATE VIEW reproduction_rate
AS
SELECT location
	,DATE
	,reproduction_rate
	,new_cases
FROM covidata;


-------------------------------------------------- QUERIES AND SCRATCHES USED FOR DATA EXPLORATION --------------------------------------------------

-- Totals worldwide by date
select date, 
		sum(total_cases) as total_cases,
		sum(cast(total_deaths as bigint)) as total_deaths, 
		(sum(total_cases) / sum(population) * 100.0) as sick_percentage,
		(sum(cast(total_deaths as bigint)) / sum(total_cases) * 100.0) as dead_percentage,
		sum(new_cases) as new_cases, 
		sum(cast(new_deaths as bigint)) as new_deaths
from covidata
where continent is not null
group by date
order by date asc

-- Total cases/deaths, people vaccinated + percentages
Select Location, date, population, total_cases, total_deaths, 
(total_cases / population * 100.0) as sick_percentage,
(total_deaths / total_cases * 100.0) as dead_percentage,
new_cases, new_deaths,
(people_vaccinated / population * 100) as vaccinated_percentage
from covidata
where continent is not null
order by 1, 2


-- Highest death count per population
select location, population, max(cast(total_deaths as bigint)) as total_deaths
from covidata
where continent is not null
group by location, population
order by total_deaths desc

-- CONTINENTS AND STUFF
-- Continents with the highest death counts
select location, population, max(cast(total_deaths as bigint)) as total_deaths
from covidata
where continent is null
group by location, population
order by total_deaths desc

-- VACCINATIONS
select *
from covidata

-- vaccinations in absolute and percentages
select deaths.location, deaths.date, deaths.total_cases, deaths.new_cases,
deaths.total_deaths, deaths.new_deaths, vaccs.total_vaccinations,
(vaccs.total_vaccinations / deaths.population * 100) as perc_vaccinated
from covidata as deaths
join covidata as vaccs
	on deaths.location = vaccs.location 
	and deaths.date = vaccs.date
order by 1, 2

-- total_by_sum is a sum of new_cases up to date
select location, date, new_cases, 
sum(new_cases) over (partition by location order by location, date) as total_by_sum,
total_cases
from covidata
where continent is not null
order by location, date

-- vaccinations in absolute and percentages using a rolling total vaccs count and a CTE to show off;
-- rolling total_vaccs count lags behind the total from the dataset, because some entries have higher total_vaccs count while new_vaccs is null, which is a 
-- a downside of the dataset; because of that VACCS ROLLING COUNT IS WILDLY INACCURATE ACTUALLY!!!
WITH CTE_rolling_vaccs as (
	select deaths.location, deaths.date, deaths.population,
	vaccs.new_vaccinations, vaccs.total_vaccinations,
	sum(cast(vaccs.new_vaccinations as bigint)) over(partition by deaths.location order by deaths.date) as total_vaccs_by_sum
	from covidata as deaths
	join covidata as vaccs
		on deaths.location = vaccs.location 
		and deaths.date = vaccs.date
	where deaths.continent is not null)
select *, 
	(total_vaccs_by_sum / population * 100.0) as perc_vaccinated_rolling
from
cte_rolling_vaccs
where location like '%poland%'
order by location, date


-- NORMALIZING OTHER FACTORS
select location, date, 
	stringency_index,
	population_density,
	handwashing_facilities,
	human_development_index,
	population
from covidata;


WITH cte_max as (
select min(stringency_index) as min_str
	, max(stringency_index) as max_str
	, min(handwashing_facilities) as min_hand
	, max(handwashing_facilities) as max_hand
	, min(human_development_index) as min_hdi
	, max(human_development_index) as max_hdi
from covidata
)
select location, date
	, (stringency_index - min_str) / (max_str - min_str) as normalized_stringency
	, (handwashing_facilities - min_hand) / (max_hand - min_hand) as normalized_handwash
from covidata
cross join cte_max


select location
	, date
	, normalized_stringency
	, normalized_handwash
	, ((normalized_handwash + normalized_stringency) / 2) as combined_index
from (
select 
	location
	, date
	, (stringency_index - min_str) / (max_str - min_str) as normalized_stringency
	, (handwashing_facilities - min_hand) / (max_hand - min_hand) as normalized_handwash
from covidata
cross join (
select min(stringency_index) as min_str
	, max(stringency_index) as max_str
	, min(handwashing_facilities) as min_hand
	, max(handwashing_facilities) as max_hand
from covidata
) as minmax) as norm
