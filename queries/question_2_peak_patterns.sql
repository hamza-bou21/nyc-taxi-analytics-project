-- Business Question 2: Peak Hours and Days by Borough (2020-2022)
SELECT
  zone_lookup.borough AS pickup_borough,
  EXTRACT(DAYOFWEEK FROM trips.pickup_datetime) AS day_of_week,
  EXTRACT(HOUR FROM trips.pickup_datetime) AS pickup_hour,
  COUNT(*) AS total_trips
FROM `nyc_taxi_analytics.cleaned_trips_2020_2022` AS trips
INNER JOIN `bigquery-public-data.new_york_taxi_trips.taxi_zone_geom` AS zone_lookup
  ON trips.pickup_location_id = zone_lookup.zone_id
WHERE zone_lookup.borough != 'Unknown'
GROUP BY 1, 2, 3
ORDER BY total_trips DESC;