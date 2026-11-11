// Obsługa zapytań /api/... Zapytania SQL odpowiadają tym z programu Delphi (DM.pas, UCommon.pas),
// składnia zgodna z Oracle 10 (rownum zamiast fetch first, złączenia (+)).
'use strict';
const db = require('./db');
const sessions = require('./sessions');
const browse = require('./browse');
const permissions = require('./permissions');
const report = require('./report');
const tools = require('./tools');
const holidays = require('./holidays');
const addClasses = require('./addClasses');
const busy = require('./busy');
const { POLISH, searchFilter } = require('./search');

// --- obiekty: wykładowcy, grupy, sale ------------------------------------------------------

const OBJECTS = {
  L: {
    table: 'LECTURERS',
    select: `lecturers.id, trim(lecturers.title||' '||lecturers.last_name||' '||lecturers.first_name) name, org_units.code org`,
    from: 'lecturers, org_units', join: 'org_units.id(+) = lecturers.orguni_id',
    perm: 'lecturers.id in (select lec_id from lec_pla where pla_id = :pla)',
    order: 'lecturers.last_name, lecturers.first_name',
  },
  G: {
    table: 'GROUPS',
    select: `groups.id, nvl(groups.abbreviation, groups.name) name, org_units.code org`,
    from: 'groups, org_units', join: 'org_units.id(+) = groups.orguni_id',
    perm: 'groups.id in (select gro_id from gro_pla where pla_id = :pla)',
    order: 'nvl(groups.abbreviation, groups.name)',
  },
  S: {
    table: 'ROOMS',
    select: `rooms.id, trim(rooms.name||' '||substr(rooms.attribs_01,1,55)) name, org_units.code org`,
    from: 'rooms, org_units', join: 'org_units.id(+) = rooms.orguni_id',
    // sale = kategoria zasobów 1 (jak w programie Delphi)
    perm: `rooms.rescat_id = ${Number(process.env.PLANSOFT_ROOM_RESCAT) || 1} and rooms.id in (select rom_id from rom_pla where pla_id = :pla)`,
    order: 'rooms.name',
  },
  // przedmioty i formy - pola okna dodawania zajęcia
  SUB: {
    search: `subjects.name||subjects.abbreviation||subjects.desc1||subjects.desc2`,
    select: `subjects.id, nvl(subjects.name, subjects.abbreviation) name, org_units.code org`,
    from: 'subjects, org_units', join: 'org_units.id(+) = subjects.orguni_id',
    perm: 'subjects.id in (select sub_id from sub_pla where pla_id = :pla)',
    order: 'subjects.name',
  },
  FOR: {
    search: `forms.name||forms.abbreviation`,
    select: `forms.id, forms.name, forms.abbreviation org`,
    from: 'forms', join: '0=0',
    perm: 'forms.id in (select for_id from for_pla where pla_id = :pla)',
    order: 'forms.sort_order_on_reports, forms.name',
    kind: true,   // ?kind=C (zajęcia) / R (rezerwacje)
  },
};

// --- pomocnicze ----------------------------------------------------------------------------

function send(res, status, body) {
  const data = JSON.stringify(body);
  res.writeHead(status, { 'Content-Type': 'application/json; charset=utf-8', 'Cache-Control': 'no-store' });
  res.end(data);
}

async function readJson(req) {
  if (!/^application\/json/.test(req.headers['content-type'] || '')) throw Object.assign(new Error('Oczekiwano JSON'), { status: 415 });
  let size = 0; const chunks = [];
  for await (const c of req) { size += c.length; if (size > 64 * 1024) throw Object.assign(new Error('Za duże zapytanie'), { status: 413 }); chunks.push(c); }
  return chunks.length ? JSON.parse(Buffer.concat(chunks).toString('utf8')) : {};
}

const plaId = s => s.roleId || s.plannerId;

function me(s) {
  return { user: s.user, plannerId: s.plannerId, roleId: s.roleId, roles: s.roles, firstResource: s.firstResource, canInsert: s.canInsert, canDelete: s.canDelete, editPermissions: s.editPermissions, canEdit: s.canEdit };
}

// --- akcje ---------------------------------------------------------------------------------

