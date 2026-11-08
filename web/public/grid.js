// Siatka semestralna jak w programie Delphi (UUtilities.pas, TConvertSingleObject):
// kolumny = kolejne tygodnie okresu, wiersze = dni tygodnia; każdy dzień ma wiersz z datami
// i pod nim wiersze godzin. Pierwsze dwie kolumny: nazwa dnia i numer godziny.

const DAY_NAMES = ['pon.', 'wt.', 'śr.', 'czw.', 'pt.', 'sob.', 'niedz.'];
const DAY_LONG = ['poniedziałek', 'wtorek', 'środa', 'czwartek', 'piątek', 'sobota', 'niedziela'];
const ROMAN = ['I', 'II', 'III', 'IV', 'V', 'VI', 'VII', 'VIII', 'IX', 'X', 'XI', 'XII'];

// daty jako liczba dni (UTC), bez problemów ze zmianą czasu
const toDays = iso => Date.UTC(+iso.slice(0, 4), +iso.slice(5, 7) - 1, +iso.slice(8, 10)) / 864e5;
const fromDays = d => new Date(d * 864e5);
const todayDays = () => { const n = new Date(); return Date.UTC(n.getFullYear(), n.getMonth(), n.getDate()) / 864e5; };
const mondayOf = d => d - ((fromDays(d).getUTCDay() + 6) % 7);

function el(tag, cls, text) {
  const e = document.createElement(tag);
  if (cls) e.className = cls;
  if (text !== undefined) e.textContent = text;
  return e;
}

// nagłówek daty jak w Delphi: "07 X"
const dateLabel = d => { const t = fromDays(d); return String(t.getUTCDate()).padStart(2, '0') + ' ' + ROMAN[t.getUTCMonth()]; };
const dateIso = d => fromDays(d).toISOString().slice(0, 10);

// klucz komórki: data|godzina|obiekt (obiekt pusty, gdy wszystkie wybrane obiekty są na jednym arkuszu)
export const cellKey = (date, hour, obj) => `${date}|${hour}|${obj || ''}`;

