--customer_orders 1NF

--new rows
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

--column updates
UPDATE customer_orders
SET exclusions =  SUBSTRING(exclusions, 1, 1 ), extras = SUBSTRING(extras, 1, 1 ) 
WHERE exclusions = '2, 6'
UPDATE customer_orders
SET extras = SUBSTRING(extras, 1, 1 ) 
WHERE extras = '1, 5'


SELECT * FROM customer_orders
order by order_id


