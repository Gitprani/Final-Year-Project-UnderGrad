DELIMITER $$

CREATE PROCEDURE recompute_customer_segments()
BEGIN
    -- Update total score and segment
    UPDATE customer_lrfs
    SET 
        Total_score = L_score + R_score + F_score + S_score,
        Segment = CASE 
            WHEN (L_score + R_score + F_score + S_score) >= 15 THEN 'Gold'
            WHEN (L_score + R_score + F_score + S_score) BETWEEN 10 AND 14 THEN 'Silver'
            ELSE 'Bronze'
        END;

    -- Refresh segmented table
    DROP TABLE IF EXISTS customer_segmented;

    CREATE TABLE customer_segmented AS
    SELECT 
        customer_id,
        L_score, R_score, F_score, S_score,
        Total_score, Segment
    FROM customer_lrfs;
END$$

DELIMITER ;
