----------------------------------- QUERY 2 ------------------------------------
-- A rental is considered to be “at capacity” if it involves a group of guests
-- (including the renter themself) that is big enough to reach the capacity of
-- the property. Report the average property rating for at-capacity rentals,
-- as well as the number of such rentals. Do the same for rentals that were
-- below capacity.
--------------------------------------------------------------------------------

DROP VIEW IF EXISTS AtCapacityRentals cascade;
DROP VIEW IF EXISTS AtCapacityRatings cascade;
DROP VIEW IF EXISTS BelowCapacityRentals cascade;
DROP VIEW IF EXISTS BelowCapacityRatings cascade;
DROP TABLE IF EXISTS Query2 cascade;

-- Find the guests who were part of At-Capacity rentals
-- and the rentalID of these rental groups.
CREATE VIEW AtCapacityRentals AS
    SELECT rentalID, uniqueKey
    FROM Rental NATURAL JOIN Guest
    WHERE occupancy = capacity;

-- Find the average ratings left by guests of the above At-Capacity rentals.
-- This View should generate the first row of our final table.
CREATE VIEW AtCapacityRatings AS
    SELECT 'At-Capacity' AS capacity, avg(rating) AS averageRating,
            (SELECT count(DISTINCT rentalID)
            FROM AtCapacityRentals) AS rentalCount
    FROM PropertyRating NATURAL JOIN AtCapacityRentals;

-- Find the guests who were part of Below-Capacity rentals
-- and the rentalID of these rental groups.
CREATE VIEW BelowCapacityRentals AS
    SELECT rentalID, uniqueKey
    FROM Rental NATURAL JOIN Guest
    WHERE occupancy < capacity;

-- Find the average ratings left by guests of the above Below-Capacity rentals.
-- This View should generate the second row of our final table.
CREATE VIEW BelowCapacityRatings AS
    SELECT 'Below-Capacity' AS capacity,
            avg(rating) AS averageRating,
            (SELECT count(DISTINCT rentalID)
            FROM BelowCapacityRentals) AS rentalCount
    FROM PropertyRating NATURAL JOIN BelowCapacityRentals;

-- Union the data from both the above capacity and below capcaity ratings.
CREATE TABLE Query2 AS
    (SELECT * FROM AtCapacityRatings)
UNION
    (SELECT * FROM BelowCapacityRatings);

-- Display the table:
SELECT * from Query2;

--------------------- SAMPLE TABLE FROM RUNNING THIS QUERY ---------------------

--    capacity    |   averagerating    | rentalcount
-- ---------------+--------------------+-------------
-- At-Capacity    | 3.8333333333333333 |           3
-- Below-Capacity | 1.6666666666666667 |           2
-- (2 rows)

--------------------------------------------------------------------------------
