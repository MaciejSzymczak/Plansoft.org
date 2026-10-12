<#
================================================================================
 InstallPlansoftOrgClient.ps1 - instalacja klienta plansoft.org
================================================================================

 CO ROBI SKRYPT (kolejno):

   1a. Pobiera, rozpakowuje i uruchamia instalator programu Planowanie:
         http://plansoft.org/wp-content/uploads/pdf/install.zip  (zawiera install.exe)

   2a. Pobiera pakiet klienta Oracle:
         http://plansoft.org/wp-content/uploads/pdf/installClient_21C.zip
       i rozpakowuje go. Hasło do pliku: !OpenPassword!

   2b. Rozpakowuje ODAC21.12Xcopy_x86.zip do folderu Downloads\ODACInstall,
       a następnie wykonuje polecenia:
         cd Downloads
         cd ODACInstall
         install.bat ALL c:\odac odac

   2c. Dodaje ścieżkę "C:\odac\bin" do zmiennej środowiskowej PATH (systemowej).

   2d. Uruchamia Oracle-Client-for-Microsoft-Tools-32-bit.exe
       Akceptuj wartości domyślne (Setup Type=Default, Destination Location),
       a na ekranie "Oracle Configuration File directory" wskaż folder
       "C:\odac\network\admin".

 WYMAGANIA:
   - Uprawnienia administratora (skrypt sam poprosi o podniesienie uprawnień),
     bo install.bat z ODAC rejestruje komponenty w systemie, a PATH jest systemowy.
   - 7-Zip (C:\Program Files\7-Zip\7z.exe) - archiwum installClient_21C.zip
     jest zaszyfrowane hasłem, a wbudowane Expand-Archive nie obsługuje haseł.
     Pobierz: https://www.7-zip.org

 URUCHOMIENIE:
   powershell -ExecutionPolicy Bypass -File InstallPlansoftOrgClient.ps1
   powershell -ExecutionPolicy Bypass -File InstallPlansoftOrgClient.ps1 -DryRun

   -DryRun : tylko wypisuje, co zostałoby zrobione. Niczego nie pobiera,
             nie rozpakowuje, nie uruchamia i nie zmienia w systemie.

 Zgodny z Windows PowerShell 5.1.
================================================================================
#>

param(
    [switch]$DryRun
)

$ErrorActionPreference = 'Stop'
$ProgressPreference    = 'SilentlyContinue'   # w PS 5.1 pasek postępu bardzo spowalnia Invoke-WebRequest

#-------------------------------------------------------------------------------
# Ustawienia
#-------------------------------------------------------------------------------
$PlansoftZipUrl = 'http://plansoft.org/wp-content/uploads/pdf/install.zip'
$ClientZipUrl   = 'http://plansoft.org/wp-content/uploads/pdf/installClient_21C.zip'
$ClientZipPass  = '!OpenPassword!'
$OdacHome       = 'c:\odac'
$OdacHomeName   = 'odac'
$OdacBin        = 'C:\odac\bin'
$OdacTnsAdmin   = 'C:\odac\network\admin'

#-------------------------------------------------------------------------------
# Funkcje pomocnicze
#-------------------------------------------------------------------------------
function Write-Step([string]$Text) {
    Write-Host ''
    Write-Host ('=== ' + $Text) -ForegroundColor Cyan
}

# Wykonuje akcję albo (w trybie -DryRun) tylko ją opisuje.
function Invoke-Action([string]$Description, [scriptblock]$Action) {
    if ($DryRun) {
        Write-Host ('[DRY-RUN] ' + $Description) -ForegroundColor Yellow
    } else {
        Write-Host ('  -> ' + $Description)
        & $Action
    }
}

