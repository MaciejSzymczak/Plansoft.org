create or replace package USOS is 

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

    procedure integration_from_usos_dict (pCleanYpMode varchar2 default 'N');
    procedure integration_from_usos_plan (pCleanYpMode varchar2 default 'N');
    procedure integration_to_usos (pCleanYpMode varchar2 default 'N');
end;
/

create or replace package body USOS is 

--2022.09.19 remove obsolete items from tt_resource_list

---------------------------------------------------------------------------------------------------------------------------------------
procedure integration_from_usos_dict (pCleanYpMode varchar2 default 'N') as 
 trace varchar2(200);
begin
    if (pCleanYpMode='Y') then
      rollback; --sometimes required by USOS!
    end if;

    --declare x decimal; begin x := 1/0; end; --deliberate error
    -- ******************************************************************
    -- ****************** LECTURERS *************************************
    -- ******************************************************************
    trace := 'LECTURERS.MERGE';
    merge into lecturers m using  
        (
            select id, nazwa, imie, nazwisko || decode(abbrPostfixName,1,null,abbrPostfixName) as nazwisko
            , abbrPrefix || decode(abbrPostfix,1,null,abbrPostfix) abbreviation, orguni_id from 
            (
            SELECT o.id, t.nazwa, o.imie, o.nazwisko, (select id from org_units where code = o.jed_org_kod) orguni_id
                 , lpad(o.imie,2)||lpad(o.nazwisko,2) abbrPrefix
                 , ROW_NUMBER() OVER (PARTITION BY lpad(o.imie,2)||lpad(o.nazwisko,2) ORDER BY o.utw_data, o.imie, o.nazwisko ) AS abbrPostfix
                 , ROW_NUMBER() OVER (PARTITION BY o.imie||o.nazwisko ORDER BY o.utw_data, o.imie, o.nazwisko ) AS abbrPostfixName
                from dz_osoby@USOS o 
                inner join dz_pracownicy@USOS p on p.os_id = o.id 
                left join dz_tytuly@USOS t on t.id = o.tytul_przed
                where p.id is not null
            )  
        ) usos
    on (m.integration_id = usos.id)
         when not matched then insert (id, abbreviation, title, first_name, last_name, integration_id, orguni_id, colour) 
         values (main_seq.nextval, abbreviation, usos.nazwa, usos.imie, usos.nazwisko,  usos.id, usos.orguni_id
               , round(dbms_random.value(128,255)) + 256*round(dbms_random.value(128,255)) + 256*256*round(dbms_random.value(128,255)))
         when matched then update 
            set title=usos.nazwa
              , first_name=usos.imie
              , last_name=usos.nazwisko
              , abbreviation = usos.abbreviation
              , orguni_id=usos.orguni_id;
    --
    if (pCleanYpMode='Y') then
      trace := 'LECTURERS.TRUNCATE LEC_PLA';
      execute immediate 'truncate table lec_pla';
    end if;
    trace := 'LECTURERS.INSERT LEC_PLA';
    insert into lec_pla (id, lec_id, pla_id)
        select lecpla_seq.nextval, lec_id,pla_id  from
        (
        select l.id lec_id, p.id pla_id from lecturers l, planners p
        minus
        select lec_id,pla_id from lec_pla
        );
    -- ******************************************************************
    -- ****************** ROLE ******************************************
    -- ******************************************************************
    trace := 'ROLE.MERGE';
    merge into planners m using  
        (
         select opis, kod from dz_cykle_dydaktyczne@usos 
          where kod in (select value from system_parameters where name like 'USOS_CYKL%')
        ) usos
    on (m.integration_id = usos.kod)
         when not matched then insert (
            id,
            name,
            type,
            colour,
            active_flag,
            is_admin,
            edit_org_units,
            edit_flex,
            log_changes,
            many_subjects_flag,
            edit_reservations,
            edit_sharing,
            can_edit_l,
            can_edit_g,
            can_edit_r,
            can_edit_s,
            can_edit_f,
            can_delete,
            can_insert,
            can_edit_o,
            can_edit_d,
            first_resource_flag,
            integration_id
         ) 
         values (main_seq.nextval,
            usos.opis /*name*/,
            'ROLE' /*type*/,
            round(dbms_random.value(128,255)) + 256*round(dbms_random.value(128,255)) + 256*256*round(dbms_random.value(128,255)) /*colour*/,
            '+' /*active_flag*/,
            '+' /*is_admin*/,
            '+' /*edit_org_units*/,
            '+' /*edit_flex*/,
            '+' /*log_changes*/,
            '-' /*many_subjects_flag*/,
            '+' /*edit_reservations*/,
            '+' /*edit_sharing*/,
            '+' /*can_edit_l*/,
            '+' /*can_edit_g*/,
            '+' /*can_edit_r*/,
            '+' /*can_edit_s*/,
            '+' /*can_edit_f*/,
            '+' /*can_delete*/,
            '+' /*can_insert*/,
            '+' /*can_edit_o*/,
            '+' /*can_edit_d*/,
            '+' /*first_resource_flag*/,
            usos.kod /* integration_id */ )
         when matched then update 
            set name= usos.opis;    
    -- ******************************************************************
    -- ****************** PERIOD ****************************************
    -- ******************************************************************
    trace := 'PERIOD.MERGE';
    merge into periods m using  
        (
         select opis, data_od, data_do, kod
              , (select id from planners where integration_id = kod) rol_id
         from dz_cykle_dydaktyczne@usos 
          where kod in (select value from system_parameters where name like 'USOS_CYKL%')
        ) usos
    on (m.integration_id = usos.kod)
         when not matched then insert (
            id,
            name,
            date_from,
            date_to,
            show_mon,
            show_tue,
            show_wed,
            show_thu,
            show_fri,
            show_sat,
            show_sun,
            hours_per_day,
            rol_id,
            integration_id                  
         ) 
         values (main_seq.nextval,
            usos.opis || ' (' || usos.kod || ')',
            usos.data_od,
            usos.data_do,
            '+','+','+','+','+','+','+',
            (select value from system_parameters where name= 'USOS_HOURS_PER_DAY'),
            usos.rol_id,
            usos.kod 
         )   
         when matched then update 
            set name=usos.opis || ' (' || usos.kod || ')'
              , date_from=usos.data_od
              , date_to=usos.data_do;    
    --    
    delete from per_pla;
    insert into per_pla (id, per_id, pla_id)
    select perPLA_SEQ.nextval, periods.id, planners.id
    from planners, periods;
    --    
    trace := 'PERIOD.DELETE ROL_PLA';
    delete from rol_pla where rol_id in (select id rol_id from planners where integration_id in (select value from system_parameters where name like 'USOS_CYKL%'));
    trace := 'PERIOD.INSERT ROL_PLA';
    insert into rol_pla (id, rol_id, pla_id)
        select rolpla_seq.nextval, r.rol_id, p.id 
        from  
        (select id rol_id from planners where integration_id in (select value from system_parameters where name like 'USOS_CYKL%')) r
        ,(select id from planners where type = 'USER') p;

    -- ******************************************************************
    -- ****************** SUBJECTS **************************************
    -- ******************************************************************
    trace := 'SUBJECTS.MERGE';
    merge into subjects m using  
        (
            select kod
                 , nazwa || '('||kod||')' as nazwa
                 --, nazwa || decode(Postfix,1,null,'('||kod||')') as nazwa
                 , cdyd_kod, orguni_id , gr_codes , gr_descs
            from
            (
            SELECT p.kod
                 , p.nazwa
                 --, ROW_NUMBER() OVER (PARTITION BY nazwa ORDER BY kod ) AS Postfix                 
                 , c.cdyd_kod
                 , (select Id from org_units where code = p.JED_ORG_KOD) orguni_id 
                 , gr_codes
                 , gr_descs
             from
             (
                SELECT 
                    p.kod,
                    p.nazwa,
                    p.JED_ORG_KOD,
                    LISTAGG(g.kod, ', ') WITHIN GROUP (ORDER BY g.kod) AS gr_codes,
                    LISTAGG(g.kod ||'(' || g.opis || ')', ', ') WITHIN GROUP (ORDER BY g.kod) AS gr_descs
                FROM 
                    dz_przedmioty@USOS p
                    LEFT JOIN dz_elem_grup_przedmiotow@USOS egp 
                        ON egp.prz_kod = p.kod
                    LEFT JOIN dz_grupy_przedmiotow@USOS g 
                        ON egp.grprz_kod = g.kod
                GROUP BY 
                    p.kod,  p.nazwa, p.JED_ORG_KOD
             ) p
            inner join dz_przedmioty_cykli@USOS c on c.prz_kod = p.kod
            where c.cdyd_kod in (select value from system_parameters where name like 'USOS_CYKL%')
            )
        ) usos
    on (m.integration_id = usos.kod)
         when not matched then insert (
         id,
         abbreviation,
         name,
         colour,
         orguni_id,
         integration_id,
         ATTRIBS_01,
         ATTRIBS_02
         ) 
         values (main_seq.nextval
               , usos.kod  
               , usos.nazwa
               , round(dbms_random.value(128,255)) + 256*round(dbms_random.value(128,255)) + 256*256*round(dbms_random.value(128,255))
               , usos.orguni_id
               , usos.kod
               , gr_codes
               , gr_descs
               )
         when matched then update 
            set abbreviation=usos.kod
              , name=usos.nazwa
              , orguni_id=usos.orguni_id
              , ATTRIBS_01=usos.gr_codes
              , ATTRIBS_02=usos.gr_descs
              ;
    ---   
    if (pCleanYpMode='Y') then
        trace := 'SUBJECTS.DELETE SUB_PLA';
        delete from sub_pla where pla_id in (select id  from planners where integration_id in (select value from system_parameters where name like 'USOS_CYKL%'));
    end if; 
    trace := 'SUBJECTS.INSERT SUB_PLA';
    insert into sub_pla (id, pla_id, sub_id)
        select subpla_seq.nextval, pla_id, sub_id
        from (
        select 
               r.id pla_id
             , sub.id  sub_id
        from  
        (select id from planners where integration_id in (select value from system_parameters where name like 'USOS_CYKL%')) r
        ,(select id 
          from subjects where abbreviation in (
            SELECT prz_kod
             from dz_przedmioty_cykli@USOS c
            where c.cdyd_kod in (select value from system_parameters where name like 'USOS_CYKL%')
          )) sub
          minus 
          select pla_id, sub_id from sub_pla
          );
    ---   
    -- ******************************************************************
    -- ****************** ROOMS *****************************************
    -- ******************************************************************
    trace := 'ROOMS.MERGE';
    merge into rooms m using  
        (
         select id
             , numer
             , liczba_miejsc
             , bud_kod
             , nvl((select id from org_units where code = jed_org_kod),(select id from org_units where rownum=1)) orguni_id 
             from dz_sale@usos  
        ) usos
    on (m.integration_id = usos.id)
         when not matched then insert (    
                    id,
                    name,
                    rescat_id, 
                    attribn_01,
                    attribs_01,
                    integration_id,
                    orguni_id,
                    colour
                ) 
         values (
               main_seq.nextval
             , usos.numer
             , 1
             , usos.liczba_miejsc
             , usos.bud_kod
             , usos.id
             , usos.orguni_id
             , round(dbms_random.value(128,255)) + 256*round(dbms_random.value(128,255)) + 256*256*round(dbms_random.value(128,255)))
         when matched then update 
            set name=usos.numer
              , attribn_01=usos.liczba_miejsc
              , attribs_01=usos.bud_kod
              , orguni_id=usos.orguni_id;
    ---          
    if (pCleanYpMode='Y') then
        trace := 'ROOMS.TRUNCATE ROM_PLA';
        execute immediate 'truncate table rom_pla';
    end if;
    trace := 'ROOMS.INSERT ROM_PLA';
    insert into rom_pla (id, rom_id, pla_id)
        select rompla_seq.nextval, rom_id, pla_id
        from (
        select rom.id rom_id, p.id pla_id from rooms rom, planners p where upper(rom.name) not like '%STREAMING%'
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
          select substrb(kod,1,30) kod
               , substrb(opis,1,30) opis
               , description from dz_typy_zajec@usos
        ) usos
    on (m.integration_id = usos.kod)
         when not matched then insert (
            id,
            abbreviation,
            name,
            kind,
            sort_order_on_reports,
            colour,
            integration_id
         ) 
         values (main_seq.nextval
                ,usos.kod
                ,usos.opis
                ,'C'
                , 1
                , round(dbms_random.value(128,255)) + 256*round(dbms_random.value(128,255)) + 256*256*round(dbms_random.value(128,255))
                ,usos.kod
         )       
         when matched then update 
            set abbreviation=usos.kod
              , name=usos.opis;
    ---          
    if (pCleanYpMode='Y') then
        trace := 'FORMS.TRUNC FOR_PLA';
        execute immediate 'truncate table for_pla';
    end if;
    trace := 'FORMS.INSERT FOR_PLA';
    insert into for_pla (id, for_id, pla_id)
        select forpla_seq.nextval, for_id, pla_id 
        from (
        select m.id for_id, p.id  pla_id from forms m, planners p
        minus
        select for_id, pla_id from for_pla
        );
    ---
    -- **********************************************************
    -- ************* GROUPS *************************************
    -- **********************************************************
    trace := 'GROUPS.MERGE';
    merge into groups m using  
        (
            select unique 
                   g.opis name
                 , g.opis integration_id
                 , org_units.Id orguni_id
                 , zc.cdyd_kod
            from DZ_ZAJECIA_CYKLI@usos zc
            inner join dz_przedmioty@usos p on p.kod = zc.prz_kod
            inner join dz_grupy@usos g on g.zaj_cyk_id = zc.id 
            --inner join dz_prowadzacy_grup@usos pg on pg.zaj_cyk_id = zc.id and pg.gr_nr = g.nr
            , org_units
            where  code = p.JED_ORG_KOD 
              and zc.cdyd_kod in (select value from system_parameters where name like 'USOS_CYKL%')
              and g.opis is not null
              and not g.opis like '% %'
              and length(g.opis)<30
              --and nvl(pg.liczba_godz, zc.liczba_godz) >0
        ) usos
    on (m.integration_id = usos.integration_id)
         when not matched then insert (    
                    id,
                    abbreviation,
                    name,
                    number_of_peoples,
                    colour,
                    group_type,
                    orguni_id,
                    integration_id,
                    usos_period
                )
         values (
               main_seq.nextval
             , usos.name
             , usos.name
             , 0
             , round(dbms_random.value(128,255)) + 256*round(dbms_random.value(128,255)) + 256*256*round(dbms_random.value(128,255))
             , 'OTHER'
             , usos.orguni_id
             , usos.integration_id
             , usos.cdyd_kod
             )
         when matched then update 
            set abbreviation=usos.name
              , name=usos.name
              , orguni_id=usos.orguni_id
              , usos_period=usos.cdyd_kod;
    --
    if (pCleanYpMode='Y') then
      trace := 'GROUPS.DEL GRO_PLA';
      delete from gro_pla where gro_id in (select id from groups where usos_period in (select value from system_parameters where name like 'USOS_CYKL%'));
    end if;
    trace := 'GROUPS.INSERT GRO_PLA';
    insert into gro_pla (id, gro_id, pla_id)
        select gropla_seq.nextval, gro_id, pla_id
        from (
            select r.Id gro_id, p.id pla_id 
            from  
            (select id  from groups where usos_period in (select value from system_parameters where name like 'USOS_CYKL%')) r
            ,(select id from planners where integration_id in (select value from system_parameters where name like 'USOS_CYKL%')) p
            minus 
            select gro_id, pla_id from gro_pla
        );
    xxmsz_tools.insertIntoEventLog('FROM USOS_DCT:'||pCleanYpMode||': OK', 'I', 'INTEGRATION_FROM_USOS' );
    delete from xxmsztools_eventlog where module_name = 'INTEGRATION_FROM_USOS' and created < sysdate - 7;
    commit;
