# :oil_drum: 8 Week SQL Challenge
In this repository I will display the solutions for 8 use cases in [8 Week SQL Challenge](https://8weeksqlchallenge.com/) from @DataWithDanny

## :arrow_forward: List of Challenges 
- [Case Study #1 - Danny's Diner](#case-study-1---dannys-diner)
- [Case Study #2 - Pizza Runner](#case-study-2---pizza-runner)
- [Case Study #3 - Foodie-Fi](#case-study-3---foodie-fi)
## Case Study #1 - Danny's Diner
![Capture](https://user-images.githubusercontent.com/105167291/230071791-2aef7e3b-095e-4a11-a628-ad1188a868ad.PNG)
### Problem Statement
Danny wants to use the data to answer a few simple questions about his customers:
- About their visiting patterns
- How much money they’ve spent?
- Which menu items are their favourite?

### Entity Relationship Diagram
![image](https://user-images.githubusercontent.com/105167291/230072841-434767eb-10ad-439d-a9b0-7f9cdae5fefb.png)
### Case Study Questions
<details>
  <summary>Click here</summary>
  
  1. What is the total amount each customer spent at the restaurant?
  2.  How many days has each customer visited the restaurant?
  3.  What was the first item from the menu purchased by each customer?
  4.  What is the most purchased item on the menu and how many times was it purchased by all customers?
  5.  Which item was the most popular for each customer?
  6.  Which item was purchased first by the customer after they became a member?
  7.  Which item was purchased just before the customer became a member?
  8.  What is the total items and amount spent for each member before they became a member?
  9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
  10.  In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer
        A and B have at the end of January?
  ##### Bonus Questions
  1. Join the tables and create a new column to find out if a customer is a member, and during what time the customer became a member.
  2. Danny also requires further information about the ranking of customer products, but he purposely does not need the ranking for non-member purchases so he expects      null ranking values for the records when customers are not yet part of the loyalty program
  
</details>

## Case Study #2 - Pizza Runner
![2](https://user-images.githubusercontent.com/105167291/230781392-def52ec2-35b5-482d-b4bd-1cbd745e6fbc.png)

### Introduction
Danny was scrolling through his Instagram feed when something really caught his eye - “80s Retro Styling and Pizza Is The Future!”

Danny was sold on the idea, but he knew that pizza alone was not going to help him get seed funding to expand his new Pizza Empire - so he had one more genius idea to combine with it - he was going to Uberize it - and so Pizza Runner was launched!

### Entity Relationship Diagram
![Capture](https://user-images.githubusercontent.com/105167291/230781641-e3f42a47-d8de-4e6d-a642-83eddc64882f.PNG)

### Case Study Questions 
This case study has **LOTS** of questions - they are broken up by area of focus including:

<details>
  <summary>A. Pizza Metrics</summary>
  
  1. How many pizzas were ordered?
  2. How many unique customer orders were made?
  3. How many successful orders were delivered by each runner?
  4. How many of each type of pizza was delivered?
  5. How many Vegetarian and Meatlovers were ordered by each customer?
  6. What was the maximum number of pizzas delivered in a single order?
  7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
  8. How many pizzas were delivered that had both exclusions and extras?
  9. What was the total volume of pizzas ordered for each hour of the day?
  10. What was the volume of orders for each day of the week?

</details>

<details>
  <summary>B. Runner and Customer Experience</summary>
  
1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
3. Is there any relationship between the number of pizzas and how long the order takes to prepare?
4. What was the average distance travelled for each customer?
5. What was the difference between the longest and shortest delivery times for all orders?
6. What was the average speed for each runner for each delivery and do you notice any trend for these values?
7. What is the successful delivery percentage for each runner?

</details>

<details>
  <summary>C. Ingredient Optimisation</summary>

1. What are the standard ingredients for each pizza?
2. What was the most commonly added extra?
3. What was the most common exclusion?
4. Generate an order item for each record in the customers_orders table in the format of one of the following:
   - Meat Lovers
   - Meat Lovers - Exclude Beef
   - Meat Lovers - Extra Bacon
   - Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers
5.  Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any relevant ingredients
6.  What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?
</details>

## Case Study #3 - Foodie-Fi

![3](https://github.com/kleamertiri/8-Week-SQL-Challenge/assets/105167291/fdd7d8aa-a663-4e6d-9b0b-6409998084f1)

### Introduction

Subscription based businesses are super popular and Danny realised that there was a large gap in the market - he wanted to create a new streaming service that only had food related content - something like Netflix but with only cooking shows!

Danny finds a few smart friends to launch his new startup Foodie-Fi in 2020 and started selling monthly and annual subscriptions, giving their customers unlimited on-demand access to exclusive food videos from around the world!

Danny created Foodie-Fi with a data driven mindset and wanted to ensure all future investment decisions and new features were decided using data. This case study focuses on using subscription style digital data to answer important business questions.

### Entity Relationship Diagram

![image](https://github.com/kleamertiri/8-Week-SQL-Challenge/assets/105167291/b96ccbeb-49b1-4347-8775-988d220cb08e)

### Case Study Questions

This case study is split into an initial data understanding question before diving straight into data analysis questions before finishing with 1 single extension challenge.

<details>
  <summary>A. Customer Journey</summary>
  Based off the 8 sample customers provided in the sample from the subscriptions table, write a brief description about each customer’s onboarding journey.
  Try to keep it as short as possible - you may also want to run some sort of join to make your explanations a bit easier!
</details>

<details>
  <summary>B. Data Analysis Questions</summary>
  
  1. How many customers has Foodie-Fi ever had?
  2. What is the monthly distribution of trial plan start_date values for our dataset - use the start of the month as the group by value
  3. What plan start_date values occur after the year 2020 for our dataset? Show the breakdown by count of events for each plan_name
  4. What is the customer count and percentage of customers who have churned rounded to 1 decimal place?
  5. How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number?
  6. What is the number and percentage of customer plans after their initial free trial?
  7. What is the customer count and percentage breakdown of all 5 plan_name values at 2020-12-31?
  8. How many customers have upgraded to an annual plan in 2020?
  9. How many days on average does it take for a customer to an annual plan from the day they join Foodie-Fi?
  10. Can you further breakdown this average value into 30 day periods (i.e. 0-30 days, 31-60 days etc)
  11. How many customers downgraded from a pro monthly to a basic monthly plan in 2020?
  
</details>
