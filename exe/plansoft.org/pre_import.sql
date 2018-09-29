REM ***************************************************************
REM * Autor: Maciej Szymczak
REM wykonywany jest przed importem danych z pliku- zob. funkcja import z pliku w aplikacji
REM skrypt musi byæ uruchamiany przez administratora bazy danych
REM ***************************************************************

DROP USER PLANNER CASCADE;
CREATE USER PLANNER IDENTIFIED BY PLANNER;
GRANT DBA TO PLANNER;
GRANT PLA_PERMISSION TO PLANNER with admin option;

grant select on SYS.CDEF$ to planner;
grant select on SYS.CON$ to planner;
grant select on SYS.OBJ$ to planner;
grant select on SYS.USER$ to planner;

grant alter system to planner;
grant select on sys.GV_$SESSION to planner;
GRANT EXECUTE ON sys.dbms_crypto TO planner;

rem Jeœli nie ma komunikatów o b³êdach, wpisz Exit i naciœnij Enter
exit
