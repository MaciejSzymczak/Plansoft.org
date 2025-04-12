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
  <h1>Nie wyslane powiadomienia EMAIL</h1>
  <table>');  
 WriteToClob(res, '<tr><th>Id</th><th>Email</th><th>Tytul</th><th>Imie</th><th>Nazwisko</th><th>Utworzyl</th><th>Komunikat</th></tr>'||chr(13)||chr(10));
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
 WriteToClob(res, '<tr><th>Blokujacy/Oczekujacy</th><th>Kill</th><th>Terminal</th><th>Szczególy</th></tr>'||chr(13)||chr(10));
 for rec in (
    select 
       substr(decode (l.request, 0, 'Blokujacy: ','Oczekujacy: ')||''''||l.sid||','||s.serial#||'''',1,20) sess
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
  <h1>Blokady: Szczegóły</h1>
  <table>');  
 WriteToClob(res, '<tr><th>Blokujący</th><th>Kill</th><th>Zablokowany</th><th>Tabela</th><th>Szczegóły</th></tr>'||chr(13)||chr(10));
 for rec in (
    SELECT
        --s1.osuser           AS blocking_os_user,
        s1.username         AS blocking_user,
        --s1.sid              AS blocking_sid,
        --s1.serial#          AS blocking_serial,
        (SELECT 'ALTER SYSTEM KILL SESSION '''|| s1.SID ||',' ||s1.SERIAL#||'''' FROM SYS.V_$SESSION WHERE SID = s1.SID) KILL_STATEMENT,
        --s2.osuser           AS blocked_os_user,
        s2.username         AS blocked_user,
        --s2.sid              AS blocked_sid,
        --s2.serial#          AS blocked_serial,
        o.object_name,
        --do.object_type,
        --lo.locked_mode,
        --s2.row_wait_obj#    AS wait_obj_id,
        --s2.row_wait_file#   AS wait_file#,
        --s2.row_wait_block#  AS wait_block#,
        --s2.row_wait_row#    AS wait_row#,
        (select 'SELECT rowid, '||o.object_name||'.* FROM '||o.object_name||' WHERE dbms_rowid.rowid_block_number(rowid) = '||s2.row_wait_block#||' AND dbms_rowid.rowid_row_number(rowid) = '||s2.row_wait_row# from dual) table_details
    FROM
        sys.v_locked_object_ext lo
        JOIN all_objects do ON lo.object_id = do.object_id
        JOIN v$session s1 ON lo.session_id = s1.sid
        JOIN v$session s2 ON s1.sid IN (
            SELECT l1.sid
            FROM sys.v_lock_ext l1, sys.v_lock_ext l2
            WHERE l1.block = 1 AND l2.request > 0 AND l1.id1 = l2.id1 AND l1.id2 = l2.id2
        )
        LEFT JOIN all_objects o ON s2.row_wait_obj# = o.object_id
    WHERE
        s1.blocking_session IS NULL
        AND s1.sid != s2.sid
        and o.object_name in (select object_name from all_objects where object_type='TABLE' and owner='PLANNER')
) loop
     WriteToClob(res, '<tr><td>'
     || rec.blocking_user
       || '</td><td>' || rec. KILL_STATEMENT
       || '</td><td>' || rec.blocked_user
       || '</td><td>' || rec. object_name
       || '</td><td>' ||  rec.table_details                                                                                                  
       ||'</td></tr>'||chr(13)||chr(10));
 end loop; 
WriteToClob(res,'
  </table>');  



WriteToClob(res,'
  <h1>Do usuniecia (Utworzone min. piec lat temu i brak zajec od pieciu lat)</h1>
  <table>');  
 WriteToClob(res, '<tr><th>Typ</th><th>Nazwa</th><th>Id</th><th>Utworzyl</th></tr>'||chr(13)||chr(10));
 for rec in (
    select * from (
    select 'WYKLADOWCA' type, id, TITLE||' '||LAST_NAME||' '||FIRST_NAME||'   ('||(SELECT CODE FROM ORG_UNITS WHERE ID = ORGUNI_ID)||')' Name, created_by from lecturers where creation_date < sysdate - 5*365 and COUNT5Y =0
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
  <h1>Zajecia do skasowania / zarchiwizowania</h1>
  <table>');  
 WriteToClob(res, '<tr><th>Liczba zajec</th><th>Rok</th><th>Alert</th></tr>'||chr(13)||chr(10));
 for rec in (
    select count, yyyy, case when to_char(sysdate,'yyyy')- yyyy >5 then '*** Zarchiwizuj lub skasuj te zajecia' else 'W porzadku' end alert from
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
  <h1>Historia zmian</h1>
  <table>');  
 WriteToClob(res, '<tr><th>Liczba zajec</th><th>Operacja wykonana w roku</th><th>Alert</th></tr>'||chr(13)||chr(10));
 for rec in (
    select count, yyyy, case when to_char(sysdate,'yyyy')- yyyy >5 then '*** Zarchiwizuj lub skasuj te zajecia' else 'W porzadku' end alert from
    (
    select count(1) count, to_char(effective_start_date,'yyyy') yyyy from classes_history group by to_char(effective_start_date,'yyyy')
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
  <h1>Ulubione terminy do skasowania / zarchiwizowania</h1>
  <table>');  
 WriteToClob(res, '<tr><th>Liczba rekordów</th><th>Rok</th><th>Alert</th></tr>'||chr(13)||chr(10));
 for rec in (
    select count, yyyy, case when to_char(sysdate,'yyyy')- yyyy >5 then '*** Zarchiwizuj lub skasuj te zajecia' else 'W porzadku' end alert from
    (
    select count(1) count, to_char(day,'yyyy') yyyy from res_hints group by to_char(day,'yyyy')
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
