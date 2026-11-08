# Instalacja srodowiska Plansoft.org Web: Node.js + Caddy (+ opcjonalnie Oracle Instant Client
# i pliki aplikacji). Wszystkie pliki sa w tym folderze - nic nie jest pobierane z internetu.
#
# Uzycie:   install.cmd                       (instalacja / aktualizacja, wymaga administratora)
#           install.ps1 -InstallDir D:\Test -SkipServices -SkipFirewall   (sama instalacja plikow, test)
#
# Ponowne uruchomienie = aktualizacja: programy i aplikacja sa podmieniane,
# foldery config, data i logs zostaja.

param(
    [string]$ConfigFile = (Join-Path $PSScriptRoot 'install.config.psd1'),
    [string]$InstallDir,
    [switch]$SkipServices,
    [switch]$SkipFirewall,
    [string]$UserSid
)

$ErrorActionPreference = 'Stop'
$ProgressPreference    = 'SilentlyContinue'

$NodeVersion  = '24.22.2'
$CaddyVersion = '2.11.9'
$NodeZip      = "node-v$NodeVersion-win-x64.zip"
$CaddyZip     = "caddy_${CaddyVersion}_windows_amd64.zip"
$WinSW        = 'WinSW-x64.exe'

$AppService   = 'plansoft-web'
$CaddyService = 'plansoft-caddy'

function Step($text) { Write-Host ''; Write-Host "== $text" -ForegroundColor Cyan }
function Info($text) { Write-Host "   $text" }

# uruchamia program; komunikaty na stderr (np. logi Caddy) nie sa bledem - liczy sie kod wyjscia
function Invoke-Native($exe, $arguments) {
    $old = $ErrorActionPreference
    $ErrorActionPreference = 'Continue'
    try { & $exe @arguments 2>&1 | Out-Null; $LASTEXITCODE } finally { $ErrorActionPreference = $old }
}

