alter table planners add (parent varchar2(255));
update planners set parent = (select name from planners x where id=planners.parent_id);
delete from flex_col_usage where id = -1;
commit;
