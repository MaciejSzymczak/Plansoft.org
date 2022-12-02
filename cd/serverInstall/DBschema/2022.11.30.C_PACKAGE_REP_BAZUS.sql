create or replace package  rep_bazus is  
    procedure prepare;  
    function getList  return clob;  
end;
/

create or replace package body rep_bazus is  
     res clob;  

    ------------------------------------------------------------------------------------------------------------------------------------------------------- 
    procedure prepare  is
    begin
        integration.int_from_plansoft('n');
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
  <title>Zajęcia bez planu studiów</title>
</head>
  <body>
');    

    WriteToClob(res,'     
      <br/><br/>Zajęcia bez planu studiów pobranego z systemu Bazus (pusta wartość w polu tt_combinations.integration_id)<br/>
      <table>');
     WriteToClob(res, '<tr><th>Id</th><th>Dzień</th><th>Godz. od</th><th>Godz. do</th><th>Dydaktyk</th><th>Grupa</th><th>Forma</th><th>Przedmiot</th><th>Sala</th></tr>'||chr(13)||chr(10));
     for rec in (
            select Id
                 , to_char(day,'yyyy-mm-dd') day
                 , hour_from
                 , hour_to
                 , ( select Id||' '||title||' '||first_name||' '||last_name||' '||integration_id from lecturers where id in (select lec_id from lec_cla where cla_id = ic.id and rownum =1 )) Lec
                 , ( select Id||' '||name||' '||integration_id from groups where id in (select gro_id from gro_cla where cla_id = ic.id and rownum =1 )) Gro
                 , (select Id||' '||name||' '||integration_id from forms where id = ic.for_id) Frm
                 , (select Id||' '||name||' '||integration_id from subjects where id =ic.sub_id) Sub
                 , ( select Id||' '||Name||' '||attribs_01 from rooms where id in (select rom_id from rom_cla where cla_id = ic.id and rownum =1 )) Rom
            from int_classes ic where tt_comb_cnt =0 order by 2,3,4         
                   ) loop
         WriteToClob(res, '<tr><td>'
           || rec.Id 
           || '</td><td>' || rec.day
           || '</td><td>' || rec.hour_from 
           || '</td><td>' || rec.hour_to 
           || '</td><td>' || rec.Lec 
           || '</td><td>' || rec.Gro 
           || '</td><td>' || rec.Frm 
           || '</td><td>' || rec.Sub 
           || '</td><td>' || rec.Rom 
           ||'</td></tr>'||chr(13)||chr(10));
     end loop;
     WriteToClob(res,'
      </table>');
  
  

    WriteToClob(res,'     
      <br/><br/>Dydaktycy bez integration_id<br/>
      <table>');
     WriteToClob(res, '<tr><th>Id</th><th>Tytul</th><th>Imie</th><th>Nazwisko</th></tr>'||chr(13)||chr(10));
     for rec in (
            select Id, title, first_name, last_name from lecturers where id in (select unique lec_gro_rom_id from int_class_members where cla_id in (select id from int_classes ic where tt_comb_cnt >0) and integration_id is null) order by 1        
                   ) loop
         WriteToClob(res, '<tr><td>'
           || rec.Id 
           || '</td><td>' || rec.title
           || '</td><td>' || rec.first_name 
           || '</td><td>' || rec.last_name 
           ||'</td></tr>'||chr(13)||chr(10));
     end loop;
     WriteToClob(res,'
      </table>');


    WriteToClob(res,'     
      <br/><br/>Grupy bez integration_id<br/>
      <table>');
     WriteToClob(res, '<tr><th>Id</th><th>Nazwa</th></tr>'||chr(13)||chr(10));
     for rec in (
            select Id, name from groups where id in (select unique lec_gro_rom_id from int_class_members where cla_id in (select id from int_classes ic where tt_comb_cnt >0) and integration_id is null) order by 1         
                   ) loop
         WriteToClob(res, '<tr><td>'
           || rec.Id 
           || '</td><td>' || rec.name
           ||'</td></tr>'||chr(13)||chr(10));
     end loop;
     WriteToClob(res,'
      </table>');


    WriteToClob(res,'     
      <br/><br/>Sale bez integration_id<br/>
      <table>');
     WriteToClob(res, '<tr><th>Id</th><th>Nazwa</th></tr>'||chr(13)||chr(10));
     for rec in (
            select Id, Name ||' ' || attribs_01 Name from rooms where id in (select unique lec_gro_rom_id from int_class_members where cla_id in (select id from int_classes ic where tt_comb_cnt >0) and integration_id is null) order by 1         
                   ) loop
         WriteToClob(res, '<tr><td>'
           || rec.Id 
           || '</td><td>' || rec.Name
           ||'</td></tr>'||chr(13)||chr(10));
     end loop;
     WriteToClob(res,'
      </table>');


    WriteToClob(res,'     
      <br/><br/>Przedmioty bez integration_id<br/>
      <table>');
     WriteToClob(res, '<tr><th>Id</th><th>Nazwa</th></tr>'||chr(13)||chr(10));
     for rec in (
            select Id, name from subjects where id in (select unique sub_id from int_classes where tt_comb_cnt >0) and  integration_id is null order by 1       
                   ) loop
         WriteToClob(res, '<tr><td>'
           || rec.Id 
           || '</td><td>' || rec.Name
           ||'</td></tr>'||chr(13)||chr(10));
     end loop;
     WriteToClob(res,'
      </table>');


    WriteToClob(res,'     
      <br/><br/>Formy bez integration_id<br/>
      <table>');
     WriteToClob(res, '<tr><th>Id</th><th>Nazwa</th></tr>'||chr(13)||chr(10));
     for rec in (
            select Id, name from forms where id in (select unique for_id from int_classes where tt_comb_cnt >0) and  integration_id is null order by 1         
                   ) loop
         WriteToClob(res, '<tr><td>'
           || rec.Id 
           || '</td><td>' || rec.Name
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
