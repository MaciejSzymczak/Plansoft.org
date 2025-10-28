--select * from system_parameters where name like 'VERSION%' order by name desc
INSERT INTO system_parameters (name,value) VALUES ('VERSION 2025.10.28', 'INSTALLED');
commit;

alter table usos_temp add (CREATED_BY VARCHAR2(30 BYTE) DEFAULT user NOT NULL);