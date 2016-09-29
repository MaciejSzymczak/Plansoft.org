-- 2013.05.07: 
--LOCAL: YES (but automatic update)
--LOCALPRIV: NO
--ININSTALL: NO 
--WAT  : YES
--WROC : NO 
--PWWA : NO 
--SOPOT: YES 

-- it is done by new version of package planner_utils
drop trigger PLANNER.lec_cla_trg;
drop trigger PLANNER.rom_cla_trg;
drop trigger PLANNER.gro_cla_trg;

Insert into FLEX_COL_USAGE
   (ID, FORM_NAME, CONTEXT_NAME, ATTR_NAME, CUSTOM_NAME, CAPTION, WIDTH, SQL_DEFAULT_VALUE, SQL_CHECK_PROCEDURE, SQL_CHECK_MESSAGE, REQUIRED, LABEL_POS_X, LABEL_POS_Y, FIELD_POS_X, FIELD_POS_Y, SHOW_IN_LIST, SHOW_IN_ORDER_BY, SYSTEM_FLAG, SHOW_IN_WHERE, CREATION_DATE, CREATED_BY, LAST_UPDATE_DATE, LAST_UPDATED_BY)
 Values
   (-2, 'FBrowsePLANNERS', 'DEFAULT', 'ATTRIBS_02', 'CHANGE_ME_ATTRIBS_02', 'Œledzenie historii zmian', 50, 'select ''-'' from dual', 'select case when :current in (''-'',''+'') then null else ''ERROR'' end from dual', 'Dozwolone znaki w tym polu to "-" oraz "+"', '+', 2, 32, 120, 26, '+', '+', '+', '+', TO_DATE('01/27/2013 18:08:14', 'MM/DD/YYYY HH24:MI:SS'), 'PLANNER', TO_DATE('01/27/2013 18:08:14', 'MM/DD/YYYY HH24:MI:SS'), 'PLANNER');
COMMIT;

-- adjust to new version of package planner_utils
ALTER TABLE LEC_CLA
  DROP CONSTRAINT LECCLA_CLA_FK;

ALTER TABLE LEC_CLA ADD (
  CONSTRAINT LECCLA_CLA_FK 
 FOREIGN KEY (CLA_ID) 
 REFERENCES CLASSES (ID)
    ON DELETE CASCADE INITIALLY DEFERRED DEFERRABLE)
    

ALTER TABLE GRO_CLA
  DROP CONSTRAINT GROCLA_CLA_FK;


ALTER TABLE GRO_CLA ADD (
  CONSTRAINT GROCLA_CLA_FK 
 FOREIGN KEY (CLA_ID) 
 REFERENCES CLASSES (ID)
    ON DELETE CASCADE INITIALLY DEFERRED DEFERRABLE);


ALTER TABLE ROM_CLA
  DROP CONSTRAINT TOMCLA_CLA_FK;


ALTER TABLE ROM_CLA ADD (
  CONSTRAINT TOMCLA_CLA_FK 
 FOREIGN KEY (CLA_ID) 
 REFERENCES CLASSES (ID)
    ON DELETE CASCADE  INITIALLY DEFERRED DEFERRABLE);


prompt ------------------------------ trial mechanism for table classes -------------------------------------

alter table classes add (effective_start_date date, effective_end_date date);
alter table classes add (last_updated_by varchar2(30));
alter table classes add (operation_flag char(1));

comment on column classes.effective_start_date is 'Used by trail mechanism';
comment on column classes.effective_end_date is 'Used by trail mechanism';
comment on column classes.last_updated_by is 'Used by trail mechanism';
comment on column classes.operation_flag is 'Used by trail mechanism';

create global temporary table classes_h_temp as select * from classes where 0=1;
create table classes_history as select * from classes where 0=1;
create index classes_i  on classes_history ( id );
create index classes_i2 on classes_history ( effective_start_date );
create index classes_i3 on classes_history ( effective_end_date );

