// Okno "Zajęcie" - wygląd komórki siatki, jak FCellLayout w programie Delphi (UFCellLayout.pas):
// kolorowanie, opisy w siatce (linie D1-D5), ukrywanie takich samych opisów, rozmiary i czcionka.

export const DEFAULT_LAYOUT = {
  colour: 'S',
  lines: ['SF', 'G', 'NONE', 'NONE', 'NONE'],
  hideSame: false,
  forceWidth: false, width: 78,
  forceHeight: false, height: 22,
  fontSize: 11,
  multi: 'together',   // wiele wybranych obiektów: together | vertical | horizontal | first
};

export const MULTI_OPTIONS = [
  ['together', 'Wszystkie na jednym arkuszu'],
  ['vertical', 'Pokazuj w pionie'],
  ['horizontal', 'Pokazuj w poziomie'],
  ['first', 'Pokazuj tylko pierwszy'],
];

// listy wyboru jak synchronizeComboboxColor / synchronizeComboboxDesc w UFMain.pas;
// kategorie zasobów i nazwane opisy zajęć pochodzą z bazy (settings)
export function colourOptions(settings) {
  return [
    ['L', 'Wykładowcy'], ['G', 'Grupy'], ['S', 'Przedmiot'], ['F', 'Forma'],
    ['OWNER', 'Właściciel'], ['CREATED_BY', 'Utworzył'], ['CLASS', 'Zajęcie'],
    ...settings.resourceCategories.map(c => [String(c.id), c.name]),
    ...descOptions(settings),
    ['ALL_RES', 'Zasoby - wszystkie'], ['NONE', 'Brak'],
  ];
}

export function lineOptions(settings) {
  return [
    ['L', 'Wykładowca Skrót'], ['L+', 'Wykładowca Nazwa'], ['G', 'Grupa'],
    ...settings.resourceCategories.map(c => [String(c.id), c.name]),
    ['S', 'Przedmiot'], ['F', 'Forma'], ['SF', 'Przedmiot+Forma Skrót'], ['SF+', 'Przedmiot+Forma Nazwa'],
    ['CREATED_BY', 'Utworzył'], ['OWNER', 'Właściciel'], ['ALL_RES', 'Zasoby - wszystkie'], ['NONE', 'Brak'],
    ...descOptions(settings),
  ];
}

const descOptions = settings => settings.descPlural.map((n, i) => (n ? ['DESC' + (i + 1), n] : null)).filter(Boolean);

const ids = list => String(list || '').split(';').map(s => s.trim()).filter(Boolean);
const parts = list => String(list || '').split(';').map(s => s.trim());

// zasoby danej kategorii (getResourcesByType w UCommon.pas): calc_rescat_ids i calc_rooms/calc_rom_ids idą parami
function byCategory(cat, catIds, values) {
  const c = parts(catIds), v = parts(values);
  return c.map((id, i) => (id === cat ? v[i] : null)).filter(Boolean);
}

const RED = '#ff0000', SILVER = '#c0c0c0';

// kolory komórki: kilka kolorów = pionowe pasy (np. kilka grup)
export function cellColours(c, code, maps) {
  const fromMap = (list, map) => ids(list).map(id => (map[id] || {}).colour).filter(Boolean);
  switch (code) {
    case 'NONE': return [];
    case 'L': return fromMap(c.lecIds, maps.lecturers);
    case 'G': return fromMap(c.groIds, maps.groups);
    case 'ALL_RES': return fromMap(c.romIds, maps.rooms);
    case 'S': case 'F': case 'OWNER': case 'CREATED_BY': case 'CLASS': return [c.colours[code]].filter(Boolean);
    case 'DESC1': case 'DESC2': case 'DESC3': case 'DESC4': return [c.desc[+code.slice(4) - 1] ? RED : SILVER];
    default: return byCategory(code, c.rescatIds, c.romIds).map(id => (maps.rooms[id] || {}).colour).filter(Boolean);
  }
}

export function lineText(c, code, maps) {
  switch (code) {
    case 'NONE': return '';
    case 'L': return c.lecturers;
    case 'L+': return ids(c.lecIds).map(id => (maps.lecturers[id] || {}).name || '').filter(Boolean).join(';');
    case 'G': return c.groups;
    case 'S': return c.sub;
    case 'F': return c.form;
    case 'SF': return `${c.sub}(${c.form})`;
    case 'SF+': return `${c.subName}(${c.form})`;
    case 'OWNER': return c.owner;
    case 'CREATED_BY': return c.createdBy;
    case 'ALL_RES': return c.rooms.trim();
    case 'DESC1': case 'DESC2': case 'DESC3': case 'DESC4': return c.desc[+code.slice(4) - 1];
    default: return byCategory(code, c.rescatIds, c.rooms).join(';');
  }
}

