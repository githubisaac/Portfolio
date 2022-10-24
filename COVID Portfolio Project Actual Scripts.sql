
select 
	*
from 
	PortfolioProject1..CovidDeaths
where
	continent is not null
order by 
	location
	,date


select
	location
	,date 
	,total_cases
	,new_cases
	,total_deaths
	,population
from
	PortfolioProject1..CovidDeaths
where
	continent is not null
order by
	location
	,date


-- Looking at Total Cases vs Total Deaths
-- Shows the likelyhood of dying if you contract covid in your country
select
	location
	,date 
	,total_cases
	,total_deaths
	,(total_deaths/total_cases)*100 DeathPercentage
from
	PortfolioProject1..CovidDeaths
where
	location like '%states%'
and
	continent is not null
order by
	location
	,date


-- Looking at Total Cases vs Population
-- Shows what percentage of population got covid
select
	location
	,date 
	,population
	,total_cases
	,(total_cases/population)*100 HadCovidPercentage
from
	PortfolioProject1..CovidDeaths
--where
--	location like '%states%'
where
	continent is not null
order by
	location
	,date


-- Looking at countries with Highest Infection Rate compared to Population
select
	location
	,population
	,max(total_cases) HighestInfectionCount
	,max((total_cases/population)*100) HadCovidPercentage
from
	PortfolioProject1..CovidDeaths
--where
--	location like '%states%'
where
	continent is not null
group by
	location
	,population
order by
	HadCovidPercentage desc


--LETS BREAK THINGS DOWN BY CONTINENT -- this one is inaccurate. the following query is accurate.
----select
----	continent
----	,max(total_deaths) TotalDeathCount
----from
----	PortfolioProject1..CovidDeaths
----where 
----	continent is not null
----group by
----	continent
----order by
----	TotalDeathCount desc 


-- Accurate search breakdown by continent
-- Showing continents with Highest Death Count
select
	location
	,max(total_deaths) TotalDeathCount
from
	PortfolioProject1..CovidDeaths
where 
	continent is null
and
	location not like '%income%'
and
	location not like '%european union%'
and 
	location not like '%world%'
and
	location not like '%international%'
group by
	location
order by
	TotalDeathCount desc 


-- Showing Countries with Highest Death Count
select
	location
	,max(total_deaths) TotalDeathCount
from
	PortfolioProject1..CovidDeaths
--where
--	location
--like '%states%'
where 
	continent is not null
group by
	location
order by
	TotalDeathCount desc


-- Global numbers
select
	date 
	,SUM(new_cases) NewCases
	,SUM(new_deaths) NewDeaths
	,(SUM(new_deaths)/SUM(new_cases))*100 DeathPercentage
	--,total_deaths
	--,(total_deaths/total_cases)*100 DeathPercentage
from
	PortfolioProject1..CovidDeaths
where
--	location like '%states%'
--and
	continent is not null
group by
	date
order by
	date


-- Total Cases To Date
select
	SUM(new_cases) TotalCases
	,SUM(new_deaths) TotalDeaths
	,(SUM(new_deaths)/SUM(new_cases))*100 DeathPercentage
from
	PortfolioProject1..CovidDeaths
where
	continent is not null


select
	*
from
	PortfolioProject1..CovidVaccinations

-- Looking at Total Population vs Vaccinations

select 
	dea.continent
	,dea.location
	,dea.date
	,dea.population
	,vac.new_vaccinations
	,SUM(vac.new_vaccinations) OVER (Partition by dea.Location Order by dea.location,dea.date) RollingPeopleVaccinated
from 
	PortfolioProject1..CovidDeaths dea
join
	PortfolioProject1..CovidVaccinations vac
on 
	dea.location=vac.location
and 
	dea.date=vac.date
where 
	dea.continent is not null
order by
	location
	,date


-- USE CTE

With PopVsVac (Continent, Location, Date, Population, New_vaccinations, RollingPeopleVaccinated)
as
(
select 
	dea.continent
	,dea.location
	,dea.date
	,dea.population
	,vac.new_vaccinations
	,SUM(vac.new_vaccinations) OVER (Partition by dea.Location Order by dea.location,dea.date) RollingPeopleVaccinated
from 
	PortfolioProject1..CovidDeaths dea
join
	PortfolioProject1..CovidVaccinations vac
on 
	dea.location=vac.location
and 
	dea.date=vac.date
where 
	dea.continent is not null
)
select
	*
	,(RollingPeopleVaccinated/Population)*100
from 
	PopVsVac


-- TEMP TABLE

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
	Continent nvarchar(255)
	,Location nvarchar(255)
	,Date datetime
	,Population numeric
	,New_Vaccinations numeric
	,RollingPeopleVaccinated numeric
)
Insert into #PercentPopulationVaccinated
select 
	dea.continent
	,dea.location
	,dea.date
	,dea.population
	,vac.new_vaccinations
	,SUM(vac.new_vaccinations) OVER (Partition by dea.Location Order by dea.location,dea.date) RollingPeopleVaccinated
from 
	PortfolioProject1..CovidDeaths dea
join
	PortfolioProject1..CovidVaccinations vac
on 
	dea.location=vac.location
and 
	dea.date=vac.date
where 
	dea.continent is not null


select
	*
	,(RollingPeopleVaccinated/Population)*100
from 
	#PercentPopulationVaccinated


-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
select 
	dea.continent
	,dea.location
	,dea.date
	,dea.population
	,vac.new_vaccinations
	,SUM(vac.new_vaccinations) OVER (Partition by dea.Location Order by dea.location,dea.date) RollingPeopleVaccinated
from 
	PortfolioProject1..CovidDeaths dea
join
	PortfolioProject1..CovidVaccinations vac
on 
	dea.location=vac.location
and 
	dea.date=vac.date
where 
	dea.continent is not null


select 
	*
from 
	PercentPopulationVaccinated


Create View ContinentsDeathTotals as
select
	location
	,max(total_deaths) TotalDeathCount
from
	PortfolioProject1..CovidDeaths
where 
	continent is null
and
	location not like '%income%'
group by
	location


select 
	*
from 
	ContinentsDeathTotals
order by
	TotalDeathCount desc
