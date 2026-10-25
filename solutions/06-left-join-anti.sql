-- ordered: false
-- hint: left join лишає всіх users, навіть без пари. Там, де пари нема, колонки orders = null.
-- hint: шукай рядки, де o.id is null.
select u.email
from users u
left join orders o on o.user_id = u.id
where o.id is null;
