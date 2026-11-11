// Plansoft.org Web - logowanie, wybór okresu, siatka semestralna z wyborem wykładowców, grup i sal.
import { ChipField } from './chips.js';
import { renderSemesterGrid, fillClasses, paintBusy, paintHints, paintHolidays } from './grid.js';
import { CellLayoutPanel, DEFAULT_LAYOUT, MULTI_MODES, cellColours, lineText } from './cellLayout.js';
import { SummaryPanel, DEFAULT_SUMMARY } from './summary.js';
import { BrowseWindow } from './browse.js';
import { AddClassDialog, openConflicts } from './addClass.js';
import { ListOrganizer } from './listOrganizer.js';
import { PermissionsWindow } from './permissions.js';
import { ReportWindow } from './report.js';
import { ToolsWindow } from './tools.js';
import { ToolWindow, openPopup, pickItems, pickColour, pickDesc, hintsList } from './toolWindow.js';
import { HolidaysWindow } from './holidays.js';
import { PivotWindow } from './pivot.js';
import { previewGrid, previewWeeklyPlan } from './preview.js';
import { FindPanel } from './find.js';

const $ = sel => document.querySelector(sel);
const $$ = sel => [...document.querySelectorAll(sel)];

const TYPE_NAMES = { L: 'wykładowca', G: 'grupa', S: 'sala', SUB: 'przedmiot' };
const TYPE_NAMES_PL = { L: 'wykładowcy', G: 'grupy', S: 'sale', SUB: 'przedmiot' };
// rozkład przedmiotu (zakładka "Przedmiot" w Delphi): tylko do podglądu - komórka może mieć kilka zajęć
const subjectView = () => state.active === 'SUB';

const state = {
  me: null, period: null, active: 'L', fields: {},
  settings: { descPlural: ['', '', '', ''], descSingular: ['', '', '', ''], resourceCategories: [] },
  classData: null, layout: null, summary: null, legend: false,
  // "Gdzie mogę przenieść zajęcia?": włączony tryb, zasoby (L/G/S) i identyfikatory (cla) zaznaczonych zajęć
  seeAvail: { on: false, L: [], G: [], S: [], cla: [] },
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
    layout: state.layout, summary: state.summary, legend: state.legend, legendTab: state.legendTab, suppress: state.suppress,
    free: state.free, freeOpts: state.freeOpts, fav: state.fav,
  };
  if (state.defaults) for (const t of ['SUB', 'FOR']) p[t] = state.defaults[t].items;
  for (const t of 'LGS') p[t] = state.fields[t] ? state.fields[t].items : [];   // przedmiot - w p.SUB (state.defaults)
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
  state.gridSig = null;   // nowy okres - siatka rysowana od nowa (ensureGrid)
  state.week = null;
  state.holidays = [];
  updateTitle();
  savePrefs();
  loadHolidays();
}

