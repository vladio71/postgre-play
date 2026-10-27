-- needs: big
-- plan: select * from big_orders where user_id = 777 and created_at >= '2024-07-01'
-- plan-has: Index Scan
-- plan-not: Seq Scan
-- hint: спершу колонка з =, потім колонка з діапазоном: (user_id, created_at).
create index big_orders_user_created_idx on big_orders (user_id, created_at);
