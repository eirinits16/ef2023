select D.*, 
B.users_freq3/A.users as efood_users3freq_perc,
C.users_freq3_breakfast/A.breakfast_users as breakfast_users3freq_perc
from (
-- select all cities that exceed 1000 orders and calculate total and breakfast users
select count(distinct user_id) as users, city,
count(distinct case when cuisine='Breakfast' then user_id end) as breakfast_users
from `main-assessment378120.main_assessment.orders`
group by city
having count(order_id)>1000) A
left join (
-- select users that exceed 3 orders
select count(distinct user_id) as users_freq3, city from (
select user_id,city,count(*) as orders_count from  `main-assessment378120.main_assessment.orders`
group by user_id ,city
having orders_count > 3
)
group by city
) B 
on A.city=B.city
left join (
-- select breakfast users that exceed 3 orders
select count(distinct user_id) as users_freq3_breakfast, city from (
select user_id,city,count(*) as orders_count from  `main-assessment378120.main_assessment.orders`
where cuisine='Breakfast'
group by user_id ,city
having orders_count > 3
)
group by city
) C
on A.city=C.city
inner join (
select 
city,  
sum(amount)/count(order_id) as efood_basket, 
sum(case when cuisine='Breakfast' then amount end)/count(case when cuisine='Breakfast' then order_id end) as breakfast_basket,
count(order_id)/count(distinct user_id) as efood_freq,
count (case when cuisine='Breakfast' then order_id end )/count(distinct case when cuisine='Breakfast' then user_id end)  as breakfast_freq
from `main-assessment378120.main_assessment.orders`
group by city
having count(order_id)>1000
) D
on A.city=D.city
left join (
-- calculate total breakfast orders in order to order final results according to this metric
select count(order_id) orders, city
from `main-assessment378120.main_assessment.orders`
where cuisine='Breakfast'
group by city
) E
on A.city=E.city
order by orders DESC
-- display top 5 cities
limit 5
