INSERT INTO system_parameters (name,value) VALUES ('VERSION 2023.12.15', 'INSTALLED');
commit;

connect sys;
GRANT SELECT ON GV_$LOCK TO planner;
GRANT SELECT ON V_$SESSION TO planner;

connect planner;
*** install packages/HealthCheck.sql
create public synonym HealthCheck for planner.HealthCheck;
