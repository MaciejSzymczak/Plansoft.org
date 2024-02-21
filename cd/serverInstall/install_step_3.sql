begin
  dbms_scheduler.create_job(
      job_name => 'CNT2'
     ,job_type => 'PLSQL_BLOCK'
     ,job_action => 'begin cnt.run; end;'
    , repeat_interval    =>  'FREQ=DAILY;BYHOUR=3;BYMINUTE=00'
    , enabled            =>  true              
     ,comments => '');
--DISPLAY SCHEDULED JOBS:  select * from dba_scheduler_jobs
--DROP JOB              :  begin dbms_scheduler.drop_job('CNT2'); end;
end; 
/


insert into system_parameters (name, value) values ('DIFF_MODE', 'SCHEDULER');
Commit;


begin
  dbms_scheduler.create_job(
	  job_name => 'DIFF_CATCHER_JOB'
	 ,job_type => 'PLSQL_BLOCK'
	 ,job_action => 'begin diff_catcher.diff; end;'
	 ,repeat_interval => 'freq=daily; byhour=20'
	 --,repeat_interval => 'freq=minutely'
	 ,enabled => TRUE
	 ,comments => '');
--EXECUTE NOW           :  begin diff_catcher.diff; end;
--DIS'PLAY SCHEDULED JOBS:  select * from dba_scheduler_jobs
--DROP JOB              :  begin dbms_scheduler.drop_job('DIFF_CATCHER_JOB'); end;
--LOG: select to_char(created,'yyyy-mm-dd hh24:mi:ss'), message from xxmsztools_eventlog where module_name = 'DIFF_CATCHER' order by id desc
end;
/


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

begin
delete from SYSTEM_PARAMETERS where name = 'PLANOWANIE.LICENCE_FOR';
insert into SYSTEM_PARAMETERS (name, value) values ('PLANOWANIE.LICENCE_FOR', 'DEMO');
commit;
end;
/