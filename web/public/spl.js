// Plan studiów 2 (SPL_ITEMS) - jak w Delphi:
//  SplPanel  - lista "Plan studiów" przy siatce (TreeMode "Plan studiów"): pozycje do zaplanowania i zaplanowane
//              dla wykładowcy / grupy / sali widoku; kliknięcie wybiera pozycję ("Gdzie przenieść?" pokazuje, gdzie
//              można ją umieścić), przeciągnięcie na siatkę - dodawanie zajęcia z danymi pozycji
//  SplWindow - okno "Plan studiów" (UFBrowseSPL_ITEMS): filtry, Porównanie z rozkładem, Przelicz, Powiązane zajęcia,
//              dodaj/zapisz/usuń; tryb wyboru (BSelectComb / "Wybierz kombinację") zwraca zaznaczone pozycje
import { ChipField } from './chips.js';
import { withProgress } from './progress.js';

export const SPL_DRAG_TYPE = 'application/x-plansoft-spl';

function el(tag, cls, text) {
  const e = document.createElement(tag);
  if (cls) e.className = cls;
  if (text !== undefined && text !== null) e.textContent = text;
  return e;
}
function button(text, cls, onClick, title) {
  const b = el('button', cls || 'secondary small', text);
  b.type = 'button';
  if (title) b.title = title;
  b.addEventListener('click', onClick);
  return b;
}
const fmt = n => (Math.round(Number(n || 0) * 100) / 100).toLocaleString('pl-PL');
export const splCaption = i => `${i.sub}, ${i.form} - ${i.gro}${i.lec ? ', ' + i.lec : ''}`;

// --- lista przy siatce (TreeMode "Plan studiów" w Delphi) --------------------------------------------
// szukaj (kilka fraz po przecinku), Sortuj, zakres (obiekt widoku / wszystkie w okresie), stan, Edycja;
// tabela: klik w nagłówek sortuje, klik w pozycję - kropki "Plan" w siatce, przeciągnięcie na siatkę - dodaj zajęcie
const POL = { 'Ą': 'A', 'Ć': 'C', 'Ę': 'E', 'Ł': 'L', 'Ń': 'N', 'Ó': 'O', 'Ś': 'S', 'Ź': 'Z', 'Ż': 'Z' };
const norm = v => String(v || '').toUpperCase().replace(/[ĄĆĘŁŃÓŚŹŻ]/g, c => POL[c]);
const COLS = [
  ['Przedmiot', i => i.sub], ['Forma', i => i.form], ['Grupa', i => i.gro], ['Wykładowca', i => i.lec],
  ['Zapl. / plan', i => i.planned - i.scheduled], ['Okres', i => i.per],
];
// Sortuj: [nazwa, kolumna (-1: kolejność planu), malejąco]
const SORTS = [['kolejność', -1, false], ['przedmiot', 0, false], ['forma', 1, false], ['grupa', 2, false],
  ['wykładowca', 3, false], ['do zaplanowania', 4, true], ['okres', 5, false]];

