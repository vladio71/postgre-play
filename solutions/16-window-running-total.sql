-- ordered: true
-- hint: sum(amount) over (order by day) дає накопичувальну суму: кожен рядок бачить себе і всі попередні.
-- hint: lag(amount) over (order by day) дає значення з попереднього рядка, для першого це null.
select day, amount,
       sum(amount) over (order by day) as running_total,
       amount - lag(amount) over (order by day) as diff
from daily_sales
order by day;
