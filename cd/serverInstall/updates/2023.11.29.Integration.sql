	zintegruj (wolaj z integration)
		! dodaj plan_id do integration
		! zakutualij ten skrypt!
	wypełniaj strukturę tak jak oni chca
		select * from int_classes
		select * from int_class_members
		select 
		  d.* 
		 , case DIFF_FLAG
		   when 'INSERT' THEN (select integration_id from int_class_members where lec_gro_rom='ROM' and cla_id=d.id and rownum =1)
		   when 'DELETE' THEN (select integration_id from int_class_members_diff where dim = 'DIFF' and DIFF_FLAG='DELETE' and lec_gro_rom='ROM' and cla_id=d.id and rownum =1)
		   end rom_id
		from int_classes_diff d where dim = 'DIFF'
		select * from int_class_members_diff   where dim = 'DIFF'
	install
	doc
----------------------------------------------------------------

INSERT INTO system_parameters (name,value) VALUES ('VERSION 2023.11.29', 'INSTALLED');

alter table lecturers modify (desc1 varchar2(3000));
alter table lecturers_history modify (desc1 varchar2(3000));

alter table forms modify (integration_id varchar2(40));
alter table forms_history modify (integration_id varchar2(40));
alter table lecturers modify (integration_id varchar2(40));
alter table lecturers_history modify (integration_id varchar2(40));
alter table groups modify (integration_id varchar2(40));
alter table groups_history modify (integration_id varchar2(40));
alter table rooms modify (integration_id varchar2(40));
alter table rooms_history modify (integration_id varchar2(40));
alter table groups modify (integration_id varchar2(40));
alter table groups_history modify (integration_id varchar2(40));
alter table subjects modify (integration_id varchar2(40));
alter table subjects_history modify (integration_id varchar2(40));

alter table int_plan modify (
INTEGRATION_ID varchar2(40)
,INTEGRATION_ID_LEC varchar2(40)
,INTEGRATION_ID_GRO varchar2(40)
,INTEGRATION_ID_SUB varchar2(40)
,INTEGRATION_ID_FOR varchar2(40)
);

alter table tt_interface modify (
 INTEGRATION_ID varchar2(40)
,PER_INTEGRATION_ID varchar2(40)
,LEC_INTEGRATION_ID varchar2(40)
,SUB_INTEGRATION_ID varchar2(40)
,FOR_INTEGRATION_ID varchar2(40)
,GRO_INTEGRATION_ID varchar2(40)
,ROM_INTEGRATION_ID varchar2(40));

 CREATE TABLE INT_CLASSES_DIFF 
   (ID NUMBER, 
	DAY DATE, 
	HOUR_FROM VARCHAR2(5), 
	HOUR_TO VARCHAR2(5), 
	NO_FROM NUMBER, 
	NO_TO NUMBER, 
	SUB_ID NUMBER, 
	FOR_ID NUMBER, 
	INTEGRATION_ID_SUB VARCHAR2(40), 
	INTEGRATION_ID_FOR VARCHAR2(40), 
	PLAN_INTEGRATION_ID VARCHAR2(500), 
	TT_COMB_CNT NUMBER, 
	SUM NUMBER, 
	DESC1 VARCHAR2(255), 
	DESC2 VARCHAR2(255), 
	MERGED_ID VARCHAR2(500), 
	CALC_LEC_IDS VARCHAR2(255), 
	CALC_GRO_IDS VARCHAR2(255), 
	CALC_ROM_IDS VARCHAR2(255),
	DIM VARCHAR2(30),
	creation_date date,
	DIFF_FLAG VARCHAR2(10)
   ) 
  TABLESPACE USERS;

    CREATE TABLE INT_CLASS_MEMBERS_DIFF 
   (CLA_ID NUMBER, 
	LEC_GRO_ROM VARCHAR2(3), 
	LEC_GRO_ROM_ID NUMBER, 
	INTEGRATION_ID VARCHAR2(40),
	DIM VARCHAR2(30 BYTE),
	creation_date date,
	DIFF_FLAG VARCHAR2(10)
   )
   TABLESPACE USERS;

  CREATE INDEX INT_CLASS_MEMBERS_DIFF_I1 ON INT_CLASS_MEMBERS_DIFF (CLA_ID) 
  TABLESPACE USERS;
  
alter table INT_CLASS_MEMBERS modify (INTEGRATION_ID VARCHAR2(40));
alter table INT_CLASSES modify (INTEGRATION_ID_SUB  VARCHAR2(40));
alter table INT_CLASSES modify (INTEGRATION_ID_FOR  VARCHAR2(40));
alter table INT_FORMS modify (INTEGRATION_ID VARCHAR2(40));
alter table INT_GROUPS modify (INTEGRATION_ID VARCHAR2(40));
alter table INT_LECTURERS modify (INTEGRATION_ID VARCHAR2(40));
alter table INT_RESOURCES modify (INTEGRATION_ID VARCHAR2(40));
alter table INT_SUBJECTS modify (INTEGRATION_ID VARCHAR2(40));
alter table INT_CLASS_MEMBERS_DIFF modify (INTEGRATION_ID VARCHAR2(40));
alter table INT_CLASSES_DIFF modify (INTEGRATION_ID_SUB  VARCHAR2(40));
alter table INT_CLASSES_DIFF modify (INTEGRATION_ID_FOR  VARCHAR2(40));

