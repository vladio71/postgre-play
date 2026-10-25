-- ordered: false
-- hint: where відсікає рядки ДО групування, тому paid фільтруй у where.
-- hint: усе в select, що не в агрегаті (count, sum), має бути в group by.
select user_id,
       count(*) as orders_count,
       sum(amount) as total
from orders
where status = 'paid'
group by user_id;
