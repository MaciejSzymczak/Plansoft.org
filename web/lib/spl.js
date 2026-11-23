// Plan studiów 2 (Plan2, tabele SPL_ITEMS / SPL_ITEM_CLA, pakiet SPL_PKG) - jak w Delphi:
// okno "Plan studiów" (UFBrowseSPL_ITEMS), lista "Plan studiów" przy siatce (TreeMode, przeciąganie na siatkę),
// "Wybierz z planu studiów" w oknie dodawania zajęcia (BSelectComb).
// Działa tylko po włączeniu w Delphi: Plik | Ustawienia programu | "Plan studiów 2" (parametr SPL_ENABLED, globalny).
'use strict';
const db = require('./db');
const { searchFilter } = require('./search');

const plaId = s => s.roleId || s.plannerId;
const httpError = (status, message) => Object.assign(new Error(message), { status });
const num = v => { const n = Number(v); return Number.isFinite(n) && n > 0 ? n : null; };
const idList = v => [...new Set(String(v || '').split(/[,;]/).map(Number).filter(n => Number.isInteger(n) && n > 0))].slice(0, 500);

// "Dowolna fraza" - jak sql_SPL_SEARCH w UFBrowseSPL_ITEMS.pas
const SEARCH = `'#'||lec.last_name||'#'||lec.first_name||'#'||lec.title||'#'||gro.abbreviation||'#'||gro.name||'#'||sub.abbreviation
  ||'#'||sub.name||'#'||xfor.abbreviation||'#'||xfor.name||'#'||per.name||'#'||i.desc1||'#'`;

// uprawnienia jak CONPERMISSIONS w Delphi (XXX_PLA bieżącego planisty / roli)
const PERM = `(i.lec_id is null or i.lec_id in (select lec_id from lec_pla where pla_id = :pla))
   and i.gro_id in (select gro_id from gro_pla where pla_id = :pla)
   and i.sub_id in (select sub_id from sub_pla where pla_id = :pla)
   and i.for_id in (select for_id from for_pla where pla_id = :pla)
   and i.per_id in (select per_id from per_pla where pla_id = :pla)`;

const SELECT = `i.id, i.per_id, i.gro_id, i.sub_id, i.for_id, i.lec_id, i.planned_hours, i.scheduled_hours, i.desc1,
       to_char(i.recalc_date, 'YYYY-MM-DD HH24:MI') recalc_date,
       per.name per_dsp, nvl(gro.abbreviation, gro.name) gro_dsp, nvl(sub.name, sub.abbreviation) sub_dsp, xfor.name for_dsp,
       trim(lec.title||' '||lec.last_name||' '||lec.first_name) lec_dsp, i.sort_order`;
const FROM = `spl_items i, periods per, groups gro, subjects sub, forms xfor, lecturers lec
 where per.id = i.per_id and gro.id = i.gro_id and sub.id = i.sub_id and xfor.id = i.for_id and lec.id(+) = i.lec_id`;

const item = r => ({
  id: r.ID, perId: r.PER_ID, groId: r.GRO_ID, subId: r.SUB_ID, forId: r.FOR_ID, lecId: r.LEC_ID,
  per: r.PER_DSP, gro: r.GRO_DSP, sub: r.SUB_DSP, form: r.FOR_DSP, lec: r.LEC_DSP || '',
  planned: r.PLANNED_HOURS || 0, scheduled: r.SCHEDULED_NOW !== undefined ? (r.SCHEDULED_NOW || 0) : (r.SCHEDULED_HOURS || 0),
  desc: r.DESC1 || '', recalcDate: r.RECALC_DATE || '', sortOrder: r.SORT_ORDER === null || r.SORT_ORDER === undefined ? null : r.SORT_ORDER,
});