CREATE OR REPLACE package classes_history_pkg as
  type t is table of number index by binary_integer;
  ids t;
  trial_active boolean := true;
END;
/

CREATE OR REPLACE TRIGGER PLANNER.classes_history_t0
before INSERT or update or delete ON classes
REFERENCING NEW AS NEW
FOR EACH ROW
DECLARE
  i  NUMBER;
BEGIN
  if deleting then
    --xxmsz_tools.insertIntoEventLog('T0 id: '||nvl(:old.id, :new.id) ,'I');
    insert into classes_h_temp (id, day, hour, fill, sub_id, for_id, desc1, desc2, calc_lecturers, calc_groups, calc_rooms, calc_lec_ids, calc_gro_ids, calc_rom_ids, created_by, owner, status, colour, calc_rescat_ids, creation_date, desc3, desc4, effective_start_date, effective_end_date, last_updated_by, operation_flag)
    values (:old.id, :old.day, :old.hour, :old.fill, :old.sub_id, :old.for_id, :old.desc1, :old.desc2, :old.calc_lecturers, :old.calc_groups, :old.calc_rooms, :old.calc_lec_ids, :old.calc_gro_ids, :old.calc_rom_ids, :old.created_by, :old.owner, :old.status, :old.colour, :old.calc_rescat_ids, :old.creation_date, :old.desc3, :old.desc4, :old.effective_start_date, :old.effective_end_date, :old.last_updated_by, :old.operation_flag);
  end if;
END;
/

CREATE OR REPLACE TRIGGER classes_history_t1
AFTER INSERT or update or delete ON classes
REFERENCING NEW AS NEW
FOR EACH ROW
DECLARE
i  NUMBER;
BEGIN
  if classes_history_pkg.trial_active then
    i := classes_history_pkg.ids.count;
    classes_history_pkg.ids( i+1 ) := nvl(:old.id, :new.id);
  end if;	
END;
/

CREATE OR REPLACE TRIGGER PLANNER.classes_history_t2 after update or insert or delete  
on classes
DECLARE
  j NUMBER;
  procedure  process ( pid number ) is
   rec classes%rowtype;
   psysdate date := sysdate;
  begin
     if deleting then
        begin
          select * into rec from classes_history where id = pid and effective_end_date is null;
        exception when no_data_found then 
          --no record in history table, likely trial was disabled before
          select * into rec from classes_h_temp where id = pid and effective_end_date is null; --<-- 2013.03.06         
        end;
     else
        select * into rec from classes where id = pid;
     end if;
     update classes_history
        set effective_end_date = psysdate - NumTodsInterval(1, 'second')
        where id = pid
        and effective_end_date is null;
     rec.effective_start_date := psysdate;
     if deleting then rec.effective_end_date := psysdate; end if;
     rec.last_updated_by := user;
     if inserting then rec.operation_flag := 'I'; end if;
     if updating then rec.operation_flag := 'U'; end if;
     if deleting then rec.operation_flag := 'D'; end if;   
     insert into classes_history values rec;
  end;
BEGIN
  j := classes_history_pkg.ids.first;
  WHILE j IS NOT NULL LOOP
      --xxmsz_tools.insertIntoEventLog('T2 id: '|| classes_history_pkg.ids (j) ,'I');
      process ( classes_history_pkg.ids (j) );
      j := classes_history_pkg.ids.next(j);
  END LOOP;
  classes_history_pkg.ids.delete;
  delete from classes_h_temp;  --<-- 2013.03.06
END;
/


prompt ------------------------------ trial mechanism for table forms -------------------------------------

alter table forms add (effective_start_date date, effective_end_date date);
alter table forms add (last_updated_by varchar2(30));
alter table forms add (operation_flag char(1));

comment on column forms.effective_start_date is 'Used by trail mechanism';
comment on column forms.effective_end_date is 'Used by trail mechanism';
comment on column forms.last_updated_by is 'Used by trail mechanism';
comment on column forms.operation_flag is 'Used by trail mechanism';

