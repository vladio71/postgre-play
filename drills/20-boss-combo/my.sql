-- 20-boss-combo
-- Пиши свій запит тут. Перевірка: npm run check 20

select country, email, total 
from (
    select country, email , total,
        row_number() over(partition by country order by total desc) as rn
    from (
        select u.country, u.email, sum(o.amount) as total
        from users u
        join orders o on o.user_id = u.id
        where status = 'paid'
        group by u.country, u.email
    ) t
)r
where rn = 1