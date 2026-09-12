
import csv
import mysql.connector
from pathlib import Path


# ============================================================
# SALES MIS AUTOMATION
# CSV → STAGING → MAIN TABLES
# ============================================================


# ============================================================
# 1. CONFIGURATION
# ============================================================

DB_CONFIG = {
    "host": "localhost",
    "port": 3306,
    "user": "root",
    "password": "Santhosh@kd9528",
    "database": "sales_automation",
    "allow_local_infile": True
}

BASE_DIR = Path(r"C:\Users\Hooooo\Downloads\MIS")


# ============================================================
# 2. CSV → STAGING TABLE MAPPING
# ============================================================

FILES = {
    "Region_Master.csv": "stg_region_master",
    "Daily_Sales.csv": "stg_daily_sales",
    "Monthly_Targets.csv": "stg_monthly_targets",
    "Employee_Master.csv": "stg_employee_master",
    "Customer_Master.csv": "stg_customer_master",
    "Product_Master.csv": "stg_product_master",
    "Orders.csv": "stg_orders",
    "Returns.csv": "stg_returns",
    "Attendance.csv": "stg_attendance",
    "Collections.csv": "stg_collections"
}


# ============================================================
# 3. CONNECT TO MYSQL
# ============================================================

conn = mysql.connector.connect(**DB_CONFIG)
cursor = conn.cursor()

print()
print("==========================================")
print("       SALES MIS AUTOMATION STARTED")
print("==========================================")
print()


# ============================================================
# 4. LOAD ALL CSV FILES INTO STAGING
# ============================================================

for filename, table in FILES.items():

    file_path = BASE_DIR / filename

    if not file_path.exists():
        print(f"❌ File not found: {filename}")
        continue

    # Clear old staging data
    cursor.execute(f"TRUNCATE TABLE {table}")

    # Read CSV
    with open(
        file_path,
        "r",
        encoding="utf-8-sig",
        newline=""
    ) as f:

        reader = csv.reader(f)

        # Skip header
        next(reader, None)

        rows = list(reader)

    # Handle empty CSV
    if not rows:
        print(f"⚠️ {filename:<25} → 0 rows")
        continue

    # Number of columns
    placeholders = ",".join(["%s"] * len(rows[0]))

    sql = f"""
        INSERT INTO {table}
        VALUES ({placeholders})
    """

    cursor.executemany(sql, rows)

    print(
        f"✅ {filename:<25} → {len(rows)} rows"
    )


# ============================================================
# 5. COMMIT STAGING DATA
# ============================================================

conn.commit()


# ============================================================
# 6. LOAD MAIN TABLES
# ============================================================

print()
print("------------------------------------------")
print("Loading main tables...")
print("------------------------------------------")


# ============================================================
# 6.1 REGION MASTER
# ============================================================

cursor.execute("""
INSERT INTO region_master
(
    Region_Code,
    Region_Name,
    Region_Manager
)
SELECT
    Region_Code,
    Region_Name,
    Region_Manager
FROM stg_region_master
WHERE Region_Code IS NOT NULL
  AND Region_Code <> ''

ON DUPLICATE KEY UPDATE
    Region_Name = VALUES(Region_Name),
    Region_Manager = VALUES(Region_Manager)
""")


# ============================================================
# 6.2 DAILY SALES
# ============================================================

cursor.execute("""
INSERT INTO daily_sales
(
    Sale_ID,
    Sale_Date,
    Employee_ID,
    Customer_ID,
    Product_ID,
    Quantity,
    Unit_Price,
    Gross_Sales,
    Region_Code
)
SELECT
    Sale_ID,
    STR_TO_DATE(
        Sale_Date,
        '%m/%d/%Y %H:%i'
    ),
    Employee_ID,
    Customer_ID,
    Product_ID,
    CAST(Quantity AS SIGNED),
    CAST(Unit_Price AS DECIMAL(18,2)),
    CAST(Gross_Sales AS DECIMAL(18,2)),
    Region_Code
FROM stg_daily_sales

WHERE Sale_ID IS NOT NULL
  AND Sale_ID <> ''

ON DUPLICATE KEY UPDATE
    Sale_Date = VALUES(Sale_Date),
    Employee_ID = VALUES(Employee_ID),
    Customer_ID = VALUES(Customer_ID),
    Product_ID = VALUES(Product_ID),
    Quantity = VALUES(Quantity),
    Unit_Price = VALUES(Unit_Price),
    Gross_Sales = VALUES(Gross_Sales),
    Region_Code = VALUES(Region_Code)
""")


# ============================================================
# 6.3 EMPLOYEE TARGET
# ============================================================
# Target file is treated as a current snapshot.
# Clear old target data before loading the new file.
# ============================================================

cursor.execute("""
TRUNCATE TABLE employee_target
""")

