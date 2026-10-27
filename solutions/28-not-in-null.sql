-- needs: seed2
-- ordered: false
-- hint: not exists (select 1 from tickets t where t.assignee_id = u.id): null нікому не дорівнює, тому просто не збігається, і це нормально.
-- hint: або not in (select assignee_id from tickets where assignee_id is not null).
select u.id, u.email
from users u
where not exists (
  select 1 from tickets t where t.assignee_id = u.id
);
