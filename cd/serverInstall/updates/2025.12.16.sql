--select * from system_parameters where name like 'VERSION%' order by name desc
INSERT INTO system_parameters (name,value) VALUES ('VERSION 2025.12.16', 'INSTALLED');
commit;


*** Install package planner_utils

