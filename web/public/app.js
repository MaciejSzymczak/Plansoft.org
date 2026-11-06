// Plansoft.org Web - logowanie, wybór okresu, siatka semestralna z wyborem wykładowców, grup i sal.
import { ChipField } from './chips.js';
import { renderSemesterGrid, fillClasses, paintBusy, paintHints } from './grid.js';
import { CellLayoutPanel, DEFAULT_LAYOUT, cellColours, lineText } from './cellLayout.js';
import { SummaryPanel, DEFAULT_SUMMARY } from './summary.js';
import { BrowseWindow } from './browse.js';
import { AddClassDialog, openConflicts } from './addClass.js';
import { ListOrganizer } from './listOrganizer.js';

const $ = sel => document.querySelector(sel);
const $$ = sel => [...document.querySelectorAll(sel)];

const TYPE_NAMES = { L: 'wykładowca', G: 'grupa', S: 'sala' };
const TYPE_NAMES_PL = { L: 'wykładowcy', G: 'grupy', S: 'sale' };

const state = {
  me: null, period: null, active: 'L', fields: {},
  settings: { descPlural: ['', '', '', ''], descSingular: ['', '', '', ''], resourceCategories: [] },
  classData: null, layout: null, summary: null, legend: false,
};

// --- API -----------------------------------------------------------------------------------
// body = dane JSON (domyślnie POST); method nadpisuje metodę (PUT, DELETE)
async function api(path, body, method) {
  const opt = body === undefined ? {} : { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify(body) };
  if (method) opt.method = method;
  const r = await fetch('/api/' + path, { credentials: 'same-origin', ...opt });
  const data = await r.json().catch(() => ({}));
  if (r.status === 401 && path !== 'login' && path !== 'me') { showLogin('Sesja wygasła - zaloguj się ponownie.'); throw new Error('401'); }
  if (!r.ok) throw new Error(data.error || `Błąd ${r.status}`);
  return data;
}

// --- zapamiętane wybory (tylko wygoda; brak dostępu do localStorage nie przeszkadza) ---------
const storeKey = () => 'plansoft.web.' + (state.me ? state.me.user : '');
function loadPrefs() { try { return JSON.parse(localStorage.getItem(storeKey())) || {}; } catch { return {}; } }
function savePrefs() {
  const p = {
    periodId: state.period && state.period.id, active: state.active, roleId: state.me && state.me.roleId,
    layout: state.layout, summary: state.summary, legend: state.legend,
    free: state.free, freeOpts: state.freeOpts, fav: state.fav,
  };
  if (state.defaults) for (const t of ['SUB', 'FOR']) p[t] = state.defaults[t].items;
  for (const t of 'LGS') p[t] = state.fields[t] ? state.fields[t].items : [];
  try { localStorage.setItem(storeKey(), JSON.stringify(p)); } catch { /* brak pamięci przeglądarki */ }
}

// --- widoki --------------------------------------------------------------------------------
function show(id) { $$('.view').forEach(v => { v.hidden = v.id !== id; }); }

function showLogin(message) {
  state.me = null;
  show('viewLogin');
  const err = $('#loginError');
  err.hidden = !message;
  err.textContent = message || '';
  $('#loginPassword').value = '';
  ($('#loginUser').value ? $('#loginPassword') : $('#loginUser')).focus();
}

function fillUser() {
  $$('.who').forEach(w => { w.textContent = state.me.user; });
  $$('.roleSelect').forEach(sel => {
    sel.hidden = !state.me.roles.length;
    sel.innerHTML = '';
    const own = new Option(`Moje uprawnienia (${state.me.user})`, '');
    sel.append(own, ...state.me.roles.map(r => new Option(`Rola: ${r.name}`, r.id)));
    sel.value = state.me.roleId || '';
  });
}

// --- logowanie -----------------------------------------------------------------------------
$('#loginForm').addEventListener('submit', async e => {
  e.preventDefault();
  const user = $('#loginUser').value.trim();
  const password = $('#loginPassword').value;
  const err = $('#loginError');
  if (!user || !password) {
    err.textContent = !user ? 'Podaj nazwę użytkownika.' : 'Podaj hasło.';
    err.hidden = false;
    (!user ? $('#loginUser') : $('#loginPassword')).focus();
    return;
  }
  const btn = $('#loginButton');
  btn.disabled = true; btn.textContent = 'Logowanie…';
  try {
    state.me = await api('login', { user, password });
    const prefs = loadPrefs();
    if (prefs.roleId && state.me.roles.some(r => r.id === prefs.roleId)) state.me = await api('role', { roleId: prefs.roleId });
    await loadSettings();
    fillUser();
    showPeriods(false);
  } catch (ex) {
    err.textContent = ex.message; err.hidden = false;
    $('#loginPassword').select();
  } finally {
    btn.disabled = false; btn.textContent = 'Zaloguj';
  }
});

