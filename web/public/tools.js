// Okna narzędzi z menu Delphi: Dostępne miejsce (TFDBSpace), Dziennik zdarzeń systemowych (TFBrowseEVENTLOG),
// Oczekujące zadania (TFWaitingTasks, odświeżanie co 5 minut) i Lista obecności (wybór dat, wynik HTML w nowej karcie).
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
const isoDay = d => new Date(Date.UTC(d.getFullYear(), d.getMonth(), d.getDate())).toISOString().slice(0, 10);

// prosta tabela z nagłówkiem: cols = [[klucz, etykieta, 'num'?]]
function table(cols, rows, rowClass) {
  const t = el('table', 'tool-grid');
  const hr = el('tr');
  cols.forEach(([, label, kind]) => hr.append(el('th', kind || '', label)));
  const thead = el('thead'); thead.append(hr); t.append(thead);
  const tb = el('tbody');
  rows.forEach((r, i) => {
    const tr = el('tr', rowClass ? rowClass(r, i) : '');
    cols.forEach(([k, , kind]) => tr.append(el('td', kind || '', r[k] ?? '')));
    tb.append(tr);
  });
  t.append(tb);
  return t;
}

export class ToolsWindow {
  constructor({ api }) {
    this.api = api;
    this.dialog = el('dialog', 'tool');
    document.body.append(this.dialog);
    this.dialog.addEventListener('close', () => { clearInterval(this.timer); this.dialog.innerHTML = ''; });
  }

  shell(title, cls) {
    clearInterval(this.timer);
    const d = this.dialog;
    d.className = 'tool ' + (cls || '');
    d.innerHTML = '';
    const head = el('div', 'b-head');
    head.append(el('h2', '', title), el('span', 'spacer'), button('×', 'link close', () => d.close(), 'Zamknij (Esc)'));
    this.body = el('div', 'tool-body');
    d.append(head, this.body);
    if (!d.open) d.showModal();
    return this.body;
  }

  error(text) { this.body.append(el('p', 'error pad', text)); }

  // --- Dostępne miejsce ---------------------------------------------------------------------
  async dbSpace() {
    const b = this.shell('Dostępne miejsce', 'small');
    b.append(el('p', 'muted', 'Wczytywanie…'));
    let r;
    try { r = await this.api('tools/dbspace'); } catch (e) { b.innerHTML = ''; return this.error(e.message); }
    b.innerHTML = '';
    const pct = Number(r.usedPercent) || 0;
    const bar = el('div', 'space-bar');
    const fill = el('div', 'space-fill ' + (pct >= 90 ? 'bad' : pct >= 70 ? 'warn' : 'ok'));
    fill.style.width = Math.min(100, Math.max(0, pct)) + '%';
    bar.append(fill, el('span', 'space-pct', pct.toLocaleString('pl-PL', { minimumFractionDigits: 1, maximumFractionDigits: 1 }) + ' %'));
    const nums = el('div', 'space-nums');
    nums.append(el('span', '', `Wykorzystano: ${r.usedGb} GB`), el('span', '', `Limit: ${r.limitGb} GB`), el('span', '', `Wolne: ${r.freeGb} GB`));
    const details = el('div', 'space-details'); details.hidden = true;
    const toggle = button('Szczegóły', 'secondary small', async () => {
      details.hidden = !details.hidden;
      toggle.textContent = details.hidden ? 'Szczegóły' : 'Ukryj szczegóły';
      if (!details.hidden && !details.childElementCount) {
        details.append(el('p', 'muted', 'Wczytywanie…'));
        try {
          const rows = await this.api('tools/dbspace/segments');
          details.innerHTML = '';
          details.append(el('h3', '', '20 największych segmentów'),
            table([['owner', 'Właściciel'], ['name', 'Segment'], ['type', 'Typ'], ['mb', 'MB', 'num']], rows, (r, i) => (i < 3 ? 'top' : '')));
        } catch (e) { details.innerHTML = ''; details.append(el('p', 'error', e.message)); }
      }
    });
    b.append(bar, nums, toggle, details);
  }