export class SplPanel {
  // getContext() -> { period, type: 'L'|'G'|'S'|..., ids: [..] }; onSelect(item | null); onEdit(); onSchedule(item) - "Rozplanuj"
  constructor(root, { api, getContext, onSelect, onEdit, onSchedule }) {
    this.onSchedule = onSchedule || (() => {});
    this.root = root;
    this.api = api;
    this.getContext = getContext;
    this.onSelect = onSelect || (() => {});
    this.onEdit = onEdit || (() => {});
    this.selected = null;
    this.items = [];
    this.req = 0;
    this.sortCol = -1;
    this.sortDesc = false;
    root.innerHTML = '';
    const bar1 = el('div', 'bar spl-bar');
    this.search = el('input');
    this.search.type = 'search';
    this.search.placeholder = 'Szukaj: przedmiot, forma, grupa, wykładowca, okres';
    this.search.title = 'Kilka fraz oddziel przecinkiem';
    this.search.addEventListener('input', () => this.render());
    this.sort = el('select');
    this.sort.title = 'Porządek listy (także kliknięcie nagłówka kolumny)';
    SORTS.forEach(([n], k) => this.sort.append(new Option('Sortuj: ' + n, String(k))));
    this.sort.addEventListener('change', () => { const [, c, d] = SORTS[Number(this.sort.value)]; this.sortCol = c; this.sortDesc = d; this.render(); });
    bar1.append(this.search, this.sort);
    const bar2 = el('div', 'bar spl-bar');
    this.scope = el('select');
    this.scope.title = 'Pozycje planu: wykładowcy / grupy / sali z siatki albo wszystkie w okresie siatki';
    this.scope.append(new Option('Obiekt widoku', 'obj'), new Option('Wszystkie w okresie', 'all'));
    this.scope.addEventListener('change', () => this.refresh());
    this.status = el('select');
    this.status.append(new Option('Wszystkie', '0'), new Option('Do zaplanowania', '1'), new Option('Zaplanowane', '2'));
    this.status.addEventListener('change', () => this.render());
    bar2.append(this.scope, this.status, button('Edycja', 'secondary small', () => this.onEdit(), 'Okno "Plan studiów": edycja pozycji, filtry, Przelicz, Powiązane zajęcia'));
    this.info = el('div', 'muted spl-info', '');
    this.list = el('div', 'table-wrap spl-list');
    root.append(bar1, bar2, this.info, this.list);
  }

  async refresh() {
    const ctx = this.getContext();
    const req = ++this.req;
    const all = this.scope.value === 'all';
    if (!ctx.period) return this.load([], 'Wybierz okres.');
    if (!all && !['L', 'G', 'S'].includes(ctx.type)) return this.load([], 'Plan studiów: widok wykładowcy, grupy lub sali (albo zakres "Wszystkie w okresie").');
    if (!all && !ctx.ids.length) return this.load([], 'Wybierz wykładowcę, grupę lub salę.');
    let r;
    try { r = await this.api(`spl/panel?period=${ctx.period}&type=${ctx.type}&ids=${ctx.ids.join(',')}${all ? '&scope=all' : ''}`); }
    catch (e) { if (req === this.req && e.message !== '401') this.load([], e.message); return; }
    if (req !== this.req) return;
    this.load(r.items, r.items.length ? '' : 'Brak pozycji planu studiów.');
  }

  load(items, message) {
    this.items = items.map((i, n) => ({ ...i, pos: n }));
    this.message = message || '';
    this.render();
  }

