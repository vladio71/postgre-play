-- needs: race
-- race: 2
-- hold: 2000
-- probe: select count(*) filter (where status = 'run') as running, count(distinct worker) as workers, count(*) filter (where status = 'new') as left_new from jobs
-- hint: update jobs set status = 'run', worker = pg_backend_pid() where id in (select id from jobs where status = 'new' order by id for update skip locked limit 2).
-- hint: for update і skip locked пишуться в підзапиті, перед limit.
update jobs
set status = 'run', worker = pg_backend_pid()
where id in (
  select id
  from jobs
  where status = 'new'
  order by id
  for update skip locked
  limit 2
);
