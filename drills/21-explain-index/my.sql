-- 21-explain-index
-- Пиши свій запит тут. Перевірка: npm run check 21

create index idx_big_orders_user_id on big_orders(user_id);

EXPLAIN  (ANALYZE, BUFFERS)
select * from big_orders where user_id = 777;