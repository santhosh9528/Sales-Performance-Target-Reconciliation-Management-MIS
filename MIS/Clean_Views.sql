-- ============================================================
-- SALES AUTOMATION - CLEAN VIEWS
-- Database: sales_automation
-- Purpose: Create dashboard-ready clean views without modifying
-- raw staging tables.
-- ============================================================

USE sales_automation;


-- ============================================================
-- 1. CLEAN DAILY SALES
-- Removes rows whose Employee, Customer, Product or Region
-- reference does not exist in the corresponding master.
-- EXISTS is used so duplicate master keys do NOT duplicate
-- sales rows.
-- ============================================================

CREATE OR REPLACE VIEW vw_clean_daily_sales AS
SELECT s.*
FROM stg_daily_sales s
WHERE EXISTS (
    SELECT 1
    FROM stg_employee_master e
    WHERE e.Employee_ID = s.Employee_ID
)
AND EXISTS (
    SELECT 1
    FROM stg_customer_master c
    WHERE c.Customer_ID = s.Customer_ID
)
AND EXISTS (
    SELECT 1
    FROM stg_product_master p
    WHERE p.Product_ID = s.Product_ID
)
AND EXISTS (
    SELECT 1
    FROM stg_region_master r
    WHERE r.Region_Code = s.Region_Code
);


-- ============================================================
-- 2. CLEAN ORDERS
-- Removes:
--   * Negative Order_Value
--   * Invalid Employee
--   * Invalid Customer
--   * Invalid Product
--   * Invalid Region
-- ============================================================

CREATE OR REPLACE VIEW vw_clean_orders AS
SELECT o.*
FROM stg_orders o
WHERE CAST(o.Order_Value AS DECIMAL(18,2)) >= 0
AND EXISTS (
    SELECT 1
    FROM stg_employee_master e
    WHERE e.Employee_ID = o.Employee_ID
)
AND EXISTS (
    SELECT 1
    FROM stg_customer_master c
    WHERE c.Customer_ID = o.Customer_ID
)
AND EXISTS (
    SELECT 1
    FROM stg_product_master p
    WHERE p.Product_ID = o.Product_ID
)
AND EXISTS (
    SELECT 1
    FROM stg_region_master r
    WHERE r.Region_Code = o.Region_Code
);


-- ============================================================
-- 3. CLEAN RETURNS
-- Removes:
--   * Invalid Sale_ID
--   * Invalid Product_ID
-- ============================================================

CREATE OR REPLACE VIEW vw_clean_returns AS
SELECT r.*
FROM stg_returns r
WHERE EXISTS (
    SELECT 1
    FROM stg_daily_sales s
    WHERE s.Sale_ID = r.Sale_ID
)
AND EXISTS (
    SELECT 1
    FROM stg_product_master p
    WHERE p.Product_ID = r.Product_ID
);


-- ============================================================
-- 4. CLEAN COLLECTIONS
-- Removes:
--   * Negative Collection_Amount
--   * Invalid Sale_ID
--   * Invalid Customer_ID
-- ============================================================

CREATE OR REPLACE VIEW vw_clean_collections AS
SELECT c.*
FROM stg_collections c
WHERE CAST(c.Collection_Amount AS DECIMAL(18,2)) >= 0
AND EXISTS (
    SELECT 1
    FROM stg_daily_sales s
    WHERE s.Sale_ID = c.Sale_ID
)
AND EXISTS (
    SELECT 1
    FROM stg_customer_master cm
    WHERE cm.Customer_ID = c.Customer_ID
);


-- ============================================================
-- 5. VERIFY CLEAN VIEW ROW COUNTS
-- ============================================================

SELECT
    (SELECT COUNT(*) FROM stg_daily_sales) AS Raw_Sales,
    (SELECT COUNT(*) FROM vw_clean_daily_sales) AS Clean_Sales,

    (SELECT COUNT(*) FROM stg_orders) AS Raw_Orders,
    (SELECT COUNT(*) FROM vw_clean_orders) AS Clean_Orders,

    (SELECT COUNT(*) FROM stg_returns) AS Raw_Returns,
    (SELECT COUNT(*) FROM vw_clean_returns) AS Clean_Returns,

    (SELECT COUNT(*) FROM stg_collections) AS Raw_Collections,
    (SELECT COUNT(*) FROM vw_clean_collections) AS Clean_Collections;


-- ============================================================
-- CURRENT VERIFIED COUNTS FROM THIS PROJECT
-- ============================================================
-- Clean Sales       = 5199
-- Clean Orders      = 5228
-- Clean Returns     = 649
-- Clean Collections = 4599
--
-- NOTE:
-- Do NOT DELETE or UPDATE records in the stg_ tables.
-- These views are the clean reporting layer for Power BI.
-- ============================================================
