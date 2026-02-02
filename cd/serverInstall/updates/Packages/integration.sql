create or replace package integration is 

   /***************************************************************************************************************************** 
   |* Integration with external system 
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
            --CLEAR LOG             :  delete from xxmsztools_eventlog where module_name = 'INT_FROM_PLANSOFT';
            --DISPLAY LOGS          :  select * from xxmsztools_eventlog where module_name = 'INT_FROM_PLANSOFT' order by id desc
                                       select message, to_char(created,'hh24:mi:ss') from xxmsztools_eventlog where module_name = 'TRACE' order by id desc
            end;   


   |***************************************************************************************************************************** 
   | History 
   | 2022.05.30 Maciej Szymczak created  
   \-----------------------------------------------------------------------------------------------------------------------------*/ 

    procedure int_to_plansoft_dict (pCleanYpMode varchar2 default 'N');
    procedure int_to_plansoft_plan (pCleanYpMode varchar2 default 'N');
    procedure int_from_plansoft (pCleanYpMode varchar2 default 'N');
    
    function get_missing_periods (pperiod_name varchar2) return varchar2;
end;
/

create or replace package body integration is 

---------------------------------------------------------------------------------------------------------------------------------------
procedure int_to_plansoft_dict (pCleanYpMode varchar2 default 'N') as 
 trace varchar2(200);
 pDefaultOrgUniId number;
