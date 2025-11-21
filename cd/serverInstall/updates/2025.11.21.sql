--select * from system_parameters where name like 'VERSION%' order by name desc
INSERT INTO system_parameters (name,value) VALUES ('VERSION 2025.11.21', 'INSTALLED');
commit;

ALTER TABLE planners ADD keywords varchar2(255);

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
/*delete "Zajecia podrzedne" on NAD without childs*/
delete from classes where sub_id=-1 and calc_gro_ids in (select Id from groups minus select parent_id from str_elems);
/*delete "Zajecia nadrzedne" on POD without parents*/
delete from classes where sub_id=-2 and calc_gro_ids in (select Id from groups minus select child_id from str_elems);
commit;
end;


*** Install package planner_utils