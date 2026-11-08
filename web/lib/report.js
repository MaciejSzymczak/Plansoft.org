// Okno "Raportowanie" - jak TFGrouping (UFGrouping.pas): zestawienie godzin zajęć z podziałem na wybrane kolumny
// (dni, godziny, wykładowcy, grupy, zasoby, przedmioty, formy, jednostki, opisy, ...), z filtrami jak "Wyszukaj wg"
// i porządkowaniem wg numerów kolumn. Zapytanie budowane tak samo jak w BRefreshClick; wartości filtrów jako binds.
'use strict';
const db = require('./db');
const { POLISH } = require('./search');
const { withChildsAndParents } = require('./addClasses');

const MAX_ROWS = 20000;
const httpError = (status, message) => Object.assign(new Error(message), { status });
const plaId = s => s.roleId || s.plannerId;
const ids = list => [...new Set((Array.isArray(list) ? list : String(list || '').split(/[;,]/)).map(Number).filter(n => Number.isInteger(n) && n > 0))];
const upperNoPolish = t => String(t || '').toUpperCase().replace(/[ĄĆĘŁŃÓŚŹŻ]/g, c => POLISH[c]);

// --- podzapytania wykładowców / grup / zasobów: zagregowane (jedna linia na zajęcie) lub "każdy w oddzielnej linii" ---
// (sqlLecturers_aggr / sqlLecturers_no_aggr itd. w UFGrouping.dfm; LISTAGG zamiast kolumn v1..v20)
const SQL_L_AGGR = `
  select listagg(title||' '||first_name||' '||last_name, ';' on overflow truncate) within group (order by lec_id) full_name
       , listagg(o.name, ';' on overflow truncate) within group (order by lec_id) orguni
       , cla_id id
    from lec_cla, lecturers, org_units o
   where lec_cla.lec_id = lecturers.id and o.id(+) = lecturers.orguni_id and lec_cla.is_child = 'N'
     and %conl and %cong and %conr
   group by cla_id`;
const SQL_L_LINES = `
  select title||' '||first_name||' '||last_name full_name, title, first_name, last_name, o.name orguni, lec_cla.cla_id id
       , lec_cla.desc1 ldesc1, lec_cla.desc2 ldesc2, lec_cla.desc3 ldesc3, lec_cla.desc4 ldesc4
       , (count(1) over (partition by cla_id order by cla_id)) lcount, lecturers.integration_id
    from lec_cla, lecturers, org_units o
   where lec_cla.lec_id = lecturers.id and lec_cla.is_child = 'N' and o.id(+) = lecturers.orguni_id`;
const SQL_G_AGGR = `
  select cla_id id
       , listagg(nvl(g.name, g.abbreviation), ';' on overflow truncate) within group (order by gro_id) group_name
       , listagg(substr(meaning, 1, 50), ';' on overflow truncate) within group (order by gro_id) group_type_dsp
       , listagg(gou.name, ';' on overflow truncate) within group (order by gro_id) orguni
       , sum(to_number(number_of_peoples)) nop
       , 'Aby zobaczyć grupy nadrzędne przejdź do widoku: każda grupa w oddzielnej linii' parent_group
    from groups g, gro_cla c, org_units gou, lookups l
   where g.id = c.gro_id and g.orguni_id = gou.id(+) and l.lookup_type(+) = 'GROUP_TYPE' and l.code(+) = g.group_type
     and c.is_child = 'N' and %conl and %cong and %conr
   group by cla_id`;
const SQL_G_LINES = `
  select cla_id id, to_number(number_of_peoples) nop, substr(meaning, 1, 50) group_type_dsp, gou.name orguni
       , nvl(g.name, g.abbreviation) group_name
       , (select listagg(gg.abbreviation, '; ') within group (order by gg.abbreviation) from str_elems se, groups gg
           where se.parent_id = gg.id and se.child_id = g.id) parent_group
       , (count(1) over (partition by cla_id order by cla_id)) gcount, g.integration_id
    from groups g, gro_cla c, org_units gou, lookups l
   where g.id = c.gro_id and g.orguni_id = gou.id(+) and l.lookup_type(+) = 'GROUP_TYPE' and l.code(+) = g.group_type and c.is_child = 'N'`;
