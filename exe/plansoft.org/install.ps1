# Rebuilds install.exe from install.nsi and packages it into install.zip.

# Execution - run powershell
# cd "C:\Users\Maciek\Documents\GitHub\Plansoft2.org\exe\plansoft.org"
# Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
# .\install.ps1

$ErrorActionPreference = "Stop"

$root = $PSScriptRoot
$exePath = Join-Path $root "install.exe"
$zipPath = Join-Path $root "install.zip"
$nsiPath = Join-Path $root "install.nsi"

$makensis = "C:\Program Files (x86)\NSIS\makensis.exe"
if (-not (Test-Path $makensis)) {
    $makensis = "C:\Program Files\NSIS\makensis.exe"
}
if (-not (Test-Path $makensis)) {
    throw "makensis.exe not found - is NSIS installed?"
}

if (Test-Path $exePath) {
    Remove-Item $exePath -Force
}
if (Test-Path $zipPath) {
    Remove-Item $zipPath -Force
}

& $makensis $nsiPath
if ($LASTEXITCODE -ne 0) {
    throw "makensis failed with exit code $LASTEXITCODE"
}

if (-not (Test-Path $exePath)) {
    throw "install.exe was not created by makensis"
}

Compress-Archive -Path $exePath -DestinationPath $zipPath -Force

Write-Output "Done: $exePath and $zipPath rebuilt."

$winscp = "C:\Program Files (x86)\WinSCP\WinSCP.com"
if (-not (Test-Path $winscp)) {
    $winscp = "C:\Program Files\WinSCP\WinSCP.com"
}
if (-not (Test-Path $winscp)) {
    throw "WinSCP.com not found - is WinSCP installed?"
}

$remoteDir = "/plansoft/wp-content/uploads/pdf"
$winscpScript = @"
option batch abort
option confirm off
open watbackup
cd $remoteDir
put "$exePath"
put "$zipPath"
close
exit
"@

$scriptFile = Join-Path $root "install_winscp_script.tmp.txt"
Set-Content -Path $scriptFile -Value $winscpScript -Encoding ASCII

try {
    & $winscp /script=$scriptFile
    if ($LASTEXITCODE -ne 0) {
        throw "WinSCP upload failed with exit code $LASTEXITCODE"
    }
    Write-Output "Uploaded install.exe and install.zip to $remoteDir via watbackup."
}
finally {
    Remove-Item $scriptFile -Force -ErrorAction SilentlyContinue
}
