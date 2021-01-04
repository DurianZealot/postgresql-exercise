set search_path to uber;
--create a view for request and dropoff so that we can filter out all requests that are finished and get a client for each request
drop view IF EXISTS finishedRequest CASCADE;
create view finishedRequest as
select r.request_id as request_id, r.client_id as client_id
from request r, dropoff d
where r.request_id = d.request_id;

select * from finishedrequest;

--create a view to match clients with drivers who they have a ride with
drop view if EXISTS clientWDrivers;
create view clientWDrivers as
select DISTINCT client_id, driver_id
from finishedrequest natural join dispatch;

select * from clientwdrivers;

--create a view to find out all rides with a rating given by its client and drivers
drop view IF EXISTS ratingWClientWDriver;
create view ratingWClientWDriver as 
select DISTINCT t.client_id, driver_id
from (request natural join driverrating) t, dispatch d
where t.request_id = d.request_id;

-- create a view for clients who did not rating every driver they have a ride with
drop view if EXISTS clientsNotRateAllDrivers;
create view clientsNotRateAllDrivers as 
(select * from clientWDrivers) EXCEPT ALL (select * from ratingWClientWDriver);

select * from clientsNotRateAllDrivers;

-- create a view for clients who did rating for every driver they have a ride with
drop view if EXISTS clientRateAllDrivers;
create view clientRateAllDrivers as
select t.client_id, client.email
from ((select * from clientwdrivers) EXCEPT ALL (select * from clientsNotRateAllDrivers)) t natural join client;

select * from clientRateAllDrivers;

drop table if EXISTS q9 CASCADE;
create table q9(
client_id integer,
email varchar(30));

insert into q9
select DISTINCT * from clientRateAllDrivers;

select * from q9;