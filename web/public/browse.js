// Okno słownika (wspólny trzon jak TFBrowseParent w Delphi): wykładowcy, grupy, zasoby.
// Lista z wyszukiwaniem, filtrami i sortowaniem; obok formularz rekordu; dodaj/kopiuj/zapisz/usuń; hierarchia.
import { excelButton, downloadXlsx } from './xlsx.js';

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

export class BrowseWindow {
  constructor({ api, onChanged }) {
    this.api = api;
    this.onChanged = onChanged || (() => {});
    this.dialog = el('dialog', 'browse');
    document.body.append(this.dialog);
    this.dialog.addEventListener('close', () => { this.dialog.innerHTML = ''; });
  }

  // selectId - rekord do zaznaczenia po otwarciu (np. "Szczegóły" w organizatorze listy)
  async open(type, selectId) {
    this.type = type;
    this.meta = await this.api(`browse/${type}/meta`);
    this.lookups = {};
    for (const f of this.meta.fields.filter(x => x.type === 'lookup')) await this.loadLookup(f.lookup);
    if (this.meta.filter) await this.loadLookup(this.meta.filter.lookup);
    await this.loadLookup('ORG');
    this.sort = null; this.dir = 'asc';
    this.rows = []; this.current = null; this.mode = 'view';
    this.build();
    if (!this.dialog.open) this.dialog.showModal();
    this.search.focus();
    await this.refresh(selectId);
  }

  async loadLookup(name) {
    if (!this.lookups[name]) this.lookups[name] = await this.api(`lookup/${name}`);
  }

  // --- układ okna ---------------------------------------------------------------------------
  build() {
    const d = this.dialog, m = this.meta;
    d.innerHTML = '';
    const head = el('div', 'b-head');
    head.append(el('h2', '', m.title), el('span', 'spacer'), button('×', 'link close', () => d.close(), 'Zamknij (Esc)'));

    const bar = el('div', 'b-bar');
    this.search = el('input');
    this.search.type = 'search';
    this.search.placeholder = 'Dowolna fraza (kilka fraz oddziel przecinkiem)';
    let t;
    this.search.addEventListener('input', () => { clearTimeout(t); t = setTimeout(() => this.refresh(), 300); });
    bar.append(this.search);
    if (m.filter) {
      this.filter = this.select(this.lookups[m.filter.lookup], '', `${m.filter.label}: wszystkie`);
      this.filter.title = m.filter.label;
      this.filter.addEventListener('change', () => this.refresh());
      bar.append(this.filter);
    }
    this.org = this.select(this.lookups.ORG, '', 'Jedn. org.: wszystkie');
    this.org.title = 'Jednostka organizacyjna (z podrzędnymi)';
    this.org.addEventListener('change', () => this.refresh());
    if (m.hasOrg) bar.append(this.org);
    this.toggle = null;
    if (m.toggle) {
      const l = el('label', 'check');
      this.toggle = el('input'); this.toggle.type = 'checkbox';
      this.toggle.addEventListener('change', () => this.refresh());
      l.append(this.toggle, ' ' + m.toggle.label);
      bar.append(l);
    }

    const tools = el('div', 'b-tools');
    this.bAdd = button('Dodaj', 'secondary small', () => this.startInsert(false));
    this.bCopy = button('Kopiuj', 'secondary small', () => this.startInsert(true), 'Nowy rekord na podstawie zaznaczonego');
    this.bDelete = button('Usuń', 'secondary small danger', () => this.askDelete());
    this.bAdd.disabled = this.bCopy.disabled = !m.canInsert;
    if (!m.canInsert) this.bAdd.title = this.bCopy.title = 'Dane są zasilane z innego systemu (integracja)';
    this.count = el('span', 'muted');
    tools.append(this.bAdd, this.bCopy, this.bDelete, button('Odśwież', 'secondary small', () => this.refresh()),
      excelButton(() => this.exportExcel()));
    // siatka godzinowa: "Utwórz typową siatkę" (bdelpopup w FBrowseGRIDS) - zastępuje wszystkie godziny siatki
    if (m.presets) {
      const sel = el('select', 'b-presets');
      sel.title = 'Usuwa wszystkie godziny siatki i tworzy nowe według wzoru';
      sel.append(new Option('Utwórz typową siatkę…', ''), ...m.presets.map(p => new Option(p.label, p.code)));
      sel.disabled = !m.canInsert;
      sel.addEventListener('change', () => { const v = sel.value; sel.value = ''; if (v) this.askPreset(m.presets.find(p => p.code === v)); });
      tools.append(sel);
    }
    tools.append(el('span', 'spacer'), this.count);

    const body = el('div', 'b-body');
    this.listWrap = el('div', 'b-list');
    this.formWrap = el('div', 'b-form');
    body.append(this.listWrap, this.formWrap);
    d.append(head, bar, tools, body);
    d.onkeydown = e => {
      if (e.key === 'Escape' && this.mode !== 'view') { e.preventDefault(); this.cancelEdit(); }
    };
  }

