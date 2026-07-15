create or replace package waiting_tasks_processor is

   /*****************************************************************************************************************************
   |* Processes queued background tasks from Waiting_tasks
   |  Use this code to schedule the processor

            begin
              dbms_scheduler.create_job(
                  job_name => 'WAITING_TASKS_PROCESSOR'
                 ,job_type => 'PLSQL_BLOCK'
                 ,job_action => 'begin waiting_tasks_processor.run; end;'
                , repeat_interval => 'FREQ=MINUTELY;INTERVAL=5',
                , enabled            =>  true
                 ,comments => '');
            --DISPLAY SCHEDULED JOBS:  select * from dba_scheduler_jobs
            --DROP JOB              :  begin dbms_scheduler.drop_job('WAITING_TASKS_PROCESSOR'); end;
            end;


   |*****************************************************************************************************************************
   | History
   | 2026.07.15 Maciej Szymczak created
   \-----------------------------------------------------------------------------------------------------------------------------*/

    procedure run;
end;
/

create or replace PACKAGE BODY WAITING_TASKS_PROCESSOR AS

  procedure process_task(p_code Waiting_tasks.code%TYPE, p_per_id Waiting_tasks.per_id%TYPE) AS
  BEGIN
    if p_code = 'CLONE_HOLIDAYS_TO_CHILDS' then
      planner_utils.clone_holidays_to_childs(p_per_id, 'N');
    end if;
    -- unrecognized codes: no handler yet, left for future extension
  END;

  procedure run AS
  BEGIN
    for rec in (
      select code, per_id
      from Waiting_tasks
      where status = 'WAITING'
      order by priority, creation_date desc
    ) loop
      begin
        process_task(rec.code, rec.per_id);
        delete from Waiting_tasks where code = rec.code and per_id = rec.per_id;
        commit;
      exception
        when others then
          rollback;
      end;
    end loop;
  END run;

END WAITING_TASKS_PROCESSOR;
/
