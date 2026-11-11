// Dni wolne okresu (tabela HOLIDAY_DAYS; w Delphi: kalendarz rezerwacji TReservationsCache, InvertReservations,
// PPCopyDays). Termin wolny: TYPE - symbol wyświetlany w siatce, CLASSES_ALLOWED '+' - zajęcia dozwolone
// (tylko oznaczenie), '-' - w tym terminie nie można planować zajęć.
'use strict';
const db = require('./db');

const plaId = s => s.roleId || s.plannerId;
const httpError = (status, message) => Object.assign(new Error(message), { status });
const isoDate = v => /^\d{4}-\d{2}-\d{2}$/.test(v || '');

async function periodOf(s, id) {
  const p = (await db.query(s.pool, `
    select p.id, to_char(p.date_from, 'YYYY-MM-DD') date_from, to_char(p.date_to, 'YYYY-MM-DD') date_to, p.hours_per_day,
           (select case when count(case when access_type = 'R' then null else 1 end) > 0 then 'E' else 'R' end
              from per_pla where per_id = p.id and pla_id = :pla) access_type
      from periods p
     where p.id = :id and p.id in (select per_id from per_pla where pla_id = :pla)`, { id: Number(id), pla: plaId(s) }))[0];
  if (!p) throw httpError(404, 'Nie znaleziono okresu lub brak uprawnień.');
  return p;
}

// uprawnienie do zmian: EDIT_RESERVATIONS planisty i dostęp do okresu inny niż tylko do odczytu (PeriodHolidaysReadOnly)
async function editCheck(s, per) {
  const r = (await db.query(s.pool, `select edit_reservations from planners where id = :id`, { id: s.plannerId }))[0] || {};
  if (r.EDIT_RESERVATIONS !== '+') return 'Nie masz uprawnień do modyfikacji dni wolnych';
  if (per.ACCESS_TYPE === 'R') return 'Nie masz uprawnień do modyfikacji dni wolnych w tym okresie';
  return null;
}

// zmiany dni wolnych przenoszone do okresów podrzędnych w tle (QueueCloneHolidaysToChilds)
async function queueClone(conn, perId) {
  await conn.execute(`delete from waiting_tasks where code = 'CLONE_HOLIDAYS_TO_CHILDS' and per_id = :p`, { p: perId });
  await conn.execute(`insert into waiting_tasks (id, code, per_id) values (main_seq.nextval, 'CLONE_HOLIDAYS_TO_CHILDS', :p)`, { p: perId });
}

// GET /api/holidays?period -> { items: [{ date, hour, type, allowed }], canEdit, reason }
async function list(s, url) {
  const per = await periodOf(s, url.searchParams.get('period'));
  const rows = await db.query(s.pool, `
    select to_char(day, 'YYYY-MM-DD') day, hour, type, classes_allowed
      from holiday_days
     where per_id = :p and day between to_date(:df, 'YYYY-MM-DD') and to_date(:dt, 'YYYY-MM-DD')
     order by day, hour`, { p: per.ID, df: per.DATE_FROM, dt: per.DATE_TO });
  const reason = await editCheck(s, per);
  return {
    items: rows.map(r => ({ date: r.DAY, hour: r.HOUR, type: r.TYPE || '', allowed: r.CLASSES_ALLOWED === '+' })),
    canEdit: !reason, reason,
  };
}

