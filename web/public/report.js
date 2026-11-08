// Okno "Raportowanie" (FGrouping w Delphi): kolumny na raporcie, "Wyszukaj wg", porządkowanie danych,
// Odśwież, zapis (Excel / przeglądarka / notatnik / CSV), inne raporty (obciążenie wykładowcy, studentogodziny),
// opcje (cała baza, tryb diagnostyczny, podgląd SQL), zapis i odczyt ustawień.
import { ChipField } from './chips.js';
import { EXCEL_ICON, downloadXlsx } from './xlsx.js';

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

// kolumny na raporcie: [klucz, etykieta, zależy od (pokazywane, gdy zaznaczone któreś)]
const COLUMNS = [
  ['day', 'Dni'], ['month', 'Miesiąc zajęcia'], ['dayOfWeek', 'Dni tygodnia'], ['hour', 'Godziny'],
  ['L', 'Wykładowcy'], ['Luni', 'Jednostki org. wykładowców'], ['LnewLine', 'Każdy w oddzielnej linii', ['L', 'Luni']],
  ['ldesc1', 'desc1S', ['LnewLine']], ['ldesc2', 'desc2S', ['LnewLine']], ['ldesc3', 'desc3S', ['LnewLine']], ['ldesc4', 'desc4S', ['LnewLine']],
  ['Lcount', 'Liczba wykładowców', ['LnewLine']],
  ['G', 'Grupy'], ['Gtype', 'Typy grup'], ['Gstudents', 'Liczba studentów'], ['Gorg', 'Jednostki org. grup'], ['Gparent', 'Grupy nadrzędne'],
  ['GnewLine', 'Każda w oddzielnej linii', ['G', 'Gtype', 'Gstudents', 'Gorg', 'Gparent']], ['Gcount', 'Liczba grup', ['GnewLine']],
  ['R', 'Zasoby'], ['Rorg', 'Jednostki org. zasobów'], ['RnewLine', 'Każdy w oddzielnej linii', ['R', 'Rorg']], ['Rcount', 'Liczba zasobów', ['RnewLine']],
  ['S', 'Przedmioty'], ['Sorg', 'Jednostki org. przedmiotów'],
  ['F', 'Formy zajęć / rezerwacje'], ['FnewColumn', 'Każda w oddzielnej kolumnie', ['F']],
  ['fill', 'Wypełnienie bl.'], ['desc1', 'desc1'], ['desc2', 'desc2'], ['desc3', 'desc3'], ['desc4', 'desc4'],
  ['createdBy', 'Utworzył'], ['owner', 'Właściciel'], ['creationDate', 'Data utworzenia'], ['integrationId', 'Integration Id'],
];
const DEFAULTS = { L: true, G: true, S: true, F: true, sortOrder: '1' };
const PREF_KEY = user => 'plansoft.web.report.' + user;

export class ReportWindow {
  // getContext: () => { user, period, settings, cells (zaznaczone terminy), objects: {L, G, S} }
  constructor({ api, getContext }) {
    this.api = api;
    this.getContext = getContext;
    this.dialog = el('dialog', 'report');
    document.body.append(this.dialog);
    this.data = null;
    this.opts = { showAll: false, emergency: false, showSql: false };
  }

  async open() {
    const ctx = this.getContext();
    this.ctx = ctx;
    if (!this.periods) { try { this.periods = await this.api('periods?q='); } catch { this.periods = []; } }
    let saved = {};
    try { saved = JSON.parse(localStorage.getItem(PREF_KEY(ctx.user))) || {}; } catch { /* brak pamięci przeglądarki */ }
    this.build({ ...DEFAULTS, ...saved, period: saved.period || (ctx.period && ctx.period.id) });
    this.dialog.showModal();
  }

  label(key, text) {
    const s = this.ctx.settings;
    const m = /^desc(\d)(S?)$/.exec(text);
    if (!m) return text;
    const i = +m[1] - 1;
    return (m[2] ? s.descSingular[i] || s.descPlural[i] : s.descPlural[i]) || '';
  }

