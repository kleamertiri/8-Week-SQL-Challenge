# :sushi: #1 Danny's Diner

## Solution

### 1. What is the total amount each customer spent at the restaurant?
```sql
SELECT S.customer_id, SUM(M.price) AS total_price
FROM sales AS S
INNER JOIN menu AS M
ON S.product_id = M.product_id
GROUP BY S.customer_id
ORDER BY S.customer_id;
```
#### Steps:
 - Using `INNER JOIN` to merge *sales* and *menu* table, as `customer_id` and `price` are from both tables
 - Using `SUM()` and `GROUP BY` to find the `total_price` for each customer

#### Answer
| customer_id | total_price |
| ----------- | ----------- |
|      A      |      76     |
|      B      |      74     |
|      C      |      36     |

- Customer A spent in total $76
- Customer B spent in total $74
- Customer C spent in total $36

### 2. How many days has each customer visited the restaurant?
```sql
SELECT customer_id, COUNT(DISTINCT order_date) AS nr_visits
FROM sales
GROUP BY customer_id
ORDER BY customer_id;
```
#### Steps:
 - All the information needed is in the table `sales`
 - We use `COUNT()` and `DISTINCT` (a customer may have visited in the same day more than once) to find the number of days the customer visited

#### Answer
| customer_id |  nr_visits  |
| ----------- | ----------- |
|      A      |       4     |
|      B      |       6     |
|      C      |       2     |

- Customer A visited the restaurant 4 days
- Customer B visited the restaurant 6 days
- Customer C visited the restaurant 2 days

### 3. What was the first item from the menu purchased by each customer?
```sql
WITH CTE_ranked_sales AS(
		SELECT customer_id, order_date, product_name,
		DENSE_RANK() OVER(PARTITION BY S.customer_id
		ORDER BY S.order_date) AS ranked_products
		FROM sales AS S
		JOIN menu AS M
		ON S.product_id = M.product_id
)

SELECT  customer_id, product_name
FROM CTE_ranked_sales
WHERE ranked_products = 1
GROUP BY customer_id, product_name;
```
#### Steps:
 - Creating a CTE table `(CTE_ranked_sales)` using a window function, `DENSE_RANK` to create a ranking column based on the `customer_id` and ordered by the `order_date`
 - Using `DENSE_RANK`, because a customer might have ordered more than one item in the same day
 - From the table created, we take the columns needed where the `ranked_products` = 1
 
#### Answer
| customer_id | product_name |
| ----------- | ------------ |
|      A      |    curry     |
|      A      |    sushi     |
|      B      |    curry     |
|      C      |    ramen     |

- Customer A's first choices are curry and sushi
- Customer B's first choice is curry
- Customer C's first choice is ramen

### 4. What is the most purchased item on the menu and how many times was it purchased by all customers?

```sql
SELECT TOP 1 M.product_name, COUNT(S.customer_id) AS number_of_purchased
FROM sales AS S
JOIN menu AS M
ON S.product_id = M.product_id
GROUP BY M.product_name
ORDER BY number_of_purchased DESC;
```
#### Steps:
 - Using `COUNT()` to find the number of each item purchased and `ORDER BY` in **descending order**
 - `TOP 1` will output the first product

#### Answer
| product_name | number_of_purchased |
| ------------ | ------------------- |
|     ramen    |          8          |

### 5. Which item was the most popular for each customer?

```sql
WITH CTE_nrOrders AS (
	SELECT S.customer_id, M.product_name, COUNT(M.product_id) AS number_of_orders,
	ROW_NUMBER() OVER(partition by S.customer_id ORDER BY COUNT(M.product_id) DESC) AS rn
	FROM sales AS S
	JOIN menu AS M
	ON S.product_id = M.product_id
	GROUP BY S.customer_id, product_name
)

SELECT customer_id, product_name, number_of_orders
FROM CTE_nrOrders
WHERE rn = 1;
```
#### Steps:
- Create a CTE table `CTE_nrOrders`, inside of which we join the `sales` and `menu` table using the `product_key`
- Use of the aggregate function **COUNT()** to get the number of the products purchased by each client
- We use the **Window Function**, `ROW_NUMBER()` to get the ranking of each customer based on the count of orders


