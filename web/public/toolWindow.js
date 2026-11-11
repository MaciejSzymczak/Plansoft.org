// Okno narzędzi przy siatce (FToolWindow w Delphi): pływający pasek z przyciskami w tym samym układzie i z tymi samymi
// ikonami (wyciągniętymi z UFToolWindow.dfm), pojawiający się nad kursorem po zaznaczeniu kilku komórek lub prawym
// przyciskiem; prawie przezroczysty, nabiera koloru, gdy kursor się zbliża, i znika, gdy kursor się oddali (jak
// AlphaBlendValue w TFMain.GridMouseMove). Menu podręczne (EditPopup, DelPopup, FavouritePopup) i okna wyboru.
import { ChipField } from './chips.js';

const ICONS = 'icons/tool/';

function el(tag, cls, text) {
  const e = document.createElement(tag);
  if (cls) e.className = cls;
  if (text !== undefined && text !== null) e.textContent = text;
  return e;
}
function button(text, cls, onClick) {
  const b = el('button', cls, text);
  b.type = 'button';
  if (onClick) b.addEventListener('click', onClick);
  return b;
}

// --- menu podręczne (TPopupMenu): pozycje z ikoną, separatory, podmenu rozwijane po najechaniu ---------------
// items: [{ label, icon, onClick, disabled, sub: [...] } | '-']
let openMenus = [];
let menuHost = document.body;   // okno modalne, z którego otwarto menu (inaczej menu byłoby pod nim)
export function closePopup() { openMenus.forEach(m => m.remove()); openMenus = []; }
function menuEl(items, level) {
  const m = el('div', 'tw-menu');
  m.setAttribute('role', 'menu');
  const hasIcons = items.some(i => i && i.icon);
  for (const it of items) {
    if (it === '-') { m.append(el('div', 'tw-sep')); continue; }
    const b = button('', 'tw-item' + (it.sub ? ' tw-has-sub' : ''));
    b.setAttribute('role', 'menuitem');
    b.disabled = !!it.disabled;
    if (hasIcons) {
      const ic = el('span', 'tw-item-icon');
      if (it.icon) { const img = el('img'); img.src = ICONS + it.icon; img.alt = ''; ic.append(img); }
      b.append(ic);
    }
    b.append(el('span', 'tw-item-label', it.label));
    if (it.sub) b.append(el('span', 'tw-item-arrow', '▸'));
    const openSub = () => {
      openMenus.slice(level + 1).forEach(x => x.remove());
      openMenus = openMenus.slice(0, level + 1);
      m.querySelectorAll('.tw-item.open').forEach(x => x.classList.remove('open'));
      if (!it.sub || it.disabled) return;
      b.classList.add('open');
      const r = b.getBoundingClientRect();
      const sub = menuEl(it.sub, level + 1);
      place(sub, r.right - 3, r.top - 3, r.left + 3);
    };
    b.addEventListener('mouseenter', openSub);
    b.addEventListener('click', e => {
      e.stopPropagation();
      if (it.sub) { openSub(); const f = openMenus[level + 1] && openMenus[level + 1].querySelector('.tw-item:not(:disabled)'); if (f) f.focus(); return; }
      closePopup();
      it.onClick();
    });
    m.append(b);
  }
  m.addEventListener('keydown', e => {
    const list = [...m.querySelectorAll('.tw-item:not(:disabled)')];
    const i = list.indexOf(document.activeElement);
    if (e.key === 'ArrowDown') { e.preventDefault(); (list[i + 1] || list[0]).focus(); }
    else if (e.key === 'ArrowUp') { e.preventDefault(); (list[i - 1] || list[list.length - 1]).focus(); }
    else if (e.key === 'ArrowRight' && document.activeElement.classList.contains('tw-has-sub')) { e.preventDefault(); document.activeElement.click(); }
    else if (e.key === 'ArrowLeft' && level > 0) { e.preventDefault(); openMenus.slice(level).forEach(x => x.remove()); openMenus = openMenus.slice(0, level); const o = openMenus[level - 1].querySelector('.tw-item.open'); if (o) o.focus(); }
    else if (e.key === 'Escape') { e.preventDefault(); e.stopPropagation(); closePopup(); }   // tylko menu, okno narzędzi zostaje
  });
  openMenus.push(m);
  return m;
}
// x, y - lewy górny róg; altX - prawa krawędź, gdy menu nie mieści się z prawej strony
function place(m, x, y, altX) {
  m.style.visibility = 'hidden';
  menuHost.append(m);
  const w = m.offsetWidth, h = m.offsetHeight;
  let left = x;
  if (left + w > window.innerWidth - 4) left = altX !== undefined ? altX - w : window.innerWidth - w - 4;
  m.style.left = Math.max(4, left) + 'px';
  m.style.top = Math.max(4, Math.min(y, window.innerHeight - h - 4)) + 'px';
  m.style.visibility = '';
}
// menu pod przyciskiem (bdelpopupClick: Popup(btn.ClientToScreen(0, btn.Height)))
export function openPopup(items, anchor) {
  closePopup();
  menuHost = anchor.closest('dialog[open]') || document.body;
  const r = anchor.getBoundingClientRect();
  const m = menuEl(items, 0);
  place(m, r.left, r.bottom);
  const first = m.querySelector('.tw-item:not(:disabled)');
  if (first) first.focus();
}
document.addEventListener('mousedown', e => { if (openMenus.length && !openMenus.some(m => m.contains(e.target))) closePopup(); }, true);
window.addEventListener('blur', closePopup);