  select(items, value, emptyLabel) {
    const s = el('select');
    s.append(new Option(emptyLabel || '', ''));
    for (const i of items || []) s.append(new Option(i.name, i.code));
    s.value = value === null || value === undefined ? '' : String(value);
    return s;
  }

  // --- lista ---------------------------------------------------------------------------------
  async refresh(selectId) {
    const q = new URLSearchParams({ q: this.search.value.trim() });
    if (this.filter && this.filter.value) q.set('filter', this.filter.value);
    if (this.org.value && this.meta.hasOrg) q.set('org', this.org.value);
    if (this.toggle && this.toggle.checked) q.set('toggle', '1');
    if (this.sort) { q.set('sort', this.sort); q.set('dir', this.dir); }
    try {
      this.rows = await this.api(`browse/${this.type}?${q}`);
    } catch (e) { this.listWrap.textContent = e.message; return; }
    this.count.textContent = `${this.rows.length} ${this.rows.length === 2000 ? '(pierwsze 2000)' : ''}`.trim();
    const keep = selectId || (this.current && this.current.id);
    this.renderList();
    const row = this.rows.find(r => r.id === keep) || this.rows[0];
    if (this.mode === 'view') this.showRecord(row || null);
  }

  renderList() {
    const cols = this.meta.columns;
    const table = el('table');
    const thead = el('thead'), tr = el('tr');
    tr.append(el('th', 'lock', ''));
    for (const c of cols) {
      const th = el('th', '', c.label + (this.sort === c.name ? (this.dir === 'asc' ? ' ▲' : ' ▼') : ''));
      th.title = 'Sortuj';
      th.addEventListener('click', () => {
        this.dir = this.sort === c.name && this.dir === 'asc' ? 'desc' : 'asc';
        this.sort = c.name;
        this.refresh();
      });
      tr.append(th);
    }
    thead.append(tr);
    const tbody = el('tbody');
    for (const r of this.rows) {
      const row = el('tr');
      row.dataset.id = r.id;
      const lock = el('td', 'lock', r.readOnly ? '🔒' : '');
      if (r.readOnly) lock.title = 'Tylko do odczytu';
      row.append(lock);
      for (const c of cols) row.append(this.listCell(c, r));
      row.addEventListener('click', () => { if (this.mode === 'view') this.showRecord(r); });
      row.addEventListener('dblclick', () => { if (this.mode === 'view') this.showRecord(r, true); });
      tbody.append(row);
    }
    table.append(thead, tbody);
    this.listWrap.innerHTML = '';
    this.listWrap.append(table);
    this.markCurrent();
  }

  listCell(c, r) {
    const v = r.values[c.name];
    const td = el('td');
    if (c.type === 'colour') { const sw = el('span', 'swatch'); if (v) sw.style.background = v; td.append(sw); return td; }
    if (c.type === 'check') { td.textContent = v === '+' ? '✓' : ''; return td; }
    const f = this.meta.fields.find(x => x.name === c.name);
    td.textContent = f && f.type === 'lookup' ? (r.display[c.name] ?? v ?? '') : (v ?? '');
    if (typeof v === 'string' && v.length > 40) td.title = v;
    return td;
  }

  markCurrent() {
    this.listWrap.querySelectorAll('tr.current').forEach(r => r.classList.remove('current'));
    if (!this.current) return;
    const row = this.listWrap.querySelector(`tr[data-id="${this.current.id}"]`);
    if (row) { row.classList.add('current'); row.scrollIntoView({ block: 'nearest' }); }
  }

  // --- formularz rekordu ----------------------------------------------------------------------
  showRecord(r, focus) {
    this.current = r;
    this.mode = 'view';
    this.markCurrent();
    this.bCopy.disabled = !this.meta.canInsert || !r;
    this.bDelete.disabled = !this.meta.canDelete || !r || r.readOnly;
    this.renderForm(r ? r.values : null, r && r.readOnly);
    if (focus) { const i = this.formWrap.querySelector('input:not([disabled]), textarea:not([disabled])'); if (i) i.focus(); }
  }

