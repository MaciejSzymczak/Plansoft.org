begin
delete from xxmsztools_eventlog where created < sysdate - 90;
delete from classes_history where effective_start_date < sysdate - 90;
commit;
end;


clean ups
=====================================================

create table backup20241301_gro_cla as
select * from gro_cla where is_child='Y' and no_conflict_flag is null

begin
for rec in (select unique gro_id child_id, parent_id from gro_cla where is_child='Y' and no_conflict_flag is null) loop
  declare
   cnt number;
   child_name varchar2(200);
   parent_name varchar2(200);
  begin
   select count(1) into cnt from str_elems where parent_id = rec.parent_id and child_id = rec.child_id;
   --the relation does not exist
   if (cnt=0) then
     delete from gro_cla where is_child='Y' and no_conflict_flag is null and gro_id = rec.child_id and parent_id = rec.parent_id;
     select name into child_name from groups where id = rec.child_id;
     select name into parent_name from groups where id = rec.parent_id;
     xxmsz_tools.insertIntoEventLog ( REPLACE(REPLACE('REMOVED: PARENTID:{1}     CHILDID:{2}','{1}',child_name || ' [' ||rec.child_id|| ']'),'{2}',parent_name || ' [' ||rec.parent_id|| ']'), 'I', 'STR_ELEMS_CLEANUP');
     commit;
   end if;
  end;
end loop;
commit;
end;

--review the results
select * from xxmsztools_eventlog where module_name = 'STR_ELEMS_CLEANUP' order by id desc

select * from backup20241301_gro_cla where id in 
(
select id from backup20241301_gro_cla
minus
select id from gro_cla
)

--clean ups
delete from xxmsztools_eventlog where module_name = 'STR_ELEMS_CLEANUP' 


