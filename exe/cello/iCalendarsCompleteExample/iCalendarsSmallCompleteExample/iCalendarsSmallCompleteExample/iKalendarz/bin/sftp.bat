call C:\PlansoftOrg\iKalendarz\bin\conf.bat

del /Q "%sftpdata%\*.*"
call :go > "%sftpdata%\Process.log"
goto :eof 

:go

call :copyfiles WME
::call :copyfiles IOE

java -Dfile.encoding=utf-8 -jar C:\\PlansoftOrg\\iKalendarz\bin\\cello.jar status "%datahome%"
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

