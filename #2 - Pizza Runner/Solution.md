
# :pizza: Pizza Runner :pizza:
Here will show and explain everything I have done to solve the **Pizza Runner Challenge** in `SQL Server`.

### :arrow_forward: Creating the tables and inserting the data needed.
[Code](https://www.db-fiddle.com/f/7VcQKQwsS3CTkGRFG7vu98/65)

### :arrow_forward: Data Cleaning and Transformation.

<details>
<summary>:one:Data Cleaning & Transformation</summary>
	
After viewing each table, I noticed some data irregularity in the `customer_order` and `runner_orders` tables.

`customer_orders`

**Before:**

![image](https://github.com/kleamertiri/8-Week-SQL-Challenge/assets/105167291/f9799e70-bdef-40b4-b6f7-9ef33af96337)


I noticed in the `exclusions` and `extras` columns that different cells have no values and they are represented in a inconsistent manner. 
Some of the cells are empty, **null** as a string or **NULL** data type. There is needed to represent this cells in the some way, 
because they can cause errors when they will be used in analysing the data. Since the data type of both columns is **VARCHAR**, the emppty values will be presented as empty strings.
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

**After:**

![image](https://github.com/kleamertiri/8-Week-SQL-Challenge/assets/105167291/58412284-873a-4523-95cb-0db3eb7e1674)

</details>

### :arrow_forward: A. Pizza Metrics