  build(v) {
    const d = this.dialog;
    d.innerHTML = '';
    const head = el('div', 'b-head');
    head.append(el('h2', '', 'Raportowanie'), el('span', 'spacer'), button('×', 'link close', () => d.close(), 'Zamknij (Esc)'));

    this.top = el('div', 'rep-top');
    // --- kolumny na raporcie ---
    const colBox = el('fieldset', 'rep-cols');
    colBox.append(el('legend', '', 'Kolumny na raporcie'));
    this.checks = {};
    for (const [key, text, deps] of COLUMNS) {
      const name = this.label(key, text);
      if (!name) continue;   // opis zajęcia bez nazwy w ustawieniach - niewidoczny (jak w Delphi)
      const l = el('label', 'check' + (deps ? ' sub' : ''));
      const c = el('input'); c.type = 'checkbox'; c.checked = !!v[key];
      c.addEventListener('change', () => this.updateDeps());
      l.append(c, ' ' + name);
      if (key === 'Lcount') l.title = 'Liczba wykładowców prowadzących zajęcie (każdy wykładowca w oddzielnej linii)';
      this.checks[key] = { c, l, deps };
      colBox.append(l);
    }

    // --- wyszukaj wg ---
    const where = el('fieldset', 'rep-where');
    where.append(el('legend', '', 'Wyszukaj wg'));
    const row = (label, ctrl) => { const l = el('label', 'rep-field'); l.append(el('span', '', label), ctrl); where.append(l); return ctrl; };
    this.period = el('select');
    this.period.append(new Option('(wszystkie okresy)', ''), ...this.periods.map(p => new Option(`${p.name} (${p.dateFrom} – ${p.dateTo})`, p.id)));
    this.period.value = v.period || '';
    row('Semestr', this.period);
    const search = (t, q) => this.api(`objects/${t}?q=${encodeURIComponent(q)}`);
    this.fields = {};
    for (const [t, label] of [['L', 'Wykładowca'], ['G', 'Grupa'], ['S', 'Zasób'], ['SUB', 'Przedmiot']]) {
      const box = el('div', 'chips small');
      box.dataset.type = t; box.dataset.label = label;
      const f = new ChipField(box, { search, single: t === 'SUB' });
      f.setItems(v['f' + t] || []);
      this.fields[t] = f;
      where.append(box);
    }
    const txt = (val, ph) => { const i = el('input'); i.value = val || ''; if (ph) i.placeholder = ph; i.addEventListener('keydown', e => { if (e.key === 'Enter') this.refresh(); }); return i; };
    this.formPhrase = row('Forma / rez.', txt(v.formPhrase, 'fragment nazwy formy'));
    this.phrase = row('Dowolna fraza', txt(v.phrase, 'wykładowca, grupa, zasób, przedmiot, forma, opis'));
    this.phrase.title = 'Szuka we wszystkich danych zajęcia: wykładowcy, grupy, zasoby, przedmioty, formy i opisy';
    const dates = el('div', 'rep-dates');
    this.createdFrom = el('input'); this.createdFrom.type = 'date'; this.createdFrom.value = v.createdFrom || '';
    this.createdTo = el('input'); this.createdTo.type = 'date'; this.createdTo.value = v.createdTo || '';
    dates.append(this.createdFrom, el('span', 'muted', 'do'), this.createdTo);
    row('Data utworzenia od', dates);
    this.createdBy = row('Utworzył', txt(v.createdByPhrase, 'fragment nazwy planisty'));
    const sel = el('label', 'check');
    this.selectedDates = el('input'); this.selectedDates.type = 'checkbox'; this.selectedDates.checked = !!v.selectedDates;
    sel.append(this.selectedDates, ` Terminy zaznaczone w siatce (${(this.ctx.cells || []).length})`);
    where.append(sel);
    const fill = el('button', 'link small', 'Wstaw wybrane w oknie głównym');
    fill.type = 'button';
    fill.title = 'Przepisz wykładowców, grupy i sale wybrane w oknie głównym';
    fill.addEventListener('click', () => { for (const t of 'LGS') this.fields[t].setItems(this.ctx.objects[t] || []); });
    where.append(fill);

    // --- porządkowanie ---
    const order = el('fieldset', 'rep-order');
    order.append(el('legend', '', 'Porządkowanie danych wg'));
    this.sortOrder = txt(v.sortOrder || '1');
    this.sortOrder.title = 'Numery kolumn oddzielone przecinkami, np. 1, 3 desc';
    order.append(this.sortOrder, el('p', 'muted', 'Numery kolumn oddzielone przecinkami, np. 1, 3 desc'));
    this.top.append(colBox, where, order);

    // --- przyciski ---
    const tools = el('div', 'b-tools rep-tools');
    this.status = el('span', 'muted');
    const menu = (label, items, title) => {
      const wrap = el('span', 'rep-menu');
      const b = button(label + ' ▾', 'secondary small', e => { e.stopPropagation(); const open = list.hidden; this.closeMenus(); list.hidden = !open; }, title);
      const list = el('div', 'menu'); list.hidden = true;
      for (const it of items) {
        if (it === '-') { list.append(el('div', 'menu-sep')); continue; }
        const mb = el('button', '', ''); mb.type = 'button';
        if (it.html) mb.innerHTML = it.html;
        mb.append(it.check !== undefined ? `${it.check() ? '☑' : '☐'} ${it.label}` : it.label);
        mb.addEventListener('click', () => { list.hidden = true; it.run(); });
        list.append(mb);
      }
      wrap.append(b, list);
      return wrap;
    };
    const opt = key => () => { this.opts[key] = !this.opts[key]; this.rebuildTools(); };
    this.rebuildTools = () => {
      tools.innerHTML = '';
      tools.append(
        button('Odśwież', 'primary small', () => this.refresh(), 'Odśwież zawartość raportu'),
        menu('Zapisz', [
          { label: ' Otwórz w Excel', html: EXCEL_ICON, run: () => this.save('xlsx') },
          { label: 'Otwórz w przeglądarce', run: () => this.save('html') },
          { label: 'Otwórz w notatniku', run: () => this.save('txt') },
          { label: 'Zapisz w pliku CSV', run: () => this.save('csv') },
        ], 'Zapisz wynik raportu'),
        menu('Inne raporty', [
          { label: 'Raport obciążenie wykładowcy', run: () => this.special('LEC_UTILIZATION') },
          { label: 'Raport studentogodziny', run: () => this.special('STUDENTHOURS') },
        ]),
        menu('Opcje', [
          { label: 'Pokaż całą zawartość bazy danych', check: () => this.opts.showAll, run: opt('showAll') },
          { label: 'Tryb diagnostyczny (bez grupowania)', check: () => this.opts.emergency, run: opt('emergency') },
          { label: 'Podgląd zapytania SQL', check: () => this.opts.showSql, run: opt('showSql') },
          '-',
          { label: 'Zapisz ustawienia do pliku', run: () => this.saveSettings() },
          { label: 'Odczytaj ustawienia z pliku', run: () => this.fileInput.click() },
          { label: 'Przywróć ustawienia domyślne', run: () => this.build({ ...DEFAULTS, period: this.ctx.period && this.ctx.period.id }) },
        ]),
        button(this.top.hidden ? 'Więcej' : 'Mniej', 'secondary small', () => { this.top.hidden = !this.top.hidden; this.rebuildTools(); }, 'Pokaż / ukryj ustawienia raportu'),
        el('span', 'spacer'), this.status,
      );
    };
    this.rebuildTools();
    this.fileInput = el('input'); this.fileInput.type = 'file'; this.fileInput.accept = '.json,application/json'; this.fileInput.hidden = true;
    this.fileInput.addEventListener('change', () => { if (this.fileInput.files[0]) this.loadSettings(this.fileInput.files[0]); this.fileInput.value = ''; });

    this.sqlBox = el('pre', 'rep-sql'); this.sqlBox.hidden = true;
    this.wrap = el('div', 'rep-wrap');
    this.wrap.append(el('p', 'muted pad', 'Wybierz kolumny i warunki, a następnie naciśnij Odśwież.'));
    d.append(head, this.top, tools, this.fileInput, this.sqlBox, this.wrap);
    d.onclick = e => { if (!e.target.closest('.rep-menu')) this.closeMenus(); };
    this.updateDeps();
  }