// opts.blocks: [{id, name}] - osobny arkusz dla każdego obiektu (opcja "Wiele obiektów" w oknie "Zajęcie"),
// opts.orientation: 'vertical' (arkusze jeden pod drugim) | 'horizontal' (obok siebie); bez blocks - jeden arkusz
// opts.week: poniedziałek (YYYY-MM-DD) - układ tygodniowy: jeden tydzień, w kolumnach obiekty (blocks)
export function renderSemesterGrid(container, period, opts = {}) {
  container.innerHTML = '';
  const from = toDays(period.dateFrom);
  const to = toDays(period.dateTo);
  const days = period.days.map((v, i) => (v ? i : -1)).filter(i => i >= 0);   // 0 = pon.
  if (!days.length) { container.append(el('p', 'muted pad', 'Okres nie zawiera żadnego dnia tygodnia.')); return; }

  const weeks = [];
  for (let m = mondayOf(from); m <= to; m += 7) weeks.push(m);
  const weekView = !!opts.week;
  const weekNo = weekView ? weeks.indexOf(toDays(opts.week)) + 1 : 0;
  if (weekView) weeks.splice(0, weeks.length, toDays(opts.week));

  const hours = [];
  for (let h = 1; h <= (period.hoursPerDay || 0); h++) {
    const g = period.hours.find(x => x.no === h);
    hours.push({ no: h, label: g && g.caption ? g.caption : String(h), title: g && g.from ? `${g.from}–${g.to}` : '' });
  }

  const blocks = opts.blocks && opts.blocks.length ? opts.blocks : [null];
  const split = blocks[0] !== null;
  const horizontal = split && (weekView || opts.orientation === 'horizontal');
  const colBlocks = horizontal ? blocks : [blocks[0]];   // arkusze obok siebie (kolumny)
  const rowBlocks = horizontal ? [null] : blocks;        // arkusze jeden pod drugim (wiersze)
  const cols = colBlocks.length * weeks.length;
  const objId = b => (b ? String(b.id) : '');

  const today = todayDays();
  const table = el('table', 'semester' + (split ? ' split' : '') + (weekView ? ' week-view' : ''));
  const colgroup = el('colgroup');
  colgroup.append(el('col', 'c-day'), el('col', 'c-hour'));
  for (let c = 0; c < cols; c++) colgroup.append(el('col', 'c-week'));
  table.append(colgroup);
  const blockStart = c => (c > 0 && c % weeks.length === 0 ? ' blk-start' : '');

  const thead = el('thead');
  // arkusze obok siebie: nad tygodniami nazwa obiektu
  if (horizontal) {
    const or = el('tr', 'objs');
    or.append(el('th', 'corner', ''), el('th', 'corner', ''));
    colBlocks.forEach((b, i) => {
      const th = el('th', 'obj-col' + blockStart(i * weeks.length));
      th.append(el('span', '', b.name));
      th.colSpan = weeks.length;
      th.title = weekView ? `${b.name} - kliknij, aby wrócić do układu semestralnego (rozkład tego obiektu)` : `${b.name} - kliknij, aby zaznaczyć cały arkusz`;
      Object.assign(th.dataset, { c0: i * weeks.length, c1: (i + 1) * weeks.length - 1, obj: b.id });
      or.append(th);
    });
    thead.append(or);
  }
  // wiersz tygodni (numer tygodnia okresu) - ułatwia orientację przy przewijaniu
  const wr = el('tr', 'weeks');
  wr.append(el('th', 'corner', ''), el('th', 'corner', ''));
  colBlocks.forEach((b, bi) => weeks.forEach((m, i) => {
    const c = bi * weeks.length + i;
    const th = el('th', 'week' + blockStart(c), `tydz. ${weekView ? weekNo : i + 1}`);
    th.title = `${b ? b.name + ': ' : ''}${dateIso(m)} – ${dateIso(m + 6)} - ` +
      (weekView ? 'kliknij, aby wrócić do układu semestralnego' : 'kliknij, aby pokazać układ tygodniowy (w kolumnach obiekty)');
    Object.assign(th.dataset, { col: c, monday: dateIso(m) });
    if (b) th.dataset.obj = b.id;
    wr.append(th);
  }));
  thead.append(wr);
  table.append(thead);

  const tbody = el('tbody');
  const matrix = [];   // wiersze godzin (wszystkie dni po kolei) x tygodnie -> komórki
  for (const rb of rowBlocks) {
    // arkusze jeden pod drugim: wiersz z nazwą obiektu
    let objHead = null;
    if (rb) {
      const tr = el('tr', 'obj-head');
      objHead = el('th', 'obj-name');
      objHead.append(el('span', '', rb.name));
      objHead.colSpan = cols + 2;
      objHead.title = `${rb.name} - kliknij, aby zaznaczyć cały arkusz`;
      Object.assign(objHead.dataset, { r0: matrix.length });
      tr.append(objHead);
      tbody.append(tr);
    }
    for (const wd of days) {
      const first = matrix.length, last = first + hours.length - 1;
      // wiersz z datami
      const hr = el('tr', 'day-head');
      const dn = el('th', 'day-name', DAY_NAMES[wd]);
      dn.title = `${DAY_LONG[wd]} - kliknij, aby zaznaczyć cały dzień`;
      dn.rowSpan = hours.length + 1;
      Object.assign(dn.dataset, { r0: first, r1: last });
      hr.append(dn, el('th', 'hour-no', ''));
      colBlocks.forEach((cb, bi) => weeks.forEach((m, i) => {
        const c = bi * weeks.length + i;
        const d = m + wd;
        const inside = d >= from && d <= to;
        const th = el('th', 'date' + (inside ? '' : ' outside') + (d === today ? ' today' : '') + blockStart(c), inside ? dateLabel(d) : '');
        if (inside) th.title = `${DAY_LONG[wd]} ${dateIso(d)}`;
        Object.assign(th.dataset, { r0: first, r1: last, col: c });
        hr.append(th);
      }));
      tbody.append(hr);

      // wiersze godzin
      for (const h of hours) {
        const r = matrix.length;
        const tr = el('tr', 'hour');
        const hn = el('th', 'hour-no', h.label);
        hn.title = (h.title ? h.title + ' - ' : '') + 'kliknij, aby zaznaczyć wiersz';
        hn.dataset.row = r;
        tr.append(hn);
        const row = [];
        colBlocks.forEach((cb, bi) => weeks.forEach((m, i) => {
          const c = bi * weeks.length + i;
          const d = m + wd;
          const inside = d >= from && d <= to;
          const td = el('td', (inside ? 'cell' : 'cell outside') + blockStart(c));
          Object.assign(td.dataset, { row: r, col: c, obj: objId(rb || cb) });
          if (inside) { td.dataset.date = dateIso(d); td.dataset.hour = h.no; }
          tr.append(td);
          row.push(td);
        }));
        matrix.push(row);
        tbody.append(tr);
      }
    }
    if (objHead) objHead.dataset.r1 = matrix.length - 1;
  }
  table.append(tbody);

  // komórki wg daty, godziny i obiektu - do wypełniania zajęciami
  container.cells = new Map();
  container.blockIds = blocks.map(objId);
  container.blockType = opts.type;
  container.weekView = weekView;
  table.querySelectorAll('td.cell[data-date]').forEach(td => container.cells.set(cellKey(td.dataset.date, td.dataset.hour, td.dataset.obj), td));

  enableSelection(container, table, matrix, cols);
  container.append(table);
  // dwa wiersze nagłówka: wiersz tygodni przyklejony pod wierszem z nazwami obiektów
  if (horizontal) {
    const h = thead.querySelector('tr.objs').getBoundingClientRect().height;
    wr.querySelectorAll('th').forEach(th => { th.style.top = h + 'px'; });
  }
}

