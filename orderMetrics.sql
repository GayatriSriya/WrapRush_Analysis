-- A.ORDER  METRICS --

-- 1. How Many Rolls were ordered?--
select count(roll_id)rolls_ordered from customer_orders as total_orders;

-- 2.how many unique customer orders were made?--
SELECT COUNT(DISTINCT customer_id) as unique_orderscheck FROM customer_orders;

-- 3. how many of each type of rolls were delivered?--
with k as (select* , case when cancellation  in ('Cancellation','Customer Cancellation') then 'c' else 'nc'end as order_cancellation_status from driver_order)
 select  co.roll_id, r.roll_name, count(r.roll_id) as total_rolls_delivered from k  join customer_orders co on k.order_id = co.order_id join rolls r on co.roll_id=r.roll_id
 where order_cancellation_status='nc'   group by  co.roll_id, r.roll_name;

-- 4. How many veg and Nonveg rolls were delivered for each customer--
select co.customer_id, count(r.roll_id) as cnt_rolls , r.roll_name from customer_orders co join rolls r on r.roll_id = co.roll_id group by co.customer_id, r.roll_name order by customer_id;

-- 5.what are the maximum no of rolls delivered  in a single order--
with k as (select* , case when cancellation  in ('Cancellation','Customer Cancellation') then 'c' else 'nc'end as order_cancellation_status from driver_order)
 select  k.order_id,customer_id, count(co.roll_id) as total_rolls_delivered from k  join customer_orders co on k.order_id = co.order_id where order_cancellation_status='nc' group by k.order_id,customer_id order by total_rolls_delivered desc limit 1 ;

-- 6.what was the total no of rolls ordered for each hour of the day--
 select hr_bucket, count(order_id )as orderedbyeachhour from (select *,concat (cast(hour(order_date) as char),"-", cast(hour(order_date) +1 as char))hr_bucket from customer_orders)subquery group by hr_bucket; 

-- 7.what was the no of orders for each day of the week--
select count(order_id ) as orders_ondays, dayname(order_date) day_name from customer_orders group by day_name;




