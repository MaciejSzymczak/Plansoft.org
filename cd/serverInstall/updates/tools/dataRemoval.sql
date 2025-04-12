DISABLE / ENABLE INTEGRATIONS
======================================================

update system_parameters set value=null where name = 'USOS_CYKL';
update system_parameters set value=null where name = 'INT_IS_ACTIVE';
commit;

--update system_parameters set value='1' where name = 'INT_IS_ACTIVE';
--update system_parameters set value='' where name = 'USOS_CYKL';

SOFT CLEAN
=======================================================
select table_name, num_rows from all_tables where owner = 'PLANNER' order by num_rows desc
truncate table CLASSES_HISTORY;
truncate table LECTURERS_HISTORY;
truncate table GRO_CLA_HISTORY;
truncate table LEC_CLA_HISTORY;
truncate table ROM_CLA_HISTORY;
truncate table FORMS_HISTORY;

begin
delete from xxmsztools_eventlog where created < sysdate - 90;
delete from classes_history where effective_start_date < sysdate - 90;
commit;
end;


CLEAN SYSTEM OBJECTS
=======================================================
connect as sys

select sum(bytes)/1024/1024/1024 size_in_gb from dba_segments 

--search for candidates to clear
select * from dba_segments order by bytes desc

purge dba_recyclebin;
truncate table aud$;
begin dbms_stats.purge_stats(sysdate-10); end;

truncate table WRI$_ADV_OBJECTS;
truncate table WRI$_SQLSET_PLAN_LINES;

select tablespace_name,sum(bytes)/1024/1024/1024 size_in_gb, file_name from dba_data_files group by tablespace_name, file_name


--not working ORA-03297
--alter database datafile 'C:\APP\EXT.MSZYMCZAK\PRODUCT\21C\ORADATA\XE\XEPDB1\SYSAUX01.DBF' resize 6g; 


REMOVE ALL (TEST DATA)
======================================================
connect planner;

truncate table lec_cla;
truncate table gro_cla;
truncate table rom_cla;
truncate table lec_cla_history;
truncate table gro_cla_history;
truncate table rom_cla_history;
truncate table RECENTLY_USED;
truncate table RESERVATIONS;
truncate table RES_HINTS;
truncate table ROOMS_HISTORY;
truncate table FORMS_HISTORY;
truncate table GROUPS_HISTORY;
truncate table LECTURERS_HISTORY;
truncate table SUBJECTS_HISTORY;
truncate table TT_LOG;
truncate table SUBJECTS_HISTORY;
truncate table CLASSES_HISTORY;
truncate table DIFF_CATCHER_HELPER;
truncate table INT_CLASSES;
truncate table INT_CLASSES_DIFF;
truncate table INT_CLASS_MEMBERS;
truncate table INT_CLASS_MEMBERS_DIFF;
truncate table TIMETABLE_NOTES;
truncate table TMP_SELECTED_DATES;
truncate table TT_RESOURCE_LISTS;
truncate table TT_INCLUSIONS;
truncate table TT_CLA;
delete from TT_COMBINATIONS;
truncate table xxmsztools_eventlog;
delete from classes;
truncate table classes_history;
delete from subjects where id > 0;
delete from groups where id > 0;
delete from lecturers where id > 0;
delete from rooms where id > 0;
delete from form_formulas where id > 0;
delete from forms where id > 0;
commit;


REMOVE ALL UP TO DATE
=======================================================

begin
for rec in (select trigger_name from all_triggers where owner='PLANNER') loop
execute immediate 'alter trigger '||rec.trigger_name||' disable';
end loop;
end;
/

declare 
 dateLimit varchar2(1000) := ' between date''2017-01-01'' and date''2018-12-31''';
 procedure deleteInChunks (sqlString varchar2, chunkSize number) is begin
      loop
        commit;
        execute immediate sqlString||' and rownum<'||to_char(chunkSize);
        exit when SQL%rowcount =0;
      end loop;
      commit;
 end;
begin
 deleteInChunks('delete from classes where day'||dateLimit , 1000);
 deleteInChunks('delete from classes_history where day'||dateLimit, 1000);
 deleteInChunks('delete from lec_cla where day'||dateLimit, 1000);
 deleteInChunks('delete from gro_cla where day'||dateLimit, 1000);
 deleteInChunks('delete from rom_cla where day'||dateLimit, 1000);
 deleteInChunks('delete from lec_cla_history where day'||dateLimit, 1000);
 deleteInChunks('delete from gro_cla_history where day'||dateLimit, 1000);
 deleteInChunks('delete from rom_cla_history where day'||dateLimit, 1000);
 deleteInChunks('delete from res_hints where day'||dateLimit, 1000);
 deleteInChunks('delete from forms_history where effective_end_Date'||dateLimit, 1000);
 deleteInChunks('delete from groups_history where effective_end_Date'||dateLimit, 1000);
 deleteInChunks('delete from lecturers_history where effective_end_Date'||dateLimit, 1000);
 deleteInChunks('delete from rooms_history where effective_end_Date'||dateLimit, 1000);
end;
/

