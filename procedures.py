import mysql.connector
from .db_connection import get_db_connection

def create_procedures():
    conn = get_db_connection()
    cursor = conn.cursor()
    
    # Procedure to insert a visitor
    cursor.execute("""
        CREATE PROCEDURE insert_visitor(
            IN p_name VARCHAR(100),
            IN p_phone VARCHAR(15),
            IN p_flat_no VARCHAR(10),
            OUT p_visitor_id INT
        )
        BEGIN
            INSERT INTO visitors (name, phone, flat_no)
            VALUES (p_name, p_phone, p_flat_no);
            SET p_visitor_id = LAST_INSERT_ID();
        END
    """)

    # Procedure to insert a delivery
    cursor.execute("""
        CREATE PROCEDURE insert_delivery(
            IN p_delivery_person_name VARCHAR(100),
            IN p_phone VARCHAR(15),
            IN p_flat_no VARCHAR(10),
            OUT p_delivery_id INT
        )
        BEGIN
            INSERT INTO deliveries (delivery_person_name, phone, flat_no)
            VALUES (p_delivery_person_name, p_phone, p_flat_no);
            SET p_delivery_id = LAST_INSERT_ID();
        END
    """)

    # Procedure to insert visitor_log
    cursor.execute("""
        CREATE PROCEDURE insert_visitor_log(
            IN p_visitor_id INT,
            IN p_status VARCHAR(20),
            IN p_reason VARCHAR(200),
            IN p_guard_id INT
        )
        BEGIN
            INSERT INTO visitor_log (visitor_id, status, reason, guard_id)
            VALUES (p_visitor_id, p_status, p_reason, p_guard_id);
        END
    """)

    # Procedure to insert delivery_log
    cursor.execute("""
        CREATE PROCEDURE insert_delivery_log(
            IN p_delivery_id INT,
            IN p_status VARCHAR(20),
            IN p_company VARCHAR(100),
            IN p_guard_id INT
        )
        BEGIN
            INSERT INTO delivery_log (delivery_id, status, company, guard_id)
            VALUES (p_delivery_id, p_status, p_company, p_guard_id);
        END
    """)

    conn.commit()
    cursor.close()
    conn.close()
