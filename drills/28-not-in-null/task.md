# 28 · NOT IN і null: пастка

**Патерн:** `x not in (список з null)` **ніколи** не true. Бо `x <> null` це `null`, а `and` з `null` дає `null`, і рядок відкидається.

```
tickets
1  login broken  assignee 2
2  slow page     assignee null   ← оцей null ламає все
3  typo          assignee 5

select ... where id not in (select assignee_id from tickets)
→ id not in (2, null, 5)
→ id <> 2 and id <> null and id <> 5
→ ... and null ...
→ null → рядок не проходить
→ результат порожній, хоча має бути 4 юзери
```

Спочатку виконай цей запит у `npm run play` і переконайся, що він повертає 0 рядків. Потім переписуй.

**Завдання:** користувачі, на яких не призначено жодного тікета. Через `not exists` (або `not in` з відфільтрованим null).

**Колонки:** `id, email`

**Таблиці:** `users`, `tickets`
