use project;

select * from 
(select avg(population) as avg_pop,state from data2 group by state) as a inner join 
(select sum(population) as sum_pop,state from data2 group by state) as b on a.state = b.state;

select a.state,a.avg_pop, b.sum_pop from 
(select state, round(avg(population),0) as avg_pop from data2 group by state) as a inner join 
(select state, sum(population) as sum_pop from data2 group by state) as b on a.state = b.state;
------------------------------------------------------------------------------------------------------------
select * from data2

--run both commands together
select sum(a.total_pop_state) as total_pop from
(select state, sum(population) as total_pop_state from data2 group by state) as a ;

select sum(population) as total_pop from data2;