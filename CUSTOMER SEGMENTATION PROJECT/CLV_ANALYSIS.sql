CREATE TABLE nexasat (
Customer_ID varchar(50),
gender varchar(3),
Partner varchar(3),
Dependents varchar(3),
Senior_citizen int,
Call_duration float,
Data_usage float,
Plan_Type varchar(20),
Plan_Level varchar(20),
Monthly_Bill_Amount float,
Tenure_Months int,
Multiple_line varchar(3),
Tech_Support varchar(3),
Churn int);

select * from nexasat LIMIT 5;

-- View customers who has stayed more then one year
Select customer_id, tenure_months from nexasat
where tenure_months >12;

-- Checking for missings values
SELECT COUNT(*) - COUNT(Customer_ID) AS missing_data FROM nexasat;

-- Checking for duplicates
SELECT Customer_ID, COUNT(*) 
FROM nexasat
GROUP BY Customer_ID
HAVING COUNT(*) > 1;


-- Exploring the dataset
SELECT 
  AVG(Monthly_Bill_Amount) AS avg_bill,
  MIN(Monthly_Bill_Amount) AS min_bill,
  MAX(Monthly_Bill_Amount) AS max_bill,
  AVG(Call_Duration) AS avg_call_duration,
  AVG(Data_Usage) AS avg_data_usage,
  COUNT(DISTINCT Plan_Type) AS num_plans
FROM nexasat;


-- Average tenure per plan level
SELECT AVG(Tenure_Months) as average_ten, Plan_Level FROM nexasat 
GROUP BY Plan_Level;

-- Gender distribution
SELECT gender, COUNT(*) FROM nexasat GROUP BY gender;

-- Partner status distribution
SELECT Partner, COUNT(*) FROM nexasat GROUP BY Partner; 

-- Dependents status distribution 
SELECT Dependents, COUNT(*) FROM nexasat GROUP BY Dependents;

-- Total users still in service
SELECT COUNT(Customer_ID) AS existing_users
FROM nexasat
where Churn = 0;

-- Average tenure of churned customers per plan_level
SELECT Plan_Level, AVG(Tenure_Months) AS average_tenure
FROM nexasat WHERE Churn = 1
GROUP BY 1;

-- Churn count by plan_level
SELECT COUNT(Customer_ID) AS numberof_users , Plan_Level 
FROM nexa_sat where Churn = 1 GROUP BY 2;


-- Create a table of existing users only

CREATE TABLE existing_users AS
SELECT * FROM nexasat
WHERE Churn = 0;


-- Total number of customers who could benefit from multiple lines
SELECT count(Customer_ID) FROM existing_users
WHERE Multiple_Lines = 'No' AND (Dependents = 'Yes' OR Partner = 'Yes');


-- Identifying customers who could benefit from multiple lines 
SELECT Customer_ID, Multiple_Lines, Dependents , Partner FROM existing_users 
WHERE  Multiple_Lines = 'No' AND (Dependents = 'Yes' OR Partner = 'Yes') ;

-- Identifying Senior citizens who do not have dependents and tech_support
SELECT Customer_ID, Plan_level FROM existing_users 
WHERE  Dependents = 'No' AND Tech_Support = 'No' ;

-- Total users by level
SELECT Plan_Level, COUNT(Customer_ID) AS total_users
FROM existing_users 
GROUP BY 1;
 