// włączony w Delphi (SPL_ENABLED = '+') i zainstalowana aktualizacja bazy 2026.11.21
async function enabled(s) {
  const r = (await db.query(s.pool, `
    select (select value from system_parameters where name = 'SPL_ENABLED') enabled,
           (select max(name) from system_parameters where name like 'VERSION%') version
      from dual`))[0] || {};
  return r.ENABLED === '+' && String(r.VERSION || '') >= 'VERSION 2026.11.21';
}
async function requireEnabled(s) {
  if (!await enabled(s)) throw httpError(400, 'Plan studiów 2 nie jest włączony (Delphi: Plik | Ustawienia programu).');
}

// GET /api/spl/panel?period&type=L|G|S&ids=1,2&scope=all - lista przy siatce (TreeMode "Plan studiów" w Delphi):
// pozycje okresów nakładających się na okres siatki, dla wykładowcy / grupy / sali widoku (scope=all - wszystkie);
// zaplanowane godziny liczone z bieżących zajęć jednym zapytaniem (te same reguły co spl_pkg.recalc)
async function panel(s, url) {
  await requireEnabled(s);
  const period = num(url.searchParams.get('period'));
  const type = url.searchParams.get('type');
  const ids = idList(url.searchParams.get('ids'));
  const all = url.searchParams.get('scope') === 'all';
  if (!period || (!all && (!ids.length || !['L', 'G', 'S'].includes(type)))) return { items: [] };
  const binds = { pla: plaId(s), cur: period };
  // all: the ids of the view are not used (and not bound - NJS-098)
  const list = all ? '' : ids.map((id, n) => { binds['i' + n] = id; return ':i' + n; }).join(',');
  const cond = all ? '0=0' : {
    // pozycje bez wykładowcy: powiązane z zajęciami wykładowcy (jak w oknie "Plan studiów")
    L: `(i.lec_id in (${list}) or (i.lec_id is null and exists (select 1 from spl_item_cla c, lec_cla lc where c.item_id = i.id and lc.cla_id = c.cla_id and lc.lec_id in (${list}))))`,
    G: `i.gro_id in (${list})`,
    S: `exists (select 1 from spl_item_cla c, rom_cla rc where c.item_id = i.id and rc.cla_id = c.cla_id and rc.rom_id in (${list}))`,
  }[type];
  const dp = Number(((await db.query(s.pool, `select value from system_parameters where name = 'GRID_DECIMAL_PLACES'`))[0] || {}).VALUE) || 4;
  const rows = await db.query(s.pool, `
    with it as (select i.id
                  from spl_items i, periods per, periods cur
                 where cur.id = :cur and per.id = i.per_id and per.date_from <= cur.date_to and per.date_to >= cur.date_from
                   and ${cond} and ${PERM}),
         h as (select i.id item_id, sum(round(nvl(cla.fill,100)/100 * nvl(g.duration,1), ${dp})) hours
                 from it, spl_items i, periods per, classes cla, grids g
                where i.id = it.id and per.id = i.per_id
                  and cla.day between per.date_from and per.date_to
                  and cla.hour <= nvl(per.hours_per_day, cla.hour)
                  and g.no = cla.hour
                  and cla.for_id = i.for_id
                  and (cla.sub_id = i.sub_id or exists (select 1 from str_elems se where se.parent_id = cla.sub_id and se.child_id = i.sub_id))
                  and exists (select 1 from gro_cla gc where gc.cla_id = cla.id and gc.gro_id = i.gro_id)
                  and (i.lec_id is null or exists (select 1 from lec_cla lc where lc.cla_id = cla.id and lc.lec_id = i.lec_id))
                group by i.id)
    select ${SELECT}, nvl(h.hours, 0) scheduled_now
      from h, ${FROM}
       and i.id in (select id from it)
       and h.item_id (+) = i.id
     order by i.sort_order, sub.name, xfor.name, gro.abbreviation, 15`, binds);
  return { items: rows.map(item) };
}

