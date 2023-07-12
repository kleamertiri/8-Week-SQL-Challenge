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
