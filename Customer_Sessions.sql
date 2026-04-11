-- Create DB and table for LRFS synthetic data
CREATE DATABASE IF NOT EXISTS lrfs_project;
USE lrfs_project;

-- Drop if exists (safe to re-run)
DROP TABLE IF EXISTS customer_sessions;

CREATE TABLE customer_sessions (
  session_id VARCHAR(32) NOT NULL PRIMARY KEY,
  customer_id INT NOT NULL,
  visit_date DATE NOT NULL,
  page_value DECIMAL(8,2) DEFAULT 0.00,
  exit_rate DECIMAL(4,3) DEFAULT 0.000,
  device VARCHAR(20),
  region VARCHAR(50),
  visitor_type VARCHAR(20)
);


ALTER table customer_sessions
drop primary key;

alter table customer_sessions
add id int auto_increment primary key
;

ALTER TABLE customer_sessions
MODIFY session_id VARCHAR(255);