-- needs: seed2
-- ordered: true
-- hint: наступний місяць: date_trunc('month', created_at) + interval '1 month'.
-- hint: left join logins l on l.user_id = u.id and date_trunc('month', l.day) = <наступний місяць>.
-- hint: size = count(distinct u.id), retained = count(distinct l.user_id): один юзер може логінитись кілька разів.
select date_trunc('month', u.created_at)::date as cohort,
       count(distinct u.id) as size,
       count(distinct l.user_id) as retained
from users u
left join logins l
  on l.user_id = u.id
 and date_trunc('month', l.day) = date_trunc('month', u.created_at) + interval '1 month'
group by 1
order by 1;