begin
    select min(id) into pDefaultOrgUniId from org_units;
    --declare x decimal; begin x := 1/0; end; --deliberate error
    begin
        --dealing with inactive records
        update lecturers set is_active = '0' where is_active='1' and integration_id in (select integration_id from int_lecturers where is_active = '0');
        update groups set is_active = '0' where is_active='1' and integration_id in (select integration_id from int_groups where is_active = '0');
        update rooms set is_active = '0' where is_active='1' and integration_id in (select integration_id from int_resources where is_active = '0');
        update subjects set is_active = '0' where is_active='1' and integration_id in (select integration_id from int_subjects where is_active = '0');
        update forms set is_active = '0' where is_active='1' and integration_id in (select integration_id from int_forms where is_active = '0');
        delete from lec_pla where lec_id in (select Id from lecturers where integration_id in (select integration_id from int_lecturers where is_active = '0') );
        delete from gro_pla where gro_id in (select Id from groups where integration_id in (select integration_id from int_groups where is_active = '0') );
        delete from rom_pla where rom_id in (select Id from rooms where integration_id in (select integration_id from int_resources where is_active = '0') );
        delete from sub_pla where sub_id in (select Id from subjects where integration_id in (select integration_id from int_subjects where is_active = '0') );
        delete from for_pla where for_id in (select Id from forms where integration_id in (select integration_id from int_forms where is_active = '0') );
        -- orguni
        update int_lecturers
          set orguni_id = (select id from org_units where name = orguni_name)
          where orguni_id is null
           and orguni_name is not null
           and orguni_name in (select name from org_units);
        update int_groups
          set orguni_id = (select id from org_units where name = orguni_name)
          where orguni_id is null
           and orguni_name is not null
           and orguni_name in (select name from org_units);
        update int_resources
          set orguni_id = (select id from org_units where name = orguni_name)
          where orguni_id is null
           and orguni_name is not null
           and orguni_name in (select name from org_units);
        update int_subjects
          set orguni_id = (select id from org_units where name = orguni_name)
          where orguni_id is null
           and orguni_name is not null
           and orguni_name in (select name from org_units);
        commit;
    end;
    begin
        --data autocorrection
        update int_lecturers set first_name = trim(first_name), last_name=trim(last_name);
        update int_groups set name = trim(name) where name <> trim(name);
        update int_resources set name = trim(name) , location = trim(location); 
        update int_subjects set name = trim(name) , type = trim(type); 
        update int_forms set name = trim(name); 
        --
        update  int_groups set group_type = 'STATIONARY'  where  group_type ='stacjonarne';
        update  int_groups set group_type = 'EXTRAMURAL'  where  group_type ='niestacjonarne';        
        --
        update int_lecturers
           set abbreviation = InitCap(lpad(first_name,2))||InitCap(lpad(last_name,2))
           where abbreviation is null;
        commit;   
        -- 
       trace := 'LECTURERS.UNIQUE ABBR';
       merge into int_lecturers m using (
            select * from (
            select integration_id, abbreviation, ROW_NUMBER() OVER (PARTITION BY abbreviation ORDER BY integration_id, abbreviation ) AS abbrPostfix  
              from int_lecturers 
              -- is_active = '1' is added temporarily because source system sends duplicates for not active records (same integration_id)
              where is_active = '1'
              ) where abbrPostfix >1
        ) int
        on (m.integration_id = int.integration_id)
        when matched then update 
         set abbreviation = int.abbreviation||abbrPostfix;
        --
        trace := 'FORM.FINE ABBR';
        update int_forms
           set abbreviation = 
                   InitCap(substr(REGEXP_SUBSTR(name, '[^ ]+', 1, 1),1,2)) ||
                   InitCap(substr(REGEXP_SUBSTR(name, '[^ ]+', 1, 2),1,2)) ||
                   InitCap(substr(REGEXP_SUBSTR(name, '[^ ]+', 1, 3),1,2)) ||
                   InitCap(substr(REGEXP_SUBSTR(name, '[^ ]+', 1, 4),1,2)) ||
                   InitCap(substr(REGEXP_SUBSTR(name, '[^ ]+', 1, 5),1,2)) ||          
                   InitCap(substr(REGEXP_SUBSTR(name, '[^ ]+', 1, 6),1,2)) ||          
                   InitCap(substr(REGEXP_SUBSTR(name, '[^ ]+', 1, 7),1,2)) ||          
                   InitCap(substr(REGEXP_SUBSTR(name, '[^ ]+', 1, 8),1,2)) ||          
                   InitCap(substr(REGEXP_SUBSTR(name, '[^ ]+', 1, 9),1,2))           
           where abbreviation is null;
       -- unique abbreviation
        merge into int_forms m using (
            select * from (
            select integration_id, abbreviation, ROW_NUMBER() OVER (PARTITION BY abbreviation ORDER BY integration_id, abbreviation ) AS abbrPostfix  
              from int_forms 
              ) where abbrPostfix >1
        ) int
        on (m.integration_id = int.integration_id)
        when matched then update 
         set abbreviation = int.abbreviation||abbrPostfix;
        --           
        update int_subjects 
           set abbreviation = 
                   InitCap(substr(REGEXP_SUBSTR(name ||' '||type, '[^ ]+', 1, 1),1,2)) ||
                   InitCap(substr(REGEXP_SUBSTR(name ||' '||type, '[^ ]+', 1, 2),1,2)) ||
                   InitCap(substr(REGEXP_SUBSTR(name ||' '||type, '[^ ]+', 1, 3),1,2)) ||
                   InitCap(substr(REGEXP_SUBSTR(name ||' '||type, '[^ ]+', 1, 4),1,2)) ||
                   InitCap(substr(REGEXP_SUBSTR(name ||' '||type, '[^ ]+', 1, 5),1,2)) ||          
                   InitCap(substr(REGEXP_SUBSTR(name ||' '||type, '[^ ]+', 1, 6),1,2)) ||          
                   InitCap(substr(REGEXP_SUBSTR(name ||' '||type, '[^ ]+', 1, 7),1,2)) ||          
                   InitCap(substr(REGEXP_SUBSTR(name ||' '||type, '[^ ]+', 1, 8),1,2)) ||          
                   InitCap(substr(REGEXP_SUBSTR(name ||' '||type, '[^ ]+', 1, 9),1,2))           
           where abbreviation is null;
       -- unique abbreviation
        merge into int_subjects m using (
            select * from (
            select integration_id, abbreviation, ROW_NUMBER() OVER (PARTITION BY abbreviation ORDER BY integration_id, abbreviation ) AS abbrPostfix  
              from int_subjects 
              ) where abbrPostfix >1
        ) int
        on (m.integration_id = int.integration_id)
        when matched then update 
         set abbreviation = int.abbreviation||abbrPostfix;
        commit;
    end;    
    -- ******************************************************************
    -- ****************** LECTURERS *************************************
    -- ******************************************************************
    trace := 'LECTURERS.MERGE';
    merge into lecturers m using  
        (
            select integration_id, title, first_name, last_name || decode(abbrPostfixName,1,null,abbrPostfixName) as last_name
            ,  abbreviation, orguni_id, is_active from 
            (
            SELECT integration_id
                 , title
                 , first_name
                 , last_name
                 , orguni_id
                 , abbreviation
                 , ROW_NUMBER() OVER (PARTITION BY first_name||last_name ORDER BY integration_id, first_name, last_name ) AS abbrPostfixName
                 , is_active
                from int_lecturers int
                where is_active=1
            )  
        ) int
    on (m.integration_id = int.integration_id)
         when not matched then insert (id, abbreviation, title, first_name, last_name, integration_id, orguni_id, colour, is_active) 
         values (main_seq.nextval, abbreviation, int.title, int.first_name, int.last_name,  int.integration_id, nvl(int.orguni_id,pDefaultOrgUniId)
               , round(dbms_random.value(128,255)) + 256*round(dbms_random.value(128,255)) + 256*256*round(dbms_random.value(128,255)), is_active)
         when matched then update 
            set title=int.title
              , first_name=int.first_name
              , last_name=int.last_name
              , abbreviation = int.abbreviation
              , orguni_id= nvl(nvl(int.orguni_id,orguni_id),pDefaultOrgUniId)
              , is_active = int.is_active
              , last_updated_by = 'INTEGRATION'
              , last_update_date = sysdate
              ;
    --
    if (pCleanYpMode='Y') then
      trace := 'LECTURERS.TRUNCATE LEC_PLA';
      execute immediate 'truncate table lec_pla';
    end if;
    trace := 'LECTURERS.INSERT LEC_PLA';
    insert into lec_pla (id, lec_id, pla_id)
        select lecpla_seq.nextval, lec_id,pla_id  from
        (
        select l.id lec_id, p.id pla_id from lecturers l, planners p where l.integration_id is not null and l.is_active = '1'
        minus
        select lec_id,pla_id from lec_pla
        );
    commit;    
    ---   
    -- ******************************************************************
    -- ****************** ROOMS *****************************************
    -- ******************************************************************
    trace := 'ROOMS.MERGE';
    merge into rooms m using  
        (
         select integration_id
               , name
               , capacity
               , location
               , orguni_id
               , is_active
             from int_resources  
            where is_active=1
        ) int
    on (m.integration_id = int.integration_id)
         when not matched then insert (    
                    id,
                    name,
                    rescat_id, 
                    attribn_01,
                    attribs_01,
                    integration_id,
                    orguni_id,
                    colour,
                    is_active
                ) 
         values (
               main_seq.nextval
             , int.name
             , 1
             , int.capacity
             , int.location
             , int.integration_id
             , nvl(int.orguni_id,pDefaultOrgUniId)
             , round(dbms_random.value(128,255)) + 256*round(dbms_random.value(128,255)) + 256*256*round(dbms_random.value(128,255))
             , int.is_active
             )
         when matched then update 
            set name=int.name
              , attribn_01=int.capacity
              , attribs_01=int.location
              , orguni_id=nvl(nvl(int.orguni_id,orguni_id),pDefaultOrgUniId)
              , is_active = int.is_active
              , last_updated_by = 'INTEGRATION'
              , last_update_date = sysdate
             ;
    ---          
    if (pCleanYpMode='Y') then
        trace := 'ROOMS.TRUNCATE ROM_PLA';
        execute immediate 'truncate table rom_pla';
    end if;
    trace := 'ROOMS.INSERT ROM_PLA';
    insert into rom_pla (id, rom_id, pla_id)
        select rompla_seq.nextval, rom_id, pla_id
        from (
        select rom.id rom_id, p.id pla_id from rooms rom, planners p where rom.integration_id is not null and rom.is_active = '1'
        minus
        select rom_id, pla_id from rom_pla
        );
    ---   
    -- ******************************************************************
    -- ****************** FORMS *****************************************
    -- ******************************************************************
    trace := 'FORMS.MERGE';
    merge into forms m using  
        (
         select integration_id
               , name
               , abbreviation
               , is_active
             from int_forms  
            where is_active=1
        ) int
    on (m.integration_id = int.integration_id)
         when not matched then insert (    
                id,
                abbreviation,
                name,
                kind,
                sort_order_on_reports,
                integration_id,
                colour,
                is_active
                ) 
         values (
               main_seq.nextval
             , int.name
             , int.name
             ,'C'
             , 1
             , int.integration_id
             , round(dbms_random.value(128,255)) + 256*round(dbms_random.value(128,255)) + 256*256*round(dbms_random.value(128,255))
             , int.is_active
             )
         when matched then update 
            set name=int.name
              , abbreviation=int.abbreviation
              , is_active = int.is_active
              , last_updated_by = 'INTEGRATION'
              , last_update_date = sysdate
              ;
    ---          
    if (pCleanYpMode='Y') then
        trace := 'ROOMS.TRUNCATE FOR_PLA';
        execute immediate 'truncate table for_pla';
    end if;
    trace := 'FORMS.INSERT FOR_PLA';
    insert into for_pla (id, for_id, pla_id)
        select forpla_seq.nextval, for_id, pla_id
        from (
        select form.id for_id, p.id pla_id from forms form, planners p where form.integration_id is not null and form.is_active = '1'
        minus
        select for_id, pla_id from for_pla
        );
    commit;    
    ---   
    -- ******************************************************************
    -- ****************** SUBJECTS *****************************************
    -- ******************************************************************
    
    --Duplicated combination subject-type
    declare
     FatalError varchar2(3) := 'NO';
    begin
    for rec in (
            select integration_id, name, type from int_subjects where (name, type) in (select name, type from int_subjects where is_active=1 group by name, type having count(1) >1) order by name, type    
    ) loop
      xxmsz_tools.insertIntoEventLog(substrb('PLANSOFT_DCT: ' || 'INFO: ZDUBLOWANA KOMBINACJA PRZEDMIOT-TYP: [' || rec.integration_id ||':'|| rec.name ||':'|| rec.type ||']'  ,1,230), 'I', 'INT_TO_PLANSOFT' );
      --FatalError:='YES';
      -- use this query to find the valid combinations
      --select integration_id_sub from int_plan
    end loop;    
      --if (FatalError='YES') then
      --      raise_application_error(-20000, 'BLAD DANYCH');
      --end if;
    end;
    
    trace := 'SUBJECTS.bazus_sub_map';
    -- if there is more than one subject with the same name we only take the first one, with minimal integration_id
    begin  
      execute immediate 'truncate table bazus_sub_map'; 
      insert into bazus_sub_map (subject_name, form_name, SUB_FORM_INTEGRATION_ID, SUB_INTEGRATION_ID)
      select name subject_name, type form_name, integration_id BAZUS_INTEGRATION_ID
          --to_number is get the records created first (id 1 wins rather than 9)
          , MIN(to_number(integration_id)) OVER (PARTITION BY name ) AS SUB_INTEGRATION_ID
      from int_subjects where is_active=1;
      commit;
    end;
    trace := 'SUBJECTS.MERGE';
    merge into subjects m using  
        (
         select integration_id
              , name
              , type
              , abbreviation
              , is_active
              , orguni_id
             from int_subjects 
            where is_active=1
             -- if there is more than one subject with the same name we only take the first one, with minimal integration_id
             and integration_id in (select unique SUB_INTEGRATION_ID from bazus_sub_map)
        ) int
    on (m.integration_id = int.integration_id)
         when not matched then insert (    
                    id,
                    name,
                    abbreviation,
                    integration_id,
                    orguni_id,
                    colour,
                    is_active
                ) 
         values (
               main_seq.nextval
             , int.name 
             , int.abbreviation
             , int.integration_id
             , nvl(int.orguni_id,pDefaultOrgUniId)
             , round(dbms_random.value(128,255)) + 256*round(dbms_random.value(128,255)) + 256*256*round(dbms_random.value(128,255))
             , int.is_active
             )
         when matched then update 
            set name=int.name 
              , abbreviation = int.abbreviation
              , orguni_id=nvl(nvl(int.orguni_id,orguni_id),pDefaultOrgUniId)
              , is_active = int.is_active
              , last_updated_by = 'INTEGRATION'
              , last_update_date = sysdate
              ;
    ---          
    if (pCleanYpMode='Y') then
        trace := 'SUBJECTS.TRUNCATE SUB_PLA';
        execute immediate 'truncate table sub_pla';
    end if;
    trace := 'SUBJECTS.INSERT SUB_PLA';
    insert into sub_pla (id, sub_id, pla_id)
        select subpla_seq.nextval, sub_id, pla_id
        from (
        select sub.id sub_id, p.id pla_id from subjects sub, planners p where sub.integration_id is not null and sub.is_active = '1'
        minus
        select sub_id, pla_id from sub_pla
        );
    ---   
    -- ******************************************************************
    -- ****************** GROUPS *****************************************
    -- ******************************************************************
    trace := 'GROUPS.MERGE';
    merge into groups m using  
        (
         select integration_id
              , name
              , capacity
              , group_type
              , is_active
              , orguni_id
             from int_groups  
            where is_active=1
        ) int
    on (m.integration_id = int.integration_id)
         when not matched then insert (    
                    id,
                    integration_id,
                    name,
                    abbreviation,
                    number_of_peoples,
                    orguni_id,
                    colour,
                    group_type,
                    is_active
                ) 
         values (
               main_seq.nextval
             , int.integration_id
             , int.name
             , int.name
             , int.capacity
             , nvl(int.orguni_id,pDefaultOrgUniId)
             , round(dbms_random.value(128,255)) + 256*round(dbms_random.value(128,255)) + 256*256*round(dbms_random.value(128,255))
             , int.group_type
             , int.is_active
             )
         when matched then update 
            set 
                --name=int.name !Do not update name. Data loss is at stake!
                abbreviation=int.name
              , number_of_peoples=int.capacity
              , orguni_id=nvl(nvl(int.orguni_id,orguni_id),pDefaultOrgUniId)
              , group_type = int.group_type
              , is_active = int.is_active
              , last_updated_by = 'INTEGRATION'
              , last_update_date = sysdate
              ;
    ---          
    if (pCleanYpMode='Y') then
        trace := 'GROUPS.TRUNCATE GRO_PLA';
        execute immediate 'truncate table gro_pla';
    end if;
    trace := 'GROUPS.INSERT GRO_PLA';
    insert into gro_pla (id, gro_id, pla_id)
        select gropla_seq.nextval, gro_id, pla_id
        from (
        select gro.id gro_id, p.id pla_id from groups gro, planners p where gro.integration_id is not null and gro.is_active = '1'
        minus
        select gro_id, pla_id from gro_pla
        );
    ---   
    -- ******************************************************************
    -- ****************** FINALIZE *****************************************
    -- ******************************************************************
    xxmsz_tools.insertIntoEventLog('TO PLANSOFT_DCT:'||pCleanYpMode||': OK', 'I', 'INT_TO_PLANSOFT' );
    delete from xxmsztools_eventlog where module_name = 'INT_TO_PLANSOFT' and created < sysdate - 7;
    commit;