// komórki danego dnia i godziny we wszystkich arkuszach (lub w arkuszu obiektu obj)
const cellsAt = (container, date, hour, obj) =>
  (obj !== undefined ? [obj] : container.blockIds || ['']).map(o => container.cells.get(cellKey(date, hour, o))).filter(Boolean);

// zaznaczanie jak w siatce Delphi: prostokąt myszą, nagłówek tygodnia = kolumna, godzina = wiersz,
// nazwa dnia = wszystkie godziny dnia, data = godziny dnia w tym tygodniu; Shift rozszerza, Ctrl dodaje
function enableSelection(container, table, matrix, cols) {
  const rows = matrix.length;
  let selected = new Set();   // klucze "wiersz,kolumna"
  let base = new Set();       // zaznaczenie sprzed bieżącego przeciągania (Ctrl)
  let anchor = null, drag = null;

  const rect = (a, b) => {
    const s = new Set();
    for (let r = Math.min(a.r0, b.r0); r <= Math.max(a.r1, b.r1); r++)
      for (let c = Math.min(a.c0, b.c0); c <= Math.max(a.c1, b.c1); c++) s.add(r + ',' + c);
    return s;
  };
  const paint = () => {
    for (let r = 0; r < rows; r++) for (let c = 0; c < cols; c++) matrix[r][c].classList.toggle('selected', selected.has(r + ',' + c));
  };
  const notify = () => container.dispatchEvent(new CustomEvent('gridselect', { detail: { count: container.getSelection().length } }));

  // obszar wskazany elementem: komórka, kolumna tygodnia, wiersz godziny, dzień, data
  const areaOf = t => {
    const d = t.dataset;
    if (t.matches('td.cell')) return { r0: +d.row, r1: +d.row, c0: +d.col, c1: +d.col };
    if (t.matches('th.week')) return { r0: 0, r1: rows - 1, c0: +d.col, c1: +d.col };
    if (t.matches('tr.hour th.hour-no')) return { r0: +d.row, r1: +d.row, c0: 0, c1: cols - 1 };
    if (t.matches('th.day-name')) return { r0: +d.r0, r1: +d.r1, c0: 0, c1: cols - 1 };
    if (t.matches('th.date')) return { r0: +d.r0, r1: +d.r1, c0: +d.col, c1: +d.col };
    if (t.matches('th.obj-name')) return { r0: +d.r0, r1: +d.r1, c0: 0, c1: cols - 1 };   // cały arkusz obiektu
    if (t.matches('th.obj-col')) return { r0: 0, r1: rows - 1, c0: +d.c0, c1: +d.c1 };
    return null;
  };

  // --- przesuwanie zajęć myszą: chwyć zaznaczone zajęcie i upuść w innym terminie - przesuwa się cały
  //     zaznaczony obszar (wszystkie jego zajęcia) o tyle samo tygodni i wierszy, jak Wytnij/Wklej obszar w Delphi;
  //     z klawiszem Ctrl przy upuszczeniu - kopia. Chwycenie niezaznaczonego zajęcia zaczyna zaznaczanie obszaru.
  let move = null;   // { r, c, keys, dr, dc, active }
  const ghost = new Set();
  const clearGhost = () => { ghost.forEach(td => td.classList.remove('drop-target', 'drop-bad')); ghost.clear(); table.classList.remove('moving'); };
  const cellOf = k => { const [r, c] = k.split(',').map(Number); return { r, c, td: matrix[r] && matrix[r][c] }; };

  // przesunięcie obszaru keys o (dr, dc): zajęcia do przeniesienia, poprawność, nowe zaznaczenie
  container.movesFor = (keys, dr, dc) => {
    const sources = keys.map(cellOf).filter(x => x.td && x.td.dataset.cla);
    const targets = sources.map(x => {
      const r = x.r + dr, c = x.c + dc;
      const td = r >= 0 && r < rows && c >= 0 && c < cols ? matrix[r][c] : null;
      // osobne arkusze obiektów: zajęcia zostają w arkuszu swojego obiektu (przesuwa się tylko termin)
      return { src: x.td, td, ok: !!(td && td.dataset.date && td.dataset.obj === x.td.dataset.obj) };
    });
    const seen = new Set();   // zajęcie kilku wybranych obiektów jest w kilku arkuszach - przesuwane raz
    return {
      targets,
      valid: targets.length > 0 && targets.every(t => t.ok),
      moves: targets.filter(t => t.ok).flatMap(t => t.src.dataset.cla.split(',').map(id => ({
        id: Number(id), from: { date: t.src.dataset.date, hour: Number(t.src.dataset.hour) },
        date: t.td.dataset.date, hour: Number(t.td.dataset.hour),
      }))).filter(m => !seen.has(m.id) && seen.add(m.id)),
      // zaznaczenie po przesunięciu: ten sam obszar w nowym miejscu (moveSelection w Delphi)
      newSelection: keys.map(k => { const { r, c } = cellOf(k); return (r + dr) + ',' + (c + dc); }),
    };
  };
  const paintGhost = () => {
    clearGhost();
    table.classList.add('moving');
    const m = container.movesFor(move.keys, move.dr, move.dc);
    const bad = !m.valid;
    m.targets.forEach(x => { if (x.td) { x.td.classList.add(bad ? 'drop-bad' : 'drop-target'); ghost.add(x.td); } });
  };

  table.addEventListener('mousedown', e => {
    if (e.button !== 0) return;
    // numer tygodnia: układ tygodniowy; w układzie tygodniowym numer tygodnia lub obiekt - powrót do semestru
    const wk = e.target.closest(container.weekView ? 'th.week, th.obj-col' : 'th.week');
    if (wk) {
      e.preventDefault();
      container.dispatchEvent(new CustomEvent('gridweek', { detail: { monday: wk.dataset.monday, obj: wk.dataset.obj } }));
      return;
    }
    const t = e.target.closest('td.cell, th.week, tr.hour th.hour-no, th.day-name, th.date, th.obj-name, th.obj-col');
    const area = t && areaOf(t);
    if (!area) return;
    e.preventDefault();
    const key = area.r0 + ',' + area.c0;
    if (t.matches('td.cell.busy') && selected.has(key) && !e.shiftKey && !e.ctrlKey && !e.metaKey && container.canMove) {
      move = { r: area.r0, c: area.c0, keys: [...selected], dr: 0, dc: 0, active: false };
      return;
    }
    base = e.ctrlKey || e.metaKey ? new Set(selected) : new Set();
    if (!(e.shiftKey && anchor)) anchor = area;
    drag = area;
    selected = new Set([...base, ...rect(anchor, area)]);
    paint();
  });
  table.addEventListener('mouseover', e => {
    if (move) {
      const td = e.target.closest('td.cell');
      if (!td) return;
      move.dr = +td.dataset.row - move.r;
      move.dc = +td.dataset.col - move.c;
      move.active = move.active || move.dr !== 0 || move.dc !== 0;
      if (move.active) paintGhost();
      return;
    }
    if (!drag) return;
    const t = e.target.closest('td.cell, th.week, tr.hour th.hour-no, th.day-name, th.date, th.obj-name, th.obj-col');
    const area = t && areaOf(t);
    if (!area) return;
    selected = new Set([...base, ...rect(anchor, area)]);
    paint();
  });
  document.addEventListener('mouseup', e => {
    if (move) {
      const m = move;
      move = null;
      clearGhost();
      if (!m.active || (m.dr === 0 && m.dc === 0)) {
        // kliknięcie bez przesunięcia: zaznacz tylko tę komórkę
        selected = new Set([m.r + ',' + m.c]); anchor = { r0: m.r, r1: m.r, c0: m.c, c1: m.c }; paint(); notify();
        return;
      }
      container.dispatchEvent(new CustomEvent('gridmove', { detail: { copy: e.ctrlKey || e.metaKey, ...container.movesFor(m.keys, m.dr, m.dc) } }));
      return;
    }
    if (drag) { drag = null; notify(); }
  });
  document.addEventListener('keydown', e => { if (e.key === 'Escape' && move) { move = null; clearGhost(); } });

  // prawy przycisk: menu kontekstowe; kliknięcie poza zaznaczeniem zaznacza tę komórkę
  table.addEventListener('contextmenu', e => {
    const td = e.target.closest('td.cell');
    if (!td) return;
    e.preventDefault();
    const key = td.dataset.row + ',' + td.dataset.col;
    if (!selected.has(key)) { selected = new Set([key]); anchor = areaOf(td); paint(); notify(); }
    container.dispatchEvent(new CustomEvent('gridcontext', { detail: { x: e.clientX, y: e.clientY, cell: td } }));
  });

  // podwójne kliknięcie komórki: okno dodawania zajęcia (jak GridDblClick w Delphi)
  table.addEventListener('dblclick', e => {
    const td = e.target.closest('td.cell');
    if (!td || !td.dataset.date) return;
    const key = td.dataset.row + ',' + td.dataset.col;
    if (!selected.has(key)) { selected = new Set([key]); anchor = areaOf(td); paint(); notify(); }
    container.dispatchEvent(new CustomEvent('griddblclick', { detail: { cell: td } }));
  });

  container.setSelectionKeys = keys => {
    selected = new Set(keys.filter(k => { const { r, c } = cellOf(k); return r >= 0 && r < rows && c >= 0 && c < cols; }));
    paint(); notify();
  };
  container.getSelectionKeys = () => [...selected];
  // lewy górny róg zaznaczenia - miejsce wklejenia (pasteArea w Delphi)
  container.selectionOrigin = () => {
    const cells = [...selected].map(cellOf);
    if (!cells.length) return null;
    return { r: Math.min(...cells.map(x => x.r)), c: Math.min(...cells.map(x => x.c)) };
  };
  // obszar w schowku: ramka niebieska (kopia) lub czerwona (wycięcie)
  container.markClipboard = (keys, mode) => {
    table.querySelectorAll('td.clip-copy, td.clip-cut').forEach(td => td.classList.remove('clip-copy', 'clip-cut'));
    (keys || []).forEach(k => { const { td } = cellOf(k); if (td) td.classList.add(mode === 'cut' ? 'clip-cut' : 'clip-copy'); });
  };

  // zaznaczone dni i godziny (bez komórek spoza okresu), posortowane; ten sam termin w kilku arkuszach - raz
  const selectedTds = () => [...selected].map(k => { const [r, c] = k.split(',').map(Number); return matrix[r][c]; }).filter(td => td.dataset.date);
  container.getSelection = () => [...new Map(selectedTds().map(td => [td.dataset.date + '|' + td.dataset.hour,
    { date: td.dataset.date, hour: Number(td.dataset.hour) }])).values()]
    .sort((a, b) => (a.date === b.date ? a.hour - b.hour : a.date < b.date ? -1 : 1));
  // obiekty (arkusze), w których jest zaznaczenie; pusta lista - wszystkie obiekty na jednym arkuszu
  container.getSelectionObjects = () => [...new Set(selectedTds().map(td => td.dataset.obj).filter(Boolean))];
  container.clearSelection = () => { selected = new Set(); anchor = null; paint(); notify(); };
  notify();   // nowa siatka (np. inny okres) - bez zaznaczenia
}