// --- okno narzędzi ---------------------------------------------------------------------------------------
// układ i rozmiary z UFToolWindow.dfm (ClientWidth 445, ClientHeight 49)
const SHAPES = [[0, 0, 443, 49, 'tw-frame'], [2, 2, 159, 45], [163, 2, 164, 45], [329, 2, 65, 45]];
export const TOOL_BUTTONS = [
  // id, x, y, w, h, ikona, podpowiedź
  ['addClass', 4, 5, 39, 39, 'AddClass.png', 'Dodaj zajęcia/ rezerwacje'],
  ['editClass', 43, 5, 39, 39, 'EditClass.png', 'Edytuj zajęcia/ rezerwacje'],
  ['editPopup', 83, 5, 15, 39, 'beditpopup.png', 'Edytuj - więcej poleceń'],
  ['deleteClass', 99, 5, 39, 39, 'BDeleteClass.png', 'Usuń zajęcia/ rezerwacje'],
  ['delPopup', 138, 5, 15, 39, 'bdelpopup.png', 'Usuń - więcej poleceń'],
  ['copyArea', 167, 5, 40, 39, 'bcopyarea.png', 'Kopiuj obszar'],
  ['cutArea', 207, 5, 39, 39, 'bcutarea.png', 'Wytnij obszar'],
  ['pasteArea', 246, 5, 39, 39, 'bpastearea.png', 'Wklej obszar'],
  ['clearSelection', 285, 5, 39, 39, 'bclearselection.png', 'Usuń zaznaczenie obszaru'],
  ['moveUp', 353, 6, 19, 17, 'moveUp.png', 'Przesuń zaznaczony obszar w górę'],
  ['moveLeft', 334, 23, 19, 17, 'moveLeft.png', 'Przesuń zaznaczony obszar w lewo'],
  ['moveDown', 353, 23, 19, 17, 'moveDown.png', 'Przesuń zaznaczony obszar w dół'],
  ['moveRight', 371, 23, 19, 17, 'moveRight.png', 'Przesuń zaznaczony obszar w prawo'],
  ['favPopup', 400, 5, 39, 39, 'bfavpopup.png', 'Zaznacz termin jako preferowany / nie preferowany'],
];

