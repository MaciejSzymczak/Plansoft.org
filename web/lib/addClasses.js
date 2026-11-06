// Dodawanie zajęć do zaznaczonych terminów siatki - jak TFMain.insertClasses / TCheckConflicts w Delphi:
// sprawdzenie danych i uprawnień (FDetails.FormCloseQuery), wyszukanie konfliktów z uwzględnieniem hierarchii
// i wykluczeń (getChildsAndParents, DBGetClassByLGR), doplanowanie, usunięcie kolidujących zajęć (api.delete_class)
// i wstawienie (planner_utils.insert_classes).
'use strict';
const db = require('./db');

const MAX_CELLS = 2000;
const plaId = s => s.roleId || s.plannerId;
const httpError = (status, message) => Object.assign(new Error(message), { status });
const ids = list => [...new Set((list || []).map(Number).filter(n => Number.isInteger(n) && n > 0))];
const inList = (prefix, values, binds) => values.map((v, i) => { binds[prefix + i] = v; return ':' + prefix + i; }).join(',');
const isoDate = v => /^\d{4}-\d{2}-\d{2}$/.test(v || '');

async function plannerFlags(s) {
  const r = (await db.query(s.pool,
    `select can_insert, can_delete, is_admin from planners where id = :id`, { id: s.plannerId }))[0] || {};
  return { canInsert: r.CAN_INSERT === '+', canDelete: r.CAN_DELETE === '+' };
}

// obiekty bez uprawnień XXX_PLA (jak HasPermissionX/PermissionDetails w FDetails)
async function missingPermissions(s, table, col, list) {
  if (!list.length) return [];
  const binds = { pla: plaId(s) };
  const granted = new Set((await db.query(s.pool,
    `select ${col} id from ${table} where pla_id = :pla and ${col} in (${inList('i', list, binds)})`, binds)).map(r => r.ID));
  const missing = list.filter(id => !granted.has(id));
  if (!missing.length) return [];
  const b2 = {};
  const names = new Map((await db.query(s.pool, `select id, name from resources where id in (${inList('m', missing, b2)})`, b2)).map(r => [r.ID, r.NAME]));
  return missing.map(id => names.get(id) || `#${id} (nie istnieje)`);
}

// zasoby z nadrzędnymi, podrzędnymi (potok) i wykluczeniami - jak getChildsAndParents(..., normalMode=true)
async function withChildsAndParents(s, list) {
  const out = new Set(list);
  for (const id of list) {
    const rows = await db.query(s.pool, `
      select unique id from (
        select parent_id id from str_elems_v
         where level = 1 and str_name_lov = 'STREAM'
         connect by prior str_name_lov = 'STREAM' and prior parent_id = child_id
         start with child_id = :id1
        union
        select child_id id from str_elems_v
         where level = 1 and str_name_lov = 'STREAM'
         connect by prior str_name_lov = 'STREAM' and prior child_id = parent_id
         start with parent_id = :id2
        union
        select res_id_excluded from exclusions where res_id = :id3)`, { id1: id, id2: id, id3: id });
    rows.forEach(r => { if (r.ID) out.add(r.ID); });
  }
  return [...out];
}

// czy bieżący planista jest właścicielem (lub przełożonym właściciela) zajęcia - isOwner w UUtilities.pas
async function ownerCheck(s) {
  const user = s.user.toUpperCase();
  const roleName = s.roleId ? ((s.roles.find(r => r.id === s.roleId) || {}).name || '').toUpperCase() : '**NONE**';
  const supervisors = {};
  for (const r of await db.query(s.pool, `select upper(name) name, upper(parent) parent from planners`)) supervisors[r.NAME] = r.PARENT || '';
  return owners => {
    const list = String(owners || '').toUpperCase();
    if ((';' + list).includes(';' + user)) return true;
    return list.split(';').map(o => o.trim()).filter(Boolean).some(o => {
      const sup = ';' + (supervisors[o] || '') + ';';
      return sup.includes(';' + user + ';') || sup.includes(';' + roleName + ';');
    });
  };
}