exception
    when others then
    xxmsz_tools.insertIntoEventLog(substrb('PLANSOFT_DCT: ' || pCleanYpMode || trace ||': '||sqlerrm,1,230), 'I', 'INT_TO_PLANSOFT' );
end;


function get_missing_periods (pperiod_name varchar2) return varchar2 is
 missingPeriods VARCHAR2(4000) := '';
begin
    for rec in (
    select unique cycle_name from int_plan where is_active='1' and cycle_name = nvl(pperiod_name, cycle_name)
    minus
    select name from periods
    ) 
    loop
      missingPeriods := xxmsz_tools.merge(missingPeriods, rec.cycle_name, ',');
    end loop;
    return missingPeriods;
end;

---------------------------------------------------------------------------------------------------------------------------------------
procedure int_to_plansoft_plan (pCleanYpMode varchar2 default 'N') as 
 trace varchar2(200);
 pperiod_name varchar2(200);
 pPER_ID number;
begin
    --
    delete from TT_COMBINATIONS where integration_id in (select integration_id from int_plan where is_active = '0');
    commit;
    select value into pperiod_name from system_parameters where name = 'INT_PERIOD_NAME';
    select Id into pPER_ID from Periods where name = pperiod_name;
    -- ******************************************************************
    -- ************* DATA INTEGRITY CHECK *******************************
    -- ******************************************************************
    declare
        missingPeriods VARCHAR2(4000) := '';
    begin
        missingPeriods := get_missing_periods(pperiod_name); 
        if nvl(missingPeriods,'-')<>'-' then
            xxmsz_tools.insertIntoEventLog(substrb(pperiod_name||'TO PLANSOFT_PLAN: MISSING PERIODS:' || missingPeriods ,1,230), 'I', 'INT_TO_PLANSOFT' );
        end if;
    end;
    -- 
    declare
     cnt number;
    begin
     select count(1) into cnt from bazus_sub_map;
     if (cnt > 0) then
        update int_plan 
          set alerts =  'REPLACED integration_id_sub:'||integration_id_sub
            , integration_id_sub = (select sub_integration_id from bazus_sub_map where sub_form_integration_id = integration_id_sub)      
          where cycle_name in (select name from periods)
           and  integration_id_sub not in (select sub_integration_id from bazus_sub_map where integration_id is not null)
           and alerts is null
           and is_active='1';
     end if;
    end;
    commit;
    --
    declare
        missingRes integer;
    begin
        select count(1) into missingRes 
        from int_plan 
        where cycle_name in (select name from periods)
        and is_active='1'
        and ((integration_id_lec not in (select integration_id from lecturers)
        or integration_id_gro not in (select integration_id from groups)
        or integration_id_sub not in (select integration_id from subjects)
        or integration_id_for not in (select integration_id from forms)));

        if missingRes > 0 then
            xxmsz_tools.insertIntoEventLog(substrb('TO PLANSOFT_PLAN: MISSING RESOURES:' || missingRes ,1,230), 'I', 'INT_TO_PLANSOFT' );
        end if;
    end;
    -- ******************************************************************
    -- *************TT_INTERFACE *************************************
    -- ******************************************************************
    declare
     prescat_comb_id number;
    begin
        trace := 'COMBINATIONS. INSERT TT_INTERFACE';
        delete from TT_INTERFACE;
        merge into TT_INTERFACE m using  
        (
        select integration_id 
              ,integration_id_lec
              ,integration_id_gro
              ,integration_id_sub
              ,integration_id_for 
              ,cycle_name
              ,cnt
              ,plan_id
            from int_plan
            where cycle_name in (select name from periods)
              and cycle_name = pperiod_name
              and integration_id_lec in (select integration_id from lecturers)
              and integration_id_gro in (select integration_id from groups)
              and integration_id_sub in (select integration_id from subjects)
              and integration_id_for in (select integration_id from forms)
              and is_active='1'
        ) int
    on (m.integration_id = int.integration_id)
         when not matched then insert (    
                    integration_id, lec_integration_id, sub_integration_id, for_integration_id, classes_cnt, gro_integration_id, cycle_name, plan_id
                )
         values ( int.integration_id, int.integration_id_lec, int.integration_id_sub, int.integration_id_for, int.cnt, int.integration_id_gro, int.cycle_name, int.plan_id
             );        --
        trace := 'COMBINATIONS. UPDATE TT_INTERFACE';
        update tt_interface
          set LEC_ID = (select Id from lecturers where integration_id=LEC_INTEGRATION_ID)
            , SUB_ID = (select Id from Subjects where integration_id=SUB_INTEGRATION_ID)
            , FOR_ID = (select Id from forms where integration_id=FOR_INTEGRATION_ID)    
            , GRO_ID = (select Id from groups where integration_id=GRO_INTEGRATION_ID)
            , PER_ID = pPER_ID;    
        select value into prescat_comb_id from system_parameters where name = 'INT_RESCAT_COMB_ID';
        commit;
        --link combination type with cycle
        trace := 'COMBINATIONS. INSERT TT_PLA';
        insert into TT_PLA (id, rescat_comb_id, pla_id)
            select TT_SEQ.nextval, prescat_comb_id, pla_id
            from (
            select prescat_comb_id prescat_comb_id, p.id pla_id from planners p 
            minus
            select rescat_comb_id, pla_id from TT_PLA
            );
        ---  
        -- ******************************************************************
        -- *************TT_COMBINATIONS *************************************
        -- ******************************************************************
        -- TT_COMBINATIONS
        trace := 'COMBINATIONS.MERGE';
         if (pCleanYpMode='Y') then
            delete from TT_COMBINATIONS where integration_id is not null;
         end if;
         merge into TT_COMBINATIONS  m 
         using (select * from TT_INTERFACE) int
            on (m.INTEGRATION_ID = int.integration_id)
          when not matched then insert (
               Id 
             , rescat_comb_id 
             , weight 
             , AVAIL_TYPE 
             , ENABLED 
             , avail_orig 
             , avail_curr
             , PER_ID
             , LEC_ID
             , GRO_ID
             , ROM_ID
             , SUB_ID
             , FOR_ID
             , integration_id
             , plan_id
          ) 
          values (
                TT_SEQ.NEXTVAL
              , prescat_comb_id
              , (select COMBINATION_NUMBER from TT_RESCAT_COMBINATIONS where Id = prescat_comb_id ) 
              , 'L'
              , 'Y'
              , int.CLASSES_CNT
              , int.CLASSES_CNT      
              , int.PER_ID
              , int.LEC_ID
              , int.GRO_ID
              , int.ROM_ID
              , int.SUB_ID
              , int.FOR_ID
              , int.integration_id
              , int.plan_id
          )
          when matched then 
          update set 
              avail_orig =  int.CLASSES_CNT
             , weight = (select COMBINATION_NUMBER from TT_RESCAT_COMBINATIONS where Id = prescat_comb_id )
             , PER_ID    = int.PER_ID
             , LEC_ID    = int.LEC_ID
             , GRO_ID    = int.GRO_ID
             , ROM_ID    = int.ROM_ID
             , SUB_ID    = int.SUB_ID
             , FOR_ID    = int.FOR_ID
             , PLAN_ID   = int.PLAN_ID
              , last_updated_by = 'INTEGRATION'
              , last_update_date = sysdate
             ;
         --
    ---  
    -- ******************************************************************
    -- *************TT_RESOURCE_LISTS *************************************
    -- ******************************************************************
         if (pCleanYpMode='Y') then
            trace := 'COMBINATIONS.DEL TT_RESOURCE_LISTS';
            delete from tt_resource_lists where tt_comb_id in (select Id from TT_COMBINATIONS where integration_id in (select integration_id from TT_INTERFACE ) );
         end if;
         trace := 'COMBINATIONS.INS TT_RESOURCE_LISTS';
         insert into tt_resource_lists (id, tt_comb_id, res_id)
          select TT_SEQ.NEXTVAL, id, res_id from 
          (
          select id, per_id res_id from TT_COMBINATIONS where integration_id in (select integration_id from TT_INTERFACE )
          union
          select id, LEC_ID from TT_COMBINATIONS where LEC_ID is not null and integration_id in (select integration_id from TT_INTERFACE )
          union
          select id, SUB_ID from TT_COMBINATIONS where SUB_ID is not null and integration_id in (select integration_id from TT_INTERFACE )
          union
          select id, FOR_ID from TT_COMBINATIONS where FOR_ID is not null and integration_id in (select integration_id from TT_INTERFACE )
          union
          select id, GRO_ID from TT_COMBINATIONS where GRO_ID is not null and integration_id in (select integration_id from TT_INTERFACE )
          union
          select id, ROM_ID from TT_COMBINATIONS where ROM_ID is not null and integration_id in (select integration_id from TT_INTERFACE )
          minus
          select tt_comb_id, res_id from tt_resource_lists
          );  
    ---  
    -- ******************************************************************
    -- *************TT_INCLUSIONS LIST *************************************
    -- ******************************************************************
          delete from TT_INCLUSIONS where inclusion_type = 'ALL' and tt_comb_id in (select Id from TT_COMBINATIONS where integration_id in (select integration_id from TT_INTERFACE ) );
          if (pCleanYpMode='Y') then
            trace := 'COMBINATIONS.DEL TT_INCLUSIONS';
            delete from TT_INCLUSIONS where tt_comb_id in (select Id from TT_COMBINATIONS where integration_id in (select integration_id from TT_INTERFACE ) );
          end if;
          trace := 'COMBINATIONS.INS TT_INCLUSIONS';
         insert into  TT_INCLUSIONS (id, tt_comb_id, rescat_id, inclusion_type)
          (
          select TT_SEQ.NEXTVAL, Id, rescat_id, inclusion_type
          from (
          select c.Id, rescat_id, 'LIST' inclusion_type
           from 
              (select id from TT_COMBINATIONS where integration_id in (select integration_id from TT_INTERFACE)) c --for each TT_COMBINATIONS ... (no where)
             , (select rescat_id from TT_RESCAT_COMBINATIONS_DTL where rescat_comb_id=prescat_comb_id) -- ... add the resource types
          minus
          select tt_comb_id, rescat_id, inclusion_type from TT_INCLUSIONS
          )
          );
    ---  
    -- ******************************************************************
    -- *************TT_INCLUSIONS ALL *************************************
    -- ******************************************************************
          trace := 'COMBINATIONS.UPD TT_INCLUSIONS.1';
          update TT_INCLUSIONS 
             set inclusion_type ='ALL' 
           where inclusion_type = 'LIST'
             and rescat_id = -4 
             and tt_comb_id in (
                    select Id 
                      from TT_COMBINATIONS 
                     where integration_id in (select integration_id from TT_INTERFACE) 
                      and lec_id is null
                 );
          trace := 'COMBINATIONS.UPD TT_INCLUSIONS.2';
          update TT_INCLUSIONS 
             set inclusion_type ='ALL' 
           where inclusion_type = 'LIST'
             and rescat_id = -2 
             and tt_comb_id in (
                    select Id 
                      from TT_COMBINATIONS 
                     where integration_id in (select integration_id from TT_INTERFACE) 
                      and for_id is null
                 );
          trace := 'COMBINATIONS.UPD TT_INCLUSIONS.3';
          update TT_INCLUSIONS 
             set inclusion_type ='ALL' 
           where inclusion_type = 'LIST'
             and rescat_id = -3 
             and tt_comb_id in (
                    select Id 
                      from TT_COMBINATIONS 
                     where integration_id in (select integration_id from TT_INTERFACE) 
                      and sub_id is null
                 );
          trace := 'COMBINATIONS.UPD TT_INCLUSIONS.4';
          update TT_INCLUSIONS 
             set inclusion_type ='ALL' 
           where inclusion_type = 'LIST'
             and rescat_id = -5 
             and tt_comb_id in (
                    select Id 
                      from TT_COMBINATIONS 
                     where integration_id in (select integration_id from TT_INTERFACE) 
                      and gro_id is null
                 );
          trace := 'COMBINATIONS.UPD TT_INCLUSIONS.5';
          update TT_INCLUSIONS 
             set inclusion_type ='ALL' 
           where inclusion_type = 'LIST'
             and rescat_id = -6 
             and tt_comb_id in (
                    select Id 
                      from TT_COMBINATIONS 
                     where integration_id in (select integration_id from TT_INTERFACE) 
                      and pla_id is null
                 );
          trace := 'COMBINATIONS.UPD TT_INCLUSIONS.6';
          update TT_INCLUSIONS 
             set inclusion_type ='ALL' 
           where inclusion_type = 'LIST'
             and rescat_id = -7 
             and tt_comb_id in (
                    select Id 
                      from TT_COMBINATIONS 
                     where integration_id in (select integration_id from TT_INTERFACE) 
                      and per_id is null
                 );
    end;   
    commit;
    ---  
    -- ******************************************************************
    -- *************recalc_combination122  ******************************
    -- ******************************************************************
    trace := 'COMBINATIONS.tt_planner.recalc_combination122';
    tt_planner.recalc_combination122( pCleanYpMode, pPER_ID );

    xxmsz_tools.insertIntoEventLog('TO PLANSOFT_PLAN:'||pperiod_name||':'||pCleanYpMode||': OK', 'I', 'INT_TO_PLANSOFT' );
    delete from xxmsztools_eventlog where module_name = 'INT_TO_PLANSOFT' and created < sysdate - 7;
    commit;
