Drop Procedure if exists
recompute_lrfs_pipeline
;

DELIMITER $$

CREATE PROCEDURE recompute_lrfs_pipeline()
BEGIN
    -- 1. Recompute LRFS metrics
    CALL recompute_lrfs();

    -- 2. Recompute customer segments
    CALL recompute_customer_segments();

    -- 3. Refresh Power BI export table
    DROP TABLE IF EXISTS customer_export;

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

        MIN(cs.region) AS region,
        MIN(cs.device) AS primary_device,
        MIN(cs.visitor_type) AS visitor_type

    FROM customer_sessions cs
    JOIN customer_lrfs lrfs 
        ON cs.customer_id = lrfs.customer_id
    JOIN customer_segmented seg 
        ON cs.customer_id = seg.customer_id
    GROUP BY
        cs.customer_id, seg.Segment, seg.Total_score,
        seg.L_score, seg.R_score, seg.F_score, seg.S_score,
        lrfs.first_visit, lrfs.last_visit,
        lrfs.L_days, lrfs.R_days, lrfs.F_count, lrfs.S_value;
END$$

DELIMITER ;

