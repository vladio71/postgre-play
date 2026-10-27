import pg from 'pg';
import fs from 'node:fs';
import path from 'node:path';
import readline from 'node:readline';
import { fileURLToPath } from 'node:url';

const ROOT = path.dirname(fileURLToPath(import.meta.url));
const DRILLS_DIR = path.join(ROOT, 'drills');
const SOLUTIONS_DIR = path.join(ROOT, 'solutions');
const SEED_DIR = path.join(ROOT, 'seed');
const PROGRESS_FILE = path.join(ROOT, '.progress.json');
const DB_URL = process.env.DATABASE_URL || 'postgres://drills:drills@localhost:5433/drills';

// date і timestamp лишаємо рядками, щоб таймзона не зсувала день
pg.types.setTypeParser(20, (v) => Number(v));    // bigint (count, sum)
pg.types.setTypeParser(1700, (v) => Number(v));  // numeric (avg, round)
pg.types.setTypeParser(1082, (v) => v);
pg.types.setTypeParser(1114, (v) => v);
pg.types.setTypeParser(1184, (v) => v);

const STUB = (name) =>
  `-- ${name}\n-- Пиши свій запит тут. Перевірка: npm run check ${name.slice(0, 2)}\n\n`;

// ---------- файли вправ ----------

function listDrillNames() {
  return fs
    .readdirSync(DRILLS_DIR, { withFileTypes: true })
    .filter((d) => d.isDirectory() && /^\d\d-/.test(d.name))
    .map((d) => d.name)
    .sort();
}

function ensureStubs() {
  for (const name of listDrillNames()) {
    const file = path.join(DRILLS_DIR, name, 'my.sql');
    if (!fs.existsSync(file)) fs.writeFileSync(file, STUB(name));
  }
}

function findDrill(arg) {
  if (!arg) fail('Вкажи номер вправи, наприклад: 05');
  const prefix = String(arg).padStart(2, '0');
  const name = listDrillNames().find((n) => n.startsWith(prefix + '-'));
  if (!name) fail(`Вправи ${prefix} нема. Список: npm run list`);
  return name;
}

// Метадані еталону, рядки виду "-- ключ: значення":
//   ordered: true          порядок рядків важливий
//   needs: big, seed2      які додаткові сіди потрібні (seed.sql завжди)
//   plan: <sql>            вправа на EXPLAIN: перевіряється план цього запиту
//   plan-has / plan-not    слова, які мають / не мають бути в плані після my.sql
//   race: N                my.sql виконується N разів одночасно (N з'єднань)
//   hold: MS               перше з'єднання тримає транзакцію відкритою MS мілісекунд
//                          після my.sql; решта мають встигнути за MS/2, інакше помилка
//   probe: <sql>           після my.sql (і race) виконати цей запит і порівняти з еталоном
//   hint: ...              підказки
function readSolution(name) {
  const text = fs.readFileSync(path.join(SOLUTIONS_DIR, name + '.sql'), 'utf8');
  const meta = {
    ordered: false,
    needs: [],
    plan: null,
    planHas: [],
    planNot: [],
    race: 1,
    hold: 0,
    probe: null,
    hints: [],
  };
  for (const line of text.split('\n')) {
    const m = line.match(/^--\s*(ordered|needs|plan|plan-has|plan-not|race|hold|probe|hint):\s*(.*)$/);
    if (!m) continue;
    const [, key, value] = m;
    const v = value.trim();
    if (key === 'ordered') meta.ordered = v === 'true';
    if (key === 'needs') meta.needs = v.split(',').map((s) => s.trim()).filter(Boolean);
    if (key === 'plan') meta.plan = v;
    if (key === 'plan-has') meta.planHas.push(v);
    if (key === 'plan-not') meta.planNot.push(v);
    if (key === 'race') meta.race = Number(v) || 1;
    if (key === 'hold') meta.hold = Number(v) || 0;
    if (key === 'probe') meta.probe = v;
    if (key === 'hint') meta.hints.push(v);
  }
  return { text, meta };
}

function readProgress() {
  try {
    return JSON.parse(fs.readFileSync(PROGRESS_FILE, 'utf8'));
  } catch {
    return {};
  }
}

function markPassed(name) {
  const progress = readProgress();
  progress[name] = true;
  fs.writeFileSync(PROGRESS_FILE, JSON.stringify(progress, null, 2));
}

function fail(message) {
  console.error(message);
  process.exit(1);
}

// ---------- база ----------

async function connect() {
  const client = new pg.Client({ connectionString: DB_URL });
  try {
    await client.connect();
  } catch (error) {
    fail(
      `Не можу підключитись до Postgres (${DB_URL}).\n` +
        `Запусти базу: npm run db\n` +
        `Деталі: ${error.message}`,
    );
  }
  await client.query('set statement_timeout = 10000');
  return client;
}

