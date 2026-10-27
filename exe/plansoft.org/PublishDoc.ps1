# Exports the user documentation (cd\doc\userGuide\*.docx) to PDF and moves the PDF files to
# https://plansoft.org/wp-content/uploads/pdf/ - the same location as install.ps1 (PlansoftUpload.ps1).
# A PDF is deleted locally only after it was uploaded successfully (WinSCP put -delete).
# A missing .docx is reported and skipped.

# Execution - run powershell
# cd "C:\Users\Maciek\Documents\GitHub\Plansoft2.org\exe\plansoft.org"
# Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
# .\PublishDoc.ps1
# Password for the upload: see PlansoftUpload.ps1 (saved encrypted for this Windows user after the first prompt).
#   .\PublishDoc.ps1 -Password <password>   - pass it as a parameter (it is then not saved)
#   .\PublishDoc.ps1 -ResetPassword         - ask for it again and save the new one

param(
    $Password,
    [switch]$ResetPassword
)

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
# Each document is converted by its own Word instance in a separate PowerShell process started from a background
# job: Word 2010 driven directly from this session hangs on the first SaveAs, from a job it takes seconds.
# A conversion that does not finish within $timeoutSec is reported and skipped.
$missing = @()
$failed  = @()
$created = @()
$timeoutSec = 600

$converter = @'
param([string]$docx, [string]$pdf)
$ErrorActionPreference = "Stop"
$word = New-Object -ComObject Word.Application
$word.Visible = $false
$word.DisplayAlerts = 0
try {
    # Open(FileName, ConfirmConversions, ReadOnly, AddToRecentFiles)
    $doc = $word.Documents.Open($docx, $false, $true, $false)
    try {
        # 17 = wdFormatPDF; SaveAs2, not ExportAsFixedFormat (hangs in an invisible Word 2010 instance)
        $doc.SaveAs2($pdf, 17)
    }
    finally {
        $doc.Close($false)
    }
}
finally {
    foreach ($d in @($word.Documents)) { $d.Close($false) }
    $word.Quit()
}
'@
$converterFile = Join-Path $root "publishdoc_converter.tmp.ps1"
Set-Content -Path $converterFile -Value $converter -Encoding ASCII

try {
    foreach ($pdf in $pdfNames) {
        $docx = Join-Path $docDir ([System.IO.Path]::ChangeExtension($pdf, ".docx"))
        if (-not (Test-Path $docx)) {
            $missing += [System.IO.Path]::GetFileName($docx)
            continue
        }
        $pdfPath = Join-Path $docDir $pdf
        if (Test-Path $pdfPath) { Remove-Item $pdfPath -Force }
        Write-Output "PDF: $pdf"
        $job = Start-Job -ScriptBlock {
            param($conv, $docx, $pdf)
            & powershell -NoProfile -ExecutionPolicy Bypass -File $conv -docx $docx -pdf $pdf 2>&1
        } -ArgumentList $converterFile, $docx, $pdfPath
        if (Wait-Job $job -Timeout $timeoutSec) {
            Receive-Job $job | ForEach-Object { Write-Output "  $_" }
        } else {
            Stop-Job $job
            Write-Output "  timeout after $timeoutSec s"
        }
        Remove-Job $job -Force
        if (Test-Path $pdfPath) { $created += $pdfPath } else { $failed += $pdf }
    }
}
finally {
    Remove-Item $converterFile -Force -ErrorAction SilentlyContinue
}

if ($failed.Count -gt 0) {
    Write-Output "PDF not created (skipped):"
    $failed | ForEach-Object { Write-Output "  $_" }
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
. (Join-Path $root "PlansoftUpload.ps1")
Send-PlansoftFiles -Files $created -Delete -Password $Password -ResetPassword:$ResetPassword
Write-Output "Moved $($created.Count) PDF file(s) to $PlansoftRemoteDir."
