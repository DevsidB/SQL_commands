-- Select database 
use project;

-- View first table
select * from Data1;

--View second table
select * from Data2;

-- Count total rows
select count(*) from Data1;

-- Count total rows
select count(*) from Data2;

--dataset from any 2 states 
select * from Data1;
select * from Data1 where State	in ('Jharkhand','Bihar');

--total population
select * from Data2;
select sum(population) as Total_pop  from Data2;

--avg growth of population
select * from Data1;
select avg(growth)*100 as Avg_growth from Data1; --(multiplying by 100 for percentage)

--avg growth by state
select * from Data1;
select state, avg(growth)*100 as Avg_growth from Data1 group by State;

--Average sex ratio by state 
select * from Data1;
select state,avg(sex_ratio) as Avg_sex_ratio from Data1 group by State; -- returns decimal (sex ratio should be an integer)
select state,round(avg(sex_ratio),0) as Avg_sex_ratio from Data1 group by State; -- integer using round function

--Average sex ratio by state/desc order by sex ratio;
select state,round(avg(sex_ratio),0) as Avg_sex_ratio from Data1 group by State  order by Avg_sex_ratio desc;

-- Average literacy rate by state/desc order by literacy rate;
select * from Data1;
select state, round (avg(literacy),0) as Avg_literacy from Data1 group by State order by Avg_literacy desc;

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
														--states where average literacy > 90 
-- Method 1 : Using having clause
select * from Data1;
select state, round (avg(literacy),0) as Avg_literacy from Data1 group by State order by Avg_literacy desc; --copied
select state, round (avg(literacy),0) as Avg_literacy from Data1 group by State having round (avg(literacy),0)>90 order by Avg_literacy desc;
-- error: 
select state, round (avg(literacy),0) as Avg_literacy from Data1 group by State having Avg_literacy >90 order by Avg_literacy desc; --(Column name for aggregated rows cannot be used in having clause) 
--Remember: 1. where is used for rows 2. having is used for aggregated/sumed rows

-- Method 2 : Using where clause and nested functions.
select * from (select state, round (avg(literacy),0) as Avg_literacy from Data1 group by State)as a where Avg_literacy>90 order by Avg_literacy desc; 

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Top 3 states with highest average growth ratio
select * from Data1;
select state, avg(growth)*100 as Avg_growth from Data1 group by State;--copied
select top 3 state, avg(growth)*100 as Avg_growth from Data1 group by State order by Avg_growth desc;
select state, avg(growth)*100 as Avg_growth from Data1 group by State order by Avg_growth desc limit 3 ; -- (Same as above using limit function/not working here because of version)


--Bottom 3 states with lowest average growth ratio
select top 3 state, avg(growth)*100 as Avg_growth from Data1 group by State order by Avg_growth; --(desc removed/by default is in asc order)


--Top 3 states with highest average sex ratio
select * from Data1;
select state,round(avg(sex_ratio),0) as Avg_sex_ratio from Data1 group by State; -- integer using round function
select top 3 state,round(avg(sex_ratio),0) as Avg_sex_ratio from Data1 group by State order by Avg_sex_ratio desc; --copied


--Bottom 3 states with lowest average sex ratio
select top 3 state,round(avg(sex_ratio),0) as Avg_sex_ratio from Data1 group by State order by Avg_sex_ratio;


----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Method 1 : Display top and bottom avg literacy  in one table using union
select state, round (avg(literacy),0) as Avg_literacy from Data1 group by State order by Avg_literacy desc;--copied
select top 3 state, round (avg(literacy),0) as Avg_literacy from Data1 group by State order by Avg_literacy desc; --TOP
select top 3 state, round (avg(literacy),0) as Avg_literacy from Data1 group by State order by Avg_literacy ; --BOTTOM

select * from (select top 3 state, round (avg(literacy),0) as Avg_literacy from Data1 group by State order by Avg_literacy desc) as a
union
select * from (select top 3 state, round (avg(literacy),0) as Avg_literacy from Data1 group by State order by Avg_literacy) as b;