// kolor tekstu jak w Delphi: biały tylko na ciemnym tle (każda składowa RGB < $80)
function textOn(hex) {
  const n = parseInt(hex.slice(1), 16);
  return (n >> 16) < 128 && ((n >> 8) & 255) < 128 && (n & 255) < 128 ? '#ffffff' : '#000000';
}

// tło komórki: pionowe pasy kolorów, zamalowane od góry do wysokości FILL %
function cellBackground(colours, fill) {
  const w = 100 / colours.length;
  const stops = colours.map((c, i) => `${c} ${i * w}% ${(i + 1) * w}%`).join(', ');
  return `linear-gradient(to right, ${stops}) top left / 100% ${Math.max(0, Math.min(100, fill))}% no-repeat, #ffffff`;
}

const addDays = (iso, n) => { const d = new Date(iso + 'T00:00:00Z'); d.setUTCDate(d.getUTCDate() + n); return d.toISOString().slice(0, 10); };

// rozmiary komórek wg ustawień okna "Zajęcie": szerokość, wysokość (domyślnie tyle linii, ile opisów), czcionka
function applySizes(table, layout) {
  const lineH = Math.round(layout.fontSize * 1.35);
  const lines = Math.max(1, layout.lines.reduce((n, code, i) => (code !== 'NONE' ? i + 1 : n), 0));
  let width = layout.forceWidth ? layout.width : 78;
  // układ tygodniowy (jak ConvWeekObjects w Delphi): kolumny obiektów dzielą szerokość okna, co najmniej 120 px
  if (table.classList.contains('week-view') && !layout.forceWidth) {
    const n = table.querySelectorAll('col.c-week').length || 1;
    width = Math.max(120, Math.floor((table.parentElement.clientWidth - 106) / n));
  }
  table.style.setProperty('--cw', width + 'px');
  table.style.setProperty('--ch', (layout.forceHeight ? layout.height : Math.max(22, lines * lineH + 2)) + 'px');
  table.style.setProperty('--cf', layout.fontSize + 'px');
  table.style.setProperty('--lh', lineH + 'px');
}

