// Dodawanie zajęcia do zaznaczonych terminów: okno szczegółów (jak FDetails w Delphi, zakładki Zajęcia i Rezerwacja)
// i okno konfliktów (jak FShowConflicts: nowe zajęcie, kolidujące zajęcia, "Kontynuuj - usuń istniejące zajęcia").
import { ChipField } from './chips.js';

function el(tag, cls, text) {
  const e = document.createElement(tag);
  if (cls) e.className = cls;
  if (text !== undefined && text !== null) e.textContent = text;
  return e;
}
function button(text, cls, onClick) {
  const b = el('button', cls, text);
  b.type = 'button';
  b.addEventListener('click', onClick);
  return b;
}
function chips(type, label) {
  const d = el('div', 'chips');
  d.dataset.type = type;
  d.dataset.label = label;
  return d;
}

const REASONS = { L: 'wykładowca', G: 'grupa', S: 'zasób' };
const prefKey = user => 'plansoft.web.addclass.' + user;
function loadPrefs(user) { try { return JSON.parse(localStorage.getItem(prefKey(user))) || {}; } catch { return {}; } }
function savePrefs(user, p) { try { localStorage.setItem(prefKey(user), JSON.stringify(p)); } catch { /* brak pamięci przeglądarki */ } }

export class AddClassDialog {
  constructor({ api, onAdded }) {
    this.api = api;
    this.onAdded = onAdded;
    this.dialog = el('dialog', 'addclass');
    this.conflictsDialog = el('dialog', 'conflicts');
    document.body.append(this.dialog, this.conflictsDialog);
  }

  // ctx: { period, cells: [{date, hour}], hours: [{no, label}], prefill: {L, G, S}, settings, user }
  open(ctx) {
    this.ctx = ctx;
    const prefs = loadPrefs(ctx.user);
    const d = this.dialog;
    d.innerHTML = '';
    const search = (type, q) => this.api(`objects/${type}?q=${encodeURIComponent(q)}${type === 'FOR' ? '&kind=' + this.kind : ''}`);

    const head = el('div', 'b-head');
    head.append(el('h2', '', 'Dodaj zajęcie'), el('span', 'spacer'), button('×', 'link close', () => d.close()));
    const info = el('p', 'muted ac-info', this.cellsText());

    const tabs = el('div', 'tabs ac-tabs');
    this.kind = 'C';
    const tabC = button('Zajęcia', 'tab active', () => this.setKind('C'));
    const tabR = button('Rezerwacja', 'tab', () => this.setKind('R'));
    tabs.append(tabC, tabR);
    this.tabs = { C: tabC, R: tabR };

    const form = el('form', 'ac-form');
    form.noValidate = true;
    // rezerwacja dla: wykładowców / grup / sal (jak rgReservationFor)
    this.forRow = el('div', 'ac-for');
    this.forRow.append(el('span', 'muted', 'Rezerwacja dla:'));
    for (const [v, label] of [['L', 'Wykładowcy'], ['G', 'Grupy'], ['S', 'Sale']]) {
      const l = el('label', 'check'); const r = el('input'); r.type = 'radio'; r.name = 'resFor'; r.value = v; r.checked = v === 'L';
      r.addEventListener('change', () => this.updateKind());
      l.append(r, ' ' + label); this.forRow.append(l);
    }
    const elL = chips('L', 'Wykładowcy'), elG = chips('G', 'Grupy'), elS = chips('S', 'Sale');
    const elSub = chips('SUB', 'Przedmiot *'), elFor = chips('FOR', 'Forma zajęć *');
    this.fields = {
      L: new ChipField(elL, { search }), G: new ChipField(elG, { search }), S: new ChipField(elS, { search }),
      SUB: new ChipField(elSub, { search, single: true }), FOR: new ChipField(elFor, { search, single: true }),
    };
    for (const t of 'LGS') this.fields[t].setItems(ctx.prefill[t] || []);
    // domyślny przedmiot i forma z okna głównego, a gdy ich nie ma - ostatnio użyte
    const sub = ctx.sub || prefs.sub, frm = ctx.form || prefs.form;
    if (sub) this.fields.SUB.setItems([sub]);
    if (frm) this.fields.FOR.setItems([frm]);
    this.chipEls = { L: elL, G: elG, S: elS, SUB: elSub, FOR: elFor };

    const row = el('div', 'ac-row');
    const fillL = el('label', 'b-field'); fillL.append(el('span', '', 'Wypełnienie [%] *'));
    this.fill = el('input'); this.fill.type = 'number'; this.fill.min = 1; this.fill.max = 100; this.fill.value = prefs.fill || 100;
    this.fill.title = 'Jaka część godziny jest zajęta (100 = cała)';
    fillL.append(this.fill);
    const colL = el('label', 'b-field'); colL.append(el('span', '', 'Kolor (status)'));
    const colBox = el('div', 'ac-colour');
    this.colour = el('input'); this.colour.type = 'color'; this.colour.value = '#ffffff';
    const noCol = el('label', 'check'); this.noColour = el('input'); this.noColour.type = 'checkbox'; this.noColour.checked = true;
    noCol.append(this.noColour, ' brak');
    this.colour.addEventListener('input', () => { this.noColour.checked = false; });
    colBox.append(this.colour, noCol);
    colL.append(colBox);
    const ownL = el('label', 'b-field'); ownL.append(el('span', '', 'Właściciel'));
    this.owner = el('input'); this.owner.value = ctx.user; this.owner.title = 'Planista, do którego należą zajęcia (kilku: oddziel średnikiem)';
    ownL.append(this.owner);
    const crL = el('label', 'b-field'); crL.append(el('span', '', 'Utworzył'));
    const cr = el('input'); cr.value = ctx.user; cr.disabled = true; crL.append(cr);
    row.append(fillL, colL, ownL, crL);

    // opisy zajęcia - tylko te, które mają nazwę w ustawieniach (CLASS_DESC1..4)
    this.descs = [];
    const descBox = el('div', 'ac-row');
    ctx.settings.descPlural.forEach((name, i) => {
      if (!name) { this.descs.push(null); return; }
      const l = el('label', 'b-field'); l.append(el('span', '', name));
      const t = el('input'); l.append(t); descBox.append(l); this.descs.push(t);
    });

    this.error = el('p', 'error ac-error'); this.error.hidden = true;
    this.warning = el('p', 'ac-warning'); this.warning.hidden = true;
    const actions = el('div', 'b-actions');
    this.ok = el('button', 'primary', 'OK'); this.ok.type = 'submit';
    actions.append(this.ok, button('Anuluj', 'secondary', () => d.close()));
    form.append(this.forRow, elL, elG, elS, elSub, elFor, row, descBox, this.error, this.warning, actions);
    form.addEventListener('submit', e => { e.preventDefault(); this.submit(false); });

    d.append(head, info, tabs, form);
    this.updateKind();
    d.showModal();
    (this.fields.SUB.items.length ? this.fill : this.fields.SUB.input).focus();
  }

