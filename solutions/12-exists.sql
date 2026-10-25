-- ordered: false
-- hint: where exists (select 1 from reviews r where r.user_id = u.id): підзапит бачить рядок u зовні.
-- hint: not exists дає протилежне. Два exists з'єднай через and.
select u.email
from users u
where exists (select 1 from reviews r where r.user_id = u.id)
  and not exists (select 1 from orders o where o.user_id = u.id and o.status = 'paid');