$$('.logout').forEach(b => b.addEventListener('click', async () => {
  await api('logout', {}).catch(() => {});
  state.period = null;
  showLogin();
}));

$$('.roleSelect').forEach(sel => sel.addEventListener('change', async () => {
  state.me = await api('role', { roleId: sel.value ? Number(sel.value) : null });
  fillUser();
  savePrefs();
  if (!$('#viewPeriods').hidden) loadPeriods();
}));

// --- wybór okresu --------------------------------------------------------------------------
let periodRows = [];
let periodIndex = -1;
let periodTimer;

function showPeriods(canCancel) {
  show('viewPeriods');
  $('#periodCancel').hidden = !canCancel;
  $('#periodSearch').value = '';
  loadPeriods();
  $('#periodSearch').focus();
}

async function loadPeriods() {
  const list = $('#periodList');
  const q = $('#periodSearch').value.trim();
  try {
    periodRows = await api('periods?q=' + encodeURIComponent(q));
  } catch (e) {
    if (e.message !== '401') { list.textContent = e.message; }
    return;
  }
  const lastId = (state.period && state.period.id) || loadPrefs().periodId;
  periodIndex = Math.max(0, periodRows.findIndex(p => p.id === lastId));
  list.innerHTML = '';
  if (!periodRows.length) {
    list.append(Object.assign(document.createElement('p'), { className: 'muted pad', textContent: q ? 'Brak okresów pasujących do frazy.' : 'Brak dostępnych okresów.' }));
    return;
  }
  periodRows.forEach((p, i) => {
    const row = document.createElement('div');
    row.className = 'period-row';
    row.setAttribute('role', 'option');
    const name = Object.assign(document.createElement('span'), { className: 'p-name', textContent: p.name });
    const dates = Object.assign(document.createElement('span'), { className: 'p-dates', textContent: `${p.dateFrom} – ${p.dateTo}` });
    row.append(name, dates);
    if (p.desc) row.title = p.desc;
    row.addEventListener('click', () => openPeriod(p.id));
    row.addEventListener('mousemove', () => { if (periodIndex !== i) { periodIndex = i; paintPeriods(); } });
    list.append(row);
  });
  paintPeriods();
}

function paintPeriods() {
  $$('#periodList .period-row').forEach((r, i) => r.classList.toggle('active', i === periodIndex));
  const a = $('#periodList .period-row.active');
  if (a) a.scrollIntoView({ block: 'nearest' });
}

$('#periodSearch').addEventListener('input', () => { clearTimeout(periodTimer); periodTimer = setTimeout(loadPeriods, 300); });
$('#periodSearch').addEventListener('keydown', e => {
  if (e.key === 'ArrowDown' || e.key === 'ArrowUp') {
    e.preventDefault();
    if (!periodRows.length) return;
    periodIndex = Math.min(periodRows.length - 1, Math.max(0, periodIndex + (e.key === 'ArrowDown' ? 1 : -1)));
    paintPeriods();
  } else if (e.key === 'Enter' && periodRows[periodIndex]) {
    openPeriod(periodRows[periodIndex].id);
  } else if (e.key === 'Escape' && !$('#periodCancel').hidden) {
    show('viewMain');
  }
});
$('#periodCancel').addEventListener('click', () => show('viewMain'));
$('#periodButton').addEventListener('click', () => showPeriods(true));

async function openPeriod(id) {
  try {
    state.period = await api('periods/' + id);
  } catch (e) {
    if (e.message !== '401') alertBox(e.message);
    return;
  }
  $('#periodName').textContent = state.period.name;
  $('#periodDates').textContent = `${state.period.dateFrom} – ${state.period.dateTo}`;
  show('viewMain');
  initFields();
  renderSemesterGrid($('#gridWrap'), state.period);
  updateTitle();
  savePrefs();
}

function alertBox(text) {
  const list = $('#periodList');
  const p = Object.assign(document.createElement('p'), { className: 'error pad', textContent: text });
  list.prepend(p);
}

