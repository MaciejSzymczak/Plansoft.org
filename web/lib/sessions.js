// Sesje w pamięci serwera: ciasteczko z losowym identyfikatorem -> pula połączeń użytkownika.
// Po restarcie usługi trzeba zalogować się ponownie.
'use strict';
const crypto = require('crypto');

const COOKIE = 'plansoft_sid';
const IDLE_MS = 8 * 60 * 60 * 1000;   // wylogowanie po 8 godzinach bezczynności

const sessions = new Map();

function parseCookies(req) {
  const out = {};
  for (const part of (req.headers.cookie || '').split(';')) {
    const i = part.indexOf('=');
    if (i > 0) out[part.slice(0, i).trim()] = decodeURIComponent(part.slice(i + 1).trim());
  }
  return out;
}

function isHttps(req) {
  return req.headers['x-forwarded-proto'] === 'https';
}

function create(res, req, data) {
  const id = crypto.randomBytes(32).toString('hex');
  sessions.set(id, { ...data, lastSeen: Date.now() });
  res.setHeader('Set-Cookie', `${COOKIE}=${id}; Path=/; HttpOnly; SameSite=Strict${isHttps(req) ? '; Secure' : ''}`);
  return sessions.get(id);
}

function get(req) {
  const id = parseCookies(req)[COOKIE];
  const s = id && sessions.get(id);
  if (!s) return null;
  if (Date.now() - s.lastSeen > IDLE_MS) { destroyById(id); return null; }
  s.lastSeen = Date.now();
  s.id = id;
  return s;
}

function destroyById(id) {
  const s = sessions.get(id);
  sessions.delete(id);
  if (s && s.pool) s.pool.close(0).catch(() => {});
}

function destroy(req, res) {
  const id = parseCookies(req)[COOKIE];
  if (id) destroyById(id);
  res.setHeader('Set-Cookie', `${COOKIE}=; Path=/; HttpOnly; SameSite=Strict; Max-Age=0`);
}

// sprzątanie wygasłych sesji
setInterval(() => {
  const now = Date.now();
  for (const [id, s] of sessions) if (now - s.lastSeen > IDLE_MS) destroyById(id);
}, 10 * 60 * 1000).unref();

async function closeAll() {
  await Promise.all([...sessions.values()].map(s => s.pool && s.pool.close(0).catch(() => {})));
  sessions.clear();
}

module.exports = { create, get, destroy, closeAll };
