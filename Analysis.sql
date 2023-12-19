--1. Which product categories generate the most revenue?
SELECT category , SUM(total_amount) AS total_revenew
FROM `etl_bde3_data.tbl_analytics` 
GROUP BY category
ORDER BY total_revenew DESC;

--2. Identify the top 5 products with the highest and lowest sales.

--Highest Sale 
SELECT product_name , SUM(quantity) AS total_sale
FROM `etl_bde3_data.tbl_analytics` 
GROUP BY product_name
ORDER BY total_sale DESC
LIMIT 5;

--Lowest sale
SELECT product_name , SUM(quantity) AS total_sale
FROM `etl_bde3_data.tbl_analytics` 
GROUP BY product_name
ORDER BY total_sale ASC
LIMIT 5;

--3. Which months show peaks in sales? Can you identify any seasonal trends?
SELECT EXTRACT(MONTH FROM order_date) AS order_month,SUM(total_amount) AS monthly_revenew
FROM `etl-bde3.etl_bde3_data.tbl_analytics`
GROUP BY order_month
ORDER BY monthly_revenew DESC;

--4. Calculate customer lifetime value considering their entire purchase history.
SELECT customer_id,first_name,last_name, SUM(total_amount) AS customer_lifetime_value
FROM `etl-bde3.etl_bde3_data.tbl_analytics`
GROUP BY customer_id,first_name,last_name
ORDER BY customer_lifetime_value DESC;

--5. How many orders, on average, does each customer place?

SELECT
  DISTINCT customer_id,
  AVG(COUNT(DISTINCT order_id)) OVER () AS Avg_order
FROM
  `etl-bde3.etl_bde3_data.tbl_analytics`
GROUP BY
  customer_id;