-- select *
-- 	from staff
-- 	where
-- 	start_date between to_timestamp('2003','YYYY')  and to_timestamp('2007','YYYY')
-- 	order by
-- 	start_date


-- with tmp as
-- (select
-- 	department,
--  	salary 
-- 	from staff 
-- 	where salary >100000) 
	
-- select tmp.department,
-- 		trunc(avg(tmp.salary))
-- 		from tmp
-- 		group by
-- 		tmp.department


-- select 
-- 	last_name,
-- 	department,
-- 	salary,
-- 	start_date,
-- 	avg(salary) over (partition by department),
-- 	max(salary) over (partition by department),
-- 	min(salary) over (partition by department)
-- 	from staff
-- 	where start_date > to_timestamp('2000','YYYY')
-- 	order by start_date
	
-- select 
-- 	department,
-- 	sum(salary) sum_sal,
-- 	count(salary) n_sal,
-- 	sum(salary)/count(salary) avg_sal,
-- 	trunc(avg(salary)) avg2_sal
-- 	from staff
-- 	group by
-- 	department

-- select 
-- 	* 
-- 	from 
-- 	time_series.location_temp ts

-- create table load_ (
-- 	id integer,
-- 	p_mw real,
-- 	q_mw real,
-- 	zone_ text,
-- 	operation_zone text,
-- 	primary key (id)
-- 	)
	
-- -- insert into load_ (id,p_mw,q_mw,zone_,operation_zone) values (1,100,25,'north east','california');
-- insert into load_ (id,p_mw,q_mw,zone_,operation_zone) values (2,200,20,'north east','miami');
-- insert into load_ (id,p_mw,q_mw,zone_,operation_zone) values (3,300,15,'north east','virginia');
-- insert into load_ (id,p_mw,q_mw,zone_,operation_zone) values (4,140,5,'north east','florida');

-- select * from load_

-- create table load_ (
-- 	Date timestamp,
-- 	Hour_ integer,
-- 	DA_Demand real,
-- 	Demand real,
-- 	DA_lmp real,
-- 	DA_ec real,
-- 	DA_cc real,
-- 	DA_mlc real,
-- 	RT_lmp real,
-- 	RT_ec real,
-- 	RT_cc real,
-- 	RT_mlc real,
-- 	DRYBulb real,
-- 	DEwPnt real,
-- 	sysload real,
-- 	regcp real
-- 	)

-- copy load_ from 'C:/Users/sahmadi7/Desktop/Job/Ex_Files_SQL_EssT/Data.csv' delimiter ',' csv header;

-- create table complaint (
-- 	date date,
--  	product text,
--  	sub_product text,
--  	issue text,
--  	sub_issue text,
--  	Consumer_complaint_narrative text,
--  	Company_public_response text,
--  	company text,
--  	state_ text,
--  	zip_code text,
--  	tags text,
--  	cons_consent_provi text,
--  	Submitted_via text,
--  	Date_sent_to_company date,
--  	Company_response_to_consumer text,
--  	Timely_esponse_ text,
--  	Consumer_disputed_ text,
--  	Complaint_ID integer
--  	)

-- copy complaint from 'C:/Users/sahmadi7/Desktop/Job/Ex_Files_SQL_EssT/cost_comp.csv' delimiter ',' csv header;

-- select 
-- 	state_,
-- 	count(product)
-- 	from complaint
-- 	group by state_
-- 	having state_ is not NULL

-- select * from complaint limit 10
	
-- select 
-- 	product,
-- 	sub_product,
-- 	substr(ltrim('   ' || sub_product  || ' (is) ' || product || ' regarding ' || issue || '   '),7) detailed
-- 	from complaint
-- 	where sub_product similar to 'Other%'


-- select 
-- 	date,
-- 	da_demand,
-- 	da_lmp,
-- 	trunc((select avg(da_demand) from load_)) avg_dem,
-- 	trunc((select stddev_pop(da_demand) from load_)) std_dem,
-- 	(case
-- 	when da_demand >= (select avg(da_demand) from load_)+(select stddev_pop(da_demand) from load_) then 'larg'
-- 	when da_demand < (select avg(da_demand) from load_)+(select stddev_pop(da_demand) from load_) and da_demand > (select avg(da_demand) from load_)-(select stddev_pop(da_demand) from load_) then 'in range'
-- 	when da_demand < (select avg(da_demand) from load_)-(select stddev_pop(da_demand) from load_) then 'small'
-- 	end) class_da
-- 	from load_
-- 	order by class_da


-- select
-- 	date,
-- 	extract(year from date) as year_,
-- 	extract(month from date) as month_,
-- 	extract(day from date-current_timestamp),
-- 	exp(extract(hour from date-current_timestamp))
-- 	from complaint 

-- select
-- 	date_trunc('month' ,date),
-- 	count(date_trunc('month' ,date))
-- 	from complaint
-- 	group by date_trunc('month' ,date)

-- create table temp_tab as
-- (select 
-- 	date_trunc('day',date) as daily_date,
-- 	avg(da_demand) avg_demand
-- 	from load_
-- 	group by date_trunc('day',date)
--  order by date_trunc('day',date)
-- 	)

select * from temp_tab
 
-- (select 
-- 	tmp1.daily_date,
-- 	tmp1.avg_demand,
--  	(select tmp2.avg_demand from temp_tab tmp2 where tmp2.daily_date = tmp1.daily_date - interval '1' day ) first_lag,
--  	tmp1.avg_demand-(select tmp2.avg_demand from temp_tab tmp2 where tmp2.daily_date = tmp1.daily_date - interval '1' day ) delta1,
--  	(regr_slope(avg_demand,(select tmp2.avg_demand from temp_tab tmp2 where tmp2.daily_date = tmp1.daily_date - interval '1' day )) +
--  	regr_intercept(avg_demand,(select tmp2.avg_demand from temp_tab tmp2 where tmp2.daily_date = tmp1.daily_date - interval '1' day ))) over(partition by row)  
-- 	 from temp_tab tmp1
--  	where (select tmp2.avg_demand from temp_tab tmp2 where tmp2.daily_date = tmp1.daily_date - interval '1' day ) is not NULL
-- 	)
 


-- select
-- 	tmp1.*,
-- 	avg(avg_demand) over (rows between current row and 2 following) as MA_12
-- 	from temp_tab tmp1

-- select 
-- 	tmp1.*,
-- 	(select tmp2.avg_demand * .5 from temp_tab tmp2 where tmp2.daily_date= tmp1.daily_date - interval '1' day)+
-- 	(select tmp3.avg_demand * .33 from temp_tab tmp3 where tmp3.daily_date= tmp1.daily_date - interval '2' day)+
-- 	(select tmp4.avg_demand * .17 from temp_tab tmp4 where tmp4.daily_date= tmp1.daily_date - interval '3' day) wavg
-- 	from temp_tab tmp1
	



	
	

