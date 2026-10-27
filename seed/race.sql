-- Таблиці для вправ на одночасні запити (35-38).
-- Підключається рядком "-- needs: race" в еталоні.

create table accounts (id int primary key, balance int not null);
insert into accounts values (1, 100), (2, 50);

create table likes (post_id int primary key, count int not null);
insert into likes values (1, 5);

create table jobs (
  id int primary key,
  status text not null,          -- new | run
  worker int                     -- pg_backend_pid() того, хто взяв
);
insert into jobs values (1, 'new', null), (2, 'new', null), (3, 'new', null), (4, 'new', null);
