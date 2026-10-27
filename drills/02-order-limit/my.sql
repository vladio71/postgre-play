-- 02-order-limit
-- Пиши свій запит тут. Перевірка: npm run check 02

select id, amount
from orders
where status = 'paid'
order by amount desc, id
limit 3