// wstawia zajęcia do siatki narysowanej przez renderSemesterGrid (jak TFMain.GridDrawCell w Delphi)
export function fillClasses(container, data, layout, helpers) {
  if (!container.cells) return;
  const table = container.querySelector('table.semester');
  applySizes(table, layout);
  for (const td of container.cells.values()) {
    if (td.classList.contains('busy')) {
      td.classList.remove('busy', 'multi', 'reservation');
      td.textContent = ''; td.removeAttribute('title'); td.style.cssText = ''; delete td.dataset.cla;
    }
  }
  // osobne arkusze: zajęcie w arkuszu każdego wybranego obiektu, który w nim uczestniczy
  const blockIds = container.blockIds || [''];
  const idsField = { L: 'lecIds', G: 'groIds', S: 'romIds' }[container.blockType];
  const objsOf = c => (blockIds[0] === '' || !idsField ? [''] : String(c[idsField] || '').split(';').map(s => s.trim()).filter(id => blockIds.includes(id)));
  const byCell = new Map();
  for (const c of data.classes) {
    for (const obj of objsOf(c)) {
      const key = cellKey(c.day, c.hour, obj);
      if (!byCell.has(key)) byCell.set(key, []);
      byCell.get(key).push(c);
    }
  }
  const texts = new Map();   // klucz komórki -> tekst opisów (do "Ukryj takie same opisy")
  const keys = [...byCell.keys()].sort();
  for (const key of keys) {
    const list = byCell.get(key);
    const td = container.cells.get(key);
    if (!td) continue;
    const c = list[0];
    td.classList.add('busy');
    td.dataset.cla = list.map(x => x.id).join(',');   // zajęcia komórki - do przesuwania myszą
    if (list.length > 1) td.classList.add('multi');

    const box = el('div', 'cla');
    // rezerwacja: zawsze kreskowana z nazwą formy (chyba że kolorowanie wg formy)
    if (c.formKind === 'R' && layout.colour !== 'F') {
      td.classList.add('reservation');
      box.append(el('div', '', c.form));
    } else {
      const colours = helpers.colours(c, layout.colour, data);
      if (colours.length) {
        td.style.background = cellBackground(colours, c.fill);
        td.style.color = textOn(colours[0]);
      }
      const lines = layout.lines.map(code => (code === 'NONE' ? null : helpers.text(c, code, data) || ''));
      const text = lines.filter(l => l !== null).join('\u0001');
      texts.set(key, text);
      const [day, hour, obj] = key.split('|');
      const hide = layout.hideSame && texts.get(cellKey(addDays(day, -7), hour, obj)) === text;
      if (!hide) lines.forEach(l => { if (l !== null) box.append(el('div', '', l)); });
    }
    td.append(box);
    td.title = list.map(x => [
      `${x.subName || x.sub}${x.formName ? ' – ' + x.formName : ''}`,
      x.lecturers && 'Wykładowcy: ' + x.lecturers,
      x.groups && 'Grupy: ' + x.groups,
      x.rooms.trim() && 'Zasoby: ' + x.rooms.trim(),
      ...x.desc.map((d, i) => d && `${helpers.descName(i)}: ${d}`),
      x.fill < 100 && `Wypełnienie: ${x.fill}%`,
    ].filter(Boolean).join('\n')).join('\n\n');
  }
}