  render() {
    const phrases = norm(this.search.value).split(',').map(x => x.trim()).filter(Boolean);
    const st = this.status.value;
    let rows = this.items.filter(i => (st !== '1' || i.scheduled < i.planned) && (st !== '2' || i.scheduled >= i.planned));
    if (phrases.length) rows = rows.filter(i => { const t = norm([i.sub, i.form, i.gro, i.lec, i.per].join('#')); return phrases.some(p => t.includes(p)); });
    const col = this.sortCol, desc = this.sortDesc;
    rows.sort((a, b) => {
      let c = 0;
      if (col >= 0) {
        const x = COLS[col][1](a), y = COLS[col][1](b);
        c = typeof x === 'number' ? x - y : String(x || '').localeCompare(String(y || ''), 'pl');
        if (desc) c = -c;
      }
      return c || a.pos - b.pos;
    });
    this.list.innerHTML = '';
    this.info.textContent = this.message || (this.items.length ? `Pozycji: ${rows.length}${rows.length !== this.items.length ? ' z ' + this.items.length : ''}` : '');
    const k = SORTS.findIndex(([, c, d]) => c === col && (c !== 4 || d === desc));
    this.sort.value = String(k >= 0 ? k : SORTS.findIndex(([, c]) => c === col));
    if (!rows.length) { if (this.selected && !this.items.some(i => i.id === this.selected.id)) this.select(null); return; }
    const tbl = el('table', 'spl-table');
    const hr = el('tr');
    COLS.forEach(([name], n) => {
      const th = el('th', n === 4 ? 'num' : '', name + (n === col ? (desc ? ' ▼' : ' ▲') : ''));
      th.title = 'Sortuj (kliknij jeszcze raz - odwrotnie)';
      th.addEventListener('click', () => { if (this.sortCol === n) this.sortDesc = !this.sortDesc; else { this.sortCol = n; this.sortDesc = false; } this.render(); });
      hr.append(th);
    });
    hr.append(el('th', '', ''));   // "Rozplanuj..."
    const thead = el('thead'); thead.append(hr);
    const tbody = el('tbody');
    let selVisible = false;
    for (const i of rows) {
      const tr = el('tr', 'spl-item' + (i.scheduled > i.planned ? ' over' : i.scheduled >= i.planned ? ' done' : ''));
      tr.draggable = true;
      tr.dataset.id = i.id;
      if (this.selected && this.selected.id === i.id) { tr.classList.add('selected'); selVisible = true; }
      for (const v of [i.sub, i.form, i.gro, i.lec, `${fmt(i.scheduled)} / ${fmt(i.planned)}`, i.per]) tr.append(el('td', '', v));
      tr.lastChild.previousSibling.className = 'num';
      // "Rozplanuj..." w każdym wierszu: terminy do akceptacji (pozycja zaplanowana - okno o tym informuje)
      const tdS = el('td', 'spl-sch-link');
      {
        const a = el('a', '', 'Rozplanuj...');
        a.href = '#';
        a.title = 'Zaproponuj terminy na brakujące godziny (bez konfliktów) i dodaj zajęcia';
        a.addEventListener('click', e => { e.preventDefault(); e.stopPropagation(); this.onSchedule(i); });
        tdS.append(a);
      }
      tr.append(tdS);
      tr.title = splCaption(i) + `\nZaplanowano ${fmt(i.scheduled)} z ${fmt(i.planned)} godz.\nKliknij: kropki "Plan" w siatce. Przeciągnij na siatkę: dodaj zajęcie.`;
      tr.addEventListener('click', () => this.select(this.selected && this.selected.id === i.id ? null : i));
      tr.addEventListener('dragstart', e => {
        this.select(i);
        e.dataTransfer.setData(SPL_DRAG_TYPE, String(i.id));
        e.dataTransfer.setData('text/plain', splCaption(i));
        e.dataTransfer.effectAllowed = 'copy';
      });
      tbody.append(tr);
    }
    tbl.append(thead, tbody);
    this.list.append(tbl);
    if (this.selected && !selVisible) this.select(null);   // not on the list any more
  }

  select(item) {
    const changed = (this.selected && this.selected.id) !== (item && item.id);
    this.selected = item;
    this.list.querySelectorAll('.spl-item').forEach(r => r.classList.toggle('selected', !!item && Number(r.dataset.id) === item.id));
    if (changed) this.onSelect(item);
  }

  itemById(id) { return this.items.find(i => i.id === Number(id)) || null; }
}

// --- okno "Plan studiów" ----------------------------------------------------------------------------
const FILTERS = [['per', 'PER', 'Okres'], ['lec', 'L', 'Wykładowca'], ['gro', 'G', 'Grupa'], ['rom', 'S', 'Sala'], ['sub', 'SUB', 'Przedmiot'], ['for', 'FOR', 'Forma']];

export class SplWindow {
  constructor({ api, onChanged }) {
    this.api = api;
    this.onChanged = onChanged || (() => {});
    this.dialog = el('dialog', 'browse spl-window');
    document.body.append(this.dialog);
    this.dialog.addEventListener('close', () => { if (this.resolve) { this.resolve(this.result || null); this.resolve = null; } this.dialog.innerHTML = ''; });
  }

  search(type, q) {
    if (type === 'PER') return this.api(`periods?q=${encodeURIComponent(q)}`).then(r => r.map(p => ({ id: p.id, name: p.name, org: p.dateFrom })));
    return this.api(`objects/${type}?q=${encodeURIComponent(q)}${type === 'FOR' ? '&kind=C' : ''}`);
  }

  // preset: { per: {id, name}, lec, gro } - filtry; select: true - tryb wyboru, wynik: zaznaczone pozycje albo null
  open({ preset, select } = {}) {
    this.select = !!select;
    this.result = null;
    this.build(preset || {});
    if (!this.dialog.open) this.dialog.showModal();
    this.refresh();
    return new Promise(resolve => { this.resolve = resolve; });
  }