// GET /api/spl/list?q&per&lec&gro&rom&sub&for&todo=1&ids - okno "Plan studiów" (godziny zapisane przez "Przelicz")
async function list(s, url) {
  await requireEnabled(s);
  const p = url.searchParams;
  const binds = { pla: plaId(s) };
  let filter = searchFilter(SEARCH, p.get('q'), binds);
  const f = (name, sql) => { const v = num(p.get(name)); if (v) { binds[name] = v; filter += ' and ' + sql.replace(/:x/g, ':' + name); } };
  f('per', 'i.per_id = :x');
  // wykładowca pozycji albo (pozycja bez wykładowcy) wykładowca powiązanych zajęć
  f('lec', '(i.lec_id = :x or (i.lec_id is null and exists (select 1 from spl_item_cla c, lec_cla lc where c.item_id = i.id and lc.cla_id = c.cla_id and lc.lec_id = :x)))');
  f('gro', 'i.gro_id = :x');
  f('rom', 'exists (select 1 from spl_item_cla c, rom_cla rc where c.item_id = i.id and rc.cla_id = c.cla_id and rc.rom_id = :x)');
  f('sub', 'i.sub_id = :x');
  f('for', 'i.for_id = :x');
  if (p.get('todo') === '1') filter += ' and i.planned_hours > i.scheduled_hours';
  const ids = idList(p.get('ids'));
  if (ids.length) filter += ' and i.id in (' + ids.map((id, n) => { binds['k' + n] = id; return ':k' + n; }).join(',') + ')';
  const rows = await db.query(s.pool, `
    select * from (
      select ${SELECT} from ${FROM} and ${filter} and ${PERM}
       order by i.sort_order, per.name, gro.abbreviation, sub.name, xfor.name, 15)
     where rownum <= 2000`, binds);
  return { items: rows.map(item) };
}

// GET /api/spl/classes?item - "Powiązane zajęcia"
async function classes(s, url) {
  await requireEnabled(s);
  const id = num(url.searchParams.get('item'));
  if (!id) return { items: [] };
  const rows = await db.query(s.pool, `
    select to_char(cla.day, 'YYYY-MM-DD') day, cla.hour, c.hours, cla.calc_lecturers, cla.calc_rooms
      from spl_item_cla c, classes cla, spl_items i
     where c.item_id = :id and cla.id = c.cla_id and i.id = c.item_id and ${PERM}
     order by cla.day, cla.hour`, { id, pla: plaId(s) });
  return { items: rows.map(r => ({ day: r.DAY, hour: r.HOUR, hours: r.HOURS, lecturers: r.CALC_LECTURERS || '', rooms: r.CALC_ROOMS || '' })) };
}

// dostęp do obiektów pozycji (zapis): okres, grupa, przedmiot, forma, wykładowca z XXX_PLA
async function checkAccess(conn, s, v) {
  const r = (await conn.execute(`
    select (select count(*) from per_pla where pla_id = :pla and per_id = :per) per,
           (select count(*) from gro_pla where pla_id = :pla and gro_id = :gro) gro,
           (select count(*) from sub_pla where pla_id = :pla and sub_id = :sub) sub,
           (select count(*) from for_pla where pla_id = :pla and for_id = :frm) frm,
           (select count(*) from lec_pla where pla_id = :pla and lec_id = :lec) lec
      from dual`, { pla: plaId(s), per: v.per, gro: v.gro, sub: v.sub, frm: v.for, lec: v.lec || -1 })).rows[0];
  if (!r.PER || !r.GRO || !r.SUB || !r.FRM || (v.lec && !r.LEC)) throw httpError(403, 'Brak uprawnień do okresu, grupy, przedmiotu, formy lub wykładowcy.');
}