async function login(req, res) {
  const { user, password } = await readJson(req);
  if (!user || !password) return send(res, 400, { error: 'Podaj nazwę użytkownika i hasło.' });

  let pool;
  try {
    pool = await db.createUserPool(String(user).trim(), String(password));
  } catch (e) {
    await new Promise(r => setTimeout(r, 1000));   // spowalnia zgadywanie haseł
    return send(res, 401, { error: db.loginErrorMessage(e) });
  }

  try {
    // te same warunki co przy logowaniu w programie Delphi (UFMain.pas)
    const perm = await db.query(pool, `select count(1) cnt from sys.dba_role_privs where grantee = user and granted_role = 'PLA_PERMISSION'`);
    if (!perm[0].CNT) throw new Error('Nie masz uprawnień do korzystania z aplikacji - brak nadanych uprawnień.');
    const pla = await db.query(pool, `select id, name, first_resource_flag, can_insert, can_delete, edit_obj_permissions, can_edit_l, can_edit_g, can_edit_r, can_edit_s, can_edit_f, can_edit_o, can_edit_d from planners where name = user`);
    if (!pla.length) throw new Error('Brak uprawnień do korzystania z Aplikacji. Skontaktuj się z administratorem systemu w celu dodania planisty (Dane | Planiści).');
    const roles = await db.query(pool,
      `select id, name from planners where type = 'ROLE' and id in (select rol_id from rol_pla where pla_id = :id) order by name`,
      { id: pla[0].ID });

    const s = sessions.create(res, req, {
      pool, user: pla[0].NAME, plannerId: pla[0].ID, roleId: null,
      // okno dodawania zajęcia podpowiada tylko pierwszego wybranego wykładowcę/grupę/salę (FIRST_RESOURCE_FLAG)
      firstResource: pla[0].FIRST_RESOURCE_FLAG === '+', canInsert: pla[0].CAN_INSERT === '+', canDelete: pla[0].CAN_DELETE === '+', editPermissions: pla[0].EDIT_OBJ_PERMISSIONS === '+',
      canEdit: Object.fromEntries('LGRSFOD'.split('').map(k => [k, pla[0]['CAN_EDIT_' + k] === '+'])),
      roles: roles.map(r => ({ id: r.ID, name: r.NAME })),
    });
    send(res, 200, me(s));
  } catch (e) {
    await pool.close(0).catch(() => {});
    send(res, 403, { error: e.message });
  }
}

async function setRole(req, res, s) {
  const { roleId } = await readJson(req);
  if (roleId && !s.roles.some(r => r.id === roleId)) return send(res, 400, { error: 'Nieznana rola.' });
  s.roleId = roleId || null;
  send(res, 200, me(s));
}

async function periods(req, res, s, url) {
  const binds = { pla: plaId(s) };
  const filter = searchFilter('PERIODS', url.searchParams.get('q'), binds);
  const rows = await db.query(s.pool, `
    select * from (
      select periods.id, periods.name, to_char(periods.date_from, 'YYYY-MM-DD') date_from, to_char(periods.date_to, 'YYYY-MM-DD') date_to,
             periods.desc1
        from periods
       where periods.id in (select per_id from per_pla where pla_id = :pla)
         and periods.sub_period_parent is null
         and ${filter}
       order by periods.date_from desc, periods.name)
     where rownum <= 300`, binds);
  send(res, 200, rows.map(r => ({ id: r.ID, name: r.NAME, dateFrom: r.DATE_FROM, dateTo: r.DATE_TO, desc: r.DESC1 })));
}

async function period(req, res, s, id) {
  const rows = await db.query(s.pool, `
    select id, name, to_char(date_from, 'YYYY-MM-DD') date_from, to_char(date_to, 'YYYY-MM-DD') date_to, hours_per_day,
           show_mon||show_tue||show_wed||show_thu||show_fri||show_sat||show_sun days, attribs_13, attribs_14, attribs_15
      from periods
     where id = :id and id in (select per_id from per_pla where pla_id = :pla)`, { id, pla: plaId(s) });
  if (!rows.length) return send(res, 404, { error: 'Nie znaleziono okresu lub brak uprawnień.' });
  const p = rows[0];
  const hours = await db.query(s.pool,
    `select no, caption, hour_from, hour_to from grids where no between 1 and :n order by no`, { n: p.HOURS_PER_DAY || 0 });
  // własne etykiety godzin (ATTRIBS_14, po przecinku; jak gridCustomLabels: ExtractWord pomija puste, najwyżej 20 znaków)
  const labels = String(p.ATTRIBS_14 || '').split(',').filter(Boolean).map(x => x.slice(0, 20));
  send(res, 200, {
    id: p.ID, name: p.NAME, dateFrom: p.DATE_FROM, dateTo: p.DATE_TO,
    hoursPerDay: p.HOURS_PER_DAY,
    days: (p.DAYS || '').split('').map(c => c === '+'),    // pon..niedz
    hours: hours.map(h => ({ no: h.NO, caption: labels[h.NO - 1] || h.CAPTION, from: (h.HOUR_FROM || '').trim(), to: (h.HOUR_TO || '').trim() })),
    // ukryte wiersze (ATTRIBS_15) i tygodnie (ATTRIBS_13): znak na godzinę / tydzień, '-' = ukryty, wzorzec powtarzany
    hideRows: p.ATTRIBS_15 || '', weekVisibility: p.ATTRIBS_13 || '',
  });
}

