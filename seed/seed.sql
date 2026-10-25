create table users (
  id int primary key,
  email text not null,
  country text not null,
  created_at date not null
);

create table orders (
  id int primary key,
  user_id int not null references users(id),
  amount int not null,
  status text not null,          -- paid | pending | cancelled
  created_at date not null
);

create table reviews (
  id int primary key,
  user_id int not null references users(id),
  rating int not null
);

create table stripe_payments (id int primary key, amount int not null, created_at date not null);
create table paypal_payments (tx_id int primary key, sum int not null, created_at date not null);
create table liqpay_payments (id int primary key, amount int not null, created_at date not null);

create table categories (
  id int primary key,
  name text not null,
  parent_id int references categories(id)
);

create table daily_sales (day date primary key, amount int not null);

insert into users values
  (1, 'anna@x.com', 'UA', '2024-01-10'),
  (2, 'bob@x.com',  'PL', '2024-02-15'),
  (3, 'cid@x.com',  'UA', '2024-03-01'),
  (4, 'dina@x.com', 'DE', '2024-03-20'),
  (5, 'egor@x.com', 'PL', '2024-05-05'),
  (6, 'fira@x.com', 'UA', '2024-06-12');

insert into orders values
  (1,  1, 100, 'paid',      '2024-02-01'),
  (2,  1,  50, 'paid',      '2024-02-10'),
  (3,  2,  70, 'paid',      '2024-03-01'),
  (4,  2,  30, 'cancelled', '2024-03-05'),
  (5,  1,  20, 'paid',      '2024-04-01'),
  (6,  4, 200, 'paid',      '2024-04-10'),
  (7,  4, 200, 'paid',      '2024-04-11'),
  (8,  4,  80, 'pending',   '2024-05-01'),
  (9,  5,  45, 'paid',      '2024-05-20'),
  (10, 2,  70, 'paid',      '2024-06-01');

insert into reviews values
  (1, 2, 5),
  (2, 3, 4),
  (3, 3, 2),
  (4, 5, 5);

insert into stripe_payments values (101, 50, '2024-05-01'), (102, 75, '2024-05-03');
insert into paypal_payments values (7, 20, '2024-05-02'), (8, 30, '2024-05-04');
insert into liqpay_payments values (55, 10, '2024-05-02');

insert into categories values
  (1, 'Electronics',    null),
  (2, 'Phones',         1),
  (3, 'Laptops',        1),
  (4, 'iPhone',         2),
  (5, 'Android',        2),
  (6, 'Gaming Laptops', 3),
  (7, 'Books',          null),
  (8, 'Fiction',        7);

insert into daily_sales values
  ('2024-06-01', 100),
  ('2024-06-02', 150),
  ('2024-06-03', 120),
  ('2024-06-04', 200),
  ('2024-06-05', 180),
  ('2024-06-06',  90),
  ('2024-06-07', 210);
