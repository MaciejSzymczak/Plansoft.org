Set DATAHOME=C:\PlansoftOrgBackup\data

set NLS_LANG=POLISH_POLAND.EE8MSWIN1250
exp planner/{yourpassword}@{yourhostname}:1521/XEPDB1 file=%DATAHOME%\%date:* =%.dmp OWNER=planner
"C:\Program Files\7-Zip\7z.exe" a -t7z %DATAHOME%\%date:* =%.7z %DATAHOME%\%date:* =%.dmp
del %DATAHOME%\%date:* =%.dmp
"C:\Documents and Settings\mszymcza\My Documents\winscp425.exe" {yourWinscpSroredSessionName} /upload %DATAHOME%\%date:* =%.7z /backups/%date:* =%.7z /defaults
exit

