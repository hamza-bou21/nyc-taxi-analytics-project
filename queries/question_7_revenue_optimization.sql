-- Business Question 7: Top 10 Most Profitable Zones by Revenue Per Minute (2020-2022)
WITH zone_revenues AS (
  SELECT
    pickup_location_id,
    total_amount,
    TIMESTAMP_DIFF(dropoff_datetime, pickup_datetime, MINUTE) AS duration_minutes
  FROM `nyc_taxi_analytics.cleaned_trips_2020_2022`
  -- Data Cleaning: Use the boundaries we discovered in Question 6 to ignore outliers!
  WHERE trip_distance > 0 AND trip_distance < 100
    AND TIMESTAMP_DIFF(dropoff_datetime, pickup_datetime, MINUTE) > 1 
    AND TIMESTAMP_DIFF(dropoff_datetime, pickup_datetime, MINUTE) < 120
    AND total_amount > 0 AND total_amount < 500
)
SELECT
  zone_lookup.borough AS pickup_borough,
  zone_lookup.zone_name AS pickup_zone, -- Fixed the column name here!
  COUNT(*) AS total_trips,
  ROUND(AVG(zr.total_amount), 2) AS avg_total_amount,
  ROUND(AVG(zr.duration_minutes), 2) AS avg_duration_minutes,
  -- Calculate our core efficiency metric
  ROUND(AVG(zr.total_amount / zr.duration_minutes), 2) AS revenue_per_minute
FROM zone_revenues AS zr
INNER JOIN `bigquery-public-data.new_york_taxi_trips.taxi_zone_geom` AS zone_lookup
  ON zr.pickup_location_id = zone_lookup.zone_id
GROUP BY 1, 2
HAVING total_trips > 1000 -- Focus only on active zones, ignore fluke single trips
ORDER BY revenue_per_minute DESC
LIMIT 10;