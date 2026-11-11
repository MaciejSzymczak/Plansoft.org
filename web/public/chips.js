// Pole wyboru wielu wartości jak w Outlooku (adresaci): wpisywanie z podpowiedziami,
// usuwanie krzyżykiem lub klawiszem Backspace, zmiana kolejności przeciąganiem myszą.

export class ChipField {
  // el: <div class="chips" data-type data-label>; search(q) -> Promise<[{id, name, org}]>
  // single: tylko jedna wartość (wybór nowej zastępuje poprzednią)
  // listOnSecondClick: pierwsze kliknięcie tylko wybiera pole (rozkład w siatce), lista podpowiedzi pojawia się
  // po kliknięciu pola już wybranego, po wpisaniu tekstu albo strzałce w dół
  // onPick(item): kliknięcie w nazwę (pojedyncze - podwójne przesuwa listę); setPicked(id) - nazwa zaznaczona
  constructor(el, { search, onChange, onActivate, onPick, single, listOnSecondClick }) {
    this.onPick = onPick || null;
    this.pickedId = null;
    this.el = el;
    this.listOnSecondClick = !!listOnSecondClick;
    this.showOnFocus = false;
    this.type = el.dataset.type;
    this.search = search;
    this.single = !!single;
    this.onChange = onChange || (() => {});
    this.onActivate = onActivate || (() => {});
    this.items = [];
    this.options = [];
    this.highlight = -1;
    this.dragIndex = -1;
    this.requestNo = 0;

    el.innerHTML = '';
    this.labelEl = document.createElement('span');
    this.labelEl.className = 'chips-label';
    this.labelEl.textContent = el.dataset.label;
    this.box = document.createElement('div');
    this.box.className = 'chips-box';
    this.input = document.createElement('input');
    this.input.type = 'text';
    this.input.autocomplete = 'off';
    this.input.setAttribute('aria-label', el.dataset.label);
    this.input.placeholder = 'Wpisz, aby wyszukać…';
    this.list = document.createElement('div');
    this.list.className = 'chips-dropdown';
    this.list.setAttribute('role', 'listbox');
    this.list.hidden = true;
    this.box.append(this.input);
    el.append(this.labelEl, this.box, this.list);

    el.addEventListener('mousedown', e => {
      // kliknięcie w pole (poza krzyżykiem i listą) = pokaż rozkład tego typu
      if (e.target.closest('.chip-x') || e.target.closest('.chips-dropdown')) return;
      const show = !this.listOnSecondClick || el.classList.contains('active');
      this.onActivate(this);
      if (e.target.closest('.chip')) return;
      if (document.activeElement === this.input) { if (show && this.list.hidden) this.refresh(); }
      else this.showOnFocus = show;
      if (e.target === this.input) return;
      if (!e.target.closest('.chip')) { e.preventDefault(); this.input.focus(); }
    });
    this.input.addEventListener('focus', () => {
      this.onActivate(this);
      if (!this.listOnSecondClick || this.showOnFocus) this.refresh();
      this.showOnFocus = false;
    });
    this.input.addEventListener('blur', () => setTimeout(() => this.close(), 150));
    this.input.addEventListener('input', () => {
      clearTimeout(this.timer);
      this.timer = setTimeout(() => this.refresh(), 250);
    });
    this.input.addEventListener('keydown', e => this.onKey(e));
  }

  // przycisk "Rotuj" (CONLECTURER_valueDblClick w Delphi): lista przesuwa się o jedną pozycję -
  // pierwszy na koniec (LROR), np. kolejny wykładowca staje się pierwszym
  rotate() {
    if (this.single || this.items.length < 2) return;
    this.close();
    this.items.push(this.items.shift());
    this.render();
    const last = this.box.querySelectorAll('.chip')[this.items.length - 1];
    if (last) last.classList.add('rotated');
    this.onChange(this);
  }

  setItems(items) {
    this.items = items.slice();
    this.render();
  }