const SQL_R_AGGR = `
  select cla_id id
       , listagg(g.name||' '||g.attribs_01, ';' on overflow truncate) within group (order by rom_id) res_name
       , listagg(gou.name, ';' on overflow truncate) within group (order by rom_id) orguni
    from rooms g, rom_cla c, org_units gou
   where g.id = c.rom_id and g.orguni_id = gou.id(+) and c.is_child = 'N' and %conl and %cong and %conr
   group by cla_id`;
const SQL_R_LINES = `
  select cla_id id, gou.name orguni, g.name||' '||g.attribs_01 res_name
       , (count(1) over (partition by cla_id order by cla_id)) rcount, g.integration_id
    from rooms g, rom_cla c, org_units gou
   where g.id = c.rom_id and g.orguni_id = gou.id(+) and c.is_child = 'N'`;

// "Dowolna fraza" (fastQueryString): wykładowcy, grupy, zasoby, przedmioty, formy, opisy zajęcia
const GENERIC_FILTER = `(
classes.id in (select cla_id from lec_cla where lec_id in (select m.id from lecturers m, org_units o where m.ORGUNI_ID = o.id(+) and (xxmsz_tools.erasePolishChars(upper(o.name||m.abbreviation||m.title||m.first_name||m.last_name||m.email|| m.attribs_01||m.attribs_02||m.attribs_03||m.attribs_04||m.attribs_05||m.attribs_06||m.attribs_07||m.attribs_08||m.attribs_09||m.attribs_10||m.attribs_11||m.attribs_12||m.attribs_13||m.attribs_14||m.attribs_15||m.desc1||m.desc2)) like :gq))) OR
classes.id in (select cla_id from gro_cla where gro_id in (select m.id from groups m, org_units o where m.ORGUNI_ID = o.id(+) and (xxmsz_tools.erasePolishChars(upper(o.name||m.name||m.abbreviation||m.email||m.desc1||m.desc2||m.attribs_01||m.attribs_02||m.attribs_03||m.attribs_04||m.attribs_05||m.attribs_06||m.attribs_07||m.attribs_08||m.attribs_09||m.attribs_10||m.attribs_11||m.attribs_12||m.attribs_13||m.attribs_14||m.attribs_15)) like :gq ))) OR
classes.id in (select cla_id from rom_cla where rom_id in (select m.id from rooms m, org_units o where m.ORGUNI_ID = o.id(+) and (xxmsz_tools.erasePolishChars(upper(o.name||m.name||m.desc1||m.desc2||m.attribs_01||m.email|| m.attribs_01||m.attribs_02||m.attribs_03||m.attribs_04||m.attribs_05||m.attribs_06||m.attribs_07||m.attribs_08||m.attribs_09||m.attribs_10||m.attribs_11||m.attribs_12||m.attribs_13||m.attribs_14||m.attribs_15)) like :gq))) OR
(CLASSES.SUB_ID in (select m.id from subjects m, org_units o where m.ORGUNI_ID = o.id(+) and (xxmsz_tools.erasePolishChars(upper(o.name||m.abbreviation||m.desc1||m.desc2||m.name|| m.attribs_01||m.attribs_02||m.attribs_03||m.attribs_04||m.attribs_05||m.attribs_06||m.attribs_07||m.attribs_08||m.attribs_09||m.attribs_10||m.attribs_11||m.attribs_12||m.attribs_13||m.attribs_14||m.attribs_15)) like :gq ))) OR
(CLASSES.FOR_ID in (select m.id from forms m where (xxmsz_tools.erasePolishChars(upper(m.abbreviation||m.desc1||m.desc2||m.name||m.attribs_01||m.attribs_02||m.attribs_03||m.attribs_04||m.attribs_05||m.attribs_06||m.attribs_07||m.attribs_08||m.attribs_09||m.attribs_10||m.attribs_11||m.attribs_12||m.attribs_13||m.attribs_14||m.attribs_15)) like :gq ))) OR
(xxmsz_tools.erasePolishChars(upper(CLASSES.DESC1)) like :gq) OR
(xxmsz_tools.erasePolishChars(upper(CLASSES.DESC2)) like :gq) OR
(xxmsz_tools.erasePolishChars(upper(CLASSES.DESC3)) like :gq) OR
(xxmsz_tools.erasePolishChars(upper(CLASSES.DESC4)) like :gq)
)`;