// --- pola wyboru wykładowców, grup, sal ----------------------------------------------------
function initFields() {
  if (state.fields.L) return;
  const prefs = loadPrefs();
  if (prefs.active) state.active = prefs.active;
  state.layout = { ...DEFAULT_LAYOUT, ...(prefs.layout || {}) };
  state.summary = { ...DEFAULT_SUMMARY, ...(prefs.summary || {}) };
  setLegend(!!prefs.legend, false);
  state.free = { L: { on: false, mode: 'all', cnt: '6,7,8' }, G: { on: false, mode: 'all', cnt: '6,7,8' }, S: { on: false, mode: 'all', cnt: '6,7,8' }, ...(prefs.free || {}) };
  state.freeOpts = { respect: false, groups: false, ...(prefs.freeOpts || {}) };
  state.fav = prefs.fav || 'off';
  const search = (type, q) => api(`objects/${type}?q=${encodeURIComponent(q)}${type === 'FOR' ? '&kind=C' : ''}`);
  $$('.selectors .chips[data-type=L], .selectors .chips[data-type=G], .selectors .chips[data-type=S]').forEach(el => {
    const f = new ChipField(el, {
      search,
      onChange: () => { if (state.active !== f.type) setActive(f.type); updateTitle(); savePrefs(); },
      onActivate: field => setActive(field.type),
    });
    f.setItems(prefs[f.type] || []);
    state.fields[f.type] = f;
    buildFreeTerms(el, f.type);
    // przycisk listy (rorL/rorG/rorR): organizator listy - kolejność, zapis i odczyt zestawu z pliku
    const b = Object.assign(document.createElement('button'), { type: 'button', className: 'chips-list', textContent: '≡' });
    b.title = 'Lista: kolejność, zależne, zapisz / otwórz zestaw';
    b.addEventListener('mousedown', e => e.stopPropagation());
    b.addEventListener('click', () => organizeList(f));
    el.append(b);
  });
  // domyślny przedmiot i forma (ConSubject/ConForm): podpowiedź przy dodawaniu zajęć, "Uzupełnianie"
  state.defaults = {};
  for (const t of ['SUB', 'FOR']) {
    const f = new ChipField($(`.selectors .chips[data-type=${t}]`), { search, single: true, onChange: () => { savePrefs(); loadBusy(); } });
    f.setItems(prefs[t] || []);
    state.defaults[t] = f;
  }
  buildFreeOptions();
  setActive(state.active);
}

// --- organizator listy (rorL/rorG/rorR) --------------------------------------------------------------
let listOrganizer = null;
function organizeList(f) {
  const apply = items => {
    f.setItems(items);
    state.active = null;   // wymusza przełączenie i odświeżenie rozkładu
    setActive(f.type);
  };
  // parametr systemowy Rotate: przycisk przesuwa listę o jedną pozycję (LROR w Delphi)
  if (state.settings.rotate) {
    if (f.items.length > 1) apply([...f.items.slice(1), f.items[0]]);
    return;
  }
  if (!listOrganizer) {
    listOrganizer = new ListOrganizer({
      api,
      onDetails: (type, id) => browser.open(type, id).catch(e => { if (e.message !== '401') console.error(e); }),
    });
  }
  listOrganizer.open(f.type, f.items, apply);
}

// --- wolne terminy (ShowFreeTermsL/G/R + ShowAllAny...) pod polami wykładowcy, grupy, sali -----------
function buildFreeTerms(chipsEl, type) {
  const box = document.createElement('div');
  box.className = 'free-terms';
  const l = document.createElement('label');
  const cb = Object.assign(document.createElement('input'), { type: 'checkbox', checked: state.free[type].on });
  l.append(cb, ' pokaż wolne terminy');
  l.title = 'Pokaż w siatce terminy zajęte dla wybranych obiektów z tego pola';
  const sel = document.createElement('select');
  sel.append(new Option('dla wszystkich', 'all'), new Option('dla któregokolwiek', 'any'), new Option(`Zajętych: ${state.free[type].cnt}`, 'n'));
  sel.value = state.free[type].mode;
  sel.title = 'dla wszystkich = termin wolny dla wszystkich wybranych; dla któregokolwiek = wolny dla co najmniej jednego';
  sel.hidden = !cb.checked;
  const cnt = Object.assign(document.createElement('input'), { value: state.free[type].cnt, title: 'Ile zajętych zasobów? Możesz wpisać kilka liczb, np. 6,7,8' });
  cnt.hidden = !cb.checked || sel.value !== 'n';
  const update = () => {
    state.free[type] = { on: cb.checked, mode: sel.value, cnt: cnt.value.replace(/[^0-9,]/g, '') || '6,7,8' };
    sel.options[2].text = `Zajętych: ${state.free[type].cnt}`;
    sel.hidden = !cb.checked;
    cnt.hidden = !cb.checked || sel.value !== 'n';
    $('#freeOptions').hidden = !anyFree();
    savePrefs();
    loadBusy();
  };
  cb.addEventListener('change', update);
  sel.addEventListener('change', update);
  cnt.addEventListener('change', update);
  box.append(l, sel, cnt);
  chipsEl.after(box);
}
const anyFree = () => 'LGS'.split('').some(t => state.free[t].on);

