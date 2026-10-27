# Rebuilds install.exe from install.nsi and packages it into install.zip.

# Execution - run powershell
# cd "C:\Users\Maciek\Documents\GitHub\Plansoft2.org\exe\plansoft.org"
# Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
# .\install.ps1
# Password for the upload: see PlansoftUpload.ps1 (saved encrypted for this Windows user after the first prompt).
#   .\install.ps1 -Password <password>   - pass it as a parameter (it is then not saved)
#   .\install.ps1 -ResetPassword         - ask for it again and save the new one

param(
    $Password,
    [switch]$ResetPassword
)

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

# install.exe right after makensis is often still locked (e.g. Windows Defender scanning it) - retry.
# -ErrorAction Stop: Compress-Archive reports this with a non-terminating Write-Error, which
# $ErrorActionPreference set in this script does not stop, so the script went on to upload without a zip.
$maxAttempts = 10
for ($attempt = 1; $attempt -le $maxAttempts; $attempt++) {
    try {
        Compress-Archive -Path $exePath -DestinationPath $zipPath -Force -ErrorAction Stop
        break
    }
    catch {
        if ($attempt -eq $maxAttempts) {
            throw "Compress-Archive failed after $maxAttempts attempts: $($_.Exception.Message)"
        }
        Write-Output "install.exe is locked by another process, retrying in 3 s ($attempt/$maxAttempts)..."
        Start-Sleep -Seconds 3
    }
}

if (-not (Test-Path $zipPath)) {
    throw "install.zip was not created"
}

Write-Output "Done: $exePath and $zipPath rebuilt."

. (Join-Path $root "PlansoftUpload.ps1")
Send-PlansoftFiles -Files @($exePath, $zipPath) -Password $Password -ResetPassword:$ResetPassword
Write-Output "Uploaded install.exe and install.zip to $PlansoftRemoteDir."