  build(preset) {
    const d = this.dialog;
    d.innerHTML = '';
    const head = el('div', 'b-head');
    head.append(el('h2', '', this.select ? 'Plan studiów - wybierz pozycje' : 'Plan studiów'), el('span', 'spacer'), button('×', 'link close', () => d.close(), 'Zamknij (Esc)'));

    const bar = el('div', 'b-bar spl-filters');
    this.q = el('input'); this.q.type = 'search'; this.q.placeholder = 'Dowolna fraza (kilka fraz oddziel przecinkiem)';
    let t;
    this.q.addEventListener('input', () => { clearTimeout(t); t = setTimeout(() => this.refresh(), 300); });
    bar.append(this.q);
    this.flt = {};
    for (const [key, type, label] of FILTERS) {
      const box = el('div', 'chips small'); box.dataset.type = type; box.dataset.label = label;
      const f = new ChipField(box, { search: (ty, q) => this.search(ty, q), single: true, onChange: () => this.refresh() });
      if (preset[key]) f.setItems([preset[key]]);
      this.flt[key] = f;
      bar.append(box);
    }
    this.todo = el('select');
    this.todo.title = 'Porównanie z rozkładem';
    this.todo.append(new Option('Porównanie z rozkładem: wszystkie', '0'), new Option('Porównanie z rozkładem: do zaplanowania', '1'));
    this.todo.addEventListener('change', () => this.refresh());
    bar.append(this.todo);

    const body = el('div', 'spl-body');
    this.tableWrap = el('div', 'b-list spl-table');
    this.side = el('div', 'spl-side');
    body.append(this.tableWrap, this.side);

    const actions = el('div', 'b-actions');
    this.count = el('span', 'muted', '');
    actions.append(this.count, el('span', 'spacer'),
      button('Dodaj', 'secondary', () => this.edit(null)),
      button('Usuń', 'secondary', () => this.remove()),
      button('Przelicz', 'secondary', () => this.recalc(), 'Powiązane zajęcia i zaplanowane godziny (okres z filtra albo wszystkie)'));
    if (this.select) actions.append(button('Wybierz', 'primary', () => this.choose()));
    actions.append(button('Zamknij', 'secondary', () => d.close()));
    d.append(head, bar, body, actions);
    this.side.append(el('p', 'muted', 'Kliknij pozycję, aby zobaczyć powiązane zajęcia.'));
  }

  params() {
    const p = new URLSearchParams();
    if (this.q.value.trim()) p.set('q', this.q.value.trim());
    for (const [key] of FILTERS) { const v = this.flt[key].items[0]; if (v) p.set(key, v.id); }
    if (this.todo.value === '1') p.set('todo', '1');
    return p;
  }

  async refresh() {
    const req = (this.req = (this.req || 0) + 1);
    let r;
    try { r = await this.api('spl/list?' + this.params()); } catch (e) { this.count.textContent = e.message; return; }
    if (req !== this.req) return;
    this.rows = r.items;
    const keep = new Set(this.checked ? [...this.checked] : []);
    this.checked = new Set(r.items.filter(i => keep.has(i.id)).map(i => i.id));
    const tbl = el('table', 'b-table');
    const hr = el('tr');
    const all = el('input'); all.type = 'checkbox'; all.title = 'Zaznacz wszystkie';
    all.addEventListener('change', () => { this.checked = new Set(all.checked ? this.rows.map(i => i.id) : []); tbl.querySelectorAll('tbody input').forEach(c => { c.checked = all.checked; }); this.paintCount(); });
    const th0 = el('th'); th0.append(all); hr.append(th0);
    for (const h of ['Kolejność', 'Okres', 'Grupa', 'Przedmiot', 'Forma', 'Wykładowca', 'Planowane', 'Zaplanowane', 'Do zaplanowania']) hr.append(el('th', '', h));
    const thead = el('thead'); thead.append(hr);
    const tbody = el('tbody');
    for (const i of r.items) {
      const tr = el('tr');
      tr.classList.toggle('current', !!this.current && this.current.id === i.id);
      const c = el('input'); c.type = 'checkbox'; c.checked = this.checked.has(i.id);
      c.addEventListener('click', e => e.stopPropagation());
      c.addEventListener('change', () => { if (c.checked) this.checked.add(i.id); else this.checked.delete(i.id); this.paintCount(); });
      const td0 = el('td'); td0.append(c); tr.append(td0);
      for (const v of [i.sortOrder === null ? '' : String(i.sortOrder), i.per, i.gro, i.sub, i.form, i.lec, fmt(i.planned), fmt(i.scheduled), fmt(Math.max(i.planned - i.scheduled, 0))]) tr.append(el('td', '', v));
      tr.addEventListener('click', () => { this.current = i; tbody.querySelectorAll('tr').forEach(x => x.classList.toggle('current', x === tr)); this.details(i); });
      tr.addEventListener('dblclick', () => { if (this.select) { this.checked = new Set([i.id]); this.choose(); } else this.edit(i); });
      tbody.append(tr);
    }
    tbl.append(thead, tbody);
    this.tableWrap.innerHTML = '';
    this.tableWrap.append(tbl);
    this.paintCount();
  }