async function objects(req, res, s, url, type) {
  const o = OBJECTS[type];
  if (!o) return send(res, 404, { error: 'Nieznany typ obiektu.' });
  const binds = { pla: plaId(s) };
  let filter = searchFilter(o.search || o.table, url.searchParams.get('q'), binds);
  const kind = url.searchParams.get('kind');
  if (o.kind && (kind === 'C' || kind === 'R')) { binds.kind = kind; filter += ' and forms.kind = :kind'; }
  const rows = await db.query(s.pool, `
    select * from (
      select ${o.select} from ${o.from}
       where ${o.join} and ${o.perm} and ${filter}
       order by ${o.order})
     where rownum <= 50`, binds);
  send(res, 200, rows.map(r => ({ id: r.ID, name: r.NAME, org: r.ORG })));
}

// --- organizator listy (FListOrganizer: rorL/rorG/rorR) ---------------------------------------------
// POST /api/objects/:type/resolve { ids, related } -> { items: [{id, name, org}], skipped }
// lista identyfikatorów (np. z pliku zapisanego w Delphi) -> nazwy w tej samej kolejności; rekordy bez
// uprawnień są pomijane (hasResourceAccess); related = dołóż nadrzędne i podrzędne (przycisk "Zależne")
async function resolveObjects(req, res, s, type) {
  const o = OBJECTS[type];
  if (!o || !['L', 'G', 'S'].includes(type)) return send(res, 404, { error: 'Nieznany typ obiektu.' });
  const body = await readJson(req);
  let ids = [...new Set((body.ids || []).map(Number).filter(n => Number.isInteger(n) && n > 0))].slice(0, 500);
  if (body.related && ids.length) ids = await addClasses.withChildsAndParents(s, ids);
  if (!ids.length) return send(res, 200, { items: [], skipped: 0 });
  const binds = { pla: plaId(s) };
  const list = ids.map((id, i) => { binds['i' + i] = id; return ':i' + i; }).join(',');
  const table = o.from.split(',')[0].trim();
  const rows = await db.query(s.pool, `
    select ${o.select} from ${o.from}
     where ${o.join} and ${o.perm} and ${table}.id in (${list})`, binds);
  const byId = new Map(rows.map(r => [r.ID, { id: r.ID, name: r.NAME, org: r.ORG }]));
  const items = ids.map(id => byId.get(id)).filter(Boolean);
  send(res, 200, { items, skipped: ids.length - items.length });
}

// --- zajęcia wybranych obiektów w okresie (jak ccLoadPeriod w UFMain.pas) -----------------

const CLASS_LINKS = {
  L: { table: 'lec_cla', col: 'lec_id', perm: 'select lec_id from lec_pla where pla_id = :pla' },
  G: { table: 'gro_cla', col: 'gro_id', perm: 'select gro_id from gro_pla where pla_id = :pla' },
  S: { table: 'rom_cla', col: 'rom_id', perm: 'select rom_id from rom_pla where pla_id = :pla' },
  // rozkład przedmiotu (zakładka "Przedmiot" w Delphi, TabViewType 5): zajęcia z wybranym przedmiotem
  SUB: { direct: 'cla.sub_id' },
};

// kolor Delphi (TColor = $00BBGGRR) -> #rrggbb
function delphiColour(c) {
  if (c === null || c === undefined || c < 0) return null;
  const r = c & 255, g = (c >> 8) & 255, b = (c >> 16) & 255;
  return '#' + [r, g, b].map(v => v.toString(16).padStart(2, '0')).join('');
}