function el(tag, cls, text) {
  const e = document.createElement(tag);
  if (cls) e.className = cls;
  if (text !== undefined) e.textContent = text;
  return e;
}

function select(options, value, onChange) {
  const s = el('select');
  for (const [v, label] of options) s.append(new Option(label, v));
  s.value = options.some(o => o[0] === value) ? value : 'NONE';
  s.addEventListener('change', () => onChange(s.value));
  return s;
}

// okienko pod przyciskiem; zmiany od razu odświeżają siatkę (onChange)
export class CellLayoutPanel {
  constructor(button, panel, { getLayout, getSettings, onChange }) {
    Object.assign(this, { button, panel, getLayout, getSettings, onChange });
    button.addEventListener('click', () => (panel.hidden ? this.open() : this.close()));
    document.addEventListener('mousedown', e => {
      if (!panel.hidden && !panel.contains(e.target) && !button.contains(e.target)) this.close();
    });
    panel.addEventListener('keydown', e => { if (e.key === 'Escape') { this.close(); button.focus(); } });
  }

  open() { this.build(); this.panel.hidden = false; this.button.setAttribute('aria-expanded', 'true'); this.panel.querySelector('select').focus(); }
  close() { this.panel.hidden = true; this.button.setAttribute('aria-expanded', 'false'); }

  set(changes) { this.onChange({ ...this.getLayout(), ...changes }); }

  build() {
    const L = this.getLayout(), settings = this.getSettings(), p = this.panel;
    p.innerHTML = '';

    const colour = el('fieldset'); colour.append(el('legend', '', 'Kolorowanie'));
    colour.append(select(colourOptions(settings), L.colour, v => this.set({ colour: v })));

    const desc = el('fieldset'); desc.append(el('legend', '', 'Opisy w siatce'));
    L.lines.forEach((code, i) => {
      const row = el('label', 'line'); row.append(el('span', 'muted', `${i + 1}.`));
      row.append(select(lineOptions(settings), code, v => { const lines = [...this.getLayout().lines]; lines[i] = v; this.set({ lines }); }));
      desc.append(row);
    });
    const same = el('label', 'check'); const cb = el('input'); cb.type = 'checkbox'; cb.checked = L.hideSame;
    cb.addEventListener('change', () => this.set({ hideSame: cb.checked }));
    same.append(cb, ' Ukryj takie same opisy'); same.title = 'Nie powtarzaj opisu, gdy w poprzednim tygodniu o tej godzinie jest taki sam';
    desc.append(same);

    const multi = el('fieldset'); multi.append(el('legend', '', 'Wiele obiektów'));
    const ms = select(MULTI_OPTIONS, L.multi || 'together', v => this.set({ multi: v }));
    ms.title = 'Jak pokazać rozkład, gdy wybrano kilku wykładowców, kilka grup lub sal';
    multi.append(ms);

    const size = el('fieldset'); size.append(el('legend', '', 'Rozmiary'));
    const slider = (label, flag, key, min, max) => {
      const row = el('div', 'size');
      const c = el('input'); c.type = 'checkbox'; c.checked = L[flag];
      const r = el('input'); r.type = 'range'; r.min = min; r.max = max; r.value = L[key]; r.disabled = !L[flag];
      const v = el('span', 'muted', `${L[key]} px`);
      c.addEventListener('change', () => { r.disabled = !c.checked; this.set({ [flag]: c.checked }); });
      r.addEventListener('input', () => { v.textContent = `${r.value} px`; this.set({ [key]: Number(r.value) }); });
      const lb = el('label', 'check'); lb.append(c, ' ' + label);
      row.append(lb, r, v);
      return row;
    };
    size.append(slider('Chcę ustalić szerokość', 'forceWidth', 'width', 5, 200));
    size.append(slider('Chcę ustalić wysokość', 'forceHeight', 'height', 5, 100));
    const font = el('label', 'line'); font.append(el('span', '', 'Czcionka'));
    font.append(select([8, 9, 10, 11, 12, 13, 14, 16].map(n => [String(n), `${n} px`]), String(L.fontSize), v => this.set({ fontSize: Number(v) })));
    size.append(font);
    const reset = el('button', 'secondary small', 'Przywróć'); reset.type = 'button';
    reset.title = 'Przywróć domyślny wygląd komórki';
    reset.addEventListener('click', () => { this.onChange({ ...DEFAULT_LAYOUT, lines: [...DEFAULT_LAYOUT.lines] }); this.build(); });
    size.append(reset);

    p.append(colour, desc, multi, size);
  }
}
