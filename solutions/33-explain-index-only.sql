-- needs: big
-- plan: select user_id, amount from big_orders where user_id = 777
-- plan-has: Index Only Scan
-- hint: усі колонки з select і where мають бути в індексі: (user_id, amount).
-- hint: або (user_id) include (amount): amount лежить в індексі, але не впливає на порядок.
create index big_orders_user_amount_cover_idx on big_orders (user_id, amount);