  paintCount() {
    this.count.textContent = `Pozycji: ${this.rows.length}` + (this.checked.size ? `, zaznaczono: ${this.checked.size}` : '') + (this.rows.length >= 2000 ? ' (pokazano pierwsze 2000)' : '');
  }

  // "Powiązane zajęcia" + edycja pozycji
  async details(i) {
    this.side.innerHTML = '';
    this.side.append(el('h3', '', splCaption(i)),
      el('p', 'muted', `${i.per}. Planowane: ${fmt(i.planned)}, zaplanowane: ${fmt(i.scheduled)}${i.recalcDate ? ' (przeliczono ' + i.recalcDate + ')' : ''}`),
      button('Edytuj', 'secondary small', () => this.edit(i)));
    if (i.desc) this.side.append(el('p', '', i.desc));
    this.side.append(el('h4', '', 'Powiązane zajęcia'));
    let r;
    try { r = await this.api('spl/classes?item=' + i.id); } catch (e) { this.side.append(el('p', 'error', e.message)); return; }
    if (!this.current || this.current.id !== i.id) return;
    if (!r.items.length) { this.side.append(el('p', 'muted', 'Brak powiązanych zajęć (albo pozycja nie była przeliczona).')); return; }
    const tbl = el('table', 'b-table');
    const hr = el('tr'); for (const h of ['Data', 'Godz.', 'Godzin', 'Wykładowcy', 'Sale']) hr.append(el('th', '', h));
    tbl.append(hr);
    for (const c of r.items) { const tr = el('tr'); for (const v of [c.day, c.hour, fmt(c.hours), c.lecturers, c.rooms]) tr.append(el('td', '', v)); tbl.append(tr); }
    this.side.append(tbl);
  }

  edit(i) {
    this.side.innerHTML = '';
    const form = el('form', 'spl-edit');
    form.append(el('h3', '', i ? 'Edycja pozycji planu studiów' : 'Nowa pozycja planu studiów'));
    const fields = {};
    const preset = {
      per: i ? { id: i.perId, name: i.per } : this.flt.per.items[0], gro: i ? { id: i.groId, name: i.gro } : this.flt.gro.items[0],
      sub: i ? { id: i.subId, name: i.sub } : this.flt.sub.items[0], for: i ? { id: i.forId, name: i.form } : this.flt.for.items[0],
      lec: i ? (i.lecId ? { id: i.lecId, name: i.lec } : null) : this.flt.lec.items[0],
    };
    for (const [key, type, label] of [['per', 'PER', 'Okres'], ['gro', 'G', 'Grupa'], ['sub', 'SUB', 'Przedmiot'], ['for', 'FOR', 'Forma'], ['lec', 'L', 'Wykładowca (opcjonalnie)']]) {
      const box = el('div', 'chips small'); box.dataset.type = type; box.dataset.label = label;
      fields[key] = new ChipField(box, { search: (ty, q) => this.search(ty, q), single: true });
      if (preset[key]) fields[key].setItems([preset[key]]);
      form.append(box);
    }
    const lp = el('label', 'field', 'Godziny planowane ');
    const planned = el('input'); planned.type = 'number'; planned.min = '0'; planned.step = 'any'; planned.value = i ? i.planned : '';
    lp.append(planned);
    const ls = el('label', 'field', 'Kolejność ');
    const sortOrder = el('input'); sortOrder.type = 'number'; sortOrder.step = 'any'; sortOrder.value = i && i.sortOrder !== null ? i.sortOrder : '';
    sortOrder.title = 'Kolejność pozycji w planie (domyślny porządek sortowania)';
    ls.append(sortOrder);
    const ld = el('label', 'field', 'Opis ');
    const desc = el('input'); desc.maxLength = 1000; desc.value = i ? i.desc : '';
    ld.append(desc);
    const err = el('p', 'error'); err.hidden = true;
    const save = button('Zapisz', 'primary', async () => {
      err.hidden = true;
      const v = k => (fields[k].items[0] || {}).id || null;
      try {
        await withProgress(this.side, 'Zapisywanie…', () => this.api('spl/save', { id: i ? i.id : null, per: v('per'), gro: v('gro'), sub: v('sub'), for: v('for'), lec: v('lec'), planned: planned.value === '' ? NaN : Number(planned.value), desc: desc.value, sortOrder: sortOrder.value === '' ? null : Number(sortOrder.value) }));
      } catch (e) { err.textContent = e.message; err.hidden = false; return; }
      this.onChanged();
      await this.refresh();
      const cur = this.rows.find(x => i ? x.id === i.id : false);
      if (cur) { this.current = cur; this.details(cur); } else this.side.innerHTML = '';
    });
    form.append(lp, ls, ld, err, el('div', 'b-actions', ''));
    form.lastChild.append(save, button('Anuluj', 'secondary', () => (i ? this.details(i) : (this.side.innerHTML = ''))));
    form.addEventListener('submit', e => e.preventDefault());
    this.side.append(form);
  }