  closeMenus() { this.dialog.querySelectorAll('.rep-menu .menu').forEach(m => { m.hidden = true; }); }

  // opcje zależne widoczne tylko przy zaznaczonej opcji nadrzędnej (calculateCountClick)
  updateDeps() {
    for (let i = 0; i < 3; i++) {
      for (const { c, l, deps } of Object.values(this.checks)) {
        if (!deps) continue;
        const on = deps.some(k => this.checks[k] && this.checks[k].c.checked && !this.checks[k].l.hidden);
        l.hidden = !on;
      }
    }
  }

  values() {
    const v = {};
    for (const [k, { c, l }] of Object.entries(this.checks)) v[k] = c.checked && !l.hidden;
    Object.assign(v, {
      period: this.period.value ? Number(this.period.value) : null,
      lec: this.fields.L.items.map(i => i.id), gro: this.fields.G.items.map(i => i.id), rom: this.fields.S.items.map(i => i.id),
      sub: this.fields.SUB.items.map(i => i.id),
      formPhrase: this.formPhrase.value, phrase: this.phrase.value,
      createdFrom: this.createdFrom.value, createdTo: this.createdTo.value, createdByPhrase: this.createdBy.value,
      selectedDates: this.selectedDates.checked, sortOrder: this.sortOrder.value,
    });
    return v;
  }

