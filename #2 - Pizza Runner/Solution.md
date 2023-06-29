
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
1- How many pizzas were ordered?

```sql
SELECT COUNT(*) AS pizza_ordered
FROM customer_orders;

```
![image](https://github.com/kleamertiri/8-Week-SQL-Challenge/assets/105167291/cb8692b8-ced5-4d86-8558-5506087657ef)

Using the aggregate function `COUNT()` to find the total number of pizzas ordered.

- The total number of pizzas ordered is 14

2- How many unique customer orders were made?
```sql
SELECT COUNT(DISTINCT order_id) AS unique_customers_orders
FROM customer_orders;
```

![image](https://github.com/kleamertiri/8-Week-SQL-Challenge/assets/105167291/25f47fe6-31da-4ca1-966b-a614b710e5c0)

Using the aggregate function `COUNT()` to find the total number and `DISTINCT` to get the unique values.

- The total number of unique orders is 10

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

9- What was the total volume of pizzas ordered for each hour of the day?

*Use of `DATEPART(HOUR, '2019-12-01 12:00:00')` to get the hour of each order*

```sql
SELECT DATEPART(HOUR, order_time) AS hour_of_day, COUNT(order_id) AS nr_pizza_ordered
FROM #TEMP_customer_orders
GROUP BY DATEPART(HOUR, order_time);
```

![image](https://github.com/kleamertiri/8-Week-SQL-Challenge/assets/105167291/5d00246f-f6f2-4316-a461-5cdb38567667)

- The best hours, where the number of pizzas ordering is higher, are at 13:00, 18:00, 21:00 and 23:00

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

