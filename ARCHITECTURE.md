# System Architecture

## 1. Project Overview

**Rule-Based Analytics: Enhancing E-Commerce Customer Insights using LRFS Segmentation and Visual Analytics**

This project implements an explainable customer segmentation framework using the LRFS model: Length, Recency, Frequency, and Staying Rate. Phase 1 establishes SQL-based feature engineering, rule-based scoring, customer segmentation, and Power BI visualization. Phase 2 extends the system with Apache Kafka-based customer session ingestion and an automated processing pipeline.

## 2. End-to-End Architecture

```text
Customer Session Events
          |
          v
    Kafka Producer
          |
          v
    Kafka Broker
          |
          v
    Kafka Consumer
          |
          v
   MySQL: customer_sessions
          |
          v
    LRFS Recalculation
          |
          v
  Rule-Based Segmentation
          |
          v
   customer_segmented
          |
          v
    customer_export
          |
          v
     Power BI Refresh
          |
          v
 Customer Analytics Dashboard
```

## 3. Phase 1 — Rule-Based Analytics

- Customer behavior data is stored and analyzed using MySQL.
- SQL logic derives Length, Recency, Frequency, and Staying Rate.
- LRFS metrics are converted into rule-based scores.
- Customers are assigned to Gold, Silver, or Bronze segments.
- Power BI visualizes customer segments and behavioral metrics.

## 4. Phase 2 — Streaming and Pipeline Integration

- A Kafka producer publishes customer session events.
- The Kafka broker manages the event stream.
- A consumer processes incoming events and inserts them into MySQL.
- SQL stored procedures recompute LRFS metrics and customer segments.
- The export table is rebuilt for Power BI, which retrieves updated data when refreshed.

## 5. Main Data Components

| Component | Purpose |
|---|---|
| `customer_sessions` | Stores ingested customer session events |
| `customer_lrfs` | Stores engineered LRFS metrics |
| `customer_segmented` | Stores scores and customer segment assignments |
| `customer_segment_before` | Supports before-state comparison |
| `customer_segment_after` | Supports after-state comparison |
| `customer_export` | Combined table for Power BI reporting |

## 6. Technology Stack

- **Apache Kafka:** Event streaming and message transport.
- **Python:** Kafka producer and consumer scripts.
- **MySQL:** Data storage, feature engineering, scoring, and stored procedures using SQL.
- **Power BI:** Interactive dashboards and customer analytics.

## 7. Dashboard Refresh Behavior

The SQL pipeline updates the MySQL analytical tables after new session events are ingested. In the current demonstration workflow, Power BI is refreshed manually to retrieve the updated data and display the resulting customer segmentation.

This is refresh-based dashboard updating, not a claim of fully automatic streaming refresh inside Power BI.

## 8. Explainability

The system uses explicit LRFS scoring rules rather than a black-box machine learning classifier. This allows customer segment assignments to be interpreted through their underlying behavioral metrics and scores.
