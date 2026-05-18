--select * from system_parameters where name like 'VERSION%' order by name desc
INSERT INTO system_parameters (name,value) VALUES ('VERSION 2026.05.18', 'INSTALLED');
commit;

*** install package planner_utils.
*** install package planner_utils_ext.