-- Total revenue by level
SELECT Plan_Level , (SUM(Monthly_Bill_Amount) AS Revenue
FROM existing_users 
GROUP BY 1;

-- Average tenure of existing users
SELECT AVG(Tenure_Months) AS Avg_Tenure
FROM existing_users;

-- Altere the table and adding Customer Life value Clv column
ALTER TABLE existing_users ADD COLUMN Clv FLOAT; 

-- Calculate the Clv 
UPDATE existing_users 
SET Clv = (Monthly_Bill_Amount * Tenure_Months);


--Add new column for Clv scores
ALTER TABLE existing_users ADD COLUMN Clv_Score FLOAT;

-- Calculate the Clv score, the weight value of the variables was calculated using Random Forest model
UPDATE existing_users
SET Clv_Score = 
    (Data_Usage * 0.2336) +
    (Tenure_Months * 0.1960) +
    (Call_Duration * 0.1886) +
    (Monthly_Bill_Amount * 0.1566) +
    (CASE WHEN Plan_Level = 'Premium' THEN 1 ELSE 0 END * 0.1680) +
    (CASE WHEN Plan_Type = 'Prepaid' THEN 1 ELSE 0 END * 0.0213) +
    (CASE WHEN Partner = 'Yes' THEN 1 ELSE 0 END * 0.0174) +
    (CASE WHEN Dependents = 'Yes' THEN 1 ELSE 0 END * 0.0142) +
    (Senior_Citizen * 0.0140);


-- Getting the range of the Clv scores.
SELECT 
    MIN(Clv_Score) AS Min_CLV,
    MAX(Clv_Score) AS Max_CLV,
    AVG(Clv_Score) AS Avg_CLV
FROM existing_users;


-- Add a new column to store the Clv segment
ALTER TABLE existing_users ADD COLUMN Clv_Segment VARCHAR(20);

-- Group users into segment based of their clv scores
UPDATE existing_users
SET Clv_Segment =
    CASE
        WHEN Clv_Score > (SELECT PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY Clv_Score) FROM existing_users)
             THEN 'High Value'
        WHEN Clv_Score > (SELECT PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY Clv_Score) FROM existing_users)
             THEN 'Moderate Value'
        WHEN Clv_Score > (SELECT PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY Clv_Score) FROM existing_users)
             THEN 'Low Value'
        ELSE 'Churn Risk'
    END;

-- View customer clv score and segment
SELECT Customer_id, Clv, Clv_score, Clv_segment from existing_users LIMIT 20;

-- View high value customers
SELECT customer_id, Clv_segment FROM existing_users where Clv_segment = 'High Value';


-- View customers at the risk of churn
SELECT customer_id, Clv_segment FROM existing_users where Clv_segment = 'Churn Risk';

-- Analyze the segment
--Average bill and tenure per segment
SELECT Clv_segment,
       ROUND(AVG(Monthly_bill_amount::INT),2) AS Avg_bill, 
       ROUND(AVG(tenure_months::INT),2) AS Avg_tenure 
FROM existing_users
GROUP BY Clv_segment;


-- Premium plan across each segment
SELECT Clv_segment, COUNT(plan_level), 
WHERE plan_level = 'Premium'
GROUP BY 1;

--Revenue per segment
SELECT Clv_Segment, COUNT(Customer_id) AS Number_of_customers,
       ROUND(SUM(Monthly_Bill_Amount::INT),2)AS Total_Revenue,
	   ROUND(AVG(Monthly_Bill_Amount::INT),2) AS Avg_Revenue
FROM existing_users
GROUP BY 1 ;

-- MARKETING STRATEGIES
-- Cross selling Tech support to senior citizens
SELECT customer_id
FROM existing_users
WHERE senior_citizen = 1 -- senior citizens
AND dependents = 'No' -- No children or tech savvy helpers
AND tech_support = 'No'  -- do not already have this service
AND (Clv_segment = 'Churn Risk' OR Clv_segment = 'Low Value');

-- Cross selling multiples lines for partners and dependents
SELECT customer_id
FROM existing_users
WHERE multiple_lines = 'No'
AND (dependents = 'Yes' OR Partner = 'Yes')
AND plan_level = 'Basic';


-- Upselling premium for basic users with churn risk. Discount for the first few months could be offered to interest them.
SELECT customer_id
FROM existing_users
WHERE Clv_segment = 'Churn Risk'
AND plan_level = 'Basic';

--Upselling basic to premium for longer lock in period and higher ARPU for high and moderate value users
SELECT customer_id, monthly_bill_amount
FROM existing_users
WHERE plan_level = 'Basic'
AND (Clv_segment = 'High Value' OR Clv_segment = 'Moderate Value')
AND monthly_bill_amount > 150;



















