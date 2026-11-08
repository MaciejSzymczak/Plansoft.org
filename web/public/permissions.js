// Okno "Uprawnienia do obiektów" (UFPlannerPermissions w Delphi): zakładki obiektów, w kolumnach planiści
// (użytkownicy i role), w wierszach obiekty; komórka E (edycja, zielona) / R (odczyt, niebieska) / pusta.
// Edycja / Odczyt / Usuń - dla zaznaczonego prostokąta; podwójne kliknięcie, Spacja, Enter, Insert, Delete -
// zmiana cykliczna: brak -> E -> R -> brak (InvertSelection). Każda zmiana zapisywana od razu.
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

const TABS = [['LEC', 'Wykładowcy'], ['GRO', 'Grupy'], ['ROM', 'Zasoby'], ['SUB', 'Przedmioty'], ['FOR', 'Formy zajęć'], ['ROL', 'Autoryzacje'], ['PER', 'Okresy']];
const NEXT = { '': 'E', E: 'R', R: '' };

export class PermissionsWindow {
  constructor({ api }) {
    this.api = api;
    this.dialog = el('dialog', 'perm');
    document.body.append(this.dialog);
    this.tab = 'LEC';
    this.data = null;
    this.dragging = false;
    document.addEventListener('mouseup', () => { this.dragging = false; });
  }

  async open() {
    if (!this.orgs) { try { this.orgs = await this.api('lookup/ORG'); } catch { this.orgs = []; } }
    this.build();
    this.dialog.showModal();
    this.rowSearch.focus();
  }

  build() {
    const d = this.dialog;
    d.innerHTML = '';
    const head = el('div', 'b-head');
    head.append(el('h2', '', 'Uprawnienia do obiektów'), el('span', 'spacer'), button('×', 'link close', () => d.close(), 'Zamknij (Esc)'));

    // "Znajdź": planista, zasób, jednostka (+ podrzędne), użytkownicy / role, Odśwież
    const find = el('div', 'b-bar perm-find');
    const input = (ph, title) => { const i = el('input'); i.type = 'search'; i.placeholder = ph; i.title = title; i.addEventListener('keydown', e => { if (e.key === 'Enter') this.refresh(); }); return i; };
    this.plannerSearch = input('Szukaj planisty', 'Fragment nazwy planisty lub roli');
    this.rowSearch = input('Szukaj zasobu', 'Dowolna fraza (kilka fraz oddziel przecinkiem)');
    this.org = el('select');
    this.org.append(new Option('Jednostka: wszystkie', ''), ...this.orgs.map(o => new Option(o.name, o.code)));
    const check = (label, checked) => { const l = el('label', 'check'); const c = el('input'); c.type = 'checkbox'; c.checked = checked; l.append(c, ' ' + label); return [l, c]; };
    const [childsL, childs] = check('i jednostki podrzędne', false);
    const [usersL, users] = check('Użytkownicy', true);
    const [rolesL, roles] = check('Role', true);
    Object.assign(this, { childs, users, roles });
    find.append(this.plannerSearch, this.rowSearch, this.org, childsL, usersL, rolesL, button('Odśwież', 'primary small', () => this.refresh()));

    const tabs = el('div', 'tabs perm-tabs');
    this.tabButtons = {};
    for (const [code, label] of TABS) {
      const b = button(label, 'tab' + (code === this.tab ? ' active' : ''), () => this.setTab(code));
      this.tabButtons[code] = b;
      tabs.append(b);
    }

    const tools = el('div', 'b-tools');
    this.msg = el('span', 'muted');
    tools.append(
      button('Edycja', 'secondary small perm-e', () => this.setSelection('E'), 'Edycja (ACCESS_TYPE = E) dla zaznaczonych komórek'),
      button('Odczyt', 'secondary small perm-r', () => this.setSelection('R'), 'Odczyt (ACCESS_TYPE = R) dla zaznaczonych komórek'),
      button('Usuń', 'secondary small danger', () => this.setSelection(''), 'Usuń uprawnienia zaznaczonych komórek'),
      excelButton(() => this.exportExcel()),
      button('Transfer uprawnień', 'secondary small', () => this.openTransfer(), 'Kopiowanie uprawnień i zmiana właściciela zajęć (wymaga EDIT_SHARING)'),
      button('Historia zmian uprawnień', 'secondary small', () => this.openHistory(), 'Kto, komu i kiedy nadał lub odebrał uprawnienia (wymaga EDIT_SHARING)'),
      el('span', 'spacer'), this.msg,
    );
    this.wrap = el('div', 'perm-wrap');
    this.wrap.tabIndex = 0;
    this.wrap.addEventListener('keydown', e => this.onKey(e));
    this.wrap.append(el('p', 'muted pad', 'Wpisz w polach powyżej czego szukasz i naciśnij Odśwież.'));
    d.append(head, find, tabs, tools, this.wrap);
  }

