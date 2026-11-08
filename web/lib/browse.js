// Wspólny trzon okien słownikowych (jak TFBrowseParent w Delphi): lista z wyszukiwaniem i filtrami,
// formularz rekordu, dodawanie/kopiowanie/edycja/usuwanie, uprawnienia XXX_PLA i hierarchia (STR_ELEMS).
// Okna: wykładowcy (UFBrowseLECTURERS), grupy (uFBrowseGROUPS), zasoby/sale (UFBrowseROOMS).
'use strict';
const db = require('./db');
const { searchFilter } = require('./search');

// pola formularza; type: text | textarea | number | colour | check | lookup (lookup: nazwa z LOOKUPS)
const ENTITIES = {
  L: {
    table: 'lecturers', title: 'Wykładowcy', one: 'wykładowca', search: 'LECTURERS',
    pla: 'lec_pla', plaCol: 'lec_id', plaSeq: 'lecpla_seq', resType: 'LEC', depType: 'L',
    hierarchyParam: 'CHILD_AND_PARENTS_LEC',
    order: { default: 'lecturers.last_name, lecturers.first_name' },
    name: `trim(lecturers.title||' '||lecturers.last_name||' '||lecturers.first_name)`,
    fields: [
      { name: 'TITLE', label: 'Tytuł' },
      { name: 'ABBREVIATION', label: 'Skrót' },
      { name: 'FIRST_NAME', label: 'Imię' },
      { name: 'LAST_NAME', label: 'Nazwisko', required: true },
      { name: 'COLOUR', label: 'Kolor', type: 'colour' },
      { name: 'DESC1', label: 'Przedmioty', type: 'textarea', hint: 'Przedmioty w formacie "#Matematyka #Fizyka" - potem wyszukuj wykładowców wpisując #nazwa przedmiotu' },
      { name: 'DESC2', label: 'Słowa kluczowe', hint: 'Słowa kluczowe w formacie "#ABD, #XYZ" - potem wyszukuj wykładowców wpisując #słowo' },
      { name: 'ORGUNI_ID', label: 'Jedn. organizacyjna', type: 'lookup', lookup: 'ORG' },
      { name: 'EMAIL', label: 'Email' },
      { name: 'ROL_ID', label: 'Portal', type: 'lookup', lookup: 'PLANNER' },
      { name: 'DIFF_NOTIFICATIONS', label: 'Email o zmianach', type: 'check' },
      { name: 'INTEGRATION_ID', label: 'ID integracji' },
    ],
    columns: ['ABBREVIATION', 'COLOUR', 'TITLE', 'FIRST_NAME', 'LAST_NAME', 'ID', 'ORG_NAME', 'ORG_CODE', 'DESC1', 'DESC2', 'INTEGRATION_ID', 'DIFF_NOTIFICATIONS', 'EMAIL', 'DIFF_MESSAGE'],
    extra: { DIFF_MESSAGE: { label: 'Błąd podczas powiadamiania', expr: 'lecturers.diff_message' } },
  },
  G: {
    table: 'groups', title: 'Grupy', one: 'grupa', search: 'GROUPS',
    pla: 'gro_pla', plaCol: 'gro_id', plaSeq: 'gropla_seq', resType: 'GRO', depType: 'G',
    order: { default: 'nvl(groups.abbreviation, groups.name)' },
    name: 'nvl(groups.abbreviation, groups.name)',
    filter: { name: 'GROUP_TYPE', label: 'Typ grupy', lookup: 'GROUP_TYPE' },
    fields: [
      { name: 'ABBREVIATION', label: 'Skrót' },
      { name: 'NAME', label: 'Nazwa', required: true },
      { name: 'NUMBER_OF_PEOPLES', label: 'Liczność', type: 'number' },
      { name: 'COLOUR', label: 'Kolor', type: 'colour' },
      { name: 'DESC1', label: 'Dodatkowy opis' },
      { name: 'DESC2', label: 'Słowa kluczowe' },
      { name: 'GROUP_TYPE', label: 'Typ', type: 'lookup', lookup: 'GROUP_TYPE' },
      { name: 'EMAIL', label: 'Email' },
      { name: 'ROL_ID', label: 'Planowanie przez przeglądarkę', type: 'lookup', lookup: 'PLANNER' },
      { name: 'ORGUNI_ID', label: 'Jedn. organizacyjna', type: 'lookup', lookup: 'ORG' },
      { name: 'INTEGRATION_ID', label: 'ID integracji' },
    ],
    columns: ['ABBREVIATION', 'COLOUR', 'NAME', 'GROUP_TYPE', 'NUMBER_OF_PEOPLES', 'DESC1', 'DESC2', 'ORG_NAME', 'ORG_CODE', 'ID', 'CREATED_BY', 'CREATION_DATE', 'INTEGRATION_ID'],
  },
  S: {
    table: 'rooms', title: 'Zasoby', one: 'zasób', search: 'ROOMS',
    pla: 'rom_pla', plaCol: 'rom_id', plaSeq: 'rompla_seq', resType: 'ROM', depType: 'R',
    order: { default: 'rooms.name' },
    name: `trim(rooms.name||' '||substr(rooms.attribs_01,1,55))`,
    filter: { name: 'RESCAT_ID', label: 'Kategoria', lookup: 'RESCAT' },
    fields: [
      { name: 'NAME', label: 'Nazwa', required: true },
      { name: 'COLOUR', label: 'Kolor', type: 'colour' },
      { name: 'DESC1', label: 'Wyposażenie' },
      { name: 'DESC2', label: 'Słowa kluczowe' },
      { name: 'RESCAT_ID', label: 'Kategoria', type: 'lookup', lookup: 'RESCAT', required: true },
      { name: 'GOOGLE_LOCATION', label: 'Lokalizacja (Google)' },
      { name: 'ORGUNI_ID', label: 'Jedn. organizacyjna', type: 'lookup', lookup: 'ORG' },
      { name: 'INTEGRATION_ID', label: 'ID integracji' },
    ],
    columns: ['NAME', 'COLOUR', 'RESCAT_ID', 'DESC1', 'DESC2', 'ORG_NAME', 'ORG_CODE', 'ID', 'INTEGRATION_ID'],
  },
  SUB: {
    table: 'subjects', title: 'Przedmioty', one: 'przedmiot', pla: 'sub_pla', plaCol: 'sub_id', plaSeq: 'subpla_seq',
    // hierarchia przedmiotów bez sprawdzania konfliktów i przeliczania zależności zajęć (przedmiot nie jest zasobem)
    resType: null, depType: null,
    search: `org_units.name||org_units.code||subjects.name||subjects.abbreviation||subjects.desc1||subjects.desc2||'#'||subjects.integration_id||'#'`,
    order: { default: 'subjects.name' },
    fields: [
      { name: 'ABBREVIATION', label: 'Skrót', required: true },
      { name: 'NAME', label: 'Nazwa' },
      { name: 'COLOUR', label: 'Kolor', type: 'colour' },
      { name: 'DESC1', label: 'Kierunki' },
      { name: 'DESC2', label: 'Słowa kluczowe' },
      { name: 'ORGUNI_ID', label: 'Jedn. organizacyjna', type: 'lookup', lookup: 'ORG' },
      { name: 'DIFF_NOTIFICATIONS', label: 'Email o zmianach', type: 'check' },
      { name: 'INTEGRATION_ID', label: 'ID integracji' },
    ],
    columns: ['ABBREVIATION', 'COLOUR', 'NAME', 'ORG_NAME', 'ORG_CODE', 'ID', 'DESC1', 'DESC2', 'INTEGRATION_ID', 'DIFF_NOTIFICATIONS'],
  },
  FOR: {
    table: 'forms', title: 'Formy zajęć / rodzaje rezerwacji terminów', one: 'forma', pla: 'for_pla', plaCol: 'for_id', plaSeq: 'forpla_seq',
    orgCol: null, noHierarchy: true,
    search: `forms.name||forms.abbreviation||forms.desc1||forms.desc2||'#'||forms.integration_id||'#'`,
    order: { default: 'forms.sort_order_on_reports, forms.name' },
    filter: { name: 'KIND', label: 'Rodzaj', lookup: 'FORM_KIND' },
    fields: [
      { name: 'ABBREVIATION', label: 'Skrót', required: true },
      { name: 'NAME', label: 'Nazwa', required: true },
      { name: 'COLOUR', label: 'Kolor', type: 'colour' },
      { name: 'KIND', label: 'Rodzaj', type: 'lookup', lookup: 'FORM_KIND', required: true, default: 'C' },
      { name: 'SORT_ORDER_ON_REPORTS', label: 'Porządek sortowania', type: 'number' },
      { name: 'DESC1', label: 'Opis' },
      { name: 'DESC2', label: 'Słowa kluczowe' },
      { name: 'INTEGRATION_ID', label: 'ID integracji' },
    ],
    columns: ['ABBREVIATION', 'COLOUR', 'NAME', 'ID', 'KIND', 'SORT_ORDER_ON_REPORTS', 'DESC1', 'DESC2', 'INTEGRATION_ID'],
  },
  PER: {
    table: 'periods', title: 'Okresy', one: 'okres', pla: 'per_pla', plaCol: 'per_id', plaSeq: 'perpla_seq',
    orgCol: 'per_orguni_id', noHierarchy: true, search: 'PERIODS',
    order: { default: 'periods.date_from desc, periods.name' },
    // tygodnie okresów (SUB_PERIOD_PARENT) widoczne tylko po zaznaczeniu "Pokaż tygodnie"
    toggle: { label: 'Pokaż tygodnie', off: 'periods.sub_period_parent is null' },
    fields: [
      { name: 'NAME', label: 'Nazwa', required: true },
      { name: 'DATE_FROM', label: 'Data od', type: 'date', required: true },
      { name: 'DATE_TO', label: 'Data do', type: 'date', required: true },
      { name: 'HOURS_PER_DAY', label: 'Liczba bloków godz. w dniu', type: 'number', required: true },
      { name: 'SHOW_MON', label: 'Poniedziałki', type: 'check', default: '+', group: 'Pokazuj dni tygodnia' },
      { name: 'SHOW_TUE', label: 'Wtorki', type: 'check', default: '+', group: 'Pokazuj dni tygodnia' },
      { name: 'SHOW_WED', label: 'Środy', type: 'check', default: '+', group: 'Pokazuj dni tygodnia' },
      { name: 'SHOW_THU', label: 'Czwartki', type: 'check', default: '+', group: 'Pokazuj dni tygodnia' },
      { name: 'SHOW_FRI', label: 'Piątki', type: 'check', default: '+', group: 'Pokazuj dni tygodnia' },
      { name: 'SHOW_SAT', label: 'Soboty', type: 'check', default: '+', group: 'Pokazuj dni tygodnia' },
      { name: 'SHOW_SUN', label: 'Niedziele', type: 'check', default: '+', group: 'Pokazuj dni tygodnia' },
      { name: 'ROL_ID', label: 'Domyślna autoryzacja', type: 'lookup', lookup: 'PLANNER' },
      { name: 'LOCKED_FLAG', label: 'Planowanie zablokowane dla innych', type: 'check', default: '-', adminOnly: true },
      { name: 'ATTRIBS_15', label: 'Widoczność wierszy', hint: 'Ukryte wiersze (godziny) siatki' },
      { name: 'ATTRIBS_14', label: 'Siatka: własne etykiety' },
      { name: 'PER_ORGUNI_ID', label: 'Jednostka', type: 'lookup', lookup: 'ORG' },
      { name: 'ATTRIBS_13', label: 'Widoczność tygodni', hint: 'Znak na tydzień: + widoczny, - ukryty (np. ++-+)' },
      { name: 'PARENT_PER_ID', label: 'Kopiuj dni wolne z okresu', type: 'lookup', lookup: 'PERIOD' },
      { name: 'DESC1', label: 'Opis 1' },
      { name: 'DESC2', label: 'Opis 2' },
      { name: 'INTEGRATION_ID', label: 'ID integracji' },
    ],
    columns: ['NAME', 'DATE_FROM', 'DATE_TO', 'HOURS_PER_DAY', 'SHOW_MON', 'SHOW_TUE', 'SHOW_WED', 'SHOW_THU', 'SHOW_FRI', 'SHOW_SAT', 'SHOW_SUN',
      'CREATED_BY', 'LOCKED_FLAG', 'ROL_ID', 'ID', 'INTEGRATION_ID', 'ORG_NAME'],
  },
  // siatka godzinowa (FBrowseGRIDS): wspólna dla wszystkich planistów - bez tabeli uprawnień XXX_PLA
  GRID: {
    table: 'grids', title: 'Siatka godzinowa', one: 'godzina siatki', pla: null, orgCol: null, noHierarchy: true,
    search: `grids.caption||'#'||grids.no||'#'||grids.hour_from||grids.hour_to`,
    order: { default: 'grids.no' },
    fields: [
      { name: 'NO', label: 'Nr', type: 'number', required: true },
      { name: 'CAPTION', label: 'Etykieta', required: true },
      { name: 'HOUR_FROM', label: 'Godz. od', required: true, hint: 'gg:mm, np. 08:00' },
      { name: 'HOUR_TO', label: 'Godz. do', required: true, hint: 'gg:mm, np. 08:45' },
      { name: 'DURATION', label: 'Trwanie', type: 'number', required: true, default: 1 },
    ],
    columns: ['NO', 'CAPTION', 'HOUR_FROM', 'HOUR_TO', 'DURATION', 'ID', 'CREATED_BY', 'CREATION_DATE', 'LAST_UPDATE_DATE', 'LAST_UPDATED_BY'],
    // CheckRecord: godziny w formacie gg:mm, numer od 1 do maxHours (DM.pas: 60)
    validate: v => {
      const errors = [];
      for (const [c, label] of [['HOUR_FROM', 'Godz. od'], ['HOUR_TO', 'Godz. do']]) {
        const x = v(c);
        if (x && !(/^\d{2}:\d{2}$/.test(x) && +x.slice(0, 2) < 24 && +x.slice(3) < 60)) errors.push(`${label}: wartość "${x}" nie jest godziną w formacie gg:mm, np. 12:30`);
      }
      const no = v('NO');
      if (no !== null && no !== undefined && (no < 1 || no > 60)) errors.push('Nr musi się zawierać pomiędzy 1 a 60');
      return errors;
    },
  },
};