// --- wolne terminy: zajętość wybranych zasobów w pustych komórkach (DrawBusy w Delphi) -------------
const BUSY_COLOUR = { W: '#ffff00', G: '#ff8080', S: '#c00000' };   // wykładowca / grupa / sala, kilka typów: czerwony
export function paintBusy(container, rows, showGroups) {
  if (!container.cells) return;
  container.querySelectorAll('.busy-dot').forEach(d => d.remove());
  container.querySelectorAll('td.cell[data-busy-title]').forEach(td => { td.removeAttribute('title'); delete td.dataset.busyTitle; });
  const byCell = new Map();
  for (const r of rows || []) {
    const k = r.day + '|' + r.hour;
    if (!byCell.has(k)) byCell.set(k, []);
    byCell.get(k).push(r);
  }
  for (const [k, list] of byCell) for (const td of cellsAt(container, ...k.split('|'))) {
    if (td.classList.contains('busy')) continue;   // komórka z zajęciami bieżącego rozkładu
    const types = [...new Set(list.flatMap(x => x.types.split('')))];
    const dot = document.createElement('span');
    dot.className = 'busy-dot';
    dot.style.background = types.length === 1 ? BUSY_COLOUR[types[0]] : '#ff0000';
    if (list.length > 1) dot.textContent = list.length;
    td.append(dot);
    if (showGroups) {
      const g = document.createElement('span');
      g.className = 'busy-dot busy-groups';
      g.textContent = [...new Set(list.map(x => x.groups).filter(Boolean))].join(', ');
      td.append(g);
    }
    td.title = 'Kolizje:\n' + list.map(x => `[${x.types}] ${x.text}`).join('\n');
    td.dataset.busyTitle = '1';
  }
}

