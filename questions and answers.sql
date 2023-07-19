select * from goldusers_signup
select * from product
select * from sales
select * from users

1. What is the total amount of each customer spent on zingo?

select a.user_id,sum(b.price) as total_amountspent from 
sales a inner join product b on a.product_id=b.product_id
group by a.user_id

2. How many days each customer has visited zingo ?
select user_id, count(distinct created_date) as Days_visited from sales group by user_id

3.What was the first product purchased by each customer?
select * from
(select *,rank() over(partition by user_id order by created_date) rnk from sales) a where rnk=1

4. What is the most purchased item on the menu and how many times was it purchased by all customers?

select top 1 product_id, count(product_id) as purchased_times from sales group by product_id order by count(product_id) desc

select user_id, count(product_id) purchased_times from sales where product_id =
(select top 1 product_id from sales group by product_id order by count(product_id) desc)
group by user_id

5. Which item was the most popular for each customer?

select * from
(select *,rank() over(partition by user_id order by purchased_times desc) rnk from
(select user_id,product_id,count(product_id) purchased_times from sales group by user_id,Product_id)a)b
where rnk=1

6.Which item was purchased by the customer after they become a member?

select * from
(select c.*,rank() over(partition by user_id order by created_date) rnk from
(select a.user_id,a.created_date,a.product_id,b.gold_signup_date from sales a inner join
goldusers_signup b on a.user_id=b.user_id and created_date>=gold_signup_date) c)d where rnk=1;

7.Which item was purchased just before the customer became a member?

select * from
(select c.*,rank() over(partition by user_id order by created_date desc) rnk from
(select a.user_id,a.created_date,a.product_id,b.gold_signup_date from sales a inner join
goldusers_signup b on a.user_id=b.user_id and created_date<=gold_signup_date) c)d where rnk=1;

8. What is the total orders and amount spent by each customer before they become a member?

select user_id,count(created_date) total_orders,sum(price) total_amount_spent from
(select c.*,d.price from
(select a.user_id,a.created_date,a.product_id,b.gold_signup_date from sales inner join
goldusers_signup b on a.user_id=b.user_id and created_date<=gold_signup_date)c inner join product d on c.product_id=d.product_id)e
group by user_id;

9. rnk all the transaction of the customers?
select *,rank() over(partition by user_id order by created_date)rnk from sales;