  startInsert(copy) {
    const base = copy && this.current ? { ...this.current.values } : {};
    if (copy) { delete base.INTEGRATION_ID; delete base.ID; }
    else for (const f of this.meta.fields) if (f.default !== undefined) base[f.name] = f.default;
    this.mode = 'insert';
    this.listWrap.querySelectorAll('tr.current').forEach(r => r.classList.remove('current'));
    this.renderForm(base, false);
    const i = this.formWrap.querySelector('input, textarea, select');
    if (i) i.focus();
  }

  cancelEdit() { this.mode = 'view'; this.showRecord(this.current); }

  renderForm(values, readOnly) {
    const w = this.formWrap;
    w.innerHTML = '';
    if (!values) { w.append(el('p', 'muted pad', 'Brak rekordów.')); return; }
    const form = el('form', 'b-fields');
    form.noValidate = true;
    const title = el('h3', '', this.mode === 'insert' ? `Nowy rekord: ${this.meta.one}` : (readOnly ? 'Rekord tylko do odczytu' : 'Edycja'));
    form.append(title);
    if (this.mode !== 'insert' && values.ID) form.append(el('div', 'muted small-text', `Id: ${values.ID}`));
    this.inputs = {};
    let group = null;
    for (const f of this.meta.fields) {
      if (f.group && f.group !== group) form.append(el('div', 'b-group', f.group));
      group = f.group || null;
      const lb = el('label', 'b-field' + (f.type === 'check' ? ' check' : '') + (f.group ? ' in-group' : ''));
      const caption = el('span', '', f.label + (f.required ? ' *' : ''));
      let input;
      const v = values[f.name];
      if (f.type === 'textarea') { input = el('textarea'); input.rows = 3; input.value = v ?? ''; }
      else if (f.type === 'colour') { input = el('input'); input.type = 'color'; input.value = v || '#ffffff'; input.dataset.empty = v ? '' : '1'; input.addEventListener('input', () => { input.dataset.empty = ''; }); }
      else if (f.type === 'check') { input = el('input'); input.type = 'checkbox'; input.checked = v === '+'; }
      else if (f.type === 'lookup') input = this.select(this.lookups[f.lookup], v, '');
      else if (f.type === 'weeks' || f.type === 'rows') {
        // widoczność tygodni / wierszy (WEEK_VISIBILITY_BTN, HIDE_ROWS_BTN): tekst +/- i wybór z listy
        input = el('input'); input.value = v ?? ''; input.className = 'b-vis';
        const pick = button('…', 'secondary small b-vis-btn', () => (f.type === 'weeks' ? this.pickWeeks(input) : this.pickRows(input)),
          f.type === 'weeks' ? 'Widoczność tygodni - wybierz z listy' : 'Widoczność wierszy - wybierz z listy');
        pick.disabled = !!readOnly;
        const box = el('span', 'b-vis-box');
        box.append(input, pick);
        input.disabled = !!readOnly;
        this.inputs[f.name] = input;
        if (f.hint) lb.title = f.hint;
        lb.append(caption, box);
        form.append(lb);
        continue;
      }
      else {
        input = el('input');
        if (f.type === 'number') { input.type = 'number'; input.step = '1'; }
        if (f.type === 'date') input.type = 'date';
        input.value = v ?? '';
      }
      if (f.max && 'maxLength' in input && f.type !== 'number' && f.type !== 'date') input.maxLength = f.max;
      if (f.hint) lb.title = f.hint;
      input.disabled = !!readOnly || (f.adminOnly && !this.meta.admin);
      if (f.adminOnly && !this.meta.admin) lb.title = 'Ta funkcja jest dostępna tylko dla administratora systemu';
      this.inputs[f.name] = input;
      if (f.type === 'check') lb.append(input, caption); else lb.append(caption, input);
      form.append(lb);
    }
    this.formError = el('p', 'error', '');
    this.formError.hidden = true;
    const actions = el('div', 'b-actions');
    if (!readOnly) {
      const save = button(this.mode === 'insert' ? 'Dodaj' : 'Zapisz', 'primary', () => this.save());
      save.type = 'submit';
      actions.append(save);
      if (this.mode === 'insert') actions.append(button('Anuluj', 'secondary', () => this.cancelEdit()));
    }
    form.append(this.formError, actions);
    form.addEventListener('submit', e => { e.preventDefault(); this.save(); });
    w.append(form);
    if (this.meta.hierarchy && this.mode !== 'insert' && this.current) this.renderHierarchy(w, readOnly);
  }

