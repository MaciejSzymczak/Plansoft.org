REMOVE ALL (TEST DATA)
======================================================
connect planner;

truncate table lec_cla;
truncate table gro_cla;
truncate table rom_cla;
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
 procedure deleteInChunks (sqlString varchar2, chunkSize number) is begin
      loop
        commit;
        execute immediate sqlString||'  and rownum<'||to_char(chunkSize);
        exit when SQL%rowcount =0;
      end loop;
      commit;
 end;
begin
 deleteInChunks('delete from classes where day < to_date(''2019-12-30'',''YYYY-MM-DD'')', 1000);
 deleteInChunks('delete from classes_history where day < to_date(''2019-12-30'',''YYYY-MM-DD'')', 1000);
 deleteInChunks('delete from lec_cla where day < to_date(''2019-12-30'',''YYYY-MM-DD'')', 1000);
 deleteInChunks('delete from gro_cla where day < to_date(''2019-12-30'',''YYYY-MM-DD'')', 1000);
 deleteInChunks('delete from rom_cla where day < to_date(''2019-12-30'',''YYYY-MM-DD'')', 1000);
 deleteInChunks('delete from lec_cla_history where day < to_date(''2019-12-30'',''YYYY-MM-DD'')', 1000);
 deleteInChunks('delete from gro_cla_history where day < to_date(''2019-12-30'',''YYYY-MM-DD'')', 1000);
 deleteInChunks('delete from rom_cla_history where day < to_date(''2019-12-30'',''YYYY-MM-DD'')', 1000);
 deleteInChunks('delete from res_hints where day < to_date(''2019-12-30'',''YYYY-MM-DD'')', 1000);
 deleteInChunks('delete from forms_history where effective_end_Date < to_date(''2019-12-30'',''YYYY-MM-DD'')', 1000);
 deleteInChunks('delete from groups_history where effective_end_Date < to_date(''2019-12-30'',''YYYY-MM-DD'')', 1000);
 deleteInChunks('delete from lecturers_history where effective_end_Date < to_date(''2019-12-30'',''YYYY-MM-DD'')', 1000);
 deleteInChunks('delete from rooms_history where effective_end_Date < to_date(''2019-12-30'',''YYYY-MM-DD'')', 1000);
end;


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


