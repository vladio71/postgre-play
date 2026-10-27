-- 06-left-join-anti
-- Пиши свій запит тут. Перевірка: npm run check 06

select u.email
from users u 
left join orders o on u.id = o.user_id
where o.id is null