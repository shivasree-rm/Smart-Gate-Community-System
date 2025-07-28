import mysql.connector
from mysql.connector import Error

def get_db_connection():
    try:
        connection = mysql.connector.connect(
            host="localhost",
            user="your_username",
            password="your_password",
            database="smart_gate_community"
        )
        return connection
    except Error as e:
        print(f"Error connecting to MySQL: {e}")
        return None