// sql_FOR_SEARCH (DM.pas): pole "Forma/ rez." jest frazą
const FOR_SEARCH = `(xxmsz_tools.erasePolishChars(upper(forms.abbreviation||forms.name||forms.attribs_01||forms.attribs_02||forms.attribs_03||forms.attribs_04
  ||forms.attribs_05||forms.attribs_06||forms.attribs_07||forms.attribs_08||forms.attribs_09||forms.attribs_10||forms.attribs_11||forms.attribs_12||forms.attribs_13||forms.attribs_14||forms.attribs_15
  ||forms.desc1||forms.desc2||'#'||forms.integration_id||'#')) like :fq)`;

// --- warunki okresu: zakres dat, liczba godzin, dni tygodnia (getWhereClausefromPeriod) i ukryte tygodnie (getWeekVisibilityClause)
async function periodClause(s, perId, binds) {
  const p = (await db.query(s.pool, `
    select to_char(date_from, 'YYYY-MM-DD') date_from, to_char(date_to, 'YYYY-MM-DD') date_to, hours_per_day,
           show_mon, show_tue, show_wed, show_thu, show_fri, show_sat, show_sun, attribs_13
      from periods where id = :id`, { id: perId }))[0];
  if (!p) throw httpError(404, 'Nie znaleziono okresu.');
  binds.pfrom = p.DATE_FROM; binds.pto = p.DATE_TO; binds.phours = p.HOURS_PER_DAY;
  let clause = `(classes.day between to_date(:pfrom, 'YYYY-MM-DD') and to_date(:pto, 'YYYY-MM-DD') and classes.hour <= :phours`;
  const days = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'].map((d, i) => (p['SHOW_' + d] === '+' ? i + 1 : 0)).filter(Boolean);
  if (days.length && days.length < 7) clause += ` and (1+trunc(classes.day)-trunc(classes.day, 'IW')) in (${days.join(',')})`;
  clause += ')';
  // ukryte tygodnie (ATTRIBS_13: '-' = tydzień ukryty, wzorzec powtarzany)
  let vis = p.ATTRIBS_13 || '+';
  if (vis.includes('-')) {
    while (vis.length < 120) vis += vis;
    const start = new Date(p.DATE_FROM + 'T00:00:00Z');
    start.setUTCDate(start.getUTCDate() - ((start.getUTCDay() + 6) % 7));
    const iso = (d, n) => { const x = new Date(d); x.setUTCDate(x.getUTCDate() + n); return x.toISOString().slice(0, 10); };
    const hidden = [];
    [...vis].forEach((ch, i) => { if (ch === '-') hidden.push(`(classes.day between date '${iso(start, i * 7)}' and date '${iso(start, i * 7 + 6)}')`); });
    if (hidden.length) clause += ` and not (${hidden.join(' or ')})`;
  }
  return clause;
}

// zajęcia wykładowców / grup / zasobów wraz z nadrzędnymi, podrzędnymi i wykluczeniami (GetCLASSESforL, tryb 'e')
async function resourceClause(s, table, col, list, colName) {
  if (!list.length) return '0=0';
  const all = await withChildsAndParents(s, list);
  return `${colName} in (select cla_id from ${table} where is_child = 'N' and ${col} in (${all.map(Number).join(',')}))`;
}

// porządkowanie: numery kolumn oddzielone przecinkami (np. "1, 3 desc"), jak pole "Porządkowanie danych wg"
function orderBy(text, count) {
  const parts = String(text || '1').replace(/- /g, ',').replace(/[;.]/g, ',').split(',').map(x => x.trim()).filter(Boolean);
  for (const p of parts) {
    const m = p.match(/^(\d+)(\s+(asc|desc))?$/i);
    if (!m || +m[1] < 1 || +m[1] > count) throw httpError(400, 'Błędna wartość w polu "porządkowanie danych wg"');
  }
  return 'order by ' + (parts.length ? parts.join(', ') : '1');
}

