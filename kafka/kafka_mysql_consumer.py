from kafka import KafkaConsumer
import json
import mysql.connector

# MySQL connection
db = mysql.connector.connect(
    host="localhost",
    user="root",
    password="mysqlprani@4",
    database="lrfs_project"
)

cursor = db.cursor()

consumer = KafkaConsumer(
    'customer_sessions',
    bootstrap_servers='localhost:9092',
    value_deserializer=lambda x: json.loads(x.decode('utf-8'))
)

print("MYSQL LIVE INGESTION STARTED")

for msg in consumer:
    d = msg.value

    sql = """INSERT INTO customer_sessions
             (session_id, customer_id, visit_date, page_value, exit_rate, device, region, visitor_type)
             VALUES (%s,%s,%s,%s,%s,%s,%s,%s)"""

    val = (
        d['session_id'],
        d['customer_id'],
        d['visit_date'],
        d['page_value'],
        d['exit_rate'],
        d['device'],
        d['region'],
        d['visitor_type']
    )

    cursor.execute(sql, val)
    db.commit()
    print("Inserted:", d['session_id'])