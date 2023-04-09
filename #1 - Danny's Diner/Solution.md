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