  // --- okna "Widoczność tygodni" (FWeekVisibility) i "Widoczność wierszy" (FHideRows) -------------------
  // lista z polami wyboru: zaznaczone = widoczne; wynik jako znaki +/- (tydzień lub godzina siatki po kolei)
  visDialog(title, items, onOk) {
    const d = el('dialog', 'vis-dialog');
    const head = el('div', 'b-head');
    head.append(el('h2', '', title), el('span', 'spacer'), button('×', 'link close', () => d.close()));
    const tools = el('div', 'vis-tools');
    const list = el('div', 'vis-list');
    const boxes = items.map(it => {
      const l = el('label', 'check vis-row'); const cb = el('input'); cb.type = 'checkbox'; cb.checked = it.checked;
      l.append(cb, ' ' + it.label); list.append(l); return cb;
    });
    tools.append(button('Zaznacz wszystkie', 'link', () => boxes.forEach(b => { b.checked = true; })),
      button('Odznacz wszystkie', 'link', () => boxes.forEach(b => { b.checked = false; })));
    const actions = el('div', 'b-actions vis-actions');
    actions.append(button('OK', 'primary', () => { onOk(boxes.map(b => b.checked)); d.close(); }), button('Anuluj', 'secondary', () => d.close()));
    d.append(head, tools, list, actions);
    d.addEventListener('close', () => d.remove());
    document.body.append(d);
    d.showModal();
    if (boxes[0]) boxes[0].focus();
  }
  pickWeeks(input) {
    const df = this.inputs.DATE_FROM && this.inputs.DATE_FROM.value, dt = this.inputs.DATE_TO && this.inputs.DATE_TO.value;
    if (!df || !dt) return this.showError('Wpisz daty okresu.');
    const day = 864e5, monday = s => { const t = Date.parse(s + 'T00:00:00Z'); return t - ((new Date(t).getUTCDay() + 6) % 7) * day; };
    const start = monday(df), n = Math.floor((monday(dt) - start) / (7 * day)) + 1;
    if (n > 40) return this.showError(`Ukrywanie tygodni jest dostępne maksymalnie dla 40 tygodni (1 rok). Ten okres obejmuje ${n} tygodni.`);
    const fmt = t => { const x = new Date(t); return `${String(x.getUTCDate()).padStart(2, '0')}.${String(x.getUTCMonth() + 1).padStart(2, '0')}.${x.getUTCFullYear()}`; };
    const s = input.value.trim();
    const items = Array.from({ length: n }, (_, i) => ({
      label: `Tydzień ${i + 1}:   ${fmt(start + i * 7 * day)} - ${fmt(start + (i * 7 + 6) * day)}`,
      checked: !s || s[i % s.length] !== '-',
    }));
    this.visDialog('Widoczność tygodni', items, v => { input.value = v.map(x => (x ? '+' : '-')).join(''); });
  }
  async pickRows(input) {
    const n = Number(this.inputs.HOURS_PER_DAY && this.inputs.HOURS_PER_DAY.value) || 60;
    let hours;
    try { hours = (await this.api('lookup/GRID_HOURS')).filter(h => h.code <= n); } catch (e) { return this.showError(e.message); }
    const s = input.value.trim();
    const items = hours.map(h => ({ no: h.code, label: h.name || String(h.code), checked: !s || s[(h.code - 1) % s.length] !== '-' }));
    this.visDialog('Widoczność wierszy', items, v => {
      const max = Math.max(0, ...items.map(i => i.no));
      const out = Array(max).fill('+');
      items.forEach((it, i) => { if (!v[i]) out[it.no - 1] = '-'; });
      input.value = out.join('');
    });
  }

  // --- jeden rekord (PERIODSShowModalAsSingleRecord(aedit) - przycisk EditPeriod) ---------------------
  async openRecord(type, id) {
    this.type = type;
    this.single = true;
    this.meta = await this.api(`browse/${type}/meta`);
    this.lookups = {};
    for (const f of this.meta.fields.filter(x => x.type === 'lookup')) await this.loadLookup(f.lookup);
    const r = await this.api(`browse/${type}/${id}`);
    const d = this.dialog;
    d.innerHTML = '';
    d.classList.add('single');
    const head = el('div', 'b-head');
    head.append(el('h2', '', `${this.meta.one[0].toUpperCase()}${this.meta.one.slice(1)}: ${r.values.NAME || ''}`), el('span', 'spacer'), button('×', 'link close', () => d.close(), 'Zamknij (Esc)'));
    this.formWrap = el('div', 'b-form');
    d.append(head, this.formWrap);
    this.current = r; this.mode = 'view';
    this.renderForm(r.values, r.readOnly);
    d.addEventListener('close', () => { this.single = false; d.classList.remove('single'); }, { once: true });
    if (!d.open) d.showModal();
    const i = this.formWrap.querySelector('input:not([disabled])'); if (i) i.focus();
  }

