alter table classes modify (calc_groups varchar2(500))
alter table classes_history modify (calc_groups varchar2(500))
alter table classes modify (calc_rooms varchar2(500));
alter table classes_history modify (calc_rooms varchar2(500));
alter table classes modify (calc_lecturers varchar2(500));
alter table classes_history modify (calc_lecturers varchar2(500));
alter table classes_h_temp modify (calc_groups varchar2(500))
alter table classes_h_temp modify (calc_rooms varchar2(500));
alter table classes_h_temp modify (calc_lecturers varchar2(500));

--errors if any can be ignored here
alter table planner.lecturers drop ( locked_by , locked_reason , locked_date  );
alter table planner.groups drop ( locked_by , locked_reason , locked_date  );
alter table planner.rooms drop ( locked_by , locked_reason , locked_date  );
alter table planner.lecturers_history drop ( locked_by , locked_reason , locked_date  );
alter table planner.groups_history drop ( locked_by , locked_reason , locked_date  );
alter table planner.rooms_history drop ( locked_by , locked_reason , locked_date  );
CREATE OR REPLACE FORCE VIEW RESOURCES 
AS select id, name from rooms 
union select id, abbreviation||' '||name from groups 
union select id, title||' '||last_name||' '||first_name from lecturers;

connect sys;

grant alter system to planner;
grant select on sys.GV_$SESSION to planner;