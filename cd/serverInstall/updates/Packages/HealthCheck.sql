create or replace package  HealthCheck is  

    /* Attendance_list 
       @author Maciej Szymczak
       @version 2023-12-15       
     */

    function getList  return clob;  
end;
/

create or replace package body HealthCheck is  
     res clob;  
     
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
  <title>Raport: Zdrowie Systemu</title>
</head>
  <body>
');    

WriteToClob(res,'
  <h1>Nie wysłane powiadomienia EMAIL</h1>
  <table>');  
 WriteToClob(res, '<tr><th>Id</th><th>Email</th><th>Tytuł</th><th>Imię</th><th>Nazwisko</th><th>Utworzył</th><th>Komunikat</th></tr>'||chr(13)||chr(10));
 for rec in (
     select id, email, title, first_name, last_name, created_by, diff_message 
       from lecturers 
       where diff_message like '***%' 
       order by created_by, last_name         
 ) loop
     WriteToClob(res, '<tr><td>'
       || rec.id 
       || '</td><td>' || rec.email 
       || '</td><td>' || rec.title
       || '</td><td>' || rec.first_name 
       || '</td><td>' || rec.last_name 
       || '</td><td>' || rec.created_by 
       || '</td><td>' || rec.diff_message 
       ||'</td></tr>'||chr(13)||chr(10));
 end loop;
WriteToClob(res,'
  </table>');  

WriteToClob(res,'
  <h1>Blokady</h1>
  <table>');  
 WriteToClob(res, '<tr><th>Blokujący/Oczekujący</th><th>Kill</th><th>Terminal</th><th>Szczególy</th></tr>'||chr(13)||chr(10));
 for rec in (
    select 
       substr(decode (l.request, 0, 'Blokujący: ','Oczekujący: ')||''''||l.sid||','||s.serial#||'''',1,20) sess
       , (SELECT 'ALTER SYSTEM KILL SESSION '''|| SID ||',' ||SERIAL#||'''' FROM SYS.V_$SESSION WHERE SID = L.SID) KILL_STATEMENT
       , terminal
       , program         
       , module                                                                                                  
       , l.id1                                                                                                               
       , l.id2                                                                                                               
       , l.lmode                                                                                                             
       , l.request                                                                                                           
       , l.type                                                                                                              
       , l.inst_id
    from gv$lock l                                                                                                        
       , v$session s                                                                                                         
    where l.sid = s.sid (+)                                                                                               
       and (l.id1, l.id2, l.type) in                                                                                         
       ( select id1                                                                                                          
         , id2                                                                                                               
         , type                                                                                                              
         from gv$lock                                                                                                        
         where request>0                                                                                                     
       )                                                                                                                     
    order by l.id1, l.inst_id,  l.request 
 ) loop
     WriteToClob(res, '<tr><td>'
     || rec.sess
       || '</td><td>' || rec. KILL_STATEMENT
       || '</td><td>' || rec.terminal
       || '</td><td>' || rec. program
       || '</td><td>' ||  rec.module                                                                                                  
                || ' ' || rec.id1                                                                                                               
                || ' ' || rec.id2                                                                                                               
                || ' ' || rec.lmode                                                                                                             
                || ' ' || rec.request                                                                                                           
                || ' ' || rec.type                                                                                                              
                || ' ' || rec.inst_id
       ||'</td></tr>'||chr(13)||chr(10));
 end loop;
WriteToClob(res,'
  </table>');  


WriteToClob(res,'
  <h1>Do usunięcia (Utworzone min. pięć lat temu i brak zajęć od pięciu lat)</h1>
  <table>');  
 WriteToClob(res, '<tr><th>Typ</th><th>Nazwa</th><th>Id</th><th>Utworzył</th></tr>'||chr(13)||chr(10));
 for rec in (
    select * from (
    select 'WYKŁADOWCA' type, id, TITLE||' '||LAST_NAME||' '||FIRST_NAME||'   ('||(SELECT CODE FROM ORG_UNITS WHERE ID = ORGUNI_ID)||')' Name, created_by from lecturers where creation_date < sysdate - 5*365 and COUNT5Y =0
    union all
    select 'GRUPA',id, nvl(abbreviation,name), created_by from groups where creation_date < sysdate - 5*365  and COUNT5Y =0
    union all
    select 'SALA', id, name || ' ' || substr(attribs_01,1,55), created_by from rooms where creation_date < sysdate - 5*365 and COUNT5Y =0
    union all
    select 'FORMA' Typ, id, name, created_by  from forms where creation_date < sysdate - 5*365  and COUNT5Y =0
    union all
    select 'PRZEDMIOT' Typ, id, name, created_by  from subjects where creation_date < sysdate - 5*365  and COUNT5Y =0
    union all
    select 'PLANISTA' Typ, id, name, created_by  from planners where type='USER' and creation_date < sysdate - 5*365  and COUNT5Y =0
    ) 
    where id >0
    order by type, created_by, Name
 ) loop
     WriteToClob(res, '<tr><td>'|| rec.type
       || '</td><td>' || rec.Name
       || '</td><td>' || rec.Id
       || '</td><td>' || rec.created_by
       ||'</td></tr>'||chr(13)||chr(10));
 end loop;
WriteToClob(res,'
  </table>');  


WriteToClob(res,'
  <h1>Zajęcia do skasowania / zarchiwizowania</h1>
  <table>');  
 WriteToClob(res, '<tr><th>Liczba zajęć</th><th>Rok</th><th>Alert</th></tr>'||chr(13)||chr(10));
 for rec in (
    select count, yyyy, case when to_char(sysdate,'yyyy')- yyyy >5 then '*** Zarchiwizuj lub skasuj te zajęcia' else 'W porządku' end alert from
    (
    select count(1) count, to_char(day,'yyyy') yyyy from classes group by to_char(day,'yyyy')
    )
    order by yyyy
 ) loop
     WriteToClob(res, '<tr>'
       || '<td>' || rec.count
       || '</td><td>' || rec.yyyy
       || '</td><td>' || rec.alert
       ||'</td></tr>'||chr(13)||chr(10));
 end loop;
WriteToClob(res,'
  </table>');  

WriteToClob(res,'
  </body>
</html>');  

       return res;  

   end getList;

end;
/