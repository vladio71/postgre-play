-- needs: race
-- race: 2
-- probe: select id, balance from accounts where id = 1
-- hint: умова в where: and balance >= 80. Без неї обидва запити спишуть.
-- hint: update сам бере замок на рядок, другий запит дочекається і побачить уже новий баланс.
update accounts
set balance = balance - 80
where id = 1 and balance >= 80
returning balance;
