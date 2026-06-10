-- Business Question 3: Financial Trends & Tipping Behavior (2020-2022)
SELECT
  EXTRACT(YEAR FROM pickup_datetime) AS trip_year,
  ROUND(AVG(fare_amount), 2) AS avg_base_fare,
  ROUND(AVG(tip_amount), 2) AS avg_tip_amount,
  -- Calculate average tip percentage specifically for credit card trips
  ROUND(
    AVG(
      CASE 
        WHEN payment_type = '1' AND fare_amount > 0 THEN (tip_amount / fare_amount) * 100 
        ELSE NULL 
      END
    ), 2
  ) AS avg_credit_card_tip_percentage
FROM `nyc_taxi_analytics.cleaned_trips_2020_2022`
WHERE fare_amount >= 0 -- Omit negative erroneous fares
GROUP BY 1
ORDER BY trip_year;