-- LightWeight Table for general Export to Power BI

DROP TABLE IF EXISTS customer_export;

-- Create export table with key reporting fields
CREATE TABLE customer_export AS
SELECT
    cs.customer_id,
    seg.Segment,
    seg.Total_score,
    seg.L_score,
    seg.R_score,
    seg.F_score,
    seg.S_score,
    
    lrfs.first_visit,
    lrfs.last_visit,
    lrfs.L_days,
    lrfs.R_days,
    lrfs.F_count,
    lrfs.S_value,
    
    MIN(cs.region) AS region,         -- dominant/first region (can refine with mode logic)
    MIN(cs.device) AS primary_device, -- first recorded device
    MIN(cs.visitor_type) AS visitor_type
    
FROM customer_sessions cs
JOIN customer_lrfs lrfs 
     ON cs.customer_id = lrfs.customer_id
JOIN customer_segmented seg 
     ON cs.customer_id = seg.customer_id
GROUP BY
    cs.customer_id, seg.Segment, seg.Total_score, seg.L_score, seg.R_score, seg.F_score, seg.S_score,
    lrfs.first_visit, lrfs.last_visit, lrfs.L_days, lrfs.R_days, lrfs.F_count, lrfs.S_value;
    
    
    
    select * from 
    customer_export
    ;
