use happy
select * from emp1;
select * from emp2;
--================================================SOME BASIC COMMANDS===========================

update emp1 set e_salary= 20000 where e_dept = 'mechanical'--update table to specific value

delete from emp1 where e_salary = 80000; --delete single row from table

delete from emp1 where e_id in (11,12,13,14);-- delete multiple rows from table

SELECT * INTO ajay2table FROM emp1 WHERE 1 = 0; -- copy the format of the table only

select * into NEW_TABLE from OLD_TABLE; -- to copy all table content from old to new

--=======================================TO CHANGE COLUMN NAME/TABLE NAME =======================
EXEC sp_rename 'employee', 'employee1'  -- Sql Server
rename table old_name to new_name;      -- MySql Workbench

alter table table_name
change column old_column new_column varchar(20);

--================================================================================================
insert into emp2 values
(1,'Sid', 1200000, 'Analytics');

insert into emp2 values
(9,'Sid', 1200000, 'Analytics');

--============Insert and skip columns=================

insert into student(e_id, e_name, e_gender)
			 values(1,'sam', 'male');

--===========Insert without id (auto populate)====
--SQL SERVER
create table #emp1_temp_table (
e_id int identity(1,1) primary key,
e_name varchar(20),
e_salary int,
e_age int,
e_gender varchar(20),
e_dept varchar(20));

--MYSQL
CREATE TABLE Persons (
    Personid int NOT NULL AUTO_INCREMENT,
    LastName varchar(255) NOT NULL,
    FirstName varchar(255),
    Age int,
    PRIMARY KEY (Personid)
);

--------------------------------------------------------JOINS---------------------------------------------------

select * from emp1 
inner join 
emp2 on emp1.e_id = emp2.e_id;

select * from emp1 
left join 
emp2 on emp1.e_id = emp2.e_id;

select * from emp1 
right join 
emp2 on emp1.e_id = emp2.e_id;

select * from emp1 
full join 
emp2 on emp1.e_id = emp2.e_id;

-------------------------------------------------------------------------------------------------
select * from emp1 
inner join 
emp2 on emp1.e_dept = emp2.e_dept;

select * from emp1 
left join 
emp2 on emp1.e_dept = emp2.e_dept;

select * from emp1 
right join 
emp2 on emp1.e_dept = emp2.e_dept;

select * from emp1 
full join 
emp2 on emp1.e_dept = emp2.e_dept;
-------------------------------------------------------UPDATE USING JOIN -----------------------------------------------------------
--used where table1 data needs to be updated based on the table2 column(join and update used together)

alter table emp2 add e_location varchar (20);
update emp2 set e_location = 'Canada' where e_id = 9;

alter table emp1 add e_age int;
update emp1 set e_age = '50' where e_id between 5 and 8;

update emp1 set e_age=e_age+8 from emp1 
join emp2
on emp1.e_dept = emp2.e_dept where e_location = 'Newyork';

-------------------------------------------------------DELETE USING JOIN -----------------------------------------------------------
delete emp1 from emp1 
join emp2
on emp1.e_dept = emp2.e_dept where e_location = 'Newyork'; 

-------------------------------------------------------UNION/UNION ALL/A UNION ALL B/INTERSECT	 -----------------------------------------------------------
-- shows only those rows which are unique(exactly matching rows are not displayed)
use mark
update mark1 set m_dept = 'analytics' where m_id = 5;

--union shows only unique rows (duplicates are shown only once)
select * from mark
union
select * from mark1;

-- union all shows everything
select * from mark
union all 
select * from mark1;

-- except shows unique from 1st table
select * from mark
except
select * from mark1;

--except shows unique from 1st table (reverse the sequence of table)
select * from mark1
except
select * from mark;

--intersect shows only duplicates
select * from mark1
intersect
select * from mark;

------------------------------------------------------------VIEWS -------------------------------------------------------
use happy;
drop view emp_view;

create view emp_view as select * from emp1 where e_salary> =100000 ;

select * from emp1;
select * from emp_view;

-------------------------------------------------------Alter table/add columns/drop columns -------------------------------------------------------
alter table emp1 add e_date date;

select * from emp1;
update emp1 set e_date = '29/december/2020' where  e_age> 20;

alter table emp1 drop column e_date; 

-------------------------------------------------------Merge(Combination of insert delete and update) -------------------------------------------------------
--------------------Data Preparation---------------------
use practice;
select * from employee;
truncate table employee;

sp_rename 'employee', 'employee_source';

--- source table 
drop table employee_source;
create table employee_source (
e_id int,
e_name varchar(20),
e_salary int,
e_age int,
e_gender varchar(20),
e_dept varchar(20))


insert into employee_source values (
1, 'sam',93000,40,'male','operations')

insert into employee_source values (
2, 'bob',80000,21,'male','support')

insert into employee_source values (
3, 'anne',130000,25,'female','analytics')

insert into employee_source values (
6, 'jeff',112000,27,'male','content')

insert into employee_source values (
7, 'adam',100000,28,'male','content')

insert into employee_source values (
8, 'priya',85000,37,'male','tech')

select * from employee_source;

-- target table
drop table employee_target;
create table employee_target (
e_id int,
e_name varchar(20),
e_salary int,
e_age int,
e_gender varchar(20),
e_dept varchar(20))

insert into employee_target values (
1, 'sam',95000,15,'male','operations')

insert into employee_target values (
2, 'bob',80000,21,'male','support')