// typowe siatki (FBrowseGRIDS, menu "Utwórz typową siatkę" -> dmodule.generateGrid): [etykieta, od, do]
const range = n => Array.from({ length: n }, (_, i) => i);
const hh = h => String(h).padStart(2, '0');
const q15 = range(60).map(i => { const m = 7 * 60 + i * 15; return `${hh(Math.floor(m / 60))}.${hh(m % 60)}`; });
const GRID_PRESETS = {
  q15: { label: 'Co 15 min, 7.00 - 21.45', rows: q15.map((c, i) => [c, c, i < 59 ? q15[i + 1] : '22.00']) },
  h1234: { label: '1, 2, 3, 4 ... (co 60 min)', rows: range(40).map(i => [String(i + 1), i < 16 ? `${hh(7 + i)}:00` : '', i < 16 ? `${hh(7 + i)}:59` : '']) },
  h12_34: { label: '1-2, 3-4, 5-6 ...', rows: range(17).map(i => [`${2 * i + 1}-${2 * i + 2}`, '', '']) },
  h7_17: {
    label: '7.00, 8.00, 9.00 ... (co 60 min)',
    rows: range(40).map(i => [i < 17 ? `${7 + i}.00` : i === 17 ? '0.00' : String(i + 1), i < 16 ? `${hh(7 + i)}:00` : '', i < 16 ? `${hh(7 + i)}:59` : '']),
  },
  previous: { label: 'Importuj poprzednie ustawienia' },
};

