set search_path to uber;

--create a veiw to match drivers and rating they get
drop view if EXISTS driverWRating CASCADE;
create view driverWRating as
select t.request_id, d.driver_id, t.rating
from (driverrating natural join request) t, dispatch d
where t.request_id = d.request_id;

select * from driverWRating;

--create a view for (driver_id, rating, count(rating))
--so that we sum up the number of rating for each level of rating a driver receives
drop view if EXISTS driverRatingCount CASCADE;
create view driverRatingCount as
select driver_id, rating, count(rating) as counts
from driverwrating
group by driver_id, rating;

select * from driverratingcount;

-- filter out rating = 5
drop view if EXISTS rating5;
create view rating5 as
select driver_id, counts as r5
from driverRatingCount
where rating = 5;

select * from rating5;

-- filter out rating = 4
drop view if EXISTS rating4;
create view rating4 as
select driver_id, counts as r4
from driverRatingCount
where rating = 4;

select * from rating4;

-- filter out rating = 3
drop view if EXISTS rating3;
create view rating3 as
select driver_id, counts as r3
from driverRatingCount
where rating = 3;

select * from rating3;

-- filter out rating = 2
drop view if EXISTS rating2;
create view rating2 as
select driver_id, counts as r2
from driverRatingCount
where rating = 2;

select * from rating2;

-- filter out rating = 1
drop view if EXISTS rating1;
create view rating1 as
select driver_id, counts as r1
from driverRatingCount
where rating = 1;

select * from rating1;


-- create a table for this query
drop table if EXISTS q7;
create table q7 (
driver_id integer,
r5 integer default null,
r4 integer default null,
r3 integer default null,
r2 integer default null,
r1 integer default null
);

select * from q7;

-- insert a list of driver ids into the result table
insert into q7
select driver_id
from driver;

-- udpate driver with the count of rating = 5 he receives
update q7
set r5 = rating5.r5
from rating5
where q7.driver_id = rating5.driver_id;

-- udpate driver with the count of rating = 4 he receives
update q7
set r4 = rating4.r4
from rating4
where q7.driver_id = rating4.driver_id;

-- udpate driver with the count of rating = 3 he receives
update q7
set r3 = rating3.r3
from rating3
where q7.driver_id = rating3.driver_id;

-- udpate driver with the count of rating = 2 he receives
update q7
set r2 = rating2.r2
from rating2
where q7.driver_id = rating2.driver_id;

-- udpate driver with the count of rating = 1 he receives
update q7
set r1 = rating1.r1
from rating1
where q7.driver_id = rating1.driver_id;

select * from q7;
