-- ordered: false
-- hint: два select один під одним, між ними union.
-- hint: колонок і їх типів у обох select має бути однаково.
select user_id from orders where status = 'paid'
union
select user_id from reviews;
