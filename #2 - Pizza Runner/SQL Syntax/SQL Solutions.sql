-------------------------------------
---Data Cleaning & Transformation----
-------------------------------------


-- runners_orders table(cleaning + transformation + temp table)
DROP TABLE IF EXISTS #TEMP_runners_orders;
SELECT order_id, runner_id, 
CASE 
	WHEN pickup_time IS NULL OR pickup_time = 'null' THEN ''
	ELSE pickup_time
	END AS pickup_time,
CASE
	WHEN distance = 'null' THEN ''
	WHEN distance LIKE '%km' THEN TRIM('km' FROM distance)
	ELSE distance
	END AS distance,
CASE
	WHEN duration LIKE '%mins' THEN TRIM('mins' FROM duration)
	WHEN duration LIKE '%minutes' THEN TRIM('minutes' FROM duration)
	WHEN duration LIKE '%minute' THEN TRIM('minute' FROM duration)
	WHEN duration = 'null' THEN ''
	ELSE duration
	END AS duration,
CASE
	WHEN cancellation IS NULL OR cancellation = 'null' THEN ''
	ELSE cancellation
	END AS cancellation
INTO #TEMP_runners_orders
FROM runner_orders;

--Change the datatype of columns in #TEMP_runners_orders
ALTER TABLE #TEMP_runners_orders
ALTER COLUMN duration INT;

ALTER TABLE #TEMP_runners_orders
ALTER COLUMN distance FLOAT;

ALTER TABLE #TEMP_runners_orders
ALTER COLUMN pickup_time DATETIME;

UPDATE #TEMP_runners_orders
SET pickup_timE = SUBSTRING(pickup_time, 1, 10)






-- customer_orders table(cleaning + transformation + temp table)
DROP TABLE IF EXISTS #TEMP_customer_orders;
SELECT order_id, customer_id, pizza_id, 
CASE
	WHEN exclusions = 'null' OR exclusions IS NULL THEN ''
	ELSE exclusions
	END AS exclusions,
CASE
	WHEN extras = 'null' OR extras IS NULL THEN ''
	ELSE extras
	END AS extras,
order_time
INTO #TEMP_customer_orders
FROM customer_orders;


SELECT * FROM customer_orders
-------------------------
--- A. Pizza Metrics ----
-------------------------

--1.How many pizzas were ordered?
SELECT COUNT(*) AS pizza_ordered
FROM customer_orders;

--2.How many unique customer orders were made?
SELECT COUNT(DISTINCT order_id) AS unique_customers_orders
FROM customer_orders;

--3.How many successful orders were delivered by each runner?
SELECT COUNT(DISTINCT c.order_id) AS orders_delivered, r.runner_id AS runner
FROM #TEMP_customer_orders AS c
INNER JOIN #TEMP_runners_orders AS r
ON c.order_id = r.order_id
WHERE r.cancellation = ''
GROUP BY r.runner_id

--4.How many of each type of pizza was delivered?
--Change of datatype of pizza_name column from text to varchar, to avoid the error
ALTER TABLE pizza_names
ALTER COLUMN pizza_name VARCHAR(70)

SELECT pizza_name, COUNT(c.pizza_id) AS number_of_pizza
FROM #TEMP_customer_orders AS c
INNER JOIN #TEMP_runners_orders AS r
ON c.order_id = r.order_id
INNER JOIN pizza_names AS p
ON c.pizza_id = p.pizza_id
WHERE r.cancellation = ''
GROUP BY pizza_name

--5.How many Vegetarian and Meatlovers were ordered by each customer?
SELECT  c.customer_id, p.pizza_name, COUNT(p.pizza_id) AS pizza_nr
FROM #TEMP_customer_orders AS c
INNER JOIN pizza_names AS p
ON c.pizza_id = p.pizza_id
GROUP BY c.customer_id, p.pizza_name
ORDER BY c.customer_id

--6.What was the maximum number of pizzas delivered in a single order?
WITH pizza_count_cte AS
(
  SELECT 
    c.order_id, 
    COUNT(c.pizza_id) AS pizza_per_order
  FROM #TEMP_customer_orders AS c
  JOIN #TEMP_runners_orders AS r
    ON c.order_id = r.order_id
  WHERE r.cancellation = ''
  GROUP BY c.order_id
)

SELECT 
  MAX(pizza_per_order) AS pizza_count
FROM pizza_count_cte;



--7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
SELECT c.customer_id, 
		SUM(CASE
			WHEN c.exclusions = '' and c.extras = '' THEN 1
			ELSE 0
			END) AS pizza_without_change,
		SUM(CASE
			WHEN c.exclusions != '' or c.extras != '' THEN 1
			ELSE 0
			END) AS pizza_with_change
