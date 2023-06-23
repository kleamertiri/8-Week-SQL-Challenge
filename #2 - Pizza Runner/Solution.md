
# :pizza: Pizza Runner :pizza:
Here will show and explain everything I have done to solve the **Pizza Runner Challenge** in `SQL Server`.

### :arrow_forward: Creating the tables and inserting the data needed.
[Code](https://www.db-fiddle.com/f/7VcQKQwsS3CTkGRFG7vu98/65)

### :arrow_forward: Data Normalization, Cleaning and Transformation.
<details>
<summary>:one: Data Normalization</summary>
	
In the `customer_orders` table, inside the `exclusions` and `extras` columns, there are more than one value in specific cells. 

`1NF`
- Every column/attribute need to have a single value.
- Each row should be unique. Either through a single or multiple columns. Not mandatory to have a primary key.

**Before:**

![image](https://github.com/kleamertiri/8-Week-SQL-Challenge/assets/105167291/7070ea96-8500-4293-b824-df382c4688a3)

**Steps:**

- Creating two new rows, where we insert the second value of the cells that have more than one value.
  
  `Example:` The cell where the `order_id = 9` and `extras = 1, 5`
  
```sql
INSERT INTO customer_orders(
	order_id,
	customer_id,
	pizza_id,
	exclusions,
	extras,
	order_time
)
VALUES
	(
	10,
	104,
	1,
	'6',
	'4',
	'2020-01-11 18:34:49'
	)

INSERT INTO customer_orders(
	order_id,
	customer_id,
	pizza_id,
	exclusions,
	extras,
	order_time
)
VALUES
	(
	9,
	103,
	1,
	'4',
	'5',
	'2020-01-10 11:22:59'
	)
 ```

- Updating the cells with more than one value to the first value

  `Example:` The cell where the `order_id = 9` and `extras = 1, 5`
  
```sql
UPDATE customer_orders
SET exclusions =  SUBSTRING(exclusions, 1, 1 ), extras = SUBSTRING(extras, 1, 1 ) 
WHERE exclusions = '2, 6'
UPDATE customer_orders
SET extras = SUBSTRING(extras, 1, 1 ) 
WHERE extras = '1, 5'
```

**After:**

![image](https://github.com/kleamertiri/8-Week-SQL-Challenge/assets/105167291/58fe7dc7-4f11-44d9-b85d-1b95a11a057f)

</details>

<details>
<summary>:two:Data Cleaning & Transformation</summary>
	
After viewing each table, I noticed some data irregularity in the `customer_order` and `runner_orders` tables.

`customer_orders`

**Before:**

![image](https://github.com/kleamertiri/8-Week-SQL-Challenge/assets/105167291/3f5a00ca-635a-4352-8274-b1847d5d4154)

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

![image](https://github.com/kleamertiri/8-Week-SQL-Challenge/assets/105167291/7df27a5b-5b8c-47d9-b6c6-cf3d235b9bc8)


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
