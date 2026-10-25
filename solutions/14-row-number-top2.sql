-- ordered: false
-- hint: row_number() over (partition by user_id order by amount desc, id) нумерує 1, 2, 3 всередині кожного user_id.
-- hint: віконну функцію не можна ставити у where, тому загорни в підзапит і фільтруй rn <= 2 зовні.
select user_id, id, amount
from (
  select user_id, id, amount,
         row_number() over (partition by user_id order by amount desc, id) as rn
  from orders
) t
where rn <= 2;
