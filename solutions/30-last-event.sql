-- needs: seed2
-- ordered: false
-- hint: distinct on (order_id) ... order by order_id, at desc.
-- hint: або row_number() over (partition by order_id order by at desc) і where rn = 1 зовні.
select distinct on (order_id) order_id, status
from order_events
order by order_id, at desc;
