// Podgląd (przycisk Preview / PPreview w Delphi): strona do wydruku w nowej karcie przeglądarki.
//  - rozkład zajęć z ekranu (Semestralny / Tygodniowy rozkład zajęć - MenuItem4Click, FSettings.BHtmlClick)
//  - Tygodniowy rozkład zajęć (Plan lekcji) - UFWeeklySchoolPlan: zajęcia zebrane wg dnia tygodnia i godziny,
//    z datami, w których się odbywają; zawsze pełne nazwy wykładowców, grup i sal

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

// plan lekcji: wiersze - godziny, kolumny - dni tygodnia okresu; w komórce zajęcia z datami
export function previewWeeklyPlan({ title, subtitle, period, data, settings }) {
  const fullNames = (ids, map) => String(ids || '').split(';').filter(Boolean).map(id => (map[id] || {}).label || id).join(', ');
  const days = period.days.map((v, i) => (v ? i : -1)).filter(i => i >= 0);
  const slots = new Map();   // "dzień|godzina" -> Map(sygnatura -> { text, dates })
  for (const c of data.classes) {
    const wd = (new Date(c.day + 'T00:00:00Z').getUTCDay() + 6) % 7;
    const k = wd + '|' + c.hour;
    if (!slots.has(k)) slots.set(k, new Map());
    const sig = [c.subId, c.forId, c.lecIds, c.groIds, c.romIds, ...c.desc].join('|');
    const m = slots.get(k);
    if (!m.has(sig)) {
      const lines = [
        `<b>${esc(c.subName || c.sub || c.formName)}</b>${c.subName || c.sub ? ` <span class="pv-form">(${esc(c.formName || c.form)})</span>` : ''}`,
        fullNames(c.lecIds, data.lecturers), fullNames(c.groIds, data.groups), fullNames(c.romIds, data.rooms),
        ...c.desc.map((d, i) => (d && settings.descPlural[i] ? `${settings.descPlural[i]}: ${d}` : '')),
      ].filter(Boolean);
      m.set(sig, { html: lines.map((l, i) => (i ? esc(l) : l)).join('<br>'), dates: [] });
    }
    m.get(sig).dates.push(c.day);
  }
  const fmt = d => `${d.slice(8, 10)}.${d.slice(5, 7)}`;
  let html = '<table class="pv-plan"><thead><tr><th></th>' + days.map(d => `<th>${DAY_LONG[d]}</th>`).join('') + '</tr></thead><tbody>';
  for (const h of period.hours) {
    if (!days.some(d => slots.has(d + '|' + h.no))) continue;   // godziny bez zajęć pomijane
    html += `<tr><th>${esc(h.caption || h.no)}${h.from ? `<div class="pv-time">${esc(h.from)}–${esc(h.to)}</div>` : ''}</th>`;
    for (const d of days) {
      const m = slots.get(d + '|' + h.no);
      html += '<td>' + (m ? [...m.values()].map(x => `<div class="pv-cla">${x.html}<div class="pv-dates">${x.dates.length} × ${x.dates.map(fmt).join(', ')}</div></div>`).join('') : '') + '</td>';
    }
    html += '</tr>';
  }
  html += '</tbody></table>';
  if (!slots.size) html = '<p>Brak zajęć w rozkładzie.</p>';
  openPage(title, `<p class="pv-sub">${esc(subtitle)}</p>${html}`, `
    table.pv-plan { border-collapse: collapse; width: 100%; font-size: 12px; }
    table.pv-plan th, table.pv-plan td { border: 1px solid #999; padding: 4px 6px; vertical-align: top; }
    table.pv-plan thead th { background: #eef2f7; }
    table.pv-plan tbody th { background: #f6f7f9; white-space: nowrap; width: 60px; }
    .pv-time { font-weight: normal; color: #666; font-size: 11px; }
    .pv-cla + .pv-cla { border-top: 1px dashed #bbb; margin-top: 4px; padding-top: 4px; }
    .pv-form { color: #444; }
    .pv-dates { color: #666; font-size: 11px; margin-top: 2px; }`);
}