// POST /api/holidays/set { period, cells: [{date, hour}], remove, type, allowed }
//   remove = false: terminy oznaczane jako wolne (istniejące - zastępowane nowym symbolem); true: usuwane
async function set(s, body) {
  const per = await periodOf(s, body.period);
  const reason = await editCheck(s, per);
  if (reason) throw httpError(403, reason);
  const seen = new Set();
  const cells = (body.cells || []).filter(c => isoDate(c.date) && Number.isInteger(c.hour) && c.hour >= 1 && c.hour <= per.HOURS_PER_DAY
    && c.date >= per.DATE_FROM && c.date <= per.DATE_TO && !seen.has(c.date + '|' + c.hour) && seen.add(c.date + '|' + c.hour)).slice(0, 20000);
  if (!cells.length) throw httpError(400, 'Wybierz dni lub terminy.');
  const type = String(body.type || '').trim().slice(0, 15) || 'HOLIDAY';
  const allowed = body.allowed ? '+' : '-';
  await db.transaction(s.pool, async conn => {
    for (const c of cells) {
      await conn.execute(`delete from holiday_days where per_id = :p and day = to_date(:d, 'YYYY-MM-DD') and hour = :h`, { p: per.ID, d: c.date, h: c.hour });
      if (!body.remove) {
        await conn.execute(`insert into holiday_days (id, day, hour, type, classes_allowed, per_id)
                            values (res_seq.nextval, to_date(:d, 'YYYY-MM-DD'), :h, :t, :a, :p)`, { d: c.date, h: c.hour, t: type, a: allowed, p: per.ID });
      }
    }
    await queueClone(conn, per.ID);
  });
  return { count: cells.length };
}

// POST /api/holidays/clear { period } - "Usuń wszystkie dni wolne z bieżącego okresu"
async function clear(s, body) {
  const per = await periodOf(s, body.period);
  const reason = await editCheck(s, per);
  if (reason) throw httpError(403, reason);
  let count = 0;
  await db.transaction(s.pool, async conn => {
    count = (await conn.execute(`delete from holiday_days where per_id = :p`, { p: per.ID })).rowsAffected || 0;
    await queueClone(conn, per.ID);
  });
  return { count };
}

// POST /api/holidays/copy { period, from, deleteExisting } - "Skopiuj dni z innego okresu" (planner_utils.clone_holidays)
async function copy(s, body) {
  const per = await periodOf(s, body.period);
  const reason = await editCheck(s, per);
  if (reason) throw httpError(403, reason);
  const src = await periodOf(s, body.from);
  if (src.ID === per.ID) throw httpError(400, 'Wybierz inny okres.');
  await db.transaction(s.pool, async conn => {
    await conn.execute('begin planner_utils.clone_holidays(:src, :dst, :del); end;', { src: String(src.ID), dst: String(per.ID), del: body.deleteExisting ? 'Y' : 'N' });
    await queueClone(conn, per.ID);
  });
  return { ok: true };
}

// terminy, w których nie można planować zajęć (CLASSES_ALLOWED = '-') - sprawdzane przy dodawaniu i przenoszeniu zajęć
async function blockedCells(s, perId, cells) {
  if (!perId || !cells.length) return [];
  const days = [...new Set(cells.map(c => c.date))];
  const blocked = new Set();
  for (let i = 0; i < days.length; i += 300) {
    const binds = { p: Number(perId) };
    const d = days.slice(i, i + 300).map((v, j) => { binds['d' + j] = v; return `to_date(:d${j}, 'YYYY-MM-DD')`; }).join(',');
    for (const r of await db.query(s.pool, `select to_char(day, 'YYYY-MM-DD') day, hour from holiday_days
                                             where per_id = :p and classes_allowed = '-' and day in (${d})`, binds)) blocked.add(r.DAY + '|' + r.HOUR);
  }
  return cells.filter(c => blocked.has(c.date + '|' + c.hour));
}

async function handle(req, res, s, url, readJson, send) {
  const m = url.pathname.match(/^\/api\/holidays(?:\/(set|clear|copy))?$/);
  if (!m) return false;
  try {
    if (!m[1] && req.method === 'GET') send(res, 200, await list(s, url));
    else if (m[1] === 'set' && req.method === 'POST') send(res, 200, await set(s, await readJson(req)));
    else if (m[1] === 'clear' && req.method === 'POST') send(res, 200, await clear(s, await readJson(req)));
    else if (m[1] === 'copy' && req.method === 'POST') send(res, 200, await copy(s, await readJson(req)));
    else send(res, 405, { error: 'Niedozwolona operacja.' });
  } catch (err) {
    if (err.status) send(res, err.status, { error: err.message });
    else throw err;
  }
  return true;
}

module.exports = { handle, blockedCells };
