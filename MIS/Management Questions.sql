-- ============================================================
-- SALES PERFORMANCE - FINAL MANAGEMENT QUESTIONS
-- Database: sales_automation
-- Purpose: Generate analysis required for Management Questions 1-7
-- ============================================================

USE sales_automation;


-- ============================================================
-- Q1. WHICH REGION IS UNDERPERFORMING?
-- Actual Sales vs Region Target
-- ============================================================

SELECT
    r.Region_Code,

    ROUND(
        SUM(CAST(s.Gross_Sales AS DECIMAL(18,2))),
        2
    ) AS Actual_Sales,

    ROUND(
        SUM(CAST(t.Monthly_Target AS DECIMAL(18,2))),
        2
    ) AS Region_Target,

    ROUND(
        SUM(CAST(s.Gross_Sales AS DECIMAL(18,2)))
        -
        SUM(CAST(t.Monthly_Target AS DECIMAL(18,2))),
        2
    ) AS Sales_Gap,

    ROUND(
        SUM(CAST(s.Gross_Sales AS DECIMAL(18,2)))
        /
        NULLIF(SUM(CAST(t.Monthly_Target AS DECIMAL(18,2))),0)
        * 100,
        2
    ) AS Achievement_Percent

FROM vw_clean_daily_sales s

JOIN stg_monthly_targets t
    ON s.Employee_ID = t.Employee_ID
    AND DATE_FORMAT(
        STR_TO_DATE(s.Sale_Date,'%m/%d/%Y %H:%i'),
        '%Y-%m'
    )
    =
    DATE_FORMAT(t.Target_Month,'%Y-%m')

JOIN stg_region_master r
    ON s.Region_Code = r.Region_Code

GROUP BY r.Region_Code

ORDER BY Achievement_Percent ASC;


-- ============================================================
-- Q2. WHICH EMPLOYEES REQUIRE MANAGEMENT ATTENTION?
-- Employees below 70% target
-- ============================================================

SELECT
    s.Employee_ID,

    ROUND(
        SUM(CAST(s.Gross_Sales AS DECIMAL(18,2))),
        2
    ) AS Actual_Sales,

    ROUND(
        SUM(CAST(t.Monthly_Target AS DECIMAL(18,2))),
        2
    ) AS Employee_Target,

    ROUND(
        SUM(CAST(s.Gross_Sales AS DECIMAL(18,2)))
        /
        NULLIF(SUM(CAST(t.Monthly_Target AS DECIMAL(18,2))),0)
        * 100,
        2
    ) AS Achievement_Percent

FROM vw_clean_daily_sales s

JOIN stg_monthly_targets t
    ON s.Employee_ID = t.Employee_ID
    AND DATE_FORMAT(
        STR_TO_DATE(s.Sale_Date,'%m/%d/%Y %H:%i'),
        '%Y-%m'
    )
    =
    DATE_FORMAT(t.Target_Month,'%Y-%m')

GROUP BY s.Employee_ID

HAVING Achievement_Percent < 70

ORDER BY Achievement_Percent ASC;


-- ============================================================
-- Q3. WHY IS ACHIEVEMENT BELOW TARGET?
-- Monthly Actual vs Target
-- ============================================================

WITH sales_by_month AS
(
    SELECT
        DATE_FORMAT(
            STR_TO_DATE(Sale_Date,'%m/%d/%Y %H:%i'),
            '%Y-%m'
        ) AS Sales_Month,

        SUM(
            CAST(Gross_Sales AS DECIMAL(18,2))
        ) AS Actual_Sales

    FROM vw_clean_daily_sales

    GROUP BY
        DATE_FORMAT(
            STR_TO_DATE(Sale_Date,'%m/%d/%Y %H:%i'),
            '%Y-%m'
        )
),

