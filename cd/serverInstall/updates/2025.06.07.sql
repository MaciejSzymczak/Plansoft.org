--select * from system_parameters where name like 'VERSION%' order by name desc
INSERT INTO system_parameters (name,value) VALUES ('VERSION 2025.06.07', 'INSTALLED');
commit;

CREATE TABLE  holiday_days  
  (	 ID  NUMBER(10,0), 
	 DAY  DATE, 
	 HOUR  NUMBER(2,0), 
	 CREATION_DATE  DATE DEFAULT sysdate NOT NULL ENABLE, 
	 CREATED_BY  VARCHAR2(30 BYTE) DEFAULT user NOT NULL ENABLE, 
	 LAST_UPDATE_DATE  DATE DEFAULT sysdate NOT NULL ENABLE, 
	 LAST_UPDATED_BY  VARCHAR2(30 BYTE) DEFAULT user NOT NULL ENABLE, 
	 TYPE  VARCHAR2(15 BYTE) DEFAULT 'HOLIDAY',
	 PER_ID NUMBER(10,0)
  ) TABLESPACE  USERS;

alter table holiday_days add (classes_allowed CHAR(1) DEFAULT '+');

CREATE INDEX HD_PK ON holiday_days (ID) TABLESPACE  USERS; 

ALTER TABLE  HOLIDAY_DAYS ADD CONSTRAINT  HD_PK  PRIMARY KEY ( ID ) USING INDEX  HD_PK  ENABLE;

CREATE OR REPLACE TRIGGER  HD_T1  
 before delete or insert
 on reservations
referencing new as new old as old
for each row
begin
 for rec in (select edit_reservations from planners where name=user and edit_reservations='-') loop
  raise_application_error(-20000, 'Nie masz uprawnien do zmiany dni wolnych');
 end loop; 
end;
/
ALTER TRIGGER HD_T1  ENABLE;

CREATE INDEX HD_PER_ID ON holiday_days (PER_ID) TABLESPACE  USERS; 

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