--exception
--    when others then
--    xxmsz_tools.insertIntoEventLog(substrb('FROM USOS: ' || pCleanYpMode || trace ||': '||sqlerrm,1,230), 'I', 'INTEGRATION_FROM_USOS' );
end;


---------------------------------------------------------------------------------------------------------------------------------------
procedure integration_from_usos_plan (pCleanYpMode varchar2 default 'N') as 
 trace varchar2(200);
begin
    -- ******************************************************************
    -- *************TT_INTERFACE *************************************
    -- ******************************************************************
    declare
     pCycle_pla_id number; 
     pCycle_per_id number; 
     prescat_comb_id number;
    begin
        trace := 'COMBINATIONS. INSERT TT_INTERFACE';
        delete from TT_INTERFACE;
        merge into TT_INTERFACE m using  
        (
            select  
              zc.id ||'-'|| o.id ||'-'|| g.nr ||'-'|| p.kod ||'-'|| zc.tzaj_kod  integration_id
            , o.id  lec_integration_id
            , g.opis gro_integration_id
            , p.kod sub_integration_id
            , zc.tzaj_kod for_integration_id
            , nvl(pg.liczba_godz, zc.liczba_godz) classes_cnt 
            , g.nr usos_gr_nr
            , zc.id usos_zaj_cyk_id
        from DZ_ZAJECIA_CYKLI@usos zc
        inner join dz_przedmioty@usos p on p.kod = zc.prz_kod
        inner join dz_grupy@usos g on g.zaj_cyk_id = zc.id 
        left outer join dz_prowadzacy_grup@usos pg on pg.zaj_cyk_id = zc.id and pg.gr_nr = g.nr
        left outer join dz_pracownicy@usos prac on prac.id = pg.prac_id
        left outer join dz_osoby@usos o on o.id = prac.os_id
        inner join dz_typy_zajec@usos tz on tz.kod = zc.tzaj_kod
        where  zc.cdyd_kod in (select value from system_parameters where name like 'USOS_CYKL%')
          and g.opis is not null
          and not g.opis like '% %'
          and length(g.opis)<30
          --and nvl(pg.liczba_godz, zc.liczba_godz) >0
        ) usos
    on (m.integration_id = usos.integration_id)
         when not matched then insert (    
                    integration_id, lec_integration_id, sub_integration_id, for_integration_id, classes_cnt, gro_integration_id, usos_gr_nr, usos_zaj_cyk_id
                )
         values ( usos.integration_id, usos.lec_integration_id, usos.sub_integration_id, usos.for_integration_id, usos.classes_cnt, usos.gro_integration_id, usos.usos_gr_nr, usos.usos_zaj_cyk_id
             );        --
        trace := 'COMBINATIONS. UPDATE TT_INTERFACE';
        update tt_interface
          set LEC_ID = (select Id from lecturers where integration_id=LEC_INTEGRATION_ID)
            , SUB_ID = (select Id from Subjects where integration_id=SUB_INTEGRATION_ID)
            , FOR_ID = (select Id from forms where integration_id=FOR_INTEGRATION_ID)    
            , GRO_ID = (select Id from groups where integration_id=GRO_INTEGRATION_ID);    
        select value into prescat_comb_id from system_parameters where name = 'USOS_RESCAT_COMB_ID';
        select id into pCycle_per_id from periods where integration_id = (select value from system_parameters where name like 'USOS_CYKL%');
        trace := 'COMBINATIONS. UPDATE2 TT_INTERFACE';
        update tt_interface set per_id = pCycle_per_id;
        --
        select id rol_id 
          into pCycle_pla_id
          from planners where integration_id = (select value from system_parameters where name like 'USOS_CYKL%');
        --link combination type with cycle
        trace := 'COMBINATIONS. INSERT TT_PLA';
        delete from TT_PLA where Pla_Id = pCycle_pla_id;
        insert into TT_PLA (Id, pla_id, rescat_comb_id) values (TT_SEQ.NEXTVAL, pCycle_pla_id, prescat_comb_id);
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
         using (select * from TT_INTERFACE) usos
            on (m.INTEGRATION_ID = usos.integration_id)
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
             , usos_gr_nr
             , usos_zaj_cyk_id
          ) 
          values (
                TT_SEQ.NEXTVAL
              , prescat_comb_id
              , (select COMBINATION_NUMBER from TT_RESCAT_COMBINATIONS where Id = prescat_comb_id ) 
              , 'L'
              , 'Y'
              , usos.CLASSES_CNT
              , usos.CLASSES_CNT      
              , usos.PER_ID
              , usos.LEC_ID
              , usos.GRO_ID
              , usos.ROM_ID
              , usos.SUB_ID
              , usos.FOR_ID
              , usos.integration_id
              , usos.usos_gr_nr
              , usos.usos_zaj_cyk_id
          )
          when matched then 
          update set 
              avail_orig =  usos.CLASSES_CNT
             , weight = (select COMBINATION_NUMBER from TT_RESCAT_COMBINATIONS where Id = prescat_comb_id )
             , PER_ID    = usos.PER_ID
             , LEC_ID    = usos.LEC_ID
             , GRO_ID    = usos.GRO_ID
             , ROM_ID    = usos.ROM_ID
             , SUB_ID    = usos.SUB_ID
             , FOR_ID    = usos.FOR_ID
             , usos_gr_nr      = usos.usos_gr_nr
             , usos_zaj_cyk_id = usos.usos_zaj_cyk_id;
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
          --remove obsolete items
         delete from tt_resource_lists where id in (select l.id from tt_resource_lists l, tt_combinations ttc where ttc.id = l.tt_comb_id and l.res_id in (select Id from groups) and l.res_id <> ttc.gro_id);
         delete from tt_resource_lists where id in (select l.id from tt_resource_lists l, tt_combinations ttc where ttc.id = l.tt_comb_id and l.res_id in (select Id from lecturers) and l.res_id <> ttc.lec_id);
         delete from tt_resource_lists where id in (select l.id from tt_resource_lists l, tt_combinations ttc where ttc.id = l.tt_comb_id and l.res_id in (select Id from rooms) and l.res_id <> ttc.rom_id);
         delete from tt_resource_lists where id in (select l.id from tt_resource_lists l, tt_combinations ttc where ttc.id = l.tt_comb_id and l.res_id in (select Id from subjects) and l.res_id <> ttc.sub_id);
         delete from tt_resource_lists where id in (select l.id from tt_resource_lists l, tt_combinations ttc where ttc.id = l.tt_comb_id and l.res_id in (select Id from forms) and l.res_id <> ttc.for_id);
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

    ---  
    -- ******************************************************************
    -- *************recalc_combination122  ******************************
    -- ******************************************************************
    tt_planner.recalc_combination122( pCleanYpMode );

    xxmsz_tools.insertIntoEventLog('FROM USOS_PLAN:'||pCleanYpMode||': OK', 'I', 'INTEGRATION_FROM_USOS' );
    delete from xxmsztools_eventlog where module_name = 'INTEGRATION_FROM_USOS' and created < sysdate - 7;
    commit;