create table forms_history as select * from forms where 0=1;
create index forms_i  on forms_history ( id );
create index forms_i2 on forms_history ( effective_start_date );
create index forms_i3 on forms_history ( effective_end_date );

CREATE OR REPLACE package forms_history_pkg as
  type t is table of number index by binary_integer;
  ids t;
  trial_active boolean := true;
END;
/

CREATE OR REPLACE TRIGGER forms_history_t1
AFTER INSERT or update or delete ON forms
REFERENCING NEW AS NEW
FOR EACH ROW
DECLARE
i  NUMBER;
BEGIN
  if forms_history_pkg.trial_active then
    i := classes_history_pkg.ids.count;
    forms_history_pkg.ids( i+1 ) := nvl(:old.id, :new.id);
  end if;	
END;
/

CREATE OR REPLACE TRIGGER forms_history_t2 after update or insert or delete  
on forms
DECLARE
j            NUMBER;
procedure  process ( pid number ) is
 rec forms%rowtype;
 psysdate date := sysdate;
begin
 if deleting then
    select * into rec from forms_history where id = pid and effective_end_date is null;
 else
    select * into rec from forms where id = pid;
 end if;
 update forms_history
    set effective_end_date = psysdate - NumTodsInterval(1, 'second')
    where id = pid
    and effective_end_date is null;
 rec.effective_start_date := psysdate;
 if deleting then rec.effective_end_date := psysdate; end if;
 rec.last_updated_by := user;
 if inserting then rec.operation_flag := 'I'; end if;
 if updating then rec.operation_flag := 'U'; end if;
 if deleting then rec.operation_flag := 'D'; end if;   
 insert into forms_history values rec;
exception when no_data_found then null; --no record in history table, likely trial was disabled before
end;
BEGIN
j := forms_history_pkg.ids.first;
WHILE j IS NOT NULL LOOP
    process ( forms_history_pkg.ids (j) );
    j := forms_history_pkg.ids.next(j);
END LOOP;
forms_history_pkg.ids.delete;
END;
/

prompt ------------------------------ trial mechanism for table subjects -------------------------------------

alter table subjects add (effective_start_date date, effective_end_date date);
alter table subjects add (last_updated_by varchar2(30));
alter table subjects add (operation_flag char(1));

comment on column subjects.effective_start_date is 'Used by trail mechanism';
comment on column subjects.effective_end_date is 'Used by trail mechanism';
comment on column subjects.last_updated_by is 'Used by trail mechanism';
comment on column subjects.operation_flag is 'Used by trail mechanism';

create table subjects_history as select * from subjects where 0=1;
create index subjects_i  on subjects_history ( id );
create index subjects_i2 on subjects_history ( effective_start_date );
create index subjects_i3 on subjects_history ( effective_end_date );

CREATE OR REPLACE package subjects_history_pkg as
  type t is table of number index by binary_integer;
  ids t;
  trial_active boolean := true;
END;
/

CREATE OR REPLACE TRIGGER subjects_history_t1
AFTER INSERT or update or delete ON subjects
REFERENCING NEW AS NEW
FOR EACH ROW
DECLARE
i  NUMBER;
BEGIN
  if subjects_history_pkg.trial_active then
    i := classes_history_pkg.ids.count;
    subjects_history_pkg.ids( i+1 ) := nvl(:old.id, :new.id);
  end if;	
END;
/

CREATE OR REPLACE TRIGGER subjects_history_t2 after update or insert or delete  
on subjects
DECLARE
j            NUMBER;
procedure  process ( pid number ) is
 rec subjects%rowtype;
 psysdate date := sysdate;
begin
 if deleting then
    select * into rec from subjects_history where id = pid and effective_end_date is null;
 else
    select * into rec from subjects where id = pid;
 end if;
 update subjects_history
    set effective_end_date = psysdate - NumTodsInterval(1, 'second')
    where id = pid
    and effective_end_date is null;
 rec.effective_start_date := psysdate;
 if deleting then rec.effective_end_date := psysdate; end if;
 rec.last_updated_by := user;
 if inserting then rec.operation_flag := 'I'; end if;
 if updating then rec.operation_flag := 'U'; end if;
 if deleting then rec.operation_flag := 'D'; end if;   
 insert into subjects_history values rec;