  formValues() {
    const out = {};
    for (const f of this.meta.fields) {
      const i = this.inputs[f.name];
      if (f.type === 'check') out[f.name] = i.checked ? '+' : '-';
      else if (f.type === 'colour') out[f.name] = i.dataset.empty ? null : i.value;
      else out[f.name] = i.value;
    }
    return out;
  }

  async save() {
    const values = this.formValues();
    const missing = this.meta.fields.find(f => f.required && !String(values[f.name] ?? '').trim());
    if (missing) return this.showError(`Wypełnij pole „${missing.label}”.`, missing.name);
    const inserting = this.mode === 'insert';
    try {
      const r = inserting
        ? await this.api(`browse/${this.type}`, { values })
        : await this.api(`browse/${this.type}/${this.current.id}`, { values }, 'PUT');
      this.mode = 'view';
      this.current = r;
      if (this.single) { this.dialog.close(); this.onChanged(this.type); return; }
      await this.refresh(r.id);
      this.flash(inserting ? 'Dodano.' : 'Zapisano.');
      this.onChanged(this.type);
    } catch (e) { this.showError(e.message); }
  }

  showError(text, field) {
    this.formError.textContent = text;
    this.formError.hidden = false;
    if (field && this.inputs[field]) this.inputs[field].focus();
  }

  flash(text) {
    const p = el('p', 'b-flash', text);
    this.formWrap.prepend(p);
    setTimeout(() => p.remove(), 2500);
  }

  // usuwanie z potwierdzeniem w oknie (bez okienek przeglądarki)
  askDelete() {
    if (!this.current) return;
    const r = this.current;
    const box = el('div', 'b-confirm');
    box.append(el('p', '', `Czy na pewno chcesz usunąć rekord ${this.recordName(r)}?`));
    const yes = button('Usuń', 'primary danger', async () => {
      try {
        await this.api(`browse/${this.type}/${r.id}`, undefined, 'DELETE');
        this.current = null;
        box.remove();
        await this.refresh();
        this.flash('Usunięto.');
        this.onChanged(this.type);
      } catch (e) { box.remove(); this.renderForm(r.values, r.readOnly); this.showError(e.message); }
    });
    box.append(yes, button('Anuluj', 'secondary', () => box.remove()));
    this.formWrap.prepend(box);
    yes.focus();
  }

  recordName(r) {
    const v = r.values;
    return [v.TITLE, v.LAST_NAME, v.FIRST_NAME, v.ABBREVIATION, v.NAME, v.CAPTION].filter(Boolean).join(' ') || `#${r.id}`;
  }

  // potwierdzenie typowej siatki - usuwa wszystkie dotychczasowe godziny
  askPreset(p) {
    this.formWrap.querySelectorAll('.b-confirm').forEach(b => b.remove());
    const box = el('div', 'b-confirm');
    box.append(el('p', '', `Utworzyć siatkę „${p.label}”? Wszystkie dotychczasowe godziny siatki zostaną usunięte.`));
    const yes = button('Utwórz siatkę', 'primary danger', async () => {
      yes.disabled = true;
      try {
        const r = await this.api(`browse/${this.type}/generate`, { preset: p.code });
        box.remove();
        await this.refresh();
        this.count.textContent = `Utworzono godzin: ${r.count}`;
        this.onChanged(this.type);
      } catch (e) { box.querySelector('p').textContent = e.message; yes.disabled = false; }
    });
    box.append(yes, button('Anuluj', 'secondary', () => box.remove()));
    this.formWrap.prepend(box);
    yes.focus();
  }

