-- Calculate 3-days moving average of revenue per year

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
, -- Calculate total revenue per day
       CTE4
AS     (SELECT   DATEPART(year, dteday) AS year
               , dteday
               , SUM(revenue) AS revenue_per_day
        FROM     CTE2
        GROUP BY DATEPART(year, dteday), dteday)
SELECT year
     , dteday
     , revenue_per_day
     , CAST (ROUND(AVG(revenue_per_day) OVER (PARTITION BY year ORDER BY dteday ASC ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 0) AS INT) AS three_day_MA
FROM   CTE4;