  async remove() {
    const ids = this.checked.size ? [...this.checked] : this.current ? [this.current.id] : [];
    if (!ids.length) { this.count.textContent = 'Zaznacz pozycje do usunięcia.'; return; }
    if (!confirm(`Usunąć pozycji planu studiów: ${ids.length}?`)) return;
    try { await this.api('spl/delete', { ids }); } catch (e) { this.count.textContent = e.message; return; }
    this.checked = new Set(); this.current = null; this.side.innerHTML = '';
    this.onChanged();
    this.refresh();
  }

  async recalc() {
    const per = this.flt.per.items[0];
    try { await withProgress(this.tableWrap, 'Przeliczanie planu studiów…', () => this.api('spl/recalc', { per: per ? per.id : null })); }
    catch (e) { this.count.textContent = e.message; return; }
    this.onChanged();
    await this.refresh();
    if (this.current) { const c = this.rows.find(x => x.id === this.current.id); if (c) { this.current = c; this.details(c); } }
  }

  choose() {
    const ids = this.checked.size ? [...this.checked] : this.current ? [this.current.id] : [];
    if (!ids.length) { this.count.textContent = 'Zaznacz pozycje.'; return; }
    this.result = this.rows.filter(i => ids.includes(i.id));
    this.dialog.close();
  }
}

// --- okno "Rozplanuj" ---------------------------------------------------------------------------------------
// terminy na godziny do zaplanowania (spl_pkg.propose: bez konfliktów wykładowcy, grupy i sali, z dniami wolnymi),
// lista do akceptacji, zaznaczone dodawane jak zwykłe zajęcia (classes/add)
const WEEKDAYS = ['Dowolny dzień', 'Poniedziałek', 'Wtorek', 'Środa', 'Czwartek', 'Piątek', 'Sobota', 'Niedziela'];
const DAY_NAMES = ['niedziela', 'poniedziałek', 'wtorek', 'środa', 'czwartek', 'piątek', 'sobota'];

export class SplScheduleDialog {
  constructor({ api, onAdded }) {
    this.api = api;
    this.onAdded = onAdded || (() => {});
    this.dialog = el('dialog', 'browse single spl-schedule');
    document.body.append(this.dialog);
    this.dialog.addEventListener('close', () => { this.dialog.innerHTML = ''; });
  }

  search(type, q) { return this.api(`objects/${type}?q=${encodeURIComponent(q)}`); }

