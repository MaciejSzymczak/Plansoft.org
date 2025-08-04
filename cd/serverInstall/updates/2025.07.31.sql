--select * from system_parameters where name like 'VERSION%' order by name desc
INSERT INTO system_parameters (name,value) VALUES ('VERSION 2025.07.31', 'INSTALLED');
commit;

CREATE TABLE EXCLUSIONS 
(	ID NUMBER(10,0) primary key, 
RES_ID NUMBER NOT NULL, 
RES_ID_EXCLUDED NUMBER NOT NULL,
DATE_FROM DATE,
DATE_TO DATE,
LAST_UPDATED_BY VARCHAR2(30 BYTE) DEFAULT USER NOT NULL, 
CREATED_BY VARCHAR2(30 BYTE) DEFAULT USER NOT NULL , 
CREATION_DATE DATE DEFAULT sysdate NOT NULL , 
LAST_UPDATE_DATE DATE DEFAULT sysdate NOT NULL 
) TABLESPACE "USERS" ;

CREATE INDEX EXCLUSIONS_RES_ID_I ON EXCLUSIONS (RES_ID) 
TABLESPACE "USERS" ;

CREATE INDEX EXCLUSIONS_RES_ID2_I ON EXCLUSIONS (RES_ID_EXCLUDED) 
TABLESPACE "USERS" ;

CREATE OR REPLACE FORCE EDITIONABLE VIEW exclusions_v (id, res_id, res_id_excluded, date_from, date_to, res_dsp,res_exluded_dsp ) AS 
select 
id, res_id, res_id_excluded, date_from, date_to
,(select name from resources where id = res_id) res_dsp 
,(select name from resources where id = res_id_excluded) res_exluded_dsp  
from exclusions;

DECLARE
CURSOR TEMP
IS
select 'CREATE PUBLIC SYNONYM '||object_name||' FOR '||object_name S from sys.all_objects where owner = user and
OBJECT_TYPE NOT IN ('SYNONYM', 'INDEX', 'PACKAGE BODY') order by object_name;
BEGIN
FOR REC_TEMP IN TEMP
	LOOP
		 BEGIN
			execute immediate REC_TEMP.S;
		 EXCEPTION 
		 WHEN OTHERS THEN
			NULL;
		 END;
	END LOOP;
END;
/

**** install package planner_utils