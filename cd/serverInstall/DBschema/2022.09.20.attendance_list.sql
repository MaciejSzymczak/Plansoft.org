alter table attendance_list_helper add (calc_groups varchar2(500));
commit;

create or replace package body attendance_list is  
     res clob;  

    ------------------------------------------------------------------------------------------------------------------------------------------------------- 
    procedure prepare (pDayFrom varchar2, pDayTo varchar2) is
    begin
            declare
                pDate_from date := to_date(pDayFrom,'yyyy-mm-dd');
                pDate_to date := to_date(pDayTo,'yyyy-mm-dd');
                prior_rec attendance_list_helper%rowtype;
                prior_rec_rowid varchar2(250);
            begin
                execute immediate 'truncate table attendance_list_helper';
                insert into attendance_list_helper (title,first_name,last_name,subject,form,calc_rooms, calc_groups, day,no_from,no_to,sum)
                select 
                     nvl(lec.title,'-') title
                    , nvl(lec.first_name,'-') first_name 
                    , nvl(lec.last_name,'-') last_name 
                    , nvl(sub.name,'-') subject
                    , nvl(frm.name,'-') form
                    , nvl(cla.calc_rooms,'-') calc_rooms
                    , nvl(cla.calc_groups,'-') calc_groups
                    , cla.day day
                    , grids.no no_from
                    , grids.no no_to
                    ,sum(grids.duration * (fill/100)) sum
                from classes cla
                    ,grids
                    ,subjects sub
                    ,forms frm
                    ,lec_cla
                    ,lecturers lec
                where
                     lec_cla.cla_id = cla.id
                     and lec.id = lec_cla.lec_id
                     and lec.id>0
                     and sub.id>0
                     and 0=0
                     and for_id = frm.id
                     and sub.id (+)= sub_id
                     and cla.hour = grids.no
                     and cla.day between pDate_from and pDate_to
                group by cla.day, grids.hour_from, grids.no, title, first_name, last_name, sub.name, frm.name, cla.calc_rooms, cla.calc_groups
                order by 1,2,3,4,5,6,7,8,9,10;
                commit;
                for rec in (
                    select rowid,day, no_from, no_to, title, first_name, last_name, subject, form, calc_rooms, calc_groups, sum 
                      from attendance_list_helper 
                      where (title, first_name, last_name, subject, form, calc_rooms, calc_groups, day) in 
                      (
                          select title, first_name, last_name, subject, form, calc_rooms, calc_groups, day
                            from attendance_list_helper
                            group by title, first_name, last_name, subject, form, calc_rooms, calc_groups, day
                            having count(1)>1  
                      )
                    order by title, first_name, last_name, subject, form, calc_rooms, calc_groups, day, no_from, no_to 
                 ) loop
                     if  rec.day             = prior_rec.day
                         and rec.title       = prior_rec.title
                         and rec.first_name  = prior_rec.first_name
                         and rec.last_name   = prior_rec.last_name
                         and rec.subject     = prior_rec.subject
                         and rec.form        = prior_rec.form
                         and rec.calc_rooms  = prior_rec.calc_rooms                         
                         and rec.calc_groups = prior_rec.calc_groups                         
                         and rec.no_from     = prior_rec.no_to+1
                     then
                         --merge current record into prior record
                         prior_rec.no_to := rec.no_to;
                         update attendance_list_helper set no_to = rec.no_to, sum = sum + rec.sum where rowid = prior_rec_rowid; 
                         delete from attendance_list_helper where rowid = rec.rowid;
                     else
                         prior_rec_rowid       := rec.rowid;
                         prior_rec.day         := rec.day;
                         prior_rec.no_from     := rec.no_from;
                         prior_rec.no_to       := rec.no_to;
                         prior_rec.title       := rec.title;
                         prior_rec.first_name  := rec.first_name;
                         prior_rec.last_name   := rec.last_name;
                         prior_rec.subject     := rec.subject;
                         prior_rec.form        := rec.form;
                         prior_rec.calc_rooms  := rec.calc_rooms;
                         prior_rec.calc_groups := rec.calc_groups;
                     end if;
                 end loop;
                update attendance_list_helper
                  set from_hour = (select substr(hour_from,1,2) from grids where no = no_from)
                     ,from_min  = (select substr(hour_from,4,2) from grids where no = no_from)
                     ,to_hour   = (select substr(hour_to,1,2) from grids where no = no_to)
                     ,to_min    = (select substr(hour_to,4,2) from grids where no = no_to);
                 commit;       
            end;
    end prepare;


    ------------------------------------------------------------------------------------------------------------------------------------------------------- 
    function getList return clob is 

            --------------------------------------------------------------  
            procedure NewClob  (clobloc       in out nocopy clob,  
                                msg_string    in varchar2) is  
             pos integer;  
             amt number;  
            begin  
               dbms_lob.createtemporary(clobloc, TRUE, DBMS_LOB.session);  
               if msg_string is not null then  
                  pos := 1;  
                  amt := length(msg_string);  
                  dbms_lob.write(clobloc,amt,pos,msg_string);  
               end if;  
            end NewClob;  

            --------------------------------------------------------------  
            procedure WriteToClob  ( clob_loc      in out nocopy clob,msg_string    in  varchar2) is  
             pos integer;  
             amt number;  
            begin  
               pos :=   dbms_lob.getlength(clob_loc) +1;  
               amt := length(msg_string);  
               dbms_lob.write(clob_loc,amt,pos,msg_string);  
            end WriteToClob;  

    --------------------------------------------------------------   
    begin

        NewClob(res, '');   
        WriteToClob(res,     
'<!DOCTYPE html>
<html lang="en">
<head>
<style>
table, th, td {
  border: 1px solid black;
  border-collapse: collapse;
}
</style>
<meta charset="utf-8">
  <title>Lista obecności</title>
</head>
  <body>
  <table>
');    

         WriteToClob(res, '<tr><th>Dzień</th><th>Godz. od</th><th>Godz. do</th><th>Tytuł</th><th>Imię</th><th>Nazwisko</th><th>Przedmiot</th><th>Forma</th><th>Sala</th><th>Grupa</th><th>Liczba godzin</th></tr>'||chr(13)||chr(10));
         for rec in (select to_char(day,'yyyy-mm-dd') day, no_from, no_to, title, first_name, last_name, subject, form, calc_rooms, calc_groups, rtrim(to_char(sum, 'FM0.99'), '.')  sum, from_hour,from_min,to_hour,to_min 
                       from attendance_list_helper 
                       order by title, first_name, last_name, subject, form, calc_rooms, calc_groups, day, no_from, no_to ) loop
             WriteToClob(res, '<tr><td>'
               || rec.day 
               || '</td><td>' || rec.from_hour ||':'|| rec.from_min 
               || '</td><td>' || rec.to_hour ||':'|| rec.to_min 
               || '</td><td>' || rec.title 
               || '</td><td>' || rec.first_name 
               || '</td><td>' || rec.last_name 
               || '</td><td>' || rec.subject 
               || '</td><td>' || rec.form 
               || '</td><td>' || rec.calc_rooms 
               || '</td><td>' || rec.calc_groups 
               || '</td><td>' ||  rec.sum  
               ||'</td></tr>'||chr(13)||chr(10));
         end loop;

WriteToClob(res,'
  </table>
  </body>
</html>');  

       return res;  

   end getList;

end;