export class ToolWindow {
  // actions: { id: (button) => void }; enabled: () => { id: bool }
  constructor({ actions, enabled }) {
    this.actions = actions;
    this.enabled = enabled;
    this.el = el('div', 'tool-window');
    this.el.hidden = true;
    this.el.setAttribute('role', 'toolbar');
    this.el.setAttribute('aria-label', 'Okno narzędzi');
    for (const [x, y, w, h, cls] of SHAPES) {
      const s = el('div', cls || 'tw-shape');
      Object.assign(s.style, { left: x + 'px', top: y + 'px', width: w + 'px', height: h + 'px' });
      this.el.append(s);
    }
    this.buttons = {};
    for (const [id, x, y, w, h, icon, hint] of TOOL_BUTTONS) {
      const b = button('', 'tw-btn' + (w < 20 ? ' tw-small' : ''));
      Object.assign(b.style, { left: x + 'px', top: y + 'px', width: w + 'px', height: h + 'px' });
      b.title = hint;
      b.setAttribute('aria-label', hint);
      const img = el('img'); img.src = ICONS + icon; img.alt = ''; img.draggable = false;
      b.append(img);
      b.addEventListener('mousedown', e => e.preventDefault());   // zaznaczenie w siatce zostaje
      b.addEventListener('click', () => { this.el.style.opacity = '1'; this.actions[id](b); });
      this.buttons[id] = b;
      this.el.append(b);
    }
    document.body.append(this.el);
    // przezroczystość zależna od odległości kursora; dalej niż 200 px - okno znika
    document.addEventListener('mousemove', e => {
      if (this.el.hidden) return;
      if (openMenus.length) { this.el.style.opacity = '1'; return; }   // otwarte menu przycisku - okno w pełni widoczne
      const r = this.el.getBoundingClientRect();
      const dx = e.clientX < r.left ? r.left - e.clientX : e.clientX > r.right ? e.clientX - r.right : 0;
      const dy = e.clientY < r.top ? r.top - e.clientY : e.clientY > r.bottom ? e.clientY - r.bottom : 0;
      const d = Math.min(dx + dy, 255);
      if (d > 200 && !openMenus.length) { this.hide(); return; }
      this.el.style.opacity = String((255 - Math.min(d, 51) * 5) / 255);
    });
  }

  // jak showtoolwindow: 20 px w lewo i 70 px nad kursorem, prawie przezroczyste (AlphaBlendValue = 30)
  show(x, y) {
    const en = this.enabled();
    for (const [id, b] of Object.entries(this.buttons)) b.disabled = en[id] === false;
    this.el.hidden = false;
    const w = this.el.offsetWidth, h = this.el.offsetHeight;
    this.el.style.left = Math.max(4, Math.min(x - 20, window.innerWidth - w - 4)) + 'px';
    this.el.style.top = Math.max(4, Math.min(y - 70, window.innerHeight - h - 4)) + 'px';
    this.el.style.opacity = String(30 / 255);
  }
  hide() { this.el.hidden = true; closePopup(); }
}

// --- okna wyboru do poleceń menu --------------------------------------------------------------------------
function modal(title, cls = 'tw-dialog') {
  const d = el('dialog', cls);
  const head = el('div', 'b-head');
  head.append(el('h2', '', title), el('span', 'spacer'), button('×', 'link close', () => d.close()));
  const body = el('div', 'tw-dlg-body');
  const actions = el('div', 'b-actions tw-dlg-actions');
  d.append(head, body, actions);
  d.addEventListener('close', () => setTimeout(() => d.remove(), 0));
  document.body.append(d);
  return { d, body, actions };
}

// wybór obiektów (LECTURERSShowModalAsMultiSelect, SUBJECTSShowModalAsSelect, PLANNERSShowModalAsSelect...)
// search(q) -> [{ id, name }]; wynik: wybrane pozycje albo null
export function pickItems({ title, label, search, single, info }) {
  return new Promise(resolve => {
    const { d, body, actions } = modal(title);
    if (info) body.append(el('p', 'muted', info));
    const box = el('div', 'chips'); box.dataset.type = 'X'; box.dataset.label = label;
    body.append(box);
    const f = new ChipField(box, { search: (t, q) => search(q), single });
    const err = el('p', 'error'); err.hidden = true; body.append(err);
    let result = null;
    const ok = button('OK', 'primary', () => {
      if (!f.items.length) { err.textContent = 'Wybierz pozycję z listy.'; err.hidden = false; return; }
      result = f.items; d.close();
    });
    actions.append(ok, button('Anuluj', 'secondary', () => d.close()));
    d.addEventListener('close', () => resolve(result));
    d.showModal();
    f.input.focus();
  });
}

// kolor zajęcia (ColorDialog)
export function pickColour(title) {
  return new Promise(resolve => {
    const { d, body, actions } = modal(title);
    const l = el('label', 'b-field'); l.append(el('span', '', 'Kolor'));
    const c = el('input'); c.type = 'color'; c.value = '#ffff80'; l.append(c);
    body.append(l);
    let result = null;
    actions.append(button('OK', 'primary', () => { result = c.value; d.close(); }), button('Anuluj', 'secondary', () => d.close()));
    d.addEventListener('close', () => resolve(result));
    d.showModal();
    c.focus();
  });
}

