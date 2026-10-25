# Exports the user documentation (cd\doc\userGuide\*.docx) to PDF and moves the PDF files to
# https://plansoft.org/wp-content/uploads/pdf/ - the same location and WinSCP session as install.ps1.
# A PDF is deleted locally only after it was uploaded successfully (WinSCP put -delete).
# A missing .docx is reported and skipped.

# Execution - run powershell
# cd "C:\Users\Maciek\Documents\GitHub\Plansoft2.org\exe\plansoft.org"
# Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
# .\PublishDoc.ps1

$ErrorActionPreference = "Stop"

$root   = $PSScriptRoot
$docDir = (Resolve-Path (Join-Path $root "..\..\cd\doc\userGuide")).Path

$pdfNames = @(
    "HowTo.JakZarzadzacKalendarzami.chg.pdf",
    "HowTo.JakZnalezcWolneSale.pdf",
    "HowTo.PlanStudiow.chg.pdf",
    "Podrecznik_uzytkownika_Plansoft.org.pdf",
    "WspolpracaZespoluPlanistow.pdf",
    "Publikacja.pdf",
    "Publikacja_iKalendarze.pdf",
    "Powiadomienia_o_zmianach.pdf",
    "Raportowanie.pdf",
    "PlanSoft.pdf",
    "Dodatki.pdf",
    "Integracja_z_USOS.pdf",
    "Integracja_z_Bazus.pdf",
    "Integracja_z_AmericanSystems.pdf"
)

# ------------------------------------------------------------------ 1. docx -> pdf (Microsoft Word)
$missing = @()
$created = @()
$wdFormatPDF = 17

$word = New-Object -ComObject Word.Application
$word.Visible = $false
$word.DisplayAlerts = 0
try {
    foreach ($pdf in $pdfNames) {
        $docx = Join-Path $docDir ([System.IO.Path]::ChangeExtension($pdf, ".docx"))
        if (-not (Test-Path $docx)) {
            $missing += [System.IO.Path]::GetFileName($docx)
            continue
        }
        $pdfPath = Join-Path $docDir $pdf
        Write-Output "PDF: $pdf"
        # Open(FileName, ConfirmConversions, ReadOnly, AddToRecentFiles)
        $doc = $word.Documents.Open($docx, $false, $true, $false)
        try {
            # SaveAs2 (not ExportAsFixedFormat - it hangs in an invisible Word 2010 instance)
            $doc.SaveAs2($pdfPath, $wdFormatPDF)
        }
        finally {
            $doc.Close($false)
        }
        $created += $pdfPath
    }
}
finally {
    foreach ($d in @($word.Documents)) { $d.Close($false) }
    $word.Quit()
    [System.Runtime.InteropServices.Marshal]::ReleaseComObject($word) | Out-Null
}

if ($missing.Count -gt 0) {
    Write-Output "Missing .docx files (skipped):"
    $missing | ForEach-Object { Write-Output "  $_" }
}
if ($created.Count -eq 0) {
    Write-Output "No PDF created - nothing to upload."
    exit 0
}

# ------------------------------------------------------------------ 2. move the PDFs to the web site (WinSCP)
$winscp = "C:\Program Files (x86)\WinSCP\WinSCP.com"
if (-not (Test-Path $winscp)) {
    $winscp = "C:\Program Files\WinSCP\WinSCP.com"
}
if (-not (Test-Path $winscp)) {
    throw "WinSCP.com not found - is WinSCP installed?"
}

$remoteDir = "/plansoft/wp-content/uploads/pdf"
$puts = ($created | ForEach-Object { "put -delete `"$_`"" }) -join "`r`n"
$winscpScript = @"
option batch abort
option confirm off
open watbackup
cd $remoteDir
$puts
close
exit
"@

$scriptFile = Join-Path $root "publishdoc_winscp_script.tmp.txt"
Set-Content -Path $scriptFile -Value $winscpScript -Encoding ASCII

try {
    & $winscp /script=$scriptFile
    if ($LASTEXITCODE -ne 0) {
        throw "WinSCP upload failed with exit code $LASTEXITCODE"
    }
    Write-Output "Moved $($created.Count) PDF file(s) to $remoteDir via watbackup."
}
finally {
    Remove-Item $scriptFile -Force -ErrorAction SilentlyContinue
}
