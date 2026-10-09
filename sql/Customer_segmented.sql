drop table if exists customer_segmented;
-- Module 3
create table customer_segmented as
 SELECT customer_id,
       L_score, R_score, F_score, S_score,
       Total_score, Segment
FROM customer_lrfs
order by Total_score
;

-- Check 
SELECT *
FROM customer_segmented
order by Total_score desc
;
