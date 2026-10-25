-- ordered: false
-- hint: умов у where може бути кілька, їх з'єднує and.
-- hint: текст у одинарних лапках: status = 'paid'.
select id, user_id, amount
from orders
where status = 'paid' and amount >= 70;
