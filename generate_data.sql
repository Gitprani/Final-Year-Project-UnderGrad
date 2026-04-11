DELIMITER $$
CREATE PROCEDURE generate_synthetic_data(IN p_customers INT, IN p_sessions INT)
BEGIN
  DECLARE i INT DEFAULT 1;
  DECLARE cid INT;
  DECLARE v_date DATE;
  DECLARE pv DECIMAL(8,2);
  DECLARE er DECIMAL(4,3);
  DECLARE dev VARCHAR(20);
  DECLARE reg VARCHAR(50);
  DECLARE vtype VARCHAR(20);

  WHILE i <= p_sessions DO
    -- Random customer id between 1 and p_customers
    SET cid = FLOOR(1 + RAND()*p_customers);

    -- Random visit date within last 365 days
    SET v_date = DATE_SUB(CURDATE(), INTERVAL FLOOR(RAND()*365) DAY);

    -- Page value (session monetary proxy) - 0.00 to 200.00
    SET pv = ROUND(RAND()*200, 2);

    -- Exit rate between 0.05 and 0.95
    SET er = ROUND(0.05 + RAND()*0.9, 3);

    -- Random device
    SET dev = ELT(FLOOR(RAND()*3)+1, 'Desktop', 'Mobile', 'Tablet');

    -- Random region
    SET reg = ELT(FLOOR(RAND()*6)+1, 'North', 'South', 'East', 'West', 'Central', 'International');

    -- Random visitor type (approx 20% new)
    SET vtype = IF(RAND() < 0.2, 'New', 'Returning');

    -- Insert synthetic row
    INSERT INTO customer_sessions(session_id, customer_id, visit_date, page_value, exit_rate, device, region, visitor_type)
    VALUES (CONCAT('S', LPAD(i,7,'0'), '-C', cid), cid, v_date, pv, er, dev, reg, vtype);

    SET i = i + 1;
  END WHILE;
END$$
DELIMITER ;

-- Example: generate data for 5000 customers with 20000 sessions
CALL generate_synthetic_data(5000, 20000);
