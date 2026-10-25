# 11 · case + coalesce + left join з умовою в on

**Патерн:** `case` це if/else усередині запиту. `coalesce` замінює `null`. Умову на правій таблиці в `left join` став у `on`, а не в `where`, інакше користувачі без замовлень зникнуть.

```
left join orders o on o.user_id = u.id and o.status = 'paid'   ← фільтр у on: cid лишається (з null)
left join orders o on o.user_id = u.id  where o.status='paid'  ← фільтр у where: cid зникає
```

**Завдання:** для кожного користувача визнач рівень за сумою оплачених (`paid`) замовлень:

```
сума >= 150  → 'vip'
сума  > 0    → 'regular'
замовлень нема → 'none'
```

**Колонки:** `email, tier`

**Таблиці:** `users`, `orders`
