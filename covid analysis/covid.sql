Select *
From covid..coronavirus_summary_data
order by 3


-- Select Data that we are going to be starting with

Select country,population,  total_confirmed, active_cases,total_recovered,total_deaths
From covid..coronavirus_summary_data
Where country is not null 
order by 1,2


-- Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country

Select country, total_confirmed,total_deaths, (total_deaths/total_confirmed)*100 as DeathPercentage
From covid..coronavirus_summary_data
Where 
--country like 'India'
--and 
country is not null 
order by 1,2



-- Total Cases vs Population
-- Shows what percentage of population infected with Covid

Select country, Population, total_confirmed,  (total_confirmed/population)*100 as PercentPopulationInfected
From covid..coronavirus_summary_data
--Where location like 'India'
order by 1,2




-- Countries with Highest Infection Rate compared to Population

Select country, Population, 
MAX(total_confirmed) as HighestInfectionCount,  Max((total_confirmed/population))*100 as PercentPopulationInfected
From covid..coronavirus_summary_data
--Where location like 'India'
Group by country, Population
order by PercentPopulationInfected desc



-- Countries with Highest Death Count per Population

Select country, MAX(Total_deaths) as TotalDeathCount
From covid..coronavirus_summary_data
--Where location like 'India'
Where country is not null 
Group by country
order by TotalDeathCount desc




-- BREAKING THINGS DOWN BY CONTINENT

-- Showing contintents with the highest death count per population

Select continent, MAX(total_deaths) as TotalDeathCount
From covid..coronavirus_summary_data
--Where location like 'India'
Where country is not null 
Group by continent
order by TotalDeathCount desc




-- GLOBAL NUMBERS

Select SUM(population) as total_population,SUM(total_confirmed) as total_cases, SUM(total_deaths) as total_deaths,SUM(total_recovered) as total_recovered, SUM(total_recovered)/SUM(total_confirmed)*100 as RecoveredPercentage,SUM(total_deaths)/SUM(total_confirmed)*100 as DeathPercentage
From covid..coronavirus_summary_data
--Where location like '%states%'
where country is not null 
--Group By date
order by 1,2





-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

Select dea.country, vac.date, dea.population, vac.people_vaccinated
, SUM(vac.people_vaccinated) OVER (Partition by dea.country Order by dea.country, vac.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From covid..coronavirus_summary_data dea
Join covid..vaccinations_data vac
	On dea.country = vac.country
where dea.country is not null 
order by 2,3





-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
Select dea.country, vac.date, dea.population, vac.people_vaccinated
, SUM(vac.people_vaccinated) OVER (Partition by dea.country Order by dea.country, vac.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From covid..coronavirus_summary_data dea
Join covid..vaccinations_data vac
	On dea.country = vac.country
where dea.country is not null 





--continent wise global numbers

Select continent,sum(population) as population ,sum(total_confirmed) as 'total confirmed',sum(total_deaths) as 'total deaths',sum(total_recovered) as 'total recovered'
From covid..coronavirus_summary_data
--Where location like '%states%'
where country is not null 
Group By continent
order by 2 desc


--country wise confirmed vs death cases

Select country,sum(population) as population ,sum(total_confirmed) as 'total confirmed',sum(total_deaths) as 'total deaths',sum(total_recovered) as 'total recovered'
From covid..coronavirus_summary_data
--Where location like '%states%'
where country is not null 
Group By country
order by 2 desc


--country wise global numbers based on daily cases

Select sum(active_cases) as 'daily active cases',sum(daily_new_cases) as 'daily new cases',sum(daily_new_deaths) as 'daily new deaths', sum(daily_vaccinations) as 'daily vaccinations', sum(daily_people_vaccinated) as 'daily people vaccinated'
From covid..coronavirus_daily_data,covid..vaccinations_data
--Where location like '%states%'
--Group By country
--order by 2 desc

--country-wise daily new cases

Select country,sum(daily_new_cases) as 'Daily new cases'
From covid..coronavirus_daily_data
--Where location like '%states%'
where country is not null 
Group By country
order by 2 desc


--country-wise daily active cases
Select country,sum(active_cases) as 'daily active cases'
From covid..coronavirus_daily_data
--Where location like '%states%'
where country is not null 
Group By country
order by 2 desc

--country-wise daily new deaths

Select country,sum(daily_new_deaths) as 'daily new deaths'
From covid..coronavirus_daily_data
--Where location like '%states%'
where country is not null 
Group By country
order by 2 desc

--country wise people vaccinated vs daily vaccinations
Select country,sum(people_vaccinated) as 'people vaccinated' ,sum(daily_vaccinations) as 'daily vaccinations',sum(daily_people_vaccinated) as 'daily people vaccinated'
From covid..vaccinations_data
--Where location like '%states%'
where country is not null
Group By country
order by 2 desc


--country wise total vaccinations vs people vaccinated
Select country,sum(total_vaccinations) as 'total vaccinations',sum(people_vaccinated) as 'people vaccinated' ,sum(people_fully_vaccinated) as 'people fully vaccinated',sum(total_boosters) as 'total boosters'
From covid..vaccinations_data
--Where location like '%states%'
where country is not null
Group By country
order by 2 desc