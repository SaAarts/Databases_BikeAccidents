from sqlalchemy import create_engine, text
from sqlalchemy.engine import URL

# 1. Connection configuration
connection_url = URL.create(
    drivername="mysql+pymysql",
    username="root",  # replace with your username
    password="password",  # replace with your password
    host="localhost",  # replace with your host
    port=3306,
    database="your_database_name",  # replace with your target database name
)

engine = create_engine(connection_url)

# 2. Read the SQL file from the same directory
sql_file_path = "schema.sql"  # replace with your actual .sql filename

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