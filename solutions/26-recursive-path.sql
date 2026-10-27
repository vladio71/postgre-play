-- needs: seed2
-- ordered: true
-- hint: старт: where manager_id is null, depth 0, path = name.
-- hint: крок: join employees e on e.manager_id = t.id; path = t.path || ' > ' || e.name.
-- hint: тип path у старті і в кроці має збігатись: name::text і там, і там.
with recursive tree as (
  select id, name, 0 as depth, name::text as path
  from employees
  where manager_id is null
  union all
  select e.id, e.name, t.depth + 1, t.path || ' > ' || e.name
  from employees e
  join tree t on e.manager_id = t.id
)
select id, name, depth, path
from tree
order by path;
