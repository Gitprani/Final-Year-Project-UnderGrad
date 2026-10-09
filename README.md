# Rule-Based Analytics: Enhancing E-Commerce Customer Insights

An end-to-end customer analytics system combining LRFS-based rule-driven segmentation, Apache Kafka event ingestion, MySQL analytical processing, and Power BI visualization.

## Overview

Customer behavior changes continuously as users browse products, revisit pages, and interact with e-commerce websites. Analyzing this behavior helps businesses understand customer engagement and identify valuable customer segments.

This project implements a rule-based LRFS (Length, Recency, Frequency, and Staying Rate) customer segmentation model. The first phase established SQL-based feature engineering, scoring, segmentation, and Power BI dashboards. The second phase extends the system with Apache Kafka to ingest customer session events and trigger updated analytical processing.

The solution emphasizes explainability through SQL rules rather than relying on machine-learning clustering models.

## Project Objectives

- Analyze customer engagement using Length, Recency, Frequency, and Staying Rate.
- Classify customers into Gold, Silver, and Bronze segments using rule-based scoring.
- Ingest customer session events through Apache Kafka.
- Automate LRFS recomputation and customer segmentation using MySQL stored procedures.
- Visualize updated customer analytics through Power BI dashboards.

## Architecture

```text
Customer Session Events
          |
          v
   Kafka Producer
          |
          v
   Kafka Topic / Broker
          |
          v
  Consumer / Data Loader
          |
          v
  MySQL: customer_sessions
          |
          v
  LRFS Computation (SQL)
          |
          v
  Rule-Based Scoring
          |
          v
  Customer Segmentation
          |
          v
  customer_export
          |
          v
  Power BI Dashboards
```

ZooKeeper is used in the local Kafka configuration for the ZooKeeper-based Kafka deployment.

## Technology Stack

| Component | Technology |
|---|---|
| Event streaming | Apache Kafka |
| Kafka coordination | Apache ZooKeeper |
| Database | MySQL |
| Data transformation | SQL and stored procedures |
| Analytics model | Rule-based LRFS segmentation |
| Visualization | Microsoft Power BI |
| Data exchange | JSON customer session events |

## LRFS Methodology

The system derives four behavioral metrics for each customer.

- **Length (L):** Duration of the customer relationship, calculated from the first and latest recorded visits.
- **Recency (R):** Number of days since the latest recorded visit.
- **Frequency (F):** Number of recorded customer sessions.
- **Staying Rate (S):** Behavioral engagement measure calculated from page value and exit rate.

The current SQL implementation uses the following expressions:

- `L_days = DATEDIFF(MAX(visit_date), MIN(visit_date))`
- `R_days = DATEDIFF(CURDATE(), MAX(visit_date))`
- `F_count = COUNT(*)`
- `S_value = SUM(page_value * (1 - exit_rate))`

Each metric is assigned a rule-based score from 1 to 5. The individual scores are combined into a total score and used to assign a customer segment.

The implemented segmentation rules are:

- **Gold:** Total score greater than or equal to 15.
- **Silver:** Total score between 10 and 14.
- **Bronze:** Total score below 10.

## Project Phases

### Phase 1 — Rule-Based Customer Analytics

- Created the customer session dataset and MySQL analytical tables.
- Engineered LRFS features using SQL.
- Implemented rule-based scoring and customer segmentation.
- Developed Power BI dashboards for customer overview, segmentation insights, and business analysis.

### Phase 2 — Kafka-Based Data Ingestion

- Configured Apache Kafka and ZooKeeper for local event streaming.
- Published customer session events to the `customer_sessions` Kafka topic.
- Consumed events and inserted the ingested records into MySQL.
- Implemented a pipeline procedure to recompute LRFS metrics, refresh customer segments, and regenerate the `customer_export` table.
- Connected Power BI to MySQL so refreshed analytical data could be visualized after a Power BI refresh.

## Data and SQL Components

The repository contains SQL scripts, CSV datasets, and Power BI reports associated with the project.

Key analytical tables include:

- `customer_sessions` — customer session-level events.
- `customer_lrfs` — computed LRFS metrics and scores.
- `customer_segmented` — customer segment assignments.
- `customer_export` — consolidated analytical output for Power BI.
- `customer_segment_before` and `customer_segment_after` — tables used for before-and-after segment comparisons.

The SQL scripts cover data generation, LRFS computation, scoring, segmentation, snapshot creation, and export generation.

## Running the Project

The complete setup requires a compatible Java installation, Apache Kafka, ZooKeeper for the configured Kafka mode, MySQL, the ingestion scripts, and Power BI Desktop.

1. Configure and start ZooKeeper and the Kafka broker.
2. Create the required MySQL database and analytical tables by executing the SQL scripts in the correct dependency order.
3. Start the event producer and consumer/loader.
4. Publish customer session events and verify that they are inserted into MySQL.
5. Execute the `recompute_lrfs_pipeline()` stored procedure.
6. Verify the updated LRFS metrics, customer segments, and `customer_export` records.
7. Refresh the Power BI report to display the latest imported data.

Refer to the SQL scripts and the actual Kafka ingestion implementation for the exact configuration and execution commands.

## Results

The project demonstrates the integration of event streaming, SQL-based analytics, rule-driven customer classification, and business intelligence dashboards. It supports the analysis of customer behavior and the visualization of updated segments after new session events are ingested and processed.

## Future Enhancements

- Automated pipeline orchestration after event ingestion.
- More robust error handling and duplicate-event prevention.
- Monitoring of Kafka ingestion and SQL processing.
- Automated dashboard refresh scheduling.
- Deployment in a cloud-based analytics environment.

## Author

Pranesh Krishnan E

Project: Rule-Based Analytics — Enhancing E-Commerce Customer Insights
