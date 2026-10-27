-- Другий набір таблиць: інший домен, ті самі патерни.
-- Підключається рядком "-- needs: seed2" в еталоні.

create table employees (
  id int primary key,
  name text not null,
  manager_id int references employees(id),
  dept text not null,            -- exec | eng | sales
  salary int not null,
  hired date not null
);

create table chats (id int primary key, title text not null);

create table messages (
  id int primary key,
  chat_id int not null references chats(id),
  sender_id int not null references employees(id),
  body text not null,
  sent_at timestamp not null
);

create table order_events (
  id int primary key,
  order_id int not null,
  status text not null,          -- created | paid | shipped | delivered | cancelled
  at timestamp not null
);

create table logins (
  user_id int not null references users(id),
  day date not null,
  primary key (user_id, day)
);

create table tickets (
  id int primary key,
  title text not null,
  assignee_id int references users(id)   -- може бути null
);

--            id  name     mgr  dept     salary hired
insert into employees values
  (1, 'Olena', null, 'exec',  9000, '2020-01-10'),
  (2, 'Taras', 1,    'eng',   7000, '2020-03-01'),
  (3, 'Iryna', 1,    'sales', 6000, '2020-04-15'),
  (4, 'Vlad',  2,    'eng',   5000, '2021-02-01'),
  (5, 'Max',   2,    'eng',   5000, '2021-06-20'),
  (6, 'Dasha', 4,    'eng',   3500, '2023-09-01'),
  (7, 'Petro', 3,    'sales', 4000, '2021-01-11'),
  (8, 'Nina',  3,    'sales', 4500, '2022-05-05'),
  (9, 'Yura',  8,    'sales', 3000, '2024-02-01');

insert into chats values (1, 'dev'), (2, 'sales'), (3, 'random');

insert into messages values
  (1, 1, 2, 'standup at 10',        '2024-06-01 09:00'),
  (2, 1, 4, 'deploy done',          '2024-06-01 12:30'),
  (3, 1, 5, 'tests are red',        '2024-06-02 08:15'),
  (4, 1, 4, 'fixed',                '2024-06-02 09:40'),
  (5, 1, 6, 'thanks',               '2024-06-02 09:41'),
  (6, 2, 3, 'q2 numbers?',          '2024-06-01 10:00'),
  (7, 2, 8, 'sending today',        '2024-06-01 10:05');

insert into order_events values
  (1,  1, 'created',   '2024-02-01 10:00'),
  (2,  1, 'paid',      '2024-02-01 10:05'),
  (3,  1, 'shipped',   '2024-02-03 09:00'),
  (4,  2, 'created',   '2024-02-10 11:00'),
  (5,  2, 'paid',      '2024-02-10 11:02'),
  (6,  3, 'created',   '2024-03-01 15:00'),
  (7,  3, 'cancelled', '2024-03-02 09:30'),
  (8,  4, 'created',   '2024-03-05 12:00'),
  (9,  4, 'paid',      '2024-03-05 12:01'),
  (10, 4, 'shipped',   '2024-03-06 08:00'),
  (11, 4, 'delivered', '2024-03-09 17:20');

insert into logins values
  (1, '2024-01-20'), (1, '2024-01-21'), (1, '2024-01-22'), (1, '2024-02-03'), (1, '2024-02-04'),
  (2, '2024-02-20'), (2, '2024-02-21'), (2, '2024-02-22'), (2, '2024-02-23'), (2, '2024-02-24'), (2, '2024-04-01'),
  (3, '2024-03-05'), (3, '2024-04-10'),
  (4, '2024-03-25'), (4, '2024-03-26'),
  (5, '2024-06-02');

insert into tickets values
  (1, 'login broken', 2),
  (2, 'slow page',    null),
  (3, 'typo',         5);