// POST /api/spl/save { id?, per, gro, sub, for, lec?, planned, desc } -> { id }; po zapisie przeliczenie pozycji
async function save(s, body) {
  await requireEnabled(s);
  const v = { id: num(body.id), per: num(body.per), gro: num(body.gro), sub: num(body.sub), for: num(body.for), lec: num(body.lec) };
  const planned = Number(body.planned);
  const missing = [!v.per && 'okres', !v.gro && 'grupa', !v.sub && 'przedmiot', !v.for && 'forma', !(planned >= 0) && 'godziny planowane'].filter(Boolean);
  if (missing.length) throw httpError(400, 'Uzupełnij: ' + missing.join(', '));
  const desc = String(body.desc || '').slice(0, 1000);
  // Kolejność (sort order): empty - none
  const sortOrder = body.sortOrder === null || body.sortOrder === undefined || body.sortOrder === '' ? null : Number(body.sortOrder);
  if (sortOrder !== null && !Number.isFinite(sortOrder)) throw httpError(400, 'Kolejność musi być liczbą.');
  try {
    return await db.transaction(s.pool, async conn => {
      await checkAccess(conn, s, v);
      const b = { per: v.per, gro: v.gro, sub: v.sub, frm: v.for, lec: v.lec, planned, descr: desc, sord: sortOrder };
      if (v.id) {
        const n = await conn.execute(`
          update spl_items i set per_id = :per, gro_id = :gro, sub_id = :sub, for_id = :frm, lec_id = :lec, planned_hours = :planned, desc1 = :descr, sort_order = :sord
           where id = :id and ${PERM}`, { ...b, id: v.id, pla: plaId(s) });
        if (!n.rowsAffected) throw httpError(404, 'Nie znaleziono pozycji lub brak uprawnień.');
      } else {
        v.id = (await conn.execute('select spl_seq.nextval id from dual')).rows[0].ID;
        await conn.execute(`
          insert into spl_items (id, per_id, gro_id, sub_id, for_id, lec_id, planned_hours, scheduled_hours, desc1, sort_order)
          values (:id, :per, :gro, :sub, :frm, :lec, :planned, 0, :descr, :sord)`, { ...b, id: v.id });
      }
      await conn.execute('begin spl_pkg.recalc(null, :id); end;', { id: v.id });
      return { id: v.id };
    });
  } catch (e) {
    if (/ORA-00001/.test(e.message)) throw httpError(400, 'Taka pozycja już istnieje (okres, grupa, przedmiot, forma, wykładowca).');
    throw e;
  }
}

// POST /api/spl/delete { ids: [..] }
async function remove(s, body) {
  await requireEnabled(s);
  const ids = idList((body.ids || []).join(','));
  if (!ids.length) throw httpError(400, 'Zaznacz pozycje.');
  return db.transaction(s.pool, async conn => {
    const binds = { pla: plaId(s) };
    const list = ids.map((id, n) => { binds['i' + n] = id; return ':i' + n; }).join(',');
    const r = await conn.execute(`delete from spl_items i where i.id in (${list}) and ${PERM}`, binds);
    return { count: r.rowsAffected };
  });
}

// POST /api/spl/recalc { per? } - "Przelicz": powiązane zajęcia i zaplanowane godziny okresu (bez okresu - wszystkie)
async function recalc(s, body) {
  await requireEnabled(s);
  const per = num(body.per);
  if (per && !(await db.query(s.pool, 'select 1 x from per_pla where pla_id = :pla and per_id = :per', { pla: plaId(s), per })).length)
    throw httpError(403, 'Brak uprawnień do okresu.');
  await db.transaction(s.pool, conn => conn.execute('begin spl_pkg.recalc(:per, null); end;', { per }));
  return { ok: true };
}

// --- "Rozplanuj" -----------------------------------------------------------------------------------------------
// the item (with permissions), hours still to be planned, rows of the grid of its period (own labels, hidden rows left out)
async function itemOf(s, id) {
  const r = (await db.query(s.pool, `
    select ${SELECT}, spl_pkg.scheduled_hours_now(i.id) scheduled_now
      from ${FROM} and i.id = :id and ${PERM}`, { id, pla: plaId(s) }))[0];
  if (!r) throw httpError(404, 'Nie znaleziono pozycji planu lub brak uprawnień.');
  return item(r);
}