exception when no_data_found then null; --no record in history table, likely trial was disabled before
end;
BEGIN
j := subjects_history_pkg.ids.first;
WHILE j IS NOT NULL LOOP
    process ( subjects_history_pkg.ids (j) );
    j := subjects_history_pkg.ids.next(j);
END LOOP;
subjects_history_pkg.ids.delete;
END;
/

prompt ------------------------------ trial mechanism for table lec_cla -------------------------------------

alter table lec_cla add (effective_start_date date, effective_end_date date);
alter table lec_cla add (last_updated_by varchar2(30));
alter table lec_cla add (operation_flag char(1));

comment on column lec_cla.effective_start_date is 'Used by trail mechanism';
comment on column lec_cla.effective_end_date is 'Used by trail mechanism';
comment on column lec_cla.last_updated_by is 'Used by trail mechanism';
comment on column lec_cla.operation_flag is 'Used by trail mechanism';

create table lec_cla_history as select * from lec_cla where 0=1;
create index lec_cla_i  on lec_cla_history ( id );
create index lec_cla_i2 on lec_cla_history ( effective_start_date );
create index lec_cla_i3 on lec_cla_history ( effective_end_date );

CREATE OR REPLACE package lec_cla_history_pkg as
  type t is table of number index by binary_integer;
  ids t;
  trial_active boolean := true;
END;
/

CREATE OR REPLACE TRIGGER lec_cla_history_t1
AFTER INSERT or update or delete ON lec_cla
REFERENCING NEW AS NEW
FOR EACH ROW
DECLARE
i  NUMBER;
BEGIN
  if lec_cla_history_pkg.trial_active then
    i := classes_history_pkg.ids.count;
    lec_cla_history_pkg.ids( i+1 ) := nvl(:old.id, :new.id);
  end if;	
END;
/

CREATE OR REPLACE TRIGGER lec_cla_history_t2 after update or insert or delete  
on lec_cla
DECLARE
j            NUMBER;
procedure  process ( pid number ) is
 rec lec_cla%rowtype;
 psysdate date := sysdate;
begin
 if deleting then
    select * into rec from lec_cla_history where id = pid and effective_end_date is null;
 else
    select * into rec from lec_cla where id = pid;
 end if;
 update lec_cla_history
    set effective_end_date = psysdate - NumTodsInterval(1, 'second')
    where id = pid
    and effective_end_date is null;
 rec.effective_start_date := psysdate;
 if deleting then rec.effective_end_date := psysdate; end if;
 rec.last_updated_by := user;
 if inserting then rec.operation_flag := 'I'; end if;
 if updating then rec.operation_flag := 'U'; end if;
 if deleting then rec.operation_flag := 'D'; end if;   
 insert into lec_cla_history values rec;
exception when no_data_found then null; --no record in history table, likely trial was disabled before
end;
BEGIN
j := lec_cla_history_pkg.ids.first;
WHILE j IS NOT NULL LOOP
    process ( lec_cla_history_pkg.ids (j) );
    j := lec_cla_history_pkg.ids.next(j);
END LOOP;
lec_cla_history_pkg.ids.delete;
END;
/

prompt ------------------------------ trial mechanism for table gro_cla -------------------------------------

alter table gro_cla add (effective_start_date date, effective_end_date date);
alter table gro_cla add (last_updated_by varchar2(30));
alter table gro_cla add (operation_flag char(1));

comment on column gro_cla.effective_start_date is 'Used by trail mechanism';
comment on column gro_cla.effective_end_date is 'Used by trail mechanism';
comment on column gro_cla.last_updated_by is 'Used by trail mechanism';
comment on column gro_cla.operation_flag is 'Used by trail mechanism';

