-- 5.
-- Both tables having the same columns and format. Therefore, it is ideal to put one table on top of another
-- Because records are unique from each table so it is safe to use UNION ALL

SELECT   *
FROM     bike_share_yr_0
UNION ALL
SELECT   *
FROM     bike_share_yr_1
ORDER BY dteday ASC;