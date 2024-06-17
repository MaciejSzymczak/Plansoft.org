INSERT INTO system_parameters (name,value) VALUES ('VERSION 2024.06.13', 'INSTALLED');
commit;

alter table attendance_list_helper add(desc2 varchar2(500))

delete from DIFF_CATCHER_HELPER where dim in ('DIFF-1','DIFF-2','DIFF-3','DIFF-4','DIFF-5','DIFF-6','DIFF-7');
commit;

*** PACKAGES INSTALLATION: attendance_list, HealthCheck, diff_catcher

File: sendEmails.php: add "and day >= trunc(sysdate)"

insert into system_parameters (name, value) values ('DIFF_MODE', 'SCHEDULER');
Commit;

--OPCJONALNIE: Ustaw ten parametr, aby raport pokazywał zmiany wykonane w zajęciach przeszłych, maksymalnie N dni w przeszłości. 
insert into system_parameters (name, value) values ('DIFF_DAYS_IN_PAST', '0');
delete from DIFF_CATCHER_HELPER where dim = 'PRIOR';
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
