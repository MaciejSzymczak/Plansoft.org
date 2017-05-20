call E:\iKalendarze\bin\conf.bat
set logname=test.txt

call :process WCY
call :log OK
::call celloSync.bat

goto :eof

:process
call :log %1
::call "%planowanie_home%\planowanie.exe" %connection% "inifile=%binhome%\%1\publikacja.ini"
java -Dfile.encoding=utf-8 -jar e:\\iKalendarze\\bin\\cello.jar uploadIcs E:\\iKalendarze\\bin\\%1.json E:\\iKalendarze\\data\\%1
goto :eof

:log
echo %date% %time% %1 >> %datahome%\%logname%
goto :eof