exception
    when others then
    xxmsz_tools.insertIntoEventLog(substrb('TO PLANSOFT_PLAN: '||pperiod_name||':' || trace ||': '||sqlerrm,1,230), 'I', 'INT_TO_PLANSOFT' );
end;






---------------------------------------------------------------------------------------------------------------------------------------
procedure int_from_plansoft (pCleanYpMode varchar2 default 'N') as 
  trace varchar2(200);
  pperiod_name varchar2(200);
  pDate_From date;
  pDate_To date;
  pPER_ID number;
  procedure setTrace (message varchar2) is begin
    trace := message;
    xxmsz_tools.insertIntoEventLog('FROM PLANSOFT:'||message, 'I', 'TRACE' );
  end;
begin   
    setTrace('***START int_from_plansoft***'); 
    select value into pperiod_name from system_parameters where name = 'INT_PERIOD_NAME';
    select date_from, date_to, id into pDate_From, pDate_To, pPER_ID from periods where name=pperiod_name;
    ---  
    -- ******************************************************************
    -- *************recalc_combination122  ******************************
    -- ******************************************************************
    setTrace('COMB122'); 
    tt_planner.recalc_combination122( pCleanYpMode, pPER_ID ); 

    declare
        prior_rec int_classes%rowtype;
        prior_rec_rowid varchar2(250);
    begin
        setTrace('TRUNCATE'); 
        execute immediate 'truncate table int_classes';
        execute immediate 'truncate table int_class_members';
        setTrace('INSERT_int_classes'); 
        insert into int_classes (
             id 
            , merged_id 
            , day 
            --, hour_from calculated later
            --, hour_to   calculated later
            , no_from
            , no_to 
            , sub_id 
            , for_id 
            , integration_id_sub 
            , integration_id_for 
            --, plan_integration_id  calculated later
            --, plan_integration_id2  calculated later
            --, tt_comb_cnt calculated later
            , sum 
            , desc1 
            , desc2 
            , calc_lec_ids
            , calc_gro_ids
            ,calc_rom_ids
            )
        select 
              cla.id 
            , cla.id merged_id
            , cla.day day
            , grids.no no_from
            , grids.no no_to
            , nvl(sub.Id,-1) sub_id
            , nvl(frm.Id,-1) for_id
            , nvl(sub.integration_id,'-1') integration_id_sub --later will be updated
            , nvl(frm.integration_id,'-1') integration_id_for
            , fill/100 * grids.duration sum
            , cla.desc1
            , cla.desc2
            , nvl(cla.calc_lec_ids,'-1')
            , nvl(cla.calc_gro_ids,'-1')
            , nvl(cla.calc_rom_ids,'-1')
        from classes cla
            ,grids
            ,subjects sub
            ,forms frm
        where    sub_id>0
             and for_id = frm.id
             and sub.id (+)= sub_id
             and cla.hour = grids.no
             and cla.day between pDate_from and pDate_to;
        commit;
        --
        setTrace('INSERT_int_class_members'); 
        insert into int_class_members 
        (cla_id 
         ,lec_gro_rom  
         ,lec_gro_rom_id  
         ,integration_id 
        ) 
        select cla_id
            , 'LEC'
            , lec_id
            , (select integration_id from lecturers where id = lec_id)
        from lec_cla
        where lec_id>0
         and day between pDate_from and pDate_to;
        --
        insert into int_class_members 
        (cla_id 
         ,lec_gro_rom  
         ,lec_gro_rom_id  
         ,integration_id 
        ) 
        select cla_id
            , 'GRO'
            , gro_id
            , (select integration_id from groups where id = gro_id)
        from gro_cla
        where gro_id>0
         --2023.02.10 do not transfer child records
         and is_child = 'N'
         and day between pDate_from and pDate_to;
        --
        insert into int_class_members 
        (cla_id 
         ,lec_gro_rom  
         ,lec_gro_rom_id  
         ,integration_id 
        ) 
        select cla_id
            , 'ROM'
            , rom_id
            , (select integration_id from rooms where id = rom_id)
        from rom_cla
        where rom_id>0
         and day between pDate_from and pDate_to;
        --
        commit;
        setTrace('UPDATE1'); 
        update int_classes tt
          set  plan_integration_id = nvl((
                select LISTAGG(nvl(integration_id,id), ',') within group (order by integration_id )  
                  from tt_combinations 
                  where nvl(integration_id,id) is not null 
                    and weight=122 
                    and id in (select tt_comb_id from tt_cla where cla_id= tt.id) 
          ),'-1')
             ,plan_integration_id2 = nvl((
                select LISTAGG(nvl(plan_id,id), ',') within group (order by plan_id )  
                  from tt_combinations 
                  where nvl(plan_id,id) is not null 
                    and weight=122 
                    and id in (select tt_comb_id from tt_cla where cla_id= tt.id) 
          ),'-1')
             , tt_comb_cnt         = (
                 select count(1)  
                  from tt_combinations 
                  where integration_id is not null 
                    and weight=122 
                    and id in (select tt_comb_id from tt_cla where cla_id= tt.id) 
                )
             ,integration_id_sub  = NVL( 
               --Search for 'Duplicated combination subject-type' is this package to understand why rownum=1 was added
               (select sub_form_integration_id from bazus_sub_map where sub_integration_id=tt.integration_id_sub and form_name=(select name from forms where id = tt.for_id )and rownum =1)
                -- if the bazus_sub_map is empty just use the original integration_id_sub
              , integration_id_sub)
             ;
        commit;
        setTrace('MERGE');
        for rec in (
            select rowid, calc_lec_ids, calc_gro_ids, calc_rom_ids, sub_id, for_id, day, no_from, no_to, sum, id, merged_id
              from int_classes 
              --where (calc_lec_ids, calc_gro_ids, calc_rom_ids, sub_id, for_id, day) in 
              --(
              --    select calc_lec_ids, calc_gro_ids, calc_rom_ids, sub_id, for_id, day
              --      from int_classes
              --      group by calc_lec_ids, calc_gro_ids, calc_rom_ids, sub_id, for_id, day
              --      having count(1)>1  
              --)
            order by calc_lec_ids, calc_gro_ids, calc_rom_ids, sub_id, for_id, day, no_from, no_to 
         ) loop
             if      rec.calc_lec_ids  = prior_rec.calc_lec_ids
                 and rec.calc_gro_ids  = prior_rec.calc_gro_ids
                 and rec.calc_rom_ids  = prior_rec.calc_rom_ids
                 and rec.sub_id        = prior_rec.sub_id
                 and rec.for_id        = prior_rec.for_id
                 and rec.day           = prior_rec.day                         
                 and rec.no_from       = prior_rec.no_to+1
             then
                 --merge current record into prior record
                 prior_rec.no_to := rec.no_to;
                 update int_classes set no_to = rec.no_to, sum = sum + rec.sum, merged_id = merged_id || ',' || rec.id where rowid = prior_rec_rowid; 
                 insert into helper1 (id) values (rec.id);
                 --delete from int_classes where rowid = rec.rowid;
             else
                 prior_rec_rowid         := rec.rowid;
                 prior_rec.day           := rec.day;
                 prior_rec.no_from       := rec.no_from;
                 prior_rec.no_to         := rec.no_to;
                 prior_rec.calc_lec_ids  := rec.calc_lec_ids;
                 prior_rec.calc_gro_ids  := rec.calc_gro_ids;
                 prior_rec.calc_rom_ids  := rec.calc_rom_ids;
                 prior_rec.sub_id        := rec.sub_id;
                 prior_rec.for_id        := rec.for_id;
             end if;
         end loop;
         setTrace('MERGE_Details');
         delete from int_classes where id in (select Id from helper1);
         delete from int_class_members where cla_id in (select cla_id from int_class_members minus select id from  int_classes);
        commit;
        setTrace('UPDATE2');
        update int_classes tt
          set hour_from = (select hour_from from grids where no = no_from)
             ,hour_to  = (select hour_to from grids where no = no_to)
             ;
         commit; 
         setTrace('COMMIT');
    end;

    setTrace('DIFF');
    integration_diff_catcher.diff;
    commit;

    xxmsz_tools.insertIntoEventLog('FROM PLANSOFT:'||pperiod_name||':'||pCleanYpMode||': OK', 'I', 'INT_FROM_PLANSOFT' );
    delete from xxmsztools_eventlog where module_name = 'INT_FROM_PLANSOFT' and created < sysdate - 7;
    delete from xxmsztools_eventlog where module_name = 'TRACE' and created < sysdate - 7;
    commit;
exception
    when others then
    xxmsz_tools.insertIntoEventLog(substrb('FROM PLANSOFT: '||pperiod_name||':'|| trace ||': '||sqlerrm,1,230), 'I', 'INT_FROM_PLANSOFT' );
end;

end;
/
