create or replace package cnt is 

   /***************************************************************************************************************************** 
   |* Integration with external system 
   |  Use this code to schedule the integration

            begin
              dbms_scheduler.create_job(
                  job_name => 'CNT'
                 ,job_type => 'PLSQL_BLOCK'
                 ,job_action => 'begin cnt.run; end;'
                , repeat_interval    =>  'FREQ=DAILY;BYHOUR=3;BYMINUTE=00'
                , enabled            =>  true              
                 ,comments => '');
            --DISPLAY SCHEDULED JOBS:  select * from dba_scheduler_jobs
            --DROP JOB              :  begin dbms_scheduler.drop_job('CNT'); end;
            end;   


   |***************************************************************************************************************************** 
   | History 
   | 2023.11.26 Maciej Szymczak created  
   \-----------------------------------------------------------------------------------------------------------------------------*/ 

    procedure run;
end;
/

create or replace PACKAGE BODY CNT AS

  procedure run AS
  BEGIN  
    commit;

    insert into helper2 (desc2, hour)
    select created_by, count(1) from classes where creation_date > sysdate - 365 group by created_by;
    update planners set COUNT1Y = nvl((select hour from helper2 where desc2 = planners.created_by ),0);
    commit;
      
    insert into helper2 (desc2, hour)
    select created_by, count(1) from classes where creation_date > sysdate - 5*365 group by created_by;
    update planners set COUNT1Y = nvl((select hour from helper2 where desc2 = planners.created_by ),0);
    commit;
    
    insert into helper2 (id, hour)
    select sub_id, count(1) from classes where creation_date > sysdate - 365 group by sub_id;
    update subjects set COUNT1Y = nvl((select hour from helper2 where id = subjects.id ),0);
    commit;
      
    insert into helper2 (id, hour)
    select sub_id, count(1) from classes where creation_date > sysdate - 5*365 group by for_id;
    update subjects set COUNT5Y = nvl((select hour from helper2 where id = subjects.id ),0);
    commit;
    
    insert into helper2 (id, hour)
    select for_id, count(1) from classes where creation_date > sysdate - 365 group by for_id;
    update forms set COUNT1Y = nvl((select hour from helper2 where id = forms.id ),0);
    commit;
      
    insert into helper2 (id, hour)
    select for_id, count(1) from classes where creation_date > sysdate - 5*365 group by for_id;
    update forms set COUNT5Y = nvl((select hour from helper2 where id = forms.id ),0);
    commit;
    
    insert into helper2 (id, hour)
    select for_id, count(1) from classes where creation_date > sysdate - 5*365 and id in (select cla_id from lec_cla) group by for_id;
    update forms set COUNT5Y_LEC = nvl((select hour from helper2 where id = forms.id ),0);
    commit;
    
    insert into helper2 (id, hour)
    select for_id, count(1) from classes where creation_date > sysdate - 5*365 and id in (select cla_id from gro_cla) group by for_id;
    update forms set COUNT5Y_GRO = nvl((select hour from helper2 where id = forms.id ),0);
    commit;
    
    insert into helper2 (id, hour)
    select for_id, count(1) from classes where creation_date > sysdate - 5*365 and id in (select cla_id from rom_cla) group by for_id;
    update forms set COUNT5Y_ROM = nvl((select hour from helper2 where id = forms.id ),0);
    commit;
    
    insert into helper2 (id, hour)
    select lec_id, count(1) from lec_cla, classes where classes.id = lec_cla.cla_id and classes.creation_date > sysdate - 365 group by  lec_id;
    update lecturers set COUNT1Y = nvl((select hour from helper2 where id = lecturers.id ),0);
    commit;
    
    insert into helper2 (id, hour)
    select lec_id, count(1) from lec_cla, classes where classes.id = lec_cla.cla_id and classes.creation_date > sysdate - 5*365 group by  lec_id;
    update lecturers set COUNT5Y = nvl((select hour from helper2 where id = lecturers.id ),0);
    commit;
    
    insert into helper2 (id, hour)
    select gro_id, count(1) from gro_cla, classes where classes.id = gro_cla.cla_id and classes.creation_date > sysdate - 365 group by  gro_id;
    update groups set COUNT1Y = nvl((select hour from helper2 where id = groups.id ),0);
    commit;
    
    insert into helper2 (id, hour)
    select gro_id, count(1) from gro_cla, classes where classes.id = gro_cla.cla_id and classes.creation_date > sysdate - 5*365 group by  gro_id;
    update groups set COUNT5Y = nvl((select hour from helper2 where id = groups.id ),0);
    commit;
    
    insert into helper2 (id, hour)
    select rom_id, count(1) from rom_cla, classes where classes.id = rom_cla.cla_id and classes.creation_date > sysdate - 365 group by  rom_id;
    update rooms set COUNT1Y = nvl((select hour from helper2 where id = rooms.id ),0);
    commit;
    
    insert into helper2 (id, hour)
    select rom_id, count(1) from rom_cla, classes where classes.id = rom_cla.cla_id and classes.creation_date > sysdate - 5*365 group by  rom_id;
    update rooms set COUNT5Y = nvl((select hour from helper2 where id = rooms.id ),0);
    commit;
  END run;

END CNT;
/