  // --- chipsy ------------------------------------------------------------------------------
  render() {
    this.box.querySelectorAll('.chip').forEach(c => c.remove());
    this.items.forEach((it, i) => {
      const chip = document.createElement('span');
      chip.className = 'chip' + (this.pickedId !== null && String(it.id) === String(this.pickedId) ? ' picked' : '');
      chip.dataset.id = it.id;
      chip.draggable = true;
      // kliknięcie w nazwę: zaznacz obiekt
      if (this.onPick) chip.addEventListener('click', e => {
        if (e.target.closest('.chip-x') || e.detail > 1) return;
        this.onPick(it);
      });
      chip.title = it.org ? `${it.name} (${it.org})` : it.name;
      const name = document.createElement('span');
      name.className = 'chip-name';
      name.textContent = it.name;
      const x = document.createElement('button');
      x.type = 'button';
      x.className = 'chip-x';
      x.title = 'Usuń';
      x.setAttribute('aria-label', `Usuń ${it.name}`);
      x.textContent = '×';
      x.addEventListener('click', e => { e.stopPropagation(); this.remove(i); });
      chip.append(name, x);

      chip.addEventListener('dragstart', e => {
        this.dragIndex = i;
        chip.classList.add('dragging');
        e.dataTransfer.effectAllowed = 'move';
        e.dataTransfer.setData('text/plain', it.name);
      });
      chip.addEventListener('dragend', () => {
        this.dragIndex = -1;
        this.box.querySelectorAll('.chip').forEach(c => c.classList.remove('dragging', 'drop-before', 'drop-after'));
      });
      chip.addEventListener('dragover', e => {
        if (this.dragIndex < 0) return;
        e.preventDefault();
        const after = this.isAfter(e, chip);
        chip.classList.toggle('drop-before', !after);
        chip.classList.toggle('drop-after', after);
      });
      chip.addEventListener('dragleave', () => chip.classList.remove('drop-before', 'drop-after'));
      chip.addEventListener('drop', e => {
        if (this.dragIndex < 0) return;
        e.preventDefault();
        let to = this.isAfter(e, chip) ? i + 1 : i;
        const from = this.dragIndex;
        if (from < to) to--;
        if (from !== to) {
          const [moved] = this.items.splice(from, 1);
          this.items.splice(to, 0, moved);
          this.render();
          this.onChange(this);
        }
      });
      this.box.insertBefore(chip, this.input);
    });
    this.el.classList.toggle('has-items', this.items.length > 0);
    this.input.placeholder = this.items.length ? '' : 'Wpisz, aby wyszukać…';
  }

  setPicked(id) {
    this.pickedId = id === undefined ? null : id;
    this.box.querySelectorAll('.chip').forEach(c => c.classList.toggle('picked', this.pickedId !== null && c.dataset.id === String(this.pickedId)));
  }

  isAfter(e, chip) {
    const r = chip.getBoundingClientRect();
    return e.clientX > r.left + r.width / 2;
  }

  add(item) {
    if (!this.items.some(i => i.id === item.id)) {
      if (this.single) this.items = [];
      this.items.push(item);
      this.render();
      this.onChange(this);
    }
    this.input.value = '';
    this.refresh();
  }

  remove(index) {
    this.items.splice(index, 1);
    this.render();
    this.onChange(this);
    this.input.focus();
  }

  // --- podpowiedzi -------------------------------------------------------------------------
  async refresh() {
    const no = ++this.requestNo;
    let rows;
    try { rows = await this.search(this.type, this.input.value.trim()); } catch { return; }
    if (no !== this.requestNo || document.activeElement !== this.input) return;
    this.options = rows.filter(r => !this.items.some(i => i.id === r.id));
    this.highlight = this.options.length ? 0 : -1;
    this.renderList();
  }

  renderList() {
    this.list.innerHTML = '';
    if (!this.options.length) {
      const empty = document.createElement('div');
      empty.className = 'chips-empty';
      empty.textContent = this.input.value.trim() ? 'Brak wyników' : 'Brak dostępnych pozycji';
      this.list.append(empty);
    }
    this.options.forEach((o, i) => {
      const row = document.createElement('div');
      row.className = 'chips-option' + (i === this.highlight ? ' active' : '');
      row.setAttribute('role', 'option');
      const n = document.createElement('span');
      n.textContent = o.name;
      row.append(n);
      if (o.org) {
        const org = document.createElement('span');
        org.className = 'muted';
        org.textContent = o.org;
        row.append(org);
      }
      row.addEventListener('mousedown', e => { e.preventDefault(); this.add(o); });
      row.addEventListener('mousemove', () => { if (this.highlight !== i) { this.highlight = i; this.paintHighlight(); } });
      this.list.append(row);
    });
    this.list.hidden = false;
  }

  paintHighlight() {
    [...this.list.querySelectorAll('.chips-option')].forEach((r, i) => r.classList.toggle('active', i === this.highlight));
    const active = this.list.querySelector('.chips-option.active');
    if (active) active.scrollIntoView({ block: 'nearest' });
  }

  close() {
    this.list.hidden = true;
    this.requestNo++;
  }

  onKey(e) {
    if (e.key === 'ArrowDown' || e.key === 'ArrowUp') {
      if (this.list.hidden) { this.refresh(); return; }
      e.preventDefault();
      const n = this.options.length;
      if (!n) return;
      this.highlight = (this.highlight + (e.key === 'ArrowDown' ? 1 : -1) + n) % n;
      this.paintHighlight();
    } else if (e.key === 'Enter') {
      e.preventDefault();
      if (!this.list.hidden && this.options[this.highlight]) this.add(this.options[this.highlight]);
    } else if (e.key === 'Escape') {
      this.close();
    } else if (e.key === 'Backspace' && !this.input.value && this.items.length) {
      this.remove(this.items.length - 1);
    }
  }
}
