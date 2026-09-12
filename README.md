# Sales Performance, Target Reconciliation & Management MIS

## 📌 Project Overview

This project presents an end-to-end **Sales Performance, Target Reconciliation & Management MIS** solution developed to provide management with a centralized view of sales performance, employee achievement, regional performance, reconciliation issues, and business exceptions.

The project integrates **Excel, Power Query, SQL, Python, DAX, and Power BI** to clean and validate business data, automate MIS reporting, reconcile operational and financial records, identify exceptions, and provide actionable management insights.

---

## 🎯 Business Objective

The organization operates across multiple regions with several employees, customers, products, and sales transactions.

Management requires a reporting solution to identify inconsistencies between:

- Sales Targets
- Actual Sales
- Orders
- Returns
- Collections
- Employee Performance
- Regional Performance

The objective is to create an automated MIS system that provides management with a clear and interactive view of business performance.

---

## 📂 Datasets

The project uses the following datasets:

- Employee Master
- Customer Master
- Product Master
- Region Master
- Daily Sales
- Monthly Targets
- Orders
- Collections
- Returns
- Attendance

---

## 🛠️ Tools & Technologies

The project was developed using:

- **Microsoft Excel**
- **Power Query**
- **SQL**
- **Python**
- **Power BI**
- **DAX**

These technologies were used for data cleaning, validation, transformation, reconciliation, automation, analysis, and dashboard development.

---

# 🔄 Project Workflow

```text
Raw Business Data
        ↓
Data Validation
        ↓
Data Cleaning
        ↓
Power Query Transformation
        ↓
SQL / Python Processing
        ↓
Sales & Target Analysis
        ↓
Reconciliation
        ↓
Exception Detection
        ↓
MIS Automation
        ↓
Power BI Dashboard
        ↓
Management Insights
```

---

# 1️⃣ Data Validation

The first stage of the project focuses on identifying data-quality issues.

Validation checks include:

- Duplicate Employees
- Duplicate Customers
- Missing Employee IDs
- Invalid Product IDs
- Invalid Region Codes
- Duplicate Transactions
- Incorrect Dates
- Negative Sales
- Invalid Target Values

A separate **Data Quality Report** was created to document identified issues.

---

# 2️⃣ Sales MIS Analysis

The Sales MIS calculates important management KPIs including:

- Daily Sales
- Month-to-Date Sales
- Year-to-Date Sales
- Monthly Target
- Achievement %
- Sales Gap
- Growth %
- Average Order Value

These metrics allow management to compare actual performance against sales targets.

---

# 3️⃣ Employee Performance Analysis

Employee performance is evaluated using:

- Total Sales
- Target Achievement
- Number of Orders
- Average Order Value
- Sales Growth

The analysis identifies:

- Top Performers
- Bottom Performers
- Employees Below Target
- Employees Below 70% Achievement
- Employees with Declining Performance

---

# 4️⃣ Region Analysis

Regional performance is analyzed using:

- Regional Sales
- Region Target
- Achievement %
- Previous Month Sales
- Growth %
- Sales Contribution

This helps identify high-performing and underperforming regions.

---

# 5️⃣ Sales & Finance Reconciliation

The complete transaction lifecycle is reconciled:

```text
Orders
   ↓
Sales
   ↓
Returns
   ↓
Net Sales
   ↓
Collections
```

The reconciliation process helps identify:

- Orders Without Sales
- Sales Without Collections
- Collection Mismatches
- Return Differences
- Missing Transactions
- Reconciliation Exceptions

---

# 6️⃣ Exception Analysis

The project automatically identifies important business exceptions such as:

- Employees Below Target
- Regions Below Target
- High Returns
- Missing Transactions
- Duplicate Transactions
- Sales Without Collections
- Orders Without Sales Records
- Reconciliation Issues

This allows management to focus on records requiring immediate attention.

---

# 7️⃣ MIS Automation

The MIS workflow is designed to process updated business data without manually rebuilding the complete report.

Automation uses:

- Excel Power Query
- SQL
- Python

### Automated Workflow

```text
New Daily Files
      ↓
Data Validation
      ↓
Data Cleaning
      ↓
Automated Processing
      ↓
Reconciliation
      ↓
Exception Detection
      ↓
MIS Refresh
      ↓
Power BI Refresh
      ↓
Updated Management Dashboard
```

---

# 📊 Power BI Dashboard

The Power BI report contains multiple analytical pages covering management performance, employees, regions, reconciliation, and business exceptions.

---

## 📌 Management Dashboard

The **Management Dashboard** provides a consolidated view of important business KPIs and overall performance.

It helps management monitor sales, targets, achievement, trends, and other key business indicators.

![Management Dashboard](Power%20BI/Dashboard%20screenshots/Management%20Dashboard.png)

---

## 👨‍💼 Employee Performance Dashboard

The **Employee Performance Dashboard** analyzes individual employee performance.

It helps identify:

