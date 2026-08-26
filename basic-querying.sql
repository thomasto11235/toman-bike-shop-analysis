-- 6.
-- Create a CTE to enclose the UNION result which later can be used to join with the cost table for further details

WITH     CTE
AS       (SELECT *
          FROM   bike_share_yr_0
          UNION ALL
          SELECT *
          FROM   bike_share_yr_1)
SELECT   dteday
       , a.yr
       , hr
       , weekday
       , riders
       , price
       , COGS
       , (riders * price) AS revenue -- Calculate the revenue
       , (riders * price) - (COGS * riders) AS profit -- Calculate the profit
FROM     CTE AS a
         INNER JOIN cost_table AS b
             ON a.yr = b.yr
ORDER BY dteday ASC;	