-- ============================================================
-- SALES MIS AUTOMATION PROJECT - COMPLETE MYSQL SETUP
-- From Database Creation -> Staging Tables -> CSV Loading
-- Database: Sales_Automation
-- CSV Folder: C:\Users\Hooooo\Downloads\MIS
-- ============================================================

-- ============================================================
-- 1. CREATE DATABASE
-- ============================================================

CREATE DATABASE IF NOT EXISTS Sales_Automation;
USE Sales_Automation;


-- ============================================================
-- 2. MAIN TABLES
-- ============================================================

-- 2.1 Region Master
CREATE TABLE IF NOT EXISTS region_master (
    Region_Code VARCHAR(10) PRIMARY KEY,
    Region_Name VARCHAR(100),
    Region_Manager VARCHAR(100)
);

-- 2.2 Daily Sales
CREATE TABLE IF NOT EXISTS daily_sales (
    Sale_ID VARCHAR(20) PRIMARY KEY,
    Sale_Date DATETIME,
    Employee_ID VARCHAR(20),
    Customer_ID VARCHAR(20),
    Product_ID VARCHAR(20),
    Quantity INT,
    Unit_Price DECIMAL(18,2),
    Gross_Sales DECIMAL(18,2),
    Region_Code VARCHAR(10)
);

-- 2.3 Employee Target
CREATE TABLE IF NOT EXISTS employee_target (
    Target_Month DATE,
    Employee_ID VARCHAR(20),
    Region_Code VARCHAR(10),
    Monthly_Target DECIMAL(18,2)
);

-- 2.4 Orders
CREATE TABLE IF NOT EXISTS orders (
    Order_ID VARCHAR(20) PRIMARY KEY,
    Order_Date DATETIME,
    Employee_ID VARCHAR(20),
    Customer_ID VARCHAR(20),
    Product_ID VARCHAR(20),
    Quantity INT,
    Region_Code VARCHAR(10),
    Order_Value DECIMAL(18,2)
);

-- 2.5 Returns
CREATE TABLE IF NOT EXISTS returns (
    Return_ID VARCHAR(20) PRIMARY KEY,
    Return_Date DATE,
    Sale_ID VARCHAR(20),
    Product_ID VARCHAR(20),
    Return_Amount DECIMAL(18,2),
    Return_Reason VARCHAR(100)
);

-- 2.6 Attendance
CREATE TABLE IF NOT EXISTS attendance (
    Attendance_Date DATE,
    Employee_ID VARCHAR(20),
    Attendance_Status VARCHAR(50)
);

-- 2.7 Collections
CREATE TABLE IF NOT EXISTS collections (
    Collection_ID VARCHAR(20) PRIMARY KEY,
    Collection_Date DATETIME,
    Sale_ID VARCHAR(20),
    Customer_ID VARCHAR(20),
    Collection_Amount DECIMAL(18,2),
    Payment_Mode VARCHAR(50)
);


-- ============================================================
-- 3. STAGING TABLES
-- Raw CSV values are initially stored safely.
-- ============================================================

-- 3.1 Region Master Staging
CREATE TABLE IF NOT EXISTS stg_region_master (
    Region_Code VARCHAR(50),
    Region_Name VARCHAR(100),
    Region_Manager VARCHAR(100)
);

-- 3.2 Daily Sales Staging
CREATE TABLE IF NOT EXISTS stg_daily_sales (
    Sale_ID VARCHAR(50),
    Sale_Date VARCHAR(50),
    Employee_ID VARCHAR(50),
    Customer_ID VARCHAR(50),
    Product_ID VARCHAR(50),
    Quantity VARCHAR(50),
    Unit_Price VARCHAR(50),
    Gross_Sales VARCHAR(50),
    Region_Code VARCHAR(50)
);

-- 3.3 Monthly Targets Staging
CREATE TABLE IF NOT EXISTS stg_monthly_targets (
    Target_Month VARCHAR(50),
    Employee_ID VARCHAR(50),
    Region_Code VARCHAR(50),
    Monthly_Target VARCHAR(50)
);

-- 3.4 Employee Master Staging
CREATE TABLE IF NOT EXISTS stg_employee_master (
    Employee_ID VARCHAR(50),
    Employee_Name VARCHAR(100),
    Region_Code VARCHAR(50),
    Team VARCHAR(100),
    Join_Date VARCHAR(50),
    Status VARCHAR(50)
);

-- 3.5 Customer Master Staging
CREATE TABLE IF NOT EXISTS stg_customer_master (
    Customer_ID VARCHAR(50),
    Customer_Name VARCHAR(100),
    Region_Code VARCHAR(50),
    Customer_Type VARCHAR(50),
    City VARCHAR(100)
);

-- 3.6 Product Master Staging
CREATE TABLE IF NOT EXISTS stg_product_master (
    Product_ID VARCHAR(50),
    Product_Name VARCHAR(100),
    Category VARCHAR(100),
    Unit_Price DECIMAL(18,2),
    Cost_Price DECIMAL(18,2)
);

-- 3.7 Orders Staging
CREATE TABLE IF NOT EXISTS stg_orders (
    Order_ID VARCHAR(50),
    Order_Date VARCHAR(50),
    Employee_ID VARCHAR(50),
    Customer_ID VARCHAR(50),
    Product_ID VARCHAR(50),
    Quantity VARCHAR(50),
    Region_Code VARCHAR(50),
    Order_Value VARCHAR(50)
);

