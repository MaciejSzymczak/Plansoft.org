// Narzędzia z menu Delphi: "Dostępne miejsce" (TFDBSpace), "Dziennik zdarzeń systemowych" (TFBrowseEVENTLOG),
// "Oczekujące zadania" (TFWaitingTasks) i "Lista obecności" (Listaobecno1Click: attendance_list.prepare + getList).
'use strict';
const db = require('./db');
const { searchFilter } = require('./search');

const httpError = (status, message) => Object.assign(new Error(message), { status });
const dbError = e => httpError(400, String(e.message || e).split('\n')[0]);

// --- Dostępne miejsce: zajętość bazy względem limitu 12 GB (Oracle XE) i 20 największych segmentów ----------
async function dbSpace(s) {
  try {
    const r = (await db.query(s.pool, `
      select round(sum(bytes)/1024/1024/1024, 2) used_gb, 12 limit_gb,
             round((12 - sum(bytes)/1024/1024/1024), 2) free_gb, round(sum(bytes)/1024/1024/1024/12*100, 2) used_percent
        from dba_segments`))[0];
    return { usedGb: r.USED_GB, limitGb: r.LIMIT_GB, freeGb: r.FREE_GB, usedPercent: r.USED_PERCENT };
  } catch (e) { throw dbError(e); }
}

async function dbSegments(s) {
  try {
    const rows = await db.query(s.pool, `
      select owner, segment_name, segment_type, round(bytes/1024/1024, 2) mb
        from dba_segments order by bytes desc fetch first 20 rows only`);
    return rows.map(r => ({ owner: r.OWNER, name: r.SEGMENT_NAME, type: r.SEGMENT_TYPE, mb: r.MB }));
  } catch (e) { throw dbError(e); }
}

// --- Dziennik zdarzeń systemowych: tylko dla użytkownika PLANNER (tabela XXMSZTOOLS_EVENTLOG należy do PLANNER) ---
async function eventLog(s, url) {
  if (String(s.user).toUpperCase() !== 'PLANNER') throw httpError(403, 'Dziennik zdarzeń systemowych jest dostępny tylko dla użytkownika PLANNER.');
  const binds = {};
  const where = searchFilter(`e.message||' '||e.module_name||' '||e.message_type||' '||e.created_dsp`, url.searchParams.get('q'), binds);
  const rows = await db.query(s.pool, `
    select * from (
      select e.id, e.created_dsp, e.message_type, e.module_name, e.message
        from (select id, to_char(created, 'yyyy-mm-dd hh24:mi:ss') created_dsp, message_type, module_name, message
                from xxmsztools_eventlog order by id desc) e
       where ${where})
     where rownum <= 2000`, binds);
  return rows.map(r => ({ id: r.ID, created: r.CREATED_DSP, type: r.MESSAGE_TYPE, module: r.MODULE_NAME, message: r.MESSAGE }));
}

// --- Oczekujące zadania (WAITING_TASKS) -------------------------------------------------------------------
async function waitingTasks(s) {
  const rows = await db.query(s.pool, `
    select t.id, t.code, t.description, t.per_id, p.name per_name, t.status, t.priority,
           to_char(t.creation_date, 'YYYY-MM-DD HH24:MI') creation_date, t.created_by
      from waiting_tasks t, periods p
     where p.id(+) = t.per_id
     order by t.priority, t.creation_date desc`);
  return rows.map(r => ({
    id: r.ID, code: r.CODE, description: r.DESCRIPTION, period: r.PER_NAME || r.PER_ID, status: r.STATUS,
    priority: r.PRIORITY, created: r.CREATION_DATE, createdBy: r.CREATED_BY,
  }));
}

// --- Lista obecności: przygotowanie (attendance_list.prepare) i odczyt HTML w tej samej sesji -------------------
async function attendance(s, body) {
  const ok = d => /^\d{4}-\d{2}-\d{2}$/.test(d || '');
  if (!ok(body.from) || !ok(body.to)) throw httpError(400, 'Podaj daty od i do.');
  if (body.from > body.to) throw httpError(400, 'Data od nie może być późniejsza niż data do.');
  const ymd = d => d.replace(/-/g, '');   // DateToYYYYMMDD w Delphi
  try {
    return await db.transaction(s.pool, async conn => {
      await conn.execute('begin attendance_list.prepare(:f, :t); end;', { f: ymd(body.from), t: ymd(body.to) });
      const r = await conn.execute('select attendance_list.getList list from dual');
      return { html: r.rows[0].LIST || '' };
    });
  } catch (e) { throw e.status ? e : dbError(e); }
}

async function handle(req, res, s, url, readJson, send) {
  const m = url.pathname.match(/^\/api\/tools\/(dbspace|dbspace\/segments|eventlog|tasks|attendance)$/);
  if (!m) return false;
  try {
    const what = m[1], M = req.method;
    if (what === 'dbspace' && M === 'GET') send(res, 200, await dbSpace(s));
    else if (what === 'dbspace/segments' && M === 'GET') send(res, 200, await dbSegments(s));
    else if (what === 'eventlog' && M === 'GET') send(res, 200, await eventLog(s, url));
    else if (what === 'tasks' && M === 'GET') send(res, 200, await waitingTasks(s));
    else if (what === 'attendance' && M === 'POST') send(res, 200, await attendance(s, await readJson(req)));
    else send(res, 405, { error: 'Niedozwolona operacja.' });
  } catch (err) {
    if (err.status) send(res, err.status, { error: err.message });
    else throw err;
  }
  return true;
}

module.exports = { handle };
