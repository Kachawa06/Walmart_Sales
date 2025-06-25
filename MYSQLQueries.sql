USE walmart_db;
SHOW tables;
SELECT * FROM walmart;
SELECT count(*) FROM walmart;
SELECT DISTINCT payment_method FROM walmart;

SELECT  payment_method, COUNT(*) 
FROM walmart
GROUP BY payment_method;

SELECT COUNT(DISTINCT Branch) 
FROM walmart;

SELECT MAX(quantity) FROM walmart;

-- Buniess problems 1
-- Find Different Payment method and number of transactions, number of quantity sold

SELECT payment_method, COUNT(*) AS number_of_payments, SUM(quantity) AS total_quantity_sold
FROM walmart
GROUP BY payment_method;

-- Project Question 2
-- Identify the highest-rated category in each branch, display the branch, category AVG Rating
 
select *
FROM
(
	SELECT Branch, category, AVG(rating) AS avg_rating,
	RANK() OVER(PARTITION BY Branch ORDER BY AVG(rating) DESC) AS category_rank
	FROM walmart
	GROUP BY Branch, category
) AS rank_rating
WHERE category_rank = 1;


-- Project Question 3
-- Find out the busiest day of the week for each branch based on transaction volume

SELECT * 
FROM (
	 SELECT Branch, DATE_FORMAT(STR_TO_DATE(date, '%d/%m/%Y'), '%W') AS Day_Name, COUNT(*) AS No_of_Tranction,
     RANK() OVER(PARTITION BY Branch ORDER BY COUNT(*) DESC) AS Ranking
	 FROM walmart
     GROUP BY Branch, DATE_FORMAT(STR_TO_DATE(date, '%d/%m/%Y'), '%W')
	 ) AS rank_data
WHERE Ranking = 1;

-- Problem 3 Solution with CTE
with Rank_data AS (
	 SELECT Branch, DATE_FORMAT(STR_TO_DATE(date, '%d/%m/%Y'), '%W') AS Day_Name, COUNT(*) AS No_of_Tranction,
     RANK() OVER(PARTITION BY Branch ORDER BY COUNT(*) DESC) AS Ranking
	 FROM walmart
     GROUP BY Branch, DATE_FORMAT(STR_TO_DATE(date, '%d/%m/%Y'), '%W')
	 ) 
     SELECT * 
FROM Rank_data
WHERE Ranking = 1;

-- Project Question 4
-- Find out items sold through each payment method
 SELECT payment_method, COUNT(*) AS no_of_payment 
 FROM walmart
 GROUP BY payment_method;
 
-- Project Question 5
-- Find out the average, minimum, and maximum ratings for each category in each city
SELECT city,category, ROUND(AVG(rating),2) AS AVG_rating, MAX(rating) AS Maximum_rating, MIN(rating) AS Minimum_rating
FROM walmart
GROUP BY city, category
ORDER BY city;

-- Project Question 6
-- Find out the total profit for each category, ranked from highest to lowest

SELECT category, SUM(Total) as Total_Revenue, SUM(Total * profit_margin) AS Profit, 
RANK() OVER(ORDER BY SUM(Total * profit_margin) DESC) AS Ranking
FROM walmart
GROUP BY category;

--  Find out the most frequently used payment method in each branch

WITH BRANCH AS (
	SELECT Branch, payment_method, COUNT(*) AS no_transaction,
	Rank() OVER(PARTITION BY Branch ORDER BY COUNT(*) DESC) AS Ranking
	FROM walmart
	GROUP BY Branch, payment_method
    )
    SELECT *
    FROM BRANCH
    WHERE Ranking =1 

