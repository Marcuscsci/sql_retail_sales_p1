-- SQL Retail Sales Analysis - P1
CREATE DATABASE sql_project_p2;


-- Create Table
CREATE TABLE retail_sales (
	transactions_id INT PRIMARY KEY,
	sale_date DATE,
	sale_time TIME,
	customer_id INT,
	gender VARCHAR(15),
	age INT,
	category VARCHAR(15),
	quantity INT,
	price_per_unit FLOAT,
	cogs FLOAT,
	total_sale FLOAT
);

-- Verify table is correct
SELECT * FROM retail_sales
LIMIT 10

SELECT 
	COUNT(*)
FROM retail_sales

-- Line 29 - 78 is Data Cleaning
-- Checked all Headers for null values
SELECT * FROM retail_sales
WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	age IS NULL
	OR
	category IS NULL
	OR
	quantity IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;
	

-- Delete null records
DELETE FROM retail_sales
WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	age IS NULL
	OR
	category IS NULL
	OR
	quantity IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;

--Data Exploration

-- How many sales do we have?
SELECT COUNT(*) as total_sale FROM retail_sales


-- How many unique customers?
SELECT COUNT(DISTINCT customer_id) as total_sale FROM retail_sales


-- Number of total categories?
SELECT DISTINCT category FROM retail_sales


-- Data Analysis & Business Key Problems & Answers


-- My Analysis and Findings

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'.
SELECT * FROM retail_sales
WHERE sale_date = '2022-11-05'

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
SELECT * FROM retail_sales
WHERE category = 'Clothing'
	AND
	TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
	AND
	quantity >= 4

-- Q.3 Write the SQL query to calculate the total sales for each category.
SELECT 
	category,
	SUM(total_sale) as net_sale
FROM retail_sales
GROUP BY 1

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'beauty' category
SELECT
	ROUND(AVG(age), 2) as avg_age
FROM retail_sales
WHERE category = 'Beauty'

-- Q.5 Write SQL query to find all transactions where the total_sale is greater than 1000.
SELECT
	transactions_id 
FROM retail_sales
WHERE total_sale > 1000

-- Q.6 Write a SQL query to find the total number of transactions made by each gender in each category.
SELECT 
	category,
	gender,
	count (*) as total_trans
FROM retail_sales
GROUP
	BY
	category,
	gender
ORDER BY 1

-- Q.7 Write a SQL query to calculate the average sale for each month. FInd out best selling nmonth in each year.
WITH avg_sales AS (
    SELECT
        EXTRACT(YEAR FROM sale_date) AS year,
        EXTRACT(MONTH FROM sale_date) AS month,
        AVG(total_sale) AS avg_sale
    FROM retail_sales
    GROUP BY 1, 2
),
ranked_sales AS (
    SELECT 
        year,
        month,
        avg_sale,
        RANK() OVER (PARTITION BY year ORDER BY avg_sale DESC) AS rank
    FROM avg_sales
)
SELECT 
    year,
    month,
    avg_sale
FROM ranked_sales
WHERE rank = 1;

-- Q.8 Write a SQL query to find the top customers based on the highest total sales.
SELECT
	customer_id,
	SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

--Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT
	category,
	COUNT(DISTINCT customer_id) as cnt_unique_cs
FROM retail_sales
GROUP BY category

-- Q.10 Write a SQL query to create each shift and number of orders. (Example Morning <= 12, Afternoon Between 12 and 17, Evening >17)
WITH hourly_sale
as
(
SELECT *,
	CASE
		WHEN EXTRACT(HOUR, FROM sale_time) < 12 THEN 'Morning'
		WHEN EXTRACT(HOUR, FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END as shft
FROM retail_sales
)
SELECT
	shift,
	COUNT(*) as total_orders
	FROM hourly_sale
	GROUP BY shift


-- End of project





	
	


	

