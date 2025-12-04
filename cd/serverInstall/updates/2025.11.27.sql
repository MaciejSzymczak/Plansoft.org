--select * from system_parameters where name like 'VERSION%' order by name desc
INSERT INTO system_parameters (name,value) VALUES ('VERSION 2025.11.27', 'INSTALLED');
commit;

create table versions (Id number, name varchar2(100) not null, per_id number not null
, date_from date not null, date_to date not null, planners  varchar2(500) not null
,userOrRoleID number);
alter table versions modify id primary key;

create unique index VERSIONS_U on versions(name);

alter table versions add(
	"OWNER" VARCHAR2(30 BYTE) default user NOT NULL, 
	"LAST_UPDATED_BY" VARCHAR2(30 BYTE) default user NOT NULL, 
	"CREATED_BY" VARCHAR2(30 BYTE) DEFAULT USER NOT NULL, 
	"CREATION_DATE" DATE DEFAULT sysdate NOT NULL, 
	"LAST_UPDATE_DATE" DATE DEFAULT sysdate NOT NULL);
	
create table classes_ver as select * from classes where rownum=0;
create table lec_cla_ver as select * from lec_cla where rownum=0;
create table gro_cla_ver as select * from gro_cla where rownum=0;
create table rom_cla_ver as select * from rom_cla where rownum=0;
alter table classes_ver add (ver_id number);
alter table lec_cla_ver add (ver_id number);
alter table gro_cla_ver add (ver_id number);
alter table rom_cla_ver add (ver_id number);

CREATE INDEX classes_ver_FK_I ON classes_ver (ver_id) TABLESPACE "USERS" ;
CREATE INDEX lec_cla_FK_I ON lec_cla_ver (ver_id) TABLESPACE "USERS" ;
CREATE INDEX gro_cla_FK_I ON gro_cla_ver (ver_id) TABLESPACE "USERS" ;
CREATE INDEX rom_cla_FK_I ON rom_cla_ver (ver_id) TABLESPACE "USERS" ;
  
alter table classes_ver add CONSTRAINT classes_ver_FK FOREIGN KEY (ver_id) REFERENCES versions (ID) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED ENABLE;
alter table lec_cla_ver add CONSTRAINT lec_cla_FK FOREIGN KEY (ver_id) REFERENCES versions (ID) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED ENABLE;
alter table gro_cla_ver add CONSTRAINT gro_cla_FK FOREIGN KEY (ver_id) REFERENCES versions (ID) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED ENABLE;
alter table rom_cla_ver add CONSTRAINT rom_cla_FK FOREIGN KEY (ver_id) REFERENCES versions (ID) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED ENABLE;

create table version_restore_messages (id number, ver_id number, message varchar2(500));
alter table version_restore_messages add (cla_id number);
create index version_restore_messages_i1 on version_restore_messages(cla_id);
create index version_restore_messages_i2 on version_restore_messages(ver_id);
alter table version_restore_messages modify id primary key;

*** Install package version_pkg

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
