-- ordered: false
-- hint: умову 'paid' став у on, а не в where: інакше left join перетвориться на звичайний join і втратить users без замовлень.
-- hint: sum по порожній групі дає null, тому coalesce(sum(o.amount), 0).
-- hint: case when ... then ... when ... then ... else ... end as tier.
select u.email,
       case
         when coalesce(sum(o.amount), 0) >= 150 then 'vip'
         when coalesce(sum(o.amount), 0) > 0 then 'regular'
         else 'none'
       end as tier
from users u
left join orders o on o.user_id = u.id and o.status = 'paid'
group by u.id, u.email;
