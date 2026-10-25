-- ordered: true
-- hint: with recursive має дві частини через union all: старт (корінь) і крок (діти знайденого).
-- hint: старт: select id, name, 0 as depth from categories where id = 1.
-- hint: крок: join categories c на tree t за c.parent_id = t.id, і depth = t.depth + 1.
with recursive tree as (
  select id, name, 0 as depth
  from categories
  where id = 1
  union all
  select c.id, c.name, t.depth + 1
  from categories c
  join tree t on c.parent_id = t.id
)
select id, name, depth
from tree
order by depth, id;
