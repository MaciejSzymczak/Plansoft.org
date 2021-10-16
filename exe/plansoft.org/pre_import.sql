REM ***************************************************************
REM * Autor: Maciej Szymczak
REM * Skrypt musi byæ uruchamiany przez uzytkownika SYS
REM ***************************************************************

begin
	execute immediate 'drop user planner cascade'; 
	execute immediate 'drop role pla_permission'; 
exception when others then null;
end;
/

create user planner identified by planner DEFAULT TABLESPACE USERS QUOTA UNLIMITED ON USERS;
grant dba to planner;
create role pla_permission identified by XXXALABAMA;
grant delete any table to pla_permission;
grant execute any library to pla_permission;
grant execute any procedure to pla_permission;
grant execute any type to pla_permission;
grant insert any table to pla_permission;
grant select any sequence to pla_permission;
grant select any table to pla_permission;
grant lock any table to pla_permission;
grant update any table to pla_permission;
grant create user to pla_permission;
grant alter user to pla_permission;
grant drop user to pla_permission;
grant connect to pla_permission with admin option;
grant resource to pla_permission;
grant dba to pla_permission;
grant pla_permission to planner with admin option;
alter user planner default role all except pla_permission;

alter profile DEFAULT limit PASSWORD_REUSE_TIME unlimited;
alter profile DEFAULT limit PASSWORD_LIFE_TIME  unlimited;

grant select on SYS.CDEF$ to planner;
grant select on SYS.CON$ to planner;
grant select on SYS.OBJ$ to planner;
grant select on SYS.USER$ to planner;
grant alter system to planner;
grant select on sys.GV_$SESSION to planner;
GRANT EXECUTE ON sys.dbms_crypto TO planner;

rem Jeœli nie ma komunikatów o b³êdach, wpisz Exit i naciœnij Enter
exit
