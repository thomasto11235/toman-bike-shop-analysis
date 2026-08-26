-- 6.
-- Create a CTE to enclose the UNION result which later can be used to join with the cost table for further details

WITH   CTE
AS     (SELECT *
        FROM   bike_share_yr_0
        UNION ALL
        SELECT *
        FROM   bike_share_yr_1)
,      CTE2
AS     (SELECT dteday
             , a.yr
             , hr
             , weekday
             , riders
             , price
             , COGS
             , (riders * price) AS revenue -- Calculate the revenue
             , (riders * price) - (COGS * riders) AS profit -- Calculate the profit
        FROM   CTE AS a
               INNER JOIN cost_table AS b
                   ON a.yr = b.yr)
, -- Calculate the monthly revenue percentage difference by year
       CTE3
AS     (SELECT   DATETRUNC(year, dteday) AS year
               , DATETRUNC(month, dteday) AS month
               , SUM(revenue) AS monthly_revenue
               , LAG(SUM(revenue), 1) OVER (PARTITION BY DATETRUNC(year, dteday) ORDER BY DATETRUNC(month, dteday)) AS previous_month_revenue
               , CAST (ROUND((SUM(revenue) - LAG(SUM(revenue), 1) OVER (PARTITION BY DATETRUNC(year, dteday) ORDER BY DATETRUNC(month, dteday))) / LAG(SUM(revenue), 1) OVER (PARTITION BY DATETRUNC(year, dteday) ORDER BY DATETRUNC(month, dteday)), 2) AS DECIMAL (10, 2)) AS percentage_difference
        FROM     CTE2
        GROUP BY DATETRUNC(year, dteday), DATETRUNC(month, dteday))
SELECT *
FROM   CTE3
WHERE  previous_month_revenue IS NOT NULL;