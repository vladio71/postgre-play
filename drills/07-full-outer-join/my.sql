-- 07-full-outer-join
-- Пиши свій запит тут. Перевірка: npm run check 07

select 
        coalesce(o.user_id, r.user_id) as user_id,
        coalesce(o.orders_count, 0) as orders_count,
        coalesce(r.reviews_count, 0) as reviews_count
from (select user_id, count(*) as orders_count from orders group by user_id) o
full join (select user_id, count(*) as reviews_count from reviews group by user_id) r 
    on o.user_id = r.user_id
