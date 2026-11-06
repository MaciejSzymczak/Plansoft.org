# Plansoft.org Web

Wersja podstawowa: logowanie kontem Oracle, wybór okresu, siatka semestralna,
pola wyboru wykładowców, grup i sal (jak w Outlooku).

```
server.js        serwer (Node.js, bez frameworków)
lib\db.js        połączenia z Oracle (pula na użytkownika; Oracle 10/11 przez Instant Client)
lib\sessions.js  sesje w pamięci (ciasteczko HttpOnly)
lib\api.js       /api/... - zapytania jak w programie Delphi (uprawnienia XXX_PLA, rola), podsumowanie godzin
lib\browse.js    wspólny trzon okien słownikowych (jak TFBrowseParent): okresy, wykładowcy, grupy, zasoby,
                 przedmioty, formy - lista, formularz, dodaj/kopiuj/zapisz/usuń, uprawnienia, hierarchia
lib\search.js    wyszukiwanie "Dowolna fraza"
lib\addClasses.js dodawanie zajęć (jak insertClasses/TCheckConflicts): kontrola danych i uprawnień, konflikty
                 z hierarchią i wykluczeniami, doplanowanie, api.delete_class + planner_utils.insert_classes
public\addClass.js okno dodawania zajęcia (FDetails) i okno konfliktów (FShowConflicts)
public\          strona: app.js, chips.js (pole wyboru), grid.js (siatka, zaznaczanie), cellLayout.js (okno
                 "Zajęcie"), summary.js (legenda: podsumowanie godzin), browse.js (okna słownikowe), app.css
build.ps1        paczka zip do cd\Install_NodeJS\app
```

Uruchomienie podczas rozwoju (Node.js 20 lub nowszy):

```
npm install
set PLANSOFT_DB_CONNECT=localhost:1521/XEPDB1
node server.js            -> http://127.0.0.1:3000
```

Nowa wersja dla klientów: zmień `version` w package.json, uruchom `build.ps1`,
potem `install.cmd` instalatora.

Szybkie wdrożenie zmian na tym komputerze (bez instalatora):

```
powershell -ExecutionPolicy Bypass -File deploy.ps1
```

Kopiuje do `C:\PlansoftWeb\app` tylko zmienione pliki. Usługę `plansoft-web` restartuje tylko po zmianie
kodu serwera (zmiany w `public\` widać od razu po odświeżeniu przeglądarki). Żeby restart działał bez
uprawnień administratora, uruchom raz `grant-restart.ps1` (cofnięcie: `grant-restart.ps1 -Remove`).