FROM #TEMP_customer_orders AS c
INNER JOIN #TEMP_runners_orders AS r
ON c.order_id = r.order_id
WHERE r.cancellation = ''
GROUP BY c.customer_id

--8. How many pizzas were delivered that had both exclusions and extras?
SELECT c.order_id, COUNT(pizza_id) AS pizza_with_changes
FROM #TEMP_customer_orders AS c
INNER JOIN #TEMP_runners_orders AS r
ON c.order_id = r.order_id
WHERE r.cancellation = '' and c.exclusions != '' and c.extras != ''
GROUP BY c.order_id


--9. What was the total volume of pizzas ordered for each hour of the day?
SELECT DATEPART(HOUR, order_time) AS hour_of_day, COUNT(order_id) AS nr_pizza_ordered
FROM #TEMP_customer_orders
GROUP BY DATEPART(HOUR, order_time)

--10. What was the volume of orders for each day of the week?
SELECT DATENAME(WEEKDAY, order_time) AS day_of_week, COUNT(order_id) AS volume_of_pizzas
FROM #TEMP_customer_orders
GROUP BY DATENAME(WEEKDAY, order_time)
ORDER BY volume_of_pizzas


------------------------------------------
--- B. Runner and Customer Experience ----
------------------------------------------

--1.How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
SELECT DATEPART(WEEK, DATEADD(DAY,3,registration_date)) - 1 AS week_nr, COUNT(runner_id) AS nr_of_runners
FROM runners
GROUP BY DATEPART(WEEK, DATEADD(DAY,3,registration_date))
ORDER BY week_nr;

--2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
WITH CTE_min AS (
		SELECT c.order_id, r.runner_id, DATEDIFF(minute, c.order_time, r.pickup_time) AS difference_min
		FROM #TEMP_customer_orders AS c
		INNER JOIN #TEMP_runners_orders AS r
		ON c.order_id = r.order_id
		WHERE r.cancellation = ''
		GROUP BY c.order_id,r.runner_id, c.order_time, r.pickup_time
		
)
SELECT  AVG(difference_min) AS avg_difference_min
FROM CTE_min;

--3. Is there any relationship between the number of pizzas and how long the order takes to prepare?
WITH CTE_pizza_prepare AS (
		SELECT c.order_id,COUNT(c.order_id) AS number_of_pizza, DATEDIFF(minute, c.order_time, r.pickup_time) AS difference_min
		FROM #TEMP_customer_orders AS c
		INNER JOIN #TEMP_runners_orders AS r
		ON c.order_id = r.order_id
		WHERE r.cancellation = ''
		GROUP BY c.order_id, c.order_time, r.pickup_time
		
	)

SELECT number_of_pizza, AVG(difference_min) AS avg_time_prepare
FROM CTE_pizza_prepare
GROUP BY number_of_pizza
ORDER BY number_of_pizza

--4. What was the average distance travelled for each customer?
SELECT c.customer_id, ROUND(AVG(distance),2) AS avg_distance
FROM #TEMP_customer_orders AS c
INNER JOIN #TEMP_runners_orders AS r
ON c.order_id = r.order_id
WHERE cancellation = ''
GROUP BY c.customer_id
ORDER BY avg_distance;

--5. What was the difference between the longest and shortest delivery times for all orders?
SELECT MAX(duration) - MIN(duration) AS diff_delivery_time	
FROM #TEMP_runners_orders
WHERE cancellation = '';


--6. What was the average speed for each runner for each delivery and do you notice any trend for these values?
SELECT order_id,runner_id, ROUND(distance / duration, 2) * 60.00 AS average_speed
FROM #TEMP_runners_orders
WHERE cancellation = ''
order by runner_id, average_speed

--7. What is the successful delivery percentage for each runner?
WITH CTE_deliveries AS (
	SELECT runner_id,
	SUM(CASE
		WHEN cancellation = '' THEN 1
		ELSE 0 END) AS successful_deliveries,
	COUNT(order_id) AS total_deliveries
	FROM #TEMP_runners_orders
	GROUP BY runner_id
)

SELECT runner_id, ROUND(successful_deliveries / CAST(total_deliveries AS DECIMAL(1,0)) * 100, 2) AS successful_perc
FROM CTE_deliveries



-----------------------------------
--- C. Ingredient Optimisation ----
-----------------------------------


SELECT * FROM #TEMP_runners_orders
SELECT * FROM #TEMP_customer_orders