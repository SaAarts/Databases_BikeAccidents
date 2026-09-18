import os
from pathlib import Path
from dotenv import load_dotenv
from sqlalchemy import create_engine, text
from sqlalchemy.engine import URL
from sqlalchemy.exc import OperationalError

# 1. Load environment variables
load_dotenv()

db_user = os.getenv("DB_USER")
db_password = os.getenv("DB_PASSWORD")
db_host = os.getenv("DB_HOST", "localhost")
db_port = int(os.getenv("DB_PORT", 3306))
db_name = os.getenv("DB_NAME", "MockdataGood")

# 2. Connect to MySQL server root to ensure the database exists
server_url = URL.create(
    drivername="mysql+pymysql",
    username=db_user,
    password=db_password,
    host=db_host,
    port=db_port,
)

server_engine = create_engine(server_url)

try:
    with server_engine.connect() as conn:
        conn.execute(text(f"CREATE DATABASE IF NOT EXISTS `{db_name}`;"))
        conn.commit()
    print(f"Connected to MySQL. Database '{db_name}' is verified.")
except OperationalError as err:
    print(f"Connection failed: Check your .env credentials or MySQL server status.\n{err}")
    exit(1)
finally:
    server_engine.dispose()

# 3. Connect specifically to the target database
target_engine = create_engine(server_url.set(database=db_name))

# 4. Load the SQL file safely using script directory
base_dir = Path(__file__).resolve().parent
sql_file_path = base_dir / "goodmockdata_schemadefinition.sql"

if not sql_file_path.exists():
    raise FileNotFoundError(f"Could not find schema file at: {sql_file_path}")

with open(sql_file_path, "r", encoding="utf-8") as file:
    sql_script = file.read()

# 5. Split statements and execute
statements = [
    stmt.strip() for stmt in sql_script.split(";") if stmt.strip()
]

with target_engine.begin() as connection:
    for statement in statements:
        connection.execute(text(statement))

print(f"Schema successfully executed! Tables created in '{db_name}'.")

# 6. Verify tables exist
with target_engine.connect() as conn:
    result = conn.execute(text("SHOW TABLES;"))
    created_tables = [row[0] for row in result.fetchall()]
    print("Tables found in database:", created_tables)

target_engine.dispose()