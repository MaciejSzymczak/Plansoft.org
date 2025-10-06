--select * from system_parameters where name like 'VERSION%' order by name desc
INSERT INTO system_parameters (name,value) VALUES ('VERSION 2025.10.03', 'INSTALLED');
commit;

INSERT INTO system_parameters (name,value) VALUES ('USOS_PACKAGE_NAME', 'USOS');
commit;

alter table org_units modify (code varchar2(20));

alter table planners add (ORGUNI_ID NUMBER);
CREATE INDEX PLANNERS_ORGUNI_FK_I ON PLANNERS (ORGUNI_ID);

ALTER TABLE PLANNERS
  ADD CONSTRAINT PLANNERS_ORGUNI_FK_FK
  FOREIGN KEY (ORGUNI_ID)
  REFERENCES ORG_UNITS (ID);

