-- Step 0: Create Consolidated Cleaned View (2020-2022)
CREATE OR REPLACE VIEW `nyc_taxi_analytics.cleaned_trips_2020_2022` AS
SELECT 
  pickup_datetime,
  dropoff_datetime,
  passenger_count,
  trip_distance,
  fare_amount,
  tip_amount,
  total_amount,
  rate_code,
  payment_type,
  pickup_location_id,
  dropoff_location_id
FROM `bigquery-public-data.new_york_taxi_trips.tlc_yellow_trips_2020`
WHERE pickup_datetime BETWEEN '2020-01-01 00:00:00' AND '2020-12-31 23:59:59'

UNION ALL

SELECT 
  pickup_datetime,
  dropoff_datetime,
  passenger_count,
  trip_distance,
  fare_amount,
  tip_amount,
  total_amount,
  rate_code,
  payment_type,
  pickup_location_id,
  dropoff_location_id
FROM `bigquery-public-data.new_york_taxi_trips.tlc_yellow_trips_2021`
WHERE pickup_datetime BETWEEN '2021-01-01 00:00:00' AND '2021-12-31 23:59:59'

UNION ALL

SELECT 
  pickup_datetime,
  dropoff_datetime,
  passenger_count,
  trip_distance,
  fare_amount,
  tip_amount,
  total_amount,
  rate_code,
  payment_type,
  pickup_location_id,
  dropoff_location_id
FROM `bigquery-public-data.new_york_taxi_trips.tlc_yellow_trips_2022`
WHERE pickup_datetime BETWEEN '2022-01-01 00:00:00' AND '2022-12-31 23:59:59';