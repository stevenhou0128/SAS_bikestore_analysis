# SAS Bike Store Pricing Analysis

Conducted pricing analysis of two bike retailers (ABC Bikes and Woolywheels) using SAS, covering data cleaning, category standardization, and visual reporting.

## Summary
This project aims to analyse product data from two bike retail stores. The goal was to clean, merge, and standardise inconsistent product categories and vendor names across both stores, then compare pricing patterns by product type, brand, and store to identify market positioning opportunities.


## Business Understanding
### Project Aims
* Analyse and compare the pricing strategies between two Australian bicycle retailers - ABC Bikes and Woolywheels
* Identify the differences in product and vendor diversity
* Specify own brands of two retailers and primary brand

### Business Objectives
* Help a bicycle retail entrant to enter Australian market
* Define the pricing strategy and how to compete with two existing retailers

### Project Deliverables
* Report of pricing analysis
* Dashboard of key findings
* SAS script

## Data Understanding
### Data Collection
* Source 1: ABC_Bikes - Excel files including 25,410 product records
* Source 2: woolywheels_com_au - Excel files including 7,278 product records
* Combined datasets: Bikes_Stores - Excel files containing 7,536 product records

### Data Description
* Rows: 7,536
* Columns: 8 variables
  Name - Character - Product Name
  Store - Character - Retailer name (ABC Bikes or Woolywheels)
  Product_id - Character - Unique identifier for each product
  Vendor - Character - Brand or manufacturer name
  Prices - Numeric - Selling price
  Compare_Prices - Numeric - Original price before discount
  Product_Types - Character - Product category label
  Discount - Numeric - calculated ratio

## Data Preparation
### Data Cleaning
* Renamed variables to consistent names across two datasets
* Replaced missing or blank values in Compare_Prices with the corresponding Prices value
* Revomed zero price records
* Removed duplicate records

### Data Transformation
* Standardised inconsistent vendor names across both datasets
* Standardised product category labels to four features: Accessories, Bikes, Clothes, Helmets
* Added store variable to identify store information in two datasets
* Created discount variable - Prices / Compare_Prices 

### Data Integration
* Combined two cleaned datasets







    
