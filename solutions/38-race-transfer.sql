-- needs: race
-- race: 2
-- probe: select id, balance from accounts order by id
-- hint: with debit as (update accounts set balance = balance - 80 where id = 1 and balance >= 80 returning id) ...
-- hint: ... update accounts set balance = balance + 80 where id = 2 and exists (select 1 from debit).
-- hint: обидва update в одному statement, тому і виконаються, і закомітяться разом.
with debit as (
  update accounts
  set balance = balance - 80
  where id = 1 and balance >= 80
  returning id
)
update accounts
set balance = balance + 80
where id = 2 and exists (select 1 from debit);
