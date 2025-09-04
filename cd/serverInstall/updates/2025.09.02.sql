--select * from system_parameters where name like 'VERSION%' order by name desc
INSERT INTO system_parameters (name,value) VALUES ('VERSION 2025.09.02', 'INSTALLED');
commit;

alter table org_units add (integration_id varchar2(40));
alter table org_units modify (name varchar2(100));
alter table org_units modify (code varchar2(10));

 CREATE TABLE INT_ORG_UNITS 
   (	"CODE" VARCHAR2(100), 
	"NAME" VARCHAR2(255), 
	"PARENT_DSP" VARCHAR2(255), 
	"INTEGRATION_ID" VARCHAR2(100)
   ) 
  TABLESPACE "USERS" ;

