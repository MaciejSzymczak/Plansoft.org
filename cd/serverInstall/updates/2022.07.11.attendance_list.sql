alter table attendance_list_helper add ( calc_rooms varchar2(500));

create index attendance_list_helper1 on attendance_list_helper(title);
create index attendance_list_helper2 on attendance_list_helper(first_name);
create index attendance_list_helper3 on attendance_list_helper(last_name);
create index attendance_list_helper4 on attendance_list_helper(subject);
create index attendance_list_helper5 on attendance_list_helper(form);
create index attendance_list_helper6 on attendance_list_helper(calc_rooms);
create index attendance_list_helper7 on attendance_list_helper(day);

create or replace package  attendance_list is  

    /* Attendance_list 
       @author Maciej Szymczak
       @version 2022-07-11       
     */

    procedure prepare (pDayFrom varchar2, pDayTo varchar2);  
    function getList  return clob;  
end;
/