// Чиста база на кожен запуск: скидаємо схему і заливаємо сіди.
async function createDb(needs = []) {
  const db = await connect();
  await db.query('drop schema public cascade; create schema public;');
  await db.query(fs.readFileSync(path.join(SEED_DIR, 'seed.sql'), 'utf8'));
  for (const extra of needs) {
    await db.query(fs.readFileSync(path.join(SEED_DIR, extra + '.sql'), 'utf8'));
  }
  return db;
}

// Виконує весь файл, результат = остання команда, яка повернула колонки.
async function runSql(db, sql) {
  try {
    let results = await db.query({ text: sql, rowMode: 'array' });
    if (!Array.isArray(results)) results = [results];
    const withColumns = results.filter((r) => r.fields && r.fields.length > 0);
    const last = withColumns[withColumns.length - 1];
    if (!last) return { ok: true, columns: [], rows: [] };
    return { ok: true, columns: last.fields.map((f) => f.name), rows: last.rows };
  } catch (error) {
    return { ok: false, error: error.message };
  }
}

function normalizeValue(value) {
  if (value === null || value === undefined) return null;
  if (typeof value === 'bigint') return String(Number(value));
  if (typeof value === 'number') return String(value);
  if (value instanceof Date) {
    const iso = value.toISOString();
    return iso.endsWith('T00:00:00.000Z') ? iso.slice(0, 10) : iso;
  }
  if (typeof value === 'string' && /^-?\d+(\.\d+)?$/.test(value)) return String(Number(value));
  if (Array.isArray(value)) return JSON.stringify(value.map(normalizeValue));
  if (typeof value === 'object') return JSON.stringify(value);
  return String(value);
}

function normalizeRows(rows) {
  return rows.map((row) => row.map(normalizeValue));
}

function showTable(columns, rows, limit = 15) {
  if (columns.length === 0) {
    console.log('  (запит не повернув колонок)');
    return;
  }
  const shown = rows.slice(0, limit).map((row) => {
    const obj = {};
    columns.forEach((c, i) => {
      obj[c] = row[i];
    });
    return obj;
  });
  console.table(shown);
  if (rows.length > limit) console.log(`  ... ще ${rows.length - limit} рядків`);
}

// ---------- перевірка ----------

function compareResults(expected, got, ordered) {
  const exp = normalizeRows(expected.rows).map((r) => JSON.stringify(r));
  const act = normalizeRows(got.rows).map((r) => JSON.stringify(r));
  if (!ordered) {
    exp.sort();
    act.sort();
  }
  const problems = [];
  if (expected.columns.length !== got.columns.length) {
    problems.push(`Колонок має бути ${expected.columns.length}, а в тебе ${got.columns.length}.`);
  }
  if (exp.length !== act.length) {
    problems.push(`Рядків має бути ${exp.length}, а в тебе ${act.length}.`);
  }
  const missing = exp.filter((r) => !act.includes(r));
  const extra = act.filter((r) => !exp.includes(r));
  if (missing.length) problems.push('Немає в тебе: ' + missing.slice(0, 5).join('  '));
  if (extra.length) problems.push('Зайві в тебе: ' + extra.slice(0, 5).join('  '));
  if (problems.length === 0 && ordered && JSON.stringify(exp) !== JSON.stringify(act)) {
    problems.push('Рядки ті самі, але порядок інший. Перевір order by.');
  }
  const namesDiffer =
    expected.columns.length === got.columns.length &&
    expected.columns.join() !== got.columns.join();
  return { problems, namesDiffer };
}

async function explain(db, query) {
  const result = await db.query('explain ' + query);
  return result.rows.map((r) => r['QUERY PLAN']).join('\n');
}

// Виконує sql у N окремих з'єднаннях одночасно. Повертає помилки (якщо були).
// З hold: з'єднання 0 робить begin; sql; чекає hold мс; commit. Так інші реально
// натикаються на його замки, а не на вже закомічені рядки.
async function runRace(sql, n, hold = 0) {
  const clients = [];
  for (let i = 0; i < n; i += 1) clients.push(await connect());
  const tasks = clients.map(async (c, i) => {
    if (hold && i === 0) {
      const r = await runSql(c, 'begin;\n' + sql);
      await new Promise((resolve) => setTimeout(resolve, hold));
      await runSql(c, r.ok ? 'commit' : 'rollback');
      return r;
    }
    if (hold) await c.query(`set statement_timeout = ${Math.floor(hold / 2)}`);
    return runSql(c, sql);
  });
  const results = await Promise.all(tasks);
  await Promise.all(clients.map((c) => c.end()));
  return results.filter((r) => !r.ok).map((r) => r.error);
}

