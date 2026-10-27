-- 09-union-vs-union-all
-- Пиши свій запит тут. Перевірка: npm run check 09

select
(select count(*) from (
    select user_id from orders 
    union
    select user_id from reviews)) as union_rows,
(select count(*) from (
    select user_id from orders
    union all
    select user_id from reviews)) as union_all_rows