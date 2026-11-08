# Plansoft.org Web – instalacja środowiska

Folder zawiera wszystko, co potrzebne do instalacji serwera aplikacji Plansoft.org Web.
Instalacja **nie pobiera niczego z internetu**.

| Program | Wersja | Do czego |
|---|---|---|
| Node.js | 24.22.2 LTS | serwer aplikacji |
| Caddy | 2.11.9 | serwer WWW, SSL (Let's Encrypt) |
| WinSW | 2.12.0 | uruchamianie Node.js i Caddy jako usług Windows |

Wszystkie programy są darmowe (licencje MIT / Apache 2.0).

Wymagania: Windows 10 / Windows Server 2016 lub nowszy, 64-bitowy, ok. 500 MB miejsca na dysku.

## Instalacja

1. Skopiuj cały folder `Install_NodeJS` na komputer, na którym ma działać serwer.
2. Jeżeli trzeba, popraw ustawienia w pliku `install.config.psd1` (folder docelowy, porty, baza danych).
3. Kliknij dwa razy `install.cmd` i potwierdź uprawnienia administratora.
4. Po zakończeniu otwórz w przeglądarce `https://localhost/` – powinna się pokazać strona aplikacji
   (albo, gdy w folderze `app` nie ma aplikacji, strona testowa „Plansoft.org Web – Środowisko działa”).

Instalator:
- sprawdza sumy kontrolne pakietów (uszkodzony lub podmieniony plik przerywa instalację),
- rozpakowuje Node.js i Caddy do `C:\PlansoftWeb`,
- instaluje aplikację z folderu `app` (a gdy jej nie ma – stronę testową),
- tworzy i uruchamia dwie usługi Windows (start automatyczny, restart po awarii):
  - `plansoft-web` – aplikacja (Node.js), dostępna tylko lokalnie na porcie 3000,
  - `plansoft-caddy` – serwer WWW na portach 80/443, przekazuje ruch do aplikacji,
- otwiera porty 80 i 443 w zaporze Windows,
- bez domeny: dodaje certyfikat główny Caddy do zaufanych w Windows, żeby `https://localhost/` działało bez ostrzeżeń,
- dopisuje Node.js do zmiennej PATH,
- na końcu sprawdza, czy strona odpowiada.

Przebieg instalacji jest zapisywany w `C:\PlansoftWeb\logs\install_*.log`.

## Folder po instalacji

```
C:\PlansoftWeb
  node\           Node.js
  caddy\          caddy.exe
  app\            aplikacja (podmieniana przy każdej instalacji)
  instantclient\  Oracle Instant Client (tylko dla Oracle 10/11)
  service\        pliki usług (WinSW)
  config\         Caddyfile, ustawienia aplikacji     – zostają przy aktualizacji
  data\           certyfikaty SSL                      – zostają przy aktualizacji
  logs\           logi instalacji, aplikacji i Caddy   – zostają przy aktualizacji
```

## Aktualizacja

Uruchom ponownie `install.cmd`. Usługi są zatrzymywane, programy i aplikacja podmieniane,
a foldery `config`, `data` i `logs` zostają bez zmian. Zatrzymywane są też inne programy
uruchomione z folderu instalacji (np. ręcznie uruchomiony `node.exe`), które blokowałyby podmianę plików.

Na komputerze z kodem źródłowym (obok instalatora jest folder `..\..\web`) instalator najpierw
sprawdza, czy kod aplikacji jest nowszy niż paczka `app\*.zip` – jeśli tak, buduje ją od nowa
(`web\build.ps1`), więc zawsze instaluje aktualną wersję. Po instalacji użytkownik, który ją
uruchomił, ma prawo restartu usługi `plansoft-web` (potrzebne dla `web\deploy.ps1`).

## SSL

Bez domeny (`Domain = ''`) strona działa jako `https://localhost/`: Caddy wystawia certyfikat
z własnego lokalnego urzędu certyfikacji, a instalator dodaje go do zaufanych w Windows
(Edge i Chrome; Firefox ma własną listę certyfikatów). Adres `http://localhost/` przekierowuje na https.
Taki certyfikat jest ważny tylko na tym komputerze. Dostęp z innych komputerów po samym http
(adres IP) daje ustawienie `LocalHttps = $false`.

Serwer z domeną:

1. Domena (np. `plan.uczelnia.pl`) musi wskazywać na ten komputer, a porty 80 i 443 muszą być dostępne z internetu.
2. W `install.config.psd1` wpisz `Domain = 'plan.uczelnia.pl'` (i opcjonalnie `Email`).
3. Uruchom ponownie `install.cmd`.

Caddy sam pobierze certyfikat Let's Encrypt, będzie go odnawiał i przekieruje http na https.
Dla serwera w sieci wewnętrznej (bez dostępu z internetu) można użyć certyfikatu firmowego:
własna konfiguracja w pliku `C:\PlansoftWeb\config\Caddyfile.custom` ma pierwszeństwo przed ustawieniami instalatora.

## Aplikacja Plansoft.org

Gotową aplikację (jeden plik zip) umieszcza się w folderze `app` i uruchamia `install.cmd` –
szczegóły w `app\CZYTAJ.txt`. Dopóki aplikacji nie ma, instalowana jest strona testowa.

## Oracle 10 i 11

Dla Oracle 12 i nowszych (w tym Oracle XE) nic nie trzeba dodawać.
Dla Oracle 10/11 potrzebny jest Oracle Instant Client – patrz `oracle\CZYTAJ.txt`.

## Odinstalowanie

`uninstall.ps1` usuwa usługi i reguły zapory. Pliki w `C:\PlansoftWeb` zostają.

## Test bez usług

Sama instalacja plików, bez usług, zapory i uprawnień administratora, np. do sprawdzenia paczki:

```
powershell -ExecutionPolicy Bypass -File install.ps1 -InstallDir C:\Temp\PlansoftWebTest -SkipServices -SkipFirewall
```

## Zawartość folderu

```
install.cmd             uruchomienie instalacji (dwuklik)
install.ps1             skrypt instalacji
install.config.psd1     ustawienia
uninstall.ps1           usunięcie usług
packages\               Node.js, Caddy, WinSW + SHA256SUMS.txt
templates\              szablony konfiguracji i strona testowa
app\                    miejsce na paczkę aplikacji
oracle\                 miejsce na Oracle Instant Client
```
