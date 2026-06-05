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
   | 2026.06.05 Maciej Szymczak updated (Wszystko)  
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
    update planners set COUNT1Y = nvl((select hour from helper2 where desc2 = planners.name ),0);
    commit;
      
    insert into helper2 (desc2, hour)
    select created_by, count(1) from classes where creation_date > sysdate - 5*365 group by created_by;
    update planners set COUNT5Y = nvl((select hour from helper2 where desc2 = planners.name ),0);
    commit;
    
    insert into helper2 (id, hour)
    select sub_id, count(1) from classes where creation_date > sysdate - 365 group by sub_id;
    update subjects set COUNT1Y = nvl((select hour from helper2 where id = subjects.id ),0);
    commit;
      
    insert into helper2 (id, hour)
    select sub_id, count(1) from classes where creation_date > sysdate - 5*365 group by sub_id;
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
    
    --WSZYSTKO
    insert into lec_pla (id, lec_id, pla_id)
    select lecpla_seq.nextval, lec_id,pla_id  from
    (
    select l.id lec_id, p.id pla_id from (select Id from lecturers where id>0) l, (select id from planners where name='WSZYSTKO') p
    minus
    select lec_id,pla_id from lec_pla
    );
    commit;
    
    insert into gro_pla (id, gro_id, pla_id)
    select gropla_seq.nextval, gro_id,pla_id  from
    (
    select l.id gro_id, p.id pla_id from (select Id from groups where id>0) l, (select id from planners where name='WSZYSTKO') p
    minus
    select gro_id,pla_id from gro_pla
    );
    commit;
    
    insert into rom_pla (id, rom_id, pla_id)
    select rompla_seq.nextval, rom_id,pla_id  from
    (
    select l.id rom_id, p.id pla_id from (select Id from rooms where id>0) l, (select id from planners where name='WSZYSTKO') p
    minus
    select rom_id,pla_id from rom_pla
    );
    commit;
    
    insert into sub_pla (id, sub_id, pla_id)
    select subpla_seq.nextval, sub_id,pla_id  from
    (
    select l.id sub_id, p.id pla_id from (select Id from subjects where id>0) l, (select id from planners where name='WSZYSTKO') p
    minus
    select sub_id,pla_id from sub_pla
    );
    commit;
    
    insert into for_pla (id, for_id, pla_id)
    select forpla_seq.nextval, for_id,pla_id  from
    (
    select l.id for_id, p.id pla_id from (select Id from forms where id>0) l, (select id from planners where name='WSZYSTKO') p
    minus
    select for_id,pla_id from for_pla
    );
    commit;
    
    insert into per_pla (id, per_id, pla_id)
    select perpla_seq.nextval, per_id,pla_id  from
    (
    select l.id per_id, p.id pla_id from (select Id from periods where id>0) l, (select id from planners where name='WSZYSTKO') p
    minus
    select per_id,pla_id from per_pla
    );
    commit;
        
  END run;

END CNT;
/
