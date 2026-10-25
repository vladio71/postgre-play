-- ordered: false
-- hint: distinct on (user_id) лишає по одному рядку на кожен user_id.
-- hint: який саме рядок лишиться, вирішує order by, а він має починатися з тієї ж колонки: order by user_id, created_at, id.
select distinct on (user_id) user_id, id
from orders
order by user_id, created_at, id;