create table gro_cla_history as select * from gro_cla where 0=1;
create index gro_cla_i  on gro_cla_history ( id );
create index gro_cla_i2 on gro_cla_history ( effective_start_date );
create index gro_cla_i3 on gro_cla_history ( effective_end_date );

CREATE OR REPLACE package gro_cla_history_pkg as
  type t is table of number index by binary_integer;
  ids t;
  trial_active boolean := true;
END;
/

CREATE OR REPLACE TRIGGER gro_cla_history_t1
AFTER INSERT or update or delete ON gro_cla
REFERENCING NEW AS NEW
FOR EACH ROW
DECLARE
i  NUMBER;
BEGIN
  if gro_cla_history_pkg.trial_active then
    i := classes_history_pkg.ids.count;
    gro_cla_history_pkg.ids( i+1 ) := nvl(:old.id, :new.id);
  end if;	
END;
/

CREATE OR REPLACE TRIGGER gro_cla_history_t2 after update or insert or delete  
on gro_cla
DECLARE
j            NUMBER;
procedure  process ( pid number ) is
 rec gro_cla%rowtype;
 psysdate date := sysdate;
begin
 if deleting then
    select * into rec from gro_cla_history where id = pid and effective_end_date is null;
 else
    select * into rec from gro_cla where id = pid;
 end if;
 update gro_cla_history
    set effective_end_date = psysdate - NumTodsInterval(1, 'second')
    where id = pid
    and effective_end_date is null;
 rec.effective_start_date := psysdate;
 if deleting then rec.effective_end_date := psysdate; end if;
 rec.last_updated_by := user;
 if inserting then rec.operation_flag := 'I'; end if;
 if updating then rec.operation_flag := 'U'; end if;
 if deleting then rec.operation_flag := 'D'; end if;   
 insert into gro_cla_history values rec;
exception when no_data_found then null; --no record in history table, likely trial was disabled before
end;
BEGIN
j := gro_cla_history_pkg.ids.first;
WHILE j IS NOT NULL LOOP
    process ( gro_cla_history_pkg.ids (j) );
    j := gro_cla_history_pkg.ids.next(j);
END LOOP;
gro_cla_history_pkg.ids.delete;
END;
/

prompt ------------------------------ trial mechanism for table rom_cla -------------------------------------

alter table rom_cla add (effective_start_date date, effective_end_date date);
alter table rom_cla add (last_updated_by varchar2(30));
alter table rom_cla add (operation_flag char(1));

comment on column rom_cla.effective_start_date is 'Used by trail mechanism';
comment on column rom_cla.effective_end_date is 'Used by trail mechanism';
comment on column rom_cla.last_updated_by is 'Used by trail mechanism';
comment on column rom_cla.operation_flag is 'Used by trail mechanism';

create table rom_cla_history as select * from rom_cla where 0=1;
create index rom_cla_i  on rom_cla_history ( id );
create index rom_cla_i2 on rom_cla_history ( effective_start_date );
create index rom_cla_i3 on rom_cla_history ( effective_end_date );

CREATE OR REPLACE package rom_cla_history_pkg as
  type t is table of number index by binary_integer;
  ids t;
  trial_active boolean := true;
END;
/

CREATE OR REPLACE TRIGGER rom_cla_history_t1
AFTER INSERT or update or delete ON rom_cla
REFERENCING NEW AS NEW
FOR EACH ROW
DECLARE
i  NUMBER;
BEGIN
  if classes_history_pkg.trial_active then
    i := rom_cla_history_pkg.ids.count;
    rom_cla_history_pkg.ids( i+1 ) := nvl(:old.id, :new.id);
  end if;	
END;
/

CREATE OR REPLACE TRIGGER rom_cla_history_t2 after update or insert or delete  
on rom_cla
DECLARE
j            NUMBER;
procedure  process ( pid number ) is
 rec rom_cla%rowtype;
 psysdate date := sysdate;