#### Answer
| customer_id | product_name | number_of_order|
| ----------- | ------------ | -------------- |
|     A       |    ramen     |       3        |
|     B       |    sushi     |       3        |
|     C       |    ramen     |       3        |


### 6. Which item was purchased first by the customer after they became member?

```sql
WITH CTE_firstOrderMember AS (
	SELECT S.customer_id, M1.product_name, S.order_date,
	ROW_NUMBER() OVER(PARTITION BY S.customer_id ORDER BY S.order_date) AS rn
	FROM sales AS S
	JOIN menu AS M1
	ON S.product_id = M1.product_id
	JOIN members AS M2
	ON S.customer_id = M2.customer_id
	WHERE S.order_date >= M2.join_date
)
SELECT customer_id, product_name
FROM CTE_firstOrderMember
WHERE rn = 1;
```
#### Steps:
- Created a CTE table, `CTE_firstOrderMemeber`, inside of which I have used the **Row_Number()** window function to create a rank of the customers
partitioned by the `customer_id` and ordered by `order_date`
- Joined the tables `sales` and `menu` on `customer_id` column
- Add the condition where the `order_date` >= `join_date` as we need the products purchased after becoming e member.

#### Answer
| customer_id |	product_name |
| ----------- | ------------ |
|      A      |    ramen     |
|      B      |    sushi     |

### 7. Which item was purchased just before the customer became a member?

```sql
WITH CTE_FirstOrderBeforeMember AS (
	SELECT S.customer_id, M1.product_name, S.order_date, 
	DENSE_RANK() OVER(PARTITION BY S.customer_id ORDER BY S.order_date DESC) AS ranking
	FROM sales AS S
	JOIN menu AS M1
	ON S.product_id = M1.product_id
	JOIN members AS M2
	ON S.customer_id = M2.customer_id
	WHERE S.order_date < M2.join_date
)

SELECT customer_id, product_name
FROM CTE_FirstOrderBeforeMember
WHERE ranking = 1
```

#### Answer
| customer_id |	product_name |
| ----------- | ------------ |
|      A      |    sushi     |
|      B      |    sushi     |

### 8. What is the total items and amound spent for each member before they became a member?

```sql
SELECT S.customer_id, COUNT(M1.product_id) AS total_orders, SUM(M1.price) AS total_amount
FROM sales AS S
JOIN menu AS M1
ON S.product_id = M1.product_id
JOIN members AS M2
ON S.customer_id = M2.customer_id
WHERE S.order_date < M2.join_date
GROUP BY S.customer_id;
```

#### Steps:
- Selecting the `customer_id` and using the **COUNT()** function to get the total number of items purchased, 
**SUM()** function to get the total price.
- Joining the tables `sales` and `menu` on `product_id` column, and then with `members` on `customer_id` column
- The condition should be `order_date` < `join_date`

#### Answer:
| customer_id | total_orders | total_amount |
| ----------- | ------------ | ------------ |
|      A      |     2        |      25      |
|      B      |     3        |      40      |


### 9. If each $1 spent equates to 10 points and sushi has sx points multiplier - how many points would each customer have?

```sql
WITH CTE_points AS (
	SELECT S.customer_id, M.product_name, M.price,
	CASE
		WHEN M.product_name = 'sushi' THEN 20 * price
		ELSE 10 * price
	END AS points_collected
	FROM sales AS S
	JOIN menu AS M
	ON S.product_id = M.product_id
)
 SELECT customer_id, SUM(points_collected) AS points
 FROM CTE_points
 GROUP BY customer_id;
 ```
 
 #### Steps:
 - Creating a CTE table, `CTE_points` where we join the tables `sales` and `menu` on `product_id`
 - Inside the CTE table, create a new column using **CASE WHEN** to get te number of points
 - In the end we select the `customer_id` and use the **SUM()** function to get the total number of the points collected

#### Answer:
| customer_id |	points_collected |
| ----------- | ---------------- |
|      A      |    860           |
|      B      |    940           |
|      C      |    360           |

 


