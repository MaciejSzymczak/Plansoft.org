--select * from system_parameters where name like 'VERSION%' order by name desc
INSERT INTO system_parameters (name,value) VALUES ('VERSION 2025.04.12', 'INSTALLED');
commit;

connect sys;
CREATE OR REPLACE VIEW sys.v_locked_object_ext AS SELECT * FROM v$locked_object;
GRANT SELECT ON sys.v_locked_object_ext TO planner;
CREATE OR REPLACE VIEW sys.v_lock_ext AS SELECT * FROM v$lock;
GRANT SELECT ON sys.v_lock_ext TO planner;

*** install package HealthCheck;
