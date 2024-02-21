prompt connect sys as sysdba;
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
alter user planner default role all except pla_permission
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
GRANT SELECT ON GV_$LOCK TO planner;
GRANT SELECT ON V_$SESSION TO planner;

create or replace procedure purge_audit_trail (days in number) as
purge_date date;
begin
  purge_date := trunc(sysdate-days);
  delete from aud$ where ntimestamp# < purge_date;
  execute immediate 'delete from planner.classes_history where effective_end_date < purge_date and rownum < 10000';
  commit;
end;
/

begin
  --select * from dba_scheduler_jobs
  --begin dbms_scheduler.drop_job('AUDIT_PURGE'); end;
  dbms_scheduler.create_job(
      job_name => 'AUDIT_PURGE'
     ,job_type => 'PLSQL_BLOCK'
     ,job_action => 'begin purge_audit_trail(31); end;'
     ,repeat_interval => 'freq=daily'
     ,enabled => TRUE
     );
end;
/

