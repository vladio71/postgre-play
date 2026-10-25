# 22 · lateral + індекс: чому він швидший

**Патерн:** `lateral` виконує підзапит на кожного користувача (1000 разів). Якщо підзапит дорогий, дорого буде 1000 разів. Правильний індекс робить кожну ітерацію майже безкоштовною.

```
для кожного u з big_users (1000 разів):
    where user_id = u.id         ← знайти 100 його замовлень
    order by amount desc         ← відсортувати їх
    limit 2                      ← взяти 2

без індексу:         Seq Scan on big_orders  × 1000  (катастрофа)
індекс (user_id):    знайшов 100 рядків, але Sort на кожній ітерації
індекс (user_id, amount desc):  рядки вже лежать у потрібному порядку, Sort не потрібен
```

Запит (його можна копіювати в `npm run play`, поставивши перед ним `explain`):

```sql
select u.id, o.id as order_id, o.amount
from big_users u
cross join lateral (
  select id, amount
  from big_orders
  where user_id = u.id
  order by amount desc
  limit 2
) o
```

**Завдання:** у `my.sql` створи індекс, після якого в плані немає ні `Seq Scan on big_orders`, ні `Sort`, а є `Index Scan`.

Перевірка: `npm run check 22`

**Таблиці:** `big_users`, `big_orders`
