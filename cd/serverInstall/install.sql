STEP 1
==================================
Connect system
drop user planner cascade; --ewentualny błąd można zignorować
drop role pla_permission; -- ewentualny błąd można zignorować
create user planner identified by planner
DEFAULT TABLESPACE USERS
QUOTA UNLIMITED ON USERS;
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
create user "PLANNERREPORTS" identified by "123"
default tablespace users
temporary tablespace temp;
grant "CONNECT" to "PLANNERREPORTS";
grant "RESOURCE" to "PLANNERREPORTS";

alter profile DEFAULT limit PASSWORD_REUSE_TIME unlimited;
alter profile DEFAULT limit PASSWORD_LIFE_TIME  unlimited;

STEP 2
=================================
connect sys as sysdba;
grant select on SYS.CDEF$ to planner;
grant select on SYS.CON$ to planner;
grant select on SYS.OBJ$ to planner;
grant select on SYS.USER$ to planner;
grant alter system to planner;
grant select on sys.GV_$SESSION to planner;
GRANT EXECUTE ON sys.dbms_crypto TO planner;


STEP 3
===============
IMP


STEP 4
================
Sqlplus planner


begin
insert into lecturers (id, abbreviation, first_name, orguni_id,colour, email) values (-1,'POD','POD', (select min(id) from org_units), 192+192*256+192*256*256,'dummy@dommy.com');
insert into lecturers (id, abbreviation, first_name, orguni_id,colour, email) values (-2,'NAD','NAD', (select min(id) from org_units), 192+192*256+192*256*256,'dummy@dommy.com');
insert into groups (id, abbreviation, name, orguni_id,colour) values (-1,'POD','Podgrupa', (select min(id) from org_units), 192+192*256+192*256*256);
insert into groups (id, abbreviation, name, orguni_id,colour) values (-2,'NAD','Nadgrupa', (select min(id) from org_units), 192+192*256+192*256*256);
insert into rooms (id, attribs_01, name, orguni_id,colour,rescat_id) values (-1,'POD','POD', (select min(id) from org_units), 192+192*256+192*256*256, 1);
insert into rooms (id, attribs_01, name, orguni_id,colour,rescat_id) values (-2,'NAD','NAD', (select min(id) from org_units), 192+192*256+192*256*256, 1);
commit;
exception
when others then null;
end;
/

begin
insert into subjects (id, abbreviation, name, orguni_id,colour) values (-1,'POD','Podgrupa', (select min(id) from org_units), 192+192*256+192*256*256);
insert into subjects (id, abbreviation, name, orguni_id,colour) values (-2,'NAD','Nadgrupa', (select min(id) from org_units), 192+192*256+192*256*256);
insert into forms (id, abbreviation, name,colour) values (-1,'POD','Podgrupa', 192+192*256+192*256*256);
insert into forms (id, abbreviation, name,colour) values (-2,'NAD','Nadgrupa', 192+192*256+192*256*256);
commit;
exception
when others then null;
end;
/

DECLARE CURSOR TEMP
IS
select 'DROP PUBLIC SYNONYM '||SNAME S from SYS.SYNONYMS WHERE CREATOR = USER AND SYNTYPE = 'PUBLIC';
C INTEGER;
BEGIN
FOR REC_TEMP IN TEMP
LOOP
 C := DBMS_SQL.OPEN_CURSOR;
 DBMS_SQL.PARSE(C, REC_TEMP.S,DBMS_SQL.V7);
 DBMS_SQL.CLOSE_CURSOR(C);
 END LOOP;
END;
/
DECLARE
CURSOR TEMP
IS
select 'CREATE PUBLIC SYNONYM '||object_name||' FOR '||object_name S from sys.all_objects where owner = user and
OBJECT_TYPE NOT IN ('SYNONYM', 'INDEX', 'PACKAGE BODY') order by object_name;
C INTEGER;
BEGIN
FOR REC_TEMP IN TEMP
LOOP
 C := DBMS_SQL.OPEN_CURSOR;
 BEGIN
 DBMS_SQL.PARSE(C, REC_TEMP.S,DBMS_SQL.V7);
 EXCEPTION -- ZABLOKOWANIE ZATRZYMANIA Z POWODU BŁĘDÓW
 WHEN OTHERS THEN
 NULL; -- POLECENIE RAISE PODNOSI WYJĄTEK
 END;
 DBMS_SQL.CLOSE_CURSOR(C);
 END LOOP;
END;
/

begin
delete from SYSTEM_PARAMETERS where name = 'PLANOWANIE.LICENCE_FOR';
insert into SYSTEM_PARAMETERS (name, value) values ('PLANOWANIE.LICENCE_FOR', 'DEMO');
commit;
end;
/


--select 'grant select on planner.'||lower(table_name)||' to plannerreports;' from cat where table_type = 'TABLE' order by
table_name
grant execute on planner.getSQLValues to plannerreports;
grant select on planner.classes to plannerreports;
grant select on planner.flex_col_usage to plannerreports;
grant select on planner.form_formulas to plannerreports;
grant select on planner.forms to plannerreports;
grant select on planner.for_pla to plannerreports;
grant select on planner.gro_cla to plannerreports;
grant select on planner.gro_pla to plannerreports;
grant select on planner.groups to plannerreports;
grant select on planner.lec_cla to plannerreports;
grant select on planner.lec_pla to plannerreports;
grant select on planner.lecturers to plannerreports;
grant select on planner.lookups to plannerreports;
grant select on planner.org_units to plannerreports;
grant select on planner.periods to plannerreports;
grant select on planner.planners to plannerreports;
grant select on planner.reservations to plannerreports;
grant select on planner.res_hints to plannerreports;
grant select on planner.resource_categories to plannerreports;
grant select on planner.str_elems to plannerreports;
grant select on planner.rol_pla to plannerreports;
grant select on planner.rom_cla to plannerreports;
grant select on planner.rom_pla to plannerreports;
grant select on planner.rooms to plannerreports;
grant select on planner.subjects to plannerreports;
grant select on planner.sub_pla to plannerreports;
grant select on planner.system_parameters to plannerreports;
grant select on planner.tmp_numbers to plannerreports;
grant select on planner.tmp_selected_dates to plannerreports;
grant select on planner.tmp_varchar2 to plannerreports;
grant select on planner.value_sets to plannerreports;