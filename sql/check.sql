-- Create indexes for faster queries
CREATE INDEX idx_customer ON customer_sessions(customer_id);
CREATE INDEX idx_visit_date ON customer_sessions(visit_date);

-- Quick checks
SELECT COUNT(*) AS total_sessions FROM customer_sessions;
SELECT COUNT(DISTINCT customer_id) AS unique_customers FROM customer_sessions LIMIT 1;
