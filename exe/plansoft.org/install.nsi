!include "MUI2.nsh"

;--------------------------------

; The name of the installer
Name "Planowanie"

; The file to write
OutFile "install.exe"

; The default installation directory
InstallDir $PROGRAMFILES\Soft\Planowanie

; Registry key to check for directory (so if you install again, it will 
; overwrite the old one automatically)
InstallDirRegKey HKLM "Software\Planowanie" "Install_Dir"

; Request application privileges for Windows Vista
RequestExecutionLevel admin

;--------------------------------

!define MUI_HEADERIMAGE
;!define MUI_HEADERIMAGE_BITMAP "${NSISDIR}\Contrib\Graphics\Header\orange.bmp"
!define MUI_HEADERIMAGE_BITMAP "${NSISDIR}\Contrib\Graphics\Header\nsis.bmp"
!define MUI_ABORTWARNING

; Pages

!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
;!define MUI_FINISHPAGE_RUN_TEXT "Uruchom program Plansoft.org"
;!define MUI_FINISHPAGE_RUN "$INSTDIR\Planowanie.exe"
;!define MUI_FINISHPAGE_RUN_TEXT2 "SprawdŸ aktualizacje"
;!define MUI_FINISHPAGE_RUN2 "$INSTDIR\Update.exe"
!insertmacro MUI_PAGE_FINISH

UninstPage uninstConfirm
UninstPage instfiles

!insertmacro MUI_LANGUAGE "Polish"


; The stuff to install
Section "Planowanie (wymagane)"

  SectionIn RO

  ; Set output path to the installation directory.
  SetOutPath $INSTDIR
  
  ; Put file there
  File "Planowanie.exe"
  File "ssleay32.dll"
  File "libeay32.dll"
  File "reg.reg"
  File "plansoft.org.dmp"
  File "MemoryStatus.exe"
  File "PrzedluzenieWaznosci.exe"
  File "Encrypt.dll"
  File "qtintf70.dll"
  File "post_import.sql"
  File "pre_import.sql"
  File "A3"
  File "A4"
  ;File "update.exe"
  File "update.xml"
  File "libgcc_s_sjlj-1.dll"
  File "libstdc++-6.dll"
  File "libwinpthread-1.dll"
  File "wkhtmltoimage.exe"
  File "wkhtmltopdf.exe"
  File "wkhtmltox.dll"
  
  SetOutPath $INSTDIR\graph
  File "resources\graph\outofrange.gif"
  File "resources\graph\Reservation.gif"
  
  SetOutPath $INSTDIR\TrickSQL
  File "TrickSQL\dotacje_xe.ini"
  File "TrickSQL\TrickSQL.exe"
  File "TrickSQL\Launch_trick_sql.lnk"
  File "TrickSQL\Encrypt.dll"
  File "TrickSQL\dotacje_plansoft.ini"

  SetOutPath $INSTDIR\TrickSQL\ConfigFiles
  File "TrickSQL\ConfigFiles\untitled.sql"

  SetOutPath $INSTDIR\TrickSQL\ConfigFiles\Plansoft\Dotacje
  File "TrickSQL\ConfigFiles\Plansoft\Dotacje\*"

  ; Write the installation path into the registry
  WriteRegStr HKLM SOFTWARE\Planowanie "Install_Dir" "$INSTDIR"
  
  WriteRegStr HKCU "SOFTWARE\Software Factory\Planowanie" "STRINGSPATH" ""
  WriteRegStr HKCU "SOFTWARE\Software Factory\Planowanie" "Version" ""
  WriteRegStr HKCU "SOFTWARE\Software Factory\Planowanie" "Common\\KeyViolation" "Key violation"
  WriteRegStr HKCU "SOFTWARE\Software Factory\Planowanie" "Common\\Warning" "Uwaga"
  WriteRegStr HKCU "SOFTWARE\Software Factory\Planowanie" "Common\\Information" "Informacja"
  WriteRegStr HKCU "SOFTWARE\Software Factory\Planowanie" "Common\\Error" "B³¹d"
  WriteRegStr HKCU "SOFTWARE\Software Factory\Planowanie" "Common\\Question" "Pytanie"
  WriteRegStr HKCU "SOFTWARE\Software Factory\Planowanie" "Common\\AfterEdit" "Edycja pliku konfiguracyjnego zosta³‚a zakoñczona"
  WriteRegStr HKCU "SOFTWARE\Software Factory\Planowanie" "PRE_UPPERCASE" "UPPER("
  WriteRegStr HKCU "SOFTWARE\Software Factory\Planowanie" "POST_UPPERCASE" ")"
  WriteRegStr HKCU "SOFTWARE\Software Factory\Planowanie" "ODBC" "Nie"
  WriteRegStr HKCU "SOFTWARE\Software Factory\Planowanie" "SAVERESOURCES" "No"
  WriteRegStr HKCU "SOFTWARE\Software Factory\Planowanie" "ANY_CHARS" "%"
  WriteRegStr HKCU "SOFTWARE\Software Factory\Planowanie" "PRE_UPPERCASE_TEXT" "DU¯E("
  WriteRegStr HKCU "SOFTWARE\Software Factory\Planowanie" "POST_UPPERCASE_TEXT" ")"
  WriteRegStr HKCU "SOFTWARE\Software Factory\Planowanie" "ANY_CHAR" "_"
  WriteRegStr HKCU "SOFTWARE\Software Factory\Planowanie" "DATEFORMAT" "Daty wprowadzaæ w formacie RRRR.MM.DD"
  WriteRegStr HKCU "SOFTWARE\Software Factory\Planowanie" "PRE_DATEFORMAT" "TO_DATE('"
  WriteRegStr HKCU "SOFTWARE\Software Factory\Planowanie" "POST_DATEFORMAT" "','YYYY.MM.DD')"
  WriteRegStr HKCU "SOFTWARE\Software Factory\Planowanie" "PRE_DATEFORMAT_TEXT" " "
  WriteRegStr HKCU "SOFTWARE\Software Factory\Planowanie" "POST_DATEFORMAT_TEXT" " "
  WriteRegStr HKCU "SOFTWARE\Software Factory\Planowanie" "MaxLecturersInLegend" "10"
  WriteRegStr HKCU "SOFTWARE\Software Factory\Planowanie" "CellWidthInLegend" "100"
  WriteRegStr HKCU "SOFTWARE\Software Factory\Planowanie" "MaxLengthFOR_abbreviation" "3"
  WriteRegStr HKCU "SOFTWARE\Software Factory\Planowanie" "MaxLengthCALC_LECTURERS" "3"
  WriteRegStr HKCU "SOFTWARE\Software Factory\Planowanie" "MaxLengthCALC_GROUPS" "5"
  WriteRegStr HKCU "SOFTWARE\Software Factory\Planowanie" "MaxLengthCALC_ROOMS" "5"
  WriteRegStr HKCU "SOFTWARE\Software Factory\Planowanie" "MaxLengthSUB_abbreviation" "5"
  WriteRegStr HKCU "SOFTWARE\Software Factory\Planowanie" "MaxLengthOwner" "3"
  WriteRegStr HKCU "SOFTWARE\Software Factory\Planowanie" "MaxLengthCreated_by" "3" 
  
  ; Write the uninstall keys for Windows
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Planowanie" "DisplayName" "Planowanie"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Planowanie" "UninstallString" '"$INSTDIR\uninstall.exe"'
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Planowanie" "NoModify" 1
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Planowanie" "NoRepair" 1
  WriteUninstaller "uninstall.exe"

  DetailPrint "Zainstalowano program Plansoft.org"
  
