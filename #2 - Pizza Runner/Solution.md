
# :pizza: Pizza Runner :pizza:
Here will show and explain everything I have done to solve the **Pizza Runner Challenge** in `SQL Server`.

### :arrow_forward: Creating the tables and inserting the data needed.
[Code](https://www.db-fiddle.com/f/7VcQKQwsS3CTkGRFG7vu98/65)

### :arrow_forward: Data Cleaning and Transformation.

<details>
<summary> :one:Data Cleaning & Transformation</summary>
	
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

### :arrow_forward: A. Pizza Metrics
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
GROUP BY r.runner_id
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
 





