--select * from system_parameters where name like 'VERSION%' order by name desc
INSERT INTO system_parameters (name,value) VALUES ('VERSION 2025.10.06', 'INSTALLED');
commit;

CREATE TABLE PER_PLA  
(	 ID  NUMBER, 
 PER_ID  NUMBER NOT NULL , 
 PLA_ID  NUMBER NOT NULL , 
 CREATION_DATE  DATE DEFAULT sysdate NOT NULL , 
 CREATED_BY  VARCHAR2(30 BYTE) DEFAULT user NOT NULL , 
 LAST_UPDATE_DATE  DATE DEFAULT sysdate NOT NULL , 
 LAST_UPDATED_BY  VARCHAR2(30 BYTE) DEFAULT user NOT NULL , 
 CONSTRAINT  PERPLA_PER_FK  FOREIGN KEY ( PER_ID )
  REFERENCES  PERIODS  ( ID ) ON DELETE CASCADE, 
 CONSTRAINT  PERPLA_PLA_FK  FOREIGN KEY ( PLA_ID )
  REFERENCES  PLANNERS  ( ID ) ON DELETE CASCADE 
) TABLESPACE  USERS  ;

CREATE UNIQUE INDEX  PERPLA_PK  ON  PER_PLA  ( ID ) 
TABLESPACE  USERS  ;

ALTER TABLE  PER_PLA  ADD CONSTRAINT  PERPLA_PK  PRIMARY KEY ( ID ) USING INDEX  PERPLA_PK;

CREATE INDEX  PERPLA_PLA_FK_I  ON  PER_PLA  ( PLA_ID ) 
TABLESPACE  USERS  ;

CREATE INDEX  PERPLA_PER_FK_I  ON  PER_PLA  ( PER_ID ) 
TABLESPACE  USERS  ;

CREATE UNIQUE INDEX  PER_PLA_UK  ON  PER_PLA  ( PLA_ID ,  PER_ID ) 
TABLESPACE  USERS  ;

create sequence perPLA_SEQ;

delete from per_pla;
insert into per_pla (id, per_id, pla_id)
select perPLA_SEQ.nextval, periods.id, planners.id
from planners, periods;

commit;

create or replace procedure copy_permissions( 
     pfrom_pla_id number 
   , pto_pla_id number 
   , plec char 
   , pgro char 
   , prom char 
   , prol char 
   , psub char 
   , pfor char 
   , pper char 
   , pclasses char 
   ) is 
begin 
    if plec='Y' then 
        delete from lec_pla where pla_id = pto_pla_id; 
        insert into lec_pla (id, lec_id, pla_id) 
        select lecpla_seq.nextval, lec_id, pto_pla_id from lec_pla where pla_id = pfrom_pla_id; 
    end if; 
    --- 
    if pgro='Y' then 
        delete from gro_pla where pla_id = pto_pla_id; 
        insert into gro_pla (id, gro_id, pla_id) 
        select gropla_seq.nextval, gro_id, pto_pla_id from gro_pla where pla_id = pfrom_pla_id; 
    end if; 
    --- 
    if prom='Y' then 
        delete from rom_pla where pla_id = pto_pla_id; 
        insert into rom_pla (id, rom_id, pla_id) 
        select rompla_seq.nextval, rom_id, pto_pla_id from rom_pla where pla_id = pfrom_pla_id; 
    end if; 
    --- 
    if prol='Y' then 
        delete from rol_pla where pla_id = pto_pla_id; 
        insert into rol_pla (id, rol_id, pla_id) 
        select rolpla_seq.nextval, rol_id, pto_pla_id from rol_pla where pla_id = pfrom_pla_id; 
    end if; 
    --- 
    if psub='Y' then 
        delete from sub_pla where pla_id = pto_pla_id; 
        insert into sub_pla (id, sub_id, pla_id) 
        select subpla_seq.nextval, sub_id, pto_pla_id from sub_pla where pla_id = pfrom_pla_id; 
    end if; 
    --- 
    if pfor='Y' then 
        delete from for_pla where pla_id = pto_pla_id; 
        insert into for_pla (id, for_id, pla_id) 
        select forpla_seq.nextval, for_id, pto_pla_id from for_pla where pla_id = pfrom_pla_id; 
    end if; 
    --- 
    if pper='Y' then 
        delete from per_pla where pla_id = pto_pla_id; 
        insert into per_pla (id, per_id, pla_id) 
        select perpla_seq.nextval, per_id, pto_pla_id from per_pla where pla_id = pfrom_pla_id; 
    end if; 
    --- 
    if pclasses='Y' then 
        declare 
           pfrom_pla_dsp varchar2(255); 
           pto_pla_dsp varchar2(255); 
        begin 
            select name into pfrom_pla_dsp from planners where id = pfrom_pla_id; 
            select name into pto_pla_dsp from planners where id = pto_pla_id; 
            update classes set owner=pto_pla_dsp  where owner=pfrom_pla_dsp; 
        end; 
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