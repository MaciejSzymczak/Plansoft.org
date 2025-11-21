--select * from system_parameters where name like 'VERSION%' order by name desc
INSERT INTO system_parameters (name,value) VALUES ('VERSION 2025.11.12', 'INSTALLED');
commit;

ALTER TABLE planners ADD CAN_RUN_INTEGRATION CHAR(1) DEFAULT '+';