begin
 if deleting then
    select * into rec from rom_cla_history where id = pid and effective_end_date is null;
 else
    select * into rec from rom_cla where id = pid;
 end if;
 update rom_cla_history
    set effective_end_date = psysdate - NumTodsInterval(1, 'second')
    where id = pid
    and effective_end_date is null;
 rec.effective_start_date := psysdate;
 if deleting then rec.effective_end_date := psysdate; end if;
 rec.last_updated_by := user;
 if inserting then rec.operation_flag := 'I'; end if;
 if updating then rec.operation_flag := 'U'; end if;
 if deleting then rec.operation_flag := 'D'; end if;   
 insert into rom_cla_history values rec;
exception when no_data_found then null; --no record in history table, likely trial was disabled before
end;
BEGIN
j := rom_cla_history_pkg.ids.first;
WHILE j IS NOT NULL LOOP
    process ( rom_cla_history_pkg.ids (j) );
    j := rom_cla_history_pkg.ids.next(j);
END LOOP;
rom_cla_history_pkg.ids.delete;
END;
/

prompt ------------------------------ trial mechanism for table lecturers -------------------------------------

alter table lecturers add (effective_start_date date, effective_end_date date);
alter table lecturers add (last_updated_by varchar2(30));
alter table lecturers add (operation_flag char(1));

comment on column lecturers.effective_start_date is 'Used by trail mechanism';
comment on column lecturers.effective_end_date is 'Used by trail mechanism';
comment on column lecturers.last_updated_by is 'Used by trail mechanism';
comment on column lecturers.operation_flag is 'Used by trail mechanism';

create table lecturers_history as select * from lecturers where 0=1;
create index lecturers_i  on lecturers_history ( id );
create index lecturers_i2 on lecturers_history ( effective_start_date );
create index lecturers_i3 on lecturers_history ( effective_end_date );

CREATE OR REPLACE package lecturers_history_pkg as
  type t is table of number index by binary_integer;
  ids t;
  trial_active boolean := true;
END;
/

CREATE OR REPLACE TRIGGER lecturers_history_t1
AFTER INSERT or update or delete ON lecturers
REFERENCING NEW AS NEW
FOR EACH ROW
DECLARE
i  NUMBER;
BEGIN
  if lecturers_history_pkg.trial_active then
    i := classes_history_pkg.ids.count;
    lecturers_history_pkg.ids( i+1 ) := nvl(:old.id, :new.id);
  end if;	
END;
/

CREATE OR REPLACE TRIGGER lecturers_history_t2 after update or insert or delete  
on lecturers
DECLARE
j            NUMBER;
procedure  process ( pid number ) is
 rec lecturers%rowtype;
 psysdate date := sysdate;
begin
 if deleting then
    select * into rec from lecturers_history where id = pid and effective_end_date is null;
 else
    select * into rec from lecturers where id = pid;
 end if;
 update lecturers_history
    set effective_end_date = psysdate - NumTodsInterval(1, 'second')
    where id = pid
    and effective_end_date is null;
 rec.effective_start_date := psysdate;
 if deleting then rec.effective_end_date := psysdate; end if;
 rec.last_updated_by := user;
 if inserting then rec.operation_flag := 'I'; end if;
 if updating then rec.operation_flag := 'U'; end if;
 if deleting then rec.operation_flag := 'D'; end if;   
 insert into lecturers_history values rec;
exception when no_data_found then null; --no record in history table, likely trial was disabled before
end;
BEGIN
j := lecturers_history_pkg.ids.first;
WHILE j IS NOT NULL LOOP
    process ( lecturers_history_pkg.ids (j) );
    j := lecturers_history_pkg.ids.next(j);
END LOOP;
lecturers_history_pkg.ids.delete;
END;
/

prompt ------------------------------ trial mechanism for table groups -------------------------------------

alter table groups add (effective_start_date date, effective_end_date date);
alter table groups add (last_updated_by varchar2(30));
alter table groups add (operation_flag char(1));

comment on column groups.effective_start_date is 'Used by trail mechanism';
comment on column groups.effective_end_date is 'Used by trail mechanism';
comment on column groups.last_updated_by is 'Used by trail mechanism';
comment on column groups.operation_flag is 'Used by trail mechanism';