function buildFreeOptions() {
  const box = $('#freeOptions');
  box.innerHTML = '';
  for (const [key, label, title] of [
    ['respect', 'Uzupełnianie', 'Uwzględniaj uzupełnianie zajęć (domyślny przedmiot i forma)'],
    ['groups', 'Niedostępne: Pokaż grupę', 'W zajętych terminach pokaż grupy'],
  ]) {
    const l = document.createElement('label');
    const cb = Object.assign(document.createElement('input'), { type: 'checkbox', checked: state.freeOpts[key] });
    cb.addEventListener('change', () => { state.freeOpts[key] = cb.checked; savePrefs(); loadBusy(); });
    l.append(cb, ' ' + label); l.title = title;
    box.append(l);
  }
  box.hidden = !anyFree();
}

// zajętość (wolne terminy) i preferowane terminy - wczytywane osobno od zajęć bieżącego rozkładu
let busyTimer, busyReq = 0;
function loadBusy() {
  clearTimeout(busyTimer);
  busyTimer = setTimeout(async () => {
    if (!state.period || !state.fields.L) return;
    const req = ++busyReq;
    const ids = t => state.fields[t].items.map(i => i.id).join(',');
    let busyRows = [], hintRows = [];
    try {
      if (anyFree()) {
        const q = new URLSearchParams({ period: state.period.id });
        for (const t of 'LGS') {
          if (!state.free[t].on || !ids(t)) continue;
          q.set(t, ids(t)); q.set('mode' + t, state.free[t].mode); q.set('cnt' + t, state.free[t].cnt);
        }
        if (state.freeOpts.respect) {
          q.set('respect', '1');
          q.set('sub', (state.defaults.SUB.items[0] || {}).id || ''); q.set('form', (state.defaults.FOR.items[0] || {}).id || '');
        }
        if ([...q.keys()].some(k => 'LGS'.includes(k))) busyRows = await api('busy?' + q);
      }
      if (state.fav !== 'off') {
        const f = state.fields[state.active];
        const hintIds = state.fav === 'current' ? (f && f.items[0] ? String(f.items[0].id) : '') : 'LGS'.split('').map(ids).filter(Boolean).join(',');
        if (hintIds) hintRows = await api(`hints?period=${state.period.id}&ids=${hintIds}`);
      }
    } catch (e) { if (e.message !== '401') flashTitle(e.message, true); return; }
    if (req !== busyReq) return;
    state.busyData = busyRows;
    state.hintData = hintRows;
    paintMarks();
  }, 80);
}
function paintMarks() {
  paintBusy($('#gridWrap'), state.busyData, state.freeOpts && state.freeOpts.groups);
  paintHints($('#gridWrap'), state.hintData);
}

function setActive(type) {
  if (state.active === type && $('.chips.active')) return;
  state.active = type;
  $$('.chips').forEach(c => c.classList.toggle('active', c.dataset.type === type));
  updateTitle();
  savePrefs();
}

function updateTitle() {
  const t = $('#gridTitle');
  const f = state.fields[state.active];
  t.innerHTML = '';
  const b = document.createElement('b');
  b.textContent = 'Rozkład zajęć';
  t.append(b);
  if (!f || !f.items.length) {
    t.append(` – wybierz ${TYPE_NAMES_PL[state.active]} w polu „${f ? f.el.dataset.label : ''}”`);
    t.classList.add('empty');
  } else {
    t.append(` – ${TYPE_NAMES[state.active]}: ${f.items.map(i => i.name).join(', ')}`);
    t.classList.remove('empty');
  }
  loadClasses();
}

// --- zajęcia w siatce ----------------------------------------------------------------------
const plural = (n, one, few, many) =>
  n === 1 ? one : (n % 10 >= 2 && n % 10 <= 4 && (n % 100 < 12 || n % 100 > 14) ? few : many);

