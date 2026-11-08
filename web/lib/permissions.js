// Okno "Uprawnienia do obiektów" - jak TFPlannerPermissions (UFPlannerPermissions.pas):
// macierz planiści (kolumny) x obiekty (wiersze) jednej zakładki, komórka = ACCESS_TYPE w tabeli XXX_PLA
// (E - edycja, R - odczyt, brak - bez dostępu). Zapis komórka po komórce: delete + insert (SaveCellGrid).
'use strict';
const db = require('./db');
const { searchFilter } = require('./search');
const { ENTITIES } = require('./browse');

const MAX_ROWS = 3000;
const httpError = (status, message) => Object.assign(new Error(message), { status });

// zakładki: tabela uprawnień, kolumna obiektu, zapytanie wierszy (id, name), jednostka organizacyjna
const TABS = {
  LEC: {
    label: 'Wykładowcy', entity: 'L', orgCol: 'lecturers.orguni_id',
    rows: `select lecturers.id, trim(lecturers.title||' '||lecturers.last_name||' '||lecturers.first_name)||nvl2(org_units.name, ' ('||org_units.name||')', '') name
             from lecturers, org_units where org_units.id(+) = lecturers.orguni_id and lecturers.id > 0 and %W order by lecturers.last_name, lecturers.first_name`,
  },
  GRO: {
    label: 'Grupy', entity: 'G', orgCol: 'groups.orguni_id',
    rows: `select groups.id, nvl(groups.abbreviation, groups.name)||nvl2(groups.abbreviation, ' '||groups.name, '')||nvl2(org_units.name, ' ('||org_units.name||')', '') name
             from groups, org_units where org_units.id(+) = groups.orguni_id and groups.id > 0 and %W order by nvl(groups.abbreviation, groups.name)`,
  },
  ROM: {
    label: 'Zasoby', entity: 'S', orgCol: 'rooms.orguni_id',
    rows: `select rooms.id, rooms.name||nvl2(rooms.attribs_01, ' '||substr(rooms.attribs_01, 1, 55), '')||nvl2(org_units.name, ' ('||org_units.name||')', '') name
             from rooms, org_units where org_units.id(+) = rooms.orguni_id and rooms.id > 0 and %W order by rooms.name`,
  },
  SUB: {
    label: 'Przedmioty', entity: 'SUB', orgCol: 'subjects.orguni_id',
    rows: `select subjects.id, subjects.name||nvl2(subjects.abbreviation, ' ('||subjects.abbreviation||')', '')||nvl2(org_units.name, ' - '||org_units.name, '') name
             from subjects, org_units where org_units.id(+) = subjects.orguni_id and subjects.id > 0 and %W order by subjects.name`,
  },
  FOR: {
    label: 'Formy zajęć', entity: 'FOR', orgCol: null,
    rows: `select forms.id, forms.name||nvl2(forms.abbreviation, ' ('||forms.abbreviation||')', '') name
             from forms where forms.id > 0 and %W order by forms.name`,
  },
  ROL: {
    label: 'Autoryzacje', entity: null, orgCol: null,
    // wiersze: role (i zewnętrzni) widoczni dla planisty; kolumny: tylko użytkownicy
    rows: `select planners.id, planners.name from planners where planners.id > 0 and planners.type in ('ROLE', 'EXTERNAL') and %V and %W order by planners.name`,
  },
  PER: {
    label: 'Okresy', entity: 'PER', orgCol: 'periods.per_orguni_id',
    rows: `select periods.id, periods.name from periods, org_units where org_units.id(+) = periods.per_orguni_id and periods.id > 0 and %W order by periods.name`,
  },
};

async function flags(s) {
  const r = (await db.query(s.pool, `select edit_obj_permissions, edit_sharing from planners where id = :id`, { id: s.plannerId }))[0] || {};
  return { editPermissions: r.EDIT_OBJ_PERMISSIONS === '+', editSharing: r.EDIT_SHARING === '+' };
}

// planiści widoczni w oknie: wszyscy (EDIT_SHARING) albo bieżący użytkownik i jego role (bind :me)
const visiblePlanners = f => (f.editSharing ? '0=0'
  : `(planners.id = :me or (planners.type = 'ROLE' and planners.id in (select rol_id from rol_pla where pla_id = :me)))`);

