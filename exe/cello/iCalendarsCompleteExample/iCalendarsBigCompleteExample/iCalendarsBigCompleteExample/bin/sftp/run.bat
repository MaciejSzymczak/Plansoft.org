call E:\iKalendarze\bin\conf.bat

del /Q "%sftpdata%\*.*"
call :go > "%sftpdata%\Process.log"
goto :eof 

:go

call :copyfiles DOK
call :copyfiles IOE
call :copyfiles SJO
call :copyfiles SSW
call :copyfiles WCY
call :copyfiles WEL
call :copyfiles WIG
call :copyfiles WLO
call :copyfiles WME
call :copyfiles WML
call :copyfiles WTC

java -Dfile.encoding=utf-8 -jar e:\\iKalendarze\\bin\\cello.jar status "%datahome%"
copy /Y "%datahome%\status.xml" "%sftpdata%"

cd %sftpdata%
wscript.exe %sftpbin%\sftp.js
::cscript %sftpbin%\sFtp.Status.vbs
cd %sftpbin%
goto :eof

:copyfiles
echo processing %1
del "%datahome%\%1\%1.js"
copy "%datahome%\%1\ListOfCalendars.js" "%datahome%\%1\%1.js"
copy /Y "%datahome%\%1\%1.js" "%sftpdata%"
goto :eof

