-- Business Question 8: Cash vs. Credit Card Payment Evolution (2020-2022)
WITH payment_totals AS (
  SELECT
    EXTRACT(YEAR FROM pickup_datetime) AS trip_year,
    payment_type,
    COUNT(*) AS total_trips
  FROM `nyc_taxi_analytics.cleaned_trips_2020_2022`
  -- Code 1 = Credit Card, Code 2 = Cash
  WHERE payment_type IN ('1', '2') 
    -- Ignore December 2022 since we discovered it was truncated earlier!
    AND pickup_datetime < '2022-12-01 00:00:00' 
  GROUP BY 1, 2
)
SELECT
  trip_year,
  CASE 
    WHEN payment_type = '1' THEN 'Credit Card'
    WHEN payment_type = '2' THEN 'Cash'
  END AS payment_method,
  total_trips,
  -- Calculate market share percentage for that year
  ROUND(
    (total_trips / SUM(total_trips) OVER(PARTITION BY trip_year)) * 100, 2
  ) AS payment_market_share
FROM payment_totals
ORDER BY trip_year, payment_method;