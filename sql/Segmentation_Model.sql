-- Compute total and assign segment
UPDATE customer_lrfs
SET 
  -- Total Score is the sum of all Scores
  Total_score = L_score + R_score + F_score + S_score,
  
  Segment = CASE 
                   -- 15 and above - Gold
              WHEN (L_score + R_score + F_score + S_score) >= 15 THEN 'Gold'
                   -- 1- to 14 - Silver 
              WHEN (L_score + R_score + F_score + S_score) BETWEEN 10 AND 14 THEN 'Silver'
              -- Below 10 - Bronze
              ELSE 'Bronze' END
;

-- Final check
SELECT customer_id,
       Total_score, Segment
FROM customer_lrfs
ORDER BY Total_score DESC
;

select Count(customer_id)
from customer_lrfs
;
              
              
