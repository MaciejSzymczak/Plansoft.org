--select * from system_parameters where name like 'VERSION%' order by name desc
INSERT INTO system_parameters (name,value) VALUES ('VERSION 2025.09.24', 'INSTALLED');
commit;

alter table TT_INTERFACE modify (lec_integration_id varchar2(200));
alter table TT_INTERFACE modify (sub_integration_id varchar2(200));
alter table TT_INTERFACE modify (for_integration_id varchar2(200));
alter table TT_INTERFACE modify (gro_integration_id varchar2(200));
alter table TT_INTERFACE modify (per_integration_id varchar2(200));
alter table TT_INTERFACE add message varchar2(500);

create sequence classes_history_seq;
create unique index classes_history_I1 on classes_history (attribn_01);

create or replace TRIGGER PLANNER.classes_history_t2 after update or insert or delete  
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
     select classes_history_seq.nextval into rec.attribn_01 from dual;
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
