# Pakuje aplikację do pliku zip dla instalatora (cd\Install_NodeJS\app\plansoft-web.zip).
# Paczka zawiera node_modules, więc instalacja u klienta nie potrzebuje internetu.
# Uruchom: powershell -ExecutionPolicy Bypass -File build.ps1
param([string]$Npm)

$ErrorActionPreference = 'Stop'
$src = $PSScriptRoot

# domyslnie npm z zainstalowanego Node.js (ta sama wersja, na ktorej dziala aplikacja), a nie z systemowego PATH
if (-not $Npm) {
    $cfg = Import-PowerShellDataFile (Join-Path $src '..\cd\Install_NodeJS\install.config.psd1')
    $nodeDir = Join-Path $cfg.InstallDir 'node'
    $Npm = if (Test-Path (Join-Path $nodeDir 'npm.cmd')) { Join-Path $nodeDir 'npm.cmd' } else { 'npm' }
    # npm.cmd uruchamia node.exe z PATH - najpierw ten z instalacji
    if (Test-Path (Join-Path $nodeDir 'node.exe')) { $env:Path = "$nodeDir;$env:Path" }
}
Write-Host "npm: $Npm"
$appOut = Join-Path $src '..\cd\Install_NodeJS\app'
$version = (Get-Content (Join-Path $src 'package.json') -Raw | ConvertFrom-Json).version

Push-Location $src
try {
    & $Npm ci --omit=dev --no-audit --no-fund
    if ($LASTEXITCODE -ne 0) { throw 'npm ci nie powiodlo sie' }
} finally { Pop-Location }

$stage = Join-Path $env:TEMP ('plansoft-web-build-' + [guid]::NewGuid().ToString('N').Substring(0, 6))
New-Item -ItemType Directory $stage | Out-Null
foreach ($item in 'server.js', 'package.json', 'package-lock.json', 'lib', 'public', 'node_modules') {
    Copy-Item (Join-Path $src $item) $stage -Recurse
}

# w folderze app instalatora moze byc tylko jedna paczka
Get-ChildItem $appOut -Filter 'plansoft-web*.zip' | Remove-Item
$zip = Join-Path ([IO.Path]::GetFullPath($appOut)) "plansoft-web-$version.zip"
Add-Type -AssemblyName System.IO.Compression.FileSystem
[IO.Compression.ZipFile]::CreateFromDirectory($stage, $zip)
Remove-Item $stage -Recurse -Force
Write-Host "Gotowe: $zip"