  // item: pozycja z listy; viewLec / viewRom: {id, name} z okna głównego (wykładowca dla pozycji bez wykładowcy, sala)
  async open({ item, viewLec, viewRom, user }) {
    this.user = user;
    let info;
    try { info = await this.api('spl/schedule-info?item=' + item.id); } catch (e) { alert(e.message); return; }
    this.info = info;
    const it = info.item;
    const d = this.dialog;
    d.innerHTML = '';
    const head = el('div', 'b-head');
    head.append(el('h2', '', 'Rozplanuj'), el('span', 'spacer'), button('×', 'link close', () => d.close(), 'Zamknij (Esc)'));
    const body = el('div', 'spl-sch-body');
    body.append(el('p', 'spl-sch-title', `${splCaption(it)}. Do zaplanowania: ${fmt(info.left)} z ${fmt(it.planned)} godz.`));

    const chip = (type, label, value, single = true) => {
      const box = el('div', 'chips small'); box.dataset.type = type; box.dataset.label = label;
      const f = new ChipField(box, { search: (t, q) => this.search(t, q), single, onChange: () => this.clearTerms() });
      if (value) f.setItems([value]);
      return { box, f };
    };
    // pozycja z wykładowcą - ten wykładowca; bez wykładowcy - najpierw wybór (domyślnie wykładowca z ekranu)
    this.itemHasLec = !!it.lecId;
    const lec = chip('L', this.itemHasLec ? 'Wykładowca (pozycji planu)' : 'Wykładowca (pozycja bez wykładowcy - wybierz)',
      this.itemHasLec ? { id: it.lecId, name: it.lec } : viewLec);
    if (this.itemHasLec) lec.box.classList.add('disabled');
    this.lec = lec.f;
    const rom = chip('S', 'Sala (opcjonalnie)', viewRom);
    this.rom = rom.f;
    body.append(lec.box, rom.box);

    const mode = el('fieldset', 'spl-sch-mode');
    mode.append(el('legend', '', 'Sposób'));
    this.modeEven = el('input'); this.modeEven.type = 'radio'; this.modeEven.name = 'splmode'; this.modeEven.checked = true;
    const modeFirst = el('input'); modeFirst.type = 'radio'; modeFirst.name = 'splmode';
    const l1 = el('label', 'check'); l1.append(this.modeEven, ' Równomiernie: ten sam dzień i godzina co tydzień (gdy za mało - także kolejne dni tygodnia)');
    const l2 = el('label', 'check'); l2.append(modeFirst, ' Pierwsze wolne terminy (jak najwcześniej)');
    mode.append(l1, l2);
    body.append(mode);

    const sel = (label, options, value) => {
      const l = el('label', 'field', label + ' ');
      const s = el('select');
      options.forEach(([v, t]) => s.append(new Option(t, String(v))));
      if (value !== undefined) s.value = String(value);
      s.addEventListener('change', () => this.clearTerms());
      l.append(s);
      return { l, s };
    };
    const hours = info.hours.map(h => [h.no, h.label]);
    const wd = sel('Dzień tygodnia', WEEKDAYS.map((n, i) => [i, n]), 0);
    const blk = sel('Bloków pod rząd', [1, 2, 3, 4].map(n => [n, String(n)]), 1);
    const hf = sel('Godziny od', hours, hours.length ? hours[0][0] : '');
    const ht = sel('do', hours, hours.length ? hours[hours.length - 1][0] : '');
    this.wd = wd.s; this.blk = blk.s; this.hf = hf.s; this.ht = ht.s;
    const row = el('div', 'spl-sch-row'); row.append(wd.l, blk.l, hf.l, ht.l);
    body.append(row);

    const bar = el('div', 'spl-sch-row');
    this.status = el('span', 'muted', '');
    bar.append(button('Zaproponuj terminy', 'primary', () => this.propose()), this.status);
    body.append(bar);
    this.terms = el('div', 'spl-sch-terms');
    body.append(this.terms);
    this.error = el('p', 'error'); this.error.hidden = true;
    body.append(this.error);

    const actions = el('div', 'b-actions');
    this.addBtn = button('Dodaj zaznaczone zajęcia', 'primary', () => this.add());
    this.addBtn.disabled = true;
    actions.append(this.addBtn, button('Zamknij', 'secondary', () => d.close()));
    d.append(head, body, actions);
    if (!d.open) d.showModal();
  }