  // --- hierarchia: zasoby nadrzędne i podrzędne -------------------------------------------------
  async renderHierarchy(w, readOnly) {
    const box = el('section', 'b-hier');
    const head = el('div', 'b-hier-head');
    head.append(el('h3', '', 'Zależności'));
    const kind = this.select(this.meta.hierarchy.map(k => ({ code: k.code, name: k.name })), this.hierKind || 'STREAM');
    kind.firstChild.remove();   // bez pustej pozycji
    kind.value = this.hierKind || 'STREAM';
    kind.title = 'Rodzaj hierarchii';
    kind.addEventListener('change', () => { this.hierKind = kind.value; load(); });
    head.append(kind);
    const lists = el('div', 'b-hier-lists');
    box.append(head, lists);
    w.append(box);
    const id = this.current.id;
    const load = async () => {
      let h;
      try { h = await this.api(`browse/${this.type}/${id}/hierarchy?kind=${kind.value}`); } catch (e) { lists.textContent = e.message; return; }
      if (!this.current || this.current.id !== id) return;
      lists.innerHTML = '';
      lists.append(this.hierList('Nadrzędne', h.parents, true, readOnly, load), this.hierList('Podrzędne', h.details, false, readOnly, load));
    };
    load();
  }

  hierList(caption, items, parent, readOnly, reload) {
    const box = el('div', 'b-hier-list');
    const head = el('div', 'b-hier-head');
    head.append(el('b', '', caption), el('span', 'spacer'));
    if (!readOnly) head.append(button(parent ? 'Dodaj nadrzędny' : 'Dodaj podrzędny', 'secondary small', () => this.pickRelated(parent, reload)));
    box.append(head);
    if (!items.length) box.append(el('p', 'muted', 'Brak.'));
    for (const i of items) {
      const row = el('div', 'b-hier-row');
      row.style.paddingLeft = (i.level - 1) * 14 + 'px';
      row.append(el('span', '', i.name || '?'));
      if (i.exclusive) row.append(el('span', 'muted', ' (jeden rodzic)'));
      row.append(el('span', 'spacer'));
      if (!readOnly && i.level === 1) {
        row.append(button('Usuń', 'link', async () => {
          try { await this.api(`browse/${this.type}/${this.current.id}/hierarchy/${i.id}`, undefined, 'DELETE'); reload(); }
          catch (e) { this.showError(e.message); }
        }));
      }
      box.append(row);
    }
    return box;
  }

  // wybór rekordów tego samego słownika do powiązania (jak LookupWindow z wielokrotnym wyborem)
  pickRelated(parent, reload) {
    const box = el('div', 'b-confirm b-pick');
    box.append(el('p', '', parent ? 'Wybierz rekordy nadrzędne:' : 'Wybierz rekordy podrzędne:'));
    const q = el('input'); q.type = 'search'; q.placeholder = 'Szukaj…';
    const list = el('div', 'b-pick-list');
    const excl = el('label', 'check'); const ex = el('input'); ex.type = 'checkbox';
    excl.append(ex, ' Jeden rodzic (wyłączny nadrzędny)');
    const chosen = new Set();
    const load = async () => {
      const rows = await this.api(`browse/${this.type}?q=${encodeURIComponent(q.value.trim())}`);
      list.innerHTML = '';
      for (const r of rows.filter(x => x.id !== this.current.id).slice(0, 200)) {
        const l = el('label', 'check'); const c = el('input'); c.type = 'checkbox'; c.checked = chosen.has(r.id);
        c.addEventListener('change', () => (c.checked ? chosen.add(r.id) : chosen.delete(r.id)));
        l.append(c, ' ' + this.recordName(r));
        list.append(l);
      }
    };
    let t; q.addEventListener('input', () => { clearTimeout(t); t = setTimeout(load, 300); });
    const err = el('p', 'error'); err.hidden = true;
    const ok = button('Dodaj', 'primary', async () => {
      try {
        await this.api(`browse/${this.type}/${this.current.id}/hierarchy`, { parent, ids: [...chosen], kind: this.hierKind || 'STREAM', exclusive: ex.checked });
        box.remove(); reload();
      } catch (e) { err.textContent = e.message; err.hidden = false; }
    });
    box.append(q, list, excl, err, ok, button('Anuluj', 'secondary', () => box.remove()));
    this.formWrap.prepend(box);
    q.focus();
    load();
  }

  // eksport bieżącej listy (z filtrem i sortowaniem) do Excela - jak dm.ExportToExcel(DBGrid)
  exportExcel() {
    const cols = this.meta.columns;
    const rows = this.rows.map(r => cols.map(c => {
      const f = this.meta.fields.find(x => x.name === c.name);
      return f && f.type === 'lookup' ? (r.display[c.name] ?? r.values[c.name]) : r.values[c.name];
    }));
    downloadXlsx(this.meta.title.toLowerCase(), this.meta.title, cols.map(c => c.label), rows);
  }
}
