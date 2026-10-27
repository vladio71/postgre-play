-- needs: big
-- plan: select * from big_users where lower(email) = 'user777@x.com'
-- plan-has: Index Scan
-- plan-not: Seq Scan
-- hint: індекс можна будувати по виразу: create index ... on big_users (lower(email)).
-- hint: вираз в індексі має буквально збігатись із виразом у where.
create index big_users_lower_email_idx on big_users (lower(email));
