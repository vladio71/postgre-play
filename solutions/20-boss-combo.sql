-- ordered: false
-- hint: крок 1 (CTE): paid-сума на користувача разом з country і email: join + group by.
-- hint: крок 2 (CTE): row_number() over (partition by country order by total desc, email) as rn.
-- hint: крок 3: лишити rn = 1.
with totals as (
  select u.country, u.email, sum(o.amount) as total
  from users u
  join orders o on o.user_id = u.id and o.status = 'paid'
  group by u.id, u.country, u.email
),
ranked as (
  select country, email, total,
         row_number() over (partition by country order by total desc, email) as rn
  from totals
)
select country, email, total
from ranked
where rn = 1;