  setTab(code) {
    this.tab = code;
    for (const [c, b] of Object.entries(this.tabButtons)) b.classList.toggle('active', c === code);
    if (this.data) this.refresh();
  }

  async refresh() {
    const q = new URLSearchParams({
      tab: this.tab, planner: this.plannerSearch.value.trim(), q: this.rowSearch.value.trim(),
      users: this.users.checked ? '1' : '0', roles: this.roles.checked ? '1' : '0',
      org: this.org.value, childs: this.childs.checked ? '1' : '0',
    });
    this.msg.textContent = 'wczytywanie…';
    try { this.data = await this.api('permissions?' + q); } catch (e) { this.msg.textContent = e.message; return; }
    this.sel = null;
    this.render();
  }

  render() {
    const { planners, rows, cells, truncated } = this.data;
    this.wrap.innerHTML = '';
    this.msg.textContent = `${rows.length} ${this.tabLabel()} × ${planners.length} planistów` + (truncated ? ' (pokazano pierwsze 3000 - zawęź wyszukiwanie)' : '');
    if (!rows.length || !planners.length) { this.wrap.append(el('p', 'muted pad', !planners.length ? 'Brak planistów spełniających warunki.' : 'Brak obiektów spełniających warunki.')); return; }
    const t = el('table', 'perm-grid');
    const hr = el('tr');
    hr.append(el('th', 'corner', ''));
    planners.forEach((p, c) => {
      const th = el('th', 'pla' + (p.type === 'ROLE' ? ' role' : ''));
      th.append(el('span', '', p.name.split('\\').pop()));
      th.title = `${p.name} (${p.type === 'ROLE' ? 'rola' : 'użytkownik'}) - kliknij, aby skopiować nazwę`;
      th.dataset.c = c;
      hr.append(th);
    });
    const thead = el('thead'); thead.append(hr); t.append(thead);
    const tb = el('tbody');
    this.tds = [];
    rows.forEach((r, ri) => {
      const tr = el('tr');
      const th = el('th', 'obj', r.name);
      th.title = `${r.name} - kliknij, aby skopiować nazwę`;
      th.dataset.r = ri;
      tr.append(th);
      const line = [];
      planners.forEach((p, ci) => {
        const v = cells[`${r.id}:${p.id}`] || '';
        const td = el('td', v ? 'v' + v : '', v);
        td.dataset.r = ri; td.dataset.c = ci;
        tr.append(td); line.push(td);
      });
      this.tds.push(line);
      tb.append(tr);
    });
    t.append(tb);
    this.wrap.append(t);
    this.enableSelection(t);
  }

  tabLabel() { return (TABS.find(x => x[0] === this.tab) || [])[1].toLowerCase(); }

  // zaznaczanie prostokąta myszą (Shift - rozszerzenie), jak w TStringGrid
  enableSelection(t) {
    let anchor = null;
    const cellOf = e => { const td = e.target.closest('td'); return td ? { r: +td.dataset.r, c: +td.dataset.c } : null; };
    t.addEventListener('mousedown', e => {
      if (e.button !== 0) return;
      const h = e.target.closest('th.pla, th.obj');
      if (h) { this.copyName(h); return; }
      const x = cellOf(e);
      if (!x) return;
      e.preventDefault();
      this.wrap.focus({ preventScroll: true });
      if (!(e.shiftKey && anchor)) anchor = x;
      this.dragging = true;
      this.select(anchor, x);
    });
    t.addEventListener('mouseover', e => { if (this.dragging) { const x = cellOf(e); if (x) this.select(anchor, x); } });
    t.addEventListener('dblclick', e => { if (cellOf(e)) this.invert(); });
  }

  select(a, b) {
    this.sel = { r0: Math.min(a.r, b.r), r1: Math.max(a.r, b.r), c0: Math.min(a.c, b.c), c1: Math.max(a.c, b.c) };
    this.wrap.querySelectorAll('td.sel, th.hl').forEach(x => x.classList.remove('sel', 'hl'));
    for (let r = this.sel.r0; r <= this.sel.r1; r++) for (let c = this.sel.c0; c <= this.sel.c1; c++) this.tds[r][c].classList.add('sel');
    // podświetlenie nagłówków zaznaczonych wierszy i kolumn (HighLight)
    this.wrap.querySelectorAll('th.obj').forEach(th => th.classList.toggle('hl', +th.dataset.r >= this.sel.r0 && +th.dataset.r <= this.sel.r1));
    this.wrap.querySelectorAll('th.pla').forEach(th => th.classList.toggle('hl', +th.dataset.c >= this.sel.c0 && +th.dataset.c <= this.sel.c1));
  }

