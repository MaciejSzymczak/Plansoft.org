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

// --- lista przy siatce -------------------------------------------------------------------------
export class SplPanel {
  // getContext() -> { period, type: 'L'|'G'|'S'|..., ids: [..] }; onSelect(item | null)
  constructor(root, { api, getContext, onSelect, onDetails }) {
    this.root = root;
    this.api = api;
    this.getContext = getContext;
    this.onSelect = onSelect || (() => {});
    this.onDetails = onDetails || (() => {});
    this.selected = null;
    this.items = [];
    this.req = 0;
    root.innerHTML = '';
    const bar = el('div', 'bar');
    this.info = el('span', 'muted', '');
    bar.append(this.info, el('span', 'spacer'), button('Okno planu studiów', 'secondary small', () => this.onDetails(), 'Plan studiów: filtry, Przelicz, Powiązane zajęcia'));
    this.list = el('div', 'table-wrap spl-list');
    root.append(bar, this.list);
  }

  async refresh() {
    const ctx = this.getContext();
    const req = ++this.req;
    if (!ctx.period) return this.render([], 'Wybierz okres.');
    if (!['L', 'G', 'S'].includes(ctx.type)) return this.render([], 'Plan studiów jest dostępny w widoku wykładowcy, grupy i sali.');
    if (!ctx.ids.length) return this.render([], 'Wybierz wykładowcę, grupę lub salę.');
    let r;
    try { r = await this.api(`spl/panel?period=${ctx.period}&type=${ctx.type}&ids=${ctx.ids.join(',')}`); }
    catch (e) { if (req === this.req && e.message !== '401') this.render([], e.message); return; }
    if (req !== this.req) return;
    this.render(r.items, r.items.length ? '' : 'Brak pozycji planu studiów.');
  }

  render(items, message) {
    this.items = items;
    this.list.innerHTML = '';
    this.info.textContent = message || '';
    if (this.selected && !items.some(i => i.id === this.selected.id)) this.select(null);
    const todo = items.filter(i => i.scheduled < i.planned), done = items.filter(i => i.scheduled >= i.planned);
    for (const [head, list] of [['Do zaplanowania', todo], ['Zaplanowane', done]]) {
      if (!items.length) break;
      const h = el('div', 'spl-head', `${head} (${list.length})`);
      h.title = 'Kliknij, aby odznaczyć pozycję';
      h.addEventListener('click', () => this.select(null));
      this.list.append(h);
      for (const i of list) {
        const row = el('div', 'spl-item');
        row.draggable = true;
        row.dataset.id = i.id;
        row.classList.toggle('selected', !!this.selected && this.selected.id === i.id);
        const over = i.scheduled > i.planned ? `  (nadmiar ${fmt(i.scheduled - i.planned)})` : '';
        row.append(el('span', 'spl-cap', splCaption(i)), el('span', 'spl-hours' + (over ? ' over' : ''), `${fmt(i.scheduled)} / ${fmt(i.planned)}${over}`));
        row.title = 'Kliknij: wybierz (Gdzie przenieść? - gdzie można umieścić). Przeciągnij na siatkę: dodaj zajęcie.';
        row.addEventListener('click', () => this.select(this.selected && this.selected.id === i.id ? null : i));
        row.addEventListener('dragstart', e => {
          this.select(i);
          e.dataTransfer.setData(SPL_DRAG_TYPE, String(i.id));
          e.dataTransfer.setData('text/plain', splCaption(i));
          e.dataTransfer.effectAllowed = 'copy';
        });
        this.list.append(row);
      }
    }
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