// parametry wspólne dla zajęć i podsumowania: okres, typ rozkładu, wybrane obiekty
function scopeParams(url, s) {
  const link = CLASS_LINKS[url.searchParams.get('type')];
  const perId = Number(url.searchParams.get('period'));
  const ids = String(url.searchParams.get('ids') || '').split(',').map(Number).filter(n => Number.isInteger(n) && n > 0).slice(0, 50);
  if (!link || !perId) return null;
  const binds = { pla: plaId(s), per: perId };
  const idList = ids.map((id, i) => { binds['o' + i] = id; return ':o' + i; }).join(',');
  // jak ccLoadPeriod w Delphi: zajęcia wybranych obiektów bez dodatkowego filtra uprawnień XXX_PLA
  // (uprawnienia ograniczają tylko listy wyboru obiektów)
  const objClause = link.direct ? `${link.direct} in (${idList || 'null'})` : `cla.id in (select cla_id from ${link.table} where ${link.col} in (${idList}))`;
  const objExpr = link.direct ? link.direct
    : `(select max(x.${link.col}) from ${link.table} x where x.cla_id = cla.id and x.${link.col} in (${idList}))`;
  return { link, ids, idList, binds, objClause, objExpr };
}

// lista id "1;2;3" z wielu wierszy -> tablica liczb bez powtórzeń
const splitIds = rows => [...new Set(rows.flatMap(v => String(v || '').split(';')).map(Number).filter(n => n > 0))];

// id -> {colour, name} dla wykładowców/grup/zasobów (porcje po 500, limit in-list Oracle = 1000)
// name - jak w Delphi (opis w komórce "Wykładowca Nazwa"), label - jak w polach wyboru nad siatką
async function colourMap(pool, table, nameExpr, ids, labelExpr) {
  const map = {};
  for (let i = 0; i < ids.length; i += 500) {
    const part = ids.slice(i, i + 500);
    const binds = {};
    const list = part.map((id, j) => { binds['i' + j] = id; return ':i' + j; }).join(',');
    for (const r of await db.query(pool, `select id, colour, ${nameExpr} name, ${labelExpr || nameExpr} label from ${table} where id in (${list})`, binds))
      map[r.ID] = { colour: delphiColour(r.COLOUR), name: r.NAME, label: r.LABEL };
  }
  return map;
}

async function classes(req, res, s, url) {
  const p = scopeParams(url, s);
  if (!p) return send(res, 400, { error: 'Brak parametrów.' });
  if (!p.ids.length) return send(res, 200, { classes: [], lecturers: {}, groups: {}, rooms: {} });

  // jak ccLoadPeriod: najpierw zajęcia zależne (nadrzędne/podrzędne) wybranych obiektów
  const resType = { L: 'L', G: 'G', S: 'R' }[url.searchParams.get('type')];
  if (resType) try {
    await db.transaction(s.pool, async conn => {
      for (const id of p.ids) {
        await conn.execute(`begin planner_utils.insert_dependency_classes(:id, :t, :per, '-'); end;`, { id: String(id), t: resType, per: p.binds.per });
      }
    });
  } catch (e) {
    console.error(new Date().toISOString(), 'insert_dependency_classes', e.message);   // zajęcia i tak się wczytają
  }

  const rows = await db.query(s.pool, `
    select cla.id, to_char(cla.day, 'YYYY-MM-DD') day, cla.hour, cla.fill,
           sub.abbreviation sub_abbreviation, sub.name sub_name, frm.abbreviation for_abbreviation, frm.name for_name, frm.kind for_kind,
           cla.calc_lecturers, cla.calc_groups, cla.calc_rooms, cla.calc_lec_ids, cla.calc_gro_ids, cla.calc_rom_ids, cla.calc_rescat_ids,
           cla.desc1, cla.desc2, cla.desc3, cla.desc4, cla.owner, cla.created_by, cla.sub_id, cla.for_id,
           sub.colour sub_colour, frm.colour for_colour, cla.colour class_colour, owner.colour owner_colour, creator.colour creator_colour,
           ${p.objExpr} obj_id
      from classes cla, subjects sub, forms frm, periods per, planners owner, planners creator
     where sub.id(+) = cla.sub_id and frm.id = cla.for_id
       and owner.name(+) = cla.owner and creator.name(+) = cla.created_by
       and per.id = :per and per.id in (select per_id from per_pla where pla_id = :pla)
       and cla.day between per.date_from and per.date_to
       and ${p.objClause}
     order by cla.day, cla.hour`, p.binds);

  const [lecturers, groups, rooms] = await Promise.all([
    colourMap(s.pool, 'lecturers', `upper(last_name||' '||first_name)`, splitIds(rows.map(r => r.CALC_LEC_IDS)), `trim(title||' '||last_name||' '||first_name)`),
    colourMap(s.pool, 'groups', 'nvl(abbreviation, name)', splitIds(rows.map(r => r.CALC_GRO_IDS))),
    colourMap(s.pool, 'rooms', 'name', splitIds(rows.map(r => r.CALC_ROM_IDS)), `trim(name||' '||substr(attribs_01,1,55))`),
  ]);
  send(res, 200, {
    lecturers, groups, rooms,
    classes: rows.map(r => ({
      id: r.ID, day: r.DAY, hour: r.HOUR, fill: r.FILL ?? 100, objId: r.OBJ_ID, subId: r.SUB_ID, forId: r.FOR_ID,
      sub: r.SUB_ABBREVIATION || '', subName: r.SUB_NAME || '',
      form: r.FOR_ABBREVIATION || '', formName: r.FOR_NAME || '', formKind: r.FOR_KIND || '',
      lecturers: r.CALC_LECTURERS || '', groups: r.CALC_GROUPS || '', rooms: r.CALC_ROOMS || '',
      lecIds: r.CALC_LEC_IDS || '', groIds: r.CALC_GRO_IDS || '', romIds: r.CALC_ROM_IDS || '', rescatIds: r.CALC_RESCAT_IDS || '',
      desc: [r.DESC1 || '', r.DESC2 || '', r.DESC3 || '', r.DESC4 || ''],
      owner: r.OWNER || '', createdBy: r.CREATED_BY || '',
      colours: {
        S: delphiColour(r.SUB_COLOUR), F: delphiColour(r.FOR_COLOUR), CLASS: delphiColour(r.CLASS_COLOUR),
        OWNER: delphiColour(r.OWNER_COLOUR), CREATED_BY: delphiColour(r.CREATOR_COLOUR),
      },
    })),
  });
}

