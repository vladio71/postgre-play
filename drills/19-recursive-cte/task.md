# 19 · with recursive: дерево

**Патерн:** рекурсивний CTE складається з двох частин через `union all`: **старт** (корінь) і **крок** (діти того, що вже знайдено). Крок повторюється, поки є нові діти.

Таблиця `categories` (кожен рядок знає свого батька через `parent_id`):

```
Electronics (1)
├── Phones (2)
│   ├── iPhone (4)
│   └── Android (5)
└── Laptops (3)
    └── Gaming Laptops (6)

Books (7)
└── Fiction (8)
```

Як росте результат:

```
старт:    Electronics                      depth 0
крок 1:   Phones, Laptops                  depth 1
крок 2:   iPhone, Android, Gaming Laptops  depth 2
крок 3:   нових дітей нема → кінець
```

**Завдання:** усе піддерево категорії `Electronics` (`id = 1`) разом з нею самою і глибиною. Порядок за `depth`, потім за `id`.

**Колонки:** `id, name, depth`

**Таблиця:** `categories`
