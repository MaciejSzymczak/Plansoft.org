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