--Method 2 : Display top and bottom avg_literacy in one table using union(by creating temporary tables)

                                             --Creating top states table
--dropping table if exists
drop table if exists #topstates;

--creating a temp table
create table #topstates 
(state varchar(255),
average_literacy int);

--inserting top 3 values in table
insert into #topstates select top 3 state, round (avg(literacy),0) as Avg_literacy from Data1 group by State order by Avg_literacy desc;

select * from #topstates;

                                              --Creating bottom states table
--dropping table if exists
drop table if exists #bottomstates;

--creating a temp table
create table #bottomstates 
(state varchar(255),
average_literacy int);

--inserting top 3 values in table
insert into #bottomstates select top 3 state, round (avg(literacy),0) as Avg_literacy from Data1 group by State order by Avg_literacy;

select * from #bottomstates;

                                   --combining top and bottom tables using union operator

select * from #topstates 
union 
select * from #bottomstates;
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                                              --filtering using alphabets--
-- Filter states starting with letter a
select * from Data1;
select state from Data1 where state like 'a%';
                                     
-- Filter distinct states starting with letter a 
select distinct state from Data1 where state like 'a%';

-- Filter distinct states starting with letter a and give a count
select count(distinct state) from Data1 where state like 'a%';

-- Filter distinct states starting with letter a or ending with letter d (also give the count)
select distinct state from Data1 where state like 'a%' or state like '%d';
select count(distinct state) from Data1 where state like 'a%' or state like '%d';

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                                --Number of males and Females (Using population and sex ratio)
select * from Data1;
select * from Data2;

--Simply joining 2 tables
select a.district,a.state,a.Sex_Ratio, b.Population from Data1 as a inner join Data2 as b on a.district = b.District; 

-- Approach:
-- Sex_ratio = (females/males) 
-- females   = Sex_ratio*males --eq1
-- females   = population - males --eq2

-- Sex_ratio*males = population- males
-- Sex_ratio*males + males = population
-- males (Sex_ratio + 1) = population
-- males = population /(Sex_ratio + 1) -- eq 3 

-- females = population - males -- from eq2
-- females = population - (population /(Sex_ratio + 1)) -- eq4 

-- Normalising sex ratio
select a.district,a.state,a.Sex_Ratio/1000 as Sex_ratio, b.Population from Data1 as a inner join Data2 as b on a.district = b.District; 


                                  -- males and females by ditrict (joined tables/nested queries)

select c.district, c.state , c.population /(c.Sex_ratio + 1) as males, c.population - (c.population /(c.Sex_ratio + 1)) as females from (
select a.district,a.state,a.Sex_Ratio/1000 as Sex_ratio, b.Population from Data1 as a inner join Data2 as b on a.district = b.District) as c; 

-- rounding off 
select c.district, c.state , round(c.population /(c.Sex_ratio + 1),0) as males, round(c.population - (c.population /(c.Sex_ratio + 1)),0) as females from (
select a.district,a.state,a.Sex_Ratio/1000 as Sex_ratio, b.Population from Data1 as a inner join Data2 as b on a.district = b.District) as c; 


-- some more commands to verify the above output.
select sum(e.population) as total1, sum(e.total_pop_verify) as total2 from  
(select d.population, (d.males + d.females) as total_pop_verify from 
(select c.district, c.state , round(c.population /(c.Sex_ratio + 1),0) as males, round(c.population - (c.population /(c.Sex_ratio + 1)),0) as females,c.Population from (
select a.district,a.state,a.Sex_Ratio/1000 as Sex_ratio, b.Population from Data1 as a inner join Data2 as b on a.district = b.District) as c) as d) as e ; 

--Above command Details: 
--layer 1 : joining 2 tables
--layer 2 as c: generating males and females by district 
--layer 3 as d: verifying population by adding m and f comparing it with original population. 
--layer 4 as e: verifying the sum of addition of population from both the population columns.


                                       -- males and females by state (joined tables/nested queries)

