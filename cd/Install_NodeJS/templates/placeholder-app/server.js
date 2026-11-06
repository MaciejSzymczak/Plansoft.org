// Strona testowa środowiska Plansoft.org Web.
// Instalowana, gdy w folderze app nie ma paczki aplikacji. Bez zewnętrznych bibliotek.
'use strict';
const http = require('http');

const port = Number(process.env.PORT) || 3000;
const started = new Date();

const page = () => `<!doctype html>
<html lang="pl"><head><meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Plansoft.org Web</title>
<style>
  body { font-family: Segoe UI, Arial, sans-serif; margin: 0; padding: 32px 16px; background: #f4f6f8; color: #1d2733; }
  main { max-width: 640px; margin: 0 auto; background: #fff; border-radius: 8px; padding: 24px; box-shadow: 0 1px 3px rgba(0,0,0,.1); }
  h1 { margin-top: 0; font-size: 1.4em; }
  td { padding: 4px 12px 4px 0; vertical-align: top; }
  .ok { color: #1a7f37; font-weight: 600; }
</style></head>
<body><main>
<h1>Plansoft.org Web</h1>
<p class="ok">Środowisko działa.</p>
<p>To jest strona testowa. Po dodaniu aplikacji (plik zip w folderze <b>app</b> instalatora) i ponownym uruchomieniu instalacji zostanie zastąpiona właściwą aplikacją.</p>
<table>
  <tr><td>Node.js</td><td>${process.version}</td></tr>
  <tr><td>Uruchomiono</td><td>${started.toLocaleString('pl-PL')}</td></tr>
  <tr><td>Baza danych</td><td>${process.env.PLANSOFT_DB_CONNECT || '-'}</td></tr>
  <tr><td>Folder</td><td>${process.env.PLANSOFT_HOME || __dirname}</td></tr>
</table>
</main></body></html>`;

http.createServer((req, res) => {
  if (req.url === '/health') {
    res.writeHead(200, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify({ status: 'ok', node: process.version, started }));
    return;
  }
  res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });
  res.end(page());
}).listen(port, '127.0.0.1', () => console.log(`Plansoft.org Web (strona testowa) - port ${port}`));
