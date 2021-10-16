STEP 0
==================================

a. Install Oracle 11g XE (this is free for use)
	http://plansoft.org/OracleXE112_Win64.zip

b. Install Oracle SQLDeveloper Windows 64-bit with JDK 8 included (this is free for use)
Use SQLDeveloper to run the installation scripts described below in this file
	https://www.oracle.com/tools/downloads/sqldev-downloads.html

c. Perform the steps described here
	http://www.plansoft.org/wp-content/uploads/pdf/InstrukcjaInstalacjiStacjaRobocza.pdf

	Note: Do NOT install higher version than oracle11c XE - not tested yet. 
		Oracle18c XE	http://plansoft.org/OracleXE112_Win64.zip
		Oracle XE client 32bit NT_180000_client.zip (select 2nd option: RUNTIME) soft.home.pl/oracle18cXE/NT_180000_client.zip
	
	
STEP 1
==================================
Connect as sys to 127.0.0.1:1521/XE (Oracle 18c: 127.0.0.1:1521/XEPDB1)
prompt connect sys as sysdba;
begin
	execute immediate 'drop user planner cascade'; 
	execute immediate 'drop role pla_permission'; 
exception when others then null;
end;
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
default tablespace users
temporary tablespace temp;

alter profile DEFAULT limit PASSWORD_REUSE_TIME unlimited;
alter profile DEFAULT limit PASSWORD_LIFE_TIME  unlimited;

grant select on SYS.CDEF$ to planner;
grant select on SYS.CON$ to planner;
grant select on SYS.OBJ$ to planner;
grant select on SYS.USER$ to planner;
grant alter system to planner;
grant select on sys.GV_$SESSION to planner;
GRANT EXECUTE ON sys.dbms_crypto TO planner;


STEP 2
===============
download and unzip this file 
https://github.com/MaciejSzymczak/Plansoft.org/blob/master/cd/serverInstall/2021.08.09.init.dmp.zip

IMP planner@127.0.0.1:1521/XE
and import 2021.08.09.init.dmp

STEP 3
================
Sqlplus planner

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


STEP 4
================
Connect sys

create or replace procedure purge_audit_trail (days in number) as
purge_date date;
begin
  purge_date := trunc(sysdate-days);
  delete from aud$ where ntimestamp# < purge_date;
  delete from planner.classes_history where effective_end_date < purge_date and rownum < 10000;
  commit;
end;
/

begin
  dbms_scheduler.create_job(
      job_name => 'AUDIT_PURGE'
     ,job_type => 'PLSQL_BLOCK'
     ,job_action => 'begin purge_audit_trail(31); end;'
     ,repeat_interval => 'freq=daily'
     ,enabled => TRUE
     );
end;

prompt select * from dba_scheduler_jobs
prompt begin dbms_scheduler.drop_job('AUDIT_PURGE'); end;

STEP 5 - OPTIONAL. REMOVE TEST DATA and setup readOnly user
================
connect planner;

truncate table lec_cla;
truncate table gro_cla;
truncate table rom_cla;
delete from classes;
truncate table classes_history;
delete from subjects where id > 0;
delete from groups where id > 0;
delete from lecturers where id > 0;
delete from rooms where id > 0;
delete from form_formulas where id > 0;
delete from forms where id > 0;
commit;