const splitIds = v => String(v || '').split(';').map(Number).filter(n => n > 0);
const subset = (a, b) => a.every(x => b.includes(x));

async function add(s, body) {
  const flags = await plannerFlags(s);
  if (!flags.canInsert) throw httpError(403, 'Nie możesz wstawiać zajęć.');

  // --- dane z okna (FDetails) -----------------------------------------------------------------
  const kind = body.kind === 'R' ? 'R' : 'C';
  const lec = ids(body.lec), gro = ids(body.gro), rom = ids(body.rom);
  const sub = kind === 'C' ? Number(body.sub) || null : null;
  const form = Number(body.form) || null;
  const fill = Math.round(Number(body.fill ?? 100));
  const colour = /^#[0-9a-f]{6}$/i.test(body.colour || '') ? (n => ((n & 255) << 16) | (n & 0xff00) | (n >> 16))(parseInt(body.colour.slice(1), 16)) : null;
  const owner = String(body.owner || s.user).trim() || s.user;
  const desc = [0, 1, 2, 3].map(i => (body.desc && body.desc[i] ? String(body.desc[i]).slice(0, 4000) : null));
  const errors = [];
  if (kind === 'C' && !sub) errors.push('Przedmiot musi zostać wybrany.');
  if (!form) errors.push(kind === 'C' ? 'Forma zajęć musi zostać wybrana.' : 'Rezerwacja musi zostać wybrana.');
  if (!(fill >= 1 && fill <= 100)) errors.push('Wypełnienie musi być liczbą od 1 do 100.');
  if (!lec.length && !gro.length && !rom.length) errors.push('Wybierz wykładowcę, grupę lub salę.');
  if (form) {
    const f = await db.query(s.pool, `select kind from forms where id = :id and id in (select for_id from for_pla where pla_id = :pla)`, { id: form, pla: plaId(s) });
    if (!f.length) errors.push('Nie masz uprawnień do wybranej formy zajęć.');
    else if ((f[0].KIND || 'C') !== kind) errors.push(kind === 'C' ? 'Wybrana forma jest rodzajem rezerwacji.' : 'Wybrana pozycja nie jest rodzajem rezerwacji.');
  }
  for (const [list, table, col, what] of [[lec, 'lec_pla', 'lec_id', 'wykładowców'], [gro, 'gro_pla', 'gro_id', 'grup'], [rom, 'rom_pla', 'rom_id', 'zasobów']]) {
    const missing = await missingPermissions(s, table, col, list);
    if (missing.length) errors.push(`Nie masz uprawnień do planowania dla ${what}: ${missing.join(', ')}`);
  }

  // terminy: w okresie z uprawnieniami, w widocznych godzinach
  const per = (await db.query(s.pool, `
    select to_char(date_from, 'YYYY-MM-DD') date_from, to_char(date_to, 'YYYY-MM-DD') date_to, hours_per_day
      from periods where id = :id and id in (select per_id from per_pla where pla_id = :pla)`, { id: Number(body.period), pla: plaId(s) }))[0];
  if (!per) throw httpError(404, 'Nie znaleziono okresu lub brak uprawnień.');
  const seen = new Set();
  const cells = (body.cells || []).filter(c => isoDate(c.date) && Number.isInteger(c.hour) && c.hour >= 1 && c.hour <= per.HOURS_PER_DAY
    && c.date >= per.DATE_FROM && c.date <= per.DATE_TO && !seen.has(c.date + '|' + c.hour) && seen.add(c.date + '|' + c.hour));
  if (!cells.length) errors.push('Zaznacz w siatce terminy, do których chcesz dodać zajęcia.');
  if (cells.length > MAX_CELLS) errors.push(`Można dodać najwyżej ${MAX_CELLS} zajęć naraz.`);
  if (errors.length) throw httpError(400, errors.join('\n'));

  // --- przekroczenie pojemności sal (ostrzeżenie, jak canInsertClass) -------------------------
  let warning = null;
  if (gro.length && rom.length) {
    const b = {};
    const cap = (await db.query(s.pool, `
      select nvl(g - r, 0) over_cap from
        (select sum(nvl(number_of_peoples, 0)) g from groups where id in (${inList('g', gro, b)})),
        (select sum(nvl(attribn_01, 9999)) r from rooms where id in (${inList('r', rom, b)}))`, b))[0];
    if (cap && cap.OVER_CAP > 0) warning = `Liczność grup/y przekracza pojemność sal/i o ${cap.OVER_CAP}.`;
  }

  // --- konflikty we wszystkich terminach -------------------------------------------------------
  const examined = await withChildsAndParents(s, [...lec, ...gro, ...rom]);
  const conflicts = await findConflicts(s, examined, cells);
  const isOwner = await ownerCheck(s);
  const newClass = { lec, gro, rom, sub, form, owner: owner.toUpperCase(), createdBy: s.user.toUpperCase() };
  for (const c of conflicts) {
    // doplanowanie: istniejące zajęcie zawiera się w nowym (te same przedmiot, forma, autor i właściciel)
    c.completion = subset(splitIds(c.lecIds), lec) && subset(splitIds(c.groIds), gro) && subset(splitIds(c.romIds), rom)
      && (c.subId || null) === sub && c.forId === form && (c.createdBy || '').toUpperCase() === newClass.createdBy
      && (c.owner || '').toUpperCase() === newClass.owner && isOwner(c.owner);
    c.canDelete = isOwner(c.owner);
  }
  const real = conflicts.filter(c => !c.completion);
  const canDeleteAll = flags.canDelete && conflicts.every(c => c.canDelete);

  if (real.length && !body.confirm) {
    return { status: 'conflicts', conflicts: real.map(publicConflict), canDelete: canDeleteAll, warning, cells: cells.length };
  }
  if (conflicts.length && !flags.canDelete) throw httpError(403, 'Nie możesz usuwać zajęć - nie można usunąć kolidujących zajęć.');
  const foreign = conflicts.find(c => !c.canDelete);
  if (foreign) throw httpError(403, `Nie możesz zmieniać zajęć użytkownika ${foreign.owner}.`);

  // --- zapis: usunięcie kolizji i wstawienie zajęć w jednej transakcji ---------------------------
  try {
    await db.transaction(s.pool, async conn => {
      for (const id of [...new Set(conflicts.map(c => c.id))]) {
        await conn.execute('begin api.delete_class(:id); end;', { id });
      }
      for (const c of cells) {
        await conn.execute(`
          begin
            planner_utils.insert_classes(to_date(:day, 'YYYY-MM-DD'), :hour, :fill, :sub, :form, :owner, :lec, :gro, :rom, :col,
                                         :d1, :d2, :d3, :d4, null);
          end;`, {
          day: c.date, hour: c.hour, fill, sub, form, owner,
          lec: lec.join(';') || null, gro: gro.join(';') || null, rom: rom.join(';') || null, col: colour,
          d1: desc[0], d2: desc[1], d3: desc[2], d4: desc[3],
        });
      }
      await conn.execute('begin upsert_recently_used_class(:pla, :l, :g, :r, :s, :f); end;', {
        pla: String(plaId(s)), l: lec.join(';') || null, g: gro.join(';') || null, r: rom.join(';') || null,
        s: sub ? String(sub) : null, f: String(form),
      });
    });
  } catch (e) { throw writeError(e); }
  return { status: 'added', count: cells.length, replaced: conflicts.length, warning };
}

