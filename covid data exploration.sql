select * from coviddeaths
where continent is not null
order by 3,4;

Select Location, date, total_cases, new_cases, total_deaths, population
From covidDeaths
Where continent is not null 
order by 1,2;

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathParcentage
From covidDeaths
Where Location like '%desh%'
and continent is not null
order by 1,2;

Select Location, date, total_cases, total_deaths, round((total_cases/population)*100,1) as PercentPopulationInfected
From covidDeaths
Where Location like '%desh%'
and continent is not null
order by PercentPopulationInfected desc ;

Select Location, Population, max(total_cases) as HighestInfectionCount, round(max(total_cases/population)*100,1) as PercentPopulationInfected
From covidDeaths
group by Location, Population
order by  PercentPopulationInfected desc;

select Location, 
max(CAST(total_deaths AS UNSIGNED)) as totalDeathCount
from coviddeaths
where  continent is not null
Group by Location
order by TotalDeathCount desc;


select continent, 
max(CAST(total_deaths AS UNSIGNED)) as totalDeathCount
from coviddeaths
where  continent is not null
Group by continent
order by TotalDeathCount desc;

select SUM(new_cases) as total_cases, 
sum(CAST(new_deaths AS UNSIGNED)) as totalDeaths,
SUM(cast(new_deaths as unsigned))/SUM(New_Cases)*100 as DeathPercentage
from coviddeaths
where  continent is not null
order by 1,2;

-- Total Population vs Vaccinations
-- Shows Percentage of Population that has 
-- recieved at least one Covid Vaccine


Select dea.continent, dea.location, dea.date,
dea.population, vac.new_vaccinations,
SUM(CONVERT(vac.new_vaccinations, unsigned)) 
OVER (Partition by dea.Location Order by dea.location, dea.Date) 
as RollingPeopleVaccinated
From CovidDeaths dea
Join CovidVaccinations vac On dea.location = vac.location 
and dea.date = vac.date
where dea.continent is not null 
order by 2,3;

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date,
dea.population, vac.new_vaccinations,
SUM(CONVERT(vac.new_vaccinations, unsigned)) 
OVER (Partition by dea.Location Order by dea.location, dea.Date) 
as RollingPeopleVaccinated
From CovidDeaths dea
Join CovidVaccinations vac
On dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null 
order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac;





