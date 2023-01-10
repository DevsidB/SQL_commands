-- to display top all records wrt the required query
select top 30 state, avg(growth)*100 as avg_growth from project..data1 group by state order by avg_growth desc;


-- to display bottom all record as per the query
select top 30 state, avg(growth)*100 as avg_growth from project..data1 group by state order by avg_growth;


--to display nth highest record table as per query(combine with output with average function as well as nth highest record)  
-- example
select top 1 state, avg_growth from (
select top 30 state, avg(growth)*100 as avg_growth from data1 
group by state order by avg_growth desc) as avg_table
order by avg_growth;

---top and bottom 3 states in literacy ratio
select top 3 * from data1

select * from Data1 
use project ;

--- joining tables 
select * from Data1 
select * from Data2

select c.district,c.state,round((population/(sex_ratio+1)),0)as male,round((population*(sex_ratio/(sex_ratio+1))),0)as female from 
(select a.district,a.state,a.sex_ratio/1000 as sex_ratio,b.population 
from data1 as a 
inner join 
data2 as b 
on a.district=b.district)as c;


