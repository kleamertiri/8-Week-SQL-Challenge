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
### Steps:
 - Using `INNER JOIN` to merge *sales* and *menu* table, as `customer_id` and `price` are from both tables
 - Using `SUM()` and `GROUP BY` to find the `total_price` for each customer

### Answer
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
### Steps:
 - All the information needed is in the table `sales`
 - We use `COUNT()` and `DISTINCT` (a customer may have visited in the same day more than once) to find the number of days the customer visited

### Answer
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
### Steps:
 - Creating a CTE table `(CTE_ranked_sales)` using a window function, `DENSE_RANK` to create a ranking column based on the `customer_id` and ordered by the `order_date`
 - Using `DENSE_RANK`, because a customer might have ordered more than one item in the same day
 - From the table created, we take the columns needed where the `ranked_products` = 1
 
### Answer
| customer_id | product_name |
| ----------- | ------------ |
|      A      |    curry     |
|      A      |    sushi     |
|      B      |    curry     |
|      C      |    ramen     |

- Customer A's first choices are curry and sushi
- Customer B's first choice is curry
- Customer C's first choice is ramen

