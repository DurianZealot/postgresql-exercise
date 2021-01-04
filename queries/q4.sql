----------------------------------- QUERY 4 ------------------------------------
-- For each type (city property, water property, and other) report the average
-- number of extra guests (that is, not including the renter themself) for
-- properties of that type. Compute the average across all rentings of that
-- type of property. Each renting should contribute once to the average, even
-- if it is for multiple weeks.
--------------------------------------------------------------------------------

DROP VIEW IF EXISTS Avg_CityGuests cascade;
DROP VIEW IF EXISTS Avg_WaterfrontGuests cascade;
DROP VIEW IF EXISTS Avg_GuestsOther cascade;
DROP TABLE IF EXISTS Query4 cascade;

-- Find the average number of guests that stay at urban properties
-- This view generates the first row of the final table.
CREATE VIEW Avg_CityGuests AS
    SELECT 'City Property' AS PropertyType,
            COALESCE(avg(occupancy - 1), 0) AS extraGuests
    FROM Urban NATURAL JOIN Rental;

-- Find the average number of guests that stay at waterfront properties
-- This view generates the second row of the final table.
CREATE VIEW Avg_WaterfrontGuests AS
    SELECT 'Water Property' AS PropertyType,
            COALESCE(avg(occupancy - 1), 0) AS extraGuests
    FROM WaterFront NATURAL JOIN Rental;

-- Find the average number of guests that stay at other property types
-- This view generates the last row of the final table.
CREATE VIEW Avg_GuestsOther AS
    SELECT 'Other Property' AS PropertyType,
            COALESCE(avg(occupancy - 1), 0) AS extraGuests
    FROM Other NATURAL JOIN Rental;

-- Generate the result table
CREATE TABLE Query4 AS
    SELECT * FROM((SELECT * FROM Avg_CityGuests)
    UNION
    (SELECT * FROM Avg_WaterfrontGuests)
    UNION
    (SELECT * FROM Avg_GuestsOther)) AS RESULT;

-- Display the table:
SELECT * from Query4;

--------------------- SAMPLE TABLE FROM RUNNING THIS QUERY ---------------------

--  propertytype  |      extraguests
-- ---------------+------------------------
-- City Property  |     2.0000000000000000
-- Water Property | 1.00000000000000000000
-- Other Property |                      0
-- (3 rows)

--------------------------------------------------------------------------------
