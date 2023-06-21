
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



