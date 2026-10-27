-- 05-inner-join
-- Пиши свій запит тут. Перевірка: npm run check 05

select u.email, o.amount
from orders o
join users u on o.user_id = u.id
where status = 'paid'
