-- 2012.07.18: 
--LOCAL: YES
--LOCALPRIV: NO
--ININSTALL: YES
--WAT  : YES
--WROC : NO
--PWWA : NO
--SOPOT: YES

begin
 delete from res_hints where res_id not in ( select id from periods union all select id from lecturers union all select id from subjects union all select id from groups union all select id from forms union all select id from rooms union all select id from planners );
 delete from str_elems where parent_id not in ( select id from periods union all select id from lecturers union all select id from subjects union all select id from groups union all select id from forms union all select id from rooms union all select id from planners);
 delete from str_elems where child_id not in ( select id from periods union all select id from lecturers union all select id from subjects union all select id from groups union all select id from forms union all select id from rooms union all select id from planners);
 delete from tt_resource_lists where res_id not in ( select id from periods union all select id from lecturers union all select id from subjects union all select id from groups union all select id from forms union all select id from rooms union all select id from planners );
 commit;
end;
/

create or replace trigger periods_t1
after delete
on periods
referencing new as new old as old
for each row
-- deletes child tables, 2012-07-18  Maciej Szymczak
begin
  delete from res_hints         where res_id    = :old.id;
  delete from str_elems         where parent_id = :old.id;
  delete from str_elems         where child_id  = :old.id;
  delete from tt_resource_lists where res_id    = :old.id;
end;
/

create or replace trigger subjects_t1
after delete
on subjects
referencing new as new old as old
for each row
-- deletes child tables, 2012-07-18  Maciej Szymczak
begin
  delete from res_hints         where res_id    = :old.id;
  delete from str_elems         where parent_id = :old.id;
  delete from str_elems         where child_id  = :old.id;
  delete from tt_resource_lists where res_id    = :old.id;
end;
/

create or replace trigger forms_t1
after delete
on forms
referencing new as new old as old
for each row
-- deletes child tables, 2012-07-18  Maciej Szymczak
begin
  delete from res_hints         where res_id    = :old.id;
  delete from str_elems         where parent_id = :old.id;
  delete from str_elems         where child_id  = :old.id;
  delete from tt_resource_lists where res_id    = :old.id;
end;
/

create or replace trigger planners_t1
after delete
on planners
referencing new as new old as old
for each row
-- deletes child tables, 2012-07-18  Maciej Szymczak
begin
  delete from res_hints         where res_id    = :old.id;
  delete from str_elems         where parent_id = :old.id;
  delete from str_elems         where child_id  = :old.id;
  delete from tt_resource_lists where res_id    = :old.id;
end;
/

