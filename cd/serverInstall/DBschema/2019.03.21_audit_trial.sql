TRIGGER PLANNER.classes_history_t0
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

TRIGGER PLANNER.classes_history_t0
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

TRIGGER PLANNER.classes_history_t2 after update or insert or delete  
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



Connect sys

create or replace procedure purge_audit_trail (days in number) as
purge_date date;
begin
  purge_date := trunc(sysdate-days);
  delete from aud$ where ntimestamp# < purge_date;
  delete from planner.classes_history where effective_end_date < purge_date and rownum < 10000;
  commit;
end;
/

select * from dba_scheduler_jobs

begin
  dbms_scheduler.create_job(
      job_name => 'AUDIT_PURGE'
     ,job_type => 'PLSQL_BLOCK'
     ,job_action => 'begin purge_audit_trail(31); end;'
     ,repeat_interval => 'freq=daily'
     ,enabled => TRUE
     );
end;

begin dbms_scheduler.drop_job('AUDIT_PURGE'); end;
