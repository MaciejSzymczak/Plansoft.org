// Podgląd (przycisk Preview / PPreview w Delphi): strona do wydruku w nowej karcie przeglądarki.
//  - rozkład zajęć z ekranu (Semestralny / Tygodniowy rozkład zajęć - MenuItem4Click, FSettings.BHtmlClick)
//  - Tygodniowy rozkład zajęć (Plan lekcji) - UFWeeklySchoolPlan: plan wybranego tygodnia (openWeeklyPlan)

const esc = s => String(s ?? '').replace(/[&<>"]/g, c => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;' }[c]));
const DAY_LONG = ['Poniedziałek', 'Wtorek', 'Środa', 'Czwartek', 'Piątek', 'Sobota', 'Niedziela'];

function openPage(title, body, extraCss = '') {
  const w = window.open('', '_blank');
  if (!w) { alert('Przeglądarka zablokowała nowe okno - zezwól na wyskakujące okna dla tej strony.'); return null; }
  const base = new URL('.', location.href).href;
  w.document.open();
  w.document.write(`<!doctype html><html lang="pl"><head><meta charset="utf-8"><title>${esc(title)}</title>
<base href="${esc(base)}"><link rel="stylesheet" href="app.css">
<style>
  body { background: #fff; margin: 16px; }
  .pv-bar { display: flex; gap: 8px; align-items: center; margin-bottom: 12px; }
  .pv-bar h1 { font-size: 18px; margin: 0; flex: 1; }
  .pv-sub { color: #555; font-size: 13px; margin: -6px 0 12px; }
  .pv-grid { overflow: visible; }
  .pv-grid table.semester th, .pv-grid table.semester td { position: static !important; }
  .pv-grid td.cell.selected { outline: none !important; box-shadow: none !important; }
  @media print { .pv-bar button { display: none; } body { margin: 0; } @page { size: landscape; margin: 8mm; } }
  ${extraCss}
</style></head><body>
<div class="pv-bar"><h1>${esc(title)}</h1><button type="button" class="primary small" onclick="print()">Drukuj</button></div>
${body}</body></html>`);
  w.document.close();
  return w;
}

// rozkład z ekranu: kopia siatki bez zaznaczenia, kropek zajętości i elementów przewijania
export function previewGrid({ title, subtitle, gridWrap }) {
  const table = gridWrap.querySelector('table.semester');
  if (!table) return;
  const copy = table.cloneNode(true);
  copy.querySelectorAll('.busy-dot, .hint-mark').forEach(x => x.remove());
  copy.querySelectorAll('.selected, .clip-copy, .clip-cut, .grp-sel, .drop-target, .drop-bad').forEach(x => x.classList.remove('selected', 'clip-copy', 'clip-cut', 'grp-sel', 'drop-target', 'drop-bad'));
  openPage(title, `<p class="pv-sub">${esc(subtitle)}</p><div class="pv-grid grid-wrap">${copy.outerHTML}</div>`);
}

// --- Tygodniowy rozkład zajęć (Plan lekcji) - jak UFWeeklySchoolPlan w Delphi --------------------------------
// plan jednego tygodnia: kolumny - widoczne dni tygodnia okresu (z datami, dzisiaj wyróżnione), wiersze - siatka godzin
// (numer i godziny), w komórkach zajęcia w kolorach z okna "Układ" i z pełnymi nazwami, kolejne godziny z tymi samymi
// zajęciami scalane w pionie, dni wolne, przyciski « ↑ » (poprzedni tydzień / następny tydzień), układ na telefon.
const PLAN_CSS = `
@page { size: A4 landscape; margin: 9mm; }
* { box-sizing: border-box; }
html { -webkit-print-color-adjust: exact; print-color-adjust: exact; }
body { margin: 0; background: #e9edf3; color: #1f2937; font-family: "Segoe UI", "Helvetica Neue", Calibri, Arial, sans-serif; }
.sheet { max-width: 1400px; margin: 28px auto; background: #fff; border-radius: 18px; box-shadow: 0 12px 36px rgba(15, 23, 42, .10); padding: 30px 34px 22px; }
.sheet + .sheet { page-break-before: always; }
.head { display: flex; justify-content: space-between; align-items: flex-end; gap: 24px; padding-bottom: 16px; margin-bottom: 14px; border-bottom: 3px solid #1e3a5f; }
.title { font-size: 25px; font-weight: 800; letter-spacing: .05em; color: #1e3a5f; text-transform: uppercase; }
.who { margin-top: 6px; font-size: 19px; color: #475569; }
.who b { color: #111827; font-weight: 700; }
.meta { text-align: right; font-size: 12px; color: #64748b; line-height: 1.6; white-space: nowrap; }
.badge { display: inline-block; background: #1e3a5f; color: #fff; border-radius: 999px; padding: 3px 12px; font-weight: 700; font-size: 12px; letter-spacing: .04em; }
.nav { display: flex; justify-content: flex-end; gap: 6px; margin-bottom: 8px; }
.navBtn { display: inline-flex; align-items: center; justify-content: center; width: 36px; height: 30px; border: 0; border-radius: 8px; background: #1e3a5f; color: #fff; text-decoration: none; font-size: 17px; font-weight: 700; box-shadow: 0 1px 3px rgba(15, 23, 42, .25); cursor: pointer; font-family: inherit; }
button.navBtn:hover { background: #c2410c; }
.navBtn.off, .navBtn:disabled { background: #e2e8f0; color: #94a3b8; box-shadow: none; cursor: default; }
.printBtn { width: auto; padding: 0 12px; font-size: 13px; }
table.plan { width: 100%; height: 1px; table-layout: fixed; border-collapse: separate; border-spacing: 6px; }
col.hours { width: 96px; }
thead th { background: #1e3a5f; color: #fff; border-radius: 10px; padding: 9px 6px; font-weight: 600; }
thead th.today { background: #c2410c; }
thead th.corner { background: transparent; color: #94a3b8; font-size: 11px; font-weight: 600; text-transform: uppercase; letter-spacing: .08em; }
thead .dayname { display: block; font-size: 15px; }
thead .date { display: block; margin-top: 2px; font-size: 12px; font-weight: 400; opacity: .8; }
tbody tr { height: 54px; }
th.hour { background: #f1f5f9; border-radius: 10px; padding: 5px 4px; text-align: center; }
th.hour .no { display: block; font-size: 18px; font-weight: 800; color: #1e3a5f; line-height: 1.1; }
th.hour .time { display: block; margin-top: 2px; font-size: 11px; font-weight: 400; color: #64748b; white-space: nowrap; }
td { height: 100%; padding: 0; border-radius: 10px; text-align: center; vertical-align: middle; }
td.empty { background: #f8fafc; border: 1px dashed #dbe2ea; }
.lesson, .lessons > div { padding: 7px 6px; line-height: 1.25; overflow-wrap: anywhere; box-shadow: inset 4px 0 0 rgba(0, 0, 0, .16), 0 1px 3px rgba(15, 23, 42, .14); }
.lessons { display: flex; gap: 4px; height: 100%; }
.lessons > div { flex: 1; min-width: 0; border-radius: 10px; display: flex; align-items: center; justify-content: center; }
.lesson .l1, .lessons .l1 { font-weight: 700; }
.lesson .ln, .lessons .ln { font-size: 12px; }
.holiday { color: #b91c1c; font-weight: 600; font-size: 13px; letter-spacing: .03em; background: repeating-linear-gradient(135deg, #fef2f2 0 10px, #fde4e4 10px 20px); }
td.outside { background: repeating-linear-gradient(135deg, #f8fafc 0 10px, #eef2f6 10px 20px); }
.note { text-align: center; color: #64748b; font-size: 14px; padding: 10px 0 4px; }
.foot { display: flex; justify-content: space-between; margin-top: 12px; font-size: 11px; color: #94a3b8; }
.foot a { color: inherit; }
.days { display: none; }
.day { margin-bottom: 14px; }
.day h2 { margin: 0 0 6px; background: #1e3a5f; color: #fff; border-radius: 10px; padding: 9px 12px; font-size: 16px; font-weight: 600; display: flex; justify-content: space-between; align-items: baseline; }
.day h2.today { background: #c2410c; }
.day h2 .date { font-size: 13px; font-weight: 400; opacity: .8; }
.item { display: flex; gap: 6px; margin-top: 6px; }
.item > .when { flex: 0 0 74px; background: #f1f5f9; border-radius: 10px; padding: 7px 4px; text-align: center; font-size: 12px; font-weight: 700; color: #1e3a5f; display: flex; align-items: center; justify-content: center; }
.item > .lesson, .item > .multi, .item > .holiday { flex: 1; min-width: 0; border-radius: 10px; padding: 8px 10px; }
.item > .multi { padding: 0; }
.item .lessons { flex-direction: column; }
.day .none { color: #94a3b8; font-size: 13px; padding: 8px 12px; background: #f8fafc; border: 1px dashed #dbe2ea; border-radius: 10px; }
@media screen and (max-width: 760px) {
  .sheet { margin: 0; border-radius: 0; padding: 16px 14px 14px; box-shadow: none; }
  .head { flex-direction: column; align-items: stretch; gap: 10px; }
  .title { font-size: 18px; } .who { font-size: 16px; }
  .meta { text-align: left; white-space: normal; } .nav { justify-content: flex-start; }
  table.plan { display: none; } .days { display: block; }
  .foot { flex-direction: column; gap: 4px; }
}
@media print {
  body { background: #fff; } .nav { display: none; }
  .sheet { margin: 0; max-width: none; padding: 0; border-radius: 0; box-shadow: none; }
  tbody tr { height: 42px; } table.plan { page-break-inside: avoid; }
}`;
const DAY_NAMES = ['Poniedziałek', 'Wtorek', 'Środa', 'Czwartek', 'Piątek', 'Sobota', 'Niedziela'];
const ddmm = t => { const d = new Date(t); return `${String(d.getUTCDate()).padStart(2, '0')}.${String(d.getUTCMonth() + 1).padStart(2, '0')}`; };
const ddmmyyyy = t => `${ddmm(t)}.${new Date(t).getUTCFullYear()}`;
const isoOf = t => new Date(t).toISOString().slice(0, 10);
const T = s => Date.parse(s + 'T00:00:00Z');

// tygodnie okresu: [{ no, from, to, visible }] (poniedziałek - niedziela; widoczność wg ATTRIBS_13)
export function periodWeeks(period) {
  const from = T(period.dateFrom), to = T(period.dateTo);
  const first = from - ((new Date(from).getUTCDay() + 6) % 7) * 864e5;
  const vis = period.weekVisibility || '';
  const out = [];
  for (let m = first, i = 0; m <= to; m += 7 * 864e5, i++) {
    out.push({ no: i + 1, from: Math.max(m, from), to: Math.min(m + 6 * 864e5, to), monday: m, visible: !vis || vis[i % vis.length] !== '-' });
  }
  return out;
}

// ctx: { period, type (L|G|S|SUB), objects [{id, name}], data (classData), holidays, colourOf(class) -> '#rrggbb', periodName }
export function openWeeklyPlan(ctx, weekIndex) {
  const w = window.open('', '_blank');
  if (!w) { alert('Przeglądarka zablokowała nowe okno - zezwól na wyskakujące okna dla tej strony.'); return; }
  const weeks = periodWeeks(ctx.period);
  let cur = weekIndex;
  // przyciski « » w planie: następny / poprzedni tydzień w tym samym oknie
  window.__plansoftPlanNav = delta => { const n = cur + delta; if (n >= 0 && n < weeks.length) { cur = n; write(); } };
  const write = () => { w.document.open(); w.document.write(planHtml(ctx, weeks, cur)); w.document.close(); };
  write();
}

function planHtml(ctx, weeks, wi) {
  const { period, type, objects, data, holidays } = ctx;
  const week = weeks[wi];
  const days = period.days.map((v, i) => (v ? i : -1)).filter(i => i >= 0);
  const today = isoOf(Date.now());
  const hours = period.hours.slice(0, period.hoursPerDay);
  const map = (ids, m) => String(ids || '').split(';').filter(Boolean).map(id => (data[m][id] || {}).label || id);
  // zawartość zajęcia: pełne nazwy, bez obiektu, którego plan jest pokazywany (jak classCellText w Delphi)
  const lines = c => {
    if (c.formKind === 'R') return [c.formName || c.form];
    const l = [];
    if (type !== 'SUB') l.push(c.subName || c.sub || c.formName);
    if (c.subName || c.sub || type === 'SUB') l.push(c.formName || c.form);
    if (type !== 'L') l.push(map(c.lecIds, 'lecturers').join(', '));
    if (type !== 'G') l.push(map(c.groIds, 'groups').join(', '));
    if (type !== 'S') l.push(map(c.romIds, 'rooms').join(', ').trim());
    return l.filter(Boolean);
  };
  const lum = hex => { const n = parseInt(hex.slice(1), 16); return ((n >> 16) * 299 + ((n >> 8) & 255) * 587 + (n & 255) * 114) / 1000; };
  const textOn = hex => (lum(hex) < 140 ? '#ffffff' : '#1f2937');
  const holidayAt = new Map((holidays || []).map(h => [h.date + '|' + h.hour, h]));
  const sheets = objects.map(obj => {
    // zajęcia tego obiektu (zajęcie kilku wybranych obiektów jest w planie każdego z nich)
    const mine = c => (type === 'SUB' ? String(c.subId) === String(obj.id)
      : String(c[{ L: 'lecIds', G: 'groIds', S: 'romIds' }[type]] || '').split(';').includes(String(obj.id)));
    const cls = data.classes.filter(c => mine(c) && c.day >= isoOf(week.monday) && c.day <= isoOf(week.monday + 6 * 864e5));
    let hasClasses = false;
    // komórki [dzień][godzina]: klucz (scalanie), atrybuty, treść
    const cells = days.map(wd => {
      const date = isoOf(week.monday + wd * 864e5);
      return hours.map(h => {
        if (T(date) < T(period.dateFrom) || T(date) > T(period.dateTo)) return { key: 'OUT', attrs: 'class="outside"', body: '' };
        const list = cls.filter(c => c.day === date && c.hour === h.no);
        if (list.length) {
          hasClasses = true;
          const uniq = new Map();
          for (const c of list) {
            const colour = c.formKind === 'R' ? '#c0c0c0' : (ctx.colourOf(c) || '#ffffff');
            const ls = lines(c);
            const html = ls.map((x, i) => `<div class="${i ? 'ln' : 'l1'}">${esc(x)}</div>`).join('');
            const one = `<div style="background:${colour};color:${textOn(colour)}"><span>${html}</span></div>`;
            if (!uniq.has(one)) uniq.set(one, { colour, html });
          }
          const all = [...uniq.keys()].join('');
          if (uniq.size === 1) { const u = [...uniq.values()][0]; return { key: 'C' + all, attrs: `class="lesson" style="background:${u.colour};color:${textOn(u.colour)}"`, body: u.html }; }
          return { key: 'C' + all, attrs: 'class="multi"', body: `<div class="lessons">${all}</div>` };
        }
        const hol = holidayAt.get(date + '|' + h.no);
        if (hol) {
          const lbl = !hol.type || hol.type.toUpperCase() === 'HOLIDAY' ? 'Dzień wolny' : hol.type;
          return { key: 'R' + lbl, attrs: 'class="holiday"', body: esc(lbl) };
        }
        return { key: '', attrs: 'class="empty"', body: '' };
      });
    });
    const hourLabel = h => {
      const tm = h.from ? h.from + (h.to ? '–' + h.to : '') : '';
      let lbl = (h.caption || '').trim();
      if (!lbl || lbl === tm || lbl.includes(':')) lbl = String(h.no);
      return { lbl, tm };
    };
    let t = `<table class="plan"><colgroup><col class="hours">${days.map(() => '<col>').join('')}</colgroup><thead><tr><th class="corner">Godzina</th>`;
    for (const wd of days) {
      const t0 = week.monday + wd * 864e5;
      t += `<th${isoOf(t0) === today ? ' class="today"' : ''}><span class="dayname">${DAY_NAMES[wd]}</span><span class="date">${ddmm(t0)}</span></th>`;
    }
    t += '</tr></thead><tbody>';
    const skip = days.map(() => 0);
    hours.forEach((h, r) => {
      const { lbl, tm } = hourLabel(h);
      t += `<tr><th class="hour"><span class="no">${esc(lbl)}</span><span class="time">${esc(tm)}</span></th>`;
      days.forEach((wd, i) => {
        if (skip[i] > 0) { skip[i]--; return; }
        const c = cells[i][r];
        let k = 1;
        if (c.key) while (r + k < hours.length && cells[i][r + k].key === c.key) k++;
        skip[i] = k - 1;
        t += `<td${k > 1 ? ` rowspan="${k}"` : ''} ${c.attrs}>${c.body}</td>`;
      });
      t += '</tr>';
    });
    t += '</tbody></table>';
    if (!hasClasses) t += '<div class="note">W tym tygodniu nie ma zaplanowanych zajęć.</div>';
    // telefon: każdy dzień osobno
    t += '<div class="days">';
    days.forEach((wd, i) => {
      const t0 = week.monday + wd * 864e5;
      if (T(isoOf(t0)) < T(period.dateFrom) || T(isoOf(t0)) > T(period.dateTo)) return;
      t += `<section class="day"><h2${isoOf(t0) === today ? ' class="today"' : ''}>${DAY_NAMES[wd]} <span class="date">${ddmm(t0)}</span></h2>`;
      let items = '';
      for (let r = 0; r < hours.length;) {
        const c = cells[i][r];
        let k = 1;
        if (c.key) {
          while (r + k < hours.length && cells[i][r + k].key === c.key) k++;
          const a = hours[r], b = hours[r + k - 1];
          const when = a.from ? a.from + (b.to ? '–' + b.to : '') : hourLabel(a).lbl;
          items += `<div class="item"><div class="when">${esc(when)}</div><div ${c.attrs}>${c.body}</div></div>`;
        }
        r += k;
      }
      t += (items || '<div class="none">Brak zajęć</div>') + '</section>';
    });
    t += '</div>';
    const who = { L: 'Wykładowca', G: 'Grupa', S: 'Sala', SUB: 'Przedmiot' }[type];
    const nav = `<div class="nav"><button class="navBtn" title="Poprzedni tydzień" ${wi > 0 ? '' : 'disabled'} onclick="opener && opener.__plansoftPlanNav && opener.__plansoftPlanNav(-1)">&laquo;</button>`
      + `<button class="navBtn" title="Następny tydzień" ${wi < weeks.length - 1 ? '' : 'disabled'} onclick="opener && opener.__plansoftPlanNav && opener.__plansoftPlanNav(1)">&raquo;</button>`
      + `<button class="navBtn printBtn" title="Drukuj" onclick="print()">Drukuj</button></div>`;
    return `<div class="sheet"><div class="head"><div>
      <div class="title">Plan zajęć w dniach ${ddmmyyyy(week.monday)} – ${ddmmyyyy(week.monday + 6 * 864e5)}</div>
      <div class="who">${who}: <b>${esc(obj.name)}</b></div></div>
      <div class="meta">${nav}<span class="badge">Tydzień ${week.no}</span><br>${esc(ctx.periodName)}</div></div>
      ${t}
      <div class="foot"><span>Data aktualizacji: ${new Date().toLocaleString('pl-PL')}</span><span>Dokument utworzony w programie <a href="http://www.plansoft.org">Plansoft.org</a></span></div></div>`;
  });
  return `<!DOCTYPE html><html lang="pl"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1">
<title>Plan zajęć - ${esc(objects.map(o => o.name).join(', '))} - ${ddmmyyyy(week.monday)} - ${ddmmyyyy(week.monday + 6 * 864e5)}</title>
<style>${PLAN_CSS}</style></head><body>${sheets.join('')}</body></html>`;
}
