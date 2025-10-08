create or replace package USOS_V2 is 

   /***************************************************************************************************************************** 
   |* Integration with USOS 
   |  Use this code to schedule the integration

            begin
              dbms_scheduler.create_job(
                  job_name => 'INT_USOS'
                 ,job_type => 'PLSQL_BLOCK'
                 ,job_action => 'begin usos.integration_from_usos_dict; end;'
                 ,repeat_interval => 'freq=hourly;byminute=1,15,30,45'
                 --,repeat_interval => 'freq=minutely'
                 ,enabled => TRUE
                 ,comments => '');
            --EXECUTE NOW           :  begin integration_usos; end;
            --DISPLAY SCHEDULED JOBS:  select * from dba_scheduler_jobs
            --DROP JOB              :  begin dbms_scheduler.drop_job('INT_USOS'); end;
            --CLEAR LOG             :  delete from xxmsztools_eventlog where module_name = 'INTEGRATION_USOS';
            --DISPLAY LOGS          :  select * from xxmsztools_eventlog where module_name = 'INTEGRATION_USOS' order by id desc
            end;   


   |***************************************************************************************************************************** 
   | History 
   | 2022.01.30 Maciej Szymczak created  
   | 2024.10.29 Maciej Szymczak updates  
   \-----------------------------------------------------------------------------------------------------------------------------*/ 

    procedure integration_from_usos_dict (pCleanYpMode varchar2 default 'N', puserOrRoleId varchar2 default null);
    procedure integration_from_usos_plan (pCleanYpMode varchar2 default 'N', puserOrRoleId varchar2 default null);
    procedure integration_to_usos (pCleanYpMode varchar2 default 'N', puserOrRoleId varchar2 default null);
end;
/

create or replace package body USOS_V2 is 

 usosCykl varchar2(200) := 'USOS_CYKL%';

procedure buildUsosCykl(puserOrRoleId varchar2) as begin
  if puserOrRoleId is null then return; end if;
  usosCykl := puserOrRoleId||':USOS_CYKL';
end;

    procedure integration_from_usos_dict (pCleanYpMode varchar2 default 'N', puserOrRoleId varchar2 default null) as begin
        buildUsosCykl(puserOrRoleId);
    end;
    procedure integration_from_usos_plan (pCleanYpMode varchar2 default 'N', puserOrRoleId varchar2 default null) as begin
        buildUsosCykl(puserOrRoleId);
    end;
    procedure integration_to_usos (pCleanYpMode varchar2 default 'N', puserOrRoleId varchar2 default null) as begin
        buildUsosCykl(puserOrRoleId);
    end;
end;
/

