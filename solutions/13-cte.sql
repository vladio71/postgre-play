-- ordered: false
-- hint: with name as ( ... ) дає запиту ім'я, як тимчасова таблиця на один запит.
-- hint: CTE можуть іти ланцюжком через кому, наступна бачить попередню.
-- hint: середнє по сумах: select avg(total) from user_totals.
with user_totals as (
  select user_id, sum(amount) as total
  from orders
  where status = 'paid'
  group by user_id
),
avg_total as (
  select avg(total) as value from user_totals
)
select user_id, total
from user_totals, avg_total
where total > avg_total.value;
