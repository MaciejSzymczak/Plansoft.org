create or replace package  rep_usos_overlaps is  

    /* rep_usos_overlaps 
       @author Maciej Szymczak
       @version 2026-01-09       
     */

    function errors  return number;  
    function getList  return clob;  
end;
/

create or replace package body rep_usos_overlaps is  
     res clob;  

    ------------------------------------------------------------------------------------------------------------------------------------------------------- 
    function errors  return number is 
     cnt number;
    begin
        select count(1) into cnt
          from sub_pla 
        where sub_id in (
            select sub_id from 
            (
            select sub_id, count(1) from sub_pla 
             where pla_id in (select id from planners where type = 'ROLE' and upper(name) like '%USOS%')
            group by sub_id having  count(1) > 1
            )
        ) 
        and pla_id in (select id from planners where type = 'ROLE' and upper(name) like '%USOS%')
        and rownum =1;         
       return cnt;         
    end;


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
  <title>Autoryzacje USOS, które mają przydzielone te same przedmioty</title>
</head>
  <body>
  <br/>
  Autoryzacje USOS nie mogą współdzielić przedmiotów z innymi autoryzacjami USOS, w przeciwnym razie ryzykujemy wielokrotne przesłanie do USOS tych samych danych.<br/>
  <br/>
  <table>
');    

         WriteToClob(res, '<tr><th>Przedmiot</th><thAutoryzacja</th></tr>'||chr(13)||chr(10));
         for rec in (

                select
                (select name from subjects where id = sub_id) Sub
                ,(select name from planners where id = pla_id)  Pla
                  from sub_pla 
                where sub_id in (
                    select sub_id from 
                    (
                    select sub_id, count(1) from sub_pla 
                     where pla_id in (select id from planners where type = 'ROLE' and upper(name) like '%USOS%')
                    group by sub_id having  count(1) > 1
                    )
                ) 
                and pla_id in (select id from planners where type = 'ROLE' and upper(name) like '%USOS%')
                order by 1,2         
         
         ) loop
             WriteToClob(res, '<tr><td>'
               || rec.sub 
               || '</td><td>' || rec.pla
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
