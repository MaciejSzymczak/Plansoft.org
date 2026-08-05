# Wymaga uruchomienia z uprawnieniami administratora (patrz autoRun.readme).
# Wykonuje po kolei: tworzenie iCalendarzy, publikacje iCalendarzy, wysylke SFTP, backup bazy danych.

$ErrorActionPreference = "Continue"

$logFile = Join-Path $PSScriptRoot "autoRun.log"

function Invoke-Step {
    param(
        [string]$Path
    )

    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

    if (-not (Test-Path $Path)) {
        Add-Content -Path $logFile -Value "$timestamp BLAD: nie znaleziono pliku $Path"
        return
    }

    Add-Content -Path $logFile -Value "$timestamp START: $Path"

    try {
        $proc = Start-Process -FilePath $Path -Wait -PassThru -NoNewWindow
        $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        Add-Content -Path $logFile -Value "$timestamp KONIEC: $Path (kod wyjscia: $($proc.ExitCode))"
    }
    catch {
        $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        Add-Content -Path $logFile -Value "$timestamp WYJATEK przy uruchamianiu $Path : $($_.Exception.Message)"
    }
}

Add-Content -Path $logFile -Value "===== START autoRun.ps1: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') ====="

Invoke-Step "E:\iKalendarze\bin\ICSCREATION.exe"
Invoke-Step "E:\iKalendarze\bin\ICSPUBLICATION.exe"
Invoke-Step "E:\iKalendarze\bin\SFTP.exe"
Invoke-Step "E:\backups\DBBACKUP.exe"

Add-Content -Path $logFile -Value "===== KONIEC autoRun.ps1: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') ====="
