-- 01-select-where
-- Пиши свій запит тут. Перевірка: npm run check 01

select id, user_id, amount
from orders
where status = 'paid' and amount >= 70