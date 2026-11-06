# Jednorazowo: pozwala biezacemu uzytkownikowi Windows uruchamiac, zatrzymywac i restartowac usluge
# plansoft-web bez uprawnien administratora (potrzebne dla deploy.ps1). Wymaga potwierdzenia administratora.
# Cofniecie: grant-restart.ps1 -Remove
param([string]$Sid, [switch]$Remove)

$ErrorActionPreference = 'Stop'
$service = 'plansoft-web'
if (-not $Sid) { $Sid = [Security.Principal.WindowsIdentity]::GetCurrent().User.Value }

$id = [Security.Principal.WindowsIdentity]::GetCurrent()
if (-not (New-Object Security.Principal.WindowsPrincipal $id).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    # uprawnienia nadajemy uzytkownikowi, ktory uruchomil skrypt (SID przekazany do procesu administratora)
    $argList = @('-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', "`"$PSCommandPath`"", '-Sid', $Sid)
    if ($Remove) { $argList += '-Remove' }
    $p = Start-Process powershell.exe -Verb RunAs -Wait -PassThru -ArgumentList $argList
    exit $p.ExitCode
}

try {
    $sddl = ((& sc.exe sdshow $service) | Where-Object { $_ -match '^D:' }) -join ''
    if (-not $sddl) { throw "Nie znaleziono uslugi $service" }
    # RP = uruchom, WP = zatrzymaj, LC = stan, LO = odpytaj, CR = sterowanie, RC = odczyt uprawnien
    $ace = "(A;;RPWPLCLOCRRC;;;$Sid)"
    $clean = $sddl -replace [regex]::Escape($ace), ''
    if ($Remove) {
        $new = $clean
    } else {
        if ($sddl.Contains($ace)) { Write-Host 'Uprawnienie juz nadane.'; Read-Host 'Enter, aby zamknac' | Out-Null; exit 0 }
        # nowy wpis na koncu czesci D: (przed ewentualna czescia S:)
        $new = if ($clean -match '^(D:.*?)(S:.*)$') { $Matches[1] + $ace + $Matches[2] } else { $clean + $ace }
    }
    & sc.exe sdset $service $new | Out-Null
    if ($LASTEXITCODE -ne 0) { throw "sc sdset nie powiodlo sie ($LASTEXITCODE)" }
    $who = (New-Object Security.Principal.SecurityIdentifier $Sid).Translate([Security.Principal.NTAccount]).Value
    Write-Host $(if ($Remove) { "Odebrano uzytkownikowi $who prawo restartu uslugi $service." } else { "Uzytkownik $who moze teraz restartowac usluge $service (deploy.ps1)." })
} catch {
    Write-Host "BLAD: $($_.Exception.Message)" -ForegroundColor Red
    Read-Host 'Enter, aby zamknac' | Out-Null
    exit 1
}
Read-Host 'Enter, aby zamknac' | Out-Null