-- 3.8 Returns Staging
CREATE TABLE IF NOT EXISTS stg_returns (
    Return_ID VARCHAR(50),
    Return_Date VARCHAR(50),
    Sale_ID VARCHAR(50),
    Product_ID VARCHAR(50),
    Return_Amount VARCHAR(50),
    Return_Reason VARCHAR(100)
);

-- 3.9 Attendance Staging
CREATE TABLE IF NOT EXISTS stg_attendance (
    Attendance_Date VARCHAR(50),
    Employee_ID VARCHAR(50),
    Attendance_Status VARCHAR(50)
);

-- 3.10 Collections Staging
CREATE TABLE IF NOT EXISTS stg_collections (
    Collection_ID VARCHAR(50),
    Collection_Date VARCHAR(50),
    Sale_ID VARCHAR(50),
    Customer_ID VARCHAR(50),
    Collection_Amount VARCHAR(50),
    Payment_Mode VARCHAR(50)
);


-- ============================================================
-- 4. ENABLE LOCAL INFILE
-- ============================================================

SHOW VARIABLES LIKE 'local_infile';

-- If the result is OFF, run:
-- SET GLOBAL local_infile = 1;


-- ============================================================
-- 5. CSV IMPORTS INTO STAGING TABLES
-- ============================================================
-- IMPORTANT:
-- Run each LOAD DATA statement only once per file.
-- If you run it again, duplicate raw rows may be loaded.
-- ============================================================

-- 5.1 Region Master
LOAD DATA LOCAL INFILE
'C:/Users/Hooooo/Downloads/MIS/Region_Master.csv'
INTO TABLE stg_region_master
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;


-- 5.2 Daily Sales
LOAD DATA LOCAL INFILE
'C:/Users/Hooooo/Downloads/MIS/Daily_Sales.csv'
INTO TABLE stg_daily_sales
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;


-- 5.3 Monthly Targets
LOAD DATA LOCAL INFILE
'C:/Users/Hooooo/Downloads/MIS/Monthly_Targets.csv'
INTO TABLE stg_monthly_targets
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;


-- 5.4 Employee Master
LOAD DATA LOCAL INFILE
'C:/Users/Hooooo/Downloads/MIS/Employee_Master.csv'
INTO TABLE stg_employee_master
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;


-- 5.5 Customer Master
LOAD DATA LOCAL INFILE
'C:/Users/Hooooo/Downloads/MIS/Customer_Master.csv'
INTO TABLE stg_customer_master
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;


-- 5.6 Product Master
LOAD DATA LOCAL INFILE
'C:/Users/Hooooo/Downloads/MIS/Product_Master.csv'
INTO TABLE stg_product_master
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;


-- 5.7 Orders
LOAD DATA LOCAL INFILE
'C:/Users/Hooooo/Downloads/MIS/Orders.csv'
INTO TABLE stg_orders
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;


-- 5.8 Returns
LOAD DATA LOCAL INFILE
'C:/Users/Hooooo/Downloads/MIS/Returns.csv'
INTO TABLE stg_returns
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;


-- 5.9 Attendance
LOAD DATA LOCAL INFILE
'C:/Users/Hooooo/Downloads/MIS/Attendance.csv'
INTO TABLE stg_attendance
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;


-- 5.10 Collections
LOAD DATA LOCAL INFILE
'C:/Users/Hooooo/Downloads/MIS/Collections.csv'
INTO TABLE stg_collections
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;


-- ============================================================
-- 6. VERIFY ALL STAGING TABLES
-- ============================================================

SELECT 'stg_region_master' AS Table_Name,
       COUNT(*) AS Row_Count
FROM stg_region_master
UNION ALL
SELECT 'stg_daily_sales', COUNT(*)
FROM stg_daily_sales
UNION ALL
SELECT 'stg_monthly_targets', COUNT(*)
FROM stg_monthly_targets
UNION ALL
SELECT 'stg_employee_master', COUNT(*)
FROM stg_employee_master
UNION ALL
SELECT 'stg_customer_master', COUNT(*)
FROM stg_customer_master
UNION ALL
SELECT 'stg_product_master', COUNT(*)
FROM stg_product_master
UNION ALL
SELECT 'stg_orders', COUNT(*)
FROM stg_orders
UNION ALL
SELECT 'stg_returns', COUNT(*)
FROM stg_returns
UNION ALL
SELECT 'stg_attendance', COUNT(*)
FROM stg_attendance
UNION ALL
SELECT 'stg_collections', COUNT(*)
FROM stg_collections;


-- ============================================================
-- 7. SAMPLE DATA CHECK
-- ============================================================

SELECT * FROM stg_region_master LIMIT 5;
SELECT * FROM stg_daily_sales LIMIT 5;
SELECT * FROM stg_monthly_targets LIMIT 5;
SELECT * FROM stg_employee_master LIMIT 5;
SELECT * FROM stg_customer_master LIMIT 5;
SELECT * FROM stg_product_master LIMIT 5;
SELECT * FROM stg_orders LIMIT 5;
SELECT * FROM stg_returns LIMIT 5;
SELECT * FROM stg_attendance LIMIT 5;
SELECT * FROM stg_collections LIMIT 5;


-- ============================================================
-- END
-- ============================================================
