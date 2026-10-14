--select * from system_parameters where name like 'VERSION%' order by name desc
INSERT INTO system_parameters (name,value) VALUES ('VERSION 2026.10.14', 'INSTALLED');
commit;

*** Install package planner_utils

delete from system_parameters where name = 'CHILD_AND_PARENTS_LEC';
delete from system_parameters where name = 'CHILD_AND_PARENTS_ROM';
commit;