create table groups_history as select * from groups where 0=1;
create index groups_i  on groups_history ( id );
create index groups_i2 on groups_history ( effective_start_date );
create index groups_i3 on groups_history ( effective_end_date );

CREATE OR REPLACE package groups_history_pkg as
  type t is table of number index by binary_integer;
  ids t;
  trial_active boolean := true;
END;
/

CREATE OR REPLACE TRIGGER groups_history_t1
AFTER INSERT or update or delete ON groups
REFERENCING NEW AS NEW
FOR EACH ROW
DECLARE
i  NUMBER;
BEGIN
  if groups_history_pkg.trial_active then
    i := classes_history_pkg.ids.count;
    groups_history_pkg.ids( i+1 ) := nvl(:old.id, :new.id);
  end if;	
END;
/

CREATE OR REPLACE TRIGGER groups_history_t2 after update or insert or delete  
on groups
DECLARE
j            NUMBER;
procedure  process ( pid number ) is
 rec groups%rowtype;
 psysdate date := sysdate;
begin
 if deleting then
    select * into rec from groups_history where id = pid and effective_end_date is null;
 else
    select * into rec from groups where id = pid;
 end if;
 update groups_history
    set effective_end_date = psysdate - NumTodsInterval(1, 'second')
    where id = pid
    and effective_end_date is null;
 rec.effective_start_date := psysdate;
 if deleting then rec.effective_end_date := psysdate; end if;
 rec.last_updated_by := user;
 if inserting then rec.operation_flag := 'I'; end if;
 if updating then rec.operation_flag := 'U'; end if;
 if deleting then rec.operation_flag := 'D'; end if;   
 insert into groups_history values rec;
exception when no_data_found then null; --no record in history table, likely trial was disabled before
end;
BEGIN
j := groups_history_pkg.ids.first;
WHILE j IS NOT NULL LOOP
    process ( groups_history_pkg.ids (j) );
    j := groups_history_pkg.ids.next(j);
END LOOP;
groups_history_pkg.ids.delete;
END;
/

prompt ------------------------------ trial mechanism for table rooms -------------------------------------

alter table rooms add (effective_start_date date, effective_end_date date);
alter table rooms add (last_updated_by varchar2(30));
alter table rooms add (operation_flag char(1));

comment on column rooms.effective_start_date is 'Used by trail mechanism';
comment on column rooms.effective_end_date is 'Used by trail mechanism';
comment on column rooms.last_updated_by is 'Used by trail mechanism';
comment on column rooms.operation_flag is 'Used by trail mechanism';

create table rooms_history as select * from rooms where 0=1;
create index rooms_i  on rooms_history ( id );
create index rooms_i2 on rooms_history ( effective_start_date );
create index rooms_i3 on rooms_history ( effective_end_date );

CREATE OR REPLACE package rooms_history_pkg as
  type t is table of number index by binary_integer;
  ids t;
  trial_active boolean := true;
END;
/

CREATE OR REPLACE TRIGGER rooms_history_t1
AFTER INSERT or update or delete ON rooms
REFERENCING NEW AS NEW
FOR EACH ROW
DECLARE
i  NUMBER;
BEGIN
  if rooms_history_pkg.trial_active then
    i := classes_history_pkg.ids.count;
    rooms_history_pkg.ids( i+1 ) := nvl(:old.id, :new.id);
  end if;	
END;
/

CREATE OR REPLACE TRIGGER rooms_history_t2 after update or insert or delete  
on rooms
DECLARE
j            NUMBER;
procedure  process ( pid number ) is
 rec rooms%rowtype;
 psysdate date := sysdate;
