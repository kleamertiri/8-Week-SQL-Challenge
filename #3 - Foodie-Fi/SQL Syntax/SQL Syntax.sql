---------------------------------
 ---- A. Customer Journey ----
---------------------------------
WITH CTE_customer_description AS (
		SELECT customer_id, plan_name, start_date, price
		FROM subscriptions AS s
		INNER JOIN plans AS p
		ON s.plan_id = p.plan_id
		WHERE customer_id IN (1, 2, 11, 13, 15, 16, 18, 19)
)

SELECT *
FROM CTE_customer_description
WHERE customer_id = 19


--------------------------------------
 ---- B. Data Analysis Questions ----
--------------------------------------

--1. How many customers has Foodie-Fi ever had?
SELECT COUNT(DISTINCT customer_id) AS total_customers
FROM subscriptions AS s
INNER JOIN plans AS p
ON s.plan_id = p.plan_id
WHERE plan_name != 'churn'

--2. What is the monthly distribution of trial plan start_date values for our dataset - use the start of the month as the group by value
SELECT 
	MONTH(s.start_date) AS month_nr, 
	DATENAME(MONTH, start_date) AS month, 
	COUNT(p.plan_name) AS trial_total
FROM subscriptions AS s
INNER JOIN plans AS p
ON s.plan_id = p.plan_id
WHERE p.plan_name = 'trial'
GROUP BY MONTH(s.start_date), DATENAME(MONTH, start_date)
ORDER BY trial_total;

--3. What plan start_date values occur after the year 2020 for our dataset? Show the breakdown by count of events for each plan_name
SELECT 
	YEAR(s.start_date) AS year, 
	CONCAT(UPPER(LEFT(p.plan_name, 1)), LOWER(RIGHT(p.plan_name, LEN(p.plan_name) - 1))) AS plan_name , 
	COUNT(customer_id) AS count_plans
FROM subscriptions AS s
INNER JOIN plans AS p
ON s.plan_id = p.plan_id
WHERE YEAR(s.start_date) > 2020
GROUP BY p.plan_name, YEAR(s.start_date)
ORDER BY count_plans;

--4. What is the customer count and percentage of customers who have churned rounded to 1 decimal place?
WITH CTE_churn_percentage AS (
	SELECT
		SUM(CASE WHEN p.plan_name = 'churn' THEN 1 END) AS churn_clients,
		COUNT(DISTINCT customer_id) AS total_number
	FROM subscriptions AS s
	INNER JOIN plans AS p
	ON s.plan_id = p.plan_id
)

SELECT churn_clients, ROUND(churn_clients * 100.0 / total_number, 1) AS churn_percentage
FROM CTE_churn_percentage;

--5. How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number?
WITH CTE_cancel AS (
		SELECT customer_id, 
			   DATEADD(day, 7, start_date) AS after_trial_date
		FROM subscriptions AS s
		INNER JOIN plans AS p
		ON s.plan_id = p.plan_id
		WHERE plan_name = 'trial'
)

SELECT 
	SUM(CASE WHEN plan_name = 'churn' AND start_date = after_trial_date THEN 1 END) AS customer_canceled_after_trial,
	ROUND(SUM(CASE WHEN plan_name = 'churn' AND start_date = after_trial_date THEN 1 END) * 100 / COUNT(DISTINCT s.customer_id), 1) AS churn_rate
FROM CTE_cancel AS c
INNER JOIN subscriptions AS s
ON c.customer_id = s.customer_id
INNER JOIN plans AS p
ON s.plan_id = p.plan_id;

--6. What is the number and percentage of customer plans after their initial free trial?
WITH CTE_rank_plans AS (
SELECT *, 
	  RANK() OVER(PARTITION BY customer_id ORDER BY start_date) AS rank_plan
FROM subscriptions
)

SELECT  plan_name, 
	    COUNT(customer_id) AS customer_per_plan, 
		ROUND(COUNT(customer_id) * CAST(100.0 AS FLOAT) / 
		(SELECT COUNT(DISTINCT customer_id) FROM subscriptions), 1) AS percentage_plan
