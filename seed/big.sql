-- Велика таблиця для вправ з EXPLAIN та індексами.
-- 1000 користувачів, по 100 замовлень на кожного.
create table big_users (id int primary key, email text not null);
insert into big_users
select g, 'user' || g || '@x.com' from generate_series(1, 1000) g;

create table big_orders (
  id int primary key,
  user_id int not null,
  amount int not null,
  created_at date not null
);
insert into big_orders
select g,
       1 + (g % 1000),
       1 + ((g * 37) % 500),
       date '2024-01-01' + (g % 365)
from generate_series(1, 100000) g;

create index big_users_email_idx on big_users (email);   -- для вправи 32

analyze big_users;
analyze big_orders;
