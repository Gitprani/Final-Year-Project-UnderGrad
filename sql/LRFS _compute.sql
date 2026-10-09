-- SAMPLE LRFS AGGREGATION QUERY (example to compute per-customer LRFS)
-- Adjust "365" or time units as per your project design.

-- Example: Compute Frequency (F), Last and First Visit (for R & L), and Staying Rate (S)
SELECT
  customer_id,
  -- First Visit Date
  MIN(visit_date) AS first_visit,
  -- Last Recent Visit date
  MAX(visit_date) AS last_visit,
  -- Length(L)
  DATEDIFF(MAX(visit_date), MIN(visit_date)) AS length_days, -- L (in days)
  -- Recency(R)
  DATEDIFF(CURDATE(), MAX(visit_date)) AS recency_days,       -- R (in days)
  -- Frequency(F)
  COUNT(*) AS frequency,                                      -- F
  -- Staying Rate(S)
  ROUND(SUM(page_value * (1 - exit_rate)), 2) AS staying_rate -- S
  
FROM customer_sessions
GROUP BY customer_id
ORDER BY staying_rate DESC
LIMIT 20;
