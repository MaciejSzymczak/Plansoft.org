// Legenda, zakładka "Podsumowanie godzin" - jak TabSheetCOUNTER w UFLegend.pas:
// liczba godzin zajęć wybranych obiektów w okresie, z podziałem na wybrane kolumny.

export const DEFAULT_SUMMARY = { group: ['subName', 'subAbbr', 'form'], groupsInLines: false, rollup: false };

// kolejność i podpisy jak w Delphi; desc/lecDesc tylko gdy opis ma nazwę w ustawieniach
function options(settings) {
  const o = [
    ['subName', 'Przedmiot: Nazwa'], ['subAbbr', 'Przedmiot: Skrót'], ['form', 'Forma'],
    ['lec', 'Wykładowca'], ['gro', 'Grupa'], ['rom', 'Sala'],
    ['day', 'Dzień'], ['hour', 'Godzina'],
    ['createdBy', 'Utworzył'], ['owner', 'Właściciel'], ['creationDate', 'Data utworzenia'],
  ];
  settings.descPlural.forEach((n, i) => { if (n) o.push(['desc' + (i + 1), `Z podziałem na ${n.toLowerCase()}`]); });
  settings.descSingular.forEach((n, i) => { if (n) o.push(['lecDesc' + (i + 1), `Z podziałem na ${n.toLowerCase()} (wykładowcy)`]); });
  return o;
}

function heading(key, settings) {
  const h = {
    subName: 'Przedmiot', subAbbr: 'Przedmiot (skrót)', form: 'Forma', lec: 'Wykładowca', gro: 'Grupa', groLine: 'Grupa',
    rom: 'Zasób', day: 'Dzień', hour: 'Godz.', createdBy: 'Utworzył', owner: 'Właściciel', creationDate: 'Data utworzenia',
  }[key];
  if (h) return h;
  const i = Number(key.slice(-1)) - 1;
  return key.startsWith('lecDesc') ? settings.descSingular[i] : settings.descPlural[i];
}

// kliknięcie w wykładowcę / grupę / salę pokazuje jego rozkład (jak FLegendNavigation w Delphi)
const NAV = { lec: 'L', groLine: 'G', gro: 'G', rom: 'S' };

function el(tag, cls, text) {
  const e = document.createElement(tag);
  if (cls) e.className = cls;
  if (text !== undefined) e.textContent = text;
  return e;
}

const fmtHours = h => (h === null || h === undefined ? '' : String(Math.round(h * 100) / 100).replace('.', ','));

export class SummaryPanel {
  constructor(root, { api, getScope, getSettings, getOptions, setOptions, onNavigate }) {
    Object.assign(this, { root, api, getScope, getSettings, getOptions, setOptions, onNavigate });
    this.req = 0;
    this.data = null;
    root.innerHTML = '';

    const bar = el('div', 'bar');
    this.filter = el('input');
    this.filter.type = 'search';
    this.filter.placeholder = 'Dowolna fraza (przedmiot, forma, kolumny podziału)';
    let t;
    this.filter.addEventListener('input', () => { clearTimeout(t); t = setTimeout(() => this.refresh(), 300); });
    const exp = el('button', 'secondary small', 'Eksport CSV');
    exp.type = 'button';
    exp.title = 'Zapisz tabelę do pliku CSV (Excel)';
    exp.addEventListener('click', () => this.exportCsv());
    bar.append(this.filter, exp);

    this.details = el('details');
    this.details.append(el('summary', '', 'Podział'));
    this.opts = el('div', 'opts');
    this.details.append(this.opts);

    this.tableWrap = el('div', 'table-wrap');
    root.append(bar, this.details, this.tableWrap);
  }

  buildOptions() {
    const o = this.getOptions(), settings = this.getSettings();
    this.opts.innerHTML = '';
    const check = (label, checked, onChange, cls) => {
      const l = el('label', cls); const c = el('input'); c.type = 'checkbox'; c.checked = checked;
      c.addEventListener('change', () => onChange(c.checked));
      l.append(c, label); return l;
    };
    const toggle = key => on => {
      const group = this.getOptions().group.filter(k => k !== key);
      if (on) group.push(key);
      this.setOptions({ ...this.getOptions(), group });
      this.buildOptions(); this.refresh();
    };
    for (const [key, label] of options(settings)) {
      this.opts.append(check(label, o.group.includes(key), toggle(key)));
      if (key === 'gro' && o.group.includes('gro')) {
        this.opts.append(check('Każda grupa w oddzielnej linii', o.groupsInLines, on => {
          this.setOptions({ ...this.getOptions(), groupsInLines: on }); this.refresh();
        }, 'sub'));
      }
    }
    this.opts.append(check('Podsumowania częściowe', o.rollup, on => { this.setOptions({ ...this.getOptions(), rollup: on }); this.refresh(); }));
  }

