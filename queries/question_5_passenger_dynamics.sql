-- Business Question 5: Passenger Count Distribution & Social Trends (2020-2022)
WITH passenger_counts AS (
  SELECT
    EXTRACT(YEAR FROM pickup_datetime) AS trip_year,
    passenger_count,
    COUNT(*) AS total_trips
  FROM `nyc_taxi_analytics.cleaned_trips_2020_2022`
  WHERE passenger_count > 0 AND passenger_count <= 6 -- Focus on valid standard capacities
  GROUP BY 1, 2
)
SELECT
  trip_year,
  passenger_count,
  total_trips,
  -- Now the window function runs beautifully because the data is already pre-grouped!
  ROUND(
    (total_trips / SUM(total_trips) OVER(PARTITION BY trip_year)) * 100, 2
  ) AS percentage_of_years_trips
FROM passenger_counts
ORDER BY trip_year, passenger_count;