cursor.execute("""
INSERT INTO employee_target
(
    Target_Month,
    Employee_ID,
    Region_Code,
    Monthly_Target
)
SELECT
    STR_TO_DATE(
        Target_Month,
        '%Y-%m-%d %H:%i:%s'
    ),
    Employee_ID,
    Region_Code,
    CAST(
        Monthly_Target AS DECIMAL(18,2)
    )
FROM stg_monthly_targets

WHERE Employee_ID IS NOT NULL
  AND Employee_ID <> ''
""")


# ============================================================
# 6.4 ORDERS
# ============================================================

cursor.execute("""
INSERT INTO orders
(
    Order_ID,
    Order_Date,
    Employee_ID,
    Customer_ID,
    Product_ID,
    Quantity,
    Region_Code,
    Order_Value
)
SELECT
    Order_ID,
    STR_TO_DATE(
        Order_Date,
        '%Y-%m-%d %H:%i:%s'
    ),
    Employee_ID,
    Customer_ID,
    Product_ID,
    CAST(Quantity AS SIGNED),
    Region_Code,
    CAST(
        Order_Value AS DECIMAL(18,2)
    )
FROM stg_orders

WHERE Order_ID IS NOT NULL
  AND Order_ID <> ''

ON DUPLICATE KEY UPDATE
    Order_Date = VALUES(Order_Date),
    Employee_ID = VALUES(Employee_ID),
    Customer_ID = VALUES(Customer_ID),
    Product_ID = VALUES(Product_ID),
    Quantity = VALUES(Quantity),
    Region_Code = VALUES(Region_Code),
    Order_Value = VALUES(Order_Value)
""")


# ============================================================
# 6.5 RETURNS
# ============================================================

cursor.execute("""
INSERT INTO returns
(
    Return_ID,
    Return_Date,
    Sale_ID,
    Product_ID,
    Return_Amount,
    Return_Reason
)
SELECT
    Return_ID,
    STR_TO_DATE(
        Return_Date,
        '%Y-%m-%d %H:%i:%s'
    ),
    Sale_ID,
    Product_ID,
    CAST(
        Return_Amount AS DECIMAL(18,2)
    ),
    Return_Reason
FROM stg_returns

WHERE Return_ID IS NOT NULL
  AND Return_ID <> ''

ON DUPLICATE KEY UPDATE
    Return_Date = VALUES(Return_Date),
    Sale_ID = VALUES(Sale_ID),
    Product_ID = VALUES(Product_ID),
    Return_Amount = VALUES(Return_Amount),
    Return_Reason = VALUES(Return_Reason)
""")


# ============================================================
# 6.6 ATTENDANCE
# ============================================================
# Attendance file is treated as a current snapshot.
# Clear old attendance data before loading the new file.
# ============================================================

cursor.execute("""
TRUNCATE TABLE attendance
""")

cursor.execute("""
INSERT INTO attendance
(
    Attendance_Date,
    Employee_ID,
    Attendance_Status
)
SELECT
    STR_TO_DATE(
        Attendance_Date,
        '%Y-%m-%d %H:%i:%s'
    ),
    Employee_ID,
    Attendance_Status
FROM stg_attendance

WHERE Employee_ID IS NOT NULL
  AND Employee_ID <> ''
""")


# ============================================================
# 6.7 COLLECTIONS
# ============================================================

cursor.execute("""
INSERT INTO collections
(
    Collection_ID,
    Collection_Date,
    Sale_ID,
    Customer_ID,
    Collection_Amount,
    Payment_Mode
)
SELECT
    Collection_ID,
    STR_TO_DATE(
        Collection_Date,
        '%Y-%m-%d %H:%i:%s'
    ),
    Sale_ID,
    Customer_ID,
    CAST(
        Collection_Amount AS DECIMAL(18,2)
    ),
    Payment_Mode
FROM stg_collections

WHERE Collection_ID IS NOT NULL
  AND Collection_ID <> ''

ON DUPLICATE KEY UPDATE
    Collection_Date = VALUES(Collection_Date),
    Sale_ID = VALUES(Sale_ID),
    Customer_ID = VALUES(Customer_ID),
    Collection_Amount = VALUES(Collection_Amount),
    Payment_Mode = VALUES(Payment_Mode)
""")


# ============================================================
# 7. COMMIT MAIN TABLES
# ============================================================

conn.commit()


# ============================================================
# 8. FINAL RECORD COUNTS
# ============================================================

print()
print("------------------------------------------")
print("Final record counts")
print("------------------------------------------")

tables = [
    "region_master",
    "daily_sales",
    "employee_target",
    "orders",
    "returns",
    "attendance",
    "collections",
    "exception_report"
]

for table in tables:

    cursor.execute(
        f"SELECT COUNT(*) FROM {table}"
    )

    count = cursor.fetchone()[0]

    print(
        f"{table:<20} : {count}"
    )


# ============================================================
# 9. CLOSE CONNECTION
# ============================================================

cursor.close()
conn.close()


# ============================================================
# 10. COMPLETED
# ============================================================

print()
print("==========================================")
print("   ✅ SALES MIS AUTOMATION COMPLETED")
print("==========================================")
print()
