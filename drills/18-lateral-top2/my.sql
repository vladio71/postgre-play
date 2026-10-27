-- 18-lateral-top2
-- Пиши свій запит тут. Перевірка: npm run check 18

select email, o.id as order_id, o.amount
from users u 
left join lateral (
    select *
    from orders o 
    where o.user_id = u.id
    order by o.amount desc
    limit 2
) o on true