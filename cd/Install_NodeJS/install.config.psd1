# Ustawienia instalacji srodowiska Plansoft.org Web.
# Plik czyta install.ps1. Po zmianie wystarczy ponownie uruchomic install.cmd.
@{
    # Folder docelowy. Ponowna instalacja podmienia programy, ale zostawia
    # foldery config, data (certyfikaty SSL) i logs.
    InstallDir   = 'C:\PlansoftWeb'

    # Port aplikacji Node.js (dostepny tylko lokalnie, przez Caddy).
    AppPort      = 3000

    # Porty serwera WWW Caddy.
    HttpPort     = 80
    HttpsPort    = 443

    # SSL. Puste = https://localhost z lokalnym certyfikatem Caddy (patrz LocalHttps).
    # Wpisz nazwe domeny (np. 'plan.uczelnia.pl'), a Caddy sam pobierze
    # i bedzie odnawial certyfikat Let's Encrypt. Domena musi wskazywac na ten
    # komputer, a porty 80 i 443 musza byc dostepne z internetu.
    Domain       = ''
    # Adres e-mail do powiadomien Let's Encrypt (opcjonalny).
    Email        = ''

    # Bez domeny: https://localhost z certyfikatem lokalnego urzedu certyfikacji Caddy.
    # Instalator dodaje certyfikat glowny Caddy do zaufanych w Windows (Edge, Chrome).
    # $false = tylko http na porcie HttpPort (np. dostep po adresie IP z innych komputerow).
    LocalHttps   = $true

    # Polaczenie z baza Oracle (przekazywane aplikacji jako zmienne srodowiskowe).
    # Oracle XE 18/21: localhost:1521/XEPDB1, starsze bazy zwykle localhost:1521/XE lub nazwa uslugi.
    DbConnect    = 'localhost:1521/XEPDB1'

    # Otworzyc porty http/https w zaporze Windows.
    OpenFirewall = $true

    # Dopisac node.exe i npm do systemowej zmiennej PATH (wygodne przy rozwoju).
    AddNodeToPath = $true
}
