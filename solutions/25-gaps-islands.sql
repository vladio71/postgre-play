-- needs: seed2
-- ordered: false
-- hint: крок 1: row_number() over (partition by user_id order by day) as rn.
-- hint: крок 2: day - rn (date мінус int дає date): одна серія = одне значення.
-- hint: крок 3: group by user_id, grp → count(*) це довжина серії; крок 4: max(len) на user_id.
with numbered as (
  select user_id, day,
         day - row_number() over (partition by user_id order by day)::int as grp
  from logins
),
streaks as (
  select user_id, grp, count(*) as len
  from numbered
  group by user_id, grp
)
select user_id, max(len) as best_streak
from streaks
group by user_id;
