// Organizator listy wykładowców / grup / sal (jak FListOrganizer w Delphi, przyciski rorL/rorG/rorR):
// kolejność, ukrywanie, wybór kolejnych, "Zależne" (nadrzędne i podrzędne), zapis i odczyt zestawu z pliku.
// Plik: jeden identyfikator w wierszu - ten sam format co w programie Delphi.
import { ChipField } from './chips.js';

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

const TITLES = { L: 'Wykładowcy', G: 'Grupy', S: 'Sale' };
const FILE_NAMES = { L: 'wykladowcy.txt', G: 'grupy.txt', S: 'sale.txt' };

export class ListOrganizer {
  constructor({ api, onDetails }) {
    this.api = api;
    this.onDetails = onDetails;
    this.dialog = el('dialog', 'listorg');
    document.body.append(this.dialog);
  }

  // items: [{id, name, org}]; onOk(items) - nowa lista
  open(type, items, onOk) {
    this.type = type;
    this.items = items.map(i => ({ ...i }));
    this.current = this.items.length ? 0 : -1;
    this.onOk = onOk;
    const d = this.dialog;
    d.innerHTML = '';
    const head = el('div', 'b-head');
    head.append(el('h2', '', `Organizer: ${TITLES[type]}`), el('span', 'spacer'), button('×', 'link close', () => d.close(), 'Anuluj'));

    // "Wybierz kolejny": pole z podpowiedziami, wybrana pozycja dopisywana na koniec listy
    const addBox = el('div', 'chips small lo-add');
    addBox.dataset.type = type;
    addBox.dataset.label = 'Wybierz kolejny';
    this.adder = new ChipField(addBox, {
      search: (t, q) => this.api(`objects/${t}?q=${encodeURIComponent(q)}`),
      single: true,
      onChange: f => {
        const it = f.items[0];
        if (!it) return;
        if (!this.items.some(x => x.id === it.id)) this.items.push(it);
        this.current = this.items.findIndex(x => x.id === it.id);
        f.setItems([]);
        this.render();
      },
    });

    const tools = el('div', 'b-tools lo-tools');
    this.msg = el('span', 'muted');
    const fileInput = el('input');
    fileInput.type = 'file';
    fileInput.accept = '.txt,text/plain';
    fileInput.hidden = true;
    fileInput.addEventListener('change', () => { if (fileInput.files[0]) this.openFile(fileInput.files[0]); fileInput.value = ''; });
    tools.append(
      button('Wyczyść i wybierz', 'secondary small', () => { this.items = []; this.current = -1; this.render(); this.adder.input.focus(); }, 'Wyczyść listę i wybierz ponownie'),
      button('Zależne', 'secondary small', () => this.related(), 'Pokaż wszystkie nadrzędne i podrzędne'),
      button('Zapisz', 'secondary small', () => this.save(), 'Zapisz listę do pliku'),
      button('Otwórz', 'secondary small', () => fileInput.click(), 'Odczytaj listę z pliku'),
      fileInput, el('span', 'spacer'), this.msg,
    );

    this.listEl = el('div', 'lo-list');
    this.listEl.tabIndex = 0;
    this.listEl.setAttribute('role', 'listbox');
    this.listEl.addEventListener('keydown', e => this.onKey(e));

    const actions = el('div', 'b-actions lo-actions');
    actions.append(
      button('OK', 'primary', () => { d.close(); this.onOk(this.items); }),
      button('Anuluj', 'secondary', () => d.close()),
    );
    d.append(head, tools, addBox, this.listEl, actions);
    this.render();
    d.showModal();
    (this.items.length ? this.listEl : this.adder.input).focus();
  }