  // ustawienia do zapamiętania (z nazwami wybranych obiektów)
  settingsToSave() {
    const v = this.values();
    for (const t of ['L', 'G', 'S', 'SUB']) v['f' + t] = this.fields[t].items;
    return v;
  }

  async refresh() {
    const v = this.values();
    try { localStorage.setItem(PREF_KEY(this.ctx.user), JSON.stringify(this.settingsToSave())); } catch { /* brak pamięci przeglądarki */ }
    this.status.textContent = 'Oczekiwanie na odpowiedź serwera…';
    try {
      this.data = await this.api('report', { ...v, ...this.opts, cells: v.selectedDates ? this.ctx.cells : [] });
    } catch (e) { this.status.textContent = ''; this.showError(e.message); return false; }
    this.render();
    return true;
  }

  showError(text) {
    this.wrap.innerHTML = '';
    this.wrap.append(el('p', 'error pad', text));
  }

  render() {
    const { columns, rows, numeric, truncated, sql } = this.data;
    this.sqlBox.hidden = !sql;
    this.sqlBox.textContent = sql || '';
    this.status.textContent = `Wierszy: ${rows.length}` + (truncated ? ' (pokazano pierwsze 20000 - zawęź warunki)' : '');
    this.wrap.innerHTML = '';
    const t = el('table', 'rep-grid');
    const hr = el('tr');
    hr.append(el('th', 'no', '#'));
    columns.forEach((c, i) => { const th = el('th', numeric[i] ? 'num' : '', c); th.title = `Kolumna ${i + 1}: ${c}`; hr.append(th); });
    const thead = el('thead'); thead.append(hr); t.append(thead);
    const tb = el('tbody');
    const fmt = (v, i) => (v === null || v === undefined ? '' : numeric[i] && typeof v === 'number' ? v.toLocaleString('pl-PL', { maximumFractionDigits: 2 }) : String(v));
    rows.slice(0, 5000).forEach((r, ri) => {
      const tr = el('tr');
      tr.append(el('td', 'no', String(ri + 1)));
      r.forEach((v, i) => tr.append(el('td', numeric[i] ? 'num' : '', fmt(v, i))));
      tb.append(tr);
    });
    t.append(tb);
    // suma kolumn liczbowych
    if (rows.length) {
      const tf = el('tfoot'); const fr = el('tr');
      fr.append(el('td', 'no', 'Σ'));
      columns.forEach((c, i) => fr.append(el('td', numeric[i] ? 'num' : '', numeric[i] && c !== 'Liczba studentów' ? fmt(rows.reduce((s, r) => s + (Number(r[i]) || 0), 0), i) : '')));
      tf.append(fr); t.append(tf);
    }
    this.wrap.append(t);
    if (rows.length > 5000) this.wrap.append(el('p', 'muted pad', `W oknie pokazano 5000 z ${rows.length} wierszy - pełny wynik zapisz do pliku.`));
  }