select d.state, round(avg(d.males),0) as males_statewise, round(avg(d.females),0)  as females_statewise from
(select c.state , round(c.population /(c.Sex_ratio + 1),0) as males, round(c.population - (c.population /(c.Sex_ratio + 1)),0) as females,c.Population from (
select a.district,a.state,a.Sex_Ratio/1000 as Sex_ratio, b.Population from Data1 as a inner join Data2 as b on a.district = b.District) as c) as d group by d.State;

--Above command Details: 
--layer 1 : joining 2 tables
--layer 2 as c: generating males and females 
--layer 3 as d: grouping males and females state wise using round(avg(),) and group by

---------------------------------------------------------------------------------------------------------------------------------------------------------------------
										      -- literate and illiterate people by district
-- Approach:
-- literacy_ratio = literate /population
-- literate = literacy_ratio * population
-- illiterate = (1-literacy_ratio) * population

select c.district, c.state, round((c.literacy_ratio * c.population),0) as literate, round(((1-c.literacy_ratio) * c.population),0) as illiterate from
(select a.district,a.state,a.literacy/100 as literacy_ratio, b.Population from Data1 as a inner join Data2 as b on a.district = b.District) as c;

--Above command Details: 
--layer 1 : joining 2 tables 
--layer 2 as c: generating literate and illiterate by district (round off)

		                                       -- literate and illiterate people by state

select c.state, round(sum(c.literacy_ratio * c.population),0) as literate, round(sum((1-c.literacy_ratio) * c.population),0) as illiterate from
(select a.district,a.state,a.literacy/100 as literacy_ratio, b.Population from Data1 as a inner join Data2 as b on a.district = b.District) as c group by c.state;

--Above command Details: 
--layer 1 : joining 2 tables 
--layer 2 as c: generating literate and illiterate by state (round off/group by)

                                      -- literate and illiterate people by state order by highest literacy
select c.state, round(sum(c.literacy_ratio * c.population),0) as literate, round(sum((1-c.literacy_ratio) * c.population),0) as illiterate from
(select a.district,a.state,a.literacy/100 as literacy_ratio, b.Population from Data1 as a inner join Data2 as b on a.district = b.District) as c group by c.state order by literate desc;

-- Verifying above results
select *,(d.literate + d.illiterate) as pop_verify from (select c.state, round(sum(c.literacy_ratio * c.population),0) as literate, round(sum((1-c.literacy_ratio) * c.population),0) as illiterate,sum(c.population) as population from
(select a.district,a.state,a.literacy/100 as literacy_ratio, b.Population from Data1 as a inner join Data2 as b on a.district = b.District) as c group by c.state)as d;

                                              -- top 3 literate states population ?

select top 3  c.state, round(sum(c.literacy_ratio * c.population),0) as literate, round(sum((1-c.literacy_ratio) * c.population),0) as illiterate from
(select a.district,a.state,a.literacy/100 as literacy_ratio, b.Population from Data1 as a inner join Data2 as b on a.district = b.District) as c group by c.state order by literate desc;

                                                  -- bottom 3 literate states population ?
select top 3  c.state, round(sum(c.literacy_ratio * c.population),0) as literate, round(sum((1-c.literacy_ratio) * c.population),0) as illiterate from
(select a.district,a.state,a.literacy/100 as literacy_ratio, b.Population from Data1 as a inner join Data2 as b on a.district = b.District) as c group by c.state order by literate;

                                         -- combine top3 literate and bottom 3 literate states by population

select * from (select top 3  c.state, round(sum(c.literacy_ratio * c.population),0) as literate, round(sum((1-c.literacy_ratio) * c.population),0) as illiterate from
(select a.district,a.state,a.literacy/100 as literacy_ratio, b.Population from Data1 as a inner join Data2 as b on a.district = b.District) as c group by c.state order by literate desc) as x 
union
select * from (select top 3  c.state, round(sum(c.literacy_ratio * c.population),0) as literate, round(sum((1-c.literacy_ratio) * c.population),0) as illiterate from
(select a.district,a.state,a.literacy/100 as literacy_ratio, b.Population from Data1 as a inner join Data2 as b on a.district = b.District) as c group by c.state order by literate) as y order by literate desc;

                                                     -- Show literate population for kerala only
