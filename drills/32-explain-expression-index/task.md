# 32 · EXPLAIN: індекс є, а не береться

**Патерн:** індекс на `email` допомагає запиту `where email = ...`, але **не** запиту `where lower(email) = ...`. Для бази `lower(email)` це інший вираз, у дереві індексу його нема.

```
create index on big_users (email);                 ← уже є в сіді

select * from big_users where lower(email) = 'user777@x.com';
→ Seq Scan  (індекс по email не підходить до lower(email))
```

Ліки: індекс по **тому самому виразу**, що в запиті.

**Завдання:** у `my.sql` створи індекс, після якого запит нижче йде через `Index Scan`, а не `Seq Scan`.

```sql
select * from big_users where lower(email) = 'user777@x.com'
```

**Таблиця:** `big_users`
