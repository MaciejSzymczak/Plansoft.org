INSERT INTO system_parameters (name,value) VALUES ('VERSION 2022.09.12', 'INSTALLED');
commit;

begin
for rec in (select trigger_name from all_triggers where owner='PLANNER') loop
execute immediate 'alter trigger '||rec.trigger_name||' disable';
end loop;
end;
/

alter table lecturers_history add (DIFF_NOTIFICATIONS varchar2(1) default '-');
alter table lecturers add (DIFF_NOTIFICATIONS varchar2(1) default '-');

alter table planners add (DIFF_NOTIFICATIONS varchar2(1) default '-');


begin
for rec in (select trigger_name from all_triggers where owner='PLANNER') loop
execute immediate 'alter trigger '||rec.trigger_name||' enable';
end loop;
end;
/