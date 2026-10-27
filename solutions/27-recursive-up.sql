-- needs: seed2
-- ordered: true
-- hint: старт: where id = 9.
-- hint: крок: join employees e on e.id = t.manager_id (шукаємо батька, а не дітей).
with recursive up as (
  select id, name, manager_id, 0 as depth
  from employees
  where id = 9
  union all
  select e.id, e.name, e.manager_id, u.depth + 1
  from employees e
  join up u on e.id = u.manager_id
)
select id, name, depth
from up
order by depth;
