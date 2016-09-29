REM ***************************************************************
REM * Autor: Maciej Szymczak
REM wykonywany jest przed importem danych z pliku- zob. funkcja import z pliku w aplikacji
REM skrypt musi by� uruchamiany przez administratora bazy danych
REM ***************************************************************

DROP USER PLANNER CASCADE;
CREATE USER PLANNER IDENTIFIED BY PLANNER;
GRANT DBA TO PLANNER;
GRANT PLA_PERMISSION TO PLANNER with admin option;

rem Je�li nie ma komunikat�w o b��dach, wpisz Exit i naci�nij Enter
exit
