select location, date, total_cases, new_cases, total_deaths, population
from coviddeath
--where location like 'Kaz%'
order by 1,2

--Общее количество заболеваний на общее кол-во смертей

select location, date, total_cases, total_deaths, (total_deaths / total_cases) * 100 as deathpersent
from coviddeath
where location like 'Kaz%'
order by 1,2

--Процент населения болевший Covid-19 в Казахстане

select location, date, total_cases, population, (total_cases / population ) * 100 as casespersent
from coviddeath
where location like 'Kaz%'
order by 1,2

--Процент населения болевший Covid-19 в Мире

select location, population, date, max(total_cases), max((total_cases / population)) * 100 as casespersent
from coviddeath
group by location, population, date
having max(total_cases) is not null and population is not null
order by casespersent desc

--Страна с наибольшим числом заразившихся на популяцию

select location, population, max(total_cases) as highestinfection, max((total_cases / population )) * 100 as casespersent
from coviddeath
--where total_cases is not null and population is not null
group by location, population
order by casespersent desc

--Общее количество смертей на континенты 

select continent, max(total_deaths) as highestdeaths
from coviddeath
where total_deaths is not null and continent is not null
group by continent
order by highestdeaths desc

--Общее количество смертей на страны

select location, max(total_deaths) as highestdeaths
from coviddeath
where total_deaths is not null and continent is not null
group by location
order by highestdeaths desc

--Глобальные цифры
--Количество заболевших и умерших каждый день

select date, sum(new_cases) as new_cases_total, 
sum(new_deaths) as new_deaths_total, 
(sum(new_deaths) / sum(new_cases)) * 100 as persentage 
from coviddeath
where continent is not null
group by date
order by 1,2

--Количество сделаных вакцин по странам

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(vac.new_vaccinations) over(partition by dea.location order by dea.location, dea.date)
from coviddeath as dea
join covidvaccination as vac on dea.location = vac.location 
and dea.date = vac.date
where dea.continent is not null
order by 2,3


select sum(new_cases) as total_cases, sum(new_deaths) as total_deaths, (sum(new_deaths) / sum(new_cases)) * 100 as deathpersenage
from coviddeath
where continent is not null
order by 1,2