  cellsText() {
    const c = this.ctx.cells, h = n => (this.ctx.hours.find(x => x.no === n) || {}).label || n;
    if (c.length === 1) return `Termin: ${c[0].date}, godz. ${h(c[0].hour)}`;
    return `Terminy: ${c.length} (od ${c[0].date} godz. ${h(c[0].hour)} do ${c[c.length - 1].date} godz. ${h(c[c.length - 1].hour)})`;
  }

  setKind(k) {
    if (this.kind === k) return;
    this.kind = k;
    this.fields.FOR.setItems(k === 'C' ? (loadPrefs(this.ctx.user).form ? [loadPrefs(this.ctx.user).form] : []) : []);
    this.updateKind();
  }

  updateKind() {
    const r = this.kind === 'R';
    this.tabs.C.classList.toggle('active', !r);
    this.tabs.R.classList.toggle('active', r);
    this.forRow.hidden = !r;
    this.chipEls.SUB.hidden = r;
    this.chipEls.FOR.querySelector('.chips-label').textContent = r ? 'Rezerwacja *' : 'Forma zajęć *';
    const resFor = r ? this.forRow.querySelector('input:checked').value : null;
    for (const t of 'LGS') this.chipEls[t].hidden = r && t !== resFor;
  }

  payload(confirm) {
    const r = this.kind === 'R';
    const resFor = r ? this.forRow.querySelector('input:checked').value : null;
    const pick = t => (!r || t === resFor ? this.fields[t].items.map(i => i.id) : []);
    return {
      period: this.ctx.period, cells: this.ctx.cells, kind: this.kind,
      lec: pick('L'), gro: pick('G'), rom: pick('S'),
      sub: r ? null : (this.fields.SUB.items[0] || {}).id, form: (this.fields.FOR.items[0] || {}).id,
      fill: Number(this.fill.value), colour: this.noColour.checked ? null : this.colour.value,
      owner: this.owner.value.trim(), desc: this.descs.map(t => (t ? t.value.trim() : null)), confirm,
    };
  }

  showError(text) { this.error.textContent = text; this.error.hidden = !text; }

