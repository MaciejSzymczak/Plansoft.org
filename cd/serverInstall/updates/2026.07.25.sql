--select * from system_parameters where name like 'VERSION%' order by name desc
INSERT INTO system_parameters (name,value) VALUES ('VERSION 2026.07.25', 'INSTALLED');
commit;

connect as sys:
GRANT EXECUTE ON SYS.DBMS_LOCK TO PLANNER;

connecy as planner:

*** install package planner_utils