  onKey(e) {
    if (!this.sel) return;
    if ([' ', 'Enter', 'Insert', 'Delete'].includes(e.key)) { e.preventDefault(); this.invert(); return; }
    const move = { ArrowUp: [-1, 0], ArrowDown: [1, 0], ArrowLeft: [0, -1], ArrowRight: [0, 1] }[e.key];
    if (move) {
      e.preventDefault();
      const r = Math.max(0, Math.min(this.tds.length - 1, this.sel.r0 + move[0]));
      const c = Math.max(0, Math.min(this.tds[0].length - 1, this.sel.c0 + move[1]));
      this.select({ r, c }, { r, c });
      this.tds[r][c].scrollIntoView({ block: 'nearest', inline: 'nearest' });
    }
  }

  async copyName(th) {
    const text = th.title.replace(/ - kliknij.*$/, '').replace(/ \((rola|użytkownik)\)$/, '');
    try { await navigator.clipboard.writeText(text); this.msg.textContent = `Skopiowano do schowka: ${text}`; } catch { this.msg.textContent = text; }
  }

  // nowa wartość komórek zaznaczenia: stała (Edycja/Odczyt/Usuń) albo cykliczna (InvertSelection)
  invert() { this.apply(v => NEXT[v]); }
  setSelection(v) {
    if (!this.sel) { this.msg.textContent = 'Zaznacz komórki w siatce.'; return; }
    this.apply(() => v);
  }

  async apply(fn) {
    if (!this.sel || !this.data) return;
    const { planners, rows } = this.data;
    const changes = [];
    for (let r = this.sel.r0; r <= this.sel.r1; r++) for (let c = this.sel.c0; c <= this.sel.c1; c++) {
      const td = this.tds[r][c];
      const v = fn(td.textContent);
      changes.push({ td, row: rows[r].id, pla: planners[c].id, old: td.textContent, access: v || null });
    }
    // od razu w siatce; przy błędzie zapisu - przywrócenie
    const paint = (td, v) => { td.textContent = v; td.className = (v ? 'v' + v : '') + ' sel'; };
    changes.forEach(x => paint(x.td, x.access || ''));
    this.msg.textContent = `Zapisywanie (${changes.length})…`;
    try {
      await this.api('permissions', { tab: this.tab, cells: changes.map(x => ({ row: x.row, pla: x.pla, access: x.access })) });
      changes.forEach(x => { this.data.cells[`${x.row}:${x.pla}`] = x.access || undefined; });
      this.msg.textContent = `Zapisano: ${changes.length} ${changes.length === 1 ? 'komórka' : 'komórek'}`;
    } catch (e) {
      changes.forEach(x => paint(x.td, x.old));
      this.msg.textContent = e.message;
    }
  }

  // --- okno pomocnicze nad oknem uprawnień ---------------------------------------------------------
  subDialog(title, cls) {
    if (!this.sub) { this.sub = el('dialog', 'perm-sub'); document.body.append(this.sub); }
    const d = this.sub;
    d.className = 'perm-sub ' + (cls || '');
    d.innerHTML = '';
    const head = el('div', 'b-head');
    head.append(el('h2', '', title), el('span', 'spacer'), button('×', 'link close', () => d.close(), 'Zamknij (Esc)'));
    const body = el('div', 'tool-body');
    d.append(head, body);
    d.showModal();
    return body;
  }

