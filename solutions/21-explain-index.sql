-- needs: big
-- plan: select * from big_orders where user_id = 777
-- plan-has: Index
-- plan-not: Seq Scan
-- hint: Seq Scan значить, що база читає всю таблицю (100 000 рядків) заради 100 потрібних.
-- hint: індекс створюється так: create index назва on таблиця (колонка);
create index big_orders_user_id_idx on big_orders (user_id);