// zajęcia kolidujące w podanych terminach: wykładowcy (L), grupy (G), zasoby (S) - jak DBGetClassByLGR
async function findConflicts(s, examined, cells) {
  if (!examined.length) return [];
  const days = [...new Set(cells.map(c => c.date))];
  const hours = [...new Set(cells.map(c => c.hour))];
  const wanted = new Set(cells.map(c => c.date + '|' + c.hour));
  const found = new Map();   // cla_id -> powody L/G/S
  for (let i = 0; i < days.length; i += 300) {
    const binds = {};
    const res = inList('x', examined, binds), d = days.slice(i, i + 300).map((v, j) => { binds['d' + j] = v; return `to_date(:d${j}, 'YYYY-MM-DD')`; }).join(','), h = inList('h', hours, binds);
    const rows = await db.query(s.pool, `
      select 'L' t, cla_id, to_char(day, 'YYYY-MM-DD') day, hour from lec_cla where lec_id in (${res}) and no_conflict_flag is null and day in (${d}) and hour in (${h})
      union select 'G' t, cla_id, to_char(day, 'YYYY-MM-DD') day, hour from gro_cla where gro_id in (${res}) and no_conflict_flag is null and day in (${d}) and hour in (${h})
      union select 'S' t, cla_id, to_char(day, 'YYYY-MM-DD') day, hour from rom_cla where rom_id in (${res}) and no_conflict_flag is null and day in (${d}) and hour in (${h})`, binds);
    for (const r of rows) {
      if (!wanted.has(r.DAY + '|' + r.HOUR)) continue;
      const prev = found.get(r.CLA_ID) || '';
      if (!prev.includes(r.T)) found.set(r.CLA_ID, prev + r.T);
    }
  }
  const list = [...found.keys()];
  const out = [];
  for (let i = 0; i < list.length; i += 500) {
    const binds = {};
    const rows = await db.query(s.pool, `
      select cla.id, to_char(cla.day, 'YYYY-MM-DD') day, cla.hour, grids.caption hour_caption, cla.calc_lecturers, cla.calc_groups, cla.calc_rooms,
             cla.calc_lec_ids, cla.calc_gro_ids, cla.calc_rom_ids, cla.sub_id, cla.for_id, sub.name sub_name, frm.name for_name,
             cla.owner, cla.created_by
        from classes cla, subjects sub, forms frm, grids
       where sub.id(+) = cla.sub_id and frm.id(+) = cla.for_id and grids.no(+) = cla.hour and cla.id in (${inList('c', list.slice(i, i + 500), binds)})
       order by cla.day, cla.hour`, binds);
    for (const r of rows) out.push({
      id: r.ID, day: r.DAY, hour: r.HOUR, hourCaption: r.HOUR_CAPTION, lecturers: r.CALC_LECTURERS || '', groups: r.CALC_GROUPS || '',
      rooms: (r.CALC_ROOMS || '').trim(), lecIds: r.CALC_LEC_IDS, groIds: r.CALC_GRO_IDS, romIds: r.CALC_ROM_IDS,
      subId: r.SUB_ID, forId: r.FOR_ID, subject: r.SUB_NAME || '', form: r.FOR_NAME || '', owner: r.OWNER || '', createdBy: r.CREATED_BY || '',
      reason: found.get(r.ID),
    });
  }
  return out;
}