// --- wartości słownikowe opisów zajęć (FIN_LOOKUP_VALUESShowModalAsMultiselectExt w changeDesc) ------
// GET /api/desc-values?type=<nazwa opisu w liczbie mnogiej>&q= -> [{ value, key, aux1, aux2 }]
async function descValues(s, url) {
  const type = String(url.searchParams.get('type') || '');
  if (!type) return [];
  const binds = { t: type + '%' };
  const q = searchFilter('description||str_key||aux_desc1||aux_desc2', url.searchParams.get('q'), binds);
  const rows = await db.query(s.pool, `
    select * from (select description, str_key, aux_desc1, aux_desc2 from fin_lookup_values
                    where lookup_type like :t and ${q} order by description) where rownum <= 500`, binds);
  return rows.map(r => ({ value: r.DESCRIPTION || '', key: r.STR_KEY || '', aux1: r.AUX_DESC1 || '', aux2: r.AUX_DESC2 || '' }));
}

// --- ustawienia potrzebne w oknie "Zajęcie" i w podsumowaniu (UFProgramSettings) ------------

async function settings(req, res, s) {
  const params = await db.query(s.pool, `select name, value from system_parameters where name like 'CLASS_DESC%' or name = 'Rotate'`);
  const val = n => (params.find(p => p.NAME === n) || {}).VALUE || '';
  const cats = await db.query(s.pool, `select id, name from resource_categories where id > 0 order by name`);
  send(res, 200, {
    descPlural: [1, 2, 3, 4].map(i => val('CLASS_DESC' + i)),
    descSingular: [1, 2, 3, 4].map(i => val('CLASS_DESC' + i + 'S')),
    resourceCategories: cats.map(c => ({ id: c.ID, name: c.NAME })),
    // parametr Rotate (Delphi: rorL/rorG/rorR przesuwa listę zamiast otwierać organizator)
    rotate: ['+', 'T', 'TRUE', '1', '-1'].includes(String(val('Rotate')).toUpperCase()),
  });
}

// --- podsumowanie godzin (FLegend, zakładka "Podsumowanie godzin") --------------------------

