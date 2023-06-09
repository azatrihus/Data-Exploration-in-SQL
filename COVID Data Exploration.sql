/*
Covid 19 Data Exploration 
Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types
*/

--Select *
--From Project..CovidDeath
--Where continent is not null 
--order by 3,4


-- Selecting the  Data that we are going to be starting with

--Select Location, date, total_cases, new_cases, total_deaths, population
--From Project..CovidDeath
--Where continent is not null 
--order by 1,2


-- Total Cases vs Total Deaths

--Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
--From Project..CovidDeath
--Where location like '%South Korea%'
--and continent is not null 
--order by 1,2


-- Total Cases vs Population
-- Shows what percentage of population infected with Covid

--Select Location, date, Population, total_cases,  (total_cases/population)*100 as PercentPopulationInfected
--From Project..CovidDeath
----Where location like '%South Korea%'
--order by 1,2

--- looking at countries with highest infection rate compared to population 
Select Location,Population, Max(total_cases) as HighestInfec,  Max((total_cases/population))*100 as  PercentPopulationInfected
From Project..CovidDeath
--Where location like '%South Korea%'
Group by location , population 
order by PercentPopulationInfected desc

--- Countries with the Highest Death Count Per population 
Select Location,MAX(cast(total_deaths as int)) AS TotalDeathCount
From Project..CovidDeath
--Where location like '%South Korea%'
where continent is not null 
Group By location 
order by TotalDeathCount desc


--- Do by continent 
Select location ,MAX(cast(total_deaths as int)) AS TotalDeathCount
From Project..CovidDeath
--Where location like '%South Korea%'
where continent is  not null 
Group By location 
order by TotalDeathCount desc


--- Showing the continents with highest death count
Select continent ,MAX(cast(total_deaths as int)) AS TotalDeathCount
From Project..CovidDeath
--Where location like '%South Korea%'
where continent is not null 
Group By continent 
order by TotalDeathCount desc

-- Global numbers
Select date, SUM (new_cases) as total_cases , SUM(cast(NEW_DEATHs as int)) as total_death, SUM(cast(NEW_DEATHs as int))/Sum (New_cases)*100 as DeathPercentage 
From Project..CovidDeath
--Where location like '%South Korea%'
where  continent is not null 
group by date
order by 1,2



----looking at Total Population vs Vaccinations 
Select dea.continent , dea.location , dea.date , dea.population,
vac.new_vaccinations, Sum(convert(int , vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date ) 
as people_vaccinated
From project .. CovidDeath dea
Join Project .. CovidVaccinations vac
on  dea.location  = vac.location 
and dea.date = vac.date 
where dea.continent is not null
order by 2,3

 -- Use CTE

with PopvsVac(continent, location , date ,  population,new_vaccination,  people_vaccinated) as
(Select dea.continent , dea.location , dea.date , dea.population,
vac.new_vaccinations, Sum(convert(int , vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date ) 
as people_vaccinated
From project .. CovidDeath dea
Join Project .. CovidVaccinations vac
on  dea.location  = vac.location 
and dea.date = vac.date 
where dea.continent is not null
--order by 2,3
)

Select* ,  (people_vaccinated/ population) *100  as vaccinated_pop
from PopvsVac

--creating view to store data for visualizations

create view percentagepopulation as 

Select dea.continent , dea.location , dea.date , dea.population,
vac.new_vaccinations, Sum(convert(int , vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date ) 
as people_vaccinated
From project .. CovidDeath dea
Join Project .. CovidVaccinations vac
on  dea.location  = vac.location 
and dea.date = vac.date 
where dea.continent is not null
--order by 2,3

