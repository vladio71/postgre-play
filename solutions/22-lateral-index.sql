-- needs: big
-- plan: select u.id, o.id as order_id, o.amount from big_users u cross join lateral (select id, amount from big_orders where user_id = u.id order by amount desc limit 2) o
-- plan-has: Index Scan
-- plan-not: Sort
-- plan-not: Seq Scan on big_orders
-- hint: у підзапиті LATERAL є where user_id = ... і order by amount desc: індекс має покрити обидва.
-- hint: індекс на дві колонки: (user_id, amount desc). База йде по user_id і вже знаходить суми у потрібному порядку, тому Sort не потрібен.
-- hint: одного індексу на (user_id) мало: база знайде рядки користувача, але потім сортуватиме їх на кожну ітерацію.
create index big_orders_user_amount_idx on big_orders (user_id, amount desc);
