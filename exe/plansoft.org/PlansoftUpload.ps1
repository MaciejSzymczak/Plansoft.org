# Upload to https://plansoft.org/wp-content/uploads/pdf/ via WinSCP - shared by install.ps1 and PublishDoc.ps1.
# Usage (dot-source):  . (Join-Path $PSScriptRoot "PlansoftUpload.ps1")
#                      Send-PlansoftFiles -Files $paths [-Delete] [-Password $pwd] [-ResetPassword]
#
# Password - never stored in the scripts or in the repository. Taken from, in this order:
#   1. -Password parameter (SecureString or plain string),
#   2. the saved file %APPDATA%\Plansoft\watbackup.password.xml - encrypted with Windows DPAPI, readable only by
#      the same Windows user on the same computer,
#   3. a prompt (the entered password is then saved to the file from point 2).
# -ResetPassword ignores the saved password, asks again and saves the new one.
# The password reaches WinSCP through an environment variable of the WinSCP process only - it is not written to the
# WinSCP script file and it is not visible on the command line.

$PlansoftFtpHost        = "soft.home.pl"
$PlansoftFtpUser        = "watbackup"
$PlansoftFtpCertificate = "31:40:50:99:10:cf:5a:d4:75:7a:ce:28:97:74:d0:c7:e8:80:91:6b"
$PlansoftRemoteDir      = "/plansoft/wp-content/uploads/pdf"
$PlansoftPasswordFile   = Join-Path $env:APPDATA "Plansoft\watbackup.password.xml"

function Get-PlansoftFtpPassword {
    param($Password, [switch]$ResetPassword)

    if ($Password) {
        if ($Password -is [System.Security.SecureString]) { return $Password }
        return (ConvertTo-SecureString ([string]$Password) -AsPlainText -Force)
    }
    if ((-not $ResetPassword) -and (Test-Path $PlansoftPasswordFile)) {
        return (Import-Clixml $PlansoftPasswordFile)
    }
    $secure = Read-Host -AsSecureString "Password for FTP user $PlansoftFtpUser@$PlansoftFtpHost"
    if ($secure.Length -eq 0) {
        throw "No password given."
    }
    New-Item -ItemType Directory -Force (Split-Path $PlansoftPasswordFile) | Out-Null
    $secure | Export-Clixml $PlansoftPasswordFile
    Write-Host "Password saved (DPAPI, this Windows user only): $PlansoftPasswordFile"
    return $secure
}

function Send-PlansoftFiles {
    param(
        [Parameter(Mandatory = $true)] [string[]]$Files,
        [switch]$Delete,          # remove the local file after a successful upload (WinSCP put -delete)
        $Password,
        [switch]$ResetPassword
    )

    $winscp = "C:\Program Files (x86)\WinSCP\WinSCP.com"
    if (-not (Test-Path $winscp)) {
        $winscp = "C:\Program Files\WinSCP\WinSCP.com"
    }
    if (-not (Test-Path $winscp)) {
        throw "WinSCP.com not found - is WinSCP installed?"
    }

    $secure = Get-PlansoftFtpPassword -Password $Password -ResetPassword:$ResetPassword
    $bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secure)
    try {
        $plain = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($bstr)
    }
    finally {
        [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr)
    }

    $putSwitch = if ($Delete) { "put -delete" } else { "put" }
    $puts = ($Files | ForEach-Object { "$putSwitch `"$_`"" }) -join "`r`n"
    # %PLANSOFT_FTP_PASSWORD% is expanded by WinSCP from its own environment
    $winscpScript = @"
option batch abort
option confirm off
open ftps://${PlansoftFtpUser}:%PLANSOFT_FTP_PASSWORD%@$PlansoftFtpHost/ -certificate="$PlansoftFtpCertificate"
cd $PlansoftRemoteDir
$puts
close
exit
"@

    $scriptFile = Join-Path ([System.IO.Path]::GetTempPath()) ("plansoft_winscp_" + [guid]::NewGuid().ToString("N") + ".txt")
    Set-Content -Path $scriptFile -Value $winscpScript -Encoding ASCII

    $env:PLANSOFT_FTP_PASSWORD = [uri]::EscapeDataString($plain)
    $plain = $null
    try {
        & $winscp /ini=nul /script=$scriptFile
        if ($LASTEXITCODE -ne 0) {
            throw "WinSCP upload failed with exit code $LASTEXITCODE (wrong password? run again with -ResetPassword)"
        }
    }
    finally {
        Remove-Item Env:\PLANSOFT_FTP_PASSWORD -ErrorAction SilentlyContinue
        Remove-Item $scriptFile -Force -ErrorAction SilentlyContinue
    }
}