SectionEnd

; Optional section (can be disabled by the user)
Section "Skróty w menu startowym"

  CreateDirectory "$SMPROGRAMS\Planowanie"
  CreateShortCut "$SMPROGRAMS\Planowanie\Plansoft.org.lnk" "$INSTDIR\Planowanie.exe" "" "$INSTDIR\Planowanie.exe" 0
  CreateShortCut "$SMPROGRAMS\Planowanie\PrzedluzenieWaznosci.lnk" "$INSTDIR\PrzedluzenieWaznosci.exe" "" "$INSTDIR\PrzedluzenieWaznosci.exe" 0
  CreateShortCut "$SMPROGRAMS\Planowanie\Uninstall.lnk" "$INSTDIR\uninstall.exe" "" "$INSTDIR\uninstall.exe" 0
  
SectionEnd

; Skrot na pulpicie
Section "Skrót na pulpicie"

  CreateShortCut "$DESKTOP\PlanSoft.org.lnk" "$INSTDIR\Planowanie.exe" ""
  CreateShortCut "$DESKTOP\PrzedluzenieWaznosci.lnk" "$INSTDIR\PrzedluzenieWaznosci.exe" ""

SectionEnd

; Skrot szybkiego uruchamiania
Section "Szybkie uruchamianie"

  CreateShortCut "$QUICKLAUNCH\Plansoft.org.lnk" "$INSTDIR\Planowanie.exe" ""
  CreateShortCut "$QUICKLAUNCH\PrzedlzuenieWaznosci.lnk" "$INSTDIR\PrzedluzenieWaznosci.exe" ""

SectionEnd

;--------------------------------

; Uninstaller

Function un.onInit
  MessageBox MB_YESNO "Czy na pewno odinstalowaæ Plansoft.org?" IDYES NoAbort
    Abort ; causes uninstaller to quit.
  NoAbort:
FunctionEnd

Section "Uninstall"
  
  ; Remove registry keys
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Planowanie"
  DeleteRegKey HKLM SOFTWARE\Planowanie
  
  ;DeleteRegKey HKCU "SOFTWARE\Software Factory\Planowanie"

  ; Remove files and uninstaller
  Delete $INSTDIR\*
  Delete $INSTDIR\graph\*
  Delete $INSTDIR\TrickSQL\*
  Delete $INSTDIR\TrickSQL\ConfigFiles\*
  Delete $INSTDIR\TrickSQL\ConfigFiles\Plansoft\Dotacje\*
 
  ; Remove shortcuts, if any
  Delete "$SMPROGRAMS\Planowanie\*.*"
  Delete "$DESKTOP\Plansoft.org.lnk"
  Delete "$DESKTOP\Pobierz aktualizacje Plansoft.org.lnk"
  Delete "$QUICKLAUNCH\Plansoft.org.lnk"
  Delete "$QUICKLAUNCH\Pobierz aktualizacje Plansoft.org.lnk"

  ; Remove directories used
  RMDir "$SMPROGRAMS\Planowanie"
  RMDir "$INSTDIR\TrickSQL\ConfigFiles\Plansoft\Dotacje"
  RMDir "$INSTDIR\TrickSQL\ConfigFiles\Plansoft\"
  RMDir "$INSTDIR\TrickSQL\ConfigFiles\"
  RMDir "$INSTDIR\TrickSQL\"
  RMDir "$INSTDIR\graph\"
  RMDir "$INSTDIR"

SectionEnd