  clearTerms() { this.list = []; this.terms.innerHTML = ''; this.status.textContent = ''; this.addBtn.disabled = true; }

  async propose() {
    this.error.hidden = true;
    const lec = this.lec.items[0];
    if (!this.itemHasLec && !lec) { this.status.textContent = 'Pozycja bez wykładowcy - najpierw wybierz wykładowcę.'; return; }
    const rom = this.rom.items[0];
    const q = new URLSearchParams({
      item: this.info.item.id, mode: this.modeEven.checked ? 'EVEN' : 'FIRST', weekday: this.wd.value,
      from: this.hf.value, to: this.ht.value, block: this.blk.value,
    });
    if (lec) q.set('lec', lec.id);
    if (rom) q.set('rom', rom.id);
    let r;
    try { r = await withProgress(this.dialog, 'Szukanie terminów…', () => this.api('spl/propose?' + q), [], 200); }
    catch (e) { this.error.textContent = e.message; this.error.hidden = false; return; }
    this.clearTerms();
    if (r.status === 'ERR') { this.status.textContent = r.message; return; }
    if (r.status === 'DONE') { this.status.textContent = 'Pozycja jest już w pełni zaplanowana.'; return; }
    this.list = r.terms.map(t => ({ ...t, on: true }));
    const label = no => (this.info.hours.find(h => h.no === no) || { label: String(no) }).label;
    const tbl = el('table', 'spl-table');
    const hr = el('tr');
    const all = el('input'); all.type = 'checkbox'; all.checked = true;
    all.addEventListener('change', () => { this.list.forEach(t => { t.on = all.checked; }); tbl.querySelectorAll('tbody input').forEach(c => { c.checked = all.checked; }); this.count(); });
    const th0 = el('th'); th0.append(all); hr.append(th0);
    for (const h of ['Data', 'Dzień', 'Godzina', 'Godzin', 'Spotkanie']) hr.append(el('th', '', h));
    const thead = el('thead'); thead.append(hr);
    const tbody = el('tbody');
    for (const t of this.list) {
      const tr = el('tr');
      const c = el('input'); c.type = 'checkbox'; c.checked = true;
      c.addEventListener('change', () => { t.on = c.checked; this.count(); });
      const td0 = el('td'); td0.append(c); tr.append(td0);
      const day = new Date(t.date + 'T12:00:00');
      for (const v of [t.date, DAY_NAMES[day.getDay()], label(t.hour), fmt(t.hours), String(t.meeting)]) tr.append(el('td', '', v));
      tbody.append(tr);
    }
    tbl.append(thead, tbody);
    this.terms.append(tbl);
    this.status.textContent = r.status === 'OK'
      ? `Terminy bez konfliktów na ${fmt(r.total)} godz. Odznacz niepotrzebne i dodaj.`
      : `Brakuje ${fmt(r.left)} z ${fmt(r.total)} godz. - nie ma więcej wolnych terminów (zmień dzień, godziny, salę albo sposób).`;
    this.count();
  }

  count() { this.addBtn.disabled = !this.list.some(t => t.on); }

  async add() {
    const cells = this.list.filter(t => t.on).map(t => ({ date: t.date, hour: t.hour }));
    if (!cells.length) return;
    const it = this.info.item;
    const lec = this.lec.items[0], rom = this.rom.items[0];
    const p = {
      period: it.perId, cells, kind: 'C', lec: lec ? [lec.id] : [], gro: [it.groId], rom: rom ? [rom.id] : [],
      sub: it.subId, form: it.forId, fill: 100, colour: null, owner: this.user, desc: [null, null, null, null], confirm: false,
    };
    this.error.hidden = true;
    this.addBtn.disabled = true;
    try {
      const r = await withProgress(this.dialog, 'Dodawanie zajęć…', () => this.api('classes/add', p), [], 150);
      if (r.status === 'conflicts') {
        this.error.textContent = `W międzyczasie pojawiły się konflikty (${r.conflicts.length}) - zaproponuj terminy jeszcze raz.`;
        this.error.hidden = false;
        return;
      }
      this.dialog.close();
      this.onAdded(r);
    } catch (e) {
      this.error.textContent = e.message; this.error.hidden = false;
    } finally { this.count(); }
  }
}
