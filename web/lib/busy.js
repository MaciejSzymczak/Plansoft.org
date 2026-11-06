// Wolne terminy (ShowFreeTermsL/G/R, tBusyClassesCache._LoadPeriod w UFMain.pas) i preferowane terminy
// (bfavpopup, tabela RES_HINTS).
'use strict';
const db = require('./db');

const plaId = s => s.roleId || s.plannerId;
const httpError = (status, message) => Object.assign(new Error(message), { status });
const idList = v => [...new Set(String(v || '').split(',').map(Number).filter(n => Number.isInteger(n) && n > 0))].slice(0, 50);
const inList = (prefix, values, binds) => values.map((v, i) => { binds[prefix + i] = v; return ':' + prefix + i; }).join(',');

const TYPES = {
  L: { table: 'lec_cla', col: 'lec_id', flag: 'W' },
  G: { table: 'gro_cla', col: 'gro_id', flag: 'G' },
  S: { table: 'rom_cla', col: 'rom_id', flag: 'S' },
};

async function periodOf(s, id) {
  const p = (await db.query(s.pool, `
    select to_char(date_from, 'YYYY-MM-DD') date_from, to_char(date_to, 'YYYY-MM-DD') date_to, hours_per_day
      from periods where id = :id and id in (select per_id from per_pla where pla_id = :pla)`, { id, pla: plaId(s) }))[0];
  if (!p) throw httpError(404, 'Nie znaleziono okresu lub brak uprawnień.');
  return p;
}

// zasoby wykluczone (planner_utils.get_excluded_res_ids) - zajętość wykluczonych też blokuje termin
async function excludedIds(s, ids) {
  if (!ids.length) return [];
  try {
    const r = (await db.query(s.pool, `select planner_utils.get_excluded_res_ids(:ids) r from dual`, { ids: ids.join(';') }))[0];
    return String((r && r.R) || '').split(/[;,]/).map(Number).filter(n => n > 0);
  } catch { return []; }   // funkcja niezainstalowana
}

// GET /api/busy?period&L=1,2&G=..&S=..&modeL=all|any|n&cntL=6,7,8&...&respect=1&sub&form
// tryb: all = wolny dla wszystkich (zajęty, gdy zajęty dla któregokolwiek), any = wolny dla któregokolwiek
// (zajęty, gdy zajęty dla wszystkich), n = liczba zajętych zasobów z listy
async function busy(s, url) {
  const q = url.searchParams;
  const per = await periodOf(s, Number(q.get('period')));
  const binds = { df: per.DATE_FROM, dt: per.DATE_TO };
  const period = `day between to_date(:df, 'YYYY-MM-DD') and to_date(:dt, 'YYYY-MM-DD')`;
  const parts = [], counts = [];
  const chosen = {};
  for (const [t, d] of Object.entries(TYPES)) {
    const ids = idList(q.get(t));
    chosen[t] = ids;
    if (!ids.length) { counts.push(`0 cnt${t}`); continue; }
    const all = [...new Set([...ids, ...await excludedIds(s, ids)])];
    const cond = `${d.col} in (${inList(t.toLowerCase(), all, binds)})`;
    const mode = q.get('mode' + t) || 'all';
    let having = '';
    if (mode === 'any') having = `= ${ids.length}`;
    if (mode === 'n') {
      const n = String(q.get('cnt' + t) || '').split(',').map(Number).filter(x => Number.isInteger(x) && x > 0);
      having = n.length ? `in (${n.join(',')})` : `= ${ids.length}`;
    }
    parts.push(`select cla_id from ${d.table} where no_conflict_flag is null and ${period} and ${cond}` +
      (having ? ` and (day, hour) in (select day, hour from ${d.table} where no_conflict_flag is null and ${period} and ${cond} group by day, hour having count(1) ${having})` : ''));
    counts.push(`(select count(1) from ${d.table} x where x.cla_id = classes.id and x.no_conflict_flag is null and x.${cond}) cnt${t}`);
  }
  if (!parts.length) return [];

  // "Uzupełnianie": pomija zajęcia, które nowe zajęcie (domyślny przedmiot/forma, właściciel) tylko by uzupełniło
  let respect = '';
  if (q.get('respect') === '1') {
    binds.rsub = Number(q.get('sub')) || -1;
    binds.rfor = Number(q.get('form')) || -1;
    binds.ruser = s.user;
    const not = Object.entries(TYPES).filter(([t]) => chosen[t].length)
      .map(([t, d]) => `select cla_id from ${d.table} where no_conflict_flag is null and ${period} and ${d.col} not in (${inList('n' + t.toLowerCase(), chosen[t], binds)})`);
    respect = ` and classes.id in (select id from classes where ${period} and (nvl(sub_id, -1) <> :rsub or for_id <> :rfor or owner <> :ruser)` +
      not.map(x => ' union ' + x).join('') + ')';
  }

  const rows = await db.query(s.pool, `
    select classes.id, to_char(classes.day, 'YYYY-MM-DD') day, classes.hour, classes.calc_lecturers, classes.calc_groups, classes.calc_rooms,
           sub.name sub_name, frm.name for_name, ${counts.join(', ')}
      from classes, subjects sub, forms frm
     where sub.id(+) = classes.sub_id and frm.id(+) = classes.for_id
       and classes.id in (${parts.join(' union ')})${respect}`, binds);
  return rows.map(r => ({
    id: r.ID, day: r.DAY, hour: r.HOUR,
    types: (r.CNTL > 0 ? 'W' : '') + (r.CNTG > 0 ? 'G' : '') + (r.CNTS > 0 ? 'S' : ''),
    text: `${r.SUB_NAME || ''} (${r.FOR_NAME || ''})  Wykładowcy: ${r.CALC_LECTURERS || ''}  Grupy: ${r.CALC_GROUPS || ''}  Zasoby: ${(r.CALC_ROOMS || '').trim()}`,
    groups: r.CALC_GROUPS || '',
  }));
}

