-- 17-distinct-on
-- Пиши свій запит тут. Перевірка: npm run check 17

select distinct on (user_id) user_id, id
from orders
order by user_id, created_at, id