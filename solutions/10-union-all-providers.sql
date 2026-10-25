-- ordered: true
-- hint: назви колонок у результаті беруться з ПЕРШОГО select, решта підганяється за позицією.
-- hint: paypal має tx_id і sum: перейменуй через as id, as amount.
-- hint: літерал 'stripe' as provider додає колонку з назвою джерела.
-- hint: order by пиши один раз, в самому кінці: він сортує весь об'єднаний результат.
select 'stripe' as provider, id, amount, created_at from stripe_payments
union all
select 'paypal', tx_id, sum, created_at from paypal_payments
union all
select 'liqpay', id, amount, created_at from liqpay_payments
order by created_at, provider;
