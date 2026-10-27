-- needs: seed2
-- ordered: false
-- hint: count(*) filter (where salary >= 5000) as seniors.
-- hint: round(avg(salary) filter (where salary >= 5000)) as senior_avg.
select dept,
       count(*) as headcount,
       count(*) filter (where salary >= 5000) as seniors,
       round(avg(salary) filter (where salary >= 5000)) as senior_avg
from employees
group by dept;