const publicConflict = c => ({
  id: c.id, day: c.day, hour: c.hour, hourCaption: c.hourCaption, lecturers: c.lecturers, groups: c.groups, rooms: c.rooms,
  subject: c.subject, form: c.form, owner: c.owner, reason: c.reason, canDelete: c.canDelete,
});

// błąd bazy przy zapisie zajęcia -> komunikat (jak planner_utils_insert_classes w UUtilities.pas)
function writeError(e) {
  if (e.status) return e;
  const msg = String(e.message || e);
  if (e.errorNum === 1) return httpError(409, 'Nie można zapisać zajęcia ze względu na konflikt (w międzyczasie ktoś mógł zaplanować zajęcia w tym terminie).\n\nSzczegóły: ' + msg.split('\n')[0]);
  if (/ORA-20050/.test(msg)) return httpError(409, 'Inny użytkownik właśnie modyfikuje dane, spróbuj za chwilę.');
  if (/ORA-20000/.test(msg)) return httpError(400, 'Nie można zapisać zajęcia:\n' + msg.split('\n')[0].replace(/^ORA-20000: /, ''));
  return httpError(500, 'Nie można zapisać zajęcia ze względu na nieoczekiwany błąd w bazie danych:\n' + msg.split('\n')[0]);
}

// --- przesuwanie i kopiowanie zajęć (przeciąganie myszą; jak modifyClass clMove/clCopy w UFMain.pas) ----
// body: { period, moves: [{ id, date, hour }], copy, confirm }
async function move(s, body) {
  const flags = await plannerFlags(s);
  const copy = !!body.copy;
  if (!flags.canInsert) throw httpError(403, 'Nie możesz wstawiać zajęć.');
  if (!copy && !flags.canDelete) throw httpError(403, 'Nie możesz usuwać zajęć - przesuwanie jest niedostępne (możesz kopiować z klawiszem Ctrl).');

  const per = (await db.query(s.pool, `
    select to_char(date_from, 'YYYY-MM-DD') date_from, to_char(date_to, 'YYYY-MM-DD') date_to, hours_per_day
      from periods where id = :id and id in (select per_id from per_pla where pla_id = :pla)`, { id: Number(body.period), pla: plaId(s) }))[0];
  if (!per) throw httpError(404, 'Nie znaleziono okresu lub brak uprawnień.');
  const moves = (body.moves || []).filter(m => Number(m.id) > 0).slice(0, MAX_CELLS);
  if (!moves.length) throw httpError(400, 'Nie wybrano zajęć do przesunięcia.');
  for (const m of moves) {
    if (!isoDate(m.date) || !Number.isInteger(m.hour) || m.hour < 1 || m.hour > per.HOURS_PER_DAY || m.date < per.DATE_FROM || m.date > per.DATE_TO)
      throw httpError(400, 'Nie można przesunąć tej komórki poza obszar planowania.');
  }

  // przesuwane zajęcia z bazy
  const binds = {};
  const rows = await db.query(s.pool, `
    select id, to_char(day, 'YYYY-MM-DD') day, hour, fill, sub_id, for_id, owner, created_by, colour,
           calc_lec_ids, calc_gro_ids, calc_rom_ids, desc1, desc2, desc3, desc4, calc_lecturers, calc_groups, calc_rooms
      from classes where id in (${inList('c', [...new Set(moves.map(m => Number(m.id)))], binds)})`, binds);
  const byId = new Map(rows.map(r => [r.ID, r]));
  const isOwner = await ownerCheck(s);
  const supervisorOnly = await supervisorCheck(s);
  const errors = [];
  const items = [];
  for (const m of moves) {
    const old = byId.get(Number(m.id));
    if (!old) { errors.push(`Zajęcie ${m.id} nie istnieje (odśwież siatkę).`); continue; }
    if (!copy && !isOwner(old.OWNER)) { errors.push(`Nie możesz zmieniać zajęć użytkownika ${old.OWNER}.`); continue; }
    items.push({
      old, date: m.date, hour: m.hour,
      // właściciel: zostaje, gdy przesuwający jest przełożonym właściciela; inaczej przesuwający
      owner: supervisorOnly(old.OWNER) ? old.OWNER : s.user.toUpperCase(),
      lec: splitIds(old.CALC_LEC_IDS), gro: splitIds(old.CALC_GRO_IDS), rom: splitIds(old.CALC_ROM_IDS),
    });
  }
  // uprawnienia do zasobów przesuwanych zajęć (hasResourcePermissions)
  const all = t => [...new Set(items.flatMap(i => i[t]))];
  for (const [list, table, col, what] of [[all('lec'), 'lec_pla', 'lec_id', 'wykładowców'], [all('gro'), 'gro_pla', 'gro_id', 'grup'], [all('rom'), 'rom_pla', 'rom_id', 'zasobów']]) {
    const missing = await missingPermissions(s, table, col, list);
    if (missing.length) errors.push(`Nie masz uprawnień do planowania dla ${what}: ${missing.join(', ')}`);
  }
  if (errors.length) throw httpError(400, [...new Set(errors)].join('\n'));
  const unchanged = items.every(i => i.date === i.old.DAY && i.hour === i.old.HOUR);
  if (unchanged) return { status: 'moved', count: 0 };

  // konflikty w nowych terminach; przesuwane zajęcia nie kolidują same ze sobą (zostaną usunięte przed wstawieniem)
  const movedIds = new Set(copy ? [] : items.map(i => i.old.ID));
  const conflicts = new Map();
  for (const i of items) {
    const examined = await withChildsAndParents(s, [...i.lec, ...i.gro, ...i.rom]);
    for (const c of await findConflicts(s, examined, [{ date: i.date, hour: i.hour }])) {
      if (movedIds.has(c.id)) continue;
      c.canDelete = isOwner(c.owner);
      conflicts.set(c.id, c);
    }
  }
  const real = [...conflicts.values()];
  const canDeleteAll = flags.canDelete && real.every(c => c.canDelete);
  if (real.length && !body.confirm) {
    return {
      status: 'conflicts', canDelete: canDeleteAll, conflicts: real.map(publicConflict),
      moving: items.map(i => ({
        day: i.date, hour: i.hour, from: `${i.old.DAY} godz. ${i.old.HOUR}`,
        lecturers: i.old.CALC_LECTURERS || '', groups: i.old.CALC_GROUPS || '', rooms: (i.old.CALC_ROOMS || '').trim(), owner: i.owner,
      })),
    };
  }
  if (real.length && !canDeleteAll) {
    const f = real.find(c => !c.canDelete);
    throw httpError(403, f ? `Nie możesz zmieniać zajęć użytkownika ${f.owner}.` : 'Nie możesz usuwać zajęć.');
  }

  try {
    await db.transaction(s.pool, async conn => {
      for (const c of real) await conn.execute('begin api.delete_class(:id); end;', { id: c.id });
      // kombinacje zasobów starych zajęć (tt_planner.get_tt_cla) - nie są sprawdzane ponownie, jak w Delphi
      for (const i of items) {
        try {
          i.tt = (await conn.execute('select tt_planner.get_tt_cla(:id) tt from dual', { id: i.old.ID })).rows[0].TT;
        } catch { i.tt = null; }
      }
      if (!copy) for (const i of items) await conn.execute('begin api.delete_class(:id); end;', { id: i.old.ID });
      for (const i of items) {
        const o = i.old;
        await conn.execute(`
          begin
            planner_utils.insert_classes(to_date(:day, 'YYYY-MM-DD'), :hour, :fill, :sub, :form, :owner, :lec, :gro, :rom, :col,
                                         :d1, :d2, :d3, :d4, :tt);
          end;`, {
          day: i.date, hour: i.hour, fill: o.FILL, sub: o.SUB_ID, form: o.FOR_ID, owner: i.owner,
          lec: o.CALC_LEC_IDS, gro: o.CALC_GRO_IDS, rom: o.CALC_ROM_IDS, col: o.COLOUR,
          d1: o.DESC1, d2: o.DESC2, d3: o.DESC3, d4: o.DESC4, tt: i.tt,
        });
      }
    });
  } catch (e) { throw writeError(e); }
  return { status: 'moved', count: items.length, copy, replaced: real.length };
}

// czy bieżący planista (lub jego aktywna rola) jest przełożonym właściciela - isOwnerSupervisor
async function supervisorCheck(s) {
  const user = s.user.toUpperCase();
  const roleName = s.roleId ? ((s.roles.find(r => r.id === s.roleId) || {}).name || '').toUpperCase() : '**NONE**';
  const supervisors = {};
  for (const r of await db.query(s.pool, `select upper(name) name, upper(parent) parent from planners`)) supervisors[r.NAME] = r.PARENT || '';
  return owners => String(owners || '').toUpperCase().split(';').map(o => o.trim()).filter(Boolean).some(o => {
    const sup = ';' + (supervisors[o] || '') + ';';
    return sup.includes(';' + user + ';') || sup.includes(';' + roleName + ';');
  });
}

module.exports = { add, move, withChildsAndParents };
