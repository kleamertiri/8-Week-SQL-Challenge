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
