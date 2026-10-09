CREATE TABLE customer_segment_before AS
SELECT
    customer_id,
    Segment AS before_segment,
    Total_score AS before_score
FROM customer_segmented;

select * from 
customer_segment_before
where customer_id = 999
;
