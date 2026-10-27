-- 08-union
-- Пиши свій запит тут. Перевірка: npm run check 08
select user_id from orders where status = 'paid'
union 
select user_id from reviews