  async submit(confirm) {
    const p = this.payload(confirm);
    this.showError('');
    // sprawdzenie jak w FDetails przed wysłaniem (serwer sprawdza ponownie)
    if (p.kind === 'C' && !p.sub) return this.showError('Przedmiot musi zostać wybrany.');
    if (!p.form) return this.showError(p.kind === 'C' ? 'Forma zajęć musi zostać wybrana.' : 'Rezerwacja musi zostać wybrana.');
    if (!(p.fill >= 1 && p.fill <= 100)) return this.showError('Wypełnienie musi być liczbą od 1 do 100.');
    if (!p.lec.length && !p.gro.length && !p.rom.length) return this.showError('Wybierz wykładowcę, grupę lub salę.');
    this.ok.disabled = true;
    try {
      const r = await this.api('classes/add', p);
      if (r.status === 'conflicts') { this.showConflicts(r); return; }
      if (p.kind === 'C') savePrefs(this.ctx.user, { sub: this.fields.SUB.items[0], form: this.fields.FOR.items[0], fill: p.fill });
      this.conflictsDialog.close();
      this.dialog.close();
      this.onAdded(r);
    } catch (e) {
      if (this.conflictsDialog.open) this.conflictsDialog.close();
      this.showError(e.message);
    } finally { this.ok.disabled = false; }
  }

  // --- okno konfliktów (FShowConflicts) ---------------------------------------------------------
  showConflicts(r) {
    const names = t => this.fields[t].items.map(i => i.name).join(', ');
    const p = this.payload(false);
    openConflicts(this.conflictsDialog, {
      newTitle: 'Nowe zajęcie',
      newRows: [[this.cellsText().replace(/^Terminy?: /, ''), '',
        p.lec.length ? names('L') : '', p.gro.length ? names('G') : '', p.rom.length ? names('S') : '',
        p.sub ? names('SUB') : '', names('FOR'), p.owner]],
      conflicts: r.conflicts, canDelete: r.canDelete, warning: r.warning,
      onContinue: () => this.submit(true),
    });
  }
}

// okno konfliktów: nowe (lub przesuwane) zajęcia, kolidujące zajęcia z zaznaczeniem przyczyny,
// "Kontynuuj - usuń istniejące zajęcia" / "Anuluj"
export function openConflicts(d, { newTitle, newRows, conflicts, canDelete, warning, onContinue }) {
  d.innerHTML = '';
  const head = el('div', 'b-head');
  head.append(el('h2', '', 'Konflikty'), el('span', 'spacer'), button('×', 'link close', () => d.close()));
  const cols = ['Data', 'Godz.', 'Wykładowcy', 'Grupy', 'Zasoby', 'Przedmiot', 'Forma', 'Właściciel'];
  const table = (rows, extra) => {
    const t = el('table', 'ac-table');
    const tr = el('tr'); [...cols, ...(extra ? ['Przyczyna'] : [])].forEach(c => tr.append(el('th', '', c)));
    const thead = el('thead'); thead.append(tr); t.append(thead);
    const tb = el('tbody');
    rows.forEach(row => { const x = el('tr'); row.forEach(c => x.append(c instanceof Node ? c : el('td', '', c))); tb.append(x); });
    t.append(tb);
    return t;
  };
  const td = (text, mark) => el('td', mark ? 'mark' : '', text);
  const confRows = conflicts.map(c => [
    td(c.day), td(c.hourCaption || String(c.hour)),
    td(c.lecturers, c.reason.includes('L')), td(c.groups, c.reason.includes('G')), td(c.rooms, c.reason.includes('S')),
    td(c.subject), td(c.form), td(c.owner, !c.canDelete),
    td(c.reason.split('').map(x => REASONS[x]).join(', ')),
  ]);
  const body = el('div', 'ac-conf-body');
  body.append(el('h3', '', newTitle), table(newRows, false),
    el('h3', '', `Istniejące zajęcia w tych terminach (${conflicts.length})`), table(confRows, true));
  if (!canDelete) body.append(el('p', 'error', 'Nie możesz usunąć kolidujących zajęć, ponieważ nie jesteś ich właścicielem (lub nie masz uprawnienia do usuwania zajęć).'));
  if (warning) body.append(el('p', 'ac-warning', warning));
  const actions = el('div', 'b-actions');
  const go = button('Kontynuuj - usuń istniejące zajęcia', 'primary danger', () => { d.close(); onContinue(); });
  go.disabled = !canDelete;
  actions.append(go, button('Anuluj', 'secondary', () => d.close()));
  d.append(head, body, actions);
  if (!d.isConnected) document.body.append(d);
  d.showModal();
  (canDelete ? go : actions.lastChild).focus();
}
