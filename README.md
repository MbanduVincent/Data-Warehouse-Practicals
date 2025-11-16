# 🚀 Data Warehouse Project: Medallion Architecture & OLAP Analysis

This repository contains a comprehensive, hands-on project demonstrating the setup, development, and analysis of a modern Data Warehouse using PostgreSQL and the Medallion Architecture.

---

## 🎯 Project Goals

The primary goal is to **integrate** and **transform** raw sales and customer data from multiple source systems (ERP and CRM) into a clean, analytical data model to support Business Intelligence (BI) and decision-making.

---

## ⚙️ Technical Stack

* **Database:** PostgreSQL (for hosting the DW)
* **Architecture:** Medallion (Bronze, Silver, Gold layers)
* **Data Modeling:** Dimensional Model (Star Schema views)
* **ETL/Analysis:** Python (Pandas, SQLAlchemy) and SQL

---

## 🏗️ Data Warehouse Architecture (Medallion)

Data progresses through three distinct layers to ensure quality and structure:

1.  **🥉 Bronze Layer (Raw):** Initial landing zone for untouched, raw data from source systems.
2.  **🥈 Silver Layer (Cleaned & Integrated):** Data is cleansed (duplicates removed, inconsistencies resolved) and standardized using ETL techniques.
3.  **🥇 Gold Layer (Curated & Consumable):** Final, highly-curated layer modeled into **Dimension** and **Fact** tables, optimized for analytical queries (Business Intelligence).

---

## 📊 Analytical Operations Demonstrated (OLAP)

The final Gold layer is queried to demonstrate core Online Analytical Processing (OLAP) techniques:

* **Roll-up & Drill-down:** Summarizing or detailing sales data across time hierarchies (e.g., from day to year).
* **Slice & Dice:** Filtering data to focus on specific dimensions or ranges (e.g., Q1 sales in Germany for specific products).
* **Pivot:** Reorienting the data view (e.g., Sales by Region vs. Sales by Product).

---

## 🛠️ Setup Instructions

To run this project locally, you'll need to set up the PostgreSQL database:

1.  **Install PostgreSQL:** Download and install PostgreSQL on your system.
2.  **Initialize Database:** Run the setup script:
    ```bash
    psql -U postgres -d postgress Data-WareHousing\scripts\init_db.sql
    ```
3.  **Create Bronze Tables:**
    ```bash
    psql -U postgres -f scripts/bronze/ddl.sql
    ```
4.  **Load Data:** Use the `psql` shell to run the copy commands listed in `scripts/add_data.txt` to load the CSV files into the Bronze layer.
5.  **Build Silver/Gold:** Follow the steps and SQL queries outlined in the **`Data Warehouse.ipynb`** notebook to run the transformation logic and build the higher layers.
