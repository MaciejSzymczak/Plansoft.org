--select * from system_parameters where name like 'VERSION%' order by name desc
INSERT INTO system_parameters (name,value) VALUES ('VERSION 2026.07.25', 'INSTALLED');
commit;

connect as sys:
GRANT EXECUTE ON SYS.DBMS_LOCK TO PLANNER;

connect as planner:

ALTER TABLE planners
DROP COLUMN cal_id;

*** install package planner_utils
