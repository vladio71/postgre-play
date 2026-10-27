-- 10-union-all-providers
-- Пиши свій запит тут. Перевірка: npm run check 10

select 'stripe' as provider, id, amount, created_at from stripe_payments
union all
select 'paypal' as provider, tx_id as id, sum as amount, created_at from paypal_payments
union all
select 'liqpay' as provider, id, amount, created_at from liqpay_payments
order by created_at, provider