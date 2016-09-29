REM ***************************************************************
REM * Autor: Maciej Szymczak
REM wykonywany jest przed importem danych z pliku- zob. funkcja import z pliku w aplikacji
REM skrypt musi byæ uruchamiany przez administratora bazy danych
REM ***************************************************************

DROP USER PLANNER CASCADE;
CREATE USER PLANNER IDENTIFIED BY PLANNER;
GRANT DBA TO PLANNER;
GRANT PLA_PERMISSION TO PLANNER with admin option;

rem Jeœli nie ma komunikatów o b³êdach, wpisz Exit i naciœnij Enter
exit
