-- 13-cte
-- Пиши свій запит тут. Перевірка: npm run check 13

with total_per_user as (
    select o.user_id, sum(o.amount) as total
    from orders o 
    where status = 'paid'
    group by o.user_id
), 
average_total as (
    select 
        avg(t.total) as value
    from total_per_user t
)
select user_id, total
from total_per_user, average_total
where total > average_total.value