  render() {
    const l = this.listEl;
    l.innerHTML = '';
    if (!this.items.length) l.append(el('p', 'muted pad', 'Lista jest pusta - wybierz pozycje w polu „Wybierz kolejny” albo otwórz zapisaną listę.'));
    this.items.forEach((it, i) => {
      const row = el('div', 'lo-row' + (i === this.current ? ' current' : ''));
      row.setAttribute('role', 'option');
      const name = el('span', 'lo-name', it.name);
      if (it.org) name.append(el('span', 'muted', ' ' + it.org));
      const tools = el('span', 'lo-row-tools');
      tools.append(
        button('▲', 'link', () => this.moveItem(i, -1), 'W górę'),
        button('▼', 'link', () => this.moveItem(i, 1), 'W dół'),
        button('Rozkład', 'link', () => { this.items.unshift(...this.items.splice(i, 1)); this.current = 0; this.render(); }, 'Ustaw jako pierwszy'),
        button('Szczegóły', 'link', () => this.onDetails(this.type, it.id), 'Pokaż rekord'),
        button('Ukryj', 'link danger', () => { this.items.splice(i, 1); this.current = Math.min(i, this.items.length - 1); this.render(); }, 'Usuń z tej listy'),
      );
      row.append(el('span', 'lo-no muted', `${i + 1}.`), name, tools);
      row.addEventListener('click', e => { if (!e.target.closest('button')) { this.current = i; this.render(); } });
      l.append(row);
    });
    this.msg.textContent = `${this.items.length} poz.`;
  }

  moveItem(i, dir) {
    const j = i + dir;
    if (j < 0 || j >= this.items.length) return;
    [this.items[i], this.items[j]] = [this.items[j], this.items[i]];
    this.current = j;
    this.render();
    this.listEl.focus();
  }

  onKey(e) {
    if (this.current < 0) return;
    if (e.key === 'ArrowUp' && (e.ctrlKey || e.altKey)) { e.preventDefault(); this.moveItem(this.current, -1); }
    else if (e.key === 'ArrowDown' && (e.ctrlKey || e.altKey)) { e.preventDefault(); this.moveItem(this.current, 1); }
    else if (e.key === 'ArrowUp') { e.preventDefault(); this.current = Math.max(0, this.current - 1); this.render(); }
    else if (e.key === 'ArrowDown') { e.preventDefault(); this.current = Math.min(this.items.length - 1, this.current + 1); this.render(); }
    else if (e.key === 'Delete') { e.preventDefault(); this.items.splice(this.current, 1); this.current = Math.min(this.current, this.items.length - 1); this.render(); }
  }

  async related() {
    if (!this.items.length) return;
    try {
      const r = await this.api(`objects/${this.type}/resolve`, { ids: this.items.map(i => i.id), related: true });
      const added = r.items.length - this.items.length;
      this.items = r.items;
      this.render();
      this.msg.textContent = added > 0 ? `Dodano zależnych: ${added}` : 'Brak dodatkowych zależnych.';
    } catch (e) { this.msg.textContent = e.message; }
  }

  // zapis jak BSaveListClick: identyfikatory, jeden w wierszu
  async save() {
    if (!this.items.length) { this.msg.textContent = 'Lista jest pusta - nie ma czego zapisywać.'; return; }
    const text = this.items.map(i => i.id).join('\r\n') + '\r\n';
    if (window.showSaveFilePicker) {
      try {
        const h = await window.showSaveFilePicker({ suggestedName: FILE_NAMES[this.type], types: [{ description: 'Lista (txt)', accept: { 'text/plain': ['.txt'] } }] });
        const w = await h.createWritable();
        await w.write(text);
        await w.close();
        this.msg.textContent = `Zapisano: ${h.name}`;
        return;
      } catch (e) { if (e.name === 'AbortError') return; }
    }
    const a = el('a');
    a.href = URL.createObjectURL(new Blob([text], { type: 'text/plain' }));
    a.download = FILE_NAMES[this.type];
    document.body.append(a); a.click(); a.remove();
    setTimeout(() => URL.revokeObjectURL(a.href), 1000);
    this.msg.textContent = `Zapisano: ${a.download}`;
  }

  // odczyt jak BOpenListClick: pomija rekordy, do których planista nie ma dostępu
  async openFile(file) {
    const ids = (await file.text()).split(/\r?\n/).map(s => Number(s.trim())).filter(n => Number.isInteger(n) && n > 0);
    try {
      const r = await this.api(`objects/${this.type}/resolve`, { ids });
      this.items = r.items;
      this.current = this.items.length ? 0 : -1;
      this.render();
      const n = r.skipped;
      const rec = n === 1 ? 'rekord' : n % 10 >= 2 && n % 10 <= 4 && (n % 100 < 12 || n % 100 > 14) ? 'rekordy' : 'rekordów';
      this.msg.textContent = `Otwarto: ${file.name}` + (n ? ` - pominięto ${n} ${rec}, do których nie masz dostępu.` : '');
    } catch (e) { this.msg.textContent = e.message; }
  }
}
