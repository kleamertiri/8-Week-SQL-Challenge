# :avocado: Foodie-Fi :avocado:

Here will show and explain everything I have done to solve the **Foodie-Fi Challenge** in `MS SQL Server`

### :arrow_forward: Creating the tables and inserting the data needed

[Code](https://github.com/kleamertiri/8-Week-SQL-Challenge/blob/main/%233%20-%20Foodie-Fi/SQL%20Syntax/Tables.sql)

### :arrow_forward: Case Study Questions
<details>
<summary>A. Customer Journey</summary>
<hr/>
Based off the 8 sample customers provided in the sample from the subscriptions table, write a brief description about each customer’s onboarding journey.


```sql
WITH CTE_customer_description AS (
		SELECT customer_id, plan_name, start_date, price
		FROM subscriptions AS s
		INNER JOIN plans AS p
		ON s.plan_id = p.plan_id
		WHERE customer_id IN (1, 2, 11, 13, 15, 16, 18, 19)
)

SELECT *
FROM CTE_customer_description
-- Selecting each customer one by one
WHERE customer_id = *
```

`Customer #1`


![image](https://github.com/kleamertiri/8-Week-SQL-Challenge/assets/105167291/8c636ba8-0f20-4e3f-8fe6-5c8427041268)

*Customer #1* started the free trial on 01-08-2020 and after it ended (7 days) upgraded to the basic monthly plan which costs $9.90

<hr/>

`Customer #2`

![image](https://github.com/kleamertiri/8-Week-SQL-Challenge/assets/105167291/2920caa2-b29c-4f74-ae23-7db4f2ae8de7)

*Customer #2* strated the free trial on 20-09-2020 and upgraded to the pro annual plan which costs $199.00

<hr/>

`Customer #11`

![image](https://github.com/kleamertiri/8-Week-SQL-Challenge/assets/105167291/11b7f268-2180-4452-8159-8c1207ab3e30)

*Customer #11* strated the free trial on 19-11-2020 and then removed the subsription

<hr/>

`Customer #13`

![image](https://github.com/kleamertiri/8-Week-SQL-Challenge/assets/105167291/1392eb1c-b2d2-405c-98f5-bb213c8ab20e)


*Customer #13* strated the free trial on 15-12-2020. Firstly, upgraded to the basic monthly plan which costs $9.90 on 22-12-2020, and after that
upgraded to the pro monthly plan which costs $19.90 on 29-03-2021

<hr/>

`Customer #15`

![image](https://github.com/kleamertiri/8-Week-SQL-Challenge/assets/105167291/f48f6c08-a670-4e4d-a53a-7f1f5ab7dad9)


*Customer #15* strated the free trial on 17-03-2020. Firstly, upgraded to the pro monthly plan which costs $19.90 on 24-03-2020, and after that
removed the subscription on 29-04-2020

<hr/>

`Customer #16`

![image](https://github.com/kleamertiri/8-Week-SQL-Challenge/assets/105167291/81ff0080-ba0b-4432-9c1f-45baefd9224c)


*Customer #16* strated the free trial on 31-05-2020. Firstly, upgraded to the basic monthly plan which costs $9.90 on 07-06-2020, and after that
upgraded to the pro annual plan which costs $199.00

<hr/>

`Customer #18` <br/>

![image](https://github.com/kleamertiri/8-Week-SQL-Challenge/assets/105167291/0af58c3c-1829-4e9e-b49a-4dd92736c00e)


*Customer #18* strated the free trial on 06-07-2020 and then upgraded to the pro monthly plan on 13-07-2020 which costs $19.90

<hr/>

`Customer #19`

![image](https://github.com/kleamertiri/8-Week-SQL-Challenge/assets/105167291/55d50058-a501-494b-b3c4-6f4c205ecd65)


*Customer #19* strated the free trial on 22-06-2020. Firstly, upgraded to the pro monthly plan which costs $19.90 on 29-06-2020, and after that
upgraded to the pro annual plan which costs $199.00 on 29-08-2020
</details>

<details>
<summary>B. Data Analysis Questions</summary>

1- How many customers has Foodie-Fi ever had?
```sql
SELECT COUNT(DISTINCT customer_id) AS total_customers
FROM subscriptions AS s
INNER JOIN plans AS p
ON s.plan_id = p.plan_id
WHERE plan_name != 'churn';
```

![image](https://github.com/kleamertiri/8-Week-SQL-Challenge/assets/105167291/f00b070c-7924-45a8-9e2c-b40b1862950e)


- There is a total of 1000 customers who has tried and purchased Foodie-Fi

<hr/>

2- What is the monthly distribution of trial plan start_date values for our dataset - use the start of the month as the group by value

```sql
SELECT 
	MONTH(s.start_date) AS month_nr, 
	DATENAME(MONTH, start_date) AS month, 
	COUNT(p.plan_name) AS trial_total
FROM subscriptions AS s
INNER JOIN plans AS p
ON s.plan_id = p.plan_id
WHERE p.plan_name = 'trial'
GROUP BY MONTH(s.start_date), DATENAME(MONTH, start_date)
ORDER BY trial_total;
```

![image](https://github.com/kleamertiri/8-Week-SQL-Challenge/assets/105167291/ee9e8097-99c0-4c34-bde2-c10f7e71056d)


- In **_March_**, there has been the largest number of people who signed up for the trial run, while in **_February_** it has been the lowest.

<hr/>

3- What plan start_date values occur after the year 2020 for our dataset? Show the breakdown by count of events for each plan_name

```sql
SELECT 
	YEAR(s.start_date) AS year, 
	CONCAT(UPPER(LEFT(p.plan_name, 1)), LOWER(RIGHT(p.plan_name, LEN(p.plan_name) - 1))) AS plan_name , 
	COUNT(customer_id) AS count_plans
FROM subscriptions AS s
INNER JOIN plans AS p
ON s.plan_id = p.plan_id
WHERE YEAR(s.start_date) > 2020
GROUP BY p.plan_name, YEAR(s.start_date)
ORDER BY count_plans;
```

![image](https://github.com/kleamertiri/8-Week-SQL-Challenge/assets/105167291/0a655399-2573-4d57-acb1-c66998a5ba3e)

- In 2021, there are not new customers since there is not any `Trial` plan. There is an increase in subscribers for the `Pro monthly` and
  `Pro annual` plan. Also, there is a huge loss of subscribers, since 71 have ended their subscription.

<hr/>

4- What is the customer count and percentage of customers who have churned rounded to 1 decimal place?

```sql
WITH CTE_churn_percentage AS (
	SELECT
		SUM(CASE WHEN p.plan_name = 'churn' THEN 1 END) AS churn_clients,
		COUNT(DISTINCT customer_id) AS total_number
	FROM subscriptions AS s
	INNER JOIN plans AS p
	ON s.plan_id = p.plan_id
)

SELECT churn_clients, ROUND(churn_clients * 100.0 / total_number, 1) AS churn_percentage
FROM CTE_churn_percentage;
```

![image](https://github.com/kleamertiri/8-Week-SQL-Challenge/assets/105167291/96bbd7ab-178a-45b3-924c-156dc7ffdcf1)

- There are 307 clients who have removed their subscription, around 30.7%

<hr/>

5- How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number?

```sql
WITH CTE_cancel AS (
		SELECT customer_id, 
			   DATEADD(day, 7, start_date) AS after_trial_date
		FROM subscriptions AS s
		INNER JOIN plans AS p
		ON s.plan_id = p.plan_id
		WHERE plan_name = 'trial'
)

SELECT 
	SUM(CASE WHEN plan_name = 'churn' AND start_date = after_trial_date THEN 1 END) AS customer_canceled_after_trial,
	ROUND(SUM(CASE WHEN plan_name = 'churn' AND start_date = after_trial_date THEN 1 END) * 100 /
	COUNT(DISTINCT s.customer_id), 1) AS churn_rate
FROM CTE_cancel AS c
INNER JOIN subscriptions AS s
ON c.customer_id = s.customer_id
INNER JOIN plans AS p
ON s.plan_id = p.plan_id;
```

![image](https://github.com/kleamertiri/8-Week-SQL-Challenge/assets/105167291/af3657bd-4bd6-4e30-9dff-5fcfd8685ce3)

- 92 customers canceled immediately after the trial run, about 9%

<hr/>

6- What is the number and percentage of customer plans after their initial free trial?

```sql
WITH CTE_rank_plans AS (
SELECT *, 
	  RANK() OVER(PARTITION BY customer_id ORDER BY start_date) AS rank_plan
FROM subscriptions
)

SELECT  plan_name, 
	    COUNT(customer_id) AS customer_per_plan, 
		ROUND(COUNT(customer_id) * CAST(CAST(100.0 AS DECIMAL(5,2)) AS FLOAT) /
		(SELECT COUNT(DISTINCT customer_id) FROM subscriptions), 1) AS percentage_plan
FROM CTE_rank_plans AS c
INNER JOIN plans AS p
ON c.plan_id = p.plan_id
WHERE rank_plan = 2 
GROUP BY plan_name
ORDER BY customer_per_plan DESC;
```

![image](https://github.com/kleamertiri/8-Week-SQL-Challenge/assets/105167291/26efd592-2185-4a66-a17d-00260a633e7b)

- The most purchased plan is `Basic monthly`, around 54,6% of customers. The last purchased plan is `Pro annual`, about 3.7%

<hr/>



</details>
