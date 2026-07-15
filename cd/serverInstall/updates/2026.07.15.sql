--select * from system_parameters where name like 'VERSION%' order by name desc
INSERT INTO system_parameters (name,value) VALUES ('VERSION 2026.07.15', 'INSTALLED');
commit;

alter table periods add (parent_per_id number);

ALTER TABLE periods
ADD CONSTRAINT periods_parent_per_id_fk
FOREIGN KEY (parent_per_id)
REFERENCES periods (id)
ON DELETE SET NULL
ENABLE NOVALIDATE;


create index PERIODS_parent_per_idI on periods(parent_per_id);

create table Waiting_tasks (
ID NUMBER primary key,
CODE varchar2(500),
DESCRIPTION varchar2(500),
per_id number,
"CREATION_DATE" DATE DEFAULT sysdate NOT NULL ENABLE, 
"CREATED_BY" VARCHAR2(30 BYTE) DEFAULT user NOT NULL ENABLE, 
"LAST_UPDATE_DATE" DATE DEFAULT sysdate NOT NULL ENABLE, 
"LAST_UPDATED_BY" VARCHAR2(30 BYTE) DEFAULT user NOT NULL ENABLE);

alter table Waiting_tasks add (
status varchar2(30) DEFAULT 'WAITING',
priority number default 99 
);

alter table lec_pla add ( Access_Type varchar2(1) default 'E');
alter table gro_pla add ( Access_Type varchar2(1) default 'E');
alter table rom_pla add ( Access_Type varchar2(1) default 'E');
alter table sub_pla add ( Access_Type varchar2(1) default 'E');
alter table for_pla add ( Access_Type varchar2(1) default 'E');
alter table per_pla add ( Access_Type varchar2(1) default 'E');
alter table rol_pla add ( Access_Type varchar2(1) default 'E');

*** install package planner_utils
*** install package waiting_tasks_processor


begin
  dbms_scheduler.create_job(
	  job_name => 'WAITING_TASKS_PROCESSOR_TASK'
	 ,job_type => 'PLSQL_BLOCK'
	 ,job_action => 'begin waiting_tasks_processor.run; end;'
	, repeat_interval => 'FREQ=MINUTELY;INTERVAL=5'
	, enabled            =>  true
	 ,comments => '');
--DISPLAY SCHEDULED JOBS:  select * from dba_scheduler_jobs
--DROP JOB              :  begin dbms_scheduler.drop_job('WAITING_TASKS_PROCESSOR'); end;
end;
			
DECLARE CURSOR TEMP
IS
select 'DROP PUBLIC SYNONYM '||SNAME S from SYS.SYNONYMS WHERE CREATOR = USER AND SYNTYPE = 'PUBLIC';
BEGIN
FOR REC_TEMP IN TEMP
LOOP
 execute immediate REC_TEMP.S;
 END LOOP;
END;
/

DECLARE
CURSOR TEMP
IS
select 'CREATE PUBLIC SYNONYM '||object_name||' FOR '||object_name S from sys.all_objects where owner = user and
OBJECT_TYPE NOT IN ('SYNONYM', 'INDEX', 'PACKAGE BODY') order by object_name;
BEGIN
FOR REC_TEMP IN TEMP
	LOOP
		 BEGIN
			execute immediate REC_TEMP.S;
		 EXCEPTION 
		 WHEN OTHERS THEN
			NULL;
		 END;
	END LOOP;
END;
/
