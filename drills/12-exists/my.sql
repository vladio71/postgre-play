-- 12-exists
-- Пиши свій запит тут. Перевірка: npm run check 12

select email from users u
where exists (select 1 from reviews r where r.user_id = u.id) 
and not exists (select 1 from orders o where o.user_id = u.id)