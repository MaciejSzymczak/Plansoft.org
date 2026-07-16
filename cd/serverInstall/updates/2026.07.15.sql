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

begin
update lec_pla set access_type='E';
update gro_pla set access_type='E';
update rom_pla set access_type='E';
update sub_pla set access_type='E';
update for_pla set access_type='E';
update per_pla set access_type='E';
update rol_pla set access_type='E';
commit;
end;

create or replace procedure copy_permissions( 
     pfrom_pla_id number 
   , pto_pla_id number 
   , plec char 
   , pgro char 
   , prom char 
   , prol char 
   , psub char 
   , pfor char 
   , pper char 
   , pclasses char 
   ) is 
begin 
    if plec='Y' then 
        delete from lec_pla where pla_id = pto_pla_id; 
        insert into lec_pla (id, lec_id, pla_id, access_type) 
        select lecpla_seq.nextval, lec_id, pto_pla_id, access_type from lec_pla where pla_id = pfrom_pla_id; 
    end if; 
    --- 
    if pgro='Y' then 
        delete from gro_pla where pla_id = pto_pla_id; 
        insert into gro_pla (id, gro_id, pla_id, access_type) 
        select gropla_seq.nextval, gro_id, pto_pla_id, access_type from gro_pla where pla_id = pfrom_pla_id; 
    end if; 
    --- 
    if prom='Y' then 
        delete from rom_pla where pla_id = pto_pla_id; 
        insert into rom_pla (id, rom_id, pla_id, access_type) 
        select rompla_seq.nextval, rom_id, pto_pla_id, access_type from rom_pla where pla_id = pfrom_pla_id; 
    end if; 
    --- 
    if prol='Y' then 
        delete from rol_pla where pla_id = pto_pla_id; 
        insert into rol_pla (id, rol_id, pla_id, access_type) 
        select rolpla_seq.nextval, rol_id, pto_pla_id, access_type from rol_pla where pla_id = pfrom_pla_id; 
    end if; 
    --- 
    if psub='Y' then 
        delete from sub_pla where pla_id = pto_pla_id; 
        insert into sub_pla (id, sub_id, pla_id, access_type) 
        select subpla_seq.nextval, sub_id, pto_pla_id, access_type from sub_pla where pla_id = pfrom_pla_id; 
    end if; 
    --- 
    if pfor='Y' then 
        delete from for_pla where pla_id = pto_pla_id; 
        insert into for_pla (id, for_id, pla_id, access_type) 
        select forpla_seq.nextval, for_id, pto_pla_id, access_type from for_pla where pla_id = pfrom_pla_id; 
    end if; 
    --- 
    if pper='Y' then 
        delete from per_pla where pla_id = pto_pla_id; 
        insert into per_pla (id, per_id, pla_id, access_type) 
        select perpla_seq.nextval, per_id, pto_pla_id, access_type from per_pla where pla_id = pfrom_pla_id; 
    end if; 
    --- 
    if pclasses='Y' then 
        declare 
           pfrom_pla_dsp varchar2(255); 
           pto_pla_dsp varchar2(255); 
        begin 
            select name into pfrom_pla_dsp from planners where id = pfrom_pla_id; 
            select name into pto_pla_dsp from planners where id = pto_pla_id; 
            update classes set owner=pto_pla_dsp  where owner=pfrom_pla_dsp; 
        end; 
    end if; 
end;
/

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