async function check(s) {
  const f = await flags(s);
  if (!f.editPermissions) throw httpError(403, 'Nie posiadasz uprawnień do uruchomienia funkcji Uprawnienia');
  return f;
}

// kolumny: planiści wg filtra (Szukaj planisty, Użytkownicy, Role), jak LoadGrid
async function planners(s, f, p) {
  const types = [p.users ? `'USER'` : null, p.roles ? `'ROLE'` : null].filter(Boolean);
  if (!types.length) return [];
  const binds = { ps: `%${(p.planner || '').toUpperCase()}%` };
  if (!f.editSharing) binds.me = s.plannerId;
  const rows = await db.query(s.pool, `
    select id, name, type from planners
     where type <> 'EXTERNAL' and ${visiblePlanners(f)} and type in (${types.join(',')}) and upper(name) like :ps
     order by type desc, name`, binds);
  return rows.map(r => ({ id: r.ID, name: r.NAME, type: r.TYPE }));
}

async function load(s, url) {
  const f = await check(s);
  const t = TABS[url.searchParams.get('tab')];
  if (!t) throw httpError(400, 'Nieznana zakładka.');
  const tab = url.searchParams.get('tab');
  const p = {
    planner: url.searchParams.get('planner') || '', q: url.searchParams.get('q') || '',
    users: url.searchParams.get('users') !== '0', roles: url.searchParams.get('roles') !== '0',
    org: Number(url.searchParams.get('org')) || null, childs: url.searchParams.get('childs') === '1',
  };
  let cols = await planners(s, f, p);
  if (tab === 'ROL') cols = cols.filter(c => c.type === 'USER');

  // wiersze: obiekty zakładki z filtrem "Szukaj zasobu" i jednostką (z podrzędnymi)
  const binds = {};
  const where = [];
  if (tab === 'ROL') where.push(p.q ? searchFilter('planners.name', p.q, binds) : '0=0');
  else where.push(searchFilter(ENTITIES[t.entity].search, p.q, binds));
  if (p.org && t.orgCol) {
    binds.org = p.org;
    where.push(p.childs
      ? `${t.orgCol} in (select id from org_units start with id = :org connect by nocycle prior id = parent_id)`
      : `${t.orgCol} = :org`);
  }
  let sql = t.rows.replace('%W', where.join(' and '));
  if (sql.includes('%V')) { sql = sql.replace('%V', visiblePlanners(f)); if (!f.editSharing) binds.me = s.plannerId; }
  const rows = (await db.query(s.pool, `select * from (${sql}) where rownum <= ${MAX_ROWS + 1}`, binds)).map(r => ({ id: r.ID, name: r.NAME }));
  const truncated = rows.length > MAX_ROWS;
  if (truncated) rows.length = MAX_ROWS;

  // komórki: uprawnienia widocznych planistów do widocznych obiektów
  const cells = {};
  if (rows.length && cols.length) {
    const rowIds = new Set(rows.map(r => r.id));
    const colIds = cols.map(c => c.id);
    for (let i = 0; i < colIds.length; i += 500) {
      const b = {};
      const list = colIds.slice(i, i + 500).map((id, j) => { b['p' + j] = id; return ':p' + j; }).join(',');
      const found = await db.query(s.pool, `select pla_id, ${tab.toLowerCase()}_id obj_id, access_type from ${tab.toLowerCase()}_pla where pla_id in (${list})`, b);
      for (const r of found) if (rowIds.has(r.OBJ_ID)) cells[`${r.OBJ_ID}:${r.PLA_ID}`] = r.ACCESS_TYPE || 'E';
    }
  }
  return { tab, planners: cols, rows, cells, truncated, canTransfer: f.editSharing };
}

