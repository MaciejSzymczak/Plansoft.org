--select * from system_parameters where name like 'VERSION%' order by name desc
INSERT INTO system_parameters (name,value) VALUES ('VERSION 2025.11.21', 'INSTALLED');
commit;

ALTER TABLE planners ADD keywords varchar2(255);