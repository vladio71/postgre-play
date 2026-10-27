# 29 · filter: кілька умов за один прохід

**Патерн:** `count(*) filter (where ...)` рахує лише рядки, що пройшли умову, в тому ж `group by`. Заміняє три окремі запити або `sum(case when ... then 1 else 0 end)`.

```
eng:   4 людей, senior (salary >= 5000): Taras 7000, Vlad 5000, Max 5000 → 3, avg 5667
sales: 4 людей, senior: Iryna 6000 → 1, avg 6000
exec:  1, senior: Olena → 1, avg 9000
```

**Завдання:** по відділах: скільки людей, скільки з них senior (`salary >= 5000`) і середня зарплата senior, округлена до цілого (`round(avg(...))`).

**Колонки:** `dept, headcount, seniors, senior_avg`

**Таблиця:** `employees`