  // --- Dziennik zdarzeń systemowych -----------------------------------------------------------------
  async eventLog() {
    const b = this.shell('Dziennik zdarzeń systemowych', 'wide');
    const bar = el('div', 'b-bar');
    const q = el('input'); q.type = 'search'; q.placeholder = 'Komunikat, moduł, rodzaj';
    const count = el('span', 'muted');
    const list = el('div', 'tool-list');
    let rows = [];
    const load = async () => {
      count.textContent = 'wczytywanie…';
      try { rows = await this.api('tools/eventlog?q=' + encodeURIComponent(q.value.trim())); } catch (e) { count.textContent = ''; list.innerHTML = ''; list.append(el('p', 'error pad', e.message)); return; }
      list.innerHTML = '';
      list.append(table([['created', 'Data i godzina'], ['type', 'Rodzaj'], ['module', 'Moduł'], ['message', 'Komunikat'], ['id', 'Id', 'num']], rows,
        r => (/err|błąd|blad/i.test(r.type || '') ? 'err' : '')));
      count.textContent = `${rows.length}` + (rows.length >= 2000 ? ' (najnowsze 2000)' : '');
    };
    let t;
    q.addEventListener('input', () => { clearTimeout(t); t = setTimeout(load, 300); });
    bar.append(q, button('Odśwież', 'secondary small', load),
      excelButton(() => downloadXlsx('dziennik_zdarzen', 'Dziennik zdarzeń', ['Data i godzina', 'Rodzaj', 'Moduł', 'Komunikat', 'Id'],
        rows.map(r => [r.created, r.type, r.module, r.message, r.id]))),
      el('span', 'spacer'), count);
    b.append(bar, list);
    q.focus();
    await load();
  }

  // --- Oczekujące zadania (odświeżanie co 5 minut, jak RefreshTimer) ---------------------------------
  async waitingTasks() {
    const b = this.shell('Oczekujące zadania', 'wide');
    const bar = el('div', 'b-bar');
    const info = el('span', 'muted');
    const list = el('div', 'tool-list');
    const load = async () => {
      let rows;
      try { rows = await this.api('tools/tasks'); } catch (e) { list.innerHTML = ''; list.append(el('p', 'error pad', e.message)); return; }
      list.innerHTML = '';
      list.append(rows.length
        ? table([['id', 'Id', 'num'], ['code', 'Kod'], ['description', 'Opis'], ['period', 'Okres'], ['status', 'Status'], ['priority', 'Priorytet', 'num'], ['created', 'Utworzono'], ['createdBy', 'Utworzył']], rows)
        : el('p', 'muted pad', 'Brak oczekujących zadań.'));
      info.textContent = `Zadań: ${rows.length} · odświeżono ${new Date().toLocaleTimeString('pl-PL')}`;
    };
    bar.append(button('Odśwież', 'secondary small', load), el('span', 'spacer'), info);
    b.append(bar, list);
    await load();
    this.timer = setInterval(() => { if (this.dialog.open) load(); }, 300000);
  }

  // --- Lista obecności (FDatesSelector + attendance_list) ------------------------------------------
  attendance() {
    const b = this.shell('Lista obecności', 'small');
    const form = el('form', 'tool-form');
    const from = el('input'); from.type = 'date';
    const to = el('input'); to.type = 'date';
    const y = new Date(); y.setDate(y.getDate() - 1);
    from.value = isoDay(y);   // jak w Delphi: od wczoraj
    to.value = '3000-01-01';  // do 01.01.3000
    const row = (label, ctrl) => { const l = el('label', 'b-field'); l.append(el('span', '', label), ctrl); return l; };
    const msg = el('p', 'muted');
    const ok = el('button', 'primary', 'OK'); ok.type = 'submit';
    form.append(row('Data od', from), row('Data do', to), msg);
    const actions = el('div', 'b-actions');
    actions.append(ok, button('Anuluj', 'secondary', () => this.dialog.close()));
    form.append(actions);
    form.addEventListener('submit', async e => {
      e.preventDefault();
      ok.disabled = true; msg.className = 'muted'; msg.textContent = 'Przygotowywanie listy obecności…';
      // karta otwierana od razu (przed odpowiedzią serwera), żeby przeglądarka nie zablokowała okna
      const w = window.open('', '_blank');
      try {
        const r = await this.api('tools/attendance', { from: from.value, to: to.value });
        const html = r.html || '<p>Brak danych.</p>';
        const url = URL.createObjectURL(new Blob([/<meta[^>]+charset/i.test(html) ? html : '<meta charset="utf-8">' + html], { type: 'text/html;charset=utf-8' }));
        if (w) w.location = url; else window.open(url, '_blank');
        setTimeout(() => URL.revokeObjectURL(url), 120000);
        this.dialog.close();
      } catch (err) {
        if (w) w.close();
        msg.className = 'error'; msg.textContent = err.message;
      } finally { ok.disabled = false; }
    });
    b.append(form);
    from.focus();
  }
}
