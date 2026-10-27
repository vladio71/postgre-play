-- 15-rank-dense-rank
-- Пиши свій запит тут. Перевірка: npm run check 15

select 
        id,
        amount,
        row_number() over (order by amount desc, id) as rn,
        rank() over (order by amount desc) as rnk,
        dense_rank() over (order by amount desc) as drnk
from orders
order by amount desc, id