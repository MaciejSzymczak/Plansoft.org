--select * from system_parameters where name like 'VERSION%' order by name desc
INSERT INTO system_parameters (name,value) VALUES ('VERSION 2025.09.26', 'INSTALLED');
commit;

alter table TT_INTERFACE add(
	"CREATION_DATE" DATE DEFAULT sysdate NOT NULL , 
	"CREATED_BY" VARCHAR2(30 BYTE) DEFAULT user NOT NULL , 
	"LAST_UPDATE_DATE" DATE DEFAULT sysdate NOT NULL , 
	"LAST_UPDATED_BY" VARCHAR2(30 BYTE) DEFAULT user NOT NULL);

*** Zainstaluj pakiet tt_interface_pkg