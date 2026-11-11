// Legenda: zakładki "Znajdź wykładowcę", "Znajdź grupę", "Znajdź salę" (TabSheetL/G/R w UFLegend.pas):
// obiekty z procentem wolnych terminów spośród zaznaczonych w siatce (Wolne [%]), najpierw najbardziej dostępne;
// "pokaż: wszystkie / dostępne" (FindMode), fraza; kliknięcie obiektu - Rozkład / Szczegóły (FActionTree w Delphi).
import { openPopup } from './toolWindow.js';

function el(tag, cls, text) {
  const e = document.createElement(tag);
  if (cls) e.className = cls;
  if (text !== undefined && text !== null) e.textContent = text;
  return e;
}
const EXTRA = { L: 'Skrót', G: 'Nazwa', S: 'Opis' };
const NAME = { L: 'Wykładowca', G: 'Grupa', S: 'Sala' };

export class FindPanel {
  // getCells() -> zaznaczone terminy [{date, hour}]; onShow(type, item) - rozkład; onDetails(type, item) - okno słownika
  constructor(root, { api, getCells, onShow, onDetails }) {
    Object.assign(this, { root, api, getCells, onShow, onDetails });
    this.type = 'L';
    this.req = 0;
    root.innerHTML = '';
    const bar = el('div', 'bar');
    this.filter = el('input'); this.filter.type = 'search'; this.filter.placeholder = 'Dowolna fraza (kilka fraz oddziel przecinkiem)';
    let t;
    this.filter.addEventListener('input', () => { clearTimeout(t); t = setTimeout(() => this.refresh(), 300); });
    this.mode = el('select');
    this.mode.append(new Option('pokaż: wszystkie', ''), new Option('pokaż: dostępne', 'free'));
    this.mode.title = 'Dostępne - tylko obiekty wolne we wszystkich zaznaczonych terminach';
    this.mode.addEventListener('change', () => this.refresh());
    bar.append(this.filter, this.mode);
    this.info = el('p', 'muted find-info');
    this.tableWrap = el('div', 'table-wrap');
    root.append(bar, this.info, this.tableWrap);
  }

  setType(type) { this.type = type; this.refresh(); }

  async refresh() {
    const req = ++this.req;
    const cells = this.getCells();
    let r;
    try {
      r = await this.api('find', { type: this.type, cells, q: this.filter.value.trim(), onlyFree: this.mode.value === 'free' });
    } catch (e) { if (req === this.req) this.info.textContent = e.message; return; }
    if (req !== this.req) return;
    this.info.textContent = cells.length
      ? `Zaznaczonych terminów: ${r.total}. Wolne [%] - część tych terminów, w których obiekt nie ma zajęć.`
      : 'Zaznacz terminy w siatce, aby zobaczyć, kto jest wtedy wolny.';
    const t = el('table', 'summary-table find-table');
    const tr = el('tr');
    ['Wolne [%]', NAME[this.type], EXTRA[this.type], 'Jedn.'].forEach(h => tr.append(el('th', '', h)));
    const thead = el('thead'); thead.append(tr); t.append(thead);
    const tb = el('tbody');
    for (const o of r.rows) {
      const x = el('tr', 'find-row');
      const pct = el('td', 'num find-pct');
      const bar = el('span', 'find-bar'); bar.style.width = o.free + '%';
      bar.style.background = o.free === 100 ? '#3fb950' : o.free >= 50 ? '#d29922' : '#f85149';
      pct.append(bar, el('span', 'find-num', String(o.free)));
      pct.title = r.total ? `wolny w ${r.total - o.busy} z ${r.total} zaznaczonych terminów` : '';
      x.append(pct, el('td', '', o.name), el('td', 'muted', o.extra), el('td', 'muted', o.org));
      x.tabIndex = 0;
      const pick = () => openPopup([
        { label: 'Rozkład', onClick: () => this.onShow(this.type, o) },
        { label: 'Szczegóły', onClick: () => this.onDetails(this.type, o) },
      ], x);
      x.addEventListener('click', pick);
      x.addEventListener('keydown', e => { if (e.key === 'Enter') pick(); });
      tb.append(x);
    }
    t.append(tb);
    this.tableWrap.innerHTML = '';
    if (!r.rows.length) this.tableWrap.append(el('p', 'muted pad', 'Brak obiektów.'));
    else this.tableWrap.append(t);
  }
}
