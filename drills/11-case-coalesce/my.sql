-- 11-case-coalesce
-- Пиши свій запит тут. Перевірка: npm run check 11

select  
        u.email,
        case
          when coalesce(sum(o.amount),0) >= 150 then 'vip'
          when coalesce(sum(o.amount),0) > 0 then 'regular'
          else 'none'
        end as tier
from users u
left join orders o on o.user_id = u.id and status = 'paid'
group by u.id, u.email
        