# 🚀 SQL Data Warehouse and Analytics Project

Welcome to the **Data Warehouse and Analytics Project** repository.  
This project demonstrates a complete **end-to-end data warehousing solution**, including data ingestion, transformation, modeling, and analytics.

It is designed as a portfolio clsproject to showcase **industry-standard data engineering practices**.

---

## 🏗️ Data Architecture

The project follows the **Medallion Architecture** approach with **Bronze, Silver, and Gold layers**.


### 🔹 Layers Overview

#### 🥉 Bronze Layer (Raw Data)

- Ingests raw data from source systems (ERP and CRM) in CSV format
- Stores data in its original form in SQL Server
- Acts as a source of truth

#### 🥈 Silver Layer (Cleaned Data)

- Performs data cleansing, validation, and standardization
- Handles deduplication and schema consistency
- Prepares structured data for analysis

#### 🥇 Gold Layer (Business Layer)

- Implements **star schema (fact and dimension tables)**
- Optimized for reporting and analytics
- Provides business-ready datasets

---

## 📖 Project Overview

This project includes:

- **Data Architecture Design**  
  Implementation of Medallion Architecture (Bronze → Silver → Gold)

- **ETL Pipeline Development**  
  SQL-based pipelines to ingest and transform data

- **Data Modeling**  
  Design of fact and dimension tables for analytical workloads

- **Analytics & Reporting**  
  SQL queries to generate actionable business insights

🎯 This repository is an excellent resource for professionals and students looking to showcase expertise in:

- SQL Development
- Data Architect
- Data Engineering
- ETL Pipeline Developer
- Data Modeling
- Data Analytics

---

## 🛠️ Important Links & Tools:

Everything is for Free!

- **[Datasets](datasets/):** Access to the project dataset (csv files).
- **[SQL Server Express](https://www.microsoft.com/en-us/sql-server/sql-server-downloads):** Lightweight server for hosting your SQL database.
- **[SQL Server Management Studio (SSMS)](https://learn.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms?view=sql-server-ver16):** GUI for managing and interacting with databases.
- **[Git Repository](https://github.com/):** Set up a GitHub account and repository to manage, version, and collaborate on your code efficiently.
- **[DrawIO](https://www.drawio.com/):** Design data architecture, models, flows, and diagrams.
- **[Notion Project Steps](https://www.notion.so/SQL-Data-Warehouse-Project-3527743098d780b7ae68c05ae518be20?source=copy_link):** Access to All Project Phases and Tasks.

---

## 🚀 Project Requirements

### Building the Data Warehouse (Data Engineering)

#### Objective

Develop a modern data warehouse using SQL Server to consolidate sales data, enabling analytical reporting and informed decision-making.

#### Specifications

- **Data Sources**: Import data from two source systems (ERP and CRM) provided as CSV files.
- **Data Quality**: Cleanse and resolve data quality issues prior to analysis.
- **Integration**: Combine both sources into a single, user-friendly data model designed for analytical queries.
- **Scope**: Focus on the latest dataset only; historization of data is not required.
- **Documentation**: Provide clear documentation of the data model to support both business stakeholders and analytics teams.

---

### BI: Analytics & Reporting (Data Analysis)

#### Objective

Develop SQL-based analytics to deliver detailed insights into:

- **Customer Behavior**
- **Product Performance**
- **Sales Trends**

These insights empower stakeholders with key business metrics, enabling strategic decision-making.

## 📂 Repository Structure

```
data-warehouse-project/
│
├── datasets/                           # Raw datasets used for the project (ERP and CRM data)
│
├── docs/                               # Project documentation and architecture details
│   ├── data_layer.drawio               # Draw.io file for data layers of medallion architecture
│   ├── data_architecture.drawio        # Draw.io file shows the project's architecture
│   ├── data_catalog.md                 # Catalog of datasets, including field descriptions and metadata
│   ├── data_flow.drawio                # Draw.io file for the data flow diagram
│   ├── data_model.drawio               # Draw.io file for data models (star schema)
│   ├── naming-conventions.md           # Consistent naming guidelines for tables, columns, and files
│
├── scripts/                            # SQL scripts for ETL and transformations
│   ├── bronze/                         # Scripts for extracting and loading raw data
│   ├── silver/                         # Scripts for cleaning and transforming data
│   ├── gold/                           # Scripts for creating analytical models
│
├── tests/                              # Test scripts and quality files
│
├── README.md                           # Project overview and instructions
├── LICENSE                             # License information for the repository
└── .gitignore                          # Files and directories to be ignored by Git
```

---
