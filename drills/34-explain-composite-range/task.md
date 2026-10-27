# 34 · EXPLAIN: складений індекс для = і діапазону

**Патерн:** у складеному індексі спершу колонка з `=`, потім колонка з діапазоном чи сортуванням. `(user_id, created_at)` для запиту нижче працює як "знайди юзера, далі йди по датах". `(created_at, user_id)` так не вміє: спершу довелося б пройти всі дати.

```
select * from big_orders
where user_id = 777 and created_at >= '2024-07-01';

(user_id, created_at):   = фіксує user_id, діапазон по created_at усередині   Index Scan
(created_at, user_id):   діапазон першим, user_id уже не звужує               гірше або Seq Scan
```

**Завдання:** у `my.sql` створи індекс, після якого в плані є `Index Scan` і немає `Seq Scan`. Потім у `npm run play` спробуй індекс у зворотному порядку і порівняй плани.

```sql
select * from big_orders where user_id = 777 and created_at >= '2024-07-01'
```

**Таблиця:** `big_orders`
