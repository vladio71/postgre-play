# 33 · EXPLAIN: Index Only Scan

**Патерн:** якщо **всі** колонки, які потрібні запиту, лежать в індексі, база не йде в таблицю взагалі. У плані це `Index Only Scan`.

```
select user_id, amount from big_orders where user_id = 777;

індекс (user_id):          знайшов рядки → пішов у таблицю за amount    Bitmap Heap Scan
індекс (user_id, amount):  і фільтр, і відповідь уже в індексі          Index Only Scan
```

**Завдання:** у `my.sql` створи індекс, після якого план цього запиту містить `Index Only Scan`.

```sql
select user_id, amount from big_orders where user_id = 777
```

**Таблиця:** `big_orders`