let classesTimer, classesReq = 0;
function loadClasses() {
  clearTimeout(classesTimer);
  classesTimer = setTimeout(async () => {
    const f = state.fields[state.active];
    if (!state.period || !f) return;
    const type = state.active;
    const ids = f.items.map(i => i.id).join(',');
    const req = ++classesReq;
    $$('#gridTitle .count:not(.flash):not(.error)').forEach(c => c.remove());   // ponowne wczytanie (np. po zapisie)
    const count = $('#gridTitle').appendChild(Object.assign(document.createElement('span'), { className: 'count' }));
    let rows = [];
    if (ids) {
      count.textContent = 'wczytywanie…';
      try {
        rows = await api(`classes?period=${state.period.id}&type=${type}&ids=${ids}`);
      } catch (e) {
        if (req === classesReq && e.message !== '401') { count.textContent = e.message; count.className = 'count error'; }
        return;
      }
    }
    if (req !== classesReq) return;   // w międzyczasie zmieniono wybór
    state.classData = rows.classes ? rows : { classes: [], lecturers: {}, groups: {}, rooms: {} };
    paintClasses();
    const n = state.classData.classes.length;
    count.textContent = ids ? `${n} ${plural(n, 'zajęcie', 'zajęcia', 'zajęć')}` : '';
  }, 50);
  if (state.legend) summaryPanel.refresh();
  loadBusy();
}

const cellHelpers = {
  colours: cellColours,
  text: lineText,
  descName: i => state.settings.descPlural[i] || `Opis ${i + 1}`,
};
function paintClasses() {
  if (state.classData) fillClasses($('#gridWrap'), state.classData, state.layout, cellHelpers);
  paintMarks();
}

// --- okno "Zajęcie" (wygląd komórki) i legenda (podsumowanie godzin) -------------------------
new CellLayoutPanel($('#cellLayoutButton'), $('#cellLayout'), {
  getLayout: () => state.layout,
  getSettings: () => state.settings,
  onChange: layout => { state.layout = layout; paintClasses(); savePrefs(); },
});

const summaryPanel = new SummaryPanel($('#summary'), {
  api,
  getSettings: () => state.settings,
  getOptions: () => state.summary,
  setOptions: o => { state.summary = o; savePrefs(); },
  getScope: () => {
    const f = state.fields[state.active];
    if (!state.period || !f) return null;
    return { period: state.period.id, type: state.active, ids: f.items.map(i => i.id), label: TYPE_NAMES_PL[state.active] };
  },
  // kliknięcie w wykładowcę/grupę/salę w podsumowaniu: jego rozkład w siatce
  onNavigate: (type, id, name) => {
    const f = state.fields[type];
    f.setItems([{ id, name }]);
    state.active = null;
    setActive(type);
  },
});

function setLegend(open, save = true) {
  state.legend = open;
  $('#legend').hidden = !open;
  $('#legendButton').setAttribute('aria-pressed', String(open));
  if (open) summaryPanel.refresh();
  if (save) savePrefs();
}
$('#legendButton').addEventListener('click', () => setLegend(!state.legend));
$('#legendClose').addEventListener('click', () => setLegend(false));

// liczba zaznaczonych terminów nad siatką
const canInsert = () => !(state.me && state.me.canInsert === false);
$('#gridWrap').addEventListener('gridselect', e => {
  const n = e.detail.count;
  $('#selCount').textContent = n ? `Zaznaczono: ${n} ${plural(n, 'termin', 'terminy', 'terminów')}` : '';
  e.currentTarget.canMove = canInsert();
});

// --- dodawanie zajęcia (FDetails + okno konfliktów) -------------------------------------------
const addClassDialog = new AddClassDialog({
  api,
  onAdded: r => {
    loadClasses();
    const n = r.count;
    flashTitle(`Dodano ${n} ${plural(n, 'zajęcie', 'zajęcia', 'zajęć')}` + (r.replaced ? `, usunięto kolidujących: ${r.replaced}` : '') + (r.warning ? ` – ${r.warning}` : ''));
  },
});
const gridSelection = () => ($('#gridWrap').getSelection ? $('#gridWrap').getSelection() : []);
function openAddClass() {
  const cells = gridSelection();
  if (!cells.length || !state.period || !canInsert()) return;
  const prefill = {};
  for (const t of 'LGS') {
    const items = state.fields[t] ? state.fields[t].items : [];
    prefill[t] = state.me.firstResource ? items.slice(0, 1) : items;
  }
  addClassDialog.open({
    period: state.period.id, cells, prefill, settings: state.settings, user: state.me.user,
    sub: state.defaults.SUB.items[0], form: state.defaults.FOR.items[0],
    hours: state.period.hours.map(h => ({ no: h.no, label: h.caption || String(h.no) })),
  });
}