  // kolumny w kolejności listy opcji (jak w Delphi), "Grupa" w wersji wierszowej gdy zaznaczono
  columns() {
    const o = this.getOptions();
    return options(this.getSettings()).map(x => x[0]).filter(k => o.group.includes(k))
      .map(k => (k === 'gro' && o.groupsInLines ? 'groLine' : k));
  }

  message(text) { this.tableWrap.innerHTML = ''; this.tableWrap.append(el('p', 'msg', text)); this.data = null; }

  async refresh() {
    if (!this.opts.childElementCount) this.buildOptions();
    const scope = this.getScope();
    const req = ++this.req;
    if (!scope) return this.message('Wybierz okres.');
    if (!scope.ids.length) return this.message(`Wybierz ${scope.label}, aby zobaczyć podsumowanie godzin.`);
    const cols = this.columns();
    const q = new URLSearchParams({
      period: scope.period, type: scope.type, ids: scope.ids.join(','), group: cols.join(','),
      rollup: this.getOptions().rollup ? '1' : '0', q: this.filter.value.trim(),
    });
    let data;
    try {
      data = await this.api('summary?' + q);
    } catch (e) {
      if (req === this.req && e.message !== '401') this.message(e.message);
      return;
    }
    if (req !== this.req) return;
    this.data = data;
    this.render();
  }

  render() {
    const { columns, rows } = this.data, settings = this.getSettings();
    this.tableWrap.innerHTML = '';
    if (!rows.length) return this.message('Brak zajęć.');
    const table = el('table');
    const head = el('tr');
    columns.forEach(k => head.append(el('th', '', heading(k, settings))));
    head.append(el('th', 'num', 'Liczba godzin'));
    const thead = el('thead');
    thead.append(head);
    table.append(thead);
    const body = el('tbody');
    let total = 0;
    for (const r of rows) {
      const allRolled = columns.length && r.rolled.every(Boolean);
      if (allRolled) continue;   // suma całkowita - na dole, jak bez podsumowań częściowych
      const tr = el('tr', r.rolled.some(Boolean) ? 'rolled' : '');
      let razem = false;
      columns.forEach((k, i) => {
        const td = el('td');
        if (r.rolled[i]) { if (!razem) { td.textContent = 'Razem'; razem = true; } }
        else this.cell(td, k, r.values[i], r.ids[i]);
        tr.append(td);
      });
      tr.append(el('td', 'num', fmtHours(r.hours)));
      body.append(tr);
      if (!r.rolled.some(Boolean)) total += r.hours || 0;
    }
    const tr = el('tr', 'total');
    tr.append(el('td', '', 'Razem'));
    for (let i = 1; i < columns.length; i++) tr.append(el('td'));
    tr.append(el('td', 'num', fmtHours(total)));
    body.append(tr);
    table.append(body);
    this.tableWrap.append(table);
  }

  cell(td, key, value, id) {
    const text = value === null || value === undefined || value === '' ? '--' : String(value);
    const type = NAV[key];
    if (!type || id === null || id === undefined) { td.textContent = text; return; }
    // grupy jako jedna kolumna: "A; B" i id "1;2" - każda grupa osobnym odnośnikiem
    const names = key === 'gro' ? text.split(';').map(s => s.trim()) : [text];
    const ids = String(id).split(';');
    names.forEach((n, i) => {
      if (i) td.append('; ');
      if (!ids[i]) { td.append(n); return; }
      const a = el('a', '', n);
      a.href = '#';
      a.title = 'Pokaż rozkład';
      a.addEventListener('click', e => { e.preventDefault(); this.onNavigate(type, Number(ids[i]), n); });
      td.append(a);
    });
  }

  exportCsv() {
    if (!this.data) return;
    const settings = this.getSettings();
    const q = v => `"${String(v ?? '').replace(/"/g, '""')}"`;
    const lines = [[...this.data.columns.map(k => heading(k, settings)), 'Liczba godzin'].map(q).join(';')];
    for (const r of this.data.rows) {
      lines.push([...r.values.map((v, i) => (r.rolled[i] ? 'Razem' : v ?? '--')), fmtHours(r.hours)].map(q).join(';'));
    }
    const blob = new Blob(['﻿' + lines.join('\r\n')], { type: 'text/csv;charset=utf-8' });
    const a = el('a');
    a.href = URL.createObjectURL(blob);
    a.download = 'podsumowanie_godzin.csv';
    document.body.append(a); a.click(); a.remove();
    setTimeout(() => URL.revokeObjectURL(a.href), 1000);
  }
}
