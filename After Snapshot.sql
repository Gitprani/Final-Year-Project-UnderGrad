CREATE TABLE customer_segment_after AS
SELECT
    customer_id,
    Segment AS after_segment,
    Total_score AS after_score
FROM customer_segmented;

select * from 
customer_segment_after
where customer_id = 999
;