// Вправа зі станом: виконати my.sql (можливо паралельно), потім probe, порівняти з еталоном.
async function evaluateState(name, mySql, solutionSql, meta) {
  const dbExp = await createDb(meta.needs);
  const errExp = await runRace(solutionSql, meta.race, meta.hold);
  if (errExp.length) fail(`Еталон ${name} зламаний: ${errExp[0]}`);
  const expected = await runSql(dbExp, meta.probe);
  await dbExp.end();

  const dbMine = await createDb(meta.needs);
  const errMine = await runRace(mySql, meta.race, meta.hold);
  const mine = await runSql(dbMine, meta.probe);
  await dbMine.end();

  const report = [];
  if (errMine.length) report.push('Помилки під час виконання: ' + errMine.join(' | '));
  const { problems } = compareResults(expected, mine, true);
  if (problems.length === 0 && errMine.length === 0) return { passed: true, report };
  report.push(`Стан бази після ${meta.race > 1 ? meta.race + ' одночасних запусків' : 'твого запиту'}:`);
  report.push({ table: mine });
  report.push('Очікується:');
  report.push({ table: expected });
  report.push(...problems);
  return { passed: false, report };
}

// Повертає { passed, report: [рядки тексту] }
async function evaluate(name, mySql) {
  const { text: solutionSql, meta } = readSolution(name);

  if (meta.probe) return evaluateState(name, mySql, solutionSql, meta);

  const db = await createDb(meta.needs);
  const report = [];

  if (meta.plan) {
    const before = await explain(db, meta.plan);
    const run = await runSql(db, mySql);
    if (!run.ok) {
      await db.end();
      return { passed: false, report: ['Помилка SQL: ' + run.error] };
    }
    await db.query('vacuum analyze');
    const after = await explain(db, meta.plan);
    await db.end();
    const problems = [];
    for (const word of meta.planHas) {
      if (!after.includes(word)) problems.push(`У плані має бути "${word}".`);
    }
    for (const word of meta.planNot) {
      if (after.includes(word)) problems.push(`У плані не має бути "${word}".`);
    }
    report.push('Запит:', '  ' + meta.plan, '', 'План ДО твоїх змін:', indent(before), '', 'План ПІСЛЯ:', indent(after));
    if (problems.length) report.push('', ...problems);
    return { passed: problems.length === 0, report };
  }

  const expected = await runSql(db, solutionSql);
  await db.end();
  if (!expected.ok) fail(`Еталон ${name} зламаний: ${expected.error}`);
  const dbMine = await createDb(meta.needs);
  const mine = await runSql(dbMine, mySql);
  await dbMine.end();
  if (!mine.ok) return { passed: false, report: ['Помилка SQL: ' + mine.error] };
  if (mine.columns.length === 0) {
    return { passed: false, report: ['Запит нічого не повернув. Напиши select у my.sql.'] };
  }
  const { problems, namesDiffer } = compareResults(expected, mine, meta.ordered);
  if (problems.length === 0) {
    if (namesDiffer) {
      report.push(`Назви колонок інші (очікувались: ${expected.columns.join(', ')}), але дані вірні.`);
    }
    return { passed: true, report };
  }
  report.push('Твій результат:');
  report.push({ table: mine });
  report.push('Очікується:');
  report.push({ table: expected });
  report.push(...problems);
  return { passed: false, report };
}

function indent(text) {
  return text
    .split('\n')
    .map((l) => '  ' + l)
    .join('\n');
}

function printReport(report) {
  for (const item of report) {
    if (typeof item === 'string') console.log(item);
    else showTable(item.table.columns, item.table.rows);
  }
}

// ---------- команди ----------

async function cmdList() {
  ensureStubs();
  const progress = readProgress();
  const names = listDrillNames();
  let done = 0;
  for (const name of names) {
    const mark = progress[name] ? '✓' : '·';
    if (progress[name]) done += 1;
    console.log(`${mark} ${name}`);
  }
  console.log(`\nПройдено ${done} з ${names.length}`);
  const next = names.find((n) => !progress[n]);
  if (next) console.log(`Далі: npm run task ${next.slice(0, 2)}`);
}

async function cmdTask(arg) {
  ensureStubs();
  const name = findDrill(arg);
  console.log(fs.readFileSync(path.join(DRILLS_DIR, name, 'task.md'), 'utf8'));
  const { text, meta } = readSolution(name);
  if (!meta.plan && !meta.probe) {
    const db = await createDb(meta.needs);
    const expected = await runSql(db, text);
    await db.end();
    console.log('Очікуваний результат' + (meta.ordered ? ' (порядок важливий):' : ' (порядок неважливий):'));
    showTable(expected.columns, expected.rows, 20);
  }
  console.log(`Пиши в: drills/${name}/my.sql`);
  console.log(`Перевірка: npm run check ${name.slice(0, 2)}`);
}

