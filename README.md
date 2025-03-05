# Customer_Life_Value_Analysis
Strategic Customer Segmentation Using Customer Lifetime Value (CLV) Analysis

Project Overview:
NexaSat, a telecommunications company, faces challenges in optimizing marketing strategies due to its diverse customer base. This project aims to enhance revenue growth by segmenting customers based on their Customer Lifetime Value (CLV) and designing targeted upselling and cross-selling strategies.

The project leverages data-driven segmentation to identify high-value customers, personalize service offerings, and increase Average Revenue Per User (ARPU) while improving customer satisfaction and loyalty.

🎯 Objectives:
Develop a structured CLV segmentation model to classify customers based on their long-term value.
Identify high-opportunity segments for upselling and cross-selling.
Personalize marketing strategies based on customer behavior and usage patterns.
Optimize NexaSat’s revenue by focusing on the most profitable customer segments.

📂 Project Structure:
The repository contains the following files:

│── NexaSat_data.csv                   # Customer data used for analysis
│── clv_analysis.sql                   # SQL queries used for the project 
│── clv_segmentation.ipynb             # Jupyter Notebook with EDA, CLV Analysis & segmentation
│── percentage_weight_clv.ipynb        # Jupyter Notebook with Random Forest model for CLV weight analysis
│── README.md                          # This file

📊 Data Description:
The dataset consists of customer information, including demographics, billing, and usage details:

Customer_ID: Unique identifier for each customer
Gender: Gender of the customer
Monthly_bill_amount: The customer's monthly bill amount
Tenure_Months: Length of time the customer has been with NexaSat
Partner: Whether the customer has a partner (Yes/No)
Dependents: Whether the customer has dependents (Yes/No)
Senior_Citizen: Whether the customer is a senior citizen (1 for Yes, 0 for No)
Call_Duration: Total duration of calls made by the customer
Data_Usage: Amount of data used by the customer
Plan_Type: Type of plan subscribed to (Prepaid/Postpaid)
Plan_Level: Level or tier of the subscribed plan (Basic/Premium)


🛠 Tech Stack:
PostgreSQL: Used for data storage, querying, and manipulation.
Jupyter Notebook:
   >  CLV Segmentation Notebook: Contains Data analysis using SQL queries, insights, and recommended marketing strategies.
   >  Random Forest Model Notebook: Used for feature importance analysis.
Pandas, NumPy, Matplotlib, Seaborn: Libraries used for data analysis and visualization.
Scikit-Learn: Used for building the Random Forest model for feature importance analysis.


🔍 Project Steps:
Exploratory Data Analysis (EDA) – Understanding customer behavior and identifying key patterns.
Feature Engineering – Creating CLV-related features for segmentation.
Customer Segmentation – Clustering customers based on their CLV scores.
Strategy Formulation – Recommending targeted marketing strategies for each segment.
Modeling (Random Forest) – Using machine learning to determine feature importance in predicting CLV.


📌 Key Insights:
High-value customers are identified based on their spending, tenure, and service usage.
Low-value and churn-risk segments are identified for retention strategies.
Upselling opportunities include promoting premium plans, bundling services, and targeting high-data users.

🚀 How to Use:
Load the dataset (dataset.xlsx) into PostgreSQL.
Run the SQL scripts (clv_analysis.sql) to preprocess and extract relevant data.
Execute clv_segmentation.ipynb for EDA, segmentation, and insights.
Use random_forest_clv_model.ipynb to analyze feature importance using machine learning.
Interpret results and apply recommendations for revenue growth.


🏆 Conclusion:
This project provides a structured, data-driven approach to customer segmentation, helping NexaSat improve its marketing strategies. By focusing on CLV-based segmentation, the company can increase revenue, enhance customer satisfaction, and build long-term customer relationships.