// o: opcje okna (kolumny, filtry, porządkowanie, opcje); zwraca { columns, rows, sql }
async function run(s, o, settings) {
  const cols = [];      // [label, wyrażenie select, wyrażenie group by | null]
  const add = (label, expr, group = expr) => cols.push([label, expr, group]);
  const desc = n => (settings.descPlural[n - 1] || `Opis ${n}`);
  const descL = n => (settings.descSingular[n - 1] || `Opis ${n}`);
  const report = o.report || null;   // LEC_UTILIZATION / STUDENTHOURS: stały układ jak generateReport

  if (o.day) add('Dzień', `to_char(classes.day, 'YYYY-MM-DD')`);
  if (o.month) add('Miesiąc', `to_char(classes.day, 'YYYY-MM')`);
  if (o.dayOfWeek) add('Dzień tyg.', `to_char(classes.day, 'dy', 'NLS_DATE_LANGUAGE=polish')`);
  if (o.hour) add('Godzina', 'grids.caption');
  if (o.createdBy) add('Utworzył', 'classes.created_by');
  if (o.owner) add('Właściciel', 'classes.owner');
  if (o.creationDate) add('Data utworzenia', `to_char(classes.creation_date, 'YYYY-MM-DD HH24:MI')`, 'classes.creation_date');

  if (o.L) {
    if (o.LnewLine) {
      add('Tytuł', 'lecturers.title'); add('Imię', 'lecturers.first_name'); add('Nazwisko', 'lecturers.last_name');
      if (o.integrationId) add('LEC Integration Id', 'lecturers.integration_id');
    } else {
      if (report) add('Wykładowcy-skróty', 'classes.calc_lecturers');
      add('Wykładowcy', 'substr(lecturers.full_name, 1, 500)');
    }
  }
  if (o.G) {
    add('Grupy', 'substr(groups.group_name, 1, 500)');
    if (o.integrationId && o.GnewLine) add('GRO Integration Id', 'groups.integration_id');
  }
  if (o.R) {
    add('Zasoby', 'substr(resources.res_name, 1, 500)');
    if (o.integrationId && o.RnewLine) add('RES Integration Id', 'resources.integration_id');
  }
  for (const n of [1, 2, 3, 4]) if (o['desc' + n]) add(desc(n), 'classes.desc' + n);
  if (o.fill) add('Wypełnienie', 'classes.fill');
  if (o.S) {
    add('Przedmioty', 'sub.name');
    if (o.integrationId) add('SUB Integration Id', 'sub.integration_id');
  }
  if (o.F && (!o.FnewColumn || report)) add('Formy', 'frm.name');
  if (o.Luni) add('Jednostka wykładowcy', 'lecturers.orguni');
  if (o.Gparent) add('Grupy nadrzędne', 'groups.parent_group');
  if (o.Gorg) add('Jednostka grupy', 'groups.orguni');
  if (o.Sorg) add('Jednostka przedmiotu', 'sou.name');
  if (o.Rorg) add('Jednostka zasobu', 'resources.orguni');
  if (o.Gtype) add('Typ grupy', 'groups.group_type_dsp');

  const lx = o.L || o.Luni;
  const gx = o.G || o.Gtype || o.Gstudents || o.Gorg || o.Gparent;
  const rx = o.R || o.Rorg;
  if (o.LnewLine && lx) {
    for (const n of [1, 2, 3, 4]) if (o['ldesc' + n]) add(descL(n), 'lecturers.ldesc' + n);
    if (o.Lcount) add('Liczba wykładowców', 'lecturers.lcount');
  }
  if (o.GnewLine && gx && o.Gcount) add('Liczba grup', 'groups.gcount');
  if (o.RnewLine && rx && o.Rcount) add('Liczba zasobów', 'resources.rcount');

  const emergency = !!o.emergency && !report;
  const binds = {};
  // formy w oddzielnych kolumnach (ChFnewColumn): suma godzin każdej formy pasującej do frazy "Forma/ rez."
  const sums = [];
  if (o.F && o.FnewColumn && !report) {
    const fb = { fq: `%${upperNoPolish(o.formPhrase || '').trim()}%` };
    const forms = await db.query(s.pool, `select id, substrb(name, 1, 30) name from forms where ${FOR_SEARCH} order by sort_order_on_reports, name`, fb);
    for (const f of forms) {
      const e = `decode(frm.id, ${Number(f.ID)}, 1, 0) * grids.duration * (classes.fill / 100)`;
      sums.push([f.NAME, emergency ? e : `sum(${e})`]);
    }
  }
  sums.push(['Zajęcia (suma)', emergency ? 'round(grids.duration * (classes.fill / 100), 2)' : 'round(sum(grids.duration * (classes.fill / 100)), 2)']);
  if (o.Gstudents) sums.push(['Liczba studentów', 'groups.nop']);

  if (!cols.length) add('Wszystko', `'Wszystko'`);
  const groupBy = [...cols.map(c => c[2]), ...(o.Gstudents ? ['groups.nop'] : [])];
  const selectCols = cols;

  // --- filtry (Wyszukaj wg) ---------------------------------------------------------------
  const where = [];
  const per = Number(o.period) || null;
  if (per) where.push(await periodClause(s, per, binds));
  where.push(await resourceClause(s, 'lec_cla', 'lec_id', ids(o.lec), 'classes.id'));
  where.push(await resourceClause(s, 'gro_cla', 'gro_id', ids(o.gro), 'classes.id'));
  where.push(await resourceClause(s, 'rom_cla', 'rom_id', ids(o.rom), 'classes.id'));
  const sub = ids(o.sub);
  if (sub.length) where.push(`classes.sub_id in (${sub.join(',')})`);
  if (String(o.formPhrase || '').trim()) {
    binds.fq = `%${upperNoPolish(o.formPhrase).trim()}%`;
    where.push(`classes.for_id in (select id from forms where ${FOR_SEARCH})`);
  }
  if (o.createdFrom && /^\d{4}-\d{2}-\d{2}$/.test(o.createdFrom)) { binds.cfrom = o.createdFrom; where.push(`classes.creation_date >= to_date(:cfrom, 'YYYY-MM-DD')`); }
  if (o.createdTo && /^\d{4}-\d{2}-\d{2}$/.test(o.createdTo)) { binds.cto = o.createdTo; where.push(`classes.creation_date < to_date(:cto, 'YYYY-MM-DD') + 1`); }
  if (String(o.createdByPhrase || '').trim()) { binds.cby = `%${String(o.createdByPhrase).trim().toUpperCase()}%`; where.push('upper(classes.created_by) like :cby'); }
  if (!o.showAll) {
    // uprawnienia: tylko zajęcia obiektów, do których planista ma dostęp (getWhereClause)
    binds.pla = plaId(s);
    where.push(`classes.id in ((select cla_id from lec_cla where lec_id in (select lec_id from lec_pla where pla_id = :pla)) union all select id from classes where calc_lec_ids is null)`);
    where.push(`classes.id in ((select cla_id from gro_cla where gro_id in (select gro_id from gro_pla where pla_id = :pla)) union all select id from classes where calc_gro_ids is null)`);
    where.push(`classes.id in ((select cla_id from rom_cla where rom_id in (select rom_id from rom_pla where pla_id = :pla)) union all select id from classes where calc_rom_ids is null)`);
    where.push(`(classes.sub_id in (select sub_id from sub_pla where pla_id = :pla) or classes.sub_id is null)`);
    where.push(`(classes.for_id in (select for_id from for_pla where pla_id = :pla) or classes.for_id is null)`);
  }
  if (String(o.phrase || '').trim()) { binds.gq = `%${upperNoPolish(o.phrase).trim()}%`; where.push(GENERIC_FILTER); }
  // "Terminy zaznaczone w siatce"
  if (o.selectedDates) {
    const cells = (o.cells || []).filter(c => /^\d{4}-\d{2}-\d{2}$/.test(c.date) && Number.isInteger(c.hour)).slice(0, 1000);
    if (!cells.length) throw httpError(400, 'Zaznacz terminy w siatce (opcja "Terminy zaznaczone w siatce").');
    where.push(`(classes.day, classes.hour) in (${cells.map((c, i) => { binds['sd' + i] = c.date; binds['sh' + i] = c.hour; return `(to_date(:sd${i}, 'YYYY-MM-DD'), :sh${i})`; }).join(', ')})`);
  }

  const lSql = o.LnewLine ? SQL_L_LINES : SQL_L_AGGR;
  const gSql = o.GnewLine ? SQL_G_LINES : SQL_G_AGGR;
  const rSql = o.RnewLine ? SQL_R_LINES : SQL_R_AGGR;
  const inner = async sql => sql
    .replace('%conl', await resourceClause(s, 'lec_cla', 'lec_id', ids(o.lec), 'cla_id'))
    .replace('%cong', await resourceClause(s, 'gro_cla', 'gro_id', ids(o.gro), 'cla_id'))
    .replace('%conr', await resourceClause(s, 'rom_cla', 'rom_id', ids(o.rom), 'cla_id'));

  const selectList = [...selectCols.map((c, i) => `${c[1]} c${i}`), ...sums.map((x, i) => `${x[1]} s${i}`)];
  const order = report
    ? 'order by ' + selectCols.map((c, i) => [c, i]).filter(([c]) => ['Wykładowcy', 'Grupy', 'Przedmioty', 'Formy'].includes(c[0])).map(([, i]) => `c${i}`).join(', ')
    : orderBy(o.sortOrder, selectList.length);
  const sql = `
select * from (
  select ${selectList.join('\n       , ')}
    from classes, grids, subjects sub, org_units sou, forms frm
         ${lx ? `, (${await inner(lSql)}) lecturers` : ''}
         ${gx ? `, (${await inner(gSql)}) groups` : ''}
         ${rx ? `, (${await inner(rSql)}) resources` : ''}
   where ${lx ? 'lecturers.id(+) = classes.id' : '0=0'}
     and ${gx ? 'groups.id(+) = classes.id' : '0=0'}
     and ${rx ? 'resources.id(+) = classes.id' : '0=0'}
     and classes.for_id = frm.id and sub.id(+) = classes.sub_id and classes.hour = grids.no
     and classes.owner <> 'AUTO' and sub.orguni_id = sou.id(+)
     and ${where.join('\n     and ')}
   ${emergency ? '' : 'group by ' + groupBy.join(', ')}
   ${order})
 where rownum <= ${MAX_ROWS + 1}`;

  let rows;
  try {
    rows = await db.query(s.pool, sql, binds);
  } catch (e) {
    if (/ORA-0(0933|0904|1785)/.test(e.message)) throw httpError(400, 'Błędna wartość w polu "porządkowanie danych wg"');
    throw httpError(400, 'Wystąpił błąd podczas wykonywania zapytania: ' + String(e.message).split('\n')[0]);
  }
  const truncated = rows.length > MAX_ROWS;
  if (truncated) rows.length = MAX_ROWS;
  const columns = [...selectCols.map(c => c[0]), ...sums.map(x => x[0])];
  const keys = [...selectCols.map((c, i) => 'C' + i), ...sums.map((x, i) => 'S' + i)];
  return {
    columns, truncated,
    numeric: [...selectCols.map(() => false), ...sums.map(() => true)],
    rows: rows.map(r => keys.map(k => (r[k] instanceof Date ? r[k].toISOString().slice(0, 10) : r[k] ?? null))),
    sql: o.showSql ? sql.trim() : undefined,
  };
}

