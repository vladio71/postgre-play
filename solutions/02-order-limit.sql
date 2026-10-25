-- ordered: true
-- hint: order by приймає кілька колонок через кому: order by amount desc, id.
-- hint: limit ріже вже відсортований результат, тому йде останнім.
select id, amount
from orders
where status = 'paid'
order by amount desc, id
limit 3;