// ponowne wczytanie bieżącego okresu (np. po zmianie siatki godzinowej), bez zmiany wyborów
async function reloadPeriod() {
  try { state.period = await api('periods/' + state.period.id); } catch (e) { return; }
  $('#periodName').textContent = state.period.name;
  $('#periodDates').textContent = `${state.period.dateFrom} – ${state.period.dateTo}`;
  state.gridSig = null;
  updateTitle();
  loadHolidays();
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
  if (!MULTI_MODES.includes(state.layout.multi)) state.layout.multi = DEFAULT_LAYOUT.multi;   // dawne "razem" (usunięte)
  state.summary = { ...DEFAULT_SUMMARY, ...(prefs.summary || {}) };
  state.legendTab = prefs.legendTab || "summary";
  state.suppress = { SUB: false, FOR: false, ...(prefs.suppress || {}) };
  setLegend(!!prefs.legend, false);
  state.free = { L: { on: false, mode: 'all', cnt: '6,7,8' }, G: { on: false, mode: 'all', cnt: '6,7,8' }, S: { on: false, mode: 'all', cnt: '6,7,8' }, ...(prefs.free || {}) };
  state.freeOpts = { respect: false, groups: false, ...(prefs.freeOpts || {}) };
  state.fav = prefs.fav || 'off';
  const search = (type, q) => api(`objects/${type}?q=${encodeURIComponent(q)}${type === 'FOR' ? '&kind=C' : ''}`);
  $$('.selectors .chips[data-type=L], .selectors .chips[data-type=G], .selectors .chips[data-type=S]').forEach(el => {
    const f = new ChipField(el, {
      search,
      listOnSecondClick: true,
      // zmiana listy (dodanie, usunięcie, kolejność): znowu wszystkie obiekty pola
      onChange: () => { if (state.pick && state.pick.type === f.type) state.pick = null; if (state.active !== f.type) setActive(f.type); updateTitle(); savePrefs(); },
      onActivate: field => setActive(field.type),
      onPick: item => pickObject(f, item),
    });
    f.setItems(prefs[f.type] || []);
    state.fields[f.type] = f;
    buildFreeTerms(el, f.type);
    // przycisk listy (rorL/rorG/rorR): organizator listy - kolejność, zapis i odczyt zestawu z pliku
    const b = Object.assign(document.createElement('button'), { type: 'button', className: 'chips-list', textContent: '≡' });
    b.title = 'Organizer: kolejność, zależne, zapisz / otwórz zestaw';
    b.addEventListener('mousedown', e => e.stopPropagation());
    b.addEventListener('click', () => organizeList(f));
    // Rotuj: pierwszy obiekt na koniec listy, kolejny staje się pierwszym (dawniej podwójne kliknięcie pola)
    const rot = Object.assign(document.createElement('button'), { type: 'button', className: 'chips-list chips-rotate' });
    rot.innerHTML = '<svg viewBox="0 0 24 24" width="15" height="15" aria-hidden="true"><path fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round" d="M20 12a8 8 0 1 1-2.34-5.66"/><path fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round" d="M20 4v5h-5"/></svg>';
    rot.title = 'Rotuj: pierwszy na koniec listy, kolejny staje się pierwszym';
    rot.setAttribute('aria-label', 'Rotuj listę');
    rot.addEventListener('mousedown', e => e.stopPropagation());
    rot.addEventListener('click', () => { if (f.items.length < 2) return; f.rotate(); });
    el.append(rot, b);
  });
  // domyślny przedmiot i forma (ConSubject/ConForm): podpowiedź przy dodawaniu zajęć, "Uzupełnianie"
  state.defaults = {};
  for (const t of ['SUB', 'FOR']) {
    const el = $(`.selectors .chips[data-type=${t}]`);
    const f = new ChipField(el, t === 'SUB'
      ? { search, single: true, listOnSecondClick: true, onActivate: () => setActive('SUB'),
          onChange: () => { if (state.active === 'SUB') updateTitle(); else paintClasses(); savePrefs(); loadBusy(); } }
      : { search, single: true, onChange: () => { paintClasses(); savePrefs(); loadBusy(); } });
    f.setItems(prefs[t] || []);
    state.defaults[t] = f;
    // DrawSuppressionS / DrawSuppressionF: "Wyróżniaj" - zajęcia innego przedmiotu / innej formy przygaszone
    const l = Object.assign(document.createElement('label'), { className: 'check suppress', title: t === 'SUB' ? 'Wyróżniaj wybrany przedmiot' : 'Wyróżniaj wybraną formę' });
    const c = Object.assign(document.createElement('input'), { type: 'checkbox', checked: !!(state.suppress && state.suppress[t]) });
    c.addEventListener('mousedown', e => e.stopPropagation());
    c.addEventListener('change', () => { state.suppress[t] = c.checked; paintClasses(); savePrefs(); });
    l.addEventListener('mousedown', e => e.stopPropagation());
    l.append(c, ' wyróżniaj');
    el.append(l);
  }
  state.fields.SUB = state.defaults.SUB;
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
      const av = state.seeAvail.on ? state.seeAvail : null;
      if (anyFree() || av) {
        const q = new URLSearchParams({ period: state.period.id });
        for (const t of 'LGS') {
          if (!state.free[t].on || !ids(t)) continue;
          q.set(t, ids(t)); q.set('mode' + t, state.free[t].mode); q.set('cnt' + t, state.free[t].cnt);
        }
        // "Gdzie mogę przenieść zajęcia?": zasoby zaznaczonych zajęć (zajęty, gdy zajęty którykolwiek), bez nich samych
        if (av) {
          for (const t of 'LGS') if (av[t].length) q.set('av' + t, av[t].join(','));
          if (av.cla.length) q.set('avNot', av.cla.join(','));
        }
        if (state.freeOpts.respect) {
          q.set('respect', '1');
          q.set('sub', (state.defaults.SUB.items[0] || {}).id || ''); q.set('form', (state.defaults.FOR.items[0] || {}).id || '');
        }
        if ([...q.keys()].some(k => ['L', 'G', 'S', 'avL', 'avG', 'avS'].includes(k))) busyRows = await api('busy?' + q);
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
  paintHolidays($('#gridWrap'), state.holidays);
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
  // nazwa obiektu, którego rozkład jest na ekranie (jeden z kilku) - zaznaczona w polu
  const one = f && f.items.length > 1 && !state.week ? shownObjects() : [];
  for (const [type, field] of Object.entries(state.fields)) field.setPicked(type === state.active && one.length === 1 ? one[0].id : null);
  if (!f || !f.items.length) {
    t.append(` – wybierz ${TYPE_NAMES_PL[state.active]} w polu „${f ? f.el.dataset.label : ''}”`);
    t.classList.add('empty');
  } else {
    const shown = shownObjects();
    t.append(` – ${TYPE_NAMES[state.active]}: ${shown.map(i => i.name).join(', ')}`);
    if (shown.length < f.items.length) t.append(Object.assign(document.createElement('span'), { className: 'muted', textContent: ` (${f.items.indexOf(shown[0]) + 1} z ${f.items.length})` }));
    t.classList.remove('empty');
  }
  loadClasses();
}

// --- wiele wybranych obiektów (okno "Zajęcie", "Wiele obiektów") ------------------------------------
// w poziomie / w pionie: jeden arkusz, w komórce każde zajęcie w osobnym kwadraciku (obok siebie / jeden pod drugim -
// fillClasses); tylko pierwszy: jeden obiekt na raz, przełączany kliknięciem nazwy w polu (state.firstIdx, pickObject);
// polecenie "Wszystkie na jednym arkuszu tygodniowym" - układ tygodniowy (showWeekOfSelection)
const multiMode = () => (state.layout && state.layout.multi) || DEFAULT_LAYOUT.multi;
function shownObjects() {
  const f = state.fields[state.active];
  const items = f ? f.items : [];
  if (state.week) return items;   // układ tygodniowy: wszystkie w kolumnach
  // kliknięta nazwa w polu (pickObject): tylko rozkład tego obiektu
  const picked = state.pick && state.pick.type === state.active && items.find(x => String(x.id) === String(state.pick.id));
  if (picked) return [picked];
  if (multiMode() !== 'first') return items;
  const i = Math.min(state.firstIdx || 0, Math.max(0, items.length - 1));
  return items.slice(i, i + 1);
}
// siatka rysowana od nowa tylko przy zmianie okresu lub układu tygodniowego (obiekty w kolumnach)
function ensureGrid() {
  if (!state.period) return;
  const items = shownObjects();
  const week = state.week && items.length ? state.week : null;
  const sig = [state.period.id, week || '', week ? state.active + ':' + items.map(i => i.id).join(',') : ''].join('|');
  paintWeekNav(week);
  if (sig === state.gridSig) return;
  state.gridSig = sig;
  renderSemesterGrid($('#gridWrap'), state.period, week ? { blocks: items, type: state.active, week } : {});
  clip = null;
}

// kliknięcie w nazwę wykładowcy / grupy / sali w polu: obiekt zaznaczony, na ekranie jego rozkład; ponowne kliknięcie
// zaznaczonej nazwy - znowu wszystkie obiekty pola. "Pokazuj jeden": zawsze jeden obiekt (state.firstIdx).
// Przejście między rozkładami pojedynczych obiektów: nowy rozkład wjeżdża z boku (z prawej - dalszy na liście)
function pickObject(f, item) {
  const i = f.items.findIndex(x => String(x.id) === String(item.id));
  if (i < 0) return;
  const wasActive = state.active === f.type;
  const shown = wasActive ? shownObjects() : [];
  const alone = shown.length === 1 && String(shown[0].id) === String(item.id);
  const cur = shown.length === 1 ? f.items.indexOf(shown[0]) : -1;
  if (cur >= 0 && !alone && !state.week) state.slide = i > cur ? 'slide-left' : 'slide-right';
  state.week = null;
  if (multiMode() === 'first' && !state.pick) {
    if (alone) return;
    state.firstIdx = i;
  } else {
    state.pick = alone && f.items.length > 1 ? null : { type: f.type, id: item.id };
  }
  if (!wasActive) setActive(f.type); else updateTitle();
}


// --- układ tygodniowy (kliknięcie w numer tygodnia, jak switchSemesterWeek w Delphi): jeden tydzień, w kolumnach
//     wybrane obiekty; kliknięcie obiektu lub numeru tygodnia - powrót do semestru (kliknięty obiekt pierwszy na liście)
const isoAddDays = (iso, n) => { const d = new Date(iso + 'T00:00:00Z'); d.setUTCDate(d.getUTCDate() + n); return d.toISOString().slice(0, 10); };
const mondayIso = iso => { const d = new Date(iso + 'T00:00:00Z'); return isoAddDays(iso, -((d.getUTCDay() + 6) % 7)); };
// "Wszystkie na jednym arkuszu tygodniowym" (okno "Zajęcie"): tydzień pierwszej zaznaczonej daty, bez zaznaczenia -
// pierwszy tydzień okresu
function showWeekOfSelection() {
  if (!state.period) return;
  const f = state.fields[state.active];
  if (!f || !f.items.length) return flashTitle(`Wybierz ${TYPE_NAMES_PL[state.active]}.`, true);
  const sel = state.week ? [] : gridSelection();
  showWeek(mondayIso(sel.length ? sel[0].date : state.period.dateFrom));
}
function showWeek(monday) {
  state.week = monday;
  updateTitle();
}
function showSemester(objId) {
  state.week = null;
  const f = state.fields[state.active];
  const i = objId ? f.items.findIndex(x => String(x.id) === String(objId)) : -1;
  if (i > 0) { f.setItems([f.items[i], ...f.items.filter((x, j) => j !== i)]); savePrefs(); }
  updateTitle();
}
function paintWeekNav(week) {
  const nav = $('#weekNav');
  nav.hidden = !week;
  if (!week) return;
  const first = mondayIso(state.period.dateFrom), last = mondayIso(state.period.dateTo);
  const fmt = iso => `${iso.slice(8, 10)}.${iso.slice(5, 7)}`;
  $('#weekLabel').textContent = `Tydzień ${fmt(week)} – ${fmt(isoAddDays(week, 6))}`;
  $('#weekPrev').disabled = week <= first;
  $('#weekNext').disabled = week >= last;
}
$('#gridWrap').addEventListener('gridweek', e => (state.week ? showSemester(e.detail.obj) : showWeek(e.detail.monday)));
$('#weekPrev').addEventListener('click', () => showWeek(isoAddDays(state.week, -7)));
$('#weekNext').addEventListener('click', () => showWeek(isoAddDays(state.week, 7)));
$('#weekBack').addEventListener('click', () => showSemester());

// --- zajęcia w siatce ----------------------------------------------------------------------
const plural = (n, one, few, many) =>
  n === 1 ? one : (n % 10 >= 2 && n % 10 <= 4 && (n % 100 < 12 || n % 100 > 14) ? few : many);

let classesTimer, classesReq = 0;
function loadClasses() {
  ensureGrid();
  clearTimeout(classesTimer);
  classesTimer = setTimeout(async () => {
    const f = state.fields[state.active];
    if (!state.period || !f) return;
    const type = state.active;
    const ids = shownObjects().map(i => i.id).join(',');
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
  if (state.legend) refreshLegendTab();
  loadBusy();
}

// DrawSuppressionS/F: komórki, w których żadne zajęcie nie ma domyślnego przedmiotu / formy - przygaszone (kratka)
function paintSuppression() {
  const g = $('#gridWrap');
  g.querySelectorAll('td.cell.suppressed').forEach(td => td.classList.remove('suppressed'));
  if (!state.classData || !state.suppress || !state.defaults) return;
  const sub = state.suppress.SUB && state.defaults.SUB.items[0], frm = state.suppress.FOR && state.defaults.FOR.items[0];
  if (!sub && !frm) return;
  const byId = new Map(state.classData.classes.map(c => [String(c.id), c]));
  for (const td of g.querySelectorAll('td.cell.busy[data-cla]')) {
    const list = td.dataset.cla.split(',').map(id => byId.get(id)).filter(Boolean);
    const ok = list.some(c => (!sub || String(c.subId) === String(sub.id)) && (!frm || String(c.forId) === String(frm.id)));
    if (!ok) td.classList.add('suppressed');
  }
}

const cellHelpers = {
  colours: cellColours,
  text: lineText,
  descName: i => state.settings.descPlural[i] || `Opis ${i + 1}`,
};
function paintClasses() {
  if (state.classData) fillClasses($('#gridWrap'), state.classData, state.layout, cellHelpers);
  paintSuppression();
  paintMarks();
  // "pokazuj jeden": przełączono obiekt - rozkład wjeżdża z boku
  const table = $('#gridWrap table.semester');
  if (state.slide && table) {
    table.classList.remove('slide-left', 'slide-right');
    void table.offsetWidth;   // ponowne uruchomienie animacji
    table.classList.add(state.slide);
  }
  state.slide = null;
}

// --- okno "Zajęcie" (wygląd komórki) i legenda (podsumowanie godzin) -------------------------
const cellLayoutPanel = new CellLayoutPanel($('#cellLayoutButton'), $('#cellLayout'), {
  getLayout: () => state.layout,
  getSettings: () => state.settings,
  onChange: layout => {
    // "Wszystkie na jednym arkuszu tygodniowym": polecenie - tryb "Wiele obiektów" bez zmian
    if (layout.multi === 'week') {
      cellLayoutPanel.close();
      showWeekOfSelection();
      return;
    }
    const multiChanged = layout.multi !== multiMode();
    state.layout = layout;
    if (multiChanged) updateTitle(); else paintClasses();
    savePrefs();
  },
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

// zakładki legendy: Podsumowanie godzin, Znajdź wykładowcę / grupę / salę (FLegendTabs)
const findPanel = new FindPanel($('#find'), {
  api,
  getCells: () => gridSelection(),
  onShow: (type, item) => { state.fields[type].setItems([{ id: item.id, name: item.name }]); state.active = null; setActive(type); },
  onDetails: (type, item) => browser.open(type, item.id).catch(() => {}),
});
function legendTab() { return state.legendTab || 'summary'; }
function refreshLegendTab() {
  if (!state.legend) return;
  if (legendTab() === 'summary') summaryPanel.refresh(); else findPanel.setType(legendTab());
}
function setLegendTab(tab) {
  state.legendTab = tab;
  $$('#legend .tab[data-tab]').forEach(b => { const on = b.dataset.tab === tab; b.classList.toggle('active', on); b.setAttribute('aria-selected', String(on)); });
  $('#summary').hidden = tab !== 'summary';
  $('#find').hidden = tab === 'summary';
  refreshLegendTab();
}
$$('#legend .tab[data-tab]').forEach(b => b.addEventListener('click', () => { setLegendTab(b.dataset.tab); savePrefs(); }));
// zaznaczenie w siatce: zakładka "Znajdź" liczy dostępność dla nowego zaznaczenia
let findTimer;
$('#gridWrap').addEventListener('gridselect', () => {
  if (!state.legend || legendTab() === 'summary') return;
  clearTimeout(findTimer); findTimer = setTimeout(() => findPanel.refresh(), 250);
});

function setLegend(open, save = true) {
  state.legend = open;
  $('#legend').hidden = !open;
  $('#legendButton').setAttribute('aria-pressed', String(open));
  if (open) setLegendTab(legendTab());
  if (save) savePrefs();
}
$('#legendButton').addEventListener('click', () => setLegend(!state.legend));
$('#legendClose').addEventListener('click', () => setLegend(false));

// liczba zaznaczonych terminów nad siatką
const canInsert = () => !(state.me && state.me.canInsert === false);
$('#gridWrap').addEventListener('gridselect', e => {
  const n = e.detail.count;
  $('#selCount').textContent = n ? `Zaznaczono: ${n} ${plural(n, 'termin', 'terminy', 'terminów')}` : '';
  e.currentTarget.canMove = canInsert() && !subjectView();
  // "Gdzie mogę przenieść zajęcia?" włączony: zaznaczono inne zajęcia - kropki zajętości dla nich;
  // zaznaczenie komórki bez zajęć - kropki znikają (tryb zostaje włączony do następnego zaznaczenia zajęcia)
  if (state.seeAvail.on) {
    const c = seeAvailCollect() || { L: [], G: [], S: [], cla: [] };
    if (JSON.stringify(c) !== JSON.stringify({ L: state.seeAvail.L, G: state.seeAvail.G, S: state.seeAvail.S, cla: state.seeAvail.cla })) {
      Object.assign(state.seeAvail, c);
      paintSeeAvail();
      loadBusy();
    }
  }
});

// --- dodawanie zajęcia (FDetails + okno konfliktów) -------------------------------------------
const addClassDialog = new AddClassDialog({
  api,
  onAdded: r => {
    loadClasses();
    const n = r.count;
    flashTitle(`${r.edited ? 'Zapisano' : 'Dodano'} ${n} ${plural(n, 'zajęcie', 'zajęcia', 'zajęć')}` + (r.replaced ? `, usunięto kolidujących: ${r.replaced}` : '') + (r.warning ? ` – ${r.warning}` : ''));
  },
});
const gridSelection = () => ($('#gridWrap').getSelection ? $('#gridWrap').getSelection() : []);
function readOnlyMsg() { flashTitle('Rozkład przedmiotu jest tylko do podglądu - wybierz wykładowcę, grupę lub salę.', true); }
function openAddClass() {
  if (subjectView()) return readOnlyMsg();
  const cells = gridSelection();
  if (!cells.length || !state.period || !canInsert()) return;
  const prefill = {};
  for (const t of 'LGS') {
    const items = state.fields[t] ? state.fields[t].items : [];
    prefill[t] = state.me.firstResource ? items.slice(0, 1) : items;
  }
  // osobne arkusze obiektów: zaznaczenie w arkuszu jednego obiektu - zajęcie dla tego obiektu
  const objs = $('#gridWrap').getSelectionObjects ? $('#gridWrap').getSelectionObjects() : [];
  if (objs.length) prefill[state.active] = state.fields[state.active].items.filter(i => objs.includes(String(i.id)));
  addClassDialog.open({
    period: state.period.id, cells, prefill, settings: state.settings, user: state.me.user,
    sub: state.defaults.SUB.items[0], form: state.defaults.FOR.items[0],
    hours: state.period.hours.map(h => ({ no: h.no, label: h.caption || String(h.no) })),
  });
}

// edycja zajęcia (bEditClassClick): okno szczegółów z danymi zajęcia klikniętej komórki; zapis zastępuje
// zajęcia zaznaczonych komórek nowymi wartościami
function openEditClass(td, chosen) {
  if (subjectView()) return readOnlyMsg();
  if (!state.period || !canInsert()) return;
  // zaznaczone scalone zajęcia (okno "Zajęcie" - scalanie): edycja wszystkich zajęć grupy, bez pytania
  const group = $('#gridWrap').activeGroup;
  const groupClass = !chosen && group && state.classData.classes.find(x => group.has(x.id));
  // komórka z kilkoma zajęciami (np. "pokazuj w poziomie / w pionie"): najpierw pytanie, które zajęcie edytować
  const cellIds = [...new Set(td.dataset.cla.split(','))];
  if (!chosen && !groupClass && cellIds.length > 1) return pickClass(cellIds, c => openEditClass(td, c));
  const c = chosen || groupClass || state.classData.classes.find(x => String(x.id) === cellIds[0]);
  if (!c) return;
  // wybrane zajęcie: w zaznaczeniu edytowane tylko zajęcia tych samych obiektów (tego samego wykładowcy / grupy / sali),
  // pojedyncza komórka - tylko wybrane zajęcie
  const idsField = { L: 'lecIds', G: 'groIds', S: 'romIds' }[state.active];
  const editIds = groupClass ? [...group] : !chosen ? selectedClassIds()
    : $$('#gridWrap td.cell.selected[data-cla]').length <= 1 ? [c.id]
    : selectedClassIds().filter(id => { const x = state.classData.classes.find(y => y.id === id); return x && x[idsField] === c[idsField]; });
  const items = (list, map) => String(list || '').split(';').filter(Boolean).map(id => ({ id: Number(id), name: (map[id] || {}).label || id }));
  addClassDialog.open({
    period: state.period.id, cells: gridSelection(), settings: state.settings, user: state.me.user,
    prefill: { L: items(c.lecIds, state.classData.lecturers), G: items(c.groIds, state.classData.groups), S: items(c.romIds, state.classData.rooms) },
    sub: c.subId ? { id: c.subId, name: c.subName || c.sub } : null, form: { id: c.forId, name: c.formName || c.form },
    hours: state.period.hours.map(h => ({ no: h.no, label: h.caption || String(h.no) })),
    edit: {
      ids: editIds, kind: c.formKind === 'R' ? 'R' : 'C', fill: c.fill, colour: c.colours.CLASS || null,
      owner: c.owner, createdBy: c.createdBy, desc: c.desc,
    },
  });
}
// okno "Które zajęcie chcesz edytować?": przyciski z nazwami wykładowców / grup / sal (wg aktywnego pola) i przedmiotem
const pickDialog = document.createElement('dialog');
pickDialog.className = 'pick-class';
document.body.append(pickDialog);
function pickClass(ids, onPick) {
  const d = pickDialog;
  d.innerHTML = '';
  const mk = (tag, cls, text) => Object.assign(document.createElement(tag), cls ? { className: cls } : {}, text !== undefined ? { textContent: text } : {});
  const head = mk('div', 'b-head');
  const close = mk('button', 'link close', '×'); close.type = 'button'; close.addEventListener('click', () => d.close());
  head.append(mk('h2', '', 'Które zajęcie chcesz edytować?'), mk('span', 'spacer'), close);
  const body = mk('div', 'pick-body');
  const field = { L: 'lecturers', G: 'groups', S: 'rooms' }[state.active];
  const names = c => String(c[{ L: 'lecIds', G: 'groIds', S: 'romIds' }[state.active]] || '').split(';').filter(Boolean)
    .map(id => (state.classData[field][id] || {}).label || id).join(', ');
  for (const id of ids) {
    const c = state.classData.classes.find(x => String(x.id) === id);
    if (!c) continue;
    const b = mk('button', 'secondary pick-item'); b.type = 'button';
    b.append(mk('b', '', names(c) || (c[field] || '').trim() || '(brak)'),
      mk('span', 'muted', [`${c.subName || c.sub || ''}${c.formName ? ' – ' + c.formName : ''}`,
        field !== 'lecturers' && c.lecturers, field !== 'groups' && c.groups, field !== 'rooms' && (c.rooms || '').trim()].filter(Boolean).join(' · ')));
    b.addEventListener('click', () => { d.close(); onPick(c); });
    body.append(b);
  }
  const actions = mk('div', 'b-actions');
  const cancel = mk('button', 'secondary', 'Anuluj'); cancel.type = 'button'; cancel.addEventListener('click', () => d.close());
  actions.append(cancel);
  d.append(head, body, actions);
  d.showModal();
  const first = body.querySelector('button'); if (first) first.focus();
}

// podwójne kliknięcie (GridDblClick): zajęcie - edycja, pusta komórka - dodawanie
$('#gridWrap').addEventListener('griddblclick', e => {
  if (subjectView()) return subjectCellNavigation(e.detail.cell);
  return e.detail.cell.dataset.cla ? openEditClass(e.detail.cell) : openAddClass();
});
// rozkład przedmiotu: wykładowcy, grupy i sale zajęć komórki - przejście do ich rozkładu (ShowSubjectCellNavigation)
function subjectCellNavigation(td) {
  if (!td || !td.dataset.cla || !state.classData) return;
  const byId = new Map(state.classData.classes.map(c => [String(c.id), c]));
  const list = td.dataset.cla.split(',').map(id => byId.get(id)).filter(Boolean);
  const items = [];
  for (const [t, key, map, head] of [['L', 'lecIds', 'lecturers', 'Wykładowcy'], ['G', 'groIds', 'groups', 'Grupy'], ['S', 'romIds', 'rooms', 'Sale']]) {
    const ids = [...new Set(list.flatMap(c => String(c[key] || '').split(';').filter(Boolean)))];
    if (!ids.length) continue;
    if (items.length) items.push('-');
    for (const id of ids) {
      const name = (state.classData[map][id] || {}).label || id;
      items.push({ label: `${head}: ${name}`, onClick: () => { state.fields[t].setItems([{ id: Number(id), name }]); state.active = null; setActive(t); } });
    }
  }
  if (items.length) openPopup(items, td);
}

// --- usuwanie zajęć zaznaczonych komórek (BDeleteClassClick; klawisz Delete) ------------------------
const canDelete = () => !(state.me && state.me.canDelete === false);
// zaznaczone scalone zajęcia - tylko zajęcia grupy (nie wszystkie zajęcia jej komórek)
const selectedClassIds = () => $('#gridWrap').activeGroup ? [...$('#gridWrap').activeGroup] : [...new Set($$('#gridWrap td.cell.selected[data-cla]').flatMap(td => td.dataset.cla.split(',').map(Number)))];
async function deleteSelected() {
  if (subjectView()) return readOnlyMsg();
  const ids = selectedClassIds();
  if (!ids.length) return flashTitle('Zaznacz zajęcia do usunięcia.', true);
  if (!canDelete()) return flashTitle('Nie możesz usuwać zajęć.', true);
  let r;
  try { r = await api('classes/delete', { ids }); } catch (e) { if (e.message !== '401') flashTitle(e.message, true); loadClasses(); return; }
  loadClasses();
  flashTitle(`Usunięto ${r.count} ${plural(r.count, 'zajęcie', 'zajęcia', 'zajęć')}`);
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
  clip = { keys, mode, only: g.activeGroup };   // scalona grupa - tylko jej zajęcia
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
  const m = g.movesFor(clip.keys, dr, dc, clip.only);
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
  else if (e.key === 'Delete') { e.preventDefault(); deleteSelected(); }
  else if ((e.ctrlKey || e.metaKey) && k === 'c') { e.preventDefault(); clipCopy('copy'); }
  else if ((e.ctrlKey || e.metaKey) && k === 'x') { e.preventDefault(); if (canInsert()) clipCopy('cut'); }
  else if ((e.ctrlKey || e.metaKey) && k === 'v') { e.preventDefault(); if (canInsert()) clipPaste(); }
  else if (e.key === 'Escape' && clip) clipClear();
});

// --- "Gdzie mogę przenieść zajęcia?" (bSeeAvailable): przycisk dwustanowy - włączony pokazuje kropkami terminy, do których
//     nie można przenieść zaznaczonych zajęć (wszyscy wykładowcy, grupy i zasoby wszystkich zaznaczonych zajęć, z wykluczeniami);
//     pola wyboru i "pokaż wolne terminy" bez zmian (zaznaczone "wolne terminy" są uwzględniane dodatkowo) ----------------
// zasoby i identyfikatory zajęć z zaznaczonych komórek; null - w zaznaczeniu nie ma zajęć
function seeAvailCollect() {
  if (!state.classData) return null;
  const byId = new Map(state.classData.classes.map(c => [String(c.id), c]));
  const sets = { L: new Set(), G: new Set(), S: new Set() }, cla = new Set(), objs = new Set();
  const split = v => String(v || '').split(';').map(x => x.trim()).filter(Boolean);
  for (const td of $$('#gridWrap td.cell.selected[data-cla]')) {
    const group = $('#gridWrap').activeGroup;
    for (const id of td.dataset.cla.split(',')) {
      const c = byId.get(id);
      if (!c || (group && !group.has(c.id))) continue;
      split(c.lecIds).forEach(x => sets.L.add(x));
      split(c.groIds).forEach(x => sets.G.add(x));
      split(c.romIds).forEach(x => sets.S.add(x));
      cla.add(id);
      if (state.week && td.dataset.obj) objs.add(td.dataset.obj);
    }
  }
  if (!cla.size) return null;
  // układ tygodniowy (obiekty w kolumnach): zajęcie przeniesione do innej kolumny dostaje obiekt tej kolumny,
  // więc zajętość obiektu kolumny, z której pochodzi, nie jest konfliktem - nie jest sprawdzana
  if (state.week) objs.forEach(o => sets[state.active] && sets[state.active].delete(o));
  return { L: [...sets.L], G: [...sets.G], S: [...sets.S], cla: [...cla] };
}

// wygląd przycisku i podpowiedź z obiektami, dla których sprawdzana jest dostępność (każdy w osobnej linii)
function paintSeeAvail() {
  const b = $('#seeAvailButton');
  const av = state.seeAvail;
  b.classList.toggle('on', av.on);
  b.setAttribute('aria-pressed', String(av.on));
  if (!av.on) { b.title = 'Gdzie mogę przenieść zajęcie?'; return; }
  const d = state.classData || { lecturers: {}, groups: {}, rooms: {} };
  const names = (ids, map) => ids.map(id => '   ' + ((map[id] || {}).label || id)).join('\n');
  const parts = ['Gdzie mogę przenieść zajęcie? - WŁĄCZONE (kliknij, aby wyłączyć)',
    av.cla.length ? 'Kropki pokazują terminy, w których zajęte są obiekty zaznaczonych zajęć:' : 'Zaznacz zajęcie, aby zobaczyć, gdzie można je przenieść.'];
  if (av.L.length) parts.push('Wykładowcy:\n' + names(av.L, d.lecturers));
  if (av.G.length) parts.push('Grupy:\n' + names(av.G, d.groups));
  if (av.S.length) parts.push('Zasoby:\n' + names(av.S, d.rooms));
  b.title = parts.join('\n');
}

function seeAvailToggle() {
  if (state.seeAvail.on) {
    state.seeAvail = { on: false, L: [], G: [], S: [], cla: [] };
  } else {
    const c = seeAvailCollect();
    if (!c) return flashTitle('Zaznacz zajęcie.', true);
    state.seeAvail = { on: true, ...c };
  }
  paintSeeAvail();
  loadBusy();
}
$('#seeAvailButton').addEventListener('click', seeAvailToggle);

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

// --- okno narzędzi przy siatce (FToolWindow): po zaznaczeniu kilku komórek i prawym przyciskiem ---------------
const canEdit = k => !(state.me && state.me.canEdit && state.me.canEdit[k] === false);
const canEditAll = () => 'LGRSFOD'.split('').every(canEdit);
// zmiana zaznaczonych zajęć (modifyClasses w Delphi) - menu Edytuj i Usuń
async function modifySelected(op, value, extra = {}) {
  const ids = selectedClassIds();
  if (!ids.length) return flashTitle('Zaznacz zajęcia.', true);
  let r;
  try { r = await api('classes/modify', { ids, op, value, ...extra }); }
  catch (e) { if (e.message !== '401') flashTitle(e.message, true); loadClasses(); return; }
  loadClasses();
  flashTitle(r.count ? `Zmieniono ${r.count} ${plural(r.count, 'zajęcie', 'zajęcia', 'zajęć')}` + (r.removed ? `, usunięto zajęć bez wykładowców, grup i zasobów: ${r.removed}` : '') : 'Bez zmian.');
}
const objSearch = type => q => api(`objects/${type}?q=${encodeURIComponent(q)}`);
const plannerSearch = q => api(`lookup/PLANNER?q=${encodeURIComponent(q)}`).then(rows => rows.map(r => ({ id: r.name, name: r.name })));
const OBJ = { L: ['wykładowcę', 'Wykładowcy'], G: ['grupę', 'Grupy'], S: ['zasób', 'Zasoby'] };
async function attachObjects(t, onlyIfEmpty) {
  const items = await pickItems({ title: `Dołącz ${OBJ[t][0]}`, label: OBJ[t][1], search: objSearch(t),
    info: onlyIfEmpty ? 'Tylko do zajęć, które nie mają jeszcze przydzielonego obiektu tego rodzaju.' : null });
  if (items) modifySelected('attach' + t, items.map(i => i.id), { onlyIfEmpty });
}
async function unplugObjects(t, all) {
  // jak deleteLecFromSelection: w arkuszu tego rodzaju odłączenie może usunąć zajęcia z bieżącego arkusza
  if (t === state.active && !confirm('Wybrano polecenie odłączenia. Spowoduje to, że zajęcia znikną z bieżącego arkusza, o ile bieżący obiekt zostanie odłączony. Czy kontynuować?')) return;
  if (all) return modifySelected('delete' + t, []);
  const items = await pickItems({ title: `Usuń ${OBJ[t][0]} - wybranego / wybranych`, label: OBJ[t][1], search: objSearch(t) });
  if (items) modifySelected('delete' + t, items.map(i => i.id));
}
async function pickPlanner(title) {
  const items = await pickItems({ title, label: 'Planista', search: plannerSearch, single: true });
  return items ? items[0].name : null;
}
const descName = i => ((state.settings && state.settings.descPlural) || [])[i - 1] || '';
async function changeDesc(i) {
  const v = await pickDesc({ title: `Zmień ${descName(i)}`, load: q => api(`desc-values?type=${encodeURIComponent(descName(i))}&q=${encodeURIComponent(q)}`) });
  if (v !== null) modifySelected('changeDesc' + i, v);
}

// EditPopup (beditpopup)
function editPopupItems() {
  const claTd = $('#gridWrap td.cell.selected[data-cla]');
  const has = !!claTd;
  const attach = t => [
    { label: 'Gdy nie ma', onClick: () => attachObjects(t, true) },
    { label: 'Bez względu na to, czy przydzielono', onClick: () => attachObjects(t, false) },
  ];
  const items = [
    { label: 'Edytuj', onClick: () => openEditClass(claTd), disabled: !has },
    { label: 'Dołącz wykładowcę', sub: attach('L'), disabled: !has || !canEdit('L') },
    { label: 'Dołącz grupę', sub: attach('G'), disabled: !has || !canEdit('G') },
    { label: 'Dołącz zasób', sub: attach('S'), disabled: !has || !canEdit('R') },
    { label: 'Dołącz właściciela', disabled: !has || !canEdit('O'), onClick: async () => { const p = await pickPlanner('Dołącz właściciela'); if (p) modifySelected('attachOwner', p); } },
    { label: 'Zmień przedmiot', disabled: !has || !canEdit('S'), onClick: async () => {
      const it = await pickItems({ title: 'Zmień przedmiot', label: 'Przedmiot', search: objSearch('SUB'), single: true });
      if (it) modifySelected('changeSub', it[0].id);
    } },
    { label: 'Zmień formę zajęć', disabled: !has || !canEdit('F'), onClick: async () => {
      const it = await pickItems({ title: 'Zmień formę zajęć', label: 'Forma zajęć', search: objSearch('FOR'), single: true });
      if (it) modifySelected('changeFor', it[0].id);
    } },
    { label: 'Zmień właściciela', disabled: !has || !canEdit('O'), onClick: async () => { const p = await pickPlanner('Zmień właściciela'); if (p) modifySelected('changeOwner', p); } },
    { label: 'Zmień kolor zajęcia', disabled: !has || !canEditAll(), onClick: async () => { const c = await pickColour('Zmień kolor zajęcia'); if (c) modifySelected('changeColour', c); } },
  ];
  for (const i of [1, 2, 3, 4]) if (descName(i)) items.push({ label: 'Zmień ' + descName(i), disabled: !has || !canEdit('D'), onClick: () => changeDesc(i) });
  return items;
}
// DelPopup (bdelpopup)
function delPopupItems() {
  const has = !!$('#gridWrap td.cell.selected[data-cla]');
  const unplug = (t, allLabel, oneLabel) => [
    { label: allLabel, onClick: () => unplugObjects(t, true) },
    { label: oneLabel, onClick: () => unplugObjects(t, false) },
  ];
  const items = [
    { label: 'Usuń', onClick: deleteSelected, disabled: !has || !canDelete() },
    { label: 'Usuń wykładowcę', sub: unplug('L', 'Wszystkich', 'Wybranego / wybranych'), disabled: !has || !canEdit('L') },
    { label: 'Usuń grupę', sub: unplug('G', 'Wszystkie', 'Wybraną / wybrane'), disabled: !has || !canEdit('G') },
    { label: 'Usuń zasób', sub: unplug('S', 'Wszystkie', 'Wybrany/ wybrane'), disabled: !has || !canEdit('R') },
    { label: 'Odłącz właściciela', disabled: !has || !canEdit('O'), sub: [
      { label: 'Przywróć domyślnego', onClick: () => modifySelected('deleteOwner', '') },
      { label: 'Odłącz wybranego', onClick: async () => { const p = await pickPlanner('Odłącz właściciela'); if (p) modifySelected('deleteOwner', p); } },
    ] },
    { label: 'Usuń przedmiot', onClick: () => modifySelected('deleteSub'), disabled: !has || !canEdit('S') },
  ];
  for (const i of [1, 2, 3, 4]) if (descName(i)) items.push({ label: 'Usuń ' + descName(i), disabled: !has || !canEdit('D'), onClick: () => modifySelected('deleteDesc' + i) });
  return items;
}
// FavouritePopup (bfavpopup): oceny z ikonami z FavIL (ImageIndex jak w Delphi), "Lista", widok preferencji
const FAV_ICONS = { [-999]: 0, [-750]: 1, [-500]: 2, [-300]: 3, 300: 7, 500: 6, 750: 5, 999: 4 };
function favPopupItems() {
  const f = state.fields[state.active];
  const who = f && f.items[0];
  const sel = gridSelection().length;
  return [
    ...RATINGS.map(([v, l]) => ({ label: l, icon: FAV_ICONS[v] !== undefined ? `fav${FAV_ICONS[v]}.png` : null, onClick: () => setRating(v), disabled: !who || !sel })),
    '-',
    { label: 'Lista', onClick: () => hintsList({ api, period: state.period.id, objects: f ? f.items : [], onChanged: loadBusy }), disabled: !state.period },
    '-',
    { label: (state.fav === 'off' ? '● ' : '○ ') + 'Wyłącz preferowane terminy', onClick: () => setFavView('off') },
    { label: (state.fav === 'current' ? '● ' : '○ ') + 'Włącz preferowane terminy - bieżący obiekt', onClick: () => setFavView('current') },
    { label: (state.fav === 'all' ? '● ' : '○ ') + 'Włącz preferowane terminy - wszystkie obiekty', onClick: () => setFavView('all') },
  ];
}
// strzałki: przesunięcie zaznaczonych zajęć o jedną komórkę (bmoveUpClick... - modifyClasses clMove)
function moveBy(dr, dc) {
  const g = $('#gridWrap');
  const keys = g.getSelectionKeys ? g.getSelectionKeys() : [];
  if (!keys.length) return;
  runMove({ ...g.movesFor(keys, dr, dc, g.activeGroup), copy: false });
}

const toolWindow = new ToolWindow({
  actions: {
    addClass: () => openAddClass(),
    editClass: () => { const td = $('#gridWrap td.cell.selected[data-cla]'); if (td) openEditClass(td); else flashTitle('Zaznacz zajęcie.', true); },
    editPopup: b => openPopup(editPopupItems(), b),
    deleteClass: () => deleteSelected(),
    delPopup: b => openPopup(delPopupItems(), b),
    copyArea: () => clipCopy('copy'),
    cutArea: () => clipCopy('cut'),
    pasteArea: () => clipPaste(),
    clearSelection: () => clipClear(),
    moveUp: () => moveBy(-1, 0),
    moveDown: () => moveBy(1, 0),
    moveLeft: () => moveBy(0, -1),
    moveRight: () => moveBy(0, 1),
    favPopup: b => openPopup(favPopupItems(), b),
  },
  // jak showtoolwindow: dostępność przycisków wg uprawnień planisty
  enabled: () => {
    const ins = canInsert(), del = canDelete(), mv = ins && del;
    return {
      addClass: ins, deleteClass: del, delPopup: del || 'LGRSFOD'.split('').some(canEdit),
      cutArea: del, pasteArea: ins, copyArea: ins || del, clearSelection: ins || del,
      moveUp: mv, moveDown: mv, moveLeft: mv, moveRight: mv,
    };
  },
});
// GridMouseUp: zaznaczono co najmniej 2 komórki albo prawy przycisk - okno narzędzi; kliknięcie siatki - ukrycie
$('#gridWrap').addEventListener('gridmouseup', e => { if (e.detail.count >= 2 && !subjectView()) toolWindow.show(e.detail.x, e.detail.y); });
$('#gridWrap').addEventListener('gridcontext', e => { if (subjectView()) subjectCellNavigation(e.detail.cell); else toolWindow.show(e.detail.x, e.detail.y); });
$('#gridWrap').addEventListener('mousedown', () => toolWindow.hide());
document.addEventListener('keydown', e => { if (e.key === 'Escape' && !toolWindow.el.hidden && !document.querySelector('.tw-menu')) toolWindow.hide(); });
$('#gridWrap').addEventListener('scroll', () => toolWindow.hide());

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
  // siatka godzinowa: etykiety godzin pochodzą z okresu - okres wczytywany od nowa
  onChanged: type => { if (state.period) (type === 'GRID' || type === 'PER' ? reloadPeriod() : loadClasses()); },
});
const dataMenu = $('#dataMenu'), dataMenuButton = $('#dataMenuButton');
function setDataMenu(open) { dataMenu.hidden = !open; dataMenuButton.setAttribute('aria-expanded', String(open)); }
dataMenuButton.addEventListener('click', () => setDataMenu(dataMenu.hidden));
document.addEventListener('mousedown', e => { if (!dataMenu.hidden && !dataMenu.parentElement.contains(e.target)) setDataMenu(false); });
dataMenu.addEventListener('keydown', e => { if (e.key === 'Escape') { setDataMenu(false); dataMenuButton.focus(); } });
// "Edytuj okres" (EditPeriodClick: PERIODSShowModalAsSingleRecord(aedit)) - po zapisie okres wczytywany od nowa
$('#editPeriodButton').addEventListener('click', () => {
  if (!state.period) return;
  browser.openRecord('PER', state.period.id).catch(e => { if (e.message !== '401') flashTitle(e.message, true); });
});
$$('#dataMenu [data-browse]').forEach(b => b.addEventListener('click', async () => {
  setDataMenu(false);
  try { await browser.open(b.dataset.browse); } catch (e) { if (e.message !== '401') console.error(e); }
}));

// --- Uprawnienia do obiektów (UFPlannerPermissions; wymaga EDIT_OBJ_PERMISSIONS) ----------------------
let permissionsWindow = null;
$('#permissionsMenu').addEventListener('click', () => {
  setDataMenu(false);
  if (state.me && state.me.editPermissions === false) return flashTitle('Nie posiadasz uprawnień do uruchomienia funkcji Uprawnienia', true);
  if (!permissionsWindow) permissionsWindow = new PermissionsWindow({ api });
  permissionsWindow.open();
});

// --- Raportowanie (FGrouping): bieżący okres, wybrane obiekty i zaznaczone terminy z okna głównego --------
let reportWindow = null;
$('#reportMenu').addEventListener('click', () => {
  setDataMenu(false);
  if (!reportWindow) {
    reportWindow = new ReportWindow({
      api,
      getContext: () => ({
        user: state.me.user, period: state.period, settings: state.settings, cells: gridSelection(),
        objects: Object.fromEntries('LGS'.split('').map(t => [t, state.fields[t] ? state.fields[t].items : []])),
      }),
    });
  }
  reportWindow.open().catch(e => { if (e.message !== '401') flashTitle(e.message, true); });
});

// --- narzędzia: lista obecności, dostępne miejsce, dziennik zdarzeń, oczekujące zadania ------------------
let toolsWindow = null;
$$('#dataMenu [data-tool], #reportsMenu [data-tool]').forEach(b => b.addEventListener('click', () => {
  setDataMenu(false); setReportsMenu(false);
  if (!toolsWindow) toolsWindow = new ToolsWindow({ api });
  Promise.resolve(toolsWindow[b.dataset.tool]()).catch(e => { if (e.message !== '401') flashTitle(e.message, true); });
}));

// --- menu "Raporty i publikowanie": Raportowanie, Tabela przestawna, Lista obecności ----------------------
const reportsMenu = $('#reportsMenu'), reportsMenuButton = $('#reportsMenuButton');
function setReportsMenu(open) { reportsMenu.hidden = !open; reportsMenuButton.setAttribute('aria-expanded', String(open)); }
reportsMenuButton.addEventListener('click', () => setReportsMenu(reportsMenu.hidden));
document.addEventListener('mousedown', e => { if (!reportsMenu.hidden && !reportsMenu.parentElement.contains(e.target)) setReportsMenu(false); });
reportsMenu.addEventListener('keydown', e => { if (e.key === 'Escape') { setReportsMenu(false); reportsMenuButton.focus(); } });
reportsMenu.addEventListener('click', e => { if (e.target.closest('button')) setReportsMenu(false); });

// tabela przestawna (FMatrix)
let pivotWindow = null;
function openPivot(preset) {
  if (!pivotWindow) {
    pivotWindow = new PivotWindow({
      api,
      getContext: () => ({
        user: state.me.user, period: state.period, settings: state.settings,
        objects: Object.fromEntries('LGS'.split('').map(t => [t, state.fields[t] ? state.fields[t].items : []])),
      }),
    });
  }
  pivotWindow.open(preset);
}
$('#pivotMenu').addEventListener('click', () => openPivot());

// --- dni wolne okresu --------------------------------------------------------------------------------
async function loadHolidays() {
  if (!state.period) return;
  try { state.holidays = (await api(`holidays?period=${state.period.id}`)).items; } catch { state.holidays = []; }
  paintMarks();
}
let holidaysWindow = null;
$('#holidaysMenu').addEventListener('click', () => {
  setDataMenu(false);
  if (!state.period) return;
  if (!holidaysWindow) holidaysWindow = new HolidaysWindow({ api, getPeriod: () => state.period, getSelection: gridSelection, onChanged: loadHolidays });
  holidaysWindow.open().catch(e => { if (e.message !== '401') flashTitle(e.message, true); });
});

// --- Idź do daty (GoToDateClick + FSelectDate): data, "Wybierz" (przedwczoraj ... pojutrze), dni tygodnia
//     (pierwszy taki dzień w okresie; dni niewidoczne w okresie - nieaktywne); wybrana data zaznaczona i widoczna ---
const gotoDialog = document.createElement('dialog');
gotoDialog.className = 'pick-class goto-date';
document.body.append(gotoDialog);
const isoDay = t => new Date(t).toISOString().slice(0, 10);
function goToDate(date) {
  const g = $('#gridWrap');
  const td = g.querySelector(`td.cell[data-date="${date}"]`);
  if (!td) return false;
  state.gotoDate = date;
  g.setSelectionKeys([td.dataset.row + ',' + td.dataset.col]);
  td.scrollIntoView({ block: 'center', inline: 'center', behavior: 'smooth' });
  return true;
}
// pierwszy dzień tygodnia wd (0 = poniedziałek) w okresie - getFirstDayOfWeekInPeriod
function firstWeekdayInPeriod(wd) {
  const from = Date.parse(state.period.dateFrom + 'T00:00:00Z'), to = Date.parse(state.period.dateTo + 'T00:00:00Z');
  const cur = (new Date(from).getUTCDay() + 6) % 7;
  const t = from + ((wd - cur + 7) % 7) * 864e5;
  return t <= to ? isoDay(t) : null;
}
$('#goToDateButton').addEventListener('click', () => {
  if (!state.period) return;
  const d = gotoDialog;
  d.innerHTML = '';
  const today = isoDay(Date.now());
  const head = Object.assign(document.createElement('div'), { className: 'b-head' });
  const close = Object.assign(document.createElement('button'), { type: 'button', className: 'link close', textContent: '×', title: 'Anuluj' });
  close.addEventListener('click', () => d.close());
  head.append(Object.assign(document.createElement('h2'), { textContent: 'Wybierz datę' }), Object.assign(document.createElement('span'), { className: 'spacer' }), close);
  const body = Object.assign(document.createElement('div'), { className: 'pick-body' });
  const row = Object.assign(document.createElement('div'), { className: 'goto-row' });
  const input = Object.assign(document.createElement('input'), { type: 'date', value: state.gotoDate || today });
  input.setAttribute('aria-label', 'Data');
  const err = Object.assign(document.createElement('p'), { className: 'error', hidden: true });
  const choose = date => {
    if (!date) { err.textContent = 'W okresie nie ma takiego dnia tygodnia'; err.hidden = false; return; }
    input.value = date;
    if (goToDate(date)) d.close();
    else { err.textContent = 'Nie ma takiej daty w bieżącym rozkładzie'; err.hidden = false; }
  };
  // "Wybierz": przedwczoraj, wczoraj, dziś, jutro, pojutrze (SelectDates)
  const pick = Object.assign(document.createElement('button'), { type: 'button', className: 'secondary', textContent: 'Wybierz ▾' });
  pick.addEventListener('click', () => openPopup([-2, -1, 0, 1, 2].map(n => ({
    label: ['Przedwczoraj', 'Wczoraj', 'Dziś', 'Jutro', 'Pojutrze'][n + 2],
    onClick: () => choose(isoDay(Date.parse(today + 'T00:00:00Z') + n * 864e5)),
  })), pick));
  row.append(input, pick);
  // dni tygodnia D1..D7: pierwszy taki dzień w okresie
  const days = Object.assign(document.createElement('div'), { className: 'goto-days' });
  ['Poniedziałek', 'Wtorek', 'Środa', 'Czwartek', 'Piątek', 'Sobota', 'Niedziela'].forEach((name, wd) => {
    const b = Object.assign(document.createElement('button'), { type: 'button', className: 'secondary', textContent: name });
    b.disabled = !state.period.days[wd];
    b.title = b.disabled ? 'Ten dzień tygodnia nie jest widoczny w okresie' : `Pierwszy dzień „${name.toLowerCase()}” w okresie`;
    b.addEventListener('click', () => choose(firstWeekdayInPeriod(wd)));
    days.append(b);
  });
  body.append(row, days, err);
  const actions = Object.assign(document.createElement('div'), { className: 'b-actions goto-actions' });
  const ok = Object.assign(document.createElement('button'), { type: 'button', className: 'primary', textContent: 'OK' });
  ok.addEventListener('click', () => choose(input.value));
  const cancel = Object.assign(document.createElement('button'), { type: 'button', className: 'secondary', textContent: 'Anuluj' });
  cancel.addEventListener('click', () => d.close());
  actions.append(ok, cancel);
  input.addEventListener('keydown', e => { if (e.key === 'Enter') { e.preventDefault(); choose(input.value); } });
  d.append(head, body, actions);
  d.showModal();
  input.focus();
});

// --- Podgląd (Preview / PPreview): strona do wydruku -----------------------------------------------------
function previewTitle() {
  const shown = shownObjects();
  return `Rozkład zajęć – ${TYPE_NAMES[state.active]}: ${shown.map(i => i.name).join(', ')}`;
}
const previewSubtitle = () => `Okres ${state.period.name} (${state.period.dateFrom} – ${state.period.dateTo})`;
$('#previewButton').addEventListener('click', e => {
  if (!state.period) return;
  const has = !!(state.fields[state.active] && state.fields[state.active].items.length);
  openPopup([
    { label: state.week ? 'Tygodniowy rozkład zajęć' : 'Semestralny rozkład zajęć', disabled: !has,
      onClick: () => previewGrid({ title: previewTitle(), subtitle: previewSubtitle(), gridWrap: $('#gridWrap') }) },
    ...(state.week ? [] : [{ label: 'Tygodniowy rozkład zajęć (Plan lekcji)', disabled: !has || !state.classData,
      onClick: () => previewWeeklyPlan({ title: previewTitle().replace('Rozkład zajęć', 'Plan lekcji'), subtitle: previewSubtitle(), period: state.period, data: state.classData, settings: state.settings }) }]),
    '-',
    { label: 'Zaawansowane: własny układ', onClick: () => openPivot({ rows: ['hour', '', ''], col: 'dayOfWeek' }) },
  ], e.currentTarget);
});

// --- SwitchMenu: panel z poleceniami menu (filtrowanymi wyszukiwaniem) i znalezionymi obiektami -----------------
// obiekt z wyszukiwania: Rozkład (do pola wyboru) / Szczegóły (okno słownika) - jak FActionTree w Delphi
const sideMenu = $('#sideMenu'), sideList = $('#sideList'), sideSearch = $('#sideSearch');
function sideCommands() {
  const cmds = [];
  const add = (group, label, run) => cmds.push({ group, label, run });
  $$('#dataMenu button[role=menuitem]').forEach(b => add('Dane', b.textContent, () => b.click()));
  $$('#reportsMenu button[role=menuitem]').forEach(b => add('Raporty i publikowanie', b.textContent, () => b.click()));
  add('Okres', 'Zmień okres', () => $('#periodButton').click());
  add('Okres', 'Edytuj okres', () => $('#editPeriodButton').click());
  add('Siatka', 'Idź do daty', () => $('#goToDateButton').click());
  add('Siatka', 'Podgląd', () => $('#previewButton').click());
  add('Siatka', 'Gdzie mogę przenieść zajęcie?', () => $('#seeAvailButton').click());
  add('Siatka', 'Układ', () => $('#cellLayoutButton').click());
  add('Siatka', 'Legenda', () => $('#legendButton').click());
  return cmds;
}
let sideReq = 0, sideTimer;
async function renderSide() {
  const q = sideSearch.value.trim();
  const norm = t => t.toLowerCase().normalize('NFD').replace(/[̀-ͯ]/g, '').replace(/ł/g, 'l');
  const phrases = q.split(',').map(x => norm(x.trim())).filter(Boolean);
  const match = t => !phrases.length || phrases.some(p => norm(t).includes(p));
  sideList.innerHTML = '';
  let group = null;
  for (const c of sideCommands().filter(c => match(c.label) || match(c.group))) {
    if (c.group !== group) { group = c.group; sideList.append(Object.assign(document.createElement('div'), { className: 'side-group', textContent: group })); }
    const b = Object.assign(document.createElement('button'), { type: 'button', className: 'side-item', textContent: c.label });
    b.addEventListener('click', c.run);
    sideList.append(b);
  }
  if (q.length < 2) return;
  const req = ++sideReq;
  const found = await Promise.all(['L', 'G', 'S'].map(t => api(`objects/${t}?q=${encodeURIComponent(q)}`).then(r => r.slice(0, 15)).catch(() => [])));
  if (req !== sideReq) return;
  ['L', 'G', 'S'].forEach((t, i) => {
    if (!found[i].length) return;
    sideList.append(Object.assign(document.createElement('div'), { className: 'side-group', textContent: { L: 'Wykładowcy', G: 'Grupy', S: 'Sale' }[t] }));
    for (const o of found[i]) {
      const row = Object.assign(document.createElement('div'), { className: 'side-obj' });
      row.append(Object.assign(document.createElement('span'), { className: 'side-obj-name', textContent: o.name + (o.org ? ' · ' + o.org : ''), title: o.name }));
      const show = Object.assign(document.createElement('button'), { type: 'button', className: 'link', textContent: 'Rozkład', title: 'Pokaż rozkład' });
      show.addEventListener('click', () => { state.fields[t].setItems([{ id: o.id, name: o.name }]); state.active = null; setActive(t); });
      const det = Object.assign(document.createElement('button'), { type: 'button', className: 'link', textContent: 'Szczegóły' });
      det.addEventListener('click', () => browser.open(t, o.id).catch(() => {}));
      row.append(show, det);
      sideList.append(row);
    }
  });
}
function setSideMenu(open, save = true) {
  sideMenu.hidden = !open;
  $('#viewMain').classList.toggle('side-open', open);
  $('#switchMenuButton').setAttribute('aria-pressed', String(open));
  if (open) renderSide();
  if (save) { try { localStorage.setItem('plansoft.web.sidemenu', open ? '+' : '-'); } catch { /* brak pamięci */ } }
}
$('#switchMenuButton').addEventListener('click', () => { setSideMenu(sideMenu.hidden); if (!sideMenu.hidden) sideSearch.focus(); });
sideSearch.addEventListener('input', () => { clearTimeout(sideTimer); sideTimer = setTimeout(renderSide, 250); });
sideSearch.addEventListener('keydown', e => { if (e.key === 'Escape') { sideSearch.value = ''; renderSide(); } });
try { if (localStorage.getItem('plansoft.web.sidemenu') === '+') setSideMenu(true, false); } catch { /* brak pamięci */ }

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
