############################################
# This file is used by the server.py file to connect to the database. Do not alter this file.
############################################
import sqlite3
import os
# sqlite3 database file path
DATABASE_PATH = "./tasks.db"


def init_db():
    # print("Current working directory:", os.getcwd())
    # print("Database path:", DATABASE_PATH)
    # print("Exists?", os.path.exists(DATABASE_PATH))
    with sqlite3.connect(DATABASE_PATH) as conn:
        cursor = conn.cursor()
        cursor.execute('''
            CREATE TABLE IF NOT EXISTS tasks (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                title TEXT NOT NULL,
                description TEXT,
                completed BOOLEAN NOT NULL DEFAULT 0
            )
        ''')
        conn.commit()


# dependency injection is fun!
def get_db_connection():
    conn = sqlite3.connect(DATABASE_PATH)
    conn.row_factory = sqlite3.Row
    return conn
