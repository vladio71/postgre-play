-- 16-window-running-total
-- Пиши свій запит тут. Перевірка: npm run check 16

select 
        day,
        amount,
        sum(amount) over (order by day) as running_total,
        amount - lag(amount) over (order by day) as diff
from daily_sales
order by day