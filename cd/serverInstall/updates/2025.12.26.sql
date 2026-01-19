--select * from system_parameters where name like 'VERSION%' order by name desc
INSERT INTO system_parameters (name,value) VALUES ('VERSION 2025.12.26', 'INSTALLED');
commit;

create public synonym usos_ps for usos_ps;

alter table holiday_days_temp modify (CREATION_DATE DATE DEFAULT sysdate);
alter table holiday_days_temp modify (CREATED_BY VARCHAR2(30 BYTE) DEFAULT user); 
alter table holiday_days_temp modify (LAST_UPDATE_DATE DATE DEFAULT sysdate);
alter table holiday_days_temp modify (LAST_UPDATED_BY VARCHAR2(30 BYTE) DEFAULT user);

CREATE GLOBAL TEMPORARY TABLE holiday_days_temp
ON COMMIT PRESERVE ROWS
AS
SELECT *
FROM holiday_days
WHERE 1 = 0;

CREATE PUBLIC SYNONYM holiday_days_temp for planner.holiday_days_temp;

*** install package TT_PLANNER