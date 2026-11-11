// Dni wolne okresu - zamiast kalendarza rezerwacji Delphi (zakładka kalendarza, InvertReservations, PPCopyDays):
// kalendarz całego okresu (miesiącami); kliknięcie dnia oznacza cały dzień jako wolny albo usuwa oznaczenie,
// Shift+kliknięcie - zakres dni; pojedyncze godziny - terminy zaznaczone w siatce. Symbol i "Zajęcia dozwolone"
// jak w Delphi (CLASSES_ALLOWED '-' = w tym terminie nie można planować zajęć).

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
const DAY = 864e5;
const toT = s => Date.parse(s + 'T00:00:00Z');
const iso = t => new Date(t).toISOString().slice(0, 10);
const MONTHS = ['styczeń', 'luty', 'marzec', 'kwiecień', 'maj', 'czerwiec', 'lipiec', 'sierpień', 'wrzesień', 'październik', 'listopad', 'grudzień'];
const WD = ['pon.', 'wt.', 'śr.', 'czw.', 'pt.', 'sob.', 'niedz.'];

export class HolidaysWindow {
  // getPeriod() -> okres z okna głównego; getSelection() -> zaznaczone terminy siatki [{date, hour}]; onChanged() - siatka od nowa
  constructor({ api, getPeriod, getSelection, onChanged }) {
    this.api = api;
    this.getPeriod = getPeriod;
    this.getSelection = getSelection;
    this.onChanged = onChanged;
    this.dialog = el('dialog', 'holidays');
    document.body.append(this.dialog);
    this.symbol = 'HOLIDAY';
    this.allowed = true;
  }

  async open() {
    this.period = this.getPeriod();
    if (!this.period) return;
    this.build();
    this.dialog.showModal();
    await this.load();
  }

  build() {
    const d = this.dialog, p = this.period;
    d.innerHTML = '';
    const head = el('div', 'b-head');
    head.append(el('h2', '', `Dni wolne: ${p.name}`), el('span', 'spacer'), button('×', 'link close', () => d.close(), 'Zamknij (Esc)'));
    const bar = el('div', 'hol-bar');
    const symL = el('label', 'b-field hol-sym'); symL.append(el('span', '', 'Symbol'));
    this.symInput = el('input'); this.symInput.maxLength = 15; this.symInput.value = this.symbol; this.symInput.title = 'Symbol wyświetlany w siatce (np. HOLIDAY, Rektorskie, Sesja)';
    this.symInput.addEventListener('input', () => { this.symbol = this.symInput.value; });
    symL.append(this.symInput);
    const alL = el('label', 'check hol-allowed');
    this.alInput = el('input'); this.alInput.type = 'checkbox'; this.alInput.checked = this.allowed;
    this.alInput.addEventListener('change', () => { this.allowed = this.alInput.checked; });
    alL.append(this.alInput, ' Zajęcia dozwolone');
    alL.title = 'Zaznaczone: termin jest tylko oznaczony. Niezaznaczone: w tym terminie nie można planować zajęć.';
    const legend = el('span', 'hol-legend');
    legend.append(el('span', 'hol-sw hol-no'), ' zajęcia niedozwolone ', el('span', 'hol-sw hol-ok'), ' zajęcia dozwolone ', el('span', 'hol-sw hol-part'), ' część godzin');
    bar.append(symL, alL, el('span', 'spacer'), legend);

    const tools = el('div', 'hol-tools');
    this.bSelSet = button('Zaznaczone w siatce terminy: oznacz', 'secondary small', () => this.applyCells(this.getSelection(), false), 'Oznacz jako wolne terminy (godziny) zaznaczone w siatce okna głównego');
    this.bSelDel = button('…: usuń oznaczenie', 'secondary small', () => this.applyCells(this.getSelection(), true), 'Usuń oznaczenie terminów zaznaczonych w siatce');
    this.bClear = button('Usuń wszystkie dni wolne z okresu', 'secondary small danger', () => this.clearAll());
    this.copySel = el('select', 'hol-copy'); this.copySel.title = 'Skopiuj dni wolne z innego okresu (dodaj do istniejących)';
    this.copySel.append(new Option('Skopiuj dni z innego okresu…', ''));
    this.copySel.addEventListener('change', () => { const v = this.copySel.value; this.copySel.value = ''; if (v) this.copyFrom(v); });
    tools.append(this.bSelSet, this.bSelDel, el('span', 'spacer'), this.copySel, this.bClear);

    this.info = el('p', 'muted hol-info', 'Kliknij dzień, aby oznaczyć cały dzień jako wolny albo usunąć oznaczenie. Shift+kliknięcie - zakres dni.');
    this.msg = el('p', 'error'); this.msg.hidden = true;
    const body = el('div', 'hol-body');
    this.cal = el('div', 'hol-cal');
    this.list = el('div', 'hol-list');
    body.append(this.cal, this.list);
    d.append(head, bar, tools, this.info, this.msg, body);
    this.fillPeriods();
  }

  async fillPeriods() {
    let rows = [];
    try { rows = await this.api('periods?q='); } catch { return; }
    for (const r of rows) if (r.id !== this.period.id) this.copySel.append(new Option(`${r.name} (${r.dateFrom} – ${r.dateTo})`, r.id));
  }

  error(text) { this.msg.textContent = text || ''; this.msg.hidden = !text; }

