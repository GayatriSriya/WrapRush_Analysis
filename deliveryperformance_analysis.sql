-- B.DELIVERY PERFORMANCE ANALYSIS--

-- 1. how many successful orders were delivered by each driver?--
select  driver_id , count(distinct order_id)delivered_orders from driver_order where pickup_time not like 'NULL' group by driver_id;

-- 2. What is the successful delivery percentage for each driver?
  SELECT tdo.driver_id, COUNT(tdo.order_id) / subquery.total_orders AS order_count_ratio FROM temp_driver_order tdo JOIN(SELECT driver_id, COUNT(order_id) AS total_orders FROM driver_order GROUP BY driver_id) AS subquery ON tdo.driver_id = subquery.driver_id
    where tdo.cancellation_status=0;
    
-- 3. What was the average time taken for each driver to arrive at WrapRush HQ to pick up the order?
with k as (select *, row_number()over(partition by order_id order by timetopickup) rnk from 
(select co.order_id, order_date, roll_id, driver_id, pickup_time, time_to_sec(timediff(pickup_time, order_date))/60 as timetopickup  from customer_orders co join driver_order do on co.order_id=do.order_id where pickup_time is not null)sq1)
select driver_id, round(avg(timetopickup),2) avg_pickuptime  from k where rnk=1 group by driver_id;

-- 4. What was the average distance traveled for each customer?
with r as (with k as (select * , replace(distance,'km','' )distance_km from temp_driver_order where cancellation_status=0)
select k.order_id, customer_id, distance_km,driver_id, row_number()over(partition by order_id order by customer_id ) as rnks from k join customer_orders co on k.order_id=co.order_id )
select customer_id,avg(distance_km) as avgdist_percustomer from r where rnks=1 group by customer_id;

-- 5. What was the difference between the longest and shortest order delivery time for all orders?
select max(duration_mins)-min(duration_mins)  from (
SELECT order_id, CAST(REPLACE(REPLACE(REPLACE(duration, 'minutes', ' '), 'mins', ''), 'minute', '') as float) as duration_mins FROM temp_driver_order WHERE cancellation_status = 0)k;

-- 6. What was the average speed for each driver during each delivery?
with z as (select tdo.order_id, customer_id, distance,driver_id,duration,r.roll_id, row_number()over(partition by order_id order by customer_id ) as rnks from (select * from temp_driver_order where cancellation_status=0 ) tdo join temp_customer_orders co on tdo.order_id=co.order_id join rolls r on co.roll_id=r.roll_id) 
select order_id , avg(distance/duration)avg_speed , count(roll_id)as cnt from z group by order_id;