// podziały: kolumny wyniku, wyrażenia GROUP BY, dodatkowe tabele i złączenia (jak w UFLegend.BRefreshClick)
const SUMMARY_GROUPS = {
  subName: { cols: [['Przedmiot', 'sub.name'], ['SUB_ID', 'sub.id']], group: '(sub.name, sub.id)', search: 'sub.name' },
  subAbbr: { cols: [['Przedmiot_Skrot', 'sub.abbreviation'], ['SUB_ID2', 'sub.id']], group: '(sub.abbreviation, sub.id)', search: 'sub.abbreviation' },
  day: { cols: [['Dzień', `to_char(cla.day, 'YYYY-MM-DD')`]], group: 'cla.day' },
  hour: { cols: [['Godz.', 'grids.caption'], ['HOUR_NO', 'min(grids.no)']], group: 'grids.caption', agg: ['HOUR_NO'] },
  form: { cols: [['Forma', 'fr.name'], ['FOR_ID', 'fr.id']], group: '(fr.name, fr.id)', search: 'fr.name' },
  desc1: { cols: [['DESC1', 'cla.desc1']], group: 'cla.desc1', search: 'cla.desc1' },
  desc2: { cols: [['DESC2', 'cla.desc2']], group: 'cla.desc2', search: 'cla.desc2' },
  desc3: { cols: [['DESC3', 'cla.desc3']], group: 'cla.desc3', search: 'cla.desc3' },
  desc4: { cols: [['DESC4', 'cla.desc4']], group: 'cla.desc4', search: 'cla.desc4' },
  lec: { cols: [['Wykładowca', `trim(lec.title||' '||lec.first_name||' '||lec.last_name)`], ['LEC_ID', 'lec.id']],
    group: `(trim(lec.title||' '||lec.first_name||' '||lec.last_name), lec.id)`, needs: 'lec', search: `lec.title||' '||lec.first_name||' '||lec.last_name` },
  groLine: { cols: [['Grupa', 'nvl(gro.abbreviation, gro.name)'], ['GRO_ID', 'gro.id']], group: '(nvl(gro.abbreviation, gro.name), gro.id)', needs: 'gro', search: 'gro.name||gro.abbreviation' },
  gro: { cols: [['Grupa', 'cla.calc_groups'], ['CALC_GRO_IDS', 'cla.calc_gro_ids']], group: '(cla.calc_groups, cla.calc_gro_ids)', search: 'cla.calc_groups' },
  rom: { cols: [['Zasób', `trim(rom.name||' '||substr(rom.attribs_01,1,55))`], ['ROM_ID', 'rom.id']],
    group: `(trim(rom.name||' '||substr(rom.attribs_01,1,55)), rom.id)`, needs: 'rom', search: 'rom.name' },
  createdBy: { cols: [['Utworzył', 'cla.created_by']], group: 'cla.created_by', search: 'cla.created_by' },
  owner: { cols: [['Właściciel', 'cla.owner']], group: 'cla.owner', search: 'cla.owner' },
  creationDate: { cols: [['Data utworzenia', `to_char(cla.creation_date, 'YYYY-MM-DD HH24:MI')`]], group: 'cla.creation_date' },
  lecDesc1: { cols: [['LDESC1', 'lec_cla.desc1']], group: 'lec_cla.desc1', needs: 'lec', search: 'lec_cla.desc1' },
  lecDesc2: { cols: [['LDESC2', 'lec_cla.desc2']], group: 'lec_cla.desc2', needs: 'lec', search: 'lec_cla.desc2' },
  lecDesc3: { cols: [['LDESC3', 'lec_cla.desc3']], group: 'lec_cla.desc3', needs: 'lec', search: 'lec_cla.desc3' },
  lecDesc4: { cols: [['LDESC4', 'lec_cla.desc4']], group: 'lec_cla.desc4', needs: 'lec', search: 'lec_cla.desc4' },
};
const SUMMARY_JOINS = {
  lec: { from: ', lec_cla, lecturers lec', where: ' and lec_cla.cla_id(+) = cla.id and lec.id(+) = lec_cla.lec_id' },
  gro: { from: ', gro_cla, groups gro', where: ` and gro_cla.cla_id(+) = cla.id and gro.id(+) = gro_cla.gro_id and gro_cla.is_child(+) = 'N'` },
  rom: { from: ', rom_cla, rooms rom', where: ' and rom_cla.cla_id(+) = cla.id and rom.id(+) = rom_cla.rom_id' },
};