// --- przesuwanie / kopiowanie zajęć: przeciąganie (gridmove) i schowek (Ctrl+C / Ctrl+X / Ctrl+V) ------
const moveConflicts = document.createElement('dialog');
moveConflicts.className = 'conflicts';
document.body.append(moveConflicts);
async function runMove({ moves, copy, valid, newSelection }, after) {
  if (!valid) return flashTitle('Nie można przesunąć zajęć poza obszar planowania.', true);
  if (!moves.length) return;
  const run = async confirm => {
    let r;
    try {
      r = await api('classes/move', { period: state.period.id, moves: moves.map(m => ({ id: m.id, date: m.date, hour: m.hour })), copy, confirm });
    } catch (err) {
      if (err.message !== '401') flashTitle(err.message, true);
      return;
    }
    if (r.status === 'conflicts') {
      openConflicts(moveConflicts, {
        newTitle: copy ? 'Kopiowane zajęcia' : 'Przesuwane zajęcia',
        newRows: r.moving.map(m => [`${m.day} (z ${m.from})`, String(m.hour), m.lecturers, m.groups, m.rooms, '', '', m.owner]),
        conflicts: r.conflicts, canDelete: r.canDelete, onContinue: () => run(true),
      });
      return;
    }
    $('#gridWrap').setSelectionKeys(newSelection);
    if (after) after();
    loadClasses();
    const n = r.count;
    if (n) flashTitle(`${copy ? 'Skopiowano' : 'Przesunięto'} ${n} ${plural(n, 'zajęcie', 'zajęcia', 'zajęć')}` + (r.replaced ? `, usunięto kolidujących: ${r.replaced}` : ''));
  };
  run(false);
}
$('#gridWrap').addEventListener('gridmove', e => runMove(e.detail));

// schowek jak CopyArea/CutArea/PasteArea: zapamiętany obszar, wklejenie w lewy górny róg bieżącego zaznaczenia
let clip = null;   // { keys, mode: 'copy' | 'cut' }
function clipCopy(mode) {
  const g = $('#gridWrap');
  const keys = g.getSelectionKeys ? g.getSelectionKeys() : [];
  if (!keys.length) return;
  clip = { keys, mode };
  g.markClipboard(keys, mode);
  flashTitle(mode === 'cut' ? 'Wycięto obszar - zaznacz miejsce i wklej (Ctrl+V).' : 'Skopiowano obszar - zaznacz miejsce i wklej (Ctrl+V).');
}
function clipPaste() {
  const g = $('#gridWrap');
  if (!clip || !g.selectionOrigin) return;
  const to = g.selectionOrigin();
  if (!to) return flashTitle('Zaznacz miejsce wklejenia.', true);
  const from = clip.keys.map(k => k.split(',').map(Number));
  const dr = to.r - Math.min(...from.map(x => x[0])), dc = to.c - Math.min(...from.map(x => x[1]));
  const m = g.movesFor(clip.keys, dr, dc);
  if (!m.moves.length && m.valid) return flashTitle('W skopiowanym obszarze nie ma zajęć.', true);
  const mode = clip.mode;
  runMove({ ...m, copy: mode === 'copy' }, () => {
    // po przeniesieniu wycięty obszar jest pusty - schowek czyszczony (jak gridSelectionMode = clRed)
    if (mode === 'cut') { clip = null; g.markClipboard([], null); }
  });
}
function clipClear() { clip = null; $('#gridWrap').markClipboard && $('#gridWrap').markClipboard([], null); }

document.addEventListener('keydown', e => {
  if ($('#viewMain').hidden || document.querySelector('dialog[open]')) return;
  if (e.target.closest && e.target.closest('input, textarea, select')) return;
  const k = e.key.toLowerCase();
  if (e.key === 'Insert') { e.preventDefault(); openAddClass(); }
  else if ((e.ctrlKey || e.metaKey) && k === 'c') { e.preventDefault(); clipCopy('copy'); }
  else if ((e.ctrlKey || e.metaKey) && k === 'x') { e.preventDefault(); if (canInsert()) clipCopy('cut'); }
  else if ((e.ctrlKey || e.metaKey) && k === 'v') { e.preventDefault(); if (canInsert()) clipPaste(); }
  else if (e.key === 'Escape' && clip) clipClear();
});

