ALTER TABLE customer_lrfs
ADD COLUMN L_score INT,
ADD COLUMN R_score INT,
ADD COLUMN F_score INT,
ADD COLUMN S_score INT,
ADD COLUMN Total_score INT,
ADD COLUMN Segment VARCHAR(10);

-- Update scoring
UPDATE customer_lrfs
SET 
  L_score = CASE 
              WHEN L_days > 365 THEN 5
              WHEN L_days BETWEEN 180 AND 365 THEN 4
              WHEN L_days BETWEEN 90 AND 179 THEN 3
              WHEN L_days BETWEEN 30 AND 89 THEN 2
              ELSE 1 END,

  R_score = CASE 
              WHEN R_days <= 5 THEN 5
              WHEN R_days BETWEEN 6 AND 15 THEN 4
              WHEN R_days BETWEEN 16 AND 30 THEN 3
              WHEN R_days BETWEEN 31 AND 60 THEN 2
              ELSE 1 END,

  F_score = CASE 
              WHEN F_count > 15 THEN 5
              WHEN F_count BETWEEN 10 AND 15 THEN 4
              WHEN F_count BETWEEN 6 AND 9 THEN 3
              WHEN F_count BETWEEN 2 AND 5 THEN 2
              ELSE 1 END,

  S_score = CASE 
              WHEN S_value > 5000 THEN 5
              WHEN S_value BETWEEN 3000 AND 5000 THEN 4
              WHEN S_value BETWEEN 1000 AND 2999 THEN 3
              WHEN S_value BETWEEN 500 AND 999 THEN 2
              ELSE 1 END;



-- check
SELECT customer_id, L_days, R_days, F_count, S_value,
L_score, R_score, F_score, S_score
FROM customer_lrfs
ORDER BY Total_score DESC
;

-- No of Customers
select Count(customer_id)
from customer_lrfs
;
