--select * from system_parameters where name like 'VERSION%' order by name desc
INSERT INTO system_parameters (name,value) VALUES ('VERSION 2025.10.09', 'INSTALLED');
commit;

Alter table subjects modify ("ATTRIBS_01" VARCHAR2(2000)); 
Alter table subjects modify ("ATTRIBS_02" VARCHAR2(2000)); 
Alter table subjects_history modify ("ATTRIBS_01" VARCHAR2(2000)); 
Alter table subjects_history modify ("ATTRIBS_02" VARCHAR2(2000)); 
alter table HOLIDAY_DAYS modify (type varchar2(50));
