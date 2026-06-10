-- Business Question 4: Airport Run Recovery vs. Local Trips (2020-2022)
SELECT
  EXTRACT(YEAR FROM pickup_datetime) AS trip_year,
  -- Categorize the dropoff location
  CASE 
    WHEN dropoff_location_id = '132' THEN 'JFK Airport'
    WHEN dropoff_location_id = '138' THEN 'LaGuardia Airport'
    ELSE 'Local City Trip'
  END AS trip_type,
  COUNT(*) AS total_trips,
  ROUND(AVG(total_amount), 2) AS avg_total_revenue
FROM `nyc_taxi_analytics.cleaned_trips_2020_2022`
GROUP BY 1, 2
ORDER BY trip_type, trip_year;