// GET /api/spl/schedule-info?item -> { item, left, hours: [{ no, label }] }
async function scheduleInfo(s, url) {
  await requireEnabled(s);
  const it = await itemOf(s, num(url.searchParams.get('item')));
  const per = (await db.query(s.pool, `select hours_per_day, attribs_14, attribs_15 from periods where id = :id`, { id: it.perId }))[0] || {};
  const labels = String(per.ATTRIBS_14 || '').split(',').filter(Boolean);
  const hidden = String(per.ATTRIBS_15 || '');
  const rows = await db.query(s.pool, `select no, caption, trim(hour_from) hour_from from grids where no between 1 and :n order by no`, { n: per.HOURS_PER_DAY || 0 });
  const hours = rows
    .filter(r => !hidden || hidden[(r.NO - 1) % hidden.length] !== '-')
    .map(r => ({ no: r.NO, label: `${r.NO}.  ${(labels[r.NO - 1] || r.CAPTION || '').trim()}${r.HOUR_FROM ? '  (' + r.HOUR_FROM + ')' : ''}` }));
  return { item: it, left: Math.max(it.planned - it.scheduled, 0), hours };
}

// GET /api/spl/propose?item&mode=FIRST|EVEN&weekday=0..7&from&to&block&lec&rom -> spl_pkg.propose (no DML)
//   -> { status: OK|PART|DONE|ERR, total, left, message, terms: [{ date, hour, hours, meeting }] }
async function propose(s, url) {
  await requireEnabled(s);
  const q = url.searchParams;
  const it = await itemOf(s, num(q.get('item')));
  const int = (v, min, max, def) => { const n = Number(v); return Number.isInteger(n) && n >= min && n <= max ? n : def; };
  const r = (await db.query(s.pool, `select spl_pkg.propose(:pitem, :pmode, :pwd, :phf, :pht, :pblk, :plec, :prom) r from dual`, {
    pitem: it.id, pmode: q.get('mode') === 'EVEN' ? 'EVEN' : 'FIRST', pwd: int(q.get('weekday'), 0, 7, 0),
    phf: int(q.get('from'), 1, 99, null), pht: int(q.get('to'), 1, 99, null), pblk: int(q.get('block'), 1, 10, 1),
    plec: num(q.get('lec')), prom: num(q.get('rom')),
  }))[0];
  const parts = String((r && r.R) || '').split('|');
  const head = parts.shift().split(';');
  if (head[0] === 'ERR') return { status: 'ERR', message: head.slice(1).join(';'), terms: [] };
  return {
    status: head[0], total: Number(head[1]) || 0, left: Number(head[2]) || 0,
    terms: parts.filter(Boolean).map(e => { const [date, hour, hours, meeting] = e.split(';'); return { date, hour: Number(hour), hours: Number(hours), meeting: Number(meeting) }; }),
  };
}

async function handle(req, res, s, url, readJson, send) {
  const path = url.pathname;
  if (!path.startsWith('/api/spl/')) return false;
  if (path === '/api/spl/status' && req.method === 'GET') send(res, 200, { enabled: await enabled(s) });
  else if (path === '/api/spl/panel' && req.method === 'GET') send(res, 200, await panel(s, url));
  else if (path === '/api/spl/list' && req.method === 'GET') send(res, 200, await list(s, url));
  else if (path === '/api/spl/classes' && req.method === 'GET') send(res, 200, await classes(s, url));
  else if (path === '/api/spl/save' && req.method === 'POST') send(res, 200, await save(s, await readJson(req)));
  else if (path === '/api/spl/delete' && req.method === 'POST') send(res, 200, await remove(s, await readJson(req)));
  else if (path === '/api/spl/recalc' && req.method === 'POST') send(res, 200, await recalc(s, await readJson(req)));
  else if (path === '/api/spl/schedule-info' && req.method === 'GET') send(res, 200, await scheduleInfo(s, url));
  else if (path === '/api/spl/propose' && req.method === 'GET') send(res, 200, await propose(s, url));
  else return false;
  return true;
}

module.exports = { handle };
