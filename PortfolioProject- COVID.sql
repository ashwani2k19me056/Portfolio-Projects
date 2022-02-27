SELECT * FROM CovidDeaths WHERE continent IS NOT NULL ORDER BY 3,4 ;

--SELECT *FROM CovidVaccination ORDER BY 3,4;

--Relevant Data

SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1,2;

--Total cases Vs Total Deaths

SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1,2;

--India Death Percentage
SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM CovidDeaths
WHERE continent IS NOT NULL AND location LIKE '%India'
ORDER BY 1,2;

--Total Cases Vs Population: Percentage-India

SELECT location, date, population, total_cases,(total_cases/population)*100 AS CasePercentage
FROM CovidDeaths
WHERE continent IS NOT NULL AND location LIKE 'India'
ORDER BY 1,2;

--Country With Highest Infection Rate WRT Population

SELECT location, population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population))*100 AS PercentPopulationInfected
FROM CovidDeaths
--WHERE location LIKE 'India'
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY PercentPopulationInfected DESC;

--Countries with the highest death count

SELECT location,MAX(population) AS TotalPopulation, MAX(cast(Total_deaths AS INT)) AS TotalDeaths
FROM CovidDeaths
--WHERE location LIKE 'India'
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY TotalDeaths DESC;

--Ordering Things By Continents

SELECT location, MAX(cast(total_deaths AS INT)) AS TotalDeathCount
FROM CovidDeaths
WHERE continent IS NULL
GROUP BY location
ORDER BY TotalDeathCount DESC;

--GLOBAL NUMBERS

SELECT date, SUM(new_cases) AS NEW_CASES, SUM(CAST(new_deaths AS INT)) AS Deaths, SUM(CAST(new_deaths AS INT))/ SUM(new_cases) * 100 AS DeathPercentage
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1,2;

SELECT SUM(new_cases) AS NEW_CASES, SUM(CAST(new_deaths AS INT)) AS Deaths, SUM(CAST(new_deaths AS INT))/ SUM(new_cases) * 100 AS DeathPercentage
FROM CovidDeaths
WHERE continent IS NOT NULL
--GROUP BY date
ORDER BY 1,2;

--CovidVaccinations
SELECT *FROM CovidVaccination ORDER BY 3,4;

--JOINING DEATHS AND VACCINATION TABLE

SELECT *
FROM CovidDeaths as dea
JOIN CovidVaccination as vac
ON dea.location = vac.location AND
dea.date = vac.date

--Total Population Vs Vaccinations

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
FROM CovidDeaths as dea
JOIN CovidVaccination as vac
ON dea.location = vac.location AND
dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2,3;

--ROLLING SUM OF TOTAL VACCINATIONS

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CAST(vac.new_vaccinations AS BIGINT)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingSum

FROM CovidDeaths as dea
JOIN CovidVaccination as vac
ON dea.location = vac.location AND
dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2,3;

--Using CTE ; WITH Clause

WITH PopVsVac(Continent, Location, Date, population, New_vaccinations, RollingSum) 
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CAST(vac.new_vaccinations AS BIGINT)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingSum

FROM CovidDeaths as dea
JOIN CovidVaccination as vac
ON dea.location = vac.location AND
dea.date = vac.date
WHERE dea.continent IS NOT NULL
--ORDER BY 2,3
)

SELECT *, (RollingSum/population) * 100
FROM PopVsVac;

--Temp Table

CREATE TABLE #PercentPeopleVaccinated
(
Continent VARCHAR(255),
location VARCHAR(255),
Date DATETIME,
Population NUMERIC,
New_vaccinations Numeric,
RollingSum Numeric
)

INSERT INTO #PercentPeopleVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CAST(vac.new_vaccinations AS BIGINT)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingSum

FROM CovidDeaths as dea
JOIN CovidVaccination as vac
ON dea.location = vac.location AND
dea.date = vac.date
WHERE dea.continent IS NOT NULL
--ORDER BY 2,3

SELECT *, (RollingSum/Population) * 100
FROM #PercentPeopleVaccinated;

--Creating View

CREATE VIEW PercentPopulationVaccinated 
AS SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CAST(vac.new_vaccinations AS BIGINT)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingSum

FROM CovidDeaths as dea
JOIN CovidVaccination as vac
ON dea.location = vac.location AND
dea.date = vac.date
WHERE dea.continent IS NOT NULL
--ORDER BY 2,3








