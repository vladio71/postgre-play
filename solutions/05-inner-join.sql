-- ordered: false
-- hint: join ... on зв'язує колонки двох таблиць: users.id = orders.user_id.
-- hint: аліаси таблиць (users u, orders o) скорочують запис.
select u.email, o.amount
from orders o
join users u on u.id = o.user_id
where o.status = 'paid';
