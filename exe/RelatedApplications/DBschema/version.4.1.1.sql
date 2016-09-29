-- 2012.01.25: already installed on wat, ppwa, ssw, iniinstall

begin
 delete from res_hints where res_id not in ( select id from lecturers union all select id from groups union all select id from rooms );
 delete from str_elems where parent_id not in ( select id from lecturers union all select id from groups union all select id from rooms );
 delete from str_elems where child_id not in ( select id from lecturers union all select id from groups union all select id from rooms );
 delete from tt_resource_lists where res_id not in ( select id from lecturers union all select id from groups union all select id from rooms );
 commit;
end;
/

create or replace trigger lecturers_t1
after delete
on lecturers
referencing new as new old as old
for each row
-- deletes child tables, 2012-01-24  Maciej Szymczak
begin
  delete from res_hints         where res_id    = :old.id;
  delete from str_elems         where parent_id = :old.id;
  delete from str_elems         where child_id  = :old.id;
  delete from tt_resource_lists where res_id    = :old.id;
end;
/

create or replace trigger groups_t1
after delete
on groups
referencing new as new old as old
for each row
-- deletes child tables, 2012-01-24  Maciej Szymczak
begin
  delete from res_hints         where res_id    = :old.id;
  delete from str_elems         where parent_id = :old.id;
  delete from str_elems         where child_id  = :old.id;
  delete from tt_resource_lists where res_id    = :old.id;
end;
/

create or replace trigger rooms_t1
after delete
on rooms
referencing new as new old as old
for each row
-- deletes child tables, 2012-01-24  Maciej Szymczak
begin
  delete from res_hints         where res_id    = :old.id;
  delete from str_elems         where parent_id = :old.id;
  delete from str_elems         where child_id  = :old.id;
  delete from tt_resource_lists where res_id    = :old.id;
end;
/


alter table resource_categories add (
 name_accusative varchar2(30)
,name_genitive   varchar2(30)
);

