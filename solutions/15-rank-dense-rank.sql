-- ordered: true
-- hint: усі три функції йдуть через over (order by amount desc).
-- hint: row_number потребує tie-break (amount desc, id), інакше порядок однакових сум випадковий.
-- hint: rank після однакових пропускає номер (1,1,3), dense_rank не пропускає (1,1,2).
select id, amount,
       row_number() over (order by amount desc, id) as rn,
       rank()       over (order by amount desc)     as rnk,
       dense_rank() over (order by amount desc)     as drnk
from orders
order by amount desc, id;