  // Transfer uprawnień i danych (TFTransfer): od planisty/autoryzacji do innego, wybrane rodzaje uprawnień
  async openTransfer() {
    let planners;
    try { planners = await this.api('permissions/planners'); } catch (e) { this.msg.textContent = e.message; return; }
    const b = this.subDialog('Transfer uprawnień i danych', 'small');
    const pick = label => {
      const sel = el('select');
      sel.append(new Option('(wybierz)', ''), ...planners.map(p => new Option(`${p.name}${p.type === 'ROLE' ? ' (rola)' : ''}`, p.id)));
      const l = el('label', 'b-field'); l.append(el('span', '', label), sel); b.append(l);
      return sel;
    };
    const from = pick('Od planisty lub autoryzacji');
    const to = pick('Do planisty lub autoryzacji');
    const box = el('fieldset', 'perm-transfer'); box.append(el('legend', '', 'Transfer uprawnień'));
    const checks = {};
    for (const [k, label] of [['lec', 'Wykładowcy'], ['gro', 'Grupy'], ['rom', 'Zasoby'], ['sub', 'Przedmioty'], ['for', 'Formy zajęć'], ['rol', 'Role'], ['per', 'Okresy']]) {
      const l = el('label', 'check'); const c = el('input'); c.type = 'checkbox'; c.checked = true; l.append(c, ' ' + label); box.append(l); checks[k] = c;
    }
    const cl = el('label', 'check'); const classes = el('input'); classes.type = 'checkbox'; cl.append(classes, ' Zmiana właściciela zajęć');
    const msg = el('p', 'muted');
    const actions = el('div', 'b-actions');
    // "Czy na pewno wykonać transfer?" - drugie kliknięcie potwierdza
    const go = button('Wykonaj', 'primary', async () => {
      if (!go.dataset.confirm) { go.dataset.confirm = '1'; go.textContent = 'Czy na pewno wykonać transfer? Kliknij ponownie'; return; }
      go.disabled = true; msg.className = 'muted'; msg.textContent = 'Wykonywanie…';
      try {
        await this.api('permissions/transfer', {
          from: Number(from.value), to: Number(to.value), classes: classes.checked,
          ...Object.fromEntries(Object.entries(checks).map(([k, c]) => [k, c.checked])),
        });
        msg.textContent = 'Zrobione. Odśwież okno, żeby zobaczyć zmiany.';
        if (this.data) this.refresh();
      } catch (e) { msg.className = 'error'; msg.textContent = e.message; }
      go.disabled = false; delete go.dataset.confirm; go.textContent = 'Wykonaj';
    });
    actions.append(go, button('Anuluj', 'secondary', () => this.sub.close()));
    b.append(box, cl, msg, actions);
  }

  // Historia zmian uprawnień (TFBrowseRES_PLA_HISTORY)
  openHistory() {
    const b = this.subDialog('Historia zmian uprawnień', 'wide');
    const bar = el('div', 'b-bar');
    const inp = (ph, title) => { const i = el('input'); i.type = 'search'; i.placeholder = ph; i.title = title; return i; };
    const q = inp('Zasób', 'Kilka fraz oddziel przecinkiem, np. Kowalski, Nowak');
    const pla = inp('Komu zmieniono', 'Planista lub rola, której nadano / odebrano uprawnienie');
    const by = inp('Kto zmienił', 'Użytkownik bazy, który zmienił uprawnienie');
    const count = el('span', 'muted');
    const note = el('p', 'muted'); note.hidden = true;
    const list = el('div', 'tool-list');
    let rows = [];
    const cols = [['changed', 'Data zmiany'], ['operation', 'Operacja'], ['type', 'Typ zasobu'], ['res', 'Zasób'], ['pla', 'Komu'], ['by', 'Zmienił'], ['osUser', 'Użytkownik systemu'], ['module', 'Program']];
    const load = async () => {
      count.textContent = 'wczytywanie…';
      const p = new URLSearchParams({ q: q.value, pla: pla.value, by: by.value });
      let r;
      try { r = await this.api('permissions/history?' + p); } catch (e) { count.textContent = ''; list.innerHTML = ''; list.append(el('p', 'error pad', e.message)); return; }
      rows = r.rows;
      note.hidden = r.tracking;
      note.textContent = 'Śledzenie historii zmian uprawnień jest wyłączone (parametr RES_PLA_HISTORY). Można je włączyć w oknie Ustawienia konfiguracyjne programu Delphi.';
      list.innerHTML = '';
      const t = el('table', 'tool-grid');
      const hr = el('tr'); cols.forEach(([, l]) => hr.append(el('th', '', l)));
      const th = el('thead'); th.append(hr); t.append(th);
      const tb = el('tbody');
      rows.forEach(x => { const tr = el('tr'); cols.forEach(([k]) => tr.append(el('td', '', x[k] ?? ''))); tb.append(tr); });
      t.append(tb); list.append(t);
      count.textContent = `${rows.length}` + (rows.length >= 3000 ? ' (najnowsze 3000)' : '');
    };
    let timer;
    [q, pla, by].forEach(i => i.addEventListener('input', () => { clearTimeout(timer); timer = setTimeout(load, 400); }));
    bar.append(q, pla, by, button('Odśwież', 'secondary small', load),
      excelButton(() => downloadXlsx('historia_uprawnien', 'Historia zmian uprawnień', cols.map(c => c[1]), rows.map(x => cols.map(([k]) => x[k])))),
      el('span', 'spacer'), count);
    b.append(note, bar, list);
    load();
  }

  exportExcel() {
    if (!this.data) return;
    const { planners, rows, cells } = this.data;
    downloadXlsx(`uprawnienia_${this.tabLabel()}`, `Uprawnienia - ${this.tabLabel()}`,
      ['Obiekt', ...planners.map(p => p.name)], rows.map(r => [r.name, ...planners.map(p => cells[`${r.id}:${p.id}`] || '')]));
  }
}