  // --- zapis wyniku (savepopup) ---------------------------------------------------------------
  async save(kind) {
    if (!this.data && !(await this.refresh())) return;
    const { columns, rows } = this.data;
    const name = 'raport';
    if (kind === 'xlsx') return downloadXlsx(name, 'Raport', columns, rows);
    const esc = v => String(v ?? '').replace(/[&<>"]/g, c => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;' }[c]));
    if (kind === 'html') {
      const html = `<!doctype html><html lang="pl"><head><meta charset="utf-8"><title>Raport</title>
<style>body{font:13px system-ui,sans-serif;margin:16px}table{border-collapse:collapse}th,td{border:1px solid #bbb;padding:3px 6px;text-align:left}th{background:#e8eef6}</style></head>
<body><h1>Raport</h1><table><thead><tr>${columns.map(c => `<th>${esc(c)}</th>`).join('')}</tr></thead><tbody>
${rows.map(r => `<tr>${r.map(v => `<td>${esc(v)}</td>`).join('')}</tr>`).join('\n')}</tbody></table></body></html>`;
      const url = URL.createObjectURL(new Blob([html], { type: 'text/html;charset=utf-8' }));
      window.open(url, '_blank');
      setTimeout(() => URL.revokeObjectURL(url), 60000);
      return;
    }
    const text = kind === 'csv'
      ? [columns, ...rows].map(r => r.map(v => `"${String(v ?? '').replace(/"/g, '""')}"`).join(';')).join('\r\n')
      : [columns, ...rows].map(r => r.map(v => String(v ?? '')).join('\t')).join('\r\n');
    const a = el('a');
    a.href = URL.createObjectURL(new Blob(['﻿' + text], { type: kind === 'csv' ? 'text/csv;charset=utf-8' : 'text/plain;charset=utf-8' }));
    a.download = `${name}.${kind}`;
    document.body.append(a); a.click(); a.remove();
    setTimeout(() => URL.revokeObjectURL(a.href), 1000);
  }

  // --- raporty "Obciążenie wykładowcy" / "Studentogodziny" (generateReport) ----------------------
  async special(report) {
    if (this.opts.emergency) { this.showError('Nie można uruchamiać tego raportu w trybie diagnostycznym.'); return; }
    const separate = await this.ask('Czy pokazywać egzamin i wykład w oddzielnej linii?');
    if (separate === null) return;
    const v = this.values();
    this.status.textContent = 'Oczekiwanie na odpowiedź serwera…';
    let r;
    try { r = await this.api('report', { ...v, ...this.opts, report, cells: v.selectedDates ? this.ctx.cells : [] }); } catch (e) { this.status.textContent = ''; this.showError(e.message); return; }
    this.data = r;
    this.render();
    const idx = n => r.columns.indexOf(n);
    const [iAbbr, iLec, iGro, iSub, iForm, iSum, iNop] = ['Wykładowcy-skróty', 'Wykładowcy', 'Grupy', 'Przedmioty', 'Formy', 'Zajęcia (suma)', 'Liczba studentów'].map(idx);
    const students = report === 'STUDENTHOURS';
    const header = ['Wykładowcy-skróty', 'Wykładowcy', 'Grupy', 'Przedmioty', ...(students ? ['Liczba studentów'] : []), ...r.forms, 'Razem'];
    const first = header.length - r.forms.length - 1;
    const out = [];
    let key = null, line1 = null, line2 = null;
    for (const row of r.rows) {
      const k = [row[iAbbr], row[iGro], row[iSub]].join('\u0001');
      if (k !== key) {
        key = k;
        line1 = new Array(header.length).fill(null);
        line1[0] = row[iAbbr]; line1[1] = row[iLec]; line1[2] = row[iGro]; line1[3] = row[iSub];
        if (students) line1[4] = row[iNop];
        out.push(line1);
        line2 = null;
        if (separate) { line2 = new Array(header.length).fill(null); out.push(line2); }
      }
      const c = r.forms.indexOf(row[iForm]);
      if (c < 0) continue;
      // tryb oddzielnej linii: wykład i egzamin w pierwszej, pozostałe formy w drugiej
      const target = !separate || ['Wykład', 'Egzamin'].includes(row[iForm]) ? line1 : line2;
      target[first + c] = (target[first + c] || 0) + (Number(row[iSum]) || 0);
      target[header.length - 1] = (target[header.length - 1] || 0) + (Number(row[iSum]) || 0);
    }
    downloadXlsx(students ? 'raport_studentogodziny' : 'raport_obciazenie_wykladowcy', students ? 'Studentogodziny' : 'Obciążenie wykładowcy',
      header, out.filter(l => l.some(x => x !== null)));
    this.status.textContent = `Utworzono raport (${out.length} wierszy).`;
  }

  // pytanie Tak / Nie / Anuluj w oknie (bez okienek przeglądarki)
  ask(question) {
    return new Promise(resolve => {
      const box = el('div', 'b-confirm rep-ask');
      box.append(el('p', '', question));
      const done = v => { box.remove(); resolve(v); };
      box.append(button('Tak', 'primary small', () => done(true)), button('Nie', 'secondary small', () => done(false)), button('Anuluj', 'link small', () => done(null)));
      this.wrap.prepend(box);
      box.querySelector('button').focus();
    });
  }

  // --- ustawienia: zapis i odczyt z pliku (Zapisz ustawienia / Odczytaj ustawienia) -----------------
  saveSettings() {
    const a = el('a');
    a.href = URL.createObjectURL(new Blob([JSON.stringify(this.settingsToSave(), null, 2)], { type: 'application/json' }));
    a.download = 'raport_ustawienia.json';
    document.body.append(a); a.click(); a.remove();
    setTimeout(() => URL.revokeObjectURL(a.href), 1000);
  }

  async loadSettings(file) {
    try {
      const v = JSON.parse(await file.text());
      this.build({ ...DEFAULTS, ...v });
      this.status.textContent = `Odczytano ustawienia: ${file.name}`;
    } catch { this.status.textContent = 'Plik nie zawiera ustawień raportu.'; }
  }
}
