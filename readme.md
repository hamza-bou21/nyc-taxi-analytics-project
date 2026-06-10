NYC Taxi Analytics: End-to-End Analytics Engineering Pipeline
🚀 Executive Summary
This project transforms 91 million rows of raw, chaotic New York City Yellow Taxi trip data (2020–2022) into a high-performance, cost-optimized, multi-page business intelligence suite.

By migrating from isolated, single-use data marts to a unified, multi-dimensional Master Data Mart in Google BigQuery, the pipeline achieves 100% global dashboard cross-filtering while maintaining near-zero execution costs. The resulting interactive Looker Studio application delivers critical macroeconomic, financial, and operational insights for fleet management optimization.

Live Dashboard Link: [Insert your Looker Studio Share Link Here]

Technologies Used: Google BigQuery, SQL (DDL/DML), Looker Studio, Analytics Engineering.

🏗️ Data Architecture & Pipeline Optimization
Initially, the dashboard relied on isolated summary tables. While cost-efficient, this architectural pattern created a Data Isolation Bottleneck, cutting off cross-chart communication in the BI layer.

To resolve this, the pipeline was re-engineered to aggregate the raw 91M rows into an optimized, multi-dimensional data matrix. This reduced table size by 99.8% (down to ~120,000 highly dense rows) while completely unlocking native cross-filtering capabilities.

Plaintext
[Raw BigQuery Tables] ──> [Cleaned & Joined Views] ──> [Master Summary Table] ──> [2-Page Looker Studio App]
     (91M Rows)                 (ETL / Joins)               (120k Rows / $0 Cost)           (Fully Synchronized)
The Master ETL Script (BigQuery SQL)
SQL
CREATE OR REPLACE TABLE `nyc_taxi_analytics.master_dashboard_summary` AS
SELECT
  DATE_TRUNC(trips.pickup_datetime, MONTH) AS trip_month,
  EXTRACT(YEAR FROM trips.pickup_datetime) AS trip_year,
  EXTRACT(DAYOFWEEK FROM trips.pickup_datetime) AS day_of_week,
  EXTRACT(HOUR FROM trips.pickup_datetime) AS pickup_hour,
  IFNULL(zone_lookup.borough, 'Unknown') AS pickup_borough,
  CASE 
    WHEN dropoff_location_id = '132' THEN 'JFK Airport'
    WHEN dropoff_location_id = '138' THEN 'LaGuardia Airport'
    ELSE 'Local City Trip'
  END AS trip_type,
  CASE 
    WHEN CAST(payment_type AS STRING) IN ('1', 'Credit card') THEN 'Credit Card'
    WHEN CAST(payment_type AS STRING) IN ('2', 'Cash') THEN 'Cash'
    ELSE 'Other'
  END AS payment_method,
  COUNT(*) AS total_trips,
  SUM(fare_amount) AS total_fare,
  SUM(tip_amount) AS total_tip,
  SUM(total_amount) AS total_revenue
FROM `nyc_taxi_analytics.cleaned_trips_2020_2022` AS trips
LEFT JOIN `bigquery-public-data.new_york_taxi_trips.taxi_zone_geom` AS zone_lookup
  ON trips.pickup_location_id = zone_lookup.zone_id
GROUP BY 1, 2, 3, 4, 5, 6, 7;
📈 Key Business & Operational Insights
1. Macro Demand & "The Manhattan Monopoly"
The Insight: Manhattan completely dominates the Yellow Taxi market share, capturing over 85% of total city-wide volume.

BI Solution: Because standard bar charts compressed outer-borough metrics into unreadable data points, a Donut Chart was deployed to intentionally frame Manhattan's footprint as global market share dominance while preserving visibility for outer-borough categories.

2. The Cashless Acceleration
The Insight: The onset of the 2020 pandemic triggered a massive, permanent behavioral shift. Cash transactions reached historic lows during lockdowns and never recovered to pre-pandemic baselines by late 2022.

BI Solution: Modeled via a 100% Stacked Column Chart to isolate proportional shifts from raw volume drops, illustrating the permanent transition to a digital transit economy.

3. Tipping Behavior & Data Collection Anomalies
The Insight: While Credit Card transactions show highly lucrative hourly surge patterns and higher averages, analysis reveals a systemic industry data gap: digital credit card tips are meticulously logged, while cash tips are consistently omitted from the raw ledger.

BI Solution: Constructed an Hourly Revenue Surge Matrix using custom calculated BI fields (SUM(total_revenue) / SUM(total_trips)) to model true financial yield per ride while transparently calling out collection bias.

🛠️ Analytics Engineering Design Patterns Used
Pre-Aggregation Defense: Created custom calculated fields in Looker Studio to bypass pre-aggregated average calculation traps (e.g., resolving a false $4,000 average tip calculation to true single-digit averages).

Data Transparency Mapping: Preserved unjoined or anomalous location coordinates as an explicit "Unknown" category to maintain 100% financial reconciliation.

Chronological BI Sorting overrides: Overrode native Looker Studio dimension-sorting constraints on area and line charts using custom chronological index mappings for day_of_week and pickup_hour.