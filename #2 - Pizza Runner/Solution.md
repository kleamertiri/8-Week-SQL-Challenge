
# :pizza: Pizza Runner :pizza:
Here will show and explain everything I have done to solve the **Pizza Runner Challenge** in `SQL Server`.

### :arrow_forward: Creating the tables and inserting the data needed.
[Code](https://www.db-fiddle.com/f/7VcQKQwsS3CTkGRFG7vu98/65)

### :arrow_forward: Data Cleaning and Transformation.

<details>
<summary>Data Cleaning & Transformation</summary>
	
After viewing each table, I noticed some data irregularity in the `customer_orders` and `runner_orders` tables.

`customer_orders`

**Before:**

![image](https://github.com/kleamertiri/8-Week-SQL-Challenge/assets/105167291/f9799e70-bdef-40b4-b6f7-9ef33af96337)


I noticed in the `exclusions` and `extras` columns that different cells have no values and they are represented in a inconsistent manner. 
Some of the cells are empty, **null** as a string or **NULL** data type. There is needed to represent this cells in the some way, 
because they can cause errors when they will be used in analysing the data. Since the data type of both columns is **VARCHAR**, the empty values will be presented as empty strings.
```sql
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
```

I created a temporary table (`#TEMP_customer_orders`), where all the empty values in both columns are substituted with empty strings. All the data cleaning and transformation are done
in the temp table, leaving the existing table untouched for reference and going back if is needed.

**After:**

![image](https://github.com/kleamertiri/8-Week-SQL-Challenge/assets/105167291/da5469a2-4f30-437b-829c-e03c6883dedc)



`runner_orders`

**Before:**

![image](https://github.com/kleamertiri/8-Week-SQL-Challenge/assets/105167291/d4513823-9b99-4ac2-8dc6-39abd145146a)

In this table, there are some incosistent data.
- `pickup_time`, the empty values are presented with **null** as a string
- `distance` , in some cells the numbers are associated with *km* while in other cells, there is just numbers
- `duration`, the time is presented with numbers associated with *mins*, *minute*, *minutes* or just the number
- `cancellation`, some cells are blank, **null** string or **NULL** data type

```sql
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
```

I created a temporary table (`#TEMP_runners_orders`) where:
- in the `pickup_time` column, converted the **null** cells to blank cells
- in the `distance` column, removed the *km* and converted the **null** cells to blank cells
- in the `duration` column, removed *mins*, *minute*, *minutes* and converted the **null** cells to blank cells
- in the `cancellation` column, converted the **null** and **NULL** to blank cells

Also, some columns have the wrong data type and I changed it, since it might cause problems later
```sql
ALTER TABLE #TEMP_runners_orders
ALTER COLUMN duration INT;

ALTER TABLE #TEMP_runners_orders
ALTER COLUMN distance FLOAT;
```

For the `pickup_time` column, I removed the time from the datetime data type.
```sql
UPDATE #TEMP_runners_orders
SET pickup_timE = SUBSTRING(pickup_time, 1, 10)
```

**After:**

![image](https://github.com/kleamertiri/8-Week-SQL-Challenge/assets/105167291/ce9c6166-376d-48f1-8846-b395fbc6b3a6)


</details>

### :arrow_forward: Case Study Questions
<details>
<summary>A. Pizza Metrics</summary> 
	<hr/>
1- How many pizzas were ordered?

```sql
SELECT COUNT(*) AS pizza_ordered
FROM customer_orders;

```
![image](https://github.com/kleamertiri/8-Week-SQL-Challenge/assets/105167291/cb8692b8-ced5-4d86-8558-5506087657ef)

Using the aggregate function `COUNT()` to find the total number of pizzas ordered.

- The total number of pizzas ordered is 14
<hr/>
2- How many unique customer orders were made?
```sql
SELECT COUNT(DISTINCT order_id) AS unique_customers_orders
FROM customer_orders;
```

![image](https://github.com/kleamertiri/8-Week-SQL-Challenge/assets/105167291/25f47fe6-31da-4ca1-966b-a614b710e5c0)

Using the aggregate function `COUNT()` to find the total number and `DISTINCT` to get the unique values.

- The total number of unique orders is 10
<hr/>
3- How many successful orders were delivered by each runner?

```sql
SELECT COUNT(DISTINCT c.order_id) AS orders_delivered, r.runner_id AS runner
FROM #TEMP_customer_orders AS c
INNER JOIN #TEMP_runners_orders AS r
ON c.order_id = r.order_id
WHERE r.cancellation = ''
GROUP BY r.runner_id;
```
**Steps:**
- Creating a `JOIN` between `#TEMP_customer_orders` and `#TEMP_runners_order`
- Getting the data where the `cancellation` column has no value(the delivery has been successful)
- Grouping the data by `runner_id`
- Getting the `runner_id` and the sum of the unique orders(using `COUNT()` and `DISTINCT`)

![image](https://github.com/kleamertiri/8-Week-SQL-Challenge/assets/105167291/c47c5e3e-843d-4dc9-8188-b691fc6ea426)

- Runner 1 has delivered successfully 4 orders
- Runner 2 has delivered successfully 3 orders
- Runner 3 has delivered successfully 1 order
<hr/>
4- How many of each type of pizza was delivered?

*Note!* Change the datatype of `pizza_column` from **TEXT** to **VARCHAR()**, to avoid the error

```sql
ALTER TABLE pizza_names
ALTER COLUMN pizza_name VARCHAR(70);
```

```sql
SELECT pizza_name, COUNT(c.pizza_id) AS number_of_pizza
FROM #TEMP_customer_orders AS c
INNER JOIN #TEMP_runners_orders AS r
ON c.order_id = r.order_id
INNER JOIN pizza_names AS p
ON c.pizza_id = p.pizza_id
WHERE r.cancellation = ''
GROUP BY pizza_name;
```

**Steps:**
- Creating a `INNER JOIN` between `#TEMP_customer_orders`, `#TEMP_runners_order` and `pizza_names`
- Getting the data where the `cancellation` column has no value(the delivery has been successful)
- Grouping the data by `pizza_name`
- Getting the `pizza_name` and the number of each *(using `COUNT()`)* that has been delivered successfully.
  

![image](https://github.com/kleamertiri/8-Week-SQL-Challenge/assets/105167291/60799f4a-d086-432e-9e8b-94e0844c777a)

- It has been delivered 9 Meatlovers
- It has been delivered 3 Vegetarian

<hr/>
5- How many Vegetarian and Meatlovers were ordered by each customer?

```sql
SELECT  c.customer_id, p.pizza_name, COUNT(c.pizza_id) AS pizza_nr
FROM #TEMP_customer_orders AS c
INNER JOIN pizza_names AS p
ON c.pizza_id = p.pizza_id
GROUP BY c.customer_id, p.pizza_name
ORDER BY c.customer_id;
```

**Steps:**
- Creating a `INNER JOIN` between `#TEMP_customer_orders` and `pizza_names`
- Grouping the data by `pizza_name` and `customer_id`
- Getting `customer_id`, `pizza_name` and the number of pizzas ordered by each customer for each kind of *(COUNT(pizza_id))*

![image](https://github.com/kleamertiri/8-Week-SQL-Challenge/assets/105167291/f9dc777c-bdd0-454b-a86c-87d6cbcb7fb2)

- Customer 101 ordered 2 Meatlovers and 1 Vegetarian
- Customer 102 ordered 2 Meatlovers and 1 Vegetarian
- Customer 103 ordered 3 Meatlovers and 1 Vegetarian
- Customer 104 ordered 3 Meatlovers
- Customer 105 ordered 1 Vegetarian
<hr/>
6- What was the maximum number of pizzas delivered in a single order?

```sql
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
```

**Steps:**
- Creating a CTE Table, where get the number of pizzas per order
- Using the aggregate function `MAX()` to get the maximum number of pizzas delivered in a single order

![image](https://github.com/kleamertiri/8-Week-SQL-Challenge/assets/105167291/6ee980dd-91f0-431f-bee5-e1fe1d253d8b)

- The maximum number of pizzas delivered in a single order, is 3
<hr/>
7- For each customer, how many delivered pizzas had at least 1 change and how many had no changes?

```sql
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
```

**Steps:**
- Creating a `INNER JOIN` between `#TEMP_customer_orders` and `#TEMP_runners_order` 
- Getting the data where the `cancellation` column has no value(the delivery has been successful)
- Grouping by `customer_id`
- Using `CASE WHEN` statement to create two new columns (`pizza_without_change` and `pizza_with_change`)
- Each of the pizzas has a standart recipe, but clients can change them by adding extra topping (`extras`) or removing ingredient/s (`exclusions`)
- Using the aggregate function `SUM()` to get the number of each of them

![image](https://github.com/kleamertiri/8-Week-SQL-Challenge/assets/105167291/8ba0ebfb-a5cc-4dfa-a721-7876dfa6612c)

- Customers 101 and 102 got 2 and 3 pizzas with their standart recipe
- Customers 103 and 105 got 3 and 1 pizza with changes
- Customer 104 got 1 pizza with the standart recipe and 2 pizzas with changes
<hr/>
8- How many pizzas were delivered that had both exclusions and extras?
```sql
SELECT c.order_id, COUNT(pizza_id) AS pizza_with_changes
FROM #TEMP_customer_orders AS c
INNER JOIN #TEMP_runners_orders AS r
ON c.order_id = r.order_id
WHERE r.cancellation = '' and c.exclusions != '' and c.extras != ''
GROUP BY c.order_id
```

**Steps:**
- Creating a `INNER JOIN` between `#TEMP_runners_order` and `#TEMP_customer_orders`
- Getting the data where the `cancellation` column has no value(the delivery has been successful), `exclusions` and `extras` columns are not blank
- Grouping by the `order_id`
- Getting the number of pizzas with changes in their standart recipe *(COUNT())*

![image](https://github.com/kleamertiri/8-Week-SQL-Challenge/assets/105167291/1aa95098-cdcf-45cd-8655-02e24381f3fa)

- There is just 1 pizza which has extra toppings and has been removed ingredient/s
<hr/>
9- What was the total volume of pizzas ordered for each hour of the day?

*Use of `DATEPART(HOUR, '2019-12-01 12:00:00')` to get the hour of each order*

```sql
SELECT DATEPART(HOUR, order_time) AS hour_of_day, COUNT(order_id) AS nr_pizza_ordered
FROM #TEMP_customer_orders
GROUP BY DATEPART(HOUR, order_time);
```

![image](https://github.com/kleamertiri/8-Week-SQL-Challenge/assets/105167291/5d00246f-f6f2-4316-a461-5cdb38567667)

- The best hours, where the number of pizzas ordering is higher, are at 13:00, 18:00, 21:00 and 23:00
<hr/>
10- What was the volume of orders for each day of the week?

*Use of `DATENAME(WEEKDAY, order_time)` to get the days with their corresponding name in the calendar*

```sql
SELECT DATENAME(WEEKDAY, order_time) AS day_of_week, COUNT(order_id) AS volume_of_pizzas
FROM #TEMP_customer_orders
GROUP BY DATENAME(WEEKDAY, order_time)
ORDER BY volume_of_pizzas;

```
![image](https://github.com/kleamertiri/8-Week-SQL-Challenge/assets/105167291/48965035-e281-4793-a8cf-0c2ab87be5f7)

- The days, where the number of pizzas ordering is higher, are on Wednesday and Saturday

</details>

<details>
<summary>B. Runner and Customer Experience</summary> 
	<hr/>
1- How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01) 
	
**_Note!_ 2021-01-01 is on Friday, so the first complete week starts on the 4th.**


![Capture](https://github.com/kleamertiri/8-Week-SQL-Challenge/assets/105167291/d390af2e-a2f4-4eb6-a90e-f7595b87798f)

```sql
SELECT DATEPART(WEEK, DATEADD(DAY,3,registration_date)) - 1 AS week_nr, COUNT(runner_id) AS nr_of_runners
FROM runners
GROUP BY DATEPART(WEEK, DATEADD(DAY,3,registration_date))
ORDER BY week_nr;
```
**Steps:**
- Since the first full week in January starts at 04-01-2021, we add 3 days to each od the `registration_date` usinf `DATEADD()`
- Getting the week of the year in which each date is, using `DATEPART(WEEK, registration_date)`
- Extracting 1 from the week we get, since `DATEPART()` recognizes the first week of the year from 01-01-2021

![image](https://github.com/kleamertiri/8-Week-SQL-Challenge/assets/105167291/0fb38394-ebb9-4dc9-9413-526cff0caf96)

- In the first week of the year, signed up 2 runners
- In the second and third week of the year, signed up just 1 runner

<hr/>

2- What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?

**_Note_: It is needed to find the difference between the `order_time` and `pickup_time` to find the average time in minutes.**

```sql
WITH CTE_min AS (
		SELECT c.order_id, r.runner_id, DATEDIFF(minute, c.order_time, r.pickup_time) AS difference_min
		FROM #TEMP_customer_orders AS c
		INNER JOIN #TEMP_runners_orders AS r
		ON c.order_id = r.order_id
		WHERE r.cancellation = ''
		GROUP BY c.order_id,r.runner_id, c.order_time, r.pickup_time
		
)
SELECT AVG(difference_min) AS avg_difference_min
FROM CTE_min;
```

**Steps:**
- Joining the tables `#TEMP_customer_orders` and `#TEMP_runners_orders`
- Filtering the data and getting the rows where `cancellation` is blank (the order has been delivered successfully)
- Getting the difference in minutes between `pickup_time` and `order_time`, using `DATEDIFF()`
- Creating a CTE table, from which we get the average time

 ![image](https://github.com/kleamertiri/8-Week-SQL-Challenge/assets/105167291/3d4a41ae-3fab-4390-a958-5164d1d7609f)

- The average time it takes each runner to arrive at the HQ is 16 minutes

<hr/>

3- Is there any relationship between the number of pizzas and how long the order takes to prepare?

**_Note_: Find the number of pizzas per average time in minutes.**

```sql
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
```
![image](https://github.com/kleamertiri/8-Week-SQL-Challenge/assets/105167291/d8d31898-7e3e-4d36-8d7b-e8c5ddb5166d)

- The more pizza ordered, the least amount of time it is needed to prepare each of them

<hr/>

4- What was the average distance travelled for each customer?

```sql
SELECT c.customer_id, ROUND(AVG(distance),2) AS avg_distance
FROM #TEMP_customer_orders AS c
INNER JOIN #TEMP_runners_orders AS r
ON c.order_id = r.order_id
WHERE cancellation = ''
GROUP BY c.customer_id
ORDER BY avg_distance;
```

![image](https://github.com/kleamertiri/8-Week-SQL-Challenge/assets/105167291/5f984101-e923-4ca7-ab2a-2800862dc2a9)

- Customer 104 lives closer (10km) while customer 105 lives the farthest (25km).

<hr/>

5- What was the difference between the longest and shortest delivery times for all orders?

```sql
SELECT MAX(duration) - MIN(duration) AS diff_delivery_time	
FROM #TEMP_runners_orders
WHERE cancellation = '';
```

![image](https://github.com/kleamertiri/8-Week-SQL-Challenge/assets/105167291/6dd8bf00-8a3c-4881-bfbd-a07cf496b105)

- The difference between the longest and shortest delivery is 30 min.

<hr/>
 6- What was the average speed for each runner for each delivery and do you notice any trend for these values?

 **_Note!_ The speed formula is _s = d / t_, where:**
 - **d is the distance (km)**
 - **t is the time (h)**

```sql
SELECT order_id,runner_id, ROUND(distance / duration, 2) * 60.00 AS average_speed
FROM #TEMP_runners_orders
WHERE cancellation = ''
order by runner_id, average_speed;
```

![image](https://github.com/kleamertiri/8-Week-SQL-Challenge/assets/105167291/4274938d-767e-43df-bc2a-a96dc63e2ead)

- The runner with the id 2, has a large difference between the lowest _(34.8km/h)_ and the others _(60km/h, 93.6km/h)_

<hr/>

7- What is the successful delivery percentage for each runner?

**_Note!_ Find the number of the successful deliveries and compare to the total number of deliveries for each runner**

```sql
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
FROM CTE_deliveries;
```

![image](https://github.com/kleamertiri/8-Week-SQL-Challenge/assets/105167291/fccbc808-c579-4e67-af1b-241e4461b3f8)

- Runner 1 has delivered succesfully all his/her orders.


</details>


<details>
<summary>C. Ingredient Optimisation</summary> <hr/>
1- What are the standard ingredients for each pizza?
	
**_Notes:_**
- Change the datatype of the columns _toppings_ (`pizza_recipes` ), _topping_name_ (`pizza_toppings`) and _pizza_name_ (`pizza_names`)
  from `TEXT` to `VARCHAR()` 

```sql
ALTER TABLE pizza_recipes
ALTER COLUMN toppings VARCHAR(max);

ALTER TABLE pizza_toppings
ALTER COLUMN topping_name VARCHAR(MAX);

ALTER TABLE pizza_names
ALTER COLUMN pizza_name VARCHAR(MAX);
```

```sql
DROP TABLE IF EXISTS #TEMP_pizza_recipes;
SELECT r.pizza_id AS pizza_id,
	  ltrim(split_table.value) AS toppings
INTO #TEMP_pizza_recipes
FROM pizza_recipes AS r
outer apply string_split(r.toppings, ',') as split_table

ALTER TABLE #TEMP_pizza_recipes
ALTER COLUMN toppings INT


WITH CTE_pizza_ingredients AS (
	SELECT name.pizza_name, t.topping_name
	FROM  #TEMP_pizza_recipes AS r
	INNER JOIN pizza_names AS name
	ON name.pizza_id = r.pizza_id
	INNER JOIN pizza_toppings AS t
	ON t.topping_id = r.toppings
)

SELECT pizza_name, STRING_AGG(topping_name, ', ') AS toppings
FROM CTE_pizza_ingredients
GROUP BY pizza_name;
```

**Steps:**
- Using the `STRING_SPLIT()` function to split comma-separated list of values which are in the same cell and creating a temporal
  table `#TEMP_pizza_recipes` 
- Changing the `toppings` datatype, from `VARCHAR()` to `INT`, in order to join the temp table with `pizza_names` and `pizza_toppings`
- Using the `STRING_AGG()` function to concatenate the values with the same `pizza_name` in a list of values inside a cell


![image](https://github.com/kleamertiri/8-Week-SQL-Challenge/assets/105167291/5e97897b-9a54-413c-b998-3953494c3d94)


2- What was the most commonly added extra?

```sql
SELECT c.customer_id AS customer_id,
	ltrim(split_table.value) AS extras
INTO #TEMP_pizza_extras
FROM #TEMP_customer_orders as c
outer apply string_split(c.extras, ',') as split_table;


ALTER TABLE #TEMP_pizza_extras
ALTER COLUMN extras INT;

SELECT t.topping_id, t.topping_name, COUNT(*) AS toppings_nr_used 
FROM #TEMP_pizza_extras AS e
INNER JOIN pizza_toppings AS t
ON t.topping_id = e.extras
GROUP BY t.topping_id, t.topping_name;
```

**Steps:**
- Creating a temporal table `#TEMP_pizza_extras`, where we split the list of values in the `extras` column
- Changing the datatype of the `extras` column (`#TEMP_pizza_extras`) from `VARCHAR()` to `INT` in order to join it with the `pizza_toppings` table

![image](https://github.com/kleamertiri/8-Week-SQL-Challenge/assets/105167291/bcd17366-16e9-4228-a6a8-90fda6307503)

- The most used ingredient as an extra is Bacon


3- What was the most common exclusion?

```sql
SELECT c.customer_id AS customer_id,
	ltrim(split_table.value) AS exclusions
INTO #TEMP_pizza_exclusions
FROM #TEMP_customer_orders as c
outer apply string_split(c.exclusions, ',') as split_table;

ALTER TABLE #TEMP_pizza_exclusions
ALTER COLUMN exclusions INT;

SELECT t.topping_id, t.topping_name, COUNT(*) AS toppings_nr_used 
FROM #TEMP_pizza_exclusions AS e
INNER JOIN pizza_toppings AS t
ON t.topping_id = e.exclusions
GROUP BY t.topping_id, t.topping_name
ORDER BY toppings_nr_used DESC; 
```

![image](https://github.com/kleamertiri/8-Week-SQL-Challenge/assets/105167291/a0ab851d-c133-4695-8a2e-132f9debe78d)

- The most common ingredient that was excluded was the Cheese


</details>

