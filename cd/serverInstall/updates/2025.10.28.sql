--select * from system_parameters where name like 'VERSION%' order by name desc
INSERT INTO system_parameters (name,value) VALUES ('VERSION 2025.10.28', 'INSTALLED');
commit;

alter table usos_temp add (CREATED_BY VARCHAR2(30 BYTE) DEFAULT user NOT NULL);

alter table planners add IS_INTEGRATED CHAR(1 BYTE) DEFAULT '-';
ALTER TABLE planners ADD EDIT_OBJ_PERMISSIONS CHAR(1) DEFAULT '+';

alter table periods add (PER_ORGUNI_ID NUMBER);
CREATE INDEX PERIODS_ORGUNI_FK_I ON PERIODS (PER_ORGUNI_ID);
alter table periods add CONSTRAINT PERIODS_ORGUNI_FK_FK FOREIGN KEY (PER_ORGUNI_ID) REFERENCES ORG_UNITS (ID);