async function cmdCheck(arg) {
  ensureStubs();
  const name = findDrill(arg);
  const mySql = fs.readFileSync(path.join(DRILLS_DIR, name, 'my.sql'), 'utf8');
  const { passed, report } = await evaluate(name, mySql);
  printReport(report);
  if (passed) {
    markPassed(name);
    console.log(`\n✓ ${name} зараховано`);
    console.log(`Порівняй зі своїм: npm run solution ${name.slice(0, 2)}`);
  } else {
    console.log(`\n✗ ${name} ще ні. Підказки: npm run hint ${name.slice(0, 2)}`);
    process.exitCode = 1;
  }
}

async function cmdHint(arg) {
  const name = findDrill(arg);
  const { meta } = readSolution(name);
  if (meta.hints.length === 0) return console.log('Підказок нема.');
  meta.hints.forEach((h, i) => console.log(`${i + 1}. ${h}`));
}

async function cmdSolution(arg, force) {
  const name = findDrill(arg);
  if (!readProgress()[name] && !force) {
    return console.log(
      `Спочатку своя спроба: npm run check ${name.slice(0, 2)}\n` +
        `Еталон відкриється після ✓. Якщо вже зовсім застряг: npm run solution ${name.slice(0, 2)} -- --force`,
    );
  }
  console.log(fs.readFileSync(path.join(SOLUTIONS_DIR, name + '.sql'), 'utf8'));
}

function allSeeds() {
  return fs
    .readdirSync(SEED_DIR)
    .filter((f) => f.endsWith('.sql') && f !== 'seed.sql')
    .map((f) => f.replace(/\.sql$/, ''));
}

async function cmdSchema() {
  const db = await createDb(allSeeds());
  const result = await db.query(
    `select table_name, string_agg(column_name || ' ' || data_type, ', ' order by ordinal_position) as columns
     from information_schema.columns where table_schema = 'public'
     group by table_name order by table_name`,
  );
  await db.end();
  for (const row of result.rows) console.log(`${row.table_name}\n  ${row.columns}\n`);
}

async function cmdPlay(args) {
  const db = await createDb(allSeeds());
  const inline = args.join(' ').trim();
  if (inline) {
    const result = await runSql(db, inline);
    await db.end();
    if (!result.ok) return console.error('Помилка SQL: ' + result.error);
    return showTable(result.columns, result.rows, 50);
  }
  console.log('Пісочниця. Всі таблиці є (npm run schema покаже їх). Запит закінчуй на ;  Вихід: exit');
  const rl = readline.createInterface({ input: process.stdin, output: process.stdout, prompt: 'sql> ' });
  let buffer = '';
  rl.prompt();
  for await (const line of rl) {
    if (line.trim() === 'exit') break;
    buffer += line + '\n';
    if (buffer.trim().endsWith(';')) {
      const result = await runSql(db, buffer);
      if (!result.ok) console.error('Помилка SQL: ' + result.error);
      else showTable(result.columns, result.rows, 50);
      buffer = '';
    }
    rl.setPrompt(buffer ? '...> ' : 'sql> ');
    rl.prompt();
  }
  rl.close();
  await db.end();
}

// Перевірка самого репо: еталони проходять, порожні заготовки ні.
async function cmdSelftest() {
  let bad = 0;
  for (const name of listDrillNames()) {
    const { text } = readSolution(name);
    const good = await evaluate(name, text);
    const empty = await evaluate(name, '-- нічого\n');
    const status = good.passed && !empty.passed ? 'ok ' : 'BAD';
    if (status === 'BAD') {
      bad += 1;
      console.log(`${status} ${name}  еталон проходить: ${good.passed}, порожній провалюється: ${!empty.passed}`);
      if (!good.passed) printReport(good.report);
    } else {
      console.log(`${status} ${name}`);
    }
  }
  console.log(bad === 0 ? '\nВсе гаразд.' : `\nПроблем: ${bad}`);
  process.exitCode = bad === 0 ? 0 : 1;
}

const [command, ...rest] = process.argv.slice(2);
const commands = {
  list: () => cmdList(),
  task: () => cmdTask(rest[0]),
  check: () => cmdCheck(rest[0]),
  hint: () => cmdHint(rest[0]),
  solution: () => cmdSolution(rest[0], rest.includes('--force')),
  schema: () => cmdSchema(),
  play: () => cmdPlay(rest),
  selftest: () => cmdSelftest(),
};

if (!commands[command]) {
  console.log('Команди: list | task NN | check NN | hint NN | solution NN | schema | play ["sql"]');
  process.exit(command ? 1 : 0);
}
await commands[command]();
