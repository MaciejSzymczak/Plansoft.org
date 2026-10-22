--select * from system_parameters where name like 'VERSION%' order by name desc
INSERT INTO system_parameters (name,value) VALUES ('VERSION 2026.10.22', 'INSTALLED');
commit;

-- '+' = log permission changes into RES_PLA_HISTORY (see planner_utils.res_pla_history), '-' = disabled
INSERT INTO system_parameters (name,value) VALUES ('RES_PLA_HISTORY', '-');
commit;

-- once enabled ('+'), RES_PLA_HISTORY cannot be disabled or removed
create or replace trigger SYSTEM_PARAMETERS_RESPLA_TRG
before update or delete on system_parameters
for each row
when (old.name = 'RES_PLA_HISTORY' and old.value = '+')
begin
  if deleting or :new.name <> 'RES_PLA_HISTORY' or nvl(:new.value, '-') <> '+' then
    raise_application_error(-20010, 'RES_PLA_HISTORY: Śledzenie historii zmian uprawnień nie może zostać wyłączone');
  end if;
end;
/

*** Install package planner_utils (before the triggers below: they read planner_utils.res_pla_history)

-- History of planner permissions: LEC_PLA, GRO_PLA, ROM_PLA, SUB_PLA, FOR_PLA, PER_PLA, ROL_PLA (tab "Autoryzacje")
-- Compatible with Oracle 10g (sequence instead of identity column)
-- OPERATION: I = insert, D = delete, U- = update (old values), U+ = update (new values)
-- RES_ID = LEC_ID / GRO_ID / ROM_ID / SUB_ID / FOR_ID / PER_ID / ROL_ID depending on TABLE_NAME
-- ACCESS_TYPE: E = edit, R = read only (xxx_PLA.ACCESS_TYPE)

CREATE TABLE RES_PLA_HISTORY
(  ID          NUMBER NOT NULL ,
 TABLE_NAME    VARCHAR2(10 BYTE) NOT NULL ,
 OPERATION     VARCHAR2(2 BYTE) NOT NULL ,
 ROW_ID        NUMBER ,
 RES_ID        NUMBER ,
 PLA_ID        NUMBER ,
 ACCESS_TYPE   VARCHAR2(1 BYTE) ,
 LAST_UPDATE_DATE  DATE DEFAULT sysdate NOT NULL ,
 LAST_UPDATED_BY   VARCHAR2(30 BYTE) DEFAULT user NOT NULL ,
 OS_USER       VARCHAR2(100 BYTE) ,
 MODULE        VARCHAR2(100 BYTE) ,
 CONSTRAINT RESPLAHIST_PK PRIMARY KEY ( ID ) USING INDEX TABLESPACE USERS
) TABLESPACE USERS ;

-- search by planner
CREATE INDEX RESPLAHIST_PLA_I ON RES_PLA_HISTORY ( PLA_ID, LAST_UPDATE_DATE )
TABLESPACE USERS ;

-- search by resource (RES_ID is unique across resource tables and planners - main_seq)
CREATE INDEX RESPLAHIST_RES_I ON RES_PLA_HISTORY ( RES_ID, LAST_UPDATE_DATE )
TABLESPACE USERS ;

-- search by who changed the permission
CREATE INDEX RESPLAHIST_LUB_I ON RES_PLA_HISTORY ( LAST_UPDATED_BY, LAST_UPDATE_DATE )
TABLESPACE USERS ;

-- data removal (default sort of FBrowseRES_PLA_HISTORY is ID DESC - primary key index RESPLAHIST_PK)
CREATE INDEX RESPLAHIST_LAST_UPDATE_DATE_I ON RES_PLA_HISTORY ( LAST_UPDATE_DATE )
TABLESPACE USERS ;

create sequence RESPLAHIST_SEQ;

create or replace procedure res_pla_history_log (
     ptable_name varchar2
   , poperation  varchar2
   , prow_id     number
   , pres_id     number
   , ppla_id     number
   , paccess_type varchar2
   ) is
begin
    -- disabled by default, see planner_utils.res_pla_history
    -- enable:  update system_parameters set value = '+' where name = 'RES_PLA_HISTORY'; commit;
    -- (applies to new sessions - package state is initialized once per session)
    if nvl(planner_utils.res_pla_history, '-') <> '+' then
      return;
    end if;
    insert into res_pla_history
      (id, table_name, operation, row_id, res_id, pla_id, access_type, os_user, module)
    values
      (resplahist_seq.nextval, ptable_name, poperation, prow_id, pres_id, ppla_id, paccess_type,
       substr(sys_context('USERENV','OS_USER'),1,100), substr(sys_context('USERENV','MODULE'),1,100));
end;
/

