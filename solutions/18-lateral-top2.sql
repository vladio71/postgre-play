-- ordered: false
-- hint: уяви цикл: для кожного u з users виконай підзапит, у якому видно u.id.
-- hint: у підзапиті where orders.user_id = u.id, потім order by amount desc, id і limit 2.
-- hint: cross join lateral відкине users без замовлень, left join lateral (...) o on true лишить їх з null.
select u.email, o.id as order_id, o.amount
from users u
left join lateral (
  select id, amount
  from orders
  where orders.user_id = u.id
  order by amount desc, id
  limit 2
) o on true;
