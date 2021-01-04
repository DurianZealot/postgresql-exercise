----------------------------------- QUERY 5 ------------------------------------
-- For each property, report the highest price ever charged for a week renting
-- that property, the lowest price, and the range. Include a column that has
-- a star in it for any property/properties with the highest range.
--------------------------------------------------------------------------------

DROP VIEW IF EXISTS priceRange CASCADE;
DROP TABLE IF EXISTS Query5 CASCADE;

-- Find the highest rate, lowest rate, and price range for every property that
-- has been rented before.
CREATE VIEW priceRange AS
    SELECT propertyID,
           max(weeklyRate) AS maxPrice,
           min(weeklyRate) AS minPrice,
           max(weeklyRate) - min(weeklyRate) AS priceRange
    FROM RentalTerm NATURAL JOIN Rental
    GROUP BY propertyID;

-- Generate the table displaying price and range for all properties.
CREATE TABLE Query5 AS
    SELECT *
    FROM (SELECT propertyID FROM property) ids NATURAL FULL JOIN priceRange
    ORDER BY propertyID ASC;

-- Add an indicator for the property with the highest price range.
ALTER TABLE Query5 ADD highestRange VARCHAR(1);
UPDATE Query5
    SET highestRange = '*'
    WHERE priceRange = (SELECT max(priceRange) FROM priceRange);

-- Display the table:
SELECT * from Query5;

--------------------- SAMPLE TABLE FROM RUNNING THIS QUERY ---------------------

--  propertyid | maxprice | minprice | pricerange | highestrange
--  -----------+----------+----------+------------+--------------
--           1 |          |          |            |
--           2 |      600 |      580 |         20 |
--           3 |      750 |      750 |          0 |
--           4 |          |          |            |
--           6 |          |          |            |
--           5 |     1220 |     1000 |        220 | *
-- (6 rows)

--------------------------------------------------------------------------------
