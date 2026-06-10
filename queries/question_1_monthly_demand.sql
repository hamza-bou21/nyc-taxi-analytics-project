-- Business Question 1: Monthly Trip Volume and MoM Growth (2020-2022)
WITH monthly_trips AS (
  SELECT
    DATE_TRUNC(pickup_datetime, MONTH) AS trip_month,
    COUNT(*) AS total_trips
  FROM `nyc_taxi_analytics.cleaned_trips_2020_2022`
  GROUP BY 1
)
SELECT
  trip_month,
  total_trips,
  LAG(total_trips) OVER(ORDER BY trip_month) AS prev_month_trips,
  ROUND(((total_trips - LAG(total_trips) OVER(ORDER BY trip_month)) / LAG(total_trips) OVER(ORDER BY trip_month)) * 100, 2) AS mom_growth_percentage
FROM monthly_trips
ORDER BY trip_month;