// tygodnie ukryte w okresie (periods.attribs_13, jak getWeekVisibilityClause w UCommon.pas)
function hiddenWeeksClause(dateFrom, visibility, binds) {
  let v = visibility || '+';
  if (!v.includes('-')) return '';
  while (v.length < 120) v += v;
  const start = new Date(dateFrom + 'T00:00:00Z');
  start.setUTCDate(start.getUTCDate() - ((start.getUTCDay() + 6) % 7));   // poniedziałek tygodnia początku okresu
  const ranges = [];
  for (let i = 0; i < v.length; i++) {
    if (v[i] !== '-') continue;
    const a = new Date(start); a.setUTCDate(a.getUTCDate() + i * 7);
    binds['hw' + i] = a.toISOString().slice(0, 10);
    ranges.push(`(cla.day between to_date(:hw${i}, 'YYYY-MM-DD') and to_date(:hw${i}, 'YYYY-MM-DD') + 6)`);
  }
  return ' and not (' + ranges.join(' or ') + ')';
}

async function summary(req, res, s, url) {
  const p = scopeParams(url, s);
  if (!p) return send(res, 400, { error: 'Brak parametrów.' });
  const keys = String(url.searchParams.get('group') || '').split(',').filter(k => SUMMARY_GROUPS[k]);
  const rollup = url.searchParams.get('rollup') === '1';
  if (!p.ids.length) return send(res, 200, { columns: [], rows: [] });

  const per = (await db.query(s.pool, `
    select to_char(date_from, 'YYYY-MM-DD') date_from, hours_per_day, attribs_13,
           show_mon||show_tue||show_wed||show_thu||show_fri||show_sat||show_sun days
      from periods where id = :per and id in (select per_id from per_pla where pla_id = :pla)`, { per: p.binds.per, pla: p.binds.pla }))[0];
  if (!per) return send(res, 404, { error: 'Nie znaleziono okresu lub brak uprawnień.' });

  const binds = { ...p.binds, hpd: per.HOURS_PER_DAY || 0 };
  // dni tygodnia widoczne w okresie (1 = pon.), jak getWhereClausefromPeriod
  const days = (per.DAYS || '').split('').map((c, i) => (c === '+' ? i + 1 : 0)).filter(Boolean);
  const daysClause = days.length && days.length < 7 ? ` and (1 + trunc(cla.day) - trunc(cla.day, 'IW')) in (${days.join(',')})` : '';

  const groups = keys.map(k => SUMMARY_GROUPS[k]);
  const joins = [...new Set(groups.map(g => g.needs).filter(Boolean))].map(j => SUMMARY_JOINS[j]);
  const select = [];
  groups.forEach((g, i) => {
    g.cols.forEach(([alias, expr], j) => select.push(`${expr} "${j === 0 ? 'G' + i : alias}"`));
    // grouping() pierwszego wyrażenia podziału: 1 = wiersz podsumowania częściowego
    if (rollup) select.push(`grouping(${g.group.replace(/^\((.*), [^,]+\)$/, '$1')}) "R${i}"`);
  });
  select.push('round(sum(grids.duration * nvl(cla.fill, 100) / 100), 2) "HOURS"');

  // "Dowolna fraza" - przedmiot, forma i kolumny wybranych podziałów
  const searchCols = ['sub.name||sub.abbreviation', 'fr.name||fr.abbreviation', ...groups.map(g => g.search).filter(Boolean)];
  const tokens = String(url.searchParams.get('q') || '').toUpperCase().replace(/[ĄĆĘŁŃÓŚŹŻ]/g, c => POLISH[c])
    .split(',').map(t => t.trim()).filter(Boolean).slice(0, 10);
  const search = tokens.length ? ' and (' + tokens.map((t, i) => {
    binds['q' + i] = '%' + t + '%';
    return '(' + searchCols.map(c => `xxmsz_tools.erasePolishChars(upper(${c})) like :q${i}`).join(' or ') + ')';
  }).join(' or ') + ')' : '';

  const groupBy = groups.length ? (rollup ? `group by rollup(${groups.map(g => g.group).join(', ')})` : `group by ${groups.map(g => g.group).join(', ')}`) : '';
  const orderBy = groups.length ? 'order by ' + groups.map((g, i) => (rollup ? `"R${i}", ` : '') + (g.agg ? `"${g.agg[0]}"` : `"G${i}"`)).join(', ') : '';
  const rows = await db.query(s.pool, `
    select ${select.join(', ')}
      from classes cla, subjects sub, forms fr, grids, periods per${joins.map(j => j.from).join('')}
     where cla.owner <> 'AUTO'
       and per.id = :per and per.id in (select per_id from per_pla where pla_id = :pla)
       and cla.day between per.date_from and per.date_to and cla.hour <= :hpd${daysClause}
       ${hiddenWeeksClause(per.DATE_FROM, per.ATTRIBS_13, binds)}
       and sub.id(+) = cla.sub_id and fr.id = cla.for_id and grids.no = cla.hour
       ${joins.map(j => j.where).join('')}
       and ${p.objClause}${search}
     ${groupBy}
     ${orderBy}`, binds);

  send(res, 200, {
    columns: keys,
    rows: rows.map(r => ({
      values: keys.map((k, i) => r['G' + i] ?? null),
      ids: keys.map(k => { const c = SUMMARY_GROUPS[k].cols[1]; return c && !SUMMARY_GROUPS[k].agg ? r[c[0]] ?? null : null; }),
      rolled: rollup ? keys.map((k, i) => r['R' + i] === 1) : keys.map(() => false),
      hours: r.HOURS,
    })),
  });
}