// opis zajęcia (FIN_LOOKUP_VALUESShowModalAsMultiselectExt): wartości słownika do zaznaczenia (wiele - po przecinku)
// albo dowolny tekst; load(q) -> [{ value, key, aux1, aux2 }]
export function pickDesc({ title, load }) {
  return new Promise(resolve => {
    const { d, body, actions } = modal(title, 'tw-dialog tw-wide');
    const q = el('input'); q.placeholder = 'Szukaj…'; q.type = 'search';
    const list = el('div', 'tw-desc-list');
    const l = el('label', 'b-field'); l.append(el('span', '', 'Nowa wartość opisu'));
    const text = el('input'); l.append(text);
    body.append(q, list, l);
    const checked = new Set();
    const render = async () => {
      let rows = [];
      try { rows = await load(q.value.trim()); } catch { /* brak słownika */ }
      list.innerHTML = '';
      if (!rows.length) list.append(el('p', 'muted', 'Brak wartości w słowniku - wpisz opis poniżej.'));
      for (const r of rows) {
        const row = el('label', 'check tw-desc-row');
        const cb = el('input'); cb.type = 'checkbox'; cb.checked = checked.has(r.value);
        cb.addEventListener('change', () => {
          cb.checked ? checked.add(r.value) : checked.delete(r.value);
          text.value = [...checked].join(',');
        });
        row.append(cb, ' ' + r.value, el('span', 'muted', [r.key, r.aux1, r.aux2].filter(Boolean).join(' · ')));
        list.append(row);
      }
    };
    let t;
    q.addEventListener('input', () => { clearTimeout(t); t = setTimeout(render, 250); });
    let result = null;
    actions.append(button('OK', 'primary', () => { result = text.value.trim(); d.close(); }), button('Anuluj', 'secondary', () => d.close()));
    d.addEventListener('close', () => resolve(result));
    render();
    d.showModal();
    q.focus();
  });
}

// lista preferowanych terminów (FavouritePopup "Lista" -> FBrowseRES_HINTS) z usuwaniem zaznaczonych ocen
export async function hintsList({ api, period, objects, onChanged }) {
  const { d, body, actions } = modal('Preferowane terminy', 'tw-dialog tw-wide');
  body.append(el('p', 'muted', objects.length ? 'Oceny terminów: ' + objects.map(o => o.name).join(', ') : 'Nie wybrano obiektów.'));
  const wrap = el('div', 'tw-table-wrap');
  body.append(wrap);
  const del = button('Usuń zaznaczone', 'secondary danger');
  actions.append(del, button('Zamknij', 'secondary', () => d.close()));
  const sel = new Set();
  const load = async () => {
    wrap.innerHTML = '';
    sel.clear(); del.disabled = true;
    let rows = [];
    try { rows = objects.length ? await api(`hints/list?period=${period}&ids=${objects.map(o => o.id).join(',')}`) : []; }
    catch (e) { wrap.append(el('p', 'error', e.message)); return; }
    if (!rows.length) { wrap.append(el('p', 'muted', 'Brak ocen terminów w tym okresie.')); return; }
    const t = el('table', 'ac-table');
    const tr = el('tr');
    ['', 'Dzień', 'Godzina', 'Preferencja', 'Wykładowca lub nazwa zasobu', 'Utworzył', 'Data utworzenia', 'Zmienił', 'Data zmiany'].forEach(c => tr.append(el('th', '', c)));
    const thead = el('thead'); thead.append(tr); t.append(thead);
    const tb = el('tbody');
    for (const r of rows) {
      const x = el('tr');
      const cb = el('input'); cb.type = 'checkbox'; cb.setAttribute('aria-label', 'Zaznacz');
      cb.addEventListener('change', () => { cb.checked ? sel.add(r.id) : sel.delete(r.id); del.disabled = !sel.size; });
      const c0 = el('td'); c0.append(cb); x.append(c0);
      [r.day, r.hourCaption, (r.ratio > 0 ? 'TAK ' : 'NIE ') + r.ratio, r.name, r.createdBy, r.created, r.updatedBy, r.updated].forEach(v => x.append(el('td', '', v)));
      tb.append(x);
    }
    t.append(tb);
    wrap.append(t);
  };
  del.addEventListener('click', async () => {
    try { await api('hints/delete', { ids: [...sel] }); } catch (e) { wrap.prepend(el('p', 'error', e.message)); return; }
    onChanged();
    load();
  });
  d.showModal();
  load();
}