create or replace package  integration_diff_catcher is  
    
    /* Difference catcher 
       @author Maciej Szymczak
       @version 2023-11-28
     */
    procedure diff;  
    
end;
/

create or replace package body integration_diff_catcher is  

    ------------------------------------------------------------------------------------------------------------------------------------------------------- 
    procedure fill (pdim varchar2) is
    begin
        delete from int_classes_diff where dim = pdim;
        delete from int_class_members_diff where dim = pdim;        
        insert into int_classes_diff (id, day, hour_from, hour_to, no_from, no_to, sub_id, for_id, integration_id_sub, integration_id_for, plan_integration_id, tt_comb_cnt, sum, desc1, desc2, merged_id, calc_lec_ids, calc_gro_ids, calc_rom_ids, dim, creation_date)
        select
              id
            , day
            , hour_from
            , hour_to
            , no_from
            , no_to
            , sub_id
            , for_id
            , integration_id_sub
            , integration_id_for
            , plan_integration_id
            , tt_comb_cnt
            , sum
            , desc1
            , desc2
            , merged_id
            , calc_lec_ids
            , calc_gro_ids
            , calc_rom_ids
            , pdim dim
            , sysdate creation_date
        from  int_classes;
        commit;  
        insert into int_class_members_diff (cla_id,  lec_gro_rom, lec_gro_rom_id, integration_id, dim, creation_date)
        select
              cla_id
            , lec_gro_rom
            , lec_gro_rom_id
            , integration_id
            , pdim dim
            , sysdate creation_date
        from  int_class_members;
        commit;  
    end fill;
     
     
    ------------------------------------------------------------------------------------------------------------------------------------------------------- 
    procedure diff  is
     trace varchar2(1000);
    begin 
        xxmsz_tools.insertIntoEventLog('START', 'I', 'INTEGRATION_DIFF_CATCHER' );
        delete from int_classes_diff where dim in ('PRIOR','DIFF-7');
        delete from int_class_members_diff where dim in ('PRIOR','DIFF-7');
        -- keep last 7 DIFFs
        update int_classes_diff set dim = 'DIFF-7' where dim = 'DIFF-6';
        update int_classes_diff set dim = 'DIFF-6' where dim = 'DIFF-5';
        update int_classes_diff set dim = 'DIFF-5' where dim = 'DIFF-4';
        update int_classes_diff set dim = 'DIFF-4' where dim = 'DIFF-3';
        update int_classes_diff set dim = 'DIFF-3' where dim = 'DIFF-2';
        update int_classes_diff set dim = 'DIFF-2' where dim = 'DIFF-1';
        update int_classes_diff set dim = 'DIFF-1' where dim = 'DIFF';
        update int_class_members_diff set dim = 'DIFF-7' where dim = 'DIFF-6';
        update int_class_members_diff set dim = 'DIFF-6' where dim = 'DIFF-5';
        update int_class_members_diff set dim = 'DIFF-5' where dim = 'DIFF-4';
        update int_class_members_diff set dim = 'DIFF-4' where dim = 'DIFF-3';
        update int_class_members_diff set dim = 'DIFF-3' where dim = 'DIFF-2';
        update int_class_members_diff set dim = 'DIFF-2' where dim = 'DIFF-1';
        update int_class_members_diff set dim = 'DIFF-1' where dim = 'DIFF';
        --
        update int_classes_diff set dim = 'PRIOR' where dim = 'CURRENT';
        update int_class_members_diff set dim = 'PRIOR' where dim = 'CURRENT';
        fill('CURRENT');
        
        insert into int_classes_diff (id, day, hour_from, hour_to, no_from, no_to, sub_id, for_id, integration_id_sub, integration_id_for, plan_integration_id, tt_comb_cnt, sum, desc1, desc2, merged_id, calc_lec_ids, calc_gro_ids, calc_rom_ids,diff_flag, dim)
        (
        select id, day, hour_from, hour_to, no_from, no_to, sub_id, for_id, integration_id_sub, integration_id_for, plan_integration_id, tt_comb_cnt, sum, desc1, desc2, merged_id, calc_lec_ids, calc_gro_ids, calc_rom_ids, 'DELETE' DIFF_FLAG, 'DIFF' dim from int_classes_diff where dim ='PRIOR'
        minus
        select id, day, hour_from, hour_to, no_from, no_to, sub_id, for_id, integration_id_sub, integration_id_for, plan_integration_id, tt_comb_cnt, sum, desc1, desc2, merged_id, calc_lec_ids, calc_gro_ids, calc_rom_ids,'DELETE' DIFF_FLAG, 'DIFF' dim from int_classes_diff where dim ='CURRENT'
        )
        union all
        (
        select id, day, hour_from, hour_to, no_from, no_to, sub_id, for_id, integration_id_sub, integration_id_for, plan_integration_id, tt_comb_cnt, sum, desc1, desc2, merged_id, calc_lec_ids, calc_gro_ids, calc_rom_ids,'INSERT' DIFF_FLAG, 'DIFF' dim from int_classes_diff where dim ='CURRENT'
        minus
        select id, day, hour_from, hour_to, no_from, no_to, sub_id, for_id, integration_id_sub, integration_id_for, plan_integration_id, tt_comb_cnt, sum, desc1, desc2, merged_id, calc_lec_ids, calc_gro_ids, calc_rom_ids,'INSERT' DIFF_FLAG, 'DIFF' dim from int_classes_diff where dim ='PRIOR'
        );  
        commit;

        insert into int_class_members_diff (cla_id,  lec_gro_rom, lec_gro_rom_id, integration_id,diff_flag, dim)
        (
        select cla_id,  lec_gro_rom, lec_gro_rom_id, integration_id,'DELETE' DIFF_FLAG, 'DIFF' dim from int_class_members_diff where dim ='PRIOR'
        minus
        select cla_id,  lec_gro_rom, lec_gro_rom_id, integration_id,'DELETE' DIFF_FLAG, 'DIFF' dim from int_class_members_diff where dim ='CURRENT'
        )
        union all
        (
        select cla_id,  lec_gro_rom, lec_gro_rom_id, integration_id,'INSERT' DIFF_FLAG, 'DIFF' dim from int_class_members_diff where dim ='CURRENT'
        minus
        select cla_id,  lec_gro_rom, lec_gro_rom_id, integration_id,'INSERT' DIFF_FLAG, 'DIFF' dim from int_class_members_diff where dim ='PRIOR'
        );  
        commit;

        xxmsz_tools.insertIntoEventLog('STOP ', 'I', 'INTEGRATION_DIFF_CATCHER' );
        delete from xxmsztools_eventlog where module_name = 'INTEGRATION_DIFF_CATCHER' and created < sysdate - 14;
        commit;
    exception
        when others then
        xxmsz_tools.insertIntoEventLog(substrb( trace ||': '||sqlerrm,1,230), 'I', 'INTEGRATION_DIFF_CATCHER' );
    end;