  async load() {
    let r;
    try { r = await this.api(`holidays?period=${this.period.id}`); } catch (e) { return this.error(e.message); }
    this.items = r.items;
    this.canEdit = r.canEdit;
    for (const b of [this.bSelSet, this.bSelDel, this.bClear, this.copySel, this.symInput, this.alInput]) b.disabled = !r.canEdit;
    if (!r.canEdit) this.info.textContent = r.reason + ' - kalendarz tylko do odczytu.';
    this.render();
  }

  byDay() {
    const m = new Map();
    for (const it of this.items) { if (!m.has(it.date)) m.set(it.date, []); m.get(it.date).push(it); }
    return m;
  }

  render() {
    const p = this.period, map = this.byDay();
    const hours = p.hoursPerDay;
    const from = toT(p.dateFrom), to = toT(p.dateTo);
    this.cal.innerHTML = '';
    const start = new Date(from);
    for (let k = 0; Date.UTC(start.getUTCFullYear(), start.getUTCMonth() + k, 1) <= to; k++) {
      const ms = new Date(Date.UTC(start.getUTCFullYear(), start.getUTCMonth() + k, 1));
      const y = ms.getUTCFullYear(), mo = ms.getUTCMonth();
      const box = el('div', 'hol-month');
      box.append(el('div', 'hol-mname', `${MONTHS[mo]} ${y}`));
      const g = el('div', 'hol-days');
      WD.forEach(w => g.append(el('span', 'hol-wd', w)));
      const first = Date.UTC(y, mo, 1), lead = (new Date(first).getUTCDay() + 6) % 7;
      for (let i = 0; i < lead; i++) g.append(el('span', 'hol-empty'));
      for (let t = first; new Date(t).getUTCMonth() === mo; t += DAY) {
        const date = iso(t), list = map.get(date) || [];
        const inside = t >= from && t <= to;
        const b = el('button', 'hol-day', String(new Date(t).getUTCDate()));
        b.type = 'button';
        if (!inside) { b.disabled = true; b.classList.add('outside'); }
        if (list.length) {
          const blocked = list.some(x => !x.allowed);
          b.classList.add(list.length >= hours ? (blocked ? 'hol-no' : 'hol-ok') : 'hol-part');
          b.title = `${date}: ${list.length >= hours ? 'cały dzień' : 'godz. ' + list.map(x => x.hour).join(', ')} - ${[...new Set(list.map(x => x.type))].join(', ')}`
            + (blocked ? ' (zajęcia niedozwolone)' : ' (zajęcia dozwolone)');
        } else if (inside) b.title = `${date} - kliknij, aby oznaczyć jako dzień wolny`;
        b.dataset.date = date;
        b.addEventListener('click', e => this.dayClick(date, e.shiftKey));
        g.append(b);
      }
      box.append(g);
      this.cal.append(box);
    }
    // lista: dni wolne po kolei
    this.list.innerHTML = '';
    this.list.append(el('h3', '', `Dni wolne (${map.size})`));
    if (!map.size) this.list.append(el('p', 'muted', 'Brak dni wolnych w tym okresie.'));
    for (const [date, list] of map) {
      const row = el('div', 'hol-row');
      const wd = WD[(new Date(toT(date)).getUTCDay() + 6) % 7];
      const blocked = list.some(x => !x.allowed);
      row.append(el('span', 'hol-sw ' + (blocked ? 'hol-no' : 'hol-ok')),
        el('b', '', `${date} ${wd}`),
        el('span', '', list.length >= hours ? 'cały dzień' : 'godz. ' + list.map(x => x.hour).join(', ')),
        el('span', 'muted', [...new Set(list.map(x => x.type))].join(', ') + (blocked ? ' · zajęcia niedozwolone' : '')));
      if (this.canEdit) row.append(button('Usuń', 'link', () => this.applyDays([date], true)));
      this.list.append(row);
    }
  }

  dayClick(date, range) {
    if (!this.canEdit) return;
    const map = this.byDay();
    let days = [date];
    if (range && this.lastDay) {
      const a = Math.min(toT(this.lastDay), toT(date)), b = Math.max(toT(this.lastDay), toT(date));
      days = [];
      for (let t = a; t <= b; t += DAY) days.push(iso(t));
    }
    // dzień już oznaczony - usunięcie oznaczenia; inaczej oznaczenie (zakres: wg klikniętego dnia)
    const remove = map.has(date);
    this.lastDay = date;
    this.applyDays(days, remove);
  }

  applyDays(days, remove) {
    const cells = [];
    for (const d of days) for (let h = 1; h <= this.period.hoursPerDay; h++) cells.push({ date: d, hour: h });
    return this.applyCells(cells, remove);
  }

  async applyCells(cells, remove) {
    this.error('');
    if (!cells || !cells.length) return this.error('Zaznacz terminy w siatce okna głównego.');
    try {
      await this.api('holidays/set', { period: this.period.id, cells, remove, type: this.symbol, allowed: this.allowed });
    } catch (e) { return this.error(e.message); }
    await this.load();
    this.onChanged();
  }

  async clearAll() {
    if (!confirm(`Usunąć wszystkie dni wolne z okresu ${this.period.name}?`)) return;
    try { await this.api('holidays/clear', { period: this.period.id }); } catch (e) { return this.error(e.message); }
    await this.load();
    this.onChanged();
  }

  async copyFrom(from) {
    try { await this.api('holidays/copy', { period: this.period.id, from: Number(from), deleteExisting: false }); } catch (e) { return this.error(e.message); }
    await this.load();
    this.onChanged();
  }
}
