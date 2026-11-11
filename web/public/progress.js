// Wskaźnik pracy (jak FProgress w Delphi) nad obszarem, którego dotyczy operacja: półprzezroczysta nakładka
// ze spinnerem, paskiem postępu (nieokreślonym - serwer nie podaje postępu) i licznikiem sekund.
// withProgress(target, text, work, disable, delay) -> wynik work(); nakładka pojawia się po `delay` ms
// (krótkie operacje nie mrugają), przyciski z `disable` są na czas pracy wyłączone.
export async function withProgress(target, text, work, disable = [], delay = 150) {
  const ov = document.createElement('div');
  ov.className = 'work-overlay';
  ov.setAttribute('role', 'status');
  ov.setAttribute('aria-live', 'polite');
  ov.innerHTML = '<div class="work-box"><span class="work-spinner" aria-hidden="true"></span><div class="work-text"></div>'
    + '<div class="work-bar" aria-hidden="true"><span></span></div><div class="work-time muted"></div></div>';
  ov.querySelector('.work-text').textContent = text;
  // nakładka w tym samym oknie (dialog w warstwie wierzchniej albo strona), dokładnie nad obszarem
  const host = (target && target.closest('dialog[open]')) || document.body;
  const place = () => {
    const r = (target || document.body).getBoundingClientRect();
    const h = Math.max(r.height, 120);
    Object.assign(ov.style, { left: r.left + 'px', top: Math.min(r.top, window.innerHeight - h) + 'px', width: r.width + 'px', height: h + 'px' });
  };
  const start = Date.now();
  let shown = false, timer = null;
  const show = () => {
    if (shown) return;
    shown = true;
    place();
    host.append(ov);
    timer = setInterval(() => {
      place();
      const s = Math.round((Date.now() - start) / 1000);
      if (s >= 2) ov.querySelector('.work-time').textContent = `${s} s`;
    }, 500);
  };
  const delayTimer = setTimeout(show, delay);
  const was = disable.map(b => b && b.disabled);
  disable.forEach(b => { if (b) b.disabled = true; });
  try {
    return await work();
  } finally {
    clearTimeout(delayTimer);
    clearInterval(timer);
    ov.remove();
    disable.forEach((b, i) => { if (b) b.disabled = was[i]; });
  }
}