begin
for rec in (select trigger_name from all_triggers where owner='PLANNER') loop
execute immediate 'alter trigger '||rec.trigger_name||' enable';
end loop;
end;
/


begin
--Data backup
--select id, name, to_char(creation_date,'YYYY-MM-DD') creation_date, created_by from periods where date_from < to_date('2019-12-30','YYYY-MM-DD') and date_to < to_date('2019-12-30','YYYY-MM-DD') and upper(name) not like '%ALENDAR%';
--select id, title, first_name, last_name, to_char(creation_date,'YYYY-MM-DD') creation_date, created_by from lecturers where id in (select id from lecturers minus select lec_id from lec_cla) and creation_date < to_date('2019-12-30','YYYY-MM-DD') 
--select id, name, to_char(creation_date,'YYYY-MM-DD') creation_date, created_by from groups where id in (select id from groups minus select gro_id from gro_cla) and creation_date < to_date('2019-12-30','YYYY-MM-DD') 
--select id, name, to_char(creation_date,'YYYY-MM-DD') creation_date, created_by from rooms where id in (select id from rooms minus select rom_id from rom_cla) and creation_date < to_date('2019-12-30','YYYY-MM-DD') 
--select id, name, to_char(creation_date,'YYYY-MM-DD') creation_date, created_by from subjects where id in (select id from subjects minus select sub_id from classes) and creation_date < to_date('2019-12-30','YYYY-MM-DD') 
--select id, name, to_char(creation_date,'YYYY-MM-DD') creation_date, created_by from forms where id in (select id from forms minus select for_id from classes) and creation_date < to_date('2019-12-30','YYYY-MM-DD') 
 delete from periods where date_from < to_date('2019-12-30','YYYY-MM-DD') and date_to < to_date('2019-12-30','YYYY-MM-DD') and upper(name) not like '%ALENDAR%';
 delete from lecturers where id in (select id from lecturers minus select lec_id from lec_cla) and creation_date < to_date('2019-12-30','YYYY-MM-DD'); 
 delete from groups where id in (select id from groups minus select gro_id from gro_cla) and creation_date < to_date('2019-12-30','YYYY-MM-DD'); 
 delete from rooms where id in (select id from rooms minus select rom_id from rom_cla) and creation_date < to_date('2019-12-30','YYYY-MM-DD'); 
 delete from subjects where id in (select id from subjects minus select sub_id from classes) and creation_date < to_date('2019-12-30','YYYY-MM-DD'); 
 delete from forms where id in (select id from forms minus select for_id from classes) and creation_date < to_date('2019-12-30','YYYY-MM-DD');
 commit;
end;


REMOVE DATA PRESENTED ON REPORT "HEALTH CHECK"
-------------------------------------------------------

1. Run the report "Health check" and obtain the list of obsolete forms, groups, lecturers, rooms, subjects
2. Save report and inform users about the deletion
3. Put the ids into table XXREMOVEME 
    create table XXREMOVEME (ID number);
    insert into XXREMOVEME values('<your values>');
    Use askmac page to create the insert into statements
4. Run this script

    --forms
    --check select to_char(max(day),'yyyy-mm-dd') from classes where for_id in (select * from XXREMOVEME)
    delete from classes where for_id in (select id from XXREMOVEME); 
    delete from forms where id in (select id from XXREMOVEME);
    --delete from sub_pla where sub_id in (select id from XXREMOVEME)
    
    --subjects
    --select to_char(max(day),'yyyy-mm-dd') from classes where sub_id in (select * from XXREMOVEME)
    delete from classes where sub_id in (select id from XXREMOVEME); 
    delete from subjects where id in (select id from XXREMOVEME);
    --delete from sub_pla where sub_id in (select id from XXREMOVEME)
    
    
    --rooms
    --select to_char(max(day),'yyyy-mm-dd') from rom_cla where rom_id in (select * from XXREMOVEME)
    delete from classes where id in (select cla_id from rom_cla where rom_id in (select id from XXREMOVEME)); 
    --delete from rom_cla where rom_id in (select id from XXREMOVEME)
    delete from rooms where id in (select id from XXREMOVEME);
    --delete from rom_pla where rom_id in (select id from XXREMOVEME)
    
    
    --lecturers
    --select to_char(max(day),'yyyy-mm-dd') from lec_cla where lec_id in (select * from XXREMOVEME)
    delete from classes where id in (select cla_id from lec_cla where lec_id in (select id from XXREMOVEME)); 
    --delete from lec_cla where lec_id in (select id from XXREMOVEME)
    delete from lecturers where id in (select id from XXREMOVEME);
    --delete from lec_pla where lec_id in (select id from XXREMOVEME)
    
    --groups
    --select to_max(day)from gro_cla where gro_id in (select * from XXREMOVEME)
    delete from classes where id in (select cla_id from gro_cla where gro_id in (select id from XXREMOVEME)); 
    --delete from gro_cla where gro_id in (select id from XXREMOVEME)
    delete from groups where id in (select id from XXREMOVEME);
    --delete from gro_pla where gro_id in (select id from XXREMOVEME)
    
    commit;

5. drop table XXREMOVEME;

