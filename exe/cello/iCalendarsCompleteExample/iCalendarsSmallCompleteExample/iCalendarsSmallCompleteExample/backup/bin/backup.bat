SET NLS_LANG=.AL32UTF8
exp planner/planner file=c:\PlansoftOrg\backups\data\plansoftorgbackup%date:* =%.dmp OWNER=planner
"C:\Program Files\7-Zip\7z.exe" a -t7z c:\PlansoftOrg\backups\data\plansoftorgbackup%date:* =%.7z c:\PlansoftOrg\backups\data\plansoftorgbackup%date:* =%.dmp
del c:\PlansoftOrg\backups\data\plansoftorgbackup%date:* =%.dmp
"C:\Program Files (x86)\WinSCP\WinSCP.exe" soft@soft.home.pl /upload c:\PlansoftOrg\backups\data\plansoftorgbackup%date:* =%.7z /defaults
exit
