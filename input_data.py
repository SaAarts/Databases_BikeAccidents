from sqlalchemy import create_engine, text
from sqlalchemy.engine import URL
import os
from dotenv import load_dotenv
from sqlalchemy import create_engine
from sqlalchemy.engine import URL

# Load environment variables from .env
load_dotenv()

# Build the connection URL securely
connection_url = URL.create(
    drivername="mysql+pymysql",
    username=os.getenv("DB_USER"),
    password=os.getenv("DB_PASSWORD"),
    host=os.getenv("DB_HOST", "localhost"),
    port=int(os.getenv("DB_PORT", 3306)),
    database=os.getenv("DB_NAME"),
)

engine = create_engine(connection_url)

# 2. Read the SQL file from the same directory
sql_file_path = "goodmockdata_schemadefinition.sql"  # replace with your actual .sql filename

with open(sql_file_path, "r", encoding="utf-8") as file:
    sql_script = file.read()

# 3. Execute the schema statements
# Splitting by ';' executes each DDL statement individually to avoid multi-statement driver errors
statements = [
    stmt.strip() for stmt in sql_script.split(";") if stmt.strip()
]

with engine.begin() as connection:
    for statement in statements:
        connection.execute(text(statement))

print("Schema successfully executed and tables created!")

# 4. Clean up connection pool
engine.dispose()