// --- "Gdzie mogę przenieść zajęcie?" (bSeeAvailable / showAvailableTerms) -------------------------
function seeAvailable() {
  const cells = $('#gridWrap').getSelectionKeys ? $('#gridWrap').getSelectionKeys() : [];
  const td = cells.length === 1 ? $(`#gridWrap td.cell[data-row="${cells[0].split(',')[0]}"][data-col="${cells[0].split(',')[1]}"]`) : null;
  if (!td) return flashTitle('Wskaż pojedynczą komórkę.', true);
  if (!td.dataset.cla) return flashTitle('Zaznacz zajęcie.', true);
  const c = state.classData.classes.find(x => String(x.id) === td.dataset.cla.split(',')[0]);
  if (!c) return;
  const items = (ids, map) => String(ids || '').split(';').filter(Boolean).map(id => ({ id: Number(id), name: (map[id] || {}).label || id }));
  state.fields.L.setItems(items(c.lecIds, state.classData.lecturers));
  state.fields.G.setItems(items(c.groIds, state.classData.groups));
  state.fields.S.setItems(items(c.romIds, state.classData.rooms));
  if (c.subId) state.defaults.SUB.setItems([{ id: c.subId, name: c.subName || c.sub }]);
  if (c.forId) state.defaults.FOR.setItems([{ id: c.forId, name: c.formName || c.form }]);
  for (const t of 'LGS') state.free[t].on = true;
  $$('.free-terms').forEach(b => { b.querySelector('input[type=checkbox]').checked = true; b.querySelector('select').hidden = false; });
  $('#freeOptions').hidden = false;
  savePrefs();
  updateTitle();
}

// --- preferowane terminy (bfavpopup): ocena zaznaczonych terminów dla bieżącego obiektu -------------
const RATINGS = [
  [-999, 'Nie planuj (fatalny)'], [-750, 'Nie planuj (bardzo zły)'], [-500, 'Nie planuj (zły)'], [-300, 'Nie planuj (raczej zły)'],
  [0, 'Termin neutralny'],
  [300, 'Planuj (raczej dobry)'], [500, 'Planuj (dobry)'], [750, 'Planuj (bardzo dobry)'], [999, 'Planuj (doskonały)'],
];
async function setRating(ratio) {
  const f = state.fields[state.active];
  const obj = f && f.items[0];
  if (!obj) return flashTitle(`Wybierz ${TYPE_NAMES_PL[state.active]}.`, true);
  const cells = gridSelection();
  if (!cells.length) return flashTitle('Zaznacz terminy w siatce.', true);
  try {
    await api('hints', { period: state.period.id, resId: obj.id, ratio, cells });
  } catch (e) { if (e.message !== '401') flashTitle(e.message, true); return; }
  if (state.fav === 'off') { state.fav = 'current'; savePrefs(); }   // pokaż od razu ustawione oceny
  flashTitle(`${obj.name}: ${RATINGS.find(r => r[0] === ratio)[1]} (${cells.length} ${plural(cells.length, 'termin', 'terminy', 'terminów')})`);
  loadBusy();
}
function setFavView(v) { state.fav = v; savePrefs(); loadBusy(); }

