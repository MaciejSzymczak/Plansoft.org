--select * from system_parameters where name like 'VERSION%' order by name desc
INSERT INTO system_parameters (name,value) VALUES ('VERSION 2026.05.25', 'INSTALLED');
commit;

*** install package planner_utils.
