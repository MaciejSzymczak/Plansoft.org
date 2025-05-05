--move grid up 

begin
for rec in (select trigger_name from all_triggers where owner='PLANNER') loop
execute immediate 'alter trigger '||rec.trigger_name||' disable';
end loop;
end;
/
begin
for n in reverse 1..14 loop
dbms_output.put_line(n);
update grids set no = n+2 where no = n;
update gro_cla set hour = n+2 where hour = n;
update rom_cla set hour = n+2 where hour = n;
update lec_cla set hour = n+2 where hour = n;
update classes set hour = n+2 where hour = n;
update RES_HINTS set hour = n+2 where hour = n;
update RESERVATIONS set hour = n+2 where hour = n;
end loop;
update periods set hours_per_day = hours_per_day +2;
commit;
end;

begin
for rec in (select trigger_name from all_triggers where owner='PLANNER') loop
execute immediate 'alter trigger '||rec.trigger_name||' enable';
end loop;
end;
/

plus add manually records in grid (no 1 and no 2)

declare
 -- All classes 1h later
 pDateFrom Date := date'2014-10-01'; --'2016-01-01'
 pDateTo Date := date'2015-12-31'; --'2021-08-08' 
begin
    for currentHour in REVERSE 1..60
    loop
         dbms_output.put_line(currentHour);
         update classes set hour = currentHour where hour = currentHour-1 and day between pDateFrom and pDateTo;
         update lec_cla set hour = currentHour where hour = currentHour-1 and day between pDateFrom and pDateTo;
         update gro_cla set hour = currentHour where hour = currentHour-1 and day between pDateFrom and pDateTo;
         update rom_cla set hour = currentHour where hour = currentHour-1 and day between pDateFrom and pDateTo;
    end loop;
    commit;
end;

declare
 -- All classes 1h earlier
 pDateFrom Date := date'2019-09-30';
 pDateTo Date := date'2019-11-18'; 
begin
    for currentHour in 1..60
    loop
         dbms_output.put_line(currentHour);
         update classes set hour = currentHour where hour = currentHour+1 and day between pDateFrom and pDateTo;
         update lec_cla set hour = currentHour where hour = currentHour+1 and day between pDateFrom and pDateTo;
         update gro_cla set hour = currentHour where hour = currentHour+1 and day between pDateFrom and pDateTo;
         update rom_cla set hour = currentHour where hour = currentHour+1 and day between pDateFrom and pDateTo;
    end loop;
    commit;
end;
