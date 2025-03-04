begin
delete from xxmsztools_eventlog where created < sysdate - 90;
delete from classes_history where effective_start_date < sysdate - 90;
commit;
end;


