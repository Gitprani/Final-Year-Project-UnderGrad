
SELECT customer_id, L_days, R_days, F_count, S_value,
       L_score, R_score, F_score, S_score,
       Total_score, Segment
FROM customer_lrfs
ORDER BY Total_score DESC
;

select Count(customer_id)
from customer_lrfs
;

SELECT customer_id,
       Total_score, Segment
FROM customer_segmented
;

select customer_id, Total_score
from customer_segmented
where Segment = 'Gold'
;

select *
from customer_export
where Segment = 'Silver' or Segment = 'Bronze' or Segment ='Gold'
;

select * from 
customer_export
;

SELECT L_score, R_score, F_score, S_score, COUNT(*) 
FROM customer_segmented
GROUP BY L_score, R_score, F_score, S_score;

SELECT Total_score, COUNT(*) 
FROM customer_segmented
GROUP BY Total_score
ORDER BY Total_score;

-- -------------------------------------------------------------------------------------------(2nd Phase)
Select *
from customer_export
order by Total_score desc
; 

select * 
from customer_sessions
order by visit_date desc
;


select count(distinct(customer_id))
from customer_sessions
;

SELECT customer_id, Segment FROM customer_segmented 
ORDER BY customer_id DESC LIMIT 5;


-- call this after every addition
call recompute_lrfs();                         


-- automatic refresh
call recompute_lrfs_pipeline();


-- check for all procedures
show procedure status where Db= DATABASE()
;


-- Compare before vs after segmentation
SELECT
    b.customer_id,
    b.before_segment,
    a.after_segment,
    b.before_score,
    a.after_score
FROM customer_segment_before b
JOIN customer_segment_after a
ON b.customer_id = a.customer_id
;