- Employee Sales
- Target Achievement
- Top Performers
- Bottom Performers
- Employee Ranking
- Employees Requiring Management Attention

![Employee Performance](Power%20BI/Dashboard%20screenshots/Employee%20Performance.png)

---

## 🌍 Region Analysis Dashboard

The **Region Analysis Dashboard** compares performance across different business regions.

The analysis includes:

- Regional Sales
- Regional Targets
- Achievement %
- Regional Contribution
- Growth
- Underperforming Regions

![Region Analysis](Power%20BI/Dashboard%20screenshots/Region%20Analysis.png)

---

## 🔄 Reconciliation Dashboard

The **Reconciliation Dashboard** provides visibility into differences between orders, sales, returns, net sales, and collections.

It helps management identify transaction and finance-related mismatches.

![Reconciliation Dashboard](Power%20BI/Dashboard%20screenshots/Reconciliation%20.png)

---

## 🚨 Exception Analysis Dashboard

The **Exception Analysis Dashboard** highlights important business exceptions requiring management attention.

The dashboard helps identify:

- Employees Below Target
- Regional Exceptions
- High Returns
- Missing Transactions
- Collection Issues
- Reconciliation Problems

![Exception Analysis](Power%20BI/Dashboard%20screenshots/Exception%20Analysis.png)

---

## ⚙️ Automated Exception Report

The **Automated Exception Report** provides a structured view of automatically detected business exceptions.

It reduces the need for manual transaction-level checking and allows management to focus on important issues.

![Automated Exception Report](Power%20BI/Dashboard%20screenshots/Exception%20Report%20Automated%20.png)

---

# 📊 Dashboard Summary

| Dashboard | Primary Focus |
|---|---|
| **Management Dashboard** | Overall business performance and management KPIs |
| **Employee Performance** | Employee sales, targets and ranking |
| **Region Analysis** | Regional sales, targets and performance |
| **Reconciliation** | Orders, sales, returns and collection reconciliation |
| **Exception Analysis** | Identification of business exceptions |
| **Automated Exception Report** | Automated monitoring of exception records |

---

# ❓ Management Questions

The project helps management answer:

1. Which region is underperforming?
2. Which employees require management attention?
3. Why is achievement below target?
4. Which products are driving the decline?
5. Where are reconciliation issues occurring?
6. How much revenue is affected by returns?
7. What actions should management take next month?

---

# 💡 Business Value

The MIS solution helps management:

- Monitor Sales vs Targets
- Track Employee Performance
- Compare Regional Performance
- Identify Sales Gaps
- Detect Reconciliation Issues
- Monitor Collections
- Analyze Returns
- Automatically Identify Exceptions
- Reduce Manual Reporting
- Improve Reporting Accuracy
- Support Faster Management Decisions

---

# 📁 Project Structure

```text
MIS/
│
├── Dataset/
├── Cleaned Data/
├── Data Quality Report/
├── Excel MIS/
├── SQL/
├── Python/
├── Exception Report/
├── Management Summary/
│
├── Power BI/
│   ├── Dashboard.pbix
│   │
│   └── Dashboard screenshots/
│       ├── Employee Performance.png
│       ├── Exception Analysis.png
│       ├── Exception Report Automated .png
│       ├── Management Dashboard.png
│       ├── Reconciliation .png
│       └── Region Analysis.png
│
└── README.md
```

---

# 🚀 Skills Demonstrated

This project demonstrates practical experience in:

- Data Cleaning
- Data Validation
- Data Quality Analysis
- Excel
- Power Query
- SQL
- Python
- DAX
- Power BI
- Sales Analytics
- Target vs Actual Analysis
- Employee Performance Analysis
- Regional Performance Analysis
- Financial Reconciliation
- Exception Reporting
- MIS Automation
- Management Reporting
- Dashboard Development
- Business Intelligence
- Data Visualization
- Data-Driven Decision Making

---

# 🎯 Project Goal

The goal of this project is to demonstrate an end-to-end **Sales Performance, Target Reconciliation & Management MIS workflow**.

```text
Data
 ↓
Validation
 ↓
Cleaning
 ↓
Transformation
 ↓
Sales Analysis
 ↓
Target Reconciliation
 ↓
Exception Detection
 ↓
MIS Automation
 ↓
Power BI Reporting
 ↓
Management Insights
```

---

# 📝 Conclusion

This project demonstrates how **Excel, Power Query, SQL, Python, DAX, and Power BI** can be integrated to develop an automated Management Information System.

The solution converts operational business data into structured management information through **data validation, sales analysis, target monitoring, reconciliation, exception detection, automation, and interactive dashboards**.

The resulting MIS helps management identify performance gaps, operational discrepancies, and areas requiring attention while reducing repetitive manual reporting work.

---

## 👤 Author

**Santhosh Kumar M.**

### Data Analytics Skills

**Excel | SQL | Python | Power Query | Power BI | DAX | Data Analysis | MIS Reporting | MIS Automation | Data Visualization**