// --- routing -------------------------------------------------------------------------------

async function handle(req, res, url) {
  const path = url.pathname;
  try {
    if (path === '/api/login' && req.method === 'POST') return await login(req, res);
    if (path === '/api/logout' && req.method === 'POST') { sessions.destroy(req, res); return send(res, 200, { ok: true }); }

    const s = sessions.get(req);
    if (!s) return send(res, 401, { error: 'Sesja wygasła - zaloguj się ponownie.' });

    if (path === '/api/me' && req.method === 'GET') return send(res, 200, me(s));
    if (path === '/api/role' && req.method === 'POST') return await setRole(req, res, s);
    if (path === '/api/periods' && req.method === 'GET') return await periods(req, res, s, url);
    if (path === '/api/classes' && req.method === 'GET') return await classes(req, res, s, url);
    if (path === '/api/summary' && req.method === 'GET') return await summary(req, res, s, url);
    if (path === '/api/settings' && req.method === 'GET') return await settings(req, res, s);
    let m;
    if ((m = path.match(/^\/api\/periods\/(\d+)$/)) && req.method === 'GET') return await period(req, res, s, Number(m[1]));
    if ((m = path.match(/^\/api\/objects\/(L|G|S|SUB|FOR)$/)) && req.method === 'GET') return await objects(req, res, s, url, m[1]);
    if ((m = path.match(/^\/api\/objects\/(L|G|S)\/resolve$/)) && req.method === 'POST') return await resolveObjects(req, res, s, m[1]);
    if (path === '/api/classes/add' && req.method === 'POST') return send(res, 200, await addClasses.add(s, await readJson(req)));
    if (path === '/api/classes/move' && req.method === 'POST') return send(res, 200, await addClasses.move(s, await readJson(req)));
    if (path === '/api/classes/delete' && req.method === 'POST') return send(res, 200, await addClasses.remove(s, await readJson(req)));
    if (path === '/api/classes/modify' && req.method === 'POST') return send(res, 200, await addClasses.modify(s, await readJson(req)));
    if (path === '/api/desc-values' && req.method === 'GET') return send(res, 200, await descValues(s, url));
    if (path === '/api/find' && req.method === 'POST') return send(res, 200, await busy.find(s, await readJson(req)));
    if (path === '/api/hints/list' && req.method === 'GET') return send(res, 200, await busy.hintsList(s, url));
    if (path === '/api/hints/delete' && req.method === 'POST') return send(res, 200, await busy.hintsDelete(s, await readJson(req)));
    if (path === '/api/busy' && req.method === 'GET') return send(res, 200, await busy.busy(s, url));
    if (path === '/api/hints' && req.method === 'GET') return send(res, 200, await busy.hints(s, url));
    if (path === '/api/hints' && req.method === 'POST') return send(res, 200, await busy.setHints(s, await readJson(req)));
    if (await browse.handle(req, res, s, url, readJson, send)) return;
    if (await permissions.handle(req, res, s, url, readJson, send)) return;
    if (await report.handle(req, res, s, url, readJson, send)) return;
    if (await tools.handle(req, res, s, url, readJson, send)) return;
    if (await holidays.handle(req, res, s, url, readJson, send)) return;

    send(res, 404, { error: 'Nie znaleziono.' });
  } catch (e) {
    console.error(new Date().toISOString(), req.method, path, e);
    send(res, e.status || 500, { error: e.status ? e.message : 'Błąd serwera: ' + e.message });
  }
}

module.exports = { handle };
