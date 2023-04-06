---------------------
 ----QUESTIONS-----
---------------------

--1.What is the total amount each customer spent at the restaurant?
SELECT S.customer_id, SUM(M.price) AS total_price
FROM sales AS S
INNER JOIN menu AS M
ON S.product_id = M.product_id
GROUP BY S.customer_id
ORDER BY S.customer_id;

--2.How many days has each customer visited the restaurant?
SELECT customer_id, COUNT(DISTINCT order_date)
FROM sales
GROUP BY customer_id
ORDER BY customer_id;

GO

--3.What was the first item from the menu purchased by each customer?
--First, we create a CTE table with a rank column and from it we get the columns needed.
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

--4.What is the most purchased item on the menu and how many times was it purchased by all customers?
SELECT TOP 1 M.product_name, COUNT(S.customer_id) AS number_of_purchased
FROM sales AS S
JOIN menu AS M
ON S.product_id = M.product_id
GROUP BY M.product_name
ORDER BY number_of_purchased DESC;

--5.Which item was the most popular for each customer?
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

--6.Which item was purchased first by the customer after they became a member?
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

--7.Which item was purchased just before the customer became a member?
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


--8.What is the total items and amount spent for each member before they became a member?
SELECT S.customer_id, COUNT(M1.product_id) AS total_orders, SUM(M1.price) AS total_amount
FROM sales AS S
JOIN menu AS M1
ON S.product_id = M1.product_id
JOIN members AS M2
ON S.customer_id = M2.customer_id
WHERE S.order_date < M2.join_date
GROUP BY S.customer_id;

--9.If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
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

 --10.In the first week after a customer joins the program (including their join date) they earn 2x points on all items, 
 --not just sushi - how many points do customer A and B have at the end of January?
WITH CTE_dates AS (
		SELECT *,
			   DATEADD(day, 6, join_date) AS valid_date,
			   EOMONTH('2021-01-31') AS last_date
		FROM members 
)

SELECT d.customer_id,
		SUM(CASE WHEN product_name = 'sushi' THEN 20 * m.price
			     WHEN s.order_date between d.join_date AND d.valid_date THEN 20 * m.price
			     ELSE 10 * m.price END) AS total_points
FROM CTE_dates as d
JOIN sales AS s 
ON  d.customer_id = s.customer_id
JOIN menu AS m 
ON s.product_id = m.product_id
WHERE s.order_date <= d.last_date
GROUP BY d.customer_id

 
