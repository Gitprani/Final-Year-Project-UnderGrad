DELIMITER $$

CREATE PROCEDURE recompute_lrfs()
BEGIN
    DROP TABLE IF EXISTS customer_lrfs;
    DROP TABLE IF EXISTS customer_segmented;

    -- Rebuild LRFS		
    CREATE TABLE customer_lrfs AS
    SELECT
        customer_id,
        MIN(visit_date) AS first_visit,
        MAX(visit_date) AS last_visit,
        DATEDIFF(MAX(visit_date), MIN(visit_date)) AS L_days,
        DATEDIFF(CURDATE(), MAX(visit_date)) AS R_days,
        COUNT(*) AS F_count,
        ROUND(SUM(page_value * (1 - exit_rate)),2) AS S_value
    FROM customer_sessions
    GROUP BY customer_id;

    -- Scoring
    ALTER TABLE customer_lrfs
    ADD COLUMN L_score INT,
    ADD COLUMN R_score INT,
    ADD COLUMN F_score INT,
    ADD COLUMN S_score INT,
    ADD COLUMN Total_score INT,
    ADD COLUMN Segment VARCHAR(10);

    UPDATE customer_lrfs SET
      L_score = CASE WHEN L_days > 365 THEN 5 WHEN L_days BETWEEN 180 AND 365 THEN 4 WHEN L_days BETWEEN 90 AND 179 THEN 3 WHEN L_days BETWEEN 30 AND 89 THEN 2 ELSE 1 END,
      R_score = CASE WHEN R_days <= 5 THEN 5 WHEN R_days BETWEEN 6 AND 15 THEN 4 WHEN R_days BETWEEN 16 AND 30 THEN 3 WHEN R_days BETWEEN 31 AND 60 THEN 2 ELSE 1 END,
      F_score = CASE WHEN F_count > 15 THEN 5 WHEN F_count BETWEEN 10 AND 15 THEN 4 WHEN F_count BETWEEN 6 AND 9 THEN 3 WHEN F_count BETWEEN 2 AND 5 THEN 2 ELSE 1 END,
      S_score = CASE WHEN S_value > 5000 THEN 5 WHEN S_value BETWEEN 3000 AND 5000 THEN 4 WHEN S_value BETWEEN 1000 AND 2999 THEN 3 WHEN S_value BETWEEN 500 AND 999 THEN 2 ELSE 1 END;

    UPDATE customer_lrfs
    SET Total_score = L_score + R_score + F_score + S_score,
        Segment = CASE
          WHEN Total_score >= 15 THEN 'Gold'
          WHEN Total_score BETWEEN 10 AND 14 THEN 'Silver'
          ELSE 'Bronze'
        END;

    CREATE TABLE customer_segmented AS
    SELECT customer_id, L_score, R_score, F_score, S_score, Total_score, Segment
    FROM customer_lrfs;
END$$

DELIMITER ;
