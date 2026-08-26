-- 1.
-- Inspect both tables to get a grasp on what's going on
-- Notice: The column dteday of both tables are set to varchar, how to transfrom to the data type string?

SELECT *
FROM   bike_share_yr_0;

SELECT *
FROM   bike_share_yr_1;

-- 2.
-- Try to convert dteday column to data type DATE by using TRY_CONVERT and filters rows that cannot be converted.
-- Output:Dates from 15/1/2021 until 31/12/2021 cannot be converted 

SELECT dteday
     , TRY_CONVERT (DATE, dteday) AS safe_day
FROM   bike_share_yr_0
WHERE  TRY_CONVERT (DATE, dteday) IS NULL;

-- 3. 
-- Assume that dteday column is following the British date style, assign the style code of 103
-- Output: Blank which mean the query has sucessfully convert data type from varchar to date

SELECT dteday
     , CONVERT (DATE, dteday, 103) AS safeday
FROM   bike_share_yr_0
WHERE  CONVERT (DATE, dteday, 103) IS NULL;

-- 4.
-- Insert converted values into the original columns

-- 4.1
-- Create a temp table to store all the data of the original table

CREATE TABLE #temp
(
    dteday DATE
  , season INT
  , yr INT
  , mnth INT
  , hr INT
  , holiday INT
  , weekday INT
  , workingday INT
  , weathersit INT
  , atemp DECIMAL (10, 2)
  , hum DECIMAL (10, 2)
  , windspeed DECIMAL (10, 4)
  , rider_type VARCHAR (50)
  , riders INT
);

-- 4.2
-- Insert data from all columns of the original table to the temp table in paralel with data conversion

INSERT INTO #temp (dteday, season, yr, mnth, hr, holiday, weekday, workingday, weathersit, atemp, hum, windspeed, rider_type, riders)
SELECT CONVERT (DATE, dteday, 103)
     , season
     , yr
     , mnth
     , hr
     , holiday
     , weekday
     , workingday
     , weathersit
     , atemp
     , hum
     , windspeed
     , rider_type
     , riders
FROM   bike_share_yr_0;

-- 4.3
-- Insert data from the temp table to the original table
-- Alter the dteday of the original table to DATE

ALTER TABLE bike_share_yr_0 ALTER COLUMN dteday DATE;

INSERT INTO bike_share_yr_0
SELECT dteday
     , season
     , yr
     , mnth
     , hr
     , holiday
     , weekday
     , workingday
     , weathersit
     , '1.00'
     , atemp
     , hum
     , windspeed
     , rider_type
     , riders
FROM   #temp;

-- do the same for bike_share_yr_1 table