end;
/


========================================================================================================
UPDATE INTEGRATION AND GET INTO THIS FILE !!! 

IT WAS:
,integration_id_sub  = (select sub_form_integration_id from bazus_sub_map where sub_integration_id=tt.integration_id_sub and form_name=(select name from forms where id = tt.for_id))

IT IS:
             ,integration_id_sub  = NVL( 
               (select sub_form_integration_id from bazus_sub_map where sub_integration_id=tt.integration_id_sub and form_name=(select name from forms where id = tt.for_id))
                -- if the bazus_sub_map is empty just use the original integration_id_sub
              , integration_id_sub)

IT WAS (nvl(integration_id,id)):
        update int_classes tt
          set  plan_integration_id = nvl((
                select LISTAGG(integration_id, ',') within group (order by integration_id )  
                  from tt_combinations 
                  where integration_id is not null 
                    and weight=122 
                    and id in (select tt_comb_id from tt_cla where cla_id= tt.id) 

IT IS:
        update int_classes tt
          set  plan_integration_id = nvl((
                select LISTAGG(nvl(integration_id,id), ',') within group (order by integration_id )  
                  from tt_combinations 
                  where nvl(integration_id,id) is not null 
                    and weight=122 
                    and id in (select tt_comb_id from tt_cla where cla_id= tt.id) 

Dodaliśmy tabelę PlanSoft.Classes (tabela jest już na bazie danych)
Id- int, PK, wartość z twojego systemu
PlanIntegrationId - uniqueidentifer, wartość z widoku vPlan
DateFrom - datetime(2), data rozpoczęcia zajęć
DateTo - datetime(2), data zakończenia zajęć
ResourceIntergrationId -  uniqueidentifer, identyfikator sali w której odbywają się zajęcia
Status - smallint, 
1 - dodano termin zajęć, 
2 - edytowano  termin zajęć, 
3 - usunięto termin zajęć
NDziekanatClassDateId - uniqueidentifer, nie ma dla ciebie znaczenia, zawsze null
ProccesedOn - datetime(2), nia ma dla ciebie znaczenia, zawsze null
Error - varchar(max) -  null, nia ma dla ciebie znaczenia, zawsze null