// słowniki pól typu lookup: zapytanie listy (%Q = warunek wyszukiwania) albo stała lista wartości
const LOOKUPS = {
  ORG: { list: `select id code, substr(name||' ('||struct_code||')',1,100) name from org_units where %Q order by name`, search: `name||code||struct_code`, numeric: true },
  PLANNER: { list: `select id code, name from planners where %Q order by name`, search: 'name', numeric: true },
  GROUP_TYPE: { list: `select code, name from lookups_group_type where %Q order by name`, search: 'name||code' },
  RESCAT: { list: `select id code, name from resource_categories where id > 0 and %Q order by name`, search: 'name', numeric: true },
  PERIOD: { list: `select id code, name from periods where sub_period_parent is null and %Q order by date_from desc`, search: 'name', numeric: true },
  FORM_KIND: { values: [{ code: 'C', name: 'Forma zajęć' }, { code: 'R', name: 'Rezerwacja' }] },
};

const HIERARCHY_KINDS = [['STREAM', 'Potok'], ['ORG', 'Struktura organizacyjna'], ['OTHER', 'Inne']];

const COMMON_LABELS = {
  ID: 'Id', ORG_NAME: 'Nazwa jedn. org.', ORG_CODE: 'Kod struktury jedn. org.', CREATED_BY: 'Utworzone przez', CREATION_DATE: 'Data utworzenia',
  LAST_UPDATE_DATE: 'Zmieniono', LAST_UPDATED_BY: 'Zmienił',
};

