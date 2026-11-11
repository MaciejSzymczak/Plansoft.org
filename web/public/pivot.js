// Tabela przestawna (FMatrix w Delphi): do 4 pól w wierszach i do 4 pól w kolumnach (nagłówki zagnieżdżone),
// na przecięciu (FMatrix: "Zawartość raportu" / "Zliczanie zajęć"):
//  - Liczba godzin: czas bloku * wypełnienie (jak "Zajęcia (suma)" w Raportowaniu), z sumami wierszy i kolumn,
//  - Zajęcia: całe zajęcia - wybrane pola (przedmiot, forma, wykładowcy, grupy, sale, opisy, ...) i daty, w których
//    się odbywają; czytelna tabela do wydruku (np. wiersze: Godzina, kolumny: Dzień tygodnia - plan zajęć).
// Dane z tego samego zapytania co okno Raportowanie (/api/report), przestawiane w przeglądarce.
import { EXCEL_ICON, downloadXlsx } from './xlsx.js';
import { withProgress } from './progress.js';

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
const esc = s => String(s ?? '').replace(/[&<>"]/g, c => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;' }[c]));

// pola: [klucz, etykieta, opcje raportu, kolumna wyniku raportu]
const FIELDS = [
  ['L', 'Wykładowca', { L: true }, 'Wykładowcy'],
  ['G', 'Grupa', { G: true }, 'Grupy'],
  ['R', 'Zasób', { R: true }, 'Zasoby'],
  ['S', 'Przedmiot', { S: true }, 'Przedmioty'],
  ['F', 'Forma zajęć / rezerwacja', { F: true, FnewColumn: false }, 'Formy'],
  ['day', 'Dzień', { day: true }, 'Dzień'],
  ['month', 'Miesiąc', { month: true }, 'Miesiąc'],
  ['dayOfWeek', 'Dzień tygodnia', { dayOfWeek: true }, 'Dzień tyg.'],
  ['hour', 'Godzina', { hour: true }, 'Godzina'],
  ['Luni', 'Jednostka wykładowcy', { Luni: true }, 'Jednostka wykładowcy'],
  ['Gtype', 'Typ grupy', { Gtype: true }, 'Typ grupy'],
  ['Sorg', 'Jednostka przedmiotu', { Sorg: true }, 'Jednostka przedmiotu'],
  ['owner', 'Właściciel', { owner: true }, 'Właściciel'],
  ['createdBy', 'Utworzył', { createdBy: true }, 'Utworzył'],
  ['desc1', 'desc1', { desc1: true }, 'desc1'], ['desc2', 'desc2', { desc2: true }, 'desc2'],
  ['desc3', 'desc3', { desc3: true }, 'desc3'], ['desc4', 'desc4', { desc4: true }, 'desc4'],
];
const ALL_FLAGS = ['L', 'G', 'R', 'S', 'F', 'FnewColumn', 'day', 'month', 'dayOfWeek', 'hour', 'Luni', 'Gtype', 'Sorg', 'owner', 'createdBy',
  'desc1', 'desc2', 'desc3', 'desc4', 'LnewLine', 'GnewLine', 'RnewLine', 'Gstudents', 'Gorg', 'Gparent', 'Rorg', 'fill', 'creationDate',
  'integrationId', 'classId', 'emergency'];
const WD_ORDER = ['pon', 'wt', 'śr', 'czw', 'pt', 'sob', 'niedz', 'nie'];
const MAX = 4;          // pól w wierszach i w kolumnach
const MAX_CONTENT = 6;  // pól zajęcia na przecięciu (cell1..cell6 w Delphi)
const PREF_KEY = user => 'plansoft.web.pivot2.' + user;
const DEFAULTS = { rows: ['L'], cols: ['F'], mode: 'hours', content: ['S', 'F', 'G', 'R'], dates: true, onlySelected: true, split: true, phrase: '' };

export class PivotWindow {
  // getContext: () => { user, period, settings, objects: {L, G, S} }
  constructor({ api, getContext }) {
    this.api = api;
    this.getContext = getContext;
    this.dialog = el('dialog', 'pivot');
    document.body.append(this.dialog);
  }

  fieldLabel(key) {
    const f = FIELDS.find(x => x[0] === key);
    const m = /^desc(\d)$/.exec(f[1]);
    return m ? this.ctx.settings.descPlural[m[1] - 1] : f[1];
  }

  // preset: częściowe ustawienia, np. "Zaawansowane: własny układ" z Podglądu
  open(preset) {
    this.ctx = this.getContext();
    let saved = {};
    try { saved = JSON.parse(localStorage.getItem(PREF_KEY(this.ctx.user))) || {}; } catch { /* brak pamięci */ }
    this.build({ ...DEFAULTS, ...saved, ...(preset || {}) });
    this.dialog.showModal();
  }

  build(v) {
    const d = this.dialog;
    d.innerHTML = '';
    const head = el('div', 'b-head');
    head.append(el('h2', '', 'Tabela przestawna'), el('span', 'spacer'), button('×', 'link close', () => d.close(), 'Zamknij (Esc)'));
    const keys = FIELDS.map(f => f[0]).filter(k => this.fieldLabel(k));
    const sel = (value, empty) => {
      const s = el('select');
      if (empty) s.append(new Option(empty, ''));
      for (const k of keys) s.append(new Option(this.fieldLabel(k), k));
      s.value = value || '';
      return s;
    };
    const group = (label, selects, cls) => { const g = el('fieldset', 'pv-group ' + (cls || '')); g.append(el('legend', '', label), ...selects); return g; };

    const layout = el('div', 'pv-layout');
    this.rowSel = Array.from({ length: MAX }, (_, i) => sel(v.rows[i], i ? '<brak>' : null));
    this.colSel = Array.from({ length: MAX }, (_, i) => sel(v.cols[i], '<brak>'));
    // na przecięciu: liczba godzin albo zajęcia (pola zajęcia i daty)
    const cellBox = el('fieldset', 'pv-group pv-cell');
    cellBox.append(el('legend', '', 'Na przecięciu'));
    const radio = (val, label) => {
      const l = el('label', 'check'); const r = el('input'); r.type = 'radio'; r.name = 'pvMode'; r.value = val; r.checked = v.mode === val;
      r.addEventListener('change', () => this.updateMode()); l.append(r, ' ' + label); return l;
    };
    this.contentSel = Array.from({ length: MAX_CONTENT }, (_, i) => sel(v.content[i], '<brak>'));
    const dl = el('label', 'check'); this.datesChk = el('input'); this.datesChk.type = 'checkbox'; this.datesChk.checked = !!v.dates;
    dl.append(this.datesChk, ' daty zajęć');
    this.contentBox = el('div', 'pv-content');
    this.contentBox.append(el('span', 'muted', 'Pola zajęcia:'), ...this.contentSel, dl);
    cellBox.append(radio('hours', 'Liczba godzin (suma, z podsumowaniem)'), radio('classes', 'Zajęcia (do wydruku)'), this.contentBox);
    layout.append(group('Wiersze', this.rowSel), group('Kolumny', this.colSel), cellBox);

    const filt = el('div', 'pv-filters');
    const o = this.ctx.objects;
    const names = t => o[t].map(i => i.name).join(', ');
    const chk = (label, val, title) => { const l = el('label', 'check'); const c = el('input'); c.type = 'checkbox'; c.checked = !!val; l.append(c, ' ' + label); if (title) l.title = title; return [l, c]; };
    const [l1, c1] = chk('Tylko obiekty wybrane w oknie głównym', v.onlySelected,
      ['Wykładowcy: ' + (names('L') || '-'), 'Grupy: ' + (names('G') || '-'), 'Zasoby: ' + (names('S') || '-')].join('\n'));
    const [l2, c2] = chk('Każdy wykładowca / grupa / zasób osobno', v.split, 'Zajęcia kilku grup liczone dla każdej grupy osobno (inaczej: wiersz "Grupa A; Grupa B")');
    this.onlySel = c1; this.split = c2;
    this.phrase = el('input'); this.phrase.type = 'search'; this.phrase.placeholder = 'Dowolna fraza (kilka fraz oddziel przecinkiem)'; this.phrase.value = v.phrase || '';
    filt.append(el('span', 'muted', `Okres: ${this.ctx.period ? this.ctx.period.name : '-'}`), l1, l2, this.phrase);

    const actions = el('div', 'b-actions pv-actions');
    this.bGo = button('Utwórz tabelę', 'primary', () => this.generate());
    this.bXls = button('', 'secondary small', () => this.exportExcel(), 'Eksport do Excel'); this.bXls.innerHTML = EXCEL_ICON + ' Eksport do Excel'; this.bXls.disabled = true;
    this.bPrint = button('Drukuj', 'secondary small', () => this.print()); this.bPrint.disabled = true;
    this.status = el('span', 'muted');
    actions.append(this.bGo, this.bXls, this.bPrint, this.status);
    this.out = el('div', 'pv-out');
    d.append(head, layout, filt, actions, this.out);
    this.updateMode();
  }

  get mode() { const r = this.dialog.querySelector('input[name=pvMode]:checked'); return r ? r.value : 'hours'; }
  updateMode() { this.contentBox.classList.toggle('off', this.mode !== 'classes'); this.contentSel.forEach(s => { s.disabled = this.mode !== 'classes'; }); this.datesChk.disabled = this.mode !== 'classes'; }

  settings() {
    return {
      rows: this.rowSel.map(s => s.value), cols: this.colSel.map(s => s.value), mode: this.mode,
      content: this.contentSel.map(s => s.value), dates: this.datesChk.checked,
      onlySelected: this.onlySel.checked, split: this.split.checked, phrase: this.phrase.value.trim(),
    };
  }

  async generate() {
    const st = this.settings();
    const rows = [...new Set(st.rows.filter(Boolean))], cols = [...new Set(st.cols.filter(Boolean))].filter(k => !rows.includes(k));
    if (!rows.length && !cols.length) { this.status.textContent = 'Wybierz pole wierszy lub kolumn.'; return; }
    const classes = st.mode === 'classes';
    const content = classes ? [...new Set(st.content.filter(Boolean))] : [];
    if (classes && !content.length && !st.dates) { this.status.textContent = 'Wybierz pola zajęcia, które mają być na przecięciu.'; return; }
    const keys = [...new Set([...rows, ...cols, ...content])];
    const opts = Object.fromEntries(ALL_FLAGS.map(f => [f, false]));
    for (const k of keys) Object.assign(opts, FIELDS.find(f => f[0] === k)[2]);
    if (st.split) for (const [k, f] of [['L', 'LnewLine'], ['G', 'GnewLine'], ['R', 'RnewLine']]) opts[f] = [...rows, ...cols].includes(k);
    // tryb "Zajęcia": jeden wiersz na zajęcie (bez grupowania), z datą i godziną
    if (classes) { opts.emergency = true; opts.classId = true; if (st.dates) { opts.day = true; opts.hour = true; } }
    opts.period = this.ctx.period && this.ctx.period.id;
    opts.sortOrder = '1';
    opts.phrase = st.phrase;
    if (st.onlySelected) for (const [t, k] of [['L', 'lec'], ['G', 'gro'], ['S', 'rom']]) opts[k] = this.ctx.objects[t].map(i => i.id);
    try { localStorage.setItem(PREF_KEY(this.ctx.user), JSON.stringify(st)); } catch { /* brak pamięci */ }
    this.status.textContent = '';
    let r;
    try { r = await withProgress(this.out, 'Tworzenie tabeli…', () => this.api('report', opts), [this.bGo, this.bXls, this.bPrint]); }
    catch (e) { this.status.textContent = e.message; return; }
    this.pivot(r, rows, cols, content, classes && st.dates);
  }

  // dane raportu -> klucze wierszy i kolumn (po kilka pól), na przecięciu suma godzin albo lista zajęć
  pivot(r, rows, cols, content, dates) {
    const idx = label => r.columns.indexOf(label);
    const valueOf = (row, key, splitL) => {
      const f = FIELDS.find(x => x[0] === key);
      if (key === 'L' && splitL) return ['Tytuł', 'Imię', 'Nazwisko'].map(c => row[idx(c)]).filter(Boolean).join(' ').trim() || '(brak)';
      const label = /^desc\d$/.test(f[3]) ? this.ctx.settings.descPlural[f[3].slice(-1) - 1] : f[3];
      const v = row[idx(label)];
      return v === null || v === undefined || v === '' ? '' : String(v);
    };
    const splitL = this.split.checked && [...rows, ...cols].includes('L');
    const dim = (row, key) => valueOf(row, key, splitL) || '(brak)';
    const sumIdx = idx('Zajęcia (suma)'), idIdx = idx('ID zajęcia'), dayIdx = idx('Dzień');
    const classes = idIdx >= 0;
    const cells = new Map(), rowKeys = new Map(), colKeys = new Map();
    for (const row of r.rows) {
      const rk = rows.map(k => dim(row, k)), ck = cols.map(k => dim(row, k));
      const rs = JSON.stringify(rk), cs = JSON.stringify(ck);
      rowKeys.set(rs, rk); colKeys.set(cs, ck);
      const key = rs + '\u0001' + cs;
      if (!classes) { cells.set(key, (cells.get(key) || 0) + (Number(row[sumIdx]) || 0)); continue; }
      // zajęcia: te same pola zajęcia w komórce - jeden wpis z listą dat
      const lines = content.map(k => valueOf(row, k, splitL && k === 'L')).filter(Boolean);
      const sig = lines.join('\u0002');
      if (!cells.has(key)) cells.set(key, new Map());
      const m = cells.get(key);
      if (!m.has(sig)) m.set(sig, { lines, dates: new Set(), ids: new Set() });
      const e = m.get(sig);
      e.ids.add(row[idIdx]);
      if (dates && dayIdx >= 0 && row[dayIdx]) e.dates.add(String(row[dayIdx]));
    }
    const order = key => (a, b) => {
      if (key === 'dayOfWeek') return WD_ORDER.indexOf(a.replace('.', '')) - WD_ORDER.indexOf(b.replace('.', ''));
      if (key === 'hour' && this.ctx.period) { const h = this.ctx.period.hours.map(x => x.caption || String(x.no)); return h.indexOf(a) - h.indexOf(b); }
      return a.localeCompare(b, 'pl', { numeric: true });
    };
    const sortKeys = (map, fields) => [...map.entries()].sort((a, b) => {
      for (let i = 0; i < fields.length; i++) { const c = order(fields[i])(a[1][i], b[1][i]); if (c) return c; }
      return 0;
    });
    this.result = { rows, cols, classes, rowKeys: sortKeys(rowKeys, rows), colKeys: sortKeys(colKeys, cols), cells };
    this.render();
    const n = this.result.rowKeys.length;
    this.status.textContent = `${n} ${n === 1 ? 'wiersz' : 'wierszy'} × ${this.result.colKeys.length} kolumn${r.truncated ? ' (dane obcięte - zawęź filtry)' : ''}`;
    this.bXls.disabled = this.bPrint.disabled = !n;
  }

  // zawartość komórki: liczba godzin albo zajęcia (pola w liniach, pod spodem daty)
  cellValue(rs, cs) {
    const v = this.result.cells.get(rs + '\u0001' + cs);
    if (!this.result.classes) return v ? Math.round(v * 100) / 100 : 0;
    return v ? [...v.values()] : [];
  }
  static fmtDates(set) {
    const d = [...set].sort();
    return `${d.length} × ` + d.map(x => `${x.slice(8, 10)}.${x.slice(5, 7)}`).join(', ');
  }

  // tabela HTML (także do wydruku): nagłówki kolumn zagnieżdżone, nagłówki wierszy bez powtórzeń
  tableHtml() {
    const { rows, cols, classes, rowKeys, colKeys } = this.result;
    const nr = Math.max(rows.length, 1);
    const totals = !classes;
    let h = '<table class="pv-table' + (classes ? ' pv-classes' : '') + '"><thead>';
    const colLevels = Math.max(cols.length, 1);
    for (let lvl = 0; lvl < colLevels; lvl++) {
      h += '<tr>';
      if (lvl === 0) h += (rows.length ? rows : ['']).map(k => `<th rowspan="${colLevels}" class="pv-rh">${esc(k ? this.fieldLabel(k) : '')}</th>`).join('');
      if (!cols.length) h += `<th>${classes ? 'Zajęcia' : 'Liczba godzin'}</th>`;
      else {
        // scalanie sąsiednich kolumn o tym samym początku klucza
        for (let i = 0; i < colKeys.length;) {
          let j = i + 1;
          const pre = colKeys[i][1].slice(0, lvl + 1).join('\u0001');
          while (j < colKeys.length && colKeys[j][1].slice(0, lvl + 1).join('\u0001') === pre) j++;
          h += `<th colspan="${j - i}" title="${esc(this.fieldLabel(cols[lvl]))}">${esc(colKeys[i][1][lvl])}</th>`;
          i = j;
        }
      }
      if (totals && cols.length && lvl === 0) h += `<th rowspan="${colLevels}" class="num">Razem</th>`;
      h += '</tr>';
    }
    h += '</thead><tbody>';
    const colTotals = colKeys.map(() => 0);
    let grand = 0;
    rowKeys.forEach(([rs, rk], ri) => {
      h += '<tr>';
      // nagłówki wierszy: wartość pokazywana, gdy zmienia się względem poprzedniego wiersza
      for (let i = 0; i < nr; i++) {
        const same = ri > 0 && rowKeys[ri - 1][1].slice(0, i + 1).join('\u0001') === rk.slice(0, i + 1).join('\u0001');
        h += `<th class="pv-rh${same ? ' rep' : ''}">${same ? '' : esc(rk[i] ?? '')}</th>`;
      }
      let rowSum = 0;
      (cols.length ? colKeys : [['[]', []]]).forEach(([cs], ci) => {
        const v = this.cellValue(rs, cs);
        if (!classes) {
          rowSum += v; colTotals[ci] = (colTotals[ci] || 0) + v;
          h += `<td class="num${v ? '' : ' zero'}">${v ? v : ''}</td>`;
        } else {
          h += '<td>' + v.map(e => `<div class="pv-cla">${e.lines.map((l, i) => (i ? esc(l) : `<b>${esc(l)}</b>`)).join('<br>')}`
            + (e.dates.size ? `<div class="pv-dates">${esc(PivotWindow.fmtDates(e.dates))}</div>` : (e.ids.size > 1 ? `<div class="pv-dates">${e.ids.size} zajęć</div>` : '')) + '</div>').join('') + '</td>';
        }
      });
      if (totals && cols.length) h += `<td class="num">${Math.round(rowSum * 100) / 100}</td>`;
      grand += rowSum;
      h += '</tr>';
    });
    h += '</tbody>';
    if (totals) {
      h += `<tfoot><tr><th class="pv-rh" colspan="${nr}">Razem</th>`
        + (cols.length ? colKeys.map((_, ci) => `<td class="num">${Math.round(colTotals[ci] * 100) / 100}</td>`).join('') : '')
        + `<td class="num">${Math.round(grand * 100) / 100}</td></tr></tfoot>`;
    }
    return h + '</table>';
  }

  render() {
    this.out.innerHTML = '';
    if (!this.result.rowKeys.length) { this.out.append(el('p', 'muted', 'Brak zajęć dla wybranych filtrów.')); return; }
    this.out.innerHTML = this.tableHtml();
  }

  exportExcel() {
    if (!this.result) return;
    const { rows, cols, classes, rowKeys, colKeys } = this.result;
    const colHead = cols.length ? colKeys.map(([, ck]) => ck.join(' / ')) : [classes ? 'Zajęcia' : 'Liczba godzin'];
    const header = [...(rows.length ? rows.map(k => this.fieldLabel(k)) : ['']), ...colHead, ...(classes || !cols.length ? [] : ['Razem'])];
    const data = rowKeys.map(([rs, rk]) => {
      const vals = (cols.length ? colKeys : [['[]']]).map(([cs]) => {
        const v = this.cellValue(rs, cs);
        return classes ? v.map(e => [...e.lines, e.dates.size ? PivotWindow.fmtDates(e.dates) : ''].filter(Boolean).join('\n')).join('\n\n') : v;
      });
      return [...(rows.length ? rk : ['']), ...vals, ...(classes || !cols.length ? [] : [Math.round(vals.reduce((a, b) => a + b, 0) * 100) / 100])];
    });
    downloadXlsx('Tabela przestawna', 'Tabela przestawna', header, data);
  }

  // wydruk: tabela na stronie poziomej, nagłówek kolumn powtarzany na każdej stronie
  print() {
    if (!this.result) return;
    const w = window.open('', '_blank');
    if (!w) { alert('Przeglądarka zablokowała nowe okno - zezwól na wyskakujące okna dla tej strony.'); return; }
    const p = this.ctx.period;
    const desc = [`Wiersze: ${this.result.rows.map(k => this.fieldLabel(k)).join(', ') || '-'}`, `Kolumny: ${this.result.cols.map(k => this.fieldLabel(k)).join(', ') || '-'}`].join(' · ');
    w.document.write(`<!doctype html><html lang="pl"><head><meta charset="utf-8"><title>Tabela przestawna</title><style>
      body { font: 11px 'Segoe UI', Tahoma, sans-serif; margin: 12px; color: #000; }
      h1 { font-size: 16px; margin: 0 0 2px; } .sub { color: #555; margin: 0 0 10px; }
      table { border-collapse: collapse; } thead { display: table-header-group; }
      th, td { border: 1px solid #888; padding: 3px 5px; vertical-align: top; }
      thead th, tfoot td, tfoot th { background: #eef2f7; }
      th.pv-rh { text-align: left; background: #f6f7f9; white-space: nowrap; } th.pv-rh.rep { border-top-color: transparent; }
      td.num { text-align: right; } td.zero { color: transparent; }
      .pv-classes td { min-width: 110px; } .pv-cla + .pv-cla { border-top: 1px dashed #bbb; margin-top: 4px; padding-top: 4px; }
      .pv-dates { color: #555; font-size: 10px; margin-top: 2px; } tr { page-break-inside: avoid; }
      @media print { button { display: none; } body { margin: 0; } @page { size: landscape; margin: 8mm; } }
      </style></head><body><button onclick="print()">Drukuj</button>
      <h1>Tabela przestawna${p ? ' – ' + esc(p.name) : ''}</h1><p class="sub">${esc(desc)}</p>${this.tableHtml()}</body></html>`);
    w.document.close();
  }
}