begin
 if deleting then
    select * into rec from rooms_history where id = pid and effective_end_date is null;
 else
    select * into rec from rooms where id = pid;
 end if;
 update rooms_history
    set effective_end_date = psysdate - NumTodsInterval(1, 'second')
    where id = pid
    and effective_end_date is null;
 rec.effective_start_date := psysdate;
 if deleting then rec.effective_end_date := psysdate; end if;
 rec.last_updated_by := user;
 if inserting then rec.operation_flag := 'I'; end if;
 if updating then rec.operation_flag := 'U'; end if;
 if deleting then rec.operation_flag := 'D'; end if;   
 insert into rooms_history values rec;
exception when no_data_found then null; --no record in history table, likely trial was disabled before
end;
BEGIN
j := rooms_history_pkg.ids.first;
WHILE j IS NOT NULL LOOP
    process ( rooms_history_pkg.ids (j) );
    j := rooms_history_pkg.ids.next(j);
END LOOP;
rooms_history_pkg.ids.delete;
END;
/

prompt ------------------------- indexes ---------------------------------------

CREATE INDEX CLA_SUB_FK_I_H ON CLASSES_HISTORY (SUB_ID);
CREATE INDEX CLA_FOR_FK_I_H ON CLASSES_HISTORY (FOR_ID);
CREATE INDEX CLA_DAY_I_H ON CLASSES_HISTORY (DAY);
--intentilonally missed indexed: 
--CREATE INDEX CLA_DESC1_I ON CLASSES (DESC1);
--CREATE INDEX CLA_DESC2_I ON CLASSES (DESC2);
--CREATE INDEX CLA_DESC3_I ON CLASSES (DESC3);
--CREATE INDEX CLA_DESC4_I ON CLASSES (DESC4);
--CREATE UNIQUE INDEX FOR_NAME_UI ON FORMS (NAME);
--CREATE UNIQUE INDEX FRM_ABBREVIATION_I ON FORMS (ABBREVIATION);
--CREATE UNIQUE INDEX SUB_ABBREVIATION_I ON SUBJECTS (ABBREVIATION);
--CREATE UNIQUE INDEX SUB_NAME_I ON SUBJECTS (NAME);
--CREATE UNIQUE INDEX LEC_CLA_U ON LEC_CLA (LEC_ID, DAY, HOUR);
CREATE INDEX LECCLA_CLA_FK_I_H ON LEC_CLA_HISTORY (CLA_ID);
CREATE INDEX LECCLA_LEC_FK_I_H ON LEC_CLA_HISTORY (LEC_ID);

--CREATE UNIQUE INDEX GRO_CLA_U ON GRO_CLA (GRO_ID, DAY, HOUR)
CREATE INDEX GROCLA_GRO_FK_I_H ON GRO_CLA_HISTORY (GRO_ID);
CREATE INDEX GROCLA_CLA_FK_I_H ON GRO_CLA_HISTORY (CLA_ID);

--CREATE UNIQUE INDEX ROM_CLA_U ON ROM_CLA (ROM_ID, DAY, HOUR)
CREATE INDEX ROMCLA_ROM_FK_I_H ON ROM_CLA_HISTORY (ROM_ID);
CREATE INDEX TOMCLA_CLA_FK_I_H ON ROM_CLA_HISTORY (CLA_ID);

--CREATE UNIQUE INDEX LEC_NAME_UI ON LECTURERS (FIRST_NAME, LAST_NAME, TITLE)
--CREATE UNIQUE INDEX LEC_ABBREVIATION_I ON LECTURERS (ABBREVIATION)
CREATE INDEX LECTURERS_ORGUNI_FK_I_H ON LECTURERS_HISTORY (ORGUNI_ID);

--CREATE UNIQUE INDEX GRO_ABBREVIATION_I ON GROUPS(ABBREVIATION)
CREATE INDEX GRO_TYPE_FK_I_H ON GROUPS_HISTORY (GROUP_TYPE);

--CREATE UNIQUE INDEX ROOM_UK ON ROOMS (CASE "RESCAT_ID" WHEN 1 THEN "NAME"||' '||"ATTRIBS_01" ELSE TO_CHAR("ID") END )
CREATE INDEX ROM_RESCAT_FK_I_H ON ROOMS_HISTORY (RESCAT_ID);

