                                                                     -- C.CUSTOMER ORDER DYNAMICS --

 -- 1.For each customer, how many delivered rolls had atleast 1 change and how many had no change?--
 -- ( steps: Clean the tables without null values creating temp tables)--
DROP TEMPORARY TABLE IF EXISTS temp_customer_orders ;
create temporary table temp_customer_orders as 
select order_id,customer_id,roll_id, 
case when not_include_items is null or not_include_items ='' then '0' else not_include_items end as new_notincluded_items,
case when extra_items_included is null or extra_items_included ='' or extra_items_included ='NaN' then '0' else extra_items_included end as new_extra_items_included, order_date from customer_orders;
DROP TEMPORARY TABLE IF EXISTS temp_driver_order;
create temporary table temp_driver_order as select order_id,driver_id,pickup_time,distance,duration, case when cancellation  in ('Cancellation','Customer Cancellation') then 1 else 0 end as cancellation_status from driver_order;
with l as (select * , case when new_notincluded_items = 0 and new_extra_items_included = 0 then 'no change' else 'change' end chang_no_chng from temp_customer_orders where order_id in (select order_id from temp_driver_order where cancellation_status =0))
select customer_id,  chang_no_chng ,count(order_id) as atleast_one_change from l group by l.customer_id,chang_no_chng;

-- 2.How many delivered rolls have both exclusions and extras?--
with r as (select * , case when new_notincluded_items = 0 and new_extra_items_included = 0 then 'no change' else 'change' end chang_no_chng from temp_customer_orders where order_id in (select order_id from temp_driver_order where cancellation_status =0))
select customer_id, count(order_id) as rolls_with_changes from r where new_notincluded_items !=0 and new_extra_items_included !=0 group by customer_id ;

-- 3.Is there any relationship between the number of rolls and how long the order takes to prepare?--
with n as (select co.order_id, order_date, roll_id, driver_id, pickup_time, time_to_sec(timediff(pickup_time, order_date))/60 as timetopickup  from customer_orders co join driver_order do on co.order_id=do.order_id where pickup_time is not null)
select order_id , count(roll_id) as rollsperorder, round(timetopickup,2) as avgtimeprepare from n group by order_id, timetopickup;
