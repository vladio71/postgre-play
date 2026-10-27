-- needs: race
-- race: 3
-- probe: select post_id, count from likes order by post_id
-- hint: insert into likes values (1, 1), (2, 1) on conflict (post_id) do update set ...
-- hint: у do update поточний рядок таблиці це likes.count, а той, що не вставився, це excluded.count.
insert into likes (post_id, count)
values (1, 1), (2, 1)
on conflict (post_id) do update
set count = likes.count + excluded.count;
