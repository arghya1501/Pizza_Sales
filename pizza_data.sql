```create database pizza;
use pizza;

create table orders(
order_id int primary key,
order_date date not null,
order_time time not null);

create table order_details(
order_details_id int primary key,
order_id int not null,
pizza_id text not null,
quantity int not null);


-- Basic:
-- Retrieve the total number of orders placed.
select count(order_id) as total_orders from orders; 

-- Calculate the total revenue generated from pizza sales.
select round( sum(pizzas.price * order_details.quantity),0) as total_revenue_generated 
FROM pizzas 
JOIN order_details
on
pizzas .pizza_id = order_details.pizza_id;

-- Identify the highest-priced pizza.
select pizza_types.name,max(pizzas.price) as highest_priced_pizza
from pizza_types 
join pizzas
on
pizza_types.pizza_type_id = pizzas .pizza_type_id
group by pizza_types.name
order by highest_priced_pizza desc limit 1;

-- Identify the most common pizza size ordered.
select pizzas.size, count(order_details.order_details_id) as most_common_pizza_size_ordered
from pizzas 
join order_details
on
pizzas.pizza_id = order_details .pizza_id
group by pizzas.size
order by most_common_pizza_size_ordered desc limit 1;


-- List the top 5 most ordered pizza types along with their quantities.
select pizza_types.name,sum(order_details.quantity) as most_ordered_pizza_types
from pizza_types 
join pizzas
on pizza_types. pizza_type_id = pizzas.pizza_type_id
join order_details 
on pizzas.pizza_id = order_details.pizza_id
group by pizza_types.name
order by most_ordered_pizza_types desc limit 5;




-- Intermediate:
-- Join the necessary tables to find the total quantity of each pizza category ordered.
select pizza_types.category,sum(order_details.quantity) as count_of_Pizza
from pizza_types 
join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details
on
order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category;


-- Determine the distribution of orders by hour of the day.
select hour(order_time) as Total_time, count(order_id) as total_order from orders
group by hour(order_time);
-- Join relevant tables to find the category-wise distribution of pizzas.
select category,count(name) from pizza_types
group by category;
-- Group the orders by date and calculate the average number of pizzas ordered per day.
select round((quantity),0)from
(select orders.order_date,sum(order_details.quantity) as quantity
from orders 
join order_details
on orders.order_id = order_details . order_id 
group by orders.order_date)as total_quantity;
-- Determine the top 3 most ordered pizza types based on revenue.
select pizza_types.name,round(sum(order_details.quantity * pizzas.price),0) as total_revenue
from order_details 
join pizzas
on order_details.pizza_id = pizzas.pizza_id
join
pizza_types
on pizza_types.pizza_type_id=pizzas.pizza_type_id 
group by pizza_types.name
order by total_revenue desc limit 3;

-- Advanced:
-- Calculate the percentage contribution of each pizza type to total revenue.
select pizza_types.name,round(sum(order_details.quantity * pizzas.price)/
(select round(sum(order_details.quantity * pizzas.price),2)
from order_details 
join pizzas
on order_details.pizza_id = pizzas.pizza_id)*100,2) as percentage_revenue
from pizza_types 
join pizzas
on pizza_types.pizza_type_id=pizzas.pizza_type_id
join order_details 
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.name;

-- Analyze the cumulative revenue generated over time.
select order_date,
sum(total_revenue) over(order by order_date desc) as cum_sum
from
(select orders.order_date,sum(order_details.quantity * pizzas.price) as total_revenue
from order_details 
join pizzas
on order_details.pizza_id = pizzas.pizza_id
join orders
on orders.order_id=order_details.order_id
group by orders.order_date) as total_sales ;
-- Determine the top 3 most ordered pizza types based on revenue for each pizza category.
with table_name1 as(
select  pizza_types.name,pizza_types.category,sum(order_details.quantity * pizzas.price) as total_revenue,
rank() over(partition by pizza_types.category order by sum(order_details.quantity * pizzas.price) desc) as rnk
from order_details 
join pizzas
on order_details.pizza_id = pizzas.pizza_id
join
pizza_types
on pizza_types.pizza_type_id=pizzas.pizza_type_id 
group by pizza_types.name,pizza_types.category)
select name,category,total_revenue,rnk
from table_name1
where rnk <=3;```