target_by_month AS
(
    SELECT
        DATE_FORMAT(Target_Month,'%Y-%m') AS Target_Month,

        SUM(
            CAST(Monthly_Target AS DECIMAL(18,2))
        ) AS Target

    FROM stg_monthly_targets

    GROUP BY
        DATE_FORMAT(Target_Month,'%Y-%m')
)

SELECT
    s.Sales_Month,

    ROUND(s.Actual_Sales,2) AS Actual_Sales,

    ROUND(t.Target,2) AS Target,

    ROUND(
        s.Actual_Sales - t.Target,
        2
    ) AS Sales_Gap,

    ROUND(
        s.Actual_Sales
        /
        NULLIF(t.Target,0)
        * 100,
        2
    ) AS Achievement_Percent

FROM sales_by_month s

JOIN target_by_month t
    ON s.Sales_Month = t.Target_Month

ORDER BY s.Sales_Month;


-- ============================================================
-- Q4. WHICH PRODUCTS ARE DRIVING THE DECLINE?
-- August vs September
-- ============================================================

WITH product_monthly_sales AS
(
    SELECT
        Product_ID,

        DATE_FORMAT(
            STR_TO_DATE(Sale_Date,'%m/%d/%Y %H:%i'),
            '%Y-%m'
        ) AS Sales_Month,

        SUM(
            CAST(Gross_Sales AS DECIMAL(18,2))
        ) AS Sales

    FROM vw_clean_daily_sales

    GROUP BY
        Product_ID,
        DATE_FORMAT(
            STR_TO_DATE(Sale_Date,'%m/%d/%Y %H:%i'),
            '%Y-%m'
        )
)

SELECT
    Product_ID,

    ROUND(
        SUM(
            CASE
                WHEN Sales_Month = '2026-08'
                THEN Sales
                ELSE 0
            END
        ),
        2
    ) AS August_Sales,

    ROUND(
        SUM(
            CASE
                WHEN Sales_Month = '2026-09'
                THEN Sales
                ELSE 0
            END
        ),
        2
    ) AS September_Sales,

    ROUND(
        SUM(
            CASE
                WHEN Sales_Month = '2026-09'
                THEN Sales
                ELSE 0
            END
        )
        -
        SUM(
            CASE
                WHEN Sales_Month = '2026-08'
                THEN Sales
                ELSE 0
            END
        ),
        2
    ) AS Sales_Decline

FROM product_monthly_sales

GROUP BY Product_ID

HAVING Sales_Decline < 0

ORDER BY Sales_Decline ASC;


-- ============================================================
-- Q5A. DUPLICATE SALES TRANSACTIONS
-- ============================================================

SELECT
    COUNT(*) AS Total_Sales,

    COUNT(DISTINCT Sale_ID) AS Unique_Sales,

    COUNT(*) - COUNT(DISTINCT Sale_ID)
        AS Duplicate_Sales

FROM vw_clean_daily_sales;


-- ============================================================
-- Q5B. ORDERS WITHOUT SALES
-- ============================================================

SELECT
    COUNT(*) AS Orders_Without_Sales

FROM stg_orders o

WHERE NOT EXISTS
(
    SELECT 1

    FROM stg_daily_sales s

    WHERE s.Sale_ID = o.Order_ID
);


-- ============================================================
-- Q5C. SALES WITHOUT COLLECTIONS
-- ============================================================

SELECT
    COUNT(*) AS Sales_Without_Collections

FROM stg_daily_sales s

WHERE NOT EXISTS
(
    SELECT 1

    FROM stg_collections c

    WHERE c.Sale_ID = s.Sale_ID
);


-- ============================================================
-- Q5D. RETURNS WITHOUT SALES
-- ============================================================

SELECT
    COUNT(*) AS Returns_Without_Sales

FROM stg_returns r

WHERE NOT EXISTS
(
    SELECT 1

    FROM stg_daily_sales s

    WHERE s.Sale_ID = r.Sale_ID
);


-- ============================================================
-- Q5E. COLLECTIONS WITHOUT SALES
-- ============================================================

SELECT
    COUNT(*) AS Collections_Without_Sales

