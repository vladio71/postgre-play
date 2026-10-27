-- needs: seed2
-- ordered: true
-- hint: sum(salary) over (partition by dept order by hired): сума йде заново в кожному dept.
-- hint: lag(salary) over (partition by dept order by hired) дає зарплату попереднього найнятого у тому ж dept.
-- hint: diff = salary - lag(...).
select dept, name, salary,
       sum(salary) over (partition by dept order by hired) as running,
       salary - lag(salary) over (partition by dept order by hired) as diff
from employees
order by dept, hired;