FROM CTE_rank_plans AS c
INNER JOIN plans AS p
ON c.plan_id = p.plan_id
WHERE rank_plan = 2 
GROUP BY plan_name
ORDER BY customer_per_plan DESC;


--7. What is the customer count and percentage breakdown of all 5 plan_name values at 2020-12-31?
WITH CTE_latest_date AS (
		SELECT *, RANK() OVER(PARTITION BY customer_id ORDER BY start_date DESC) AS rank
		FROM subscriptions
		WHERE start_date <= '2020-12-31'
)

SELECT p.plan_name,
	   COUNT(DISTINCT c.customer_id) AS customer_count,
	   ROUND(COUNT(customer_id) * CAST(100.0 AS FLOAT) / 
		(SELECT COUNT(DISTINCT customer_id) FROM subscriptions), 1) AS percentage_plan
FROM CTE_latest_date AS c
INNER JOIN plans AS p
ON c.plan_id = p.plan_id
WHERE rank = 1
GROUP BY p.plan_name
ORDER BY customer_count DESC


--8. How many customers have upgraded to an annual plan in 2020?
SELECT COUNT(DISTINCT s.customer_id) AS total_customers
FROM subscriptions AS s
INNER JOIN plans AS p
ON s.plan_id = p.plan_id
WHERE YEAR(s.start_date) = '2020' AND p.plan_name = 'pro annual';

--9. How many days on average does it take for a customer to an annual plan from the day they join Foodie-Fi?
WITH CTE_rank AS (
	SELECT customer_id, s.plan_id, p.plan_name, s.start_date,
		  RANK() OVER(PARTITION BY customer_id ORDER BY start_date) AS rank
	FROM subscriptions AS s
	INNER JOIN plans AS p
	ON s.plan_id = p.plan_id 
	WHERE plan_name IN ('trial', 'pro annual')
)

SELECT  
		AVG(DATEDIFF(day, c1.start_date, c2.start_date)) AS avg_difference_days
FROM CTE_rank AS c1
INNER JOIN CTE_rank AS c2
ON c1.customer_id = c2.customer_id
WHERE c1.rank = 1 and c2.rank = 2


--10. Can you further breakdown this average value into 30 day periods (i.e. 0-30 days, 31-60 days etc)
WITH CTE_trial AS (
			  SELECT customer_id, 
				     start_date AS trial_date
			  FROM subscriptions
			  WHERE plan_id = 0

), CTE_annual AS (
			  SELECT customer_id, 
				     start_date AS annual_date
			  FROM subscriptions
			  WHERE plan_id = 3

), CTE_day_difference AS (
			SELECT DATEDIFF(day, t.trial_date, a.annual_date) AS diff_day
			FROM CTE_annual AS a
			LEFT JOIN CTE_trial AS t
			ON t.customer_id = a.customer_id

), CTE_group_day AS (

			SELECT *, FLOOR(diff_day/ 30) AS group_day
			FROM CTE_day_difference
)

SELECT CONCAT((group_day * 30) + 1, '-', (group_day + 1) * 30, ' days') AS days,
	   COUNT(group_day) AS number_days
FROM CTE_group_day
GROUP BY group_day


--11. How many customers downgraded from a pro monthly to a basic monthly plan in 2020?
WITH CTE_downgrade AS (
	SELECT customer_id, s.plan_id, p.plan_name, s.start_date,
			RANK() OVER(PARTITION BY customer_id ORDER BY start_date) AS rank
	FROM subscriptions AS s
	INNER JOIN plans AS p
	ON s.plan_id = p.plan_id 
	WHERE plan_name IN ('basic monthly', 'pro monthly') AND YEAR(start_date) = '2020'
)

SELECT COUNT(customer_id) AS total_customers
FROM CTE_downgrade
WHERE  rank = 1 AND rank = 2