FROM stg_collections c

WHERE NOT EXISTS
(
    SELECT 1

    FROM stg_daily_sales s

    WHERE s.Sale_ID = c.Sale_ID
);


-- ============================================================
-- Q6. HOW MUCH REVENUE IS AFFECTED BY RETURNS?
-- ============================================================

SELECT

    ROUND(
        SUM(
            CAST(Return_Amount AS DECIMAL(18,2))
        ),
        2
    ) AS Total_Return_Revenue

FROM vw_clean_returns;


-- ============================================================
-- Q6B. RETURN RATE
-- ============================================================

SELECT

    ROUND(
        SUM(
            CAST(Return_Amount AS DECIMAL(18,2))
        ),
        2
    ) AS Total_Return_Revenue,

    ROUND(
        (
            SUM(
                CAST(Return_Amount AS DECIMAL(18,2))
            )
            /
            NULLIF(
                (
                    SELECT
                        SUM(
                            CAST(Gross_Sales AS DECIMAL(18,2))
                        )
                    FROM vw_clean_daily_sales
                ),
                0
            )
        ) * 100,
        2
    ) AS Return_Revenue_Percent

FROM vw_clean_returns;


-- ============================================================
-- Q7. WHAT SHOULD MANAGEMENT DO NEXT MONTH?
-- Generate management action priorities
-- ============================================================

SELECT
    1 AS Priority,
    'Sales Recovery' AS Action_Area,
    'September MTD achievement is 40.53% with a sales gap of 38.89M'
        AS Finding,
    'Increase sales follow-up and focus on high-value opportunities'
        AS Recommended_Action

UNION ALL

SELECT
    2,
    'Product Performance',
    'P3008, P3037 and P3031 are the largest declining products',
    'Review product demand, pricing, availability and sales strategy'

UNION ALL

SELECT
    3,
    'Collections',
    '602 sales transactions have no matching collection',
    'Finance and sales teams should immediately follow up on pending collections'

UNION ALL

SELECT
    4,
    'Reconciliation',
    '30 orders have no corresponding sales record',
    'Investigate missing sales transactions and strengthen order-to-sales reconciliation'

UNION ALL

SELECT
    5,
    'Returns',
    'Return revenue impact is 8.41M',
    'Analyze return reasons and reduce recurring product and customer issues'

UNION ALL

SELECT
    6,
    'Employee Performance',
    'Employees below target require management attention',
    'Create individual improvement plans and monitor performance weekly'

UNION ALL

SELECT
    7,
    'Regional Performance',
    'Underperforming regions are affecting overall target achievement',
    'Set region-specific recovery targets and review progress regularly';


-- ============================================================
-- FINAL MANAGEMENT SUMMARY - VERIFIED FINDINGS
-- ============================================================
--
-- Q1:
-- Identify the region with the lowest Achievement_Percent
-- from Q1 output.
--
-- Q2:
-- Employees with Achievement_Percent < 70% require
-- management attention.
--
-- Q3:
-- September MTD:
-- Actual Sales       = 26,507,693.57
-- Target             = 65,398,401.43
-- Sales Gap          = -38,890,707.86
-- Achievement       = 40.53%
--
-- Q4:
-- Biggest declining products:
-- P3008 = -4,319,985.44
-- P3037 = -4,276,702.26
-- P3031 = -3,843,090.47
--
-- Q5:
-- Duplicate Sales              = 0
-- Orders without Sales         = 30
-- Sales without Collections    = 602
--
-- Q6:
-- Total Return Revenue         = 8,407,871.70
--
-- Q7:
-- Management should focus on:
-- 1. Sales recovery
-- 2. Declining products
-- 3. Pending collections
-- 4. Order-to-sales reconciliation
-- 5. Return reduction
-- 6. Employee performance
-- 7. Regional recovery plans
--
-- ============================================================
-- END OF MANAGEMENT QUESTIONS SQL
-- ============================================================