function Test-Admin {
    $id = [Security.Principal.WindowsIdentity]::GetCurrent()
    (New-Object Security.Principal.WindowsPrincipal $id).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# --- paczka aplikacji ze zrodel ----------------------------------------------------------------
# Na komputerze programisty obok instalatora jest kod aplikacji (..\..\web). Jezeli kod jest nowszy
# niz paczka app\*.zip, paczka jest budowana od nowa (build.ps1) - instalacja zawsze wgrywa aktualna
# wersje. Na plycie dla klienta folderu web nie ma i ten krok jest pomijany.
$webSrc = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..\..\web'))
$buildScript = Join-Path $webSrc 'build.ps1'
if ((Test-Path $buildScript) -and -not $UserSid) {
    $zipNow = @(Get-ChildItem (Join-Path $PSScriptRoot 'app') -Filter '*.zip' -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending)
    $srcFiles = @(Get-Item (Join-Path $webSrc 'server.js'), (Join-Path $webSrc 'package.json'), (Join-Path $webSrc 'package-lock.json') -ErrorAction SilentlyContinue) +
                @(Get-ChildItem (Join-Path $webSrc 'lib'), (Join-Path $webSrc 'public') -Recurse -File -ErrorAction SilentlyContinue)
    $newest = ($srcFiles | Sort-Object LastWriteTime -Descending | Select-Object -First 1)
    if ($zipNow.Count -eq 0 -or ($newest -and $newest.LastWriteTime -gt $zipNow[0].LastWriteTime)) {
        Write-Host "Kod aplikacji jest nowszy niz paczka ($($newest.Name)) - buduje paczke od nowa (build.ps1)..."
        & powershell.exe -NoProfile -ExecutionPolicy Bypass -File $buildScript
        if ($LASTEXITCODE -ne 0) { throw 'Budowanie paczki aplikacji (build.ps1) nie powiodlo sie - instalacja przerwana.' }
    } else {
        Write-Host "Paczka aplikacji jest aktualna: $($zipNow[0].Name)"
    }
}

# --- uprawnienia administratora (uslugi, zapora, PATH) ---------------------------------------
$needAdmin = -not ($SkipServices -and $SkipFirewall)
if ($needAdmin -and -not (Test-Admin)) {
    Write-Host 'Potrzebne sa uprawnienia administratora - uruchamiam ponownie...'
    $argList = @('-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', "`"$PSCommandPath`"", '-ConfigFile', "`"$ConfigFile`"")
    if ($InstallDir)   { $argList += @('-InstallDir', "`"$InstallDir`"") }
    if ($SkipServices) { $argList += '-SkipServices' }
    if ($SkipFirewall) { $argList += '-SkipFirewall' }
    # uzytkownik, ktory uruchomil instalacje - dostanie prawo restartu uslugi (deploy.ps1)
    $argList += @('-UserSid', [Security.Principal.WindowsIdentity]::GetCurrent().User.Value)
    $p = Start-Process powershell.exe -Verb RunAs -ArgumentList $argList -Wait -PassThru
    exit $p.ExitCode
}

# --- ustawienia ------------------------------------------------------------------------------
$cfg = Import-PowerShellDataFile $ConfigFile
if (-not $InstallDir) { $InstallDir = $cfg.InstallDir }
$InstallDir = [IO.Path]::GetFullPath($InstallDir)

$src      = $PSScriptRoot
$pkgDir   = Join-Path $src 'packages'
$nodeDir  = Join-Path $InstallDir 'node'
$caddyDir = Join-Path $InstallDir 'caddy'
$appDir   = Join-Path $InstallDir 'app'
$svcDir   = Join-Path $InstallDir 'service'
$confDir  = Join-Path $InstallDir 'config'
$dataDir  = Join-Path $InstallDir 'data'
$logDir   = Join-Path $InstallDir 'logs'
$icDir    = Join-Path $InstallDir 'instantclient'

# adres strony: domena (Let's Encrypt), https://localhost (lokalny certyfikat Caddy) albo samo http
$localHttps = (-not $cfg.Domain) -and ($cfg.LocalHttps -ne $false)
$baseUrl = if ($cfg.Domain) { "https://$($cfg.Domain)" }
    elseif ($localHttps) { 'https://localhost' + $(if ($cfg.HttpsPort -ne 443) { ":$($cfg.HttpsPort)" }) }
    else { 'http://localhost' + $(if ($cfg.HttpPort -ne 80) { ":$($cfg.HttpPort)" }) }

foreach ($d in $InstallDir, $confDir, $dataDir, $logDir, $svcDir) { New-Item -ItemType Directory -Force $d | Out-Null }
Start-Transcript -Path (Join-Path $logDir ("install_{0:yyyy-MM-dd_HHmmss}.log" -f (Get-Date))) | Out-Null

try {
    Write-Host "Plansoft.org Web - instalacja srodowiska (Node.js $NodeVersion, Caddy $CaddyVersion)"
    Info "Folder docelowy: $InstallDir"

    # --- 1. sumy kontrolne -------------------------------------------------------------------
    Step '1. Sprawdzam pakiety instalacyjne'
    foreach ($line in Get-Content (Join-Path $pkgDir 'SHA256SUMS.txt')) {
        if ($line -notmatch '^([0-9a-f]{64})\s+(\S+)$') { continue }
        $file = Join-Path $pkgDir $Matches[2]
        if (-not (Test-Path $file)) { throw "Brak pliku: $file" }
        $hash = (Get-FileHash $file -Algorithm SHA256).Hash.ToLower()
        if ($hash -ne $Matches[1]) { throw "Zla suma kontrolna pliku $($Matches[2]) - plik jest uszkodzony lub podmieniony." }
        Info "OK  $($Matches[2])"
    }

    # --- 2. zatrzymanie uslug (aktualizacja) ---------------------------------------------------
    if (-not $SkipServices) {
        Step '2. Zatrzymuje uruchomione uslugi (jezeli sa)'
        foreach ($s in $CaddyService, $AppService) {
            if (Get-Service $s -ErrorAction SilentlyContinue) { Stop-Service $s -Force; Info "zatrzymano $s" }
        }
    }
    # procesy uruchomione z folderu instalacji poza uslugami (np. node.exe uruchomiony recznie) blokuja
    # podmiane plikow - "Access to the path 'node.exe' is denied"
    $prefix = $InstallDir.TrimEnd('\') + '\'
    $locked = @(Get-CimInstance Win32_Process -ErrorAction SilentlyContinue |
        Where-Object { $_.ExecutablePath -and $_.ExecutablePath.StartsWith($prefix, [StringComparison]::OrdinalIgnoreCase) })
    foreach ($proc in $locked) {
        Stop-Process -Id $proc.ProcessId -Force -ErrorAction SilentlyContinue
        Info "zatrzymano proces $($proc.Name) (PID $($proc.ProcessId)) uruchomiony z $InstallDir"
    }
    if ($locked.Count) { Start-Sleep -Seconds 2 }

    Add-Type -AssemblyName System.IO.Compression.FileSystem
    function Expand-Zip($zip, $target) {
        # rozpakowuje zip do $target; jezeli w zipie jest jeden folder glowny, jego zawartosc
        $tmp = Join-Path $InstallDir ('_t' + [guid]::NewGuid().ToString('N').Substring(0, 6))
        [IO.Compression.ZipFile]::ExtractToDirectory($zip, $tmp)
        $items = @(Get-ChildItem $tmp)
        $root = if ($items.Count -eq 1 -and $items[0].PSIsContainer) { $items[0].FullName } else { $tmp }
        if (Test-Path $target) { Remove-Item $target -Recurse -Force }
        Move-Item $root $target
        if (Test-Path $tmp) { Remove-Item $tmp -Recurse -Force }
    }

    # --- 3. Node.js --------------------------------------------------------------------------
    Step "3. Instaluje Node.js $NodeVersion"
    Expand-Zip (Join-Path $pkgDir $NodeZip) $nodeDir
    Info (& (Join-Path $nodeDir 'node.exe') --version)

    # --- 4. Caddy ----------------------------------------------------------------------------
    Step "4. Instaluje Caddy $CaddyVersion"
    $tmpCaddy = Join-Path $InstallDir '_caddy'
    if (Test-Path $tmpCaddy) { Remove-Item $tmpCaddy -Recurse -Force }
    [IO.Compression.ZipFile]::ExtractToDirectory((Join-Path $pkgDir $CaddyZip), $tmpCaddy)
    New-Item -ItemType Directory -Force $caddyDir | Out-Null
    Copy-Item (Join-Path $tmpCaddy 'caddy.exe') $caddyDir -Force
    Remove-Item $tmpCaddy -Recurse -Force
    Info ((& (Join-Path $caddyDir 'caddy.exe') version) -split ' ')[0]

    # --- 5. Oracle Instant Client (opcjonalnie, dla Oracle 10/11) ------------------------------
    Step '5. Oracle Instant Client (tylko dla baz Oracle 10/11)'
    $ic = @(Get-ChildItem (Join-Path $src 'oracle') -Filter 'instantclient*.zip' -ErrorAction SilentlyContinue)
    if ($ic.Count -gt 0) {
        if (Test-Path $icDir) { Remove-Item $icDir -Recurse -Force }
        New-Item -ItemType Directory -Force $icDir | Out-Null
        foreach ($z in $ic) {
            $tmp = Join-Path $InstallDir '_ic'
            [IO.Compression.ZipFile]::ExtractToDirectory($z.FullName, $tmp)
            $inner = @(Get-ChildItem $tmp)
            $root = if ($inner.Count -eq 1 -and $inner[0].PSIsContainer) { $inner[0].FullName } else { $tmp }
            Copy-Item (Join-Path $root '*') $icDir -Recurse -Force
            Remove-Item $tmp -Recurse -Force
            Info "rozpakowano $($z.Name)"
        }
    } else {
        Info 'pominieto (brak pliku oracle\instantclient*.zip - dla Oracle 12 i nowszych nie jest potrzebny)'
    }

    # --- 6. aplikacja ------------------------------------------------------------------------
    Step '6. Instaluje pliki aplikacji'
    $appZip = @(Get-ChildItem (Join-Path $src 'app') -Filter '*.zip' -ErrorAction SilentlyContinue | Sort-Object Name)
    if ($appZip.Count -gt 1) { throw 'W folderze app moze byc tylko jeden plik zip z aplikacja.' }
    if ($appZip.Count -eq 1) {
        Expand-Zip $appZip[0].FullName $appDir
        Info "zainstalowano $($appZip[0].Name)"
    } else {
        if (Test-Path $appDir) { Remove-Item $appDir -Recurse -Force }
        Copy-Item (Join-Path $src 'templates\placeholder-app') $appDir -Recurse
        Info 'brak pliku app\*.zip - zainstalowano strone testowa (zastepcza aplikacja)'
    }
    # punkt startowy: pole "main" z package.json, domyslnie server.js
    $entry = 'server.js'
    $pkgJson = Join-Path $appDir 'package.json'
    if (Test-Path $pkgJson) {
        $main = (Get-Content $pkgJson -Raw | ConvertFrom-Json).main
        if ($main) { $entry = $main }
    }
    if (-not (Test-Path (Join-Path $appDir $entry))) { throw "Brak pliku startowego aplikacji: $entry" }
    Info "plik startowy: $entry"

    # dodatkowe kroki instalacji aplikacji (np. skrypty bazy) - plik setup.ps1 w paczce aplikacji
    $setup = Join-Path $appDir 'setup.ps1'
    if (Test-Path $setup) {
        Info 'uruchamiam setup.ps1 aplikacji'
        & $setup -InstallDir $InstallDir -Config $cfg
    }

    # --- 7. konfiguracja Caddy -----------------------------------------------------------------
    Step '7. Konfiguracja serwera WWW (Caddyfile)'
    $caddyfile = Join-Path $confDir 'Caddyfile'
    $custom = Join-Path $confDir 'Caddyfile.custom'
    if (Test-Path $custom) {
        Copy-Item $custom $caddyfile -Force
        Info 'uzyto wlasnego pliku config\Caddyfile.custom'
    } else {
        $site = if ($cfg.Domain) { $cfg.Domain } elseif ($localHttps) { 'localhost, 127.0.0.1' } else { ":$($cfg.HttpPort)" }
        $global = @()
        if ($cfg.Email) { $global += "    email $($cfg.Email)" }
        # certyfikat glowny Caddy dodaje do zaufanych instalator (krok 10), nie sama usluga
        if ($localHttps) { $global += '    skip_install_trust' }
        $text = (Get-Content (Join-Path $src 'templates\Caddyfile.template') -Raw).
            Replace('{{HTTP_PORT}}', [string]$cfg.HttpPort).
            Replace('{{HTTPS_PORT}}', [string]$cfg.HttpsPort).
            Replace('{{GLOBAL}}', ($global -join "`n")).
            Replace('{{SITE}}', $site).
            Replace('{{APP_PORT}}', [string]$cfg.AppPort).
            Replace('{{LOG_DIR}}', $logDir.Replace('\', '/'))
        [IO.File]::WriteAllText($caddyfile, $text, (New-Object Text.UTF8Encoding $false))
        Info $(if ($cfg.Domain) { "$baseUrl (certyfikat Let's Encrypt automatycznie)" }
            elseif ($localHttps) { "$baseUrl (lokalny certyfikat Caddy, http przekierowane na https)" }
            else { "$baseUrl (bez SSL)" })
    }
    $code = Invoke-Native (Join-Path $caddyDir 'caddy.exe') @('validate', '--config', $caddyfile, '--adapter', 'caddyfile')
    if ($code -ne 0) { throw "Bledny plik $caddyfile (sprawdz: caddy validate --config `"$caddyfile`")" }
    Info 'Caddyfile poprawny'

    # --- 8. pliki uslug (WinSW) ----------------------------------------------------------------
    Step '8. Pliki uslug Windows'
    $vars = @{
        '{{INSTALL_DIR}}' = $InstallDir
        '{{NODE_EXE}}'    = Join-Path $nodeDir 'node.exe'
        '{{APP_DIR}}'     = $appDir
        '{{APP_ENTRY}}'   = Join-Path $appDir $entry
        '{{APP_PORT}}'    = [string]$cfg.AppPort
        '{{CONF_DIR}}'    = $confDir
        '{{DATA_DIR}}'    = $dataDir
        '{{LOG_DIR}}'     = $logDir
        '{{DB_CONNECT}}'  = [string]$cfg.DbConnect
        '{{IC_DIR}}'      = $(if (Test-Path $icDir) { $icDir } else { '' })
        '{{CADDY_EXE}}'   = Join-Path $caddyDir 'caddy.exe'
        '{{CADDYFILE}}'   = $caddyfile
    }
    foreach ($s in $AppService, $CaddyService) {
        $xml = Get-Content (Join-Path $src "templates\$s.xml.template") -Raw
        foreach ($k in $vars.Keys) { $xml = $xml.Replace($k, [Security.SecurityElement]::Escape($vars[$k])) }
        [IO.File]::WriteAllText((Join-Path $svcDir "$s.xml"), $xml, (New-Object Text.UTF8Encoding $false))
        Copy-Item (Join-Path $pkgDir $WinSW) (Join-Path $svcDir "$s.exe") -Force
        Info "$s.xml"
    }

    # --- 9. uslugi ---------------------------------------------------------------------------
    if (-not $SkipServices) {
        Step '9. Rejestruje i uruchamiam uslugi'
        foreach ($s in $AppService, $CaddyService) {
            $exe = Join-Path $svcDir "$s.exe"
            if (Get-Service $s -ErrorAction SilentlyContinue) { Invoke-Native $exe @('uninstall') | Out-Null; Start-Sleep -Seconds 2 }
            if ((Invoke-Native $exe @('install')) -ne 0) { throw "Nie udalo sie zarejestrowac uslugi $s" }
            Start-Service $s
            Info "$s - uruchomiona"
        }
        # rejestracja uslugi od nowa kasuje jej uprawnienia - uzytkownik, ktory uruchomil instalacje,
        # dostaje prawo uruchamiania i restartu plansoft-web (potrzebne dla web\deploy.ps1)
        $sid = if ($UserSid) { $UserSid } else { [Security.Principal.WindowsIdentity]::GetCurrent().User.Value }
        $sddl = ((& sc.exe sdshow $AppService) | Where-Object { $_ -match '^D:' }) -join ''
        $ace = "(A;;RPWPLCLOCRRC;;;$sid)"
        if ($sddl -and -not $sddl.Contains($ace)) {
            $new = if ($sddl -match '^(D:.*?)(S:.*)$') { $Matches[1] + $ace + $Matches[2] } else { $sddl + $ace }
            if ((Invoke-Native 'sc.exe' @('sdset', $AppService, $new)) -eq 0) { Info "prawo restartu $AppService nadane (deploy.ps1)" }
            else { Info "UWAGA: nie udalo sie nadac prawa restartu $AppService" }
        }
    } else {
        Step '9. Uslugi - pominieto (-SkipServices)'
    }

    # --- 10. zapora i PATH ---------------------------------------------------------------------
    if ($cfg.OpenFirewall -and -not $SkipFirewall) {
        Step '10. Zapora Windows'
        foreach ($r in @(@{n='Plansoft.org Web (HTTP)'; p=$cfg.HttpPort}, @{n='Plansoft.org Web (HTTPS)'; p=$cfg.HttpsPort})) {
            Get-NetFirewallRule -DisplayName $r.n -ErrorAction SilentlyContinue | Remove-NetFirewallRule
            New-NetFirewallRule -DisplayName $r.n -Direction Inbound -Protocol TCP -LocalPort $r.p -Action Allow | Out-Null
            Info "otwarto port $($r.p)"
        }
    }
    if ($localHttps -and -not $SkipServices) {
        Step '10. Certyfikat https://localhost'
        # Caddy tworzy swoj urzad certyfikacji przy pierwszym starcie (folder data)
        $rootCrt = Join-Path $dataDir 'caddy\pki\authorities\local\root.crt'
        for ($i = 0; $i -lt 30 -and -not (Test-Path $rootCrt); $i++) { Start-Sleep -Seconds 1 }
        if (Test-Path $rootCrt) {
            $cert = Import-Certificate -FilePath $rootCrt -CertStoreLocation Cert:\LocalMachine\Root
            Info "dodano do zaufanych: $($cert.Subject)"
        } else {
            Write-Warning "Brak pliku $rootCrt - przegladarka pokaze ostrzezenie o certyfikacie"
        }
    }
    if ($cfg.AddNodeToPath -and (Test-Admin)) {
        $path = [Environment]::GetEnvironmentVariable('Path', 'Machine')
        if (($path -split ';') -notcontains $nodeDir) {
            [Environment]::SetEnvironmentVariable('Path', ($path.TrimEnd(';') + ';' + $nodeDir), 'Machine')
            Info "dopisano $nodeDir do PATH (nowe okna konsoli)"
        }
    }

    # --- 11. test ----------------------------------------------------------------------------
    if (-not $SkipServices) {
        Step '11. Test'
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        $url = "$baseUrl/health"
        $ok = $false
        for ($i = 0; $i -lt 15 -and -not $ok; $i++) {
            try { $r = Invoke-WebRequest $url -UseBasicParsing -TimeoutSec 5; $ok = $r.StatusCode -eq 200 } catch { Start-Sleep -Seconds 2 }
        }
        if ($ok) { Info "OK  $url" } else { Write-Warning "Brak odpowiedzi z $url - sprawdz logi w $logDir" }
    }

    Write-Host ''
    Write-Host 'Instalacja zakonczona.' -ForegroundColor Green
    if (-not $SkipServices) {
        Write-Host "Strona: $baseUrl/"
    }
} catch {
    Write-Host ''
    Write-Host "BLAD: $($_.Exception.Message)" -ForegroundColor Red
    Stop-Transcript | Out-Null
    exit 1
}
Stop-Transcript | Out-Null
exit 0
