# Usuwa uslugi i reguly zapory srodowiska Plansoft.org Web.
# Pliki w folderze instalacji zostaja (config, data z certyfikatami SSL, logs) - usun je recznie, jezeli trzeba.
param([string]$ConfigFile = (Join-Path $PSScriptRoot 'install.config.psd1'))

$ErrorActionPreference = 'Stop'
$id = [Security.Principal.WindowsIdentity]::GetCurrent()
if (-not (New-Object Security.Principal.WindowsPrincipal $id).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    $p = Start-Process powershell.exe -Verb RunAs -Wait -PassThru -ArgumentList @('-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', "`"$PSCommandPath`"", '-ConfigFile', "`"$ConfigFile`"")
    exit $p.ExitCode
}

$cfg = Import-PowerShellDataFile $ConfigFile
$svcDir = Join-Path $cfg.InstallDir 'service'
foreach ($s in 'plansoft-caddy', 'plansoft-web') {
    if (Get-Service $s -ErrorAction SilentlyContinue) {
        Stop-Service $s -Force
        & (Join-Path $svcDir "$s.exe") uninstall | Out-Null
        Write-Host "usunieto usluge $s"
    }
}
foreach ($n in 'Plansoft.org Web (HTTP)', 'Plansoft.org Web (HTTPS)') {
    Get-NetFirewallRule -DisplayName $n -ErrorAction SilentlyContinue | Remove-NetFirewallRule
}
# certyfikat glowny Caddy dla https://localhost (dodany przez install.ps1)
$rootCrt = Join-Path $cfg.InstallDir 'data\caddy\pki\authorities\local\root.crt'
if (Test-Path $rootCrt) {
    $thumb = (New-Object Security.Cryptography.X509Certificates.X509Certificate2 $rootCrt).Thumbprint
    Get-ChildItem Cert:\LocalMachine\Root | Where-Object Thumbprint -eq $thumb | Remove-Item
    Write-Host 'usunieto certyfikat https://localhost z zaufanych'
}
Write-Host "Gotowe. Pliki zostaly w $($cfg.InstallDir)."
