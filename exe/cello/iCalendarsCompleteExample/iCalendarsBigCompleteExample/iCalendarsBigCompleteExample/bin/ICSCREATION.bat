call E:\iKalendarze\bin\conf.bat
set logname=icsCreation.txt

call :process DOK
::call :process IOE
::call :process SJO
call :process SSW
call :process WCY
call :process WEL
call :process WIG
call :process WLO
call :process WME
call :process WML
call :process WTC
call :process SWF
call :log OK
::call celloSync.bat

goto :eof

:process
call :log %1
call "%planowanie_home%\planowanie.exe" %connection% "inifile=%binhome%\%1\publikacja.ini"
::java -Dfile.encoding=utf-8 -jar e:\\iKalendarze\\bin\\cello.jar uploadIcs E:\\iKalendarze\\bin\\%1.json E:\\iKalendarze\\data\\%1
goto :eof

:log
echo %date% %time% %1 >> %datahome%\%logname%
goto :eof