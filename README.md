# sql-drills

38 вправ з SQL від `where` до `lateral`, `EXPLAIN` і одночасних запитів. Postgres 16 у Docker.

```
npm install
npm run db                # підняти Postgres (docker compose, порт 5433)
npm run list              # всі вправи, що пройдено
npm run task 05           # завдання + очікуваний результат
# пиши запит у drills/05-inner-join/my.sql
npm run check 05          # перевірка
npm run hint 05           # підказки
npm run solution 05       # еталон (відкривається після ✓)
npm run db:stop           # зупинити базу
```

Кожен `check` скидає схему і заливає сіди наново, тому база завжди чиста. Інший Postgres: `DATABASE_URL=postgres://... npm run check 05`.

Пісочниця з усіма таблицями:

```
npm run schema                          # які є таблиці і колонки
npm run play -- "select * from users"   # один запит
npm run play                            # інтерактивно, запит закінчуй на ;
```

У пісочниці працює все, що вміє Postgres: `explain (analyze, buffers)`, `create index`, `begin` / `commit`.

Порядок вправ:

```
01-04  select, where, order by, group by, having
05-07  join, left join, full join
08-10  union, union all
11-13  case, coalesce, exists, CTE
14-17  row_number, rank, lag, distinct on
18-19  lateral, recursive CTE
20     усе разом
21-22  EXPLAIN і індекси

23-31  ті самі патерни в іншому домені (employees, chats, order_events, logins):
       lateral, window по партиції, gaps & islands, recursive зі шляхом і знизу вгору,
       пастка not in з null, filter, distinct on, когорти
32-34  EXPLAIN: індекс по виразу, Index Only Scan, порядок колонок у складеному індексі
35-38  одночасні запити: перевірка запускає my.sql у 2-3 з'єднаннях паралельно
       (атомарне списання, on conflict, for update skip locked, переказ через with ... returning)
```

`npm run selftest` перевіряє сам репо: усі еталони проходять, порожні заготовки ні.