function Test-IsAdmin {
    $id = [Security.Principal.WindowsIdentity]::GetCurrent()
    return (New-Object Security.Principal.WindowsPrincipal($id)).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Get-DownloadsFolder {
    # Folder "Pobrane" może być przeniesiony przez użytkownika - pytamy powłokę Windows
    try {
        $path = (New-Object -ComObject Shell.Application).NameSpace('shell:Downloads').Self.Path
        if ($path -and (Test-Path $path)) { return $path }
    } catch { }
    return (Join-Path $env:USERPROFILE 'Downloads')
}

function Get-SevenZip {
    $candidates = @(
        (Join-Path $env:ProgramFiles '7-Zip\7z.exe'),
        (Join-Path ${env:ProgramFiles(x86)} '7-Zip\7z.exe')
    )
    foreach ($c in $candidates) { if ($c -and (Test-Path $c)) { return $c } }
    return $null
}

function Save-Url([string]$Url, [string]$Target) {
    Invoke-Action ("Pobieranie $Url -> $Target") {
        Invoke-WebRequest -Uri $Url -OutFile $Target -UseBasicParsing
    }
}

# Rozpakowanie przez 7-Zip (opcjonalnie z hasłem); -y nadpisuje istniejące pliki
function Expand-With7Zip([string]$Archive, [string]$Destination, [string]$Password) {
    $desc = "Rozpakowanie $Archive -> $Destination"
    if ($Password) { $desc += ' (z hasłem)' }
    Invoke-Action $desc {
        $args7z = @('x', '-y', ('-o' + $Destination))
        if ($Password) { $args7z += ('-p' + $Password) }
        $args7z += $Archive
        & $script:SevenZip @args7z | Out-Null
        if ($LASTEXITCODE -ne 0) { throw "7-Zip zakończył się błędem ($LASTEXITCODE) dla $Archive - sprawdź hasło/plik." }
    }
}

# Wysyła WM_SETTINGCHANGE, żeby nowo uruchamiane programy widziały nowy PATH bez wylogowania
function Send-EnvironmentChanged {
    if (-not ('Win32.EnvNotify' -as [type])) {
        Add-Type -Namespace Win32 -Name EnvNotify -MemberDefinition @'
[DllImport("user32.dll", SetLastError = true, CharSet = CharSet.Auto)]
public static extern IntPtr SendMessageTimeout(IntPtr hWnd, uint Msg, UIntPtr wParam, string lParam,
    uint fuFlags, uint uTimeout, out UIntPtr lpdwResult);
'@
    }
    $result = [UIntPtr]::Zero
    [void][Win32.EnvNotify]::SendMessageTimeout([IntPtr]0xffff, 0x1A, [UIntPtr]::Zero, 'Environment', 2, 5000, [ref]$result)
}

#-------------------------------------------------------------------------------
# Start: uprawnienia administratora i 7-Zip
#-------------------------------------------------------------------------------
if (-not $DryRun -and -not (Test-IsAdmin)) {
    Write-Host 'Skrypt wymaga uprawnień administratora - ponowne uruchomienie z podniesionymi uprawnieniami...' -ForegroundColor Yellow
    Start-Process -FilePath 'powershell.exe' -Verb RunAs -ArgumentList @(
        '-NoProfile', '-ExecutionPolicy', 'Bypass', '-NoExit', '-File', ('"' + $PSCommandPath + '"')
    )
    exit
}

$script:SevenZip = Get-SevenZip
if (-not $script:SevenZip) {
    $msg = 'Nie znaleziono 7-Zip (7z.exe). Zainstaluj 7-Zip z https://www.7-zip.org i uruchom skrypt ponownie.'
    if ($DryRun) { Write-Host ('[DRY-RUN] UWAGA: ' + $msg) -ForegroundColor Red } else { throw $msg }
}

$Downloads   = Get-DownloadsFolder
$PlansoftZip = Join-Path $Downloads 'install.zip'
$PlansoftDir = Join-Path $Downloads 'PlansoftInstall'
$ClientZip   = Join-Path $Downloads 'installClient_21C.zip'
$ClientDir   = Join-Path $Downloads 'installClient_21C'
$OdacDir     = Join-Path $Downloads 'ODACInstall'

Write-Host ('Folder Pobrane: ' + $Downloads)
if ($DryRun) { Write-Host 'TRYB -DryRun: nic nie zostanie pobrane, uruchomione ani zmienione.' -ForegroundColor Yellow }

#-------------------------------------------------------------------------------
# 1a. Pobierz, rozpakuj i uruchom install.zip (program Planowanie)
#-------------------------------------------------------------------------------
Write-Step '1a. Instalator programu Planowanie (install.zip)'
Save-Url $PlansoftZipUrl $PlansoftZip
Expand-With7Zip $PlansoftZip $PlansoftDir $null
Invoke-Action ("Uruchomienie $PlansoftDir\install.exe (czekam na zakończenie)") {
    $exe = Get-ChildItem -Path $PlansoftDir -Filter 'install.exe' -Recurse | Select-Object -First 1
    if (-not $exe) { throw "Nie znaleziono install.exe w $PlansoftDir" }
    Start-Process -FilePath $exe.FullName -WorkingDirectory $exe.DirectoryName -Wait
}

#-------------------------------------------------------------------------------
# 2a. Pobierz i rozpakuj installClient_21C.zip (hasło: !OpenPassword!)
#-------------------------------------------------------------------------------
Write-Step '2a. Pakiet klienta Oracle (installClient_21C.zip)'
Save-Url $ClientZipUrl $ClientZip
Expand-With7Zip $ClientZip $ClientDir $ClientZipPass

#-------------------------------------------------------------------------------
# 2b. Rozpakuj ODAC21.12Xcopy_x86.zip do Downloads\ODACInstall
#     i wykonaj: install.bat ALL c:\odac odac
#-------------------------------------------------------------------------------
Write-Step '2b. ODAC: rozpakowanie i install.bat ALL c:\odac odac'
Invoke-Action ("Wyszukanie ODAC21.12Xcopy_x86.zip w $ClientDir i rozpakowanie do $OdacDir") {
    $odacZip = Get-ChildItem -Path $ClientDir -Filter 'ODAC21.12Xcopy_x86.zip' -Recurse | Select-Object -First 1
    if (-not $odacZip) { throw "Nie znaleziono ODAC21.12Xcopy_x86.zip w $ClientDir" }
    Expand-With7Zip $odacZip.FullName $OdacDir $null
}
Invoke-Action ("cd $OdacDir ; install.bat ALL $OdacHome $OdacHomeName") {
    $bat = Join-Path $OdacDir 'install.bat'
    if (-not (Test-Path $bat)) { throw "Nie znaleziono $bat" }
    Push-Location $OdacDir
    try {
        & cmd.exe /c "install.bat ALL $OdacHome $OdacHomeName"
        if ($LASTEXITCODE -ne 0) { throw "install.bat zakończył się kodem $LASTEXITCODE" }
    } finally {
        Pop-Location
    }
}

#-------------------------------------------------------------------------------
# 2c. Dodaj C:\odac\bin do systemowej zmiennej PATH
#     PATH czytamy i zapisujemy bezpośrednio w rejestrze jako REG_EXPAND_SZ,
#     żeby nie rozwinąć istniejących wpisów typu %SystemRoot%. Nie używamy setx
#     (obcina PATH do 1024 znaków). Jeśli ścieżka już jest - nic nie zmieniamy.
#-------------------------------------------------------------------------------
Write-Step "2c. Dodanie $OdacBin do zmiennej PATH"
$envKeyPath = 'SYSTEM\CurrentControlSet\Control\Session Manager\Environment'
$envKeyRO   = [Microsoft.Win32.Registry]::LocalMachine.OpenSubKey($envKeyPath, $false)
$machinePath = [string]$envKeyRO.GetValue('Path', '', [Microsoft.Win32.RegistryValueOptions]::DoNotExpandEnvironmentNames)
$envKeyRO.Close()
$alreadyThere = $machinePath.Split(';') | Where-Object { $_.Trim().TrimEnd('\') -ieq $OdacBin.TrimEnd('\') }
if ($alreadyThere) {
    Write-Host "  -> $OdacBin jest już w PATH - bez zmian."
} else {
    Invoke-Action ("Dopisanie $OdacBin na końcu systemowego PATH") {
        $envKey = [Microsoft.Win32.Registry]::LocalMachine.OpenSubKey($envKeyPath, $true)
        try {
            $envKey.SetValue('Path', ($machinePath.TrimEnd(';') + ';' + $OdacBin), [Microsoft.Win32.RegistryValueKind]::ExpandString)
        } finally {
            $envKey.Close()
        }
        Send-EnvironmentChanged
        $env:Path = $env:Path.TrimEnd(';') + ';' + $OdacBin   # także dla bieżącej sesji
    }
}

#-------------------------------------------------------------------------------
# 2d. Uruchom Oracle-Client-for-Microsoft-Tools-32-bit.exe (instalacja ręczna)
#     Akceptuj wartości domyślne (Setup Type=Default, Destination Location),
#     a na ekranie "Oracle Configuration File directory" wskaż C:\odac\network\admin
#     Uwaga: w archiwum plik nazywa się "Oracle-Client-for-Microsoft-Tools-32-bit .exe"
#     (ze spacją przed .exe) - dlatego szukamy go wzorcem.
#-------------------------------------------------------------------------------
Write-Step '2d. Oracle Client for Microsoft Tools (32-bit)'
Write-Host '  W instalatorze:' -ForegroundColor Green
Write-Host '   - akceptuj wartości domyślne (Setup Type = Default, Destination Location),' -ForegroundColor Green
Write-Host ("   - na ekranie 'Oracle Configuration File directory' wskaż: $OdacTnsAdmin") -ForegroundColor Green
Invoke-Action ("Uruchomienie Oracle-Client-for-Microsoft-Tools-32-bit*.exe z $ClientDir (czekam na zakończenie)") {
    $oc = Get-ChildItem -Path $ClientDir -Filter 'Oracle-Client-for-Microsoft-Tools-32-bit*.exe' -Recurse | Select-Object -First 1
    if (-not $oc) { throw "Nie znaleziono Oracle-Client-for-Microsoft-Tools-32-bit*.exe w $ClientDir" }
    Start-Process -FilePath $oc.FullName -WorkingDirectory $oc.DirectoryName -Wait
}

Write-Host ''
Write-Host 'Gotowe.' -ForegroundColor Green
if (-not $DryRun) { Write-Host 'Nowy PATH będzie widoczny w nowo otwartych oknach/programach.' }