// --- menu kontekstowe siatki (prawy przycisk; jak okno narzędzi FToolWindow w Delphi) ---------------
const ctxMenu = Object.assign(document.createElement('div'), { className: 'menu ctx-menu', hidden: true });
ctxMenu.setAttribute('role', 'menu');
document.body.append(ctxMenu);
function menuItem(label, onClick, opts = {}) {
  const b = Object.assign(document.createElement('button'), { type: 'button', disabled: !!opts.disabled });
  b.setAttribute('role', opts.radio !== undefined ? 'menuitemradio' : 'menuitem');
  if (opts.radio !== undefined) b.setAttribute('aria-checked', String(opts.radio));
  const l = Object.assign(document.createElement('span'), { textContent: (opts.radio ? '● ' : opts.radio === false ? '○ ' : '') + label });
  b.append(l);
  if (opts.key) b.append(Object.assign(document.createElement('span'), { className: 'key', textContent: opts.key }));
  if (opts.sub) b.classList.add('has-sub');
  b.addEventListener('click', e => { if (opts.sub) { e.stopPropagation(); opts.sub(b); return; } hideCtx(); onClick(); });
  return b;
}
const sep = () => Object.assign(document.createElement('div'), { className: 'menu-sep' });
function hideCtx() { ctxMenu.hidden = true; ctxMenu.querySelectorAll('.ctx-sub').forEach(s => s.remove()); }
function showCtx(x, y) {
  ctxMenu.innerHTML = '';
  const sel = gridSelection();
  const hasClass = !!$('#gridWrap td.cell.selected[data-cla]');
  ctxMenu.append(
    menuItem('Dodaj zajęcie', openAddClass, { key: 'Insert', disabled: !sel.length || !canInsert() }),
    sep(),
    menuItem('Kopiuj', () => clipCopy('copy'), { key: 'Ctrl+C', disabled: !hasClass }),
    menuItem('Wytnij', () => clipCopy('cut'), { key: 'Ctrl+X', disabled: !hasClass || !canInsert() }),
    menuItem('Wklej', clipPaste, { key: 'Ctrl+V', disabled: !clip || !sel.length || !canInsert() }),
    sep(),
    menuItem('Gdzie mogę przenieść zajęcie?', seeAvailable, { disabled: !hasClass }),
    sep(),
    menuItem('Preferowane terminy', null, {
      sub: anchor => {
        ctxMenu.querySelectorAll('.ctx-sub').forEach(s => s.remove());
        const sub = Object.assign(document.createElement('div'), { className: 'menu ctx-sub' });
        const f = state.fields[state.active];
        const who = f && f.items[0] ? f.items[0].name : '';
        sub.append(Object.assign(document.createElement('div'), { className: 'menu-head', textContent: who ? `Ocena terminów: ${who}` : `Wybierz ${TYPE_NAMES_PL[state.active]}` }));
        RATINGS.forEach(([v, l]) => sub.append(menuItem(l, () => setRating(v), { disabled: !who || !sel.length })));
        sub.append(sep(),
          menuItem('Wyłącz preferowane terminy', () => setFavView('off'), { radio: state.fav === 'off' }),
          menuItem('Włącz preferowane terminy - bieżący obiekt', () => setFavView('current'), { radio: state.fav === 'current' }),
          menuItem('Włącz preferowane terminy - wszystkie obiekty', () => setFavView('all'), { radio: state.fav === 'all' }));
        ctxMenu.append(sub);
        const r = anchor.getBoundingClientRect(), m = ctxMenu.getBoundingClientRect();
        sub.style.top = (r.top - m.top) + 'px';
        sub.style.left = (m.right + 260 > window.innerWidth ? -262 : m.width - 2) + 'px';
      },
    }),
  );
  ctxMenu.hidden = false;
  const w = ctxMenu.offsetWidth, h = ctxMenu.offsetHeight;
  ctxMenu.style.left = Math.min(x, window.innerWidth - w - 8) + 'px';
  ctxMenu.style.top = Math.min(y, window.innerHeight - h - 8) + 'px';
  const first = ctxMenu.querySelector('button:not(:disabled)');
  if (first) first.focus();
}
$('#gridWrap').addEventListener('gridcontext', e => showCtx(e.detail.x, e.detail.y));
document.addEventListener('mousedown', e => { if (!ctxMenu.hidden && !ctxMenu.contains(e.target)) hideCtx(); });
document.addEventListener('keydown', e => { if (e.key === 'Escape' && !ctxMenu.hidden) hideCtx(); });
window.addEventListener('blur', hideCtx);
$('#gridWrap').addEventListener('scroll', hideCtx);

function flashTitle(text, error) {
  if (error) {
    const t = $('#gridTitle').appendChild(Object.assign(document.createElement('span'), { className: 'count error', textContent: text }));
    t.style.whiteSpace = 'pre-line';
    setTimeout(() => t.remove(), 8000);
    return;
  }
  const t = $('#gridTitle').appendChild(Object.assign(document.createElement('span'), { className: 'count flash', textContent: text }));
  setTimeout(() => t.remove(), 6000);
}

// --- menu "Dane": okna słownikowe ------------------------------------------------------------
const browser = new BrowseWindow({
  api,
  // zmiany nazw/kolorów wykładowców, grup, sal, przedmiotów i form widać w siatce od razu
  onChanged: () => { if (state.period) loadClasses(); },
});
const dataMenu = $('#dataMenu'), dataMenuButton = $('#dataMenuButton');
function setDataMenu(open) { dataMenu.hidden = !open; dataMenuButton.setAttribute('aria-expanded', String(open)); }
dataMenuButton.addEventListener('click', () => setDataMenu(dataMenu.hidden));
document.addEventListener('mousedown', e => { if (!dataMenu.hidden && !dataMenu.parentElement.contains(e.target)) setDataMenu(false); });
dataMenu.addEventListener('keydown', e => { if (e.key === 'Escape') { setDataMenu(false); dataMenuButton.focus(); } });
$$('#dataMenu [data-browse]').forEach(b => b.addEventListener('click', async () => {
  setDataMenu(false);
  try { await browser.open(b.dataset.browse); } catch (e) { if (e.message !== '401') console.error(e); }
}));

async function loadSettings() {
  try { state.settings = await api('settings'); } catch { /* zostają wartości domyślne */ }
}

// --- start ---------------------------------------------------------------------------------
(async function start() {
  try {
    state.me = await api('me');
  } catch {
    return showLogin();
  }
  await loadSettings();
  fillUser();
  const prefs = loadPrefs();
  if (prefs.periodId) {
    try { await openPeriod(prefs.periodId); if (state.period) return; } catch { /* okres usunięty */ }
  }
  showPeriods(false);
})();
