# 07 · full join: JOIN замість UNION (і чому це різне)

**Патерн:** `full join` лишає рядки з обох боків, навіть без пари. Це не `UNION`: тут колонки **поруч**, а не рядки одні під одними.

```
orders (кількість)   reviews (кількість)      full join
user 1 → 3           user 2 → 1               1 | 3 | null
user 2 → 3           user 3 → 2        →      2 | 3 | 1
                                              3 | null | 2

coalesce(x, 0)  → замінює null на 0
coalesce(a, b)  → бере перше не-null (так склеюються два user_id в один)
```

**Завдання:** для кожного user_id, що є в `orders` або в `reviews`, покажи скільки в нього замовлень (усіх) і скільки відгуків. Де нема, там `0`.

**Колонки:** `user_id, orders_count, reviews_count`

**Таблиці:** `orders`, `reviews`
