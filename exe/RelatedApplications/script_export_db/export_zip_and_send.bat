set NLS_LANG=POLISH_POLAND.EE8MSWIN1250
D:\app\Administrator\product\11.1.0\db_1\BIN\exp planner/4154 file=d:\backups\%date:* =%.dmp OWNER=planner
"C:\Program Files (x86)\7-Zip\7z.exe" a -t7z d:\backups\%date:* =%.7z d:\backups\%date:* =%.dmp
del d:\backups\%date:* =%.dmp
"C:\Documents and Settings\mszymcza\My Documents\winscp425.exe" soft@soft.home.pl /upload D:\backups\%date:* =%.7z /backups/%date:* =%.7z /defaults
exit
