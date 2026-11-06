@echo off
rem Uruchamia install.ps1 (mozna kliknac dwa razy). Parametry sa przekazywane dalej.
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0install.ps1" %*
pause
