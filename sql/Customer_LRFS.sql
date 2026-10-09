-- Example: Basic scoring approach (1-5) using NTILE for quantiles (alternative to fixed bins)
-- This creates a temp table with L,R,F,S and quantile buckets (requires MySQL 8.0 for window functions).
DROP TABLE IF EXISTS customer_lrfs;
CREATE TABLE customer_lrfs AS
SELECT
  customer_id,
  MIN(visit_date) AS first_visit,
  MAX(visit_date) AS last_visit,
  DATEDIFF(MAX(visit_date), MIN(visit_date)) AS L_days,
  DATEDIFF(CURDATE(), MAX(visit_date)) AS R_days,
  COUNT(*) AS F_count,
  ROUND(SUM(page_value * (1 - exit_rate)), 2) AS S_value
FROM customer_sessions
GROUP BY customer_id;

select * from customer_lrfs
;


ALTER TABLE customer_lrfs DROP COLUMN L_rank , DROP COLUMN R_rank, DROP COLUMN F_rank, DROP COLUMN S_rank
;

select * , rank() over(order by L_days desc) L_rank, rank() over(order by R_days desc) R_rank, rank() over(order by F_count desc) F_rank, rank() over(order by S_value desc) S_rank
from customer_lrfs
;