select * from
(select c.state,round(sum(c.literacy_ratio * c.population),0) as literate from
(select a.district,a.state,a.literacy/100 as literacy_ratio, b.Population from Data1 as a inner join Data2 as b on a.district = b.District) as c group by c.state) as d where state = 'Kerala';

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
													     -- Population in previous census by district
select * from Data1;
select * from Data2;

-- Combining 2 tables (growth and population)
select a.district, a.state, a.growth, b.Population from data1 as a inner join data2 as b on a.district = b.district;

-- Approach:
--curent_census_population = previous_census_population + increase in previous_census_population
--curent_census_population = previous_census_population + (%growth * previous_census_population)
--curent_census_population = previous_census_population(1+%growth)
--previous_census_population = curent_census_population/(1+%growth)

select c.district,c.state, c.population as curent_census_population, round(c.population/(1+c.growth),0) as previous_census_population from 
(select a.district, a.state, a.growth, b.Population from data1 as a inner join data2 as b on a.district = b.district) as c;

-- Quick verification
select * , round(((d.growth*d.previous_census_population)+d.previous_census_population),0) as pop_verify from
(select *, round(c.population/(1+c.growth),0) as previous_census_population from 
(select a.district, a.state, a.growth, b.Population from data1 as a inner join data2 as b on a.district = b.district) as c) as d;


												    -- Population in previous census by state

 
select c.state, sum(c.population) as curent_census_population, sum(round(c.population/(1+c.growth),0)) as previous_census_population from 
(select a.district, a.state, a.growth, b.Population from data1 as a inner join data2 as b on a.district = b.district) as c group by state;

--count
select sum(curent_census_population) as curent_census_population , sum(previous_census_population) as previous_census_population from
(select c.state, sum(c.population) as curent_census_population, sum(round(c.population/(1+c.growth),0)) as previous_census_population from 
(select a.district, a.state, a.growth, b.Population from data1 as a inner join data2 as b on a.district = b.district) as c group by state) as d;


																--quick verification 

select * from data2;  -- observe that there are some null values in state column which are omitted while joining

--run below 3 commands simultaneously for verification.(The difference in total_population is due to the null values)
select sum(population) as total_population_original from Data2; 

select sum(c.population) as total_population from
(select a.district, a.state, a.growth, b.Population from data1 as a inner join data2 as b on a.district = b.district) as c; -- 1st layer of below command used

select sum(d.current_census_population) as total_population from 
(select c.state, sum(c.population) as current_census_population, sum(round(c.population/(1+c.growth),0)) as previous_census_population from 
(select a.district, a.state, a.growth, b.Population from data1 as a inner join data2 as b on a.district = b.district) as c group by state)as d; --all layers used from above

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
																		-- Area vs population
-- some basic supporting syntaxes
select * from data2;

select '1' as keyy,* from (select * from data2) as a; -- for understanding(adding column with keys)

select 1 as keyy,sum(area_km2) as total_area from data2;

select '1' as keyy, sum(curent_census_population) as curent_census_population , sum(previous_census_population) as previous_census_population from
(select c.state, sum(c.population) as curent_census_population, sum(round(c.population/(1+c.growth),0)) as previous_census_population from 
(select a.district, a.state, a.growth, b.Population from data1 as a inner join data2 as b on a.district = b.district) as c group by state) as d;


select '1' as keyy,g.* from(select sum(curent_census_population) as curent_census_population , sum(previous_census_population) as previous_census_population from
(select c.state, sum(c.population) as curent_census_population, sum(round(c.population/(1+c.growth),0)) as previous_census_population from 
(select a.district, a.state, a.growth, b.Population from data1 as a inner join data2 as b on a.district = b.district) as c group by state) as d) as g
 
 inner join 

 (select 1 as keyy,f.* from (select sum(area_km2) as total_area from data2) as e)as f on g.keyy = f.keyy;
