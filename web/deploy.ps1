# Szybkie wdrozenie zmian z folderu web do zainstalowanej aplikacji (bez install.cmd).
# Kopiuje tylko zmienione pliki; restartuje usluge plansoft-web tylko wtedy, gdy zmienil sie kod serwera
# (zmiany w public\ - strona - widac od razu po odswiezeniu przegladarki).
# Uruchom: powershell -ExecutionPolicy Bypass -File deploy.ps1
# Restart uslugi bez uprawnien administratora: jednorazowo uruchom grant-restart.ps1.
param(
    [string]$InstallDir,
    [switch]$NoRestart
)

$ErrorActionPreference = 'Stop'
$src = $PSScriptRoot
$cfg = Import-PowerShellDataFile (Join-Path $src '..\cd\Install_NodeJS\install.config.psd1')
if (-not $InstallDir) { $InstallDir = $cfg.InstallDir }
$app = Join-Path $InstallDir 'app'
if (-not (Test-Path (Join-Path $app 'server.js'))) { throw "Brak zainstalowanej aplikacji w $app - najpierw uruchom install.cmd" }

# robocopy: kod 0 = bez zmian, 1-7 = skopiowano/usunieto pliki, 8+ = blad
function Sync($from, $to, [switch]$Mirror, [string[]]$files) {
    $opts = @('/NJH', '/NJS', '/NDL', '/NP', '/R:1', '/W:1')
    if ($Mirror) { $opts += '/MIR' }
    if ($files) { & robocopy $from $to @files @opts | Out-Null } else { & robocopy $from $to @opts | Out-Null }
    if ($LASTEXITCODE -ge 8) { throw "Blad kopiowania $from -> $to (robocopy $LASTEXITCODE)" }
    return ($LASTEXITCODE -band 3) -ne 0
}

$sw = [Diagnostics.Stopwatch]::StartNew()
# poprzednie wdrozenie skopiowalo kod serwera, ale usluga nie zostala zrestartowana
$pendingMark = Join-Path $app '.restart-pending'
$serverChanged = Test-Path $pendingMark
$serverChanged = (Sync $src $app -files @('server.js', 'package.json', 'package-lock.json')) -or $serverChanged
$serverChanged = (Sync (Join-Path $src 'lib') (Join-Path $app 'lib') -Mirror) -or $serverChanged
$pageChanged   = Sync (Join-Path $src 'public') (Join-Path $app 'public') -Mirror

# biblioteki tylko po zmianie zaleznosci (package-lock.json) - folder web\node_modules przygotowuje build.ps1 / npm ci
$lockSrc = (Get-FileHash (Join-Path $src 'package-lock.json')).Hash
$lockMark = Join-Path $app 'node_modules\.deployed-lock'
$lockApp = if (Test-Path $lockMark) { Get-Content $lockMark -Raw } else { '' }
if ($lockSrc -ne $lockApp.Trim()) {
    if (-not (Test-Path (Join-Path $src 'node_modules'))) { throw 'Brak web\node_modules - uruchom: npm ci --omit=dev' }
    Write-Host 'Kopiuje node_modules (zmienily sie zaleznosci)...'
    Sync (Join-Path $src 'node_modules') (Join-Path $app 'node_modules') -Mirror | Out-Null
    Set-Content $lockMark $lockSrc
    $serverChanged = $true
}

if (-not $serverChanged -and -not $pageChanged) { Write-Host 'Bez zmian.'; exit 0 }
if ($pageChanged) { Write-Host 'Strona (public) zaktualizowana - odswiez przegladarke (Ctrl+F5).' }

if ($serverChanged -and -not $NoRestart) {
    Write-Host 'Restart uslugi plansoft-web...'
    try {
        Restart-Service plansoft-web -ErrorAction Stop
        Remove-Item $pendingMark -ErrorAction SilentlyContinue
    } catch {
        Set-Content $pendingMark (Get-Date -Format s)
        Write-Warning 'Nie udalo sie zrestartowac uslugi (brak uprawnien?). Uruchom jednorazowo grant-restart.ps1 albo zrestartuj usluge jako administrator.'
        exit 1
    }
    # czekamy, az aplikacja odpowie
    $ok = $false
    for ($i = 0; $i -lt 20 -and -not $ok; $i++) {
        Start-Sleep -Milliseconds 500
        try { $ok = (Invoke-WebRequest "http://127.0.0.1:$($cfg.AppPort)/health" -UseBasicParsing -TimeoutSec 2).StatusCode -eq 200 } catch { }
    }
    if (-not $ok) { Write-Warning "Aplikacja nie odpowiada - sprawdz $InstallDir\logs\plansoft-web.err.log"; exit 1 }
    Write-Host 'Usluga dziala. Uwaga: po restarcie trzeba zalogowac sie ponownie.'
} elseif ($serverChanged) {
    Set-Content $pendingMark (Get-Date -Format s)
    Write-Host 'Kod serwera skopiowany - zmiany zadzialaja po restarcie uslugi plansoft-web.'
}
Write-Host ("Gotowe ({0:N1} s)." -f $sw.Elapsed.TotalSeconds)
