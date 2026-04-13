call E:\iKalendarze\bin\conf.bat
set logname=icsPublication.txt

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
::
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
::
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
call E:\iKalendarze\bin\sftp\run.bat
call :log OK
::call celloSync.bat

goto :eof

:process
call :log %1
set iCal_Home="e:\\iKalendarze"
java -Dfile.encoding=utf-8 -jar %iCal_Home%\\bin\\cello.jar uploadIcs %iCal_Home%\\bin\\%1.json %iCal_Home%\\data\\%1 scope:public
java -Dfile.encoding=utf-8 -jar %iCal_Home%\\bin\\cello.jar uploadIcs %iCal_Home%\\bin\\%1.json %iCal_Home%\\data\\%1 scope:public
java -Dfile.encoding=utf-8 -jar %iCal_Home%\\bin\\cello.jar uploadIcs %iCal_Home%\\bin\\%1.json %iCal_Home%\\data\\%1 scope:public
java -Dfile.encoding=utf-8 -jar %iCal_Home%\\bin\\cello.jar uploadIcs %iCal_Home%\\bin\\%1.json %iCal_Home%\\data\\%1 scope:public
java -Dfile.encoding=utf-8 -jar %iCal_Home%\\bin\\cello.jar uploadIcs %iCal_Home%\\bin\\%1.json %iCal_Home%\\data\\%1 scope:public
java -Dfile.encoding=utf-8 -jar %iCal_Home%\\bin\\cello.jar uploadIcs %iCal_Home%\\bin\\%1.json %iCal_Home%\\data\\%1 scope:public
java -Dfile.encoding=utf-8 -jar %iCal_Home%\\bin\\cello.jar uploadIcs %iCal_Home%\\bin\\%1.json %iCal_Home%\\data\\%1 scope:public
java -Dfile.encoding=utf-8 -jar %iCal_Home%\\bin\\cello.jar uploadIcs %iCal_Home%\\bin\\%1.json %iCal_Home%\\data\\%1 scope:public
java -Dfile.encoding=utf-8 -jar %iCal_Home%\\bin\\cello.jar uploadIcs %iCal_Home%\\bin\\%1.json %iCal_Home%\\data\\%1 scope:public
java -Dfile.encoding=utf-8 -jar %iCal_Home%\\bin\\cello.jar uploadIcs %iCal_Home%\\bin\\%1.json %iCal_Home%\\data\\%1 scope:public
java -Dfile.encoding=utf-8 -jar %iCal_Home%\\bin\\cello.jar uploadIcs %iCal_Home%\\bin\\%1.json %iCal_Home%\\data\\%1 scope:public
java -Dfile.encoding=utf-8 -jar %iCal_Home%\\bin\\cello.jar uploadIcs %iCal_Home%\\bin\\%1.json %iCal_Home%\\data\\%1 scope:public
java -Dfile.encoding=utf-8 -jar %iCal_Home%\\bin\\cello.jar uploadIcs %iCal_Home%\\bin\\%1.json %iCal_Home%\\data\\%1 scope:public
java -Dfile.encoding=utf-8 -jar %iCal_Home%\\bin\\cello.jar uploadIcs %iCal_Home%\\bin\\%1.json %iCal_Home%\\data\\%1 scope:public
java -Dfile.encoding=utf-8 -jar %iCal_Home%\\bin\\cello.jar uploadIcs %iCal_Home%\\bin\\%1.json %iCal_Home%\\data\\%1 scope:public
java -Dfile.encoding=utf-8 -jar %iCal_Home%\\bin\\cello.jar uploadIcs %iCal_Home%\\bin\\%1.json %iCal_Home%\\data\\%1 scope:public
java -Dfile.encoding=utf-8 -jar %iCal_Home%\\bin\\cello.jar uploadIcs %iCal_Home%\\bin\\%1.json %iCal_Home%\\data\\%1 scope:public
java -Dfile.encoding=utf-8 -jar %iCal_Home%\\bin\\cello.jar uploadIcs %iCal_Home%\\bin\\%1.json %iCal_Home%\\data\\%1 scope:public
java -Dfile.encoding=utf-8 -jar %iCal_Home%\\bin\\cello.jar uploadIcs %iCal_Home%\\bin\\%1.json %iCal_Home%\\data\\%1 scope:public
java -Dfile.encoding=utf-8 -jar %iCal_Home%\\bin\\cello.jar uploadIcs %iCal_Home%\\bin\\%1.json %iCal_Home%\\data\\%1 scope:public
java -Dfile.encoding=utf-8 -jar %iCal_Home%\\bin\\cello.jar uploadIcs %iCal_Home%\\bin\\%1.json %iCal_Home%\\data\\%1 scope:public
java -Dfile.encoding=utf-8 -jar %iCal_Home%\\bin\\cello.jar uploadIcs %iCal_Home%\\bin\\%1.json %iCal_Home%\\data\\%1 scope:public
java -Dfile.encoding=utf-8 -jar %iCal_Home%\\bin\\cello.jar uploadIcs %iCal_Home%\\bin\\%1.json %iCal_Home%\\data\\%1 scope:public


goto :eof

:log
echo %date% %time% %1 >> %datahome%\%logname%
goto :eof