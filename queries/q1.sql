----------------------------------- QUERY 1 ------------------------------------
-- For each type of luxury (hot tub etc.),
-- report the number of properties that offer that luxury.
--------------------------------------------------------------------------------

DROP TABLE IF EXISTS Query1 cascade;
CREATE TABLE Query1 AS
    SELECT serviceName, COALESCE(count(propertyID), 0) AS instances
    FROM Luxuries NATURAL LEFT JOIN PropertyLuxuries
    GROUP BY serviceName;

-- Display the table:
SELECT * from Query1;

--------------------- SAMPLE TABLE FROM RUNNING THIS QUERY ---------------------

--       servicename        | instances
-- -------------------------+-----------
-- sauna                    |         2
-- laundry service          |         2
-- daily breakfast delivery |         1
-- daily cleaning           |         3
-- concierge service        |         2
-- hot tub                  |         4
-- (6 rows)

--------------------------------------------------------------------------------
