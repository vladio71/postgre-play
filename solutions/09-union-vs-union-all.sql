-- ordered: false
-- hint: union і union all, обидва над user_id з orders та reviews (усі замовлення, будь-який статус).
-- hint: порахуй рядки обгорткою: select count(*) from ( ...union... ) t.
-- hint: два числа в одному рядку: два підзапити в select, кожен з as.
select
  (select count(*) from (
     select user_id from orders
     union
     select user_id from reviews) t) as union_rows,
  (select count(*) from (
     select user_id from orders
     union all
     select user_id from reviews) t) as union_all_rows;
