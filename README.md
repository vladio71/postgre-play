# sql-drills

22 вправи з SQL від `where` до `lateral` і `EXPLAIN`. Postgres працює всередині Node (PGlite), Docker не потрібен.

```
npm install
npm run list              # всі вправи, що пройдено
npm run task 05           # завдання + очікуваний результат
# пиши запит у drills/05-inner-join/my.sql
npm run check 05          # перевірка
npm run hint 05           # підказки
npm run solution 05       # еталон (відкривається після ✓)
```

Пісочниця з усіма таблицями:

```
npm run schema                          # які є таблиці і колонки
npm run play -- "select * from users"   # один запит
npm run play                            # інтерактивно, запит закінчуй на ;
```

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
```

`npm run selftest` перевіряє сам репо: усі еталони проходять, порожні заготовки ні.
