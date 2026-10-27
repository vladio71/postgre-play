-- 03-group-by
-- Пиши свій запит тут. Перевірка: npm run check 03

select user_id, count(*) as orders_count, sum(amount) as total
from orders 
where status = 'paid'
group by user_id