// zapis zmienionych komórek: [{ row, pla, access: 'E' | 'R' | null }] - jak SaveCellGrid + runSQL
async function save(s, body) {
  const f = await check(s);
  const tab = body.tab;
  if (!TABS[tab]) throw httpError(400, 'Nieznana zakładka.');
  const cells = (body.cells || []).filter(c => Number(c.row) > 0 && Number(c.pla) > 0 && [null, 'E', 'R'].includes(c.access ?? null));
  if (!cells.length) return { count: 0 };
  if (cells.length > 20000) throw httpError(400, 'Za dużo komórek naraz - zaznacz mniejszy obszar.');
  // planista komórki musi być widoczny dla zmieniającego (bez EDIT_SHARING: on sam i jego role)
  const allowed = new Set((await planners(s, f, { planner: '', users: true, roles: true })).map(p => p.id));
  const bad = cells.find(c => !allowed.has(Number(c.pla)));
  if (bad) throw httpError(403, 'Nie możesz zmieniać uprawnień tego planisty.');
  const t = tab.toLowerCase();
  await db.transaction(s.pool, async conn => {
    for (const c of cells) {
      const b = { pla: Number(c.pla), obj: Number(c.row) };
      await conn.execute(`delete from ${t}_pla where pla_id = :pla and ${t}_id = :obj`, b);
      if (c.access) {
        await conn.execute(`insert into ${t}_pla (id, pla_id, ${t}_id, access_type) values (${t}pla_seq.nextval, :pla, :obj, :acc)`, { ...b, acc: c.access });
      }
    }
  });
  return { count: cells.length };
}

// --- Historia zmian uprawnień (TFBrowseRES_PLA_HISTORY): zasób, komu, kto zmienił ---------------------------
const RES_TYPES = { LEC_PLA: 'Wykładowca', GRO_PLA: 'Grupa', ROM_PLA: 'Zasób', SUB_PLA: 'Przedmiot', FOR_PLA: 'Forma', PER_PLA: 'Okres', ROL_PLA: 'Autoryzacja' };
async function history(s, url) {
  const f = await check(s);
  if (!f.editSharing) throw httpError(403, 'Historia zmian uprawnień jest dostępna dla planistów z uprawnieniem do udostępniania (EDIT_SHARING).');
  const binds = {};
  const where = [];
  const q = url.searchParams.get('q') || '';
  if (q.trim()) {
    // RES_ID jest unikalne we wszystkich tabelach zasobów i w PLANNERS (main_seq) - jedna lista ID
    const sub = [
      `select lecturers.id from lecturers, org_units where lecturers.orguni_id = org_units.id(+) and ${searchFilter('LECTURERS', q, binds, 'a')}`,
      `select groups.id from groups, org_units where groups.orguni_id = org_units.id(+) and ${searchFilter('GROUPS', q, binds, 'b')}`,
      `select rooms.id from rooms, org_units where rooms.orguni_id = org_units.id(+) and ${searchFilter('ROOMS', q, binds, 'c')}`,
      `select subjects.id from subjects, org_units where subjects.orguni_id = org_units.id(+) and ${searchFilter(ENTITIES.SUB.search, q, binds, 'd')}`,
      `select forms.id from forms where ${searchFilter(ENTITIES.FOR.search, q, binds, 'e')}`,
      `select periods.id from periods where ${searchFilter('PERIODS', q, binds, 'f')}`,
      `select planners.id from planners where planners.type in ('ROLE', 'EXTERNAL') and ${searchFilter('planners.name', q, binds, 'g')}`,
    ];
    where.push(`h.res_id in (${sub.join(' union all ')})`);
  }
  const pla = url.searchParams.get('pla') || '';
  if (pla.trim()) where.push(`h.pla_id in (select planners.id from planners where ${searchFilter('planners.name', pla, binds, 'p')})`);
  const by = url.searchParams.get('by') || '';
  if (by.trim()) where.push(searchFilter('h.last_updated_by', by, binds, 'u'));
  const rows = await db.query(s.pool, `
    select * from (
      select h.id, to_char(h.last_update_date, 'YYYY-MM-DD HH24:MI:SS') changed, h.table_name,
             nvl(case h.table_name
                   when 'LEC_PLA' then (select trim(title||' '||last_name||' '||first_name) from lecturers where id = h.res_id)
                   when 'GRO_PLA' then (select nvl(abbreviation, name) from groups where id = h.res_id)
                   when 'ROM_PLA' then (select name from rooms where id = h.res_id)
                   when 'SUB_PLA' then (select name from subjects where id = h.res_id)
                   when 'FOR_PLA' then (select name from forms where id = h.res_id)
                   when 'PER_PLA' then (select name from periods where id = h.res_id)
                   when 'ROL_PLA' then (select name from planners where id = h.res_id)
                 end, '(usunięty, id='||h.res_id||')') res_name,
             decode(h.operation, 'I', 'Nadanie', 'D', 'Odebranie', 'U-', 'Zmiana - przed', 'U+', 'Zmiana - po', h.operation)
               || decode(h.access_type, null, null, ' ('||h.access_type||')') operation_dsp,
             nvl((select name from planners where id = h.pla_id), '(usunięty, id='||h.pla_id||')') pla_name,
             h.last_updated_by, h.os_user, h.module
        from res_pla_history h
       where ${where.length ? where.join(' and ') : '0=0'}
       order by h.last_update_date desc, h.id desc)
     where rownum <= 3000`, binds);
  const tracking = (await db.query(s.pool, `select value from system_parameters where name = 'RES_PLA_HISTORY'`))[0];
  return {
    tracking: !!tracking && tracking.VALUE === '+',
    rows: rows.map(r => ({
      changed: r.CHANGED, operation: r.OPERATION_DSP, type: RES_TYPES[r.TABLE_NAME] || r.TABLE_NAME, res: r.RES_NAME,
      pla: r.PLA_NAME, by: r.LAST_UPDATED_BY, osUser: r.OS_USER, module: r.MODULE,
    })),
  };
}