// ustawienia potrzebne do nazw kolumn (opisy zajęcia)
async function settingsOf(s) {
  const p = await db.query(s.pool, `select name, value from system_parameters where name like 'CLASS_DESC%'`);
  const v = Object.fromEntries(p.map(r => [r.NAME, r.VALUE]));
  return {
    descPlural: [1, 2, 3, 4].map(i => v['CLASS_DESC' + i] || ''),
    descSingular: [1, 2, 3, 4].map(i => v['CLASS_DESC' + i + 'S'] || v['CLASS_DESC' + i] || ''),
  };
}

// raporty "Obciążenie wykładowcy" i "Studentogodziny" (generateReport): wiersze do zestawienia w Excelu
async function special(s, o) {
  const reportOpts = {
    ...o, report: o.report, L: true, G: true, S: true, F: true, FnewColumn: true, Lcount: true, Gcount: true, Rcount: true,
    Gstudents: o.report === 'STUDENTHOURS', day: false, month: false, dayOfWeek: false, hour: false, createdBy: false, owner: false,
    creationDate: false, R: false, fill: false, Luni: false, Gorg: false, Gparent: false, Sorg: false, Rorg: false, Gtype: false,
    LnewLine: false, GnewLine: false, RnewLine: false, selectedDates: false, integrationId: false,
    desc1: false, desc2: false, desc3: false, desc4: false, emergency: false,
  };
  const data = await run(s, reportOpts, await settingsOf(s));
  const forms = (await db.query(s.pool, `select name from forms where kind = 'C' and sort_order_on_reports is not null order by sort_order_on_reports, name`)).map(r => r.NAME);
  return { ...data, forms };
}

async function handle(req, res, s, url, readJson, send) {
  if (url.pathname !== '/api/report' || req.method !== 'POST') return false;
  try {
    const o = await readJson(req);
    send(res, 200, o.report ? await special(s, o) : await run(s, o, await settingsOf(s)));
  } catch (err) {
    if (err.status) send(res, err.status, { error: err.message });
    else throw err;
  }
  return true;
}

module.exports = { handle };
