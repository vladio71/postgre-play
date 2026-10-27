-- 19-recursive-cte
-- Пиши свій запит тут. Перевірка: npm run check 19

with recursive tree as (
    select id , name , 0 as depth
    from categories
    where id = 1 

    union all

    select c.id, c.name, t.depth + 1
    from categories c
    join tree t on t.id = c.parent_id
)
select *
from tree
order by depth, id