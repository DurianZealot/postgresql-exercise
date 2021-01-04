----------------------------------- QUERY 3 ------------------------------------
-- Find the host/hosts with the highest average host rating.
-- Report their email address, average host rating, and the price for the most
-- expensive booking week they have every recorded.
--------------------------------------------------------------------------------

DROP VIEW IF EXISTS Avg_HostRatings cascade;
DROP VIEW IF EXISTS TopHosts cascade;
DROP VIEW IF EXISTS TopHostRentals cascade;
DROP VIEW IF EXISTS Max_TopHostPrice cascade;
DROP TABLE IF EXISTS Query3 cascade;

-- Find the average ratings that were given to property hosts.
CREATE VIEW Avg_HostRatings AS
    SELECT hostID, email, avg(rating) AS avgRating
    FROM HostRating NATURAL JOIN Host
    GROUP BY hostID, email;

-- Find the host(s) that have received the highest average rating.
CREATE VIEW TopHosts AS
    SELECT hostID, email, avgRating
    FROM Avg_HostRatings
    WHERE avgRating = (SELECT max(avgRating) FROM Avg_HostRatings);

-- Find the rentals on properties that are owned by host(s) with the highest
-- average rating.
CREATE VIEW TopHostRentals AS
    SELECT property, rentalID, hostID
    FROM Property NATURAL JOIN TopHosts NATURAL JOIN Rental;

-- Find the max price that the above top host(s) have rented a property for
CREATE VIEW Max_TopHostPrice AS
    SELECT hostID, max(weeklyRate) AS highestPrice
    FROM RentalTerm NATURAL JOIN TopHostRentals
    GROUP BY hostID;

-- Form the final table from the information gathered above.
CREATE TABLE Query3 AS
    SELECT email, avgRating, highestPrice
    FROM Max_TopHostPrice NATURAL JOIN TopHosts;

-- Display the table:
SELECT * from Query3;

--------------------- SAMPLE TABLE FROM RUNNING THIS QUERY ---------------------

--     email     |     avgrating      | highestprice
-- --------------+--------------------+--------------
-- han@gmail.com | 4.3333333333333333 |         1220
-- (1 row)

--------------------------------------------------------------------------------
