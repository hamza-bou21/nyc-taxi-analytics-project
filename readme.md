# NYC Taxi Analytics: End-to-End Analytics Engineering Pipeline

[![Made with BigQuery](https://img.shields.io/badge/BigQuery-4285F4?style=for-the-badge&logo=googlecloud&logoColor=white)](https://cloud.google.com/bigquery)
[![Looker Studio](https://img.shields.io/badge/Looker_Studio-4285F4?style=for-the-badge&logo=looker&logoColor=white)](https://lookerstudio.google.com/)
[![SQL](https://img.shields.io/badge/SQL-4479A1?style=for-the-badge&logo=postgresql&logoColor=white)](https://en.wikipedia.org/wiki/SQL)

## 📋 Table of Contents

- [Executive Summary](#executive-summary)
- [Live Dashboard](#live-dashboard)
- [Technologies Used](#technologies-used)
- [Data Architecture](#data-architecture)
- [Project Structure](#project-structure)
- [Key Business Insights](#key-business-insights)
- [SQL Implementation](#sql-implementation)
- [Analytics Engineering Patterns](#analytics-engineering-patterns)
- [Setup & Deployment](#setup--deployment)

## 🚀 Executive Summary

This project transforms **91 million rows** of raw New York City Yellow Taxi trip data (2020–2022) into a high-performance, cost-optimized, multi-page business intelligence suite.

By migrating from isolated, single-use data marts to a unified, multi-dimensional **Master Data Mart** in Google BigQuery, the pipeline achieves **100% global dashboard cross-filtering** while maintaining **near-zero execution costs**. The resulting interactive Looker Studio application delivers critical macroeconomic, financial, and operational insights for fleet management optimization.

### Key Metrics

| Metric | Before | After |
|--------|--------|-------|
| Table Size | 91M rows | 120K rows |
| Reduction | - | **99.8%** |
| Cross-Filtering | ❌ Broken | ✅ Fully functional |
| Query Cost | Variable | **$0** (pre-aggregated) |

## 🔗 Live Dashboard

**[→ View Interactive Looker Studio Dashboard](https://datastudio.google.com/reporting/ef6c2836-3e45-4aef-86d4-94bae1fddd44)**

**Dashboard:** NYC Taxi Analytics Live Dashboard

### Dashboard Components

- Total trips over time (time-series analysis)
- Borough market share (donut chart)
- Yearly airport demand recovery (JFK vs LGA)
- Consolidated trip metrics
- Cross-filter enabled across all charts

## 🛠️ Technologies Used

| Category | Technology |
|----------|------------|
| **Data Warehouse** | Google BigQuery |
| **Query Language** | SQL (DDL/DML) |
| **BI & Visualization** | Looker Studio (Google Data Studio) |
| **Analytics Engineering** | Custom ETL, pre-aggregation strategies |
| **Data Source** | NYC TLC Yellow Taxi trip data (2020-2022) |
| **Geospatial Data** | NYC Taxi Zone geography (BigQuery public dataset) |

## 🏗️ Data Architecture

### The Problem

Initial dashboard relied on isolated summary tables. While cost-efficient, this created a **Data Isolation Bottleneck** — charts couldn't communicate, breaking cross-filtering in the BI layer.

### The Solution

The pipeline was re-engineered to aggregate raw data into an optimized, multi-dimensional data matrix.

### Pipeline Flow
┌─────────────────┐ ┌─────────────────┐ ┌─────────────────┐ ┌─────────────────┐
│ Raw BigQuery │────▶│ Cleaned Views │────▶│ Master Summary │────▶│ Looker Studio │
│ Tables │ │ (ETL/Joins) │ │ Table │ │ Dashboard │
├─────────────────┤ ├─────────────────┤ ├─────────────────┤ ├─────────────────┤
│ 91 Million │ │ Data Cleaning │ │ 120,000 Rows │ │ 2-Page App │
│ Rows │ │ Zone Joining │ │ 99.8% smaller │ │ Fully Sync'd │
└─────────────────┘ └─────────────────┘ └─────────────────┘ └─────────────────┘


### Performance Impact

| Aspect | Before | After |
|--------|--------|-------|
| Cross-filtering | ❌ Broken | ✅ 100% functional |
| Query performance | Slow (full scan) | Fast (pre-aggregated) |
| User experience | Isolated charts | Enterprise-grade |

## 📁 Project Structure
```text
NYC-TAXI-ANALYTICS-PROJECT/
├── queries/
│   ├── 00_create_mega_view.sql
│   ├── question_1_monthly_demand.sql
│   ├── question_2_peak_patterns.sql
│   ├── question_3_financial_trends.sql
│   ├── question_4_airport_recovery.sql
│   ├── question_5_passenger_dynamics.sql
│   ├── question_6_trip_efficiency.sql
│   ├── question_7_revenue_optimization.sql
│   └── question_8_payment_trends.sql
└── readme.md
```

### Query Descriptions

| File | Analysis Focus | Business Value |
|------|---------------|----------------|
| `00_create_mega_view.sql` | Base view creation | Foundation for all downstream queries |
| `question_1_monthly_demand.sql` | Volume trends | Demand forecasting |
| `question_2_peak_patterns.sql` | Temporal patterns | Shift optimization |
| `question_3_financial_trends.sql` | Revenue analysis | Profitability tracking |
| `question_4_airport_recovery.sql` | Airport demand | Tourism recovery insights |
| `question_5_passenger_dynamics.sql` | Group vs solo rides | Pricing strategy |
| `question_6_trip_efficiency.sql` | Duration/distance | Operational efficiency |
| `question_7_revenue_optimization.sql` | High-value trips | Revenue maximization |
| `question_8_payment_trends.sql` | Payment methods | Cashless transition tracking |

## 📈 Key Business Insights

### 1. Macro Demand & "The Manhattan Monopoly"

**The Insight:** Manhattan completely dominates the Yellow Taxi market share, capturing over 85% of total city-wide volume.

**BI Solution:** Donut Chart deployed to intentionally frame Manhattan's footprint as global market share dominance while preserving visibility for outer-borough categories.

**Business Impact:** Fleet allocation can prioritize Manhattan during peak hours.

---

### 2. The Cashless Acceleration

**The Insight:** The 2020 pandemic triggered a massive, permanent behavioral shift. Cash transactions reached historic lows during lockdowns and never recovered to pre-pandemic baselines.

**BI Solution:** 100% Stacked Column Chart isolates proportional shifts from raw volume drops.

**Business Impact:** Investment in card readers and digital payment infrastructure is justified.

---

### 3. Tipping Behavior & Data Collection Anomalies

**The Insight:** Credit card tips are meticulously logged, but cash tips are consistently omitted from the raw ledger.

**BI Solution:** Hourly Revenue Surge Matrix using custom calculated fields to model true financial yield while calling out collection bias.

**Business Impact:** Transparent reporting prevents misleading average tip calculations.

## 🔧 SQL Implementation

### Master ETL Script (BigQuery SQL)

This is the core aggregation query that creates the optimized master summary table:

```sql
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
### Key SQL Design Patterns

| Pattern | Implementation | Purpose |
|---------|----------------|---------|
| **Date truncation** | `DATE_TRUNC(pickup_datetime, MONTH)` | Groups timestamps by month for time-series analysis |
| **NULL handling** | `IFNULL(borough, 'Unknown')` | Preserves data completeness, prevents missing value gaps |
| **CASE mapping** | `CASE WHEN dropoff_location_id = '132' THEN 'JFK Airport'` | Converts codes to human-readable labels |
| **Left join** | `LEFT JOIN zone_lookup ON trips.pickup_location_id = zone_lookup.zone_id` | Enriches trip data while preserving all records |


## Section 10: Analytics Engineering Patterns

```markdown
## 🛠️ Analytics Engineering Design Patterns

### 1. Pre-Aggregation Defense

**Problem:** Raw average calculations can produce misleading results (e.g., false $4,000 average tip).

**Solution:** Created custom calculated fields in Looker Studio to bypass pre-aggregated average calculation traps.

```javascript
// Looker Studio calculated field example
SUM(total_revenue) / SUM(total_trips)  // True average
-- vs
AVG(total_revenue)  // Potentially misleading

### 2. Data Transparency Mapping

| Aspect | Description |
|--------|-------------|
| **Problem** | Unjoined or anomalous location coordinates break financial reconciliation |
| **Solution** | Preserve unmatched records as explicit 'Unknown' category |
| **Implementation** | `IFNULL(zone_lookup.borough, 'Unknown') AS pickup_borough` |
| **Impact** | 100% data retention with transparent flagging of unmapped records |

### 3. Chronological BI Sorting Overrides

| Aspect | Description |
|--------|-------------|
| **Problem** | Looker Studio's default alphabetical sorting breaks time-series (e.g., Friday comes before Monday) |
| **Solution** | Custom chronological index mappings using WEEKDAY() or CASE statements |
| **Implementation** | `CASE EXTRACT(DAYOFWEEK FROM pickup_datetime) WHEN 1 THEN 'Monday' WHEN 2 THEN 'Tuesday' END` |
| **Impact** | Proper chronological order in area charts, line charts, and bar charts |


## Section 11: Setup & Deployment

```markdown
## 🚀 Setup & Deployment

### Prerequisites

- Google Cloud Platform account
- BigQuery API enabled
- Access to NYC TLC public datasets

### BigQuery Configuration

```bash
# Required datasets
Project ID: your-gcp-project
Dataset: nyc_taxi_analytics
Source tables:
  - cleaned_trips_2020_2022
  - bigquery-public-data.new_york_taxi_trips.taxi_zone_geom

  ## 🚀 Deployment Steps

### Prerequisites

| Requirement | Details |
|-------------|---------|
| **Google Cloud Account** | Active GCP account with billing enabled |
| **BigQuery API** | Enabled in your GCP project |
| **Permissions** | BigQuery User + Data Viewer roles |
| **Looker Studio Access** | Free with Google account |

### BigQuery Configuration

| Setting | Value |
|---------|-------|
| **Project ID** | `your-gcp-project-id` |
| **Dataset** | `nyc_taxi_analytics` |
| **Source Tables** | `cleaned_trips_2020_2022`, `taxi_zone_geom` |

### Step 1: Clone the Repository

```bash
git clone https://github.com/hamza-bou21/nyc-taxi-analytics-project.git
cd nyc-taxi-analytics-project

### Step 2: Create the Base View
bq query --use_legacy_sql=false < queries/00_create_mega_view.sql
### Step 3: Run Analysis Queries
# Run all question queries in sequence
for i in {1..8}; do
  bq query --use_legacy_sql=false < queries/question_${i}_*.sql
done

### Step 4: Create Master Summary Table
-- Run the master aggregation query
bq query --use_legacy_sql=false < queries/00_create_mega_view.sql
### Step 6: Access Live Dashboard
after connecting the data to looker studio:
[→ NYC Taxi Analytics Live Dashboard](https://datastudio.google.com/reporting/ef6c2836-3e45-4aef-86d4-94bae1fddd44)

## Cost Optimization
- Master summary table reduces query costs to $0 for dashboard refreshes

- Pre-aggregation eliminates full table scans

- Estimated monthly savings: $50-200 compared to querying raw data


## Section 12: Author & License

```markdown
## 👨‍💻 Author

**Hamza Bou** | [GitHub](https://github.com/hamza-bou21)

## 📄 License

This project is open source and available under the MIT License.

## 🙏 Acknowledgments

- NYC Taxi & Limousine Commission for open data
- Google Cloud Platform for BigQuery public datasets
- Looker Studio for free BI visualization

---

**⭐ Star this repo if you found it useful!**