// --- Transfer uprawnień i danych (TFTransfer): procedura copy_permissions ---------------------------------
async function plannerList(s) {
  const f = await check(s);
  if (!f.editSharing) throw httpError(403, 'Transfer uprawnień jest dostępny dla planistów z uprawnieniem do udostępniania (EDIT_SHARING).');
  return (await db.query(s.pool, `select id, name, type from planners where type <> 'EXTERNAL' order by type desc, name`))
    .map(r => ({ id: r.ID, name: r.NAME, type: r.TYPE }));
}
async function transfer(s, body) {
  const f = await check(s);
  if (!f.editSharing) throw httpError(403, 'Transfer uprawnień jest dostępny dla planistów z uprawnieniem do udostępniania (EDIT_SHARING).');
  const from = Number(body.from), to = Number(body.to);
  if (!from) throw httpError(400, 'Wprowadź wartość w polu "Od planisty lub autoryzacji"');
  if (!to) throw httpError(400, 'Wprowadź wartość w polu "Do planisty lub autoryzacji"');
  if (from === to) throw httpError(400, 'Wprowadź dwie różne nazwy planistów');
  const yn = k => (body[k] ? 'Y' : 'N');
  try {
    await db.transaction(s.pool, conn => conn.execute(
      'begin copy_permissions(:pfrom, :pto, :plec, :pgro, :prom, :prol, :psub, :pfor, :pper, :pclasses); end;',
      { pfrom: from, pto: to, plec: yn('lec'), pgro: yn('gro'), prom: yn('rom'), prol: yn('rol'), psub: yn('sub'), pfor: yn('for'), pper: yn('per'), pclasses: yn('classes') }));
  } catch (e) {
    throw httpError(400, 'Ups.. Coś poszło nie tak, powiedz o tym administratorowi.\nKomunikat, który zwróciła baza danych: ' + String(e.message).split('\n')[0]);
  }
  return { ok: true };
}

async function handle(req, res, s, url, readJson, send) {
  const m = url.pathname.match(/^\/api\/permissions(?:\/(history|transfer|planners))?$/);
  if (!m) return false;
  try {
    if (m[1] === 'history' && req.method === 'GET') send(res, 200, await history(s, url));
    else if (m[1] === 'planners' && req.method === 'GET') send(res, 200, await plannerList(s));
    else if (m[1] === 'transfer' && req.method === 'POST') send(res, 200, await transfer(s, await readJson(req)));
    else if (m[1]) send(res, 405, { error: 'Niedozwolona operacja.' });
    else if (req.method === 'GET') send(res, 200, await load(s, url));
    else if (req.method === 'POST') send(res, 200, await save(s, await readJson(req)));
    else send(res, 405, { error: 'Niedozwolona operacja.' });
  } catch (err) {
    if (err.status) send(res, err.status, { error: err.message });
    else if (err.errorNum) send(res, 400, { error: db.writeErrorMessage(err) });
    else throw err;
  }
  return true;
}

module.exports = { handle, TABS };