insert into employee_target values (
3, 'anne',125000,25,'female','analytics')

insert into employee_target values (
4, 'julia',112000,30,'male','analytics')

insert into employee_target values (
5, 'matt',159000,33,'male','sales')

insert into employee_target values (
8, 'jeff',112000,27,'male','operations')

select * from employee_source;
select * from employee_target;
--------------------------------------------------------MERGE---------------------------------
merge employee_target as T
using
employee_source as S
on 
T.e_id = S.e_id
when matched 
then update set T.e_salary = S.e_salary, T.e_age = S.e_age
when not matched by target 
then insert (e_id,e_name,e_salary,e_age,e_gender, e_dept)
values (S.e_id,S.e_name,S.e_salary,S.e_age,S.e_gender, S.e_dept)
when not matched by source 
then delete;
select * from employee_target;


--------------------------------------------------------SCALAR FUNCTION/TABLED FUNCTION-------------------------------------------
--SCALAR--(once set cannot be changed)- used with single value        

use practice;
drop function add_five;

create function add_five(@num as int)
returns int 
as 
begin return(@num+5)
end

select dbo.add_five(10) as column_name;
----------

drop function custom_function;

create function custom_function(@sid as int)
returns int 
as 
begin return(@sid+10)
end

select dbo.custom_function(20) as column_name;
select dbo.custom_function(30) as column_name;
select dbo.custom_function(40) as column_name;


--Tabled function--(user can set the value) - used with values inside the tables

drop function select_gender;
select * from employee_target;

create function select_gender (@gender as varchar (20))
returns table 
as
return 
(select * from employee_target where e_gender = @gender)

select e_id,e_gender from dbo.select_gender ('male')

--================general format==========
create function function_name(@field_name as data_type)
returns table
as 
return 
(select * from table_name where column_name = @field_name)

select * from dbo.function_name('required_field')
--===============
-------------------------------------------------------#TEMPORARY TABLES / (SAME AS TABLE - GETS DELETED AS THE SESSION IS CLOSED)------------------------------------------

-- just use # - rest same as normal table

drop table #emp1_temp_table;
create table #emp1_temp_table (
e_id int,
e_name varchar(20),
e_salary int,
e_age int,
e_gender varchar(20),
e_dept varchar(20))

insert into #emp1_temp_table values (1, 'sam',93000,40,'male','operations'),
                                    (2, 'bob',80000,21,'male','support'),
                                    (3, 'anne',130000,25,'female','analytics'),
                                    (4, 'jeff',112000,27,'male','content'),
                                    (5, 'adam',100000,28,'male','content'),
                                    (6, 'priya',85000,37,'male','tech');

select * from #emp1_temp_table;


----------------------------------------------------------------------CASE STATEMENT(ADDS COLUMN TO TABLE based on certain conditions)------------------------------------------
-- multiparameters can be used (a,b,c, etc)
select * from employee_target;
select *,
e_grade = case when e_salary<90000 then 'C' when e_salary> 120000 then 'A' else 'B' end 
from employee_target;

----------------------------------------------------------------------IIF STATEMENT(ALTERNATIVE TO CASE STATEMENT)------------------------------------------
-- only boolean expressions can be used
select *, 
iif(e_salary<90000,'C',iif (e_salary>120000,'A','B')) as e_grade
from employee_target

----------------------------------------------------------------------STORED PREOCEDURES------------------------------------------
--Example1
create procedure current_table as select * from employee_target;
current_table; -- method 1
exec current_table; -- method 2

--EXAMPLE2 (passing parameters inside a function)
create procedure emp1_gender @gender varchar(20)
as
select * from employee_target where e_gender = @gender;

emp1_gender @gender = 'male'
emp1_gender @gender = 'female'


----------------------------------------------------------------------EXCEPTION HANDLING(try/catch)------------------------------------------
-- To specify the error in more accurate way
--General Approach:
-- Begin try
-- sql_statement
-- end try

-- begin catch
-- print error/rollback transaction 
-- end catch

--example1
declare @val1 int;
declare @val2 int;

begin try 
set @val1 = 8;
set @val2 = @val1 /0;
end try

begin catch
print error_message()
end catch;

--example2 (adding string and integer to get an error)

begin try
select e_salary + e_name from employee_source
end try

begin catch
print 'cannot add'
end catch;

----------------------------------------------------------------------TRANSACTIONS----------------------------------------------------------
-- transaction is commited only when all commands run successfully
-- if not then transactions are rolled back to its original state

--example1 : successful transaction
begin try 
	begin transaction 
		update employee_target set e_salary = 50 where e_gender = 'male'
		update employee_target set e_salary = 100 where e_gender = 'female'
	commit transaction
		print 'transaction commited'
end try 

begin catch 
	rollback transaction
		print 'transaction rolledback'
end catch

current_table;--stored procedure above

--example2 : unsuccessful transaction(divide by zero)

begin try 
	begin transaction 
		update emp1_target set e_salary = 5 where e_gender = 'male'
		update emp1_target set e_salary = 10/0 where e_gender = 'female'
	commit transaction
		print 'transaction commited'
end try 

begin catch 
	rollback transaction
		print 'transaction rolledback'
end catch

current_table;--stored procedure above

----------------------------------------------------------------------RECOVERING A MODEL----------------------------------------------------------

--3 TYPES 
--1. SIMPLE 
--2. FULL 
--3. BULK LOGGED

