-- ordered: false
-- hint: спочатку згорни кожну таблицю окремо в підзапиті: user_id + count(*).
-- hint: full join лишає user_id з обох боків, де пари нема, там null.
-- hint: coalesce(a, b) бере перше не-null значення: так склеюються два user_id в один і null стає 0.
select coalesce(o.user_id, r.user_id) as user_id,
       coalesce(o.orders_count, 0) as orders_count,
       coalesce(r.reviews_count, 0) as reviews_count
from (select user_id, count(*) as orders_count from orders group by user_id) o
full join (select user_id, count(*) as reviews_count from reviews group by user_id) r
  on o.user_id = r.user_id;
