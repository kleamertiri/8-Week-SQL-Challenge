# :oil_drum: 8 Week SQL Challenge
In this repository I will display the solutions for 8 use cases in [8 Week SQL Challenge](https://8weeksqlchallenge.com/) from @DataWithDanny

## :arrow_forward: List of Challenges
- [Case Study #1 - Danny's Diner](#case-study-1---dannys-diner)
- [Case Study #2 - Pizza Runner](#case-study-2---pizza-runner)
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