exception
    when others then
    xxmsz_tools.insertIntoEventLog(substrb('FROM USOS: ' || trace ||': '||sqlerrm,1,230), 'I', 'INTEGRATION_FROM_USOS' );
end;










---------------------------------------------------------------------------------------------------------------------------------------
procedure integration_to_usos (pCleanYpMode varchar2 default 'N') as 
  trace varchar2(200);
begin      
    if (pCleanYpMode='Y') then
        rollback; --sometimes required by USOS!
        ---  
        -- ******************************************************************
        -- *************recalc_combination122  ******************************
        -- ******************************************************************
        tt_planner.recalc_combination122( pCleanYpMode );
    end if;

    -- ******************************************************
    -- ****************** MERGE *****************************
    -- ******************************************************
    trace := 'MERGE';
    declare
     pDate_from date;
     pDate_to date;
     prior_rec usos_temp%rowtype;
     prior_rec_rowid varchar2(250);
     pUsosOnline varchar2(30);
    begin
        select date_from, date_to 
        into pDate_from, pDate_to 
        from periods
        where integration_id in (select value from system_parameters where name like 'USOS_CYKL%'); 
        select value into pUsosOnline from system_parameters where name = 'USOS_ONLINE';
        execute immediate 'truncate table usos_temp';
        insert into usos_temp (day, no_from, no_to, lec_id, gro_id, rom_id, sub_id, classes_sub_id, for_id, gr_nr, sl_id, zaj_cyk_id, desc2)
            select classes.day
                ,  classes.hour
                ,  classes.hour
                ,  ttc.lec_id
                ,  ttc.gro_id
                ,  nvl(rom_cla.rom_id,0) rom_id --rom is extracted froom classes, lec, gro, sub and for is extracted from combinations
                ,  ttc.sub_id /* child subject */
                ,  classes.sub_id /*actual sub_id, typically parent subject, but can be also child subject*/
                ,  ttc.for_id      
                --
               , ttc.usos_gr_nr gr_nr
               , nvl(rooms.integration_id,pUsosOnline) sl_id
               , ttc.usos_zaj_cyk_id zaj_cyk_id
               , classes.desc2
             from classes
               , tt_cla
               , tt_combinations ttc
               , rom_cla
            , rooms
            where tt_cla.tt_comb_id= ttc.id
             and tt_cla.cla_id = classes.id
             and rom_cla.cla_id(+) = classes.id
             and rom_cla.rom_id = rooms.id(+)
             and ttc.integration_id is not null--ignore those created manually in Plansoft (no reference in USOS)
             and classes.DAY BETWEEN pDate_from AND pDate_to;  
         --    
         update usos_temp 
           set rom_id = nvl( (select streaming_id from usos_streaming_room_map where id=rom_id) , rom_id)
         where upper(desc2) like '%STREAMING%';
         --
         update usos_temp set lec_id = -1 where lec_id is null;
         update usos_temp set gro_id = -1 where gro_id is null;
         update usos_temp set rom_id = -1 where rom_id is null;
         update usos_temp set sub_id = -1 where sub_id is null;
         update usos_temp set for_id = -1 where for_id is null;
         for rec in (
            select rowid, day, no_from, no_to, lec_id, gro_id, rom_id, sub_id, for_id 
              from usos_temp
              where (lec_id, gro_id, rom_id, sub_id, for_id, day) in 
              (
                  select lec_id, gro_id, rom_id, sub_id, for_id, day
                    from usos_temp
                    group by lec_id, gro_id, rom_id, sub_id, for_id, day
                    having count(1)>1  
              )
            order by lec_id, gro_id, rom_id, sub_id, for_id, day, no_from
         ) loop
             if      rec.day = prior_rec.day 
                 and nvl(rec.lec_id,-1) = nvl(prior_rec.lec_id,-1) --merge classes even if lec_id is blank 
                 and nvl(rec.gro_id,-1) = nvl(prior_rec.gro_id,-1)
                 and nvl(rec.rom_id,-1) = nvl(prior_rec.rom_id,-1) 
                 and nvl(rec.sub_id,-1) = nvl(prior_rec.sub_id,-1) 
                 and nvl(rec.for_id,-1) = nvl(prior_rec.for_id,-1)
                 and rec.no_from = prior_rec.no_to+1
             then
                 --merge current record into prior record
                 prior_rec.no_to := rec.no_to;
                 update usos_temp set no_to = rec.no_to where rowid = prior_rec_rowid; 
                 delete from usos_temp where rowid = rec.rowid;
             else
                 prior_rec_rowid  := rec.rowid;
                 prior_rec.day    := rec.day;
                 prior_rec.no_from:= rec.no_from;
                 prior_rec.no_to  := rec.no_to;
                 prior_rec.lec_id := rec.lec_id;
                 prior_rec.gro_id := rec.gro_id;
                 prior_rec.rom_id := rec.rom_id;
                 prior_rec.sub_id := rec.sub_id;
                 prior_rec.for_id := rec.for_id;
             end if;
         end loop;
         update usos_temp set lec_id = null where lec_id =-1;
         update usos_temp set gro_id = null where gro_id =-1;
         update usos_temp set rom_id = null where rom_id =-1;
         update usos_temp set sub_id = null where sub_id =-1;
         update usos_temp set for_id = null where for_id =-1;
         commit;
    end;

    -- ******************************************************
    -- ****************** CLEAR *****************************
    -- ******************************************************
    declare
      pIntegrationUser varchar2(30);
    begin
        select value into pIntegrationUser from system_parameters where name = 'USOS_INTEGRATION_USER';
        delete from DZ_TERMINY_GRUP_PROW_SPTK@usos where tgsp_id  in (select id from DZ_TERMINY_GRUP_SPTK@usos where TRM_GRUP_ID in (select id from dz_terminy_grup@usos where utw_id=pIntegrationUser));
        delete from DZ_TERMINY_GRUP_SPTK@usos where utw_id=pIntegrationUser;
        delete from DZ_TERMINY_GRUP_SPTK@usos where TRM_GRUP_ID in (select id from dz_terminy_grup@usos where utw_id=pIntegrationUser);
        delete from dz_terminy_grup@usos where utw_id=pIntegrationUser;
        delete from dz_terminy@usos where utw_id=pIntegrationUser;
        commit;
    end;

    -- ******************************************************************
    -- ****************** DZ_TERMINY.INSERT *****************************
    -- ******************************************************************
    trace := 'DZ_TERMINY.INSERT';
    update USOS_TEMP
      set from_hour = (select substr(hour_from,1,2) from grids where no = no_from)
         ,from_min  = (select substr(hour_from,4,2) from grids where no = no_from)
         ,to_hour   = (select substr(hour_to,1,2) from grids where no = no_to)
         ,to_min    = (select substr(hour_to,4,2) from grids where no = no_to);
     commit;    
      --   
      insert into dz_terminy@usos (DZIEN_TYGODNIA,GODZINA_POCZATKU,MINUTA_POCZATKU,GODZINA_KONCA,MINUTA_KONCA)
        SELECT unique trim(to_char(DAY,'DAY', 'NLS_DATE_LANGUAGE=POLISH')) DZIEN_TYGODNIA
             , from_hour GODZINA_POCZATKU
             , from_min MINUTA_POCZATKU
             , to_hour GODZINA_KONCA
             , to_min MINUTA_KONCA
        FROM USOS_TEMP
        minus
        select DZIEN_TYGODNIA,GODZINA_POCZATKU,MINUTA_POCZATKU,GODZINA_KONCA,MINUTA_KONCA from dz_terminy@usos;        
    -- ******************************************************************
    -- ****************** dz_terminy_grup.INSERT ************************
    -- ******************************************************************
    trace := 'dz_terminy_grup.INSERT';
    update USOS_TEMP
      set trm_id = (
             select Id 
             from dz_terminy@usos 
             where DZIEN_TYGODNIA =  trim(to_char(DAY,'DAY', 'NLS_DATE_LANGUAGE=POLISH')) 
               and GODZINA_POCZATKU = from_hour 
               and MINUTA_POCZATKU = from_min 
               and GODZINA_KONCA =  to_hour 
               and MINUTA_KONCA =  to_min      
      );
    --commit; 2025.03.05
    --
     --Avoid the error: ORA-02291: integrity constraint (USOS_PROD_TAB.TRM_GR_SL_FK) violated - parent key not found
     for rec in (
         select name, integration_id from rooms where integration_id in (
         select sl_id from usos_temp
         minus 
         select id from dz_sale@usos
         )
     ) loop 
       raise_application_error(-20001, 'W USOS nie ma sali: '||rec.name||' Id:'||rec.integration_id);
     end loop;
    --  
    insert into dz_terminy_grup@usos (gr_nr, sl_id, zaj_cyk_id, trm_id, czestotliwosc)
    select UNIQUE 
           gr_nr
         , sl_id
         , zaj_cyk_id
         , trm_id
         , 'INNA_CZESTOTLIWOSC'
     from usos_temp;
    --
    -- ******************************************************************
    -- ****************** DZ_TERMINY_GRUP_SPTK.INSERT ************************
    -- ******************************************************************
    trace := 'usos_temp.update PRAC_ID';
    update usos_temp
      set prac_id = (select id from dz_pracownicy@USOS p where os_id = (select integration_id from lecturers where id = usos_temp.lec_id))
        , USOS_OD_DATA = to_date(to_char(day,'YYYY-MM-DD')||' '||lpad(from_hour,2,'0')||':'||lpad(from_min,2,'0')||':00','YYYY-MM-DD HH24:MI:SS')
        , USOS_DO_DATA = to_date(to_char(day,'YYYY-MM-DD')||' '||lpad(to_hour,2,'0')||':'||lpad(to_min,2,'0')||':00','YYYY-MM-DD HH24:MI:SS');
    trace := 'usos_temp.update';
    update usos_temp
       set TRM_GRUP_ID =
            (select Id 
                from dz_terminy_grup@usos
                where gr_nr= usos_temp.gr_nr
                  and sl_id= usos_temp.sl_id
                  and zaj_cyk_id=usos_temp.zaj_cyk_id
                  and trm_id= usos_temp.trm_id 
                  and czestotliwosc='INNA_CZESTOTLIWOSC'
                );  
    --commit;   2025.03.05          
    --   
    insert into DZ_TERMINY_GRUP_SPTK@usos (TRM_GRUP_ID,SL_ID,OD_DATA,DO_DATA,GR_NR,ZAJ_CYK_ID)
    select  unique TRM_GRUP_ID
           ,SL_ID
           , USOS_OD_DATA
           , USOS_DO_DATA
           ,GR_NR
           ,ZAJ_CYK_ID
     from usos_temp;
    -- commit;  2025.03.05
    --
    -- ******************************************************************
    -- ****************** DZ_TERMINY_GRUP_PROW_SPTK.INSERT ************************
    -- ******************************************************************
    trace := 'DZ_TERMINY_GRUP_PROW_SPTK.insert';
    insert into DZ_TERMINY_GRUP_PROW_SPTK@usos (TGSP_ID, PRAC_ID)
      select unique TGSP_ID, prac_id
      from(
      select 
            (select Id from DZ_TERMINY_GRUP_SPTK@usos
             where TRM_GRUP_ID = usos_temp.TRM_GRUP_ID
               and SL_ID       = usos_temp.SL_ID
               and OD_DATA     = usos_OD_DATA
               and DO_DATA     = usos_DO_DATA
               and GR_NR       = usos_temp.GR_NR
               and ZAJ_CYK_ID  = usos_temp.ZAJ_CYK_ID
            ) TGSP_ID
            , prac_id
       from usos_temp
       )
       where prac_id is not null and TGSP_ID is not null;
       -- commit;  2025.03.05
    --
    -- ******************************************************************
    -- ****************** Rollup liczba_godz  ***************************
    -- ******************************************************************
    trace := 'DZ_ZAJECIA_CYKLI.UPDATE';
    update DZ_ZAJECIA_CYKLI@usos zc
       set liczba_godz = (select sum(liczba_godz) from dz_prowadzacy_grup@usos pg where pg.zaj_cyk_id = zc.id and liczba_godz is not null)
     where  zc.cdyd_kod in (select value from system_parameters where name like 'USOS_CYKL%')
       and zc.id in (
           --there is something for rollup
           select zaj_cyk_id from dz_prowadzacy_grup@usos where liczba_godz is not null
           minus
           --no null values - avoid data corruption!
           select zaj_cyk_id from dz_prowadzacy_grup@usos where liczba_godz is null
        );      
     --
    xxmsz_tools.insertIntoEventLog('TO_USOS:'||pCleanYpMode||': OK', 'I', 'INTEGRATION_TO_USOS' );
    delete from xxmsztools_eventlog where module_name = 'INTEGRATION_TO_USOS' and created < sysdate - 7;
    commit;
--exception
--    when others then
--    xxmsz_tools.insertIntoEventLog(substrb('TO USOS: ' || trace ||': '||sqlerrm,1,200), 'I', 'INTEGRATION_TO_USOS' );
end;

end;