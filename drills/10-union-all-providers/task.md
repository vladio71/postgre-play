# 10 · union all: платежі від різних провайдерів

**Патерн:** схожі таблиці з різними назвами колонок зводяться в один список. Колонки зіставляються **за позицією**, назви беруться з першого `select`. Звідки рядок, показує літерал.

```
stripe_payments: id, amount, created_at
paypal_payments: tx_id, sum, created_at     ← інші назви, перейменуй через as
liqpay_payments: id, amount, created_at

provider | id  | amount | created_at
stripe   | 101 |  50    | ...
paypal   |  7  |  20    | ...
```

**Завдання:** один список платежів з усіх трьох таблиць, відсортований за `created_at`, а при однаковій даті за `provider` (за алфавітом).

**Колонки:** `provider, id, amount, created_at`

**Таблиці:** `stripe_payments`, `paypal_payments`, `liqpay_payments`
