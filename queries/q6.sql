set search_path to uber;
--create a view for request and dropoff so that we can filter out all requests that are finished and get a client for each request
drop view IF EXISTS finishedRequest CASCADE;
create view finishedRequest as
select r.request_id as request_id, r.client_id as client_id, r.datetime
from request r, dropoff d
where r.request_id = d.request_id;


--create a view for clients and the count of rides they have in each year they have at least one ride
drop view if EXISTS clientsCountofRides;
create view clientsCountofRides as
select client_id, EXTRACT(year from datetime) as year, count(request_id) as rides
from finishedRequest
group by client_id, EXTRACT(year from datetime);

--create a view for the clients with the top 3 rides in a single year
drop view if EXISTS topClients;
create view topClients as
select client_id, year, rides
from clientsCountofRides
where rides in (SELECT DISTINCT rides FROM clientsCountofRides ORDER BY rides DESC LIMIT 3)
order by rides desc;

select * from topClients;

--create a view for clients with the bottom 3 rides in a single year
drop view if EXISTS bottomClients;
create view bottomClients as
select client_id, year, rides
from clientsCountofRides
where rides in (SELECT DISTINCT rides FROM clientsCountofRides ORDER BY rides LIMIT 3)
order by rides;

SELECT * from bottomclients;

--create a view to merge topClients with bottomClients and remove the duplicate
drop view if EXISTS topAndBottomClients;
create view topAndBottomClients as
select DISTINCT *
from ((select * from topclients) union (select * from bottomclients)) m
order by rides desc;

select * from topAndBottomClients;

--create a table for the final answer
drop table if exists q6;
create table q6(
client_id integer,
year varchar(4),
rides integer);

insert into q6
select * from topAndBottomClients;

select * from q6;