// --- pomocnicze ----------------------------------------------------------------------------

const plaId = s => s.roleId || s.plannerId;

function httpError(status, message) { return Object.assign(new Error(message), { status }); }

// uprawnienia planisty z tabeli PLANNERS (wczytywane raz na sesję, jak przy logowaniu w UFMain.pas)
async function plannerFlags(s) {
  if (!s.flags) {
    const r = (await db.query(s.pool, `select is_integrated, is_admin, edit_obj_permissions, edit_sharing from planners where id = :id`, { id: s.plannerId }))[0] || {};
    s.flags = {
      integrated: r.IS_INTEGRATED === '+', admin: r.IS_ADMIN === '+',
      editPermissions: r.EDIT_OBJ_PERMISSIONS === '+', editSharing: r.EDIT_SHARING === '+',
    };
  }
  return s.flags;
}

async function systemParam(s, name, def) {
  const r = await db.query(s.pool, `select value from system_parameters where name = :n`, { n: name });
  return r.length && r[0].VALUE !== null ? r[0].VALUE : def;
}

const delphiToHex = c => {
  if (c === null || c === undefined) return null;
  const r = c & 255, g = (c >> 8) & 255, b = (c >> 16) & 255;
  return '#' + [r, g, b].map(v => v.toString(16).padStart(2, '0')).join('');
};
const hexToDelphi = h => {
  if (!/^#[0-9a-f]{6}$/i.test(h || '')) return null;
  const n = parseInt(h.slice(1), 16);
  return ((n & 255) << 16) | (n & 0xff00) | (n >> 16);
};
// losowy jasny kolor dla nowego rekordu (jak getRandomColor)
const randomColour = () => { const v = () => 128 + Math.floor(Math.random() * 128); return v() | (v() << 8) | (v() << 16); };

// maksymalne długości pól tekstowych z bazy (przycinanie i walidacja w formularzu)
const lengthsCache = {};
async function columnLengths(s, table) {
  if (!lengthsCache[table]) {
    const rows = await db.query(s.pool,
      `select column_name, data_type, data_length from all_tab_columns where table_name = upper(:t) and owner = (select table_owner from all_synonyms where synonym_name = upper(:t) and owner = 'PUBLIC' and rownum = 1)`, { t: table });
    const rows2 = rows.length ? rows : await db.query(s.pool,
      `select column_name, data_type, data_length from user_tab_columns where table_name = upper(:t)`, { t: table });
    lengthsCache[table] = Object.fromEntries(rows2.filter(r => r.DATA_TYPE === 'VARCHAR2').map(r => [r.COLUMN_NAME, r.DATA_LENGTH]));
  }
  return lengthsCache[table];
}

// --- lista i rekord ------------------------------------------------------------------------

// kolumna jednostki organizacyjnej (formy jej nie mają, okresy mają per_orguni_id)
const orgCol = e => (e.orgCol === undefined ? 'orguni_id' : e.orgCol);
const fromClause = e => (orgCol(e) ? `${e.table}, org_units` : e.table);
const joinClause = e => (orgCol(e) ? `org_units.id(+) = ${e.table}.${orgCol(e)}` : '0=0');
const fieldOf = (e, name) => e.fields.find(f => f.name === name) || {};

function selectList(e) {
  const t = e.table;
  const cols = new Set(['ID', ...e.fields.map(f => f.name), ...e.columns.filter(c => !['ORG_NAME', 'ORG_CODE'].includes(c) && !(e.extra || {})[c])]);
  return [
    ...[...cols].map(c => {
      if (c === 'CREATION_DATE') return `to_char(${t}.creation_date, 'YYYY-MM-DD HH24:MI') creation_date`;
      if (c === 'LAST_UPDATE_DATE') return `to_char(${t}.last_update_date, 'YYYY-MM-DD HH24:MI') last_update_date`;
      if (fieldOf(e, c).type === 'date') return `to_char(${t}.${c.toLowerCase()}, 'YYYY-MM-DD') ${c}`;
      return `${t}.${c.toLowerCase()}`;
    }),
    orgCol(e) ? 'org_units.name org_name, org_units.struct_code org_code' : 'null org_name, null org_code',
    ...Object.entries(e.extra || {}).map(([k, x]) => `${x.expr} ${k}`),
    e.pla ? `(select nvl(max(access_type), 'E') from ${e.pla} x where x.${e.plaCol} = ${t}.id and x.pla_id = :pla) access_type` : `'E' access_type`,
    ...e.fields.filter(f => f.type === 'lookup' && f.lookup !== 'ORG').map(f => lookupExpr(t, f)),
  ].join(', ');
}

function lookupExpr(t, f) {
  const c = `${t}.${f.name.toLowerCase()}`;
  if (f.lookup === 'PLANNER') return `(select name from planners where id = ${c}) ${f.name}_DSP`;
  if (f.lookup === 'GROUP_TYPE') return `(select name from lookups_group_type where code = ${c}) ${f.name}_DSP`;
  if (f.lookup === 'RESCAT') return `(select name from resource_categories where id = ${c}) ${f.name}_DSP`;
  if (f.lookup === 'PERIOD') return `(select name from periods where id = ${c}) ${f.name}_DSP`;
  const values = LOOKUPS[f.lookup].values;
  if (values) return `decode(${c}, ${values.map(v => `'${v.code}', '${v.name}'`).join(', ')}, ${c}) ${f.name}_DSP`;
  return `null ${f.name}_DSP`;
}

// wartość do zapisu: daty jako tekst RRRR-MM-DD
const bindExpr = (e, c) => (fieldOf(e, c).type === 'date' ? `to_date(:${c}, 'YYYY-MM-DD')` : ':' + c);

function rowOut(e, r) {
  const out = { id: r.ID, readOnly: r.ACCESS_TYPE === 'R', values: {}, display: {} };
  for (const f of e.fields) {
    let v = r[f.name] ?? null;
    if (f.type === 'colour') v = delphiToHex(v);
    out.values[f.name] = v;
    if (f.type === 'lookup') out.display[f.name] = f.lookup === 'ORG' ? r.ORG_NAME : r[f.name + '_DSP'] ?? null;
  }
  for (const c of e.columns) if (!(c in out.values)) out.values[c] = r[c] ?? null;
  return out;
}

async function list(s, e, url) {
  const binds = e.pla ? { pla: plaId(s) } : {};
  const where = [
    e.pla ? `${e.table}.id in (select ${e.plaCol} from ${e.pla} where pla_id = :pla)` : '0=0',
    searchFilter(e.search, url.searchParams.get('q'), binds),
  ];
  const org = Number(url.searchParams.get('org'));
  if (org && orgCol(e)) {
    binds.org = org;
    where.push(`${e.table}.${orgCol(e)} in (select id from org_units where struct_code like (select struct_code from org_units where id = :org)||'%')`);
  }
  const fv = url.searchParams.get('filter');
  if (e.filter && fv) { binds.fv = fv; where.push(`${e.table}.${e.filter.name.toLowerCase()} = :fv`); }
  if (e.toggle && url.searchParams.get('toggle') !== '1') where.push(e.toggle.off);

  // sortowanie po kliknięciu w nagłówek kolumny (tylko znane kolumny)
  const sort = url.searchParams.get('sort');
  const dir = url.searchParams.get('dir') === 'desc' ? 'desc' : 'asc';
  const sortable = new Set([...e.columns, ...e.fields.map(f => f.name)]);
  const sortExpr = c => (c === 'ORG_NAME' ? 'org_units.name' : c === 'ORG_CODE' ? 'org_units.struct_code'
    : ((e.extra || {})[c] || {}).expr || `${e.table}.${c.toLowerCase()}`);
  const order = sort && sortable.has(sort) ? `${sortExpr(sort)} ${dir} nulls last` : e.order.default;

  const rows = await db.query(s.pool, `
    select * from (
      select ${selectList(e)}
        from ${fromClause(e)}
       where ${joinClause(e)} and ${where.join(' and ')}
       order by ${order})
     where rownum <= 2000`, binds);
  return rows.map(r => rowOut(e, r));
}

async function getRecord(s, e, id, conn) {
  const sql = `select ${selectList(e)} from ${fromClause(e)}
     where ${joinClause(e)} and ${e.table}.id = :id
       and ${e.pla ? `${e.table}.id in (select ${e.plaCol} from ${e.pla} where pla_id = :pla)` : '0=0'}`;
  const binds = e.pla ? { id, pla: plaId(s) } : { id };
  const rows = conn ? (await conn.execute(sql, binds)).rows : await db.query(s.pool, sql, binds);
  if (!rows.length) throw httpError(404, 'Nie znaleziono rekordu lub brak uprawnień.');
  return rowOut(e, rows[0]);
}

// --- zapis ---------------------------------------------------------------------------------

// wartości z formularza -> binds; walidacja wymaganych pól i długości
async function valuesToBinds(s, e, values) {
  const lengths = await columnLengths(s, e.table);
  const binds = {};
  for (const f of e.fields) {
    let v = values ? values[f.name] : undefined;
    if (v === undefined) continue;
    if (typeof v === 'string') v = v.trim();
    if (v === '') v = null;
    if (f.type === 'colour') v = hexToDelphi(v);
    else if (f.type === 'number' || (f.type === 'lookup' && LOOKUPS[f.lookup].numeric)) {
      if (v !== null) { v = Number(v); if (!Number.isFinite(v)) throw httpError(400, `Pole „${f.label}” musi być liczbą.`); }
    } else if (f.type === 'check') v = v === true || v === '+' ? '+' : '-';
    else if (f.type === 'date') {
      if (v !== null && !/^\d{4}-\d{2}-\d{2}$/.test(v)) throw httpError(400, `Pole „${f.label}” musi być datą (RRRR-MM-DD).`);
    } else if (v !== null) {
      v = String(v);
      if (lengths[f.name] && v.length > lengths[f.name]) throw httpError(400, `Pole „${f.label}” może mieć najwyżej ${lengths[f.name]} znaków.`);
    }
    binds[f.name] = v;
  }
  return binds;
}

function checkRequired(e, binds, full) {
  for (const f of e.fields) {
    if (f.required && (full || f.name in binds) && (binds[f.name] === null || binds[f.name] === undefined))
      throw httpError(400, `Wypełnij pole „${f.label}”.`);
  }
}

// wspólne reguły zapisu: pola tylko dla administratora, kolejność dat okresu
async function checkWrite(s, e, binds, cur) {
  const flags = await plannerFlags(s);
  for (const f of e.fields) {
    if (f.adminOnly && !flags.admin && f.name in binds && binds[f.name] !== (cur ? cur.values[f.name] : f.default)) {
      throw httpError(403, `Pole „${f.label}” może zmieniać tylko administrator systemu.`);
    }
  }
  const val = c => (c in binds ? binds[c] : cur && cur.values[c]);
  if (fieldOf(e, 'DATE_FROM').type === 'date' && val('DATE_FROM') && val('DATE_TO') && val('DATE_FROM') > val('DATE_TO')) {
    throw httpError(400, '„Data od” nie może być późniejsza niż „Data do”.');
  }
  if (e.validate) {
    const errors = e.validate(val);
    if (errors.length) throw httpError(400, errors.join('\n'));
  }
}

async function insert(s, e, values) {
  const flags = await plannerFlags(s);
  if (flags.integrated) throw httpError(403, 'Dodawanie jest wyłączone, ponieważ dane są zasilane z innego systemu (integracja).');
  const binds = await valuesToBinds(s, e, values);
  if (fieldOf(e, 'COLOUR').type === 'colour' && (binds.COLOUR === null || binds.COLOUR === undefined)) binds.COLOUR = randomColour();
  for (const f of e.fields) if (f.default !== undefined && (binds[f.name] === null || binds[f.name] === undefined)) binds[f.name] = f.default;
  checkRequired(e, binds, true);
  await checkWrite(s, e, binds, null);
  const cols = Object.keys(binds);
  return db.transaction(s.pool, async conn => {
    const id = (await conn.execute('select main_seq.nextval id from dual')).rows[0].ID;
    await conn.execute(
      `insert into ${e.table} (id, ${cols.join(', ')}, creation_date, created_by, last_update_date, last_updated_by)
       values (:id, ${cols.map(c => bindExpr(e, c)).join(', ')}, sysdate, user, sysdate, user)`, { id, ...binds });
    // dostęp do nowego rekordu: planista i jego role (jak FSharing.init('I', ...) w Delphi)
    const owners = e.pla ? [s.plannerId, ...s.roles.map(r => r.id)] : [];
    for (const p of owners) {
      await conn.execute(
        `insert into ${e.pla} (id, pla_id, ${e.plaCol}, access_type, creation_date, created_by, last_update_date, last_updated_by)
         values (${e.plaSeq}.nextval, :p, :id, 'E', sysdate, user, sysdate, user)`, { p, id });
    }
    return getRecord(s, e, id, conn);
  });
}

async function update(s, e, id, values) {
  const cur = await getRecord(s, e, id);
  if (cur.readOnly) throw httpError(403, 'Masz dostęp do tego rekordu tylko do odczytu.');
  const binds = await valuesToBinds(s, e, values);
  checkRequired(e, binds, false);
  await checkWrite(s, e, binds, cur);
  const cols = Object.keys(binds);
  if (!cols.length) return cur;
  return db.transaction(s.pool, async conn => {
    await conn.execute(
      `update ${e.table} set ${cols.map(c => `${c} = ${bindExpr(e, c)}`).join(', ')}, last_update_date = sysdate, last_updated_by = user where id = :id`,
      { id, ...binds });
    // zmiana okresu, z którego kopiowane są dni wolne: zadanie w tle (jak TFBrowsePERIODS.AfterPost)
    if (e.table === 'periods' && 'PARENT_PER_ID' in binds && binds.PARENT_PER_ID && binds.PARENT_PER_ID !== cur.values.PARENT_PER_ID) {
      await conn.execute(`insert into waiting_tasks (id, code, per_id) values (main_seq.nextval, 'CLONE_HOLIDAYS_TO_CHILDS', :p)`, { p: binds.PARENT_PER_ID });
    }
    return getRecord(s, e, id, conn);
  });
}

async function remove(s, e, id) {
  const flags = await plannerFlags(s);
  if (flags.integrated) throw httpError(403, 'Usuwanie jest wyłączone, ponieważ dane są zasilane z innego systemu (integracja).');
  const cur = await getRecord(s, e, id);
  if (cur.readOnly) throw httpError(403, 'Masz dostęp do tego rekordu tylko do odczytu.');
  await db.transaction(s.pool, async conn => {
    await conn.execute(`delete from ${e.table} where id = :id`, { id });
  });
}

// --- hierarchia (zakładka "... zależni": zasoby nadrzędne i podrzędne) ---------------------

async function hierarchy(s, e, id, kind) {
  const lov = HIERARCHY_KINDS.some(k => k[0] === kind) ? kind : 'STREAM';
  await getRecord(s, e, id);
  const parents = await db.query(s.pool, `
    select id, level lvl, parent_dsp name, exclusive_parent from str_elems_v
     where str_name_lov = :l1
     connect by prior str_name_lov = :l2 and prior parent_id = child_id
     start with child_id = :id
     order by level desc`, { l1: lov, l2: lov, id });
  const details = await db.query(s.pool, `
    select id, level lvl, child_dsp name, exclusive_parent from str_elems_v
     where str_name_lov = :l1
     connect by prior str_name_lov = :l2 and prior child_id = parent_id
     start with parent_id = :id`, { l1: lov, l2: lov, id });
  const out = r => ({ id: r.ID, level: r.LVL, name: r.NAME, exclusive: r.EXCLUSIVE_PARENT === '+' });
  return { kind: lov, parents: parents.map(out), details: details.map(out) };
}

// dodanie nadrzędnych (parent=true) lub podrzędnych; wcześniej sprawdzenie konfliktów zajęć (sqlCheckConflicts w UFMain)
async function addHierarchy(s, e, id, body) {
  const lov = HIERARCHY_KINDS.some(k => k[0] === body.kind) ? body.kind : 'STREAM';
  const ids = (body.ids || []).map(Number).filter(n => n > 0 && n !== id);
  if (!ids.length) throw httpError(400, 'Wybierz rekordy.');
  await getRecord(s, e, id);
  const t = e.resType ? e.resType.toLowerCase() : null;
  for (const other of t ? ids : []) {
    const c = await db.query(s.pool, `
      select to_char(day, 'yyyy-mm-dd')||':'||hour x from (
        select classes.day, classes.hour from ${t}_cla, classes where classes.id = cla_id and owner <> 'AUTO' and ${t}_id = :id1
        intersect
        select classes.day, classes.hour from ${t}_cla, classes where classes.id = cla_id and owner <> 'AUTO' and ${t}_id = :id2)
       where rownum < 10`, { id1: other, id2: id });
    if (c.length) throw httpError(409, `${other}: Nie można utworzyć relacji, ponieważ spowodowałaby ona konflikty: oba zasoby mają już zajęcia w tym samym czasie, np. ${c[0].X}`);
  }
  const message = await db.transaction(s.pool, async conn => {
    for (const other of ids) {
      const parentId = body.parent ? other : id;
      const childId = body.parent ? id : other;
      await conn.execute(`begin planner_utils.insert_str_elem(:p, :c, :lov, :ex); end;`,
        { p: parentId, c: childId, lov, ex: body.exclusive ? '+' : '-' });
      if (e.depType) await conn.execute(`begin planner_utils.insert_dependency_classes(:res, :type, null, '+'); end;`, { res: String(parentId), type: e.depType });
    }
    const m = (await conn.execute('select planner_utils.get_output_param_char1 m from dual')).rows[0].M;
    if (m) throw httpError(400, m);
    return m;
  });
  return { ok: true, message };
}

async function removeHierarchy(s, e, id, strId) {
  await getRecord(s, e, id);
  await db.transaction(s.pool, async conn => {
    const r = (await conn.execute(`select parent_id from str_elems where id = :id and (parent_id = :o or child_id = :o)`, { id: strId, o: id })).rows;
    if (!r.length) throw httpError(404, 'Nie znaleziono powiązania.');
    await conn.execute('delete from str_elems where id = :id', { id: strId });
    if (e.depType) await conn.execute(`begin planner_utils.insert_dependency_classes(:res, :type, null, '+'); end;`, { res: String(r[0].PARENT_ID), type: e.depType });
  });
}

// --- typowa siatka godzinowa: usuwa wszystkie godziny i wstawia nowe (dmodule.generateGrid) -----------
async function generateGrid(s, body) {
  const flags = await plannerFlags(s);
  if (flags.integrated) throw httpError(403, 'Zmiana jest wyłączona, ponieważ dane są zasilane z innego systemu (integracja).');
  const preset = GRID_PRESETS[body.preset];
  if (!preset) throw httpError(400, 'Nieznany rodzaj siatki.');
  let rows = preset.rows;
  if (!rows) {
    // importPreviousGridSettings: parametry systemowe LESSON_NO1..9, LESSON_N10..60, LESSON_HFROMn, LESSON_HTOn
    rows = [];
    for (const i of range(60)) {
      rows.push(await Promise.all([i < 9 ? `LESSON_NO${i + 1}` : `LESSON_N${i + 1}`, `LESSON_HFROM${i + 1}`, `LESSON_HTO${i + 1}`]
        .map(n => systemParam(s, n, ''))));
    }
  }
  await db.transaction(s.pool, async conn => {
    await conn.execute('delete from grids');
    for (const [i, [caption, from, to]] of rows.entries()) {
      await conn.execute(`
        insert into grids (id, no, caption, hour_from, hour_to, duration, creation_date, created_by, last_update_date, last_updated_by)
        values (main_seq.nextval, :no, :caption, :hf, :ht, 1, sysdate, user, sysdate, user)`,
      { no: i + 1, caption: caption || null, hf: from || null, ht: to || null });
    }
  });
  return { count: rows.length };
}

// --- opis okna dla przeglądarki ------------------------------------------------------------

async function meta(s, e, type) {
  const flags = await plannerFlags(s);
  const lengths = await columnLengths(s, e.table);
  const hierarchyOn = e.noHierarchy ? false : e.hierarchyParam ? (await systemParam(s, e.hierarchyParam, '-')) === '+' : true;
  const fieldLabel = c => (e.fields.find(f => f.name === c) || {}).label || ((e.extra || {})[c] || {}).label || COMMON_LABELS[c] || c;
  return {
    type, title: e.title, one: e.one,
    canInsert: !flags.integrated, canDelete: !flags.integrated,
    hierarchy: hierarchyOn ? HIERARCHY_KINDS.map(([code, name]) => ({ code, name })) : null,
    filter: e.filter ? { name: e.filter.name, label: e.filter.label, lookup: e.filter.lookup } : null,
    toggle: e.toggle ? { label: e.toggle.label } : null,
    hasOrg: !!orgCol(e), admin: flags.admin,
    presets: e.table === 'grids' ? Object.entries(GRID_PRESETS).map(([code, p]) => ({ code, label: p.label })) : null,
    fields: e.fields.map(f => ({ ...f, type: f.type || 'text', max: lengths[f.name] || null })),
    columns: e.columns.map(c => ({ name: c, label: fieldLabel(c), type: (e.fields.find(f => f.name === c) || {}).type || 'text' })),
  };
}

async function lookup(s, name, url) {
  const l = LOOKUPS[name];
  if (!l) throw httpError(404, 'Nieznany słownik.');
  if (l.values) return l.values;
  const binds = {};
  const q = searchFilter(l.search, url.searchParams.get('q'), binds);
  const rows = await db.query(s.pool, `select * from (${l.list.replace('%Q', q)}) where rownum <= 200`, binds);
  return rows.map(r => ({ code: r.CODE, name: r.NAME }));
}

// --- routing /api/browse/... ---------------------------------------------------------------

async function handle(req, res, s, url, readJson, send) {
  const m = url.pathname.match(/^\/api\/(?:browse\/(L|G|S|SUB|FOR|PER|GRID)(?:\/(meta|generate|\d+)(?:\/(hierarchy)(?:\/(\d+))?)?)?|lookup\/([A-Z_]+))$/);
  if (!m) return false;
  const [, type, idOrMeta, sub, strId, lookupName] = m;
  try {
    if (lookupName) return send(res, 200, await lookup(s, lookupName, url)), true;
    const e = ENTITIES[type];
    const id = idOrMeta && /^\d+$/.test(idOrMeta) ? Number(idOrMeta) : null;
    const M = req.method;
    if (idOrMeta === 'meta' && M === 'GET') send(res, 200, await meta(s, e, type));
    else if (idOrMeta === 'generate' && type === 'GRID' && M === 'POST') send(res, 200, await generateGrid(s, await readJson(req)));
    else if (!idOrMeta && M === 'GET') send(res, 200, await list(s, e, url));
    else if (!idOrMeta && M === 'POST') send(res, 200, await insert(s, e, (await readJson(req)).values));
    else if (id && !sub && M === 'GET') send(res, 200, await getRecord(s, e, id));
    else if (id && !sub && M === 'PUT') send(res, 200, await update(s, e, id, (await readJson(req)).values));
    else if (id && !sub && M === 'DELETE') { await remove(s, e, id); send(res, 200, { ok: true }); }
    else if (id && sub && !strId && M === 'GET') send(res, 200, await hierarchy(s, e, id, url.searchParams.get('kind')));
    else if (id && sub && !strId && M === 'POST') send(res, 200, await addHierarchy(s, e, id, await readJson(req)));
    else if (id && sub && strId && M === 'DELETE') { await removeHierarchy(s, e, id, Number(strId)); send(res, 200, { ok: true }); }
    else send(res, 405, { error: 'Niedozwolona operacja.' });
  } catch (err) {
    if (err.status) send(res, err.status, { error: err.message });
    else if (err.errorNum) send(res, 400, { error: db.writeErrorMessage(err) });
    else throw err;
  }
  return true;
}

module.exports = { handle, ENTITIES };