// --- preferowane terminy ------------------------------------------------------------------------

// GET /api/hints?period&ids=1,2 -> [{day, hour, ratio, resId, resName}]
async function hints(s, url) {
  const per = await periodOf(s, Number(url.searchParams.get('period')));
  const ids = idList(url.searchParams.get('ids'));
  if (!ids.length) return [];
  const binds = { df: per.DATE_FROM, dt: per.DATE_TO };
  const rows = await db.query(s.pool, `
    select to_char(day, 'YYYY-MM-DD') day, hour, ratio + 0 ratio, res_id, (select name from resources where resources.id = res_hints.res_id) res_name
      from res_hints
     where day between to_date(:df, 'YYYY-MM-DD') and to_date(:dt, 'YYYY-MM-DD') and res_id in (${inList('i', ids, binds)})
     order by day, hour, ratio`, binds);
  return rows.map(r => ({ day: r.DAY, hour: r.HOUR, ratio: r.RATIO, resId: r.RES_ID, resName: r.RES_NAME }));
}

const RATIOS = [-999, -750, -500, -300, 0, 300, 500, 750, 999];

// POST /api/hints { period, resId, ratio, cells: [{date, hour}] } - jak TFMain.SetRatio
async function setHints(s, body) {
  const per = await periodOf(s, Number(body.period));
  const ratio = Number(body.ratio);
  if (!RATIOS.includes(ratio)) throw httpError(400, 'Nieprawidłowa ocena terminu.');
  const resId = Number(body.resId);
  const perm = await db.query(s.pool, `
    select 1 from lec_pla where lec_id = :r and pla_id = :p union select 1 from gro_pla where gro_id = :r and pla_id = :p
    union select 1 from rom_pla where rom_id = :r and pla_id = :p`, { r: resId, p: plaId(s) });
  if (!perm.length) throw httpError(403, 'Brak uprawnień do tego obiektu.');
  const cells = (body.cells || []).filter(c => /^\d{4}-\d{2}-\d{2}$/.test(c.date || '') && Number.isInteger(c.hour)
    && c.date >= per.DATE_FROM && c.date <= per.DATE_TO && c.hour >= 1 && c.hour <= per.HOURS_PER_DAY).slice(0, 5000);
  if (!cells.length) throw httpError(400, 'Zaznacz terminy w siatce.');
  await db.transaction(s.pool, async conn => {
    for (const c of cells) {
      await conn.execute(`delete from res_hints where day = to_date(:d, 'YYYY-MM-DD') and hour = :h and res_id = :r`, { d: c.date, h: c.hour, r: resId });
      if (ratio !== 0) {
        await conn.execute(`insert into res_hints (id, day, hour, ratio, res_id, res_type) values (hint_seq.nextval, to_date(:d, 'YYYY-MM-DD'), :h, :ratio, :r, 'X')`,
          { d: c.date, h: c.hour, ratio, r: resId });
      }
    }
  });
  return { ok: true, count: cells.length };
}

module.exports = { busy, hints, setHints };
