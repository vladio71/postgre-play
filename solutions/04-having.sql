-- ordered: false
-- hint: where фільтрує рядки до group by, having фільтрує групи після.
-- hint: в having пиши агрегат повністю: having sum(amount) > 100 (аліас total тут не працює).
select user_id, sum(amount) as total
from orders
where status = 'paid'
group by user_id
having sum(amount) > 100;
