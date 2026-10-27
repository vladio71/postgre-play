-- needs: seed2
-- ordered: false
-- hint: left join lateral (...) m on true: чат без повідомлень лишається з null.
-- hint: у підзапиті where chat_id = c.id, order by sent_at desc, limit 3.
-- hint: підзапиту потрібен аліас після дужки, інакше m.id нема на що посилатись.
select c.title, m.id as message_id, m.body
from chats c
left join lateral (
  select id, body
  from messages
  where chat_id = c.id
  order by sent_at desc
  limit 3
) m on true;
