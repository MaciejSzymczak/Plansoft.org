// Wolne terminy (ShowFreeTermsL/G/R, tBusyClassesCache._LoadPeriod w UFMain.pas) i preferowane terminy
// (bfavpopup, tabela RES_HINTS).
'use strict';
const db = require('./db');

const plaId = s => s.roleId || s.plannerId;
const httpError = (status, message) => Object.assign(new Error(message), { status });
const idList = (v, max = 50) => [...new Set(String(v || '').split(',').map(Number).filter(n => Number.isInteger(n) && n > 0))].slice(0, max);
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
//     &avL=..&avG=..&avS=..&avNot=.. - "Gdzie mogę przenieść zajęcia?": zasoby zaznaczonych zajęć (zajęty, gdy zajęty
//     którykolwiek z nich, z wykluczeniami), avNot - same przenoszone zajęcia nie są zajętością
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
    // "Gdzie mogę przenieść zajęcia?": zasoby zaznaczonych zajęć - zajęty, gdy zajęty którykolwiek (bez warunku having)
    const av = idList(q.get('av' + t), 500);
    let avCond = '';
    if (av.length) {
      const avAll = [...new Set([...av, ...await excludedIds(s, av)])];
      avCond = `${d.col} in (${inList('a' + t.toLowerCase(), avAll, binds)})`;
      parts.push(`select cla_id from ${d.table} where no_conflict_flag is null and ${period} and ${avCond}`);
    }
    if (!ids.length) {
      counts.push(avCond ? `(select count(1) from ${d.table} x where x.cla_id = classes.id and x.no_conflict_flag is null and x.${avCond}) cnt${t}` : `0 cnt${t}`);
      continue;
    }
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
    counts.push(`(select count(1) from ${d.table} x where x.cla_id = classes.id and x.no_conflict_flag is null and (x.${cond}${avCond ? ' or x.' + avCond : ''})) cnt${t}`);
  }
  if (!parts.length) return [];
  // przenoszone zajęcia (po 900 w jednym "not in" - ORA-01795)
  const avNot = idList(q.get('avNot'), 5000);
  let notMoved = '';
  for (let i = 0; i < avNot.length; i += 900) notMoved += ` and classes.id not in (${avNot.slice(i, i + 900).join(',')})`;

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
       and classes.id in (${parts.join(' union ')})${respect}${notMoved}`, binds);
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

// --- lista preferowanych terminów (FavouritePopup "Lista" -> FBrowseRES_HINTS) ----------------------
// GET /api/hints/list?period&ids=1,2 - oceny wybranych obiektów w okresie (jak kolumny FBrowseRES_HINTS)
async function hintsList(s, url) {
  const per = await periodOf(s, Number(url.searchParams.get('period')));
  const ids = idList(url.searchParams.get('ids'), 500);
  if (!ids.length) return [];
  const binds = { df: per.DATE_FROM, dt: per.DATE_TO, pla: plaId(s) };
  const rows = await db.query(s.pool, `
    select res_hints.id, to_char(res_hints.day, 'YYYY-MM-DD') day, res_hints.hour, grids.caption, res_hints.ratio + 0 ratio, resources.name,
           res_hints.created_by, to_char(res_hints.creation_date, 'YYYY-MM-DD HH24:MI') creation_date,
           res_hints.last_updated_by, to_char(res_hints.last_update_date, 'YYYY-MM-DD HH24:MI') last_update_date
      from res_hints, resources, grids
     where res_hints.res_id = resources.id and grids.no(+) = res_hints.hour
       and res_hints.day between to_date(:df, 'YYYY-MM-DD') and to_date(:dt, 'YYYY-MM-DD')
       and res_hints.res_id in (${inList('i', ids, binds)})
       and res_hints.res_id in (select lec_id from lec_pla where pla_id = :pla union select gro_id from gro_pla where pla_id = :pla
                                union select rom_id from rom_pla where pla_id = :pla)
     order by res_hints.day, res_hints.hour, resources.name`, binds);
  return rows.map(r => ({
    id: r.ID, day: r.DAY, hour: r.HOUR, hourCaption: r.CAPTION || String(r.HOUR), ratio: r.RATIO, name: r.NAME,
    createdBy: r.CREATED_BY || '', created: r.CREATION_DATE || '', updatedBy: r.LAST_UPDATED_BY || '', updated: r.LAST_UPDATE_DATE || '',
  }));
}

// POST /api/hints/delete { ids: [id res_hints] } - usunięcie ocen obiektów, do których planista ma uprawnienia
async function hintsDelete(s, body) {
  const ids = [...new Set((body.ids || []).map(Number).filter(n => Number.isInteger(n) && n > 0))].slice(0, 5000);
  if (!ids.length) throw httpError(400, 'Zaznacz oceny do usunięcia.');
  let count = 0;
  await db.transaction(s.pool, async conn => {
    for (let i = 0; i < ids.length; i += 500) {
      const binds = { pla: plaId(s) };
      const r = await conn.execute(`
        delete from res_hints where id in (${inList('h', ids.slice(i, i + 500), binds)})
           and res_id in (select lec_id from lec_pla where pla_id = :pla union select gro_id from gro_pla where pla_id = :pla
                          union select rom_id from rom_pla where pla_id = :pla)`, binds);
      count += r.rowsAffected || 0;
    }
  });
  return { count };
}

// --- legenda: "Znajdź wykładowcę / grupę / salę" (TabSheetL/G/R w UFLegend.pas) ------------------------------
// POST /api/find { type: L|G|S, cells: [{date, hour}], q, onlyFree } -> { total, rows: [{ id, name, org, extra, busy, free }] }
// free - procent zaznaczonych terminów, w których obiekt nie ma zajęć (available_lec); bez zaznaczenia - 100
const FIND = {
  L: { table: 'lecturers', link: 'lec_cla', col: 'lec_id', pla: 'lec_pla', search: 'LECTURERS',
    name: `trim(lecturers.title||' '||lecturers.last_name||' '||lecturers.first_name)`, extra: 'lecturers.abbreviation', order: 'lecturers.last_name, lecturers.first_name' },
  G: { table: 'groups', link: 'gro_cla', col: 'gro_id', pla: 'gro_pla', search: 'GROUPS',
    name: 'nvl(groups.abbreviation, groups.name)', extra: `groups.name||nvl2(groups.number_of_peoples, ' ('||groups.number_of_peoples||' os.)', '')`, order: 'nvl(groups.abbreviation, groups.name)' },
  S: { table: 'rooms', link: 'rom_cla', col: 'rom_id', pla: 'rom_pla', search: 'ROOMS',
    name: 'rooms.name', extra: 'rooms.attribs_01', order: 'rooms.name' },
};
async function find(s, body) {
  const f = FIND[body.type];
  if (!f) throw httpError(400, 'Nieznany typ obiektu.');
  const { searchFilter } = require('./search');
  const seen = new Set();
  const cells = (body.cells || []).filter(c => /^\d{4}-\d{2}-\d{2}$/.test(c.date || '') && Number.isInteger(c.hour)
    && !seen.has(c.date + '|' + c.hour) && seen.add(c.date + '|' + c.hour)).slice(0, 1000);
  const binds = { pla: plaId(s) };
  const q = searchFilter(f.search, body.q, binds);
  let busyJoin = '', busyCol = '0';
  if (cells.length) {
    const terms = cells.map((c, i) => { binds['d' + i] = c.date; binds['h' + i] = c.hour; return `(to_date(:d${i}, 'YYYY-MM-DD'), :h${i})`; }).join(',');
    busyJoin = `, (select ${f.col} obj_id, count(distinct to_char(day, 'YYYYMMDD')||'|'||hour) cnt from ${f.link} where (day, hour) in (${terms}) group by ${f.col}) b`;
    busyCol = 'nvl(b.cnt, 0)';
  }
  const rows = await db.query(s.pool, `
    select * from (
      select ${f.table}.id, ${f.name} name, org_units.code org, ${f.extra} extra, ${busyCol} busy
        from ${f.table}, org_units ${busyJoin}
       where org_units.id(+) = ${f.table}.orguni_id ${cells.length ? `and b.obj_id(+) = ${f.table}.id` : ''}
         and ${f.table}.id in (select ${f.col} from ${f.pla} where pla_id = :pla) and ${q}
         ${body.onlyFree && cells.length ? `and ${busyCol} = 0` : ''}
       order by ${busyCol}, ${f.order})
     where rownum <= 500`, binds);
  const total = cells.length;
  return {
    total,
    rows: rows.map(r => ({ id: r.ID, name: r.NAME, org: r.ORG || '', extra: r.EXTRA || '', busy: r.BUSY, free: total ? Math.round((total - r.BUSY) * 100 / total) : 100 })),
  };
}

module.exports = { busy, hints, setHints, hintsList, hintsDelete, find };
