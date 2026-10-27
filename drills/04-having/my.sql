-- 04-having
-- Пиши свій запит тут. Перевірка: npm run check 04
select 
        user_id, 
        sum(amount) as total
from orders 
where status = 'paid'
group by user_id
having sum(amount) > 100