create or replace trigger LEC_PLA_HIST_TRG
after insert or delete or update of id, lec_id, pla_id, access_type on LEC_PLA
for each row
begin
  if inserting then
    res_pla_history_log('LEC_PLA', 'I', :new.id, :new.lec_id, :new.pla_id, :new.access_type);
  elsif deleting then
    res_pla_history_log('LEC_PLA', 'D', :old.id, :old.lec_id, :old.pla_id, :old.access_type);
  else
    res_pla_history_log('LEC_PLA', 'U-', :old.id, :old.lec_id, :old.pla_id, :old.access_type);
    res_pla_history_log('LEC_PLA', 'U+', :new.id, :new.lec_id, :new.pla_id, :new.access_type);
  end if;
end;
/

create or replace trigger GRO_PLA_HIST_TRG
after insert or delete or update of id, gro_id, pla_id, access_type on GRO_PLA
for each row
begin
  if inserting then
    res_pla_history_log('GRO_PLA', 'I', :new.id, :new.gro_id, :new.pla_id, :new.access_type);
  elsif deleting then
    res_pla_history_log('GRO_PLA', 'D', :old.id, :old.gro_id, :old.pla_id, :old.access_type);
  else
    res_pla_history_log('GRO_PLA', 'U-', :old.id, :old.gro_id, :old.pla_id, :old.access_type);
    res_pla_history_log('GRO_PLA', 'U+', :new.id, :new.gro_id, :new.pla_id, :new.access_type);
  end if;
end;
/

create or replace trigger ROM_PLA_HIST_TRG
after insert or delete or update of id, rom_id, pla_id, access_type on ROM_PLA
for each row
begin
  if inserting then
    res_pla_history_log('ROM_PLA', 'I', :new.id, :new.rom_id, :new.pla_id, :new.access_type);
  elsif deleting then
    res_pla_history_log('ROM_PLA', 'D', :old.id, :old.rom_id, :old.pla_id, :old.access_type);
  else
    res_pla_history_log('ROM_PLA', 'U-', :old.id, :old.rom_id, :old.pla_id, :old.access_type);
    res_pla_history_log('ROM_PLA', 'U+', :new.id, :new.rom_id, :new.pla_id, :new.access_type);
  end if;
end;
/

create or replace trigger SUB_PLA_HIST_TRG
after insert or delete or update of id, sub_id, pla_id, access_type on SUB_PLA
for each row
begin
  if inserting then
    res_pla_history_log('SUB_PLA', 'I', :new.id, :new.sub_id, :new.pla_id, :new.access_type);
  elsif deleting then
    res_pla_history_log('SUB_PLA', 'D', :old.id, :old.sub_id, :old.pla_id, :old.access_type);
  else
    res_pla_history_log('SUB_PLA', 'U-', :old.id, :old.sub_id, :old.pla_id, :old.access_type);
    res_pla_history_log('SUB_PLA', 'U+', :new.id, :new.sub_id, :new.pla_id, :new.access_type);
  end if;
end;
/

create or replace trigger FOR_PLA_HIST_TRG
after insert or delete or update of id, for_id, pla_id, access_type on FOR_PLA
for each row
begin
  if inserting then
    res_pla_history_log('FOR_PLA', 'I', :new.id, :new.for_id, :new.pla_id, :new.access_type);
  elsif deleting then
    res_pla_history_log('FOR_PLA', 'D', :old.id, :old.for_id, :old.pla_id, :old.access_type);
  else
    res_pla_history_log('FOR_PLA', 'U-', :old.id, :old.for_id, :old.pla_id, :old.access_type);
    res_pla_history_log('FOR_PLA', 'U+', :new.id, :new.for_id, :new.pla_id, :new.access_type);
  end if;
end;
/

create or replace trigger PER_PLA_HIST_TRG
after insert or delete or update of id, per_id, pla_id, access_type on PER_PLA
for each row
begin
  if inserting then
    res_pla_history_log('PER_PLA', 'I', :new.id, :new.per_id, :new.pla_id, :new.access_type);
  elsif deleting then
    res_pla_history_log('PER_PLA', 'D', :old.id, :old.per_id, :old.pla_id, :old.access_type);
  else
    res_pla_history_log('PER_PLA', 'U-', :old.id, :old.per_id, :old.pla_id, :old.access_type);
    res_pla_history_log('PER_PLA', 'U+', :new.id, :new.per_id, :new.pla_id, :new.access_type);
  end if;
end;
/

create or replace trigger ROL_PLA_HIST_TRG
after insert or delete or update of id, rol_id, pla_id, access_type on ROL_PLA
for each row
begin
  if inserting then
    res_pla_history_log('ROL_PLA', 'I', :new.id, :new.rol_id, :new.pla_id, :new.access_type);
  elsif deleting then
    res_pla_history_log('ROL_PLA', 'D', :old.id, :old.rol_id, :old.pla_id, :old.access_type);
  else
    res_pla_history_log('ROL_PLA', 'U-', :old.id, :old.rol_id, :old.pla_id, :old.access_type);
    res_pla_history_log('ROL_PLA', 'U+', :new.id, :new.rol_id, :new.pla_id, :new.access_type);
  end if;
end;
/

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