// --- preferowane terminy: trójkąt w rogu komórki (DrawTriangle), czerwony = niepreferowany ------------
export function paintHints(container, hints) {
  if (!container.cells) return;
  container.querySelectorAll('.hint-tri').forEach(d => d.remove());
  // osobne arkusze: ocena terminu w arkuszu ocenianego obiektu (inny typ obiektu - we wszystkich arkuszach)
  const blockIds = container.blockIds || [''];
  const byCell = new Map();
  for (const h of hints || []) {
    const obj = blockIds.includes(String(h.resId)) ? String(h.resId) : '*';
    const k = h.day + '|' + h.hour + '|' + obj;
    if (!byCell.has(k)) byCell.set(k, []);
    byCell.get(k).push(h);
  }
  for (const [k, list] of byCell) for (const td of (([d, h, o]) => cellsAt(container, d, h, o === '*' ? undefined : o))(k.split('|'))) {
    const worst = Math.min(...list.map(h => h.ratio));
    const tri = document.createElement('span');
    tri.className = 'hint-tri ' + (worst < 0 ? 'bad' : 'good');
    const size = Math.max(4, Math.round(Math.abs(worst) / 100) + 2);
    tri.style.borderWidth = `${size}px ${size}px 0 0`;
    tri.title = list.map(h => `${h.resName || 'id ' + h.resId} - ${h.ratio < 0 ? 'termin niepreferowany' : 'termin preferowany'} (${h.ratio})`).join('\n');
    td.append(tri);
  }
}
