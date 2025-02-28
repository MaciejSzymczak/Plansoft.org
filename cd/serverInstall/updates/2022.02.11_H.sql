  CREATE TABLE attendance_list_helper 
   (	"TITLE" VARCHAR2(30 BYTE), 
	"FIRST_NAME" VARCHAR2(30 BYTE), 
	"LAST_NAME" VARCHAR2(30 BYTE), 
	"SUBJECT" VARCHAR2(200 BYTE), 
	"FORM" VARCHAR2(30 BYTE), 
	"DAY" DATE, 
	"NO_FROM" NUMBER, 
	"NO_TO" NUMBER, 
	"SUM" NUMBER,
  from_hour varchar2(5)
,from_min  varchar2(5)
,to_hour   varchar2(5)
,to_min    varchar2(5)
   ) 
  TABLESPACE "USERS" ;

  create or replace package  attendance_list is  
    procedure prepare (pDayFrom varchar2, pDayTo varchar2);  
    function getList  return clob;  
end;
/

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
                delete from attendance_list_helper;
                insert into attendance_list_helper (title,first_name,last_name,subject,form,day,no_from,no_to,sum)
                select 
                     nvl(lec.title,'-') title
                    ,lec.first_name 
                    ,lec.last_name 
                    ,sub.name subject
                    ,frm.name form
                    ,cla.day day
                    ,grids.no no_from
                    ,grids.no no_to
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
                group by cla.day,grids.hour_from,grids.no,title,first_name,last_name,sub.name,frm.name
                order by 1,2,3,4,5,6,7,8;
                commit;
                for rec in (
                    select rowid,day, no_from, no_to, title, first_name, last_name, subject, form,  sum 
                      from attendance_list_helper 
                      where (title, first_name, last_name, subject, form, day) in 
                      (
                          select title, first_name, last_name, subject, form, day
                            from attendance_list_helper
                            group by title, first_name, last_name, subject, form, day
                            having count(1)>1  
                      )
                    order by title, first_name, last_name, subject, form, day, no_from, no_to 
                 ) loop
                     if  rec.day        = prior_rec.day
                         and rec.title      = prior_rec.title
                         and rec.first_name = prior_rec.first_name
                         and rec.last_name  = prior_rec.last_name
                         and rec.subject    = prior_rec.subject
                         and rec.form       = prior_rec.form
                         and rec.no_from = prior_rec.no_to+1
                     then
                         --merge current record into prior record
                         prior_rec.no_to := rec.no_to;
                         update attendance_list_helper set no_to = rec.no_to, sum = sum + rec.sum where rowid = prior_rec_rowid; 
                         delete from attendance_list_helper where rowid = rec.rowid;
                     else
                         prior_rec_rowid  := rec.rowid;
                         prior_rec.day        := rec.day;
                         prior_rec.no_from    := rec.no_from;
                         prior_rec.no_to   := rec.no_to;
                         prior_rec.title      := rec.title;
                         prior_rec.first_name := rec.first_name;
                         prior_rec.last_name  := rec.last_name;
                         prior_rec.subject    := rec.subject;
                         prior_rec.form       := rec.form;
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

         WriteToClob(res, '<tr><th>Dzień</th><th>Godz. od</th><th>Godz. do</th><th>Tytuł</th><th>Imię</th><th>Nazwisko</th><th>Przedmiot</th><th>Forma</th><th>Liczba godzin</th></tr>'||chr(13)||chr(10));
         for rec in (select to_char(day,'yyyy-mm-dd') day, no_from, no_to, title, first_name, last_name, subject, form,  rtrim(to_char(sum, 'FM0.99'), '.')  sum, from_hour,from_min,to_hour,to_min 
                       from attendance_list_helper 
                       order by title, first_name, last_name, subject, form, day, no_from, no_to ) loop
             WriteToClob(res, '<tr><td>'
               || rec.day 
               || '</td><td>' || rec.from_hour ||':'|| rec.from_min 
               || '</td><td>' || rec.to_hour ||':'|| rec.to_min 
               || '</td><td>' || rec.title 
               || '</td><td>' || rec.first_name 
               || '</td><td>' || rec.last_name 
               || '</td><td>' || rec.subject 
               || '</td><td>' || rec.form 
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
/
