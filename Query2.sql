select A.city as City,
A.Top10Users_Orders, 
B.Total_City_Orders, 
round((A.top10users_orders/B.total_city_orders)*100,2) || '%' as Top10Users_Perc 
from (
-- select top 10 users from each city according to their total number of orders
select city, sum(orders) as Top10Users_Orders from (
select user_id, city,orders, row_number() over (partition by city order by orders DESC) as row_num from (
select distinct user_id, city,count(order_id) as orders
from `main-assessment378120.main_assessment.orders`
group by user_id,city
)
)
where row_num <=10
group by city
) A
inner join (
-- calculate total orders for each city
select count(order_id) as Total_City_Orders, city from `main-assessment378120.main_assessment.orders`
group by city
) B 
on A.city=B.city