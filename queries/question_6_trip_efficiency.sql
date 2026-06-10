-- Business Question 6: Trip Distance, Duration, and Speed Anomalies (2020-2022)
WITH trip_metrics AS (
  SELECT
    EXTRACT(YEAR FROM pickup_datetime) AS trip_year,
    trip_distance,
    -- Calculate ride duration in minutes
    TIMESTAMP_DIFF(dropoff_datetime, pickup_datetime, MINUTE) AS duration_minutes,
    fare_amount
  FROM `nyc_taxi_analytics.cleaned_trips_2020_2022`
)
SELECT
  trip_year,
  ROUND(AVG(trip_distance), 2) AS avg_distance_miles,
  ROUND(AVG(duration_minutes), 2) AS avg_duration_minutes,
  -- Check for impossible data extremes to flag for data cleaning
  MAX(trip_distance) AS max_recorded_distance,
  MIN(trip_distance) AS min_recorded_distance,
  MAX(duration_minutes) AS max_recorded_duration,
  MIN(duration_minutes) AS min_recorded_duration
FROM trip_metrics
WHERE duration_minutes > 0 -- Omit instant cancellations or glitches
GROUP BY 1
ORDER BY trip_year;