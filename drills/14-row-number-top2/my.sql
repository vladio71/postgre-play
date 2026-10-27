-- 14-row-number-top2
-- Пиши свій запит тут. Перевірка: npm run check 14

select user_id, id, amount
from (
    select user_id,id, amount,
    row_number() over (partition by user_id order by amount desc, id) as rn
    from orders
) t
where rn <=2