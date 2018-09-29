CREATE TABLE TMP_CHUNKEDCLOB
(
  ID     NUMBER,
  VALUE  VARCHAR2(4000 BYTE)
);
CREATE PUBLIC SYNONYM TMP_CHUNKEDCLOB FOR TMP_CHUNKEDCLOB;
ALTER TABLE TMP_CHUNKEDCLOB ADD (PRIMARY KEY (ID));


CREATE OR REPLACE package google_orgchart is  
    procedure getOrgChart(
         pinclude_lec char
       , pinclude_sub char
       , pinclude_gro char
       , pinclude_rom char
       , ppla_id      varchar2  
       , pentire_db   varchar2       
       , pstruct_code varchar2   
    );  
end;
/

CREATE OR REPLACE package body google_orgchart is  
    
    --@Author: Maciej Szymczak
    --@Created:2015.04.02
    
    res clob;  
       
    --------------------------------------------------------------  
    procedure getOrgChart(
         pinclude_lec char
       , pinclude_sub char
       , pinclude_gro char
       , pinclude_rom char
       , ppla_id      varchar2  
       , pentire_db   varchar2     
       , pstruct_code varchar2    
    )   is  
     counter number := 0;  

  
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
            procedure ChunkClob  ( res clob) is
             i number := 0;
             maxLen number := dbms_lob.getlength(res);
             howManyBytes number;
             chunkSize number := 3000;
            begin
              loop
                howManyBytes := dbms_lob.getlength(res)-i+1;
                if howManyBytes > chunkSize then howManyBytes := chunkSize; end if;
                exit when howManyBytes<=0;
                insert into tmp_chunkedclob (id, value) values (main_seq.nextval, dbms_lob.substr( res, chunkSize, 1+i ) );
                i := i + chunkSize;
              end loop;
            end ChunkClob;   
  
    --------------------------------------------------------------   
    begin --getMap 
    
    
        NewClob(res, '');   
        WriteToClob(res,'
<html>
  <head>
    <meta http-equiv="content-type" content="text/html; charset=windows-1250"/>
    <title>
      Plansoft.org - Struktura organizacyjna
    </title>  
    <script type="text/javascript" src="https://www.google.com/jsapi"></script>
    <script type="text/javascript">
      google.load("visualization", "1", {packages:["orgchart"]});
      google.setOnLoadCallback(drawChart);
      function drawChart() {
        var data = new google.visualization.DataTable();
        data.addColumn("string", "Name");
        data.addColumn("string", "Manager");
        data.addColumn("string", "ToolTip");

        data.addRows([
');
        
        -------------------------------------------------------------- 
        declare
          comma varchar2(1) := '';
        begin
          for rec in (
                select id, name, parent_id from org_units 
                where struct_code like pstruct_code||'%'  order by id      
          ) loop
              declare
                -- top organization has no parent organization
                -- top org is when we are the first time in the loop, which means comma is null
                parentOrg number;
              begin
              if comma is null then
                parentOrg := '';
              else
                parentOrg := rec.parent_id;
              end if;
                  WriteToClob(res,comma||'[{v:"'||rec.id||'", f:'''||rec.name||'<div style="color:red; font-style:italic">Jednostka</div>''}, '''||parentOrg||''', ''Jednostka'']
    ');  
              end;
              comma:=',';
              
              declare
                first_entry boolean := true;
              begin
                if pinclude_lec in ('Y') then
                  for recl in (
                        select id, title, last_name, first_name 
                          from lecturers 
                         where orguni_id = rec.id
                          and (pentire_db='Y'
                            or id in (select lec_id from lec_pla where pla_id = ppla_id)) 
                         order by title, last_name, first_name     
                  ) loop
                      if first_entry then
                          WriteToClob(res,comma||'[{v:"LECTURERS'||rec.id||'", f:''Wyk³adowcy''}, '''||rec.id||''', ''Wyk³adowcy'']
    ');  
                          first_entry := false;
                      end if;
                      WriteToClob(res,comma||'[{v:"'||recl.id||'", f:'''||recl.title||' '||recl.last_name||' '||recl.first_name||'<div style="color:red; font-style:italic">Wyk³adowca</div>''}, ''LECTURERS'||rec.id||''', ''Wyk³adowca'']
    ');  
                  end loop;
                end if;  
                if pinclude_lec in ('C') then
                  for recl in (
                        select id, title, last_name, first_name from lecturers  
                         where orguni_id = rec.id
                          and (pentire_db='Y'
                            or id in (select lec_id from lec_pla where pla_id = ppla_id)) 
                        order by title, last_name, first_name     
                  ) loop
                      if first_entry then
                          WriteToClob(res,comma||'[{v:"LECTURERS'||rec.id||'", f:''Wyk³adowcy');  
                          first_entry := false;
                      end if;
                      WriteToClob(res,'<div style="color:red; font-style:italic">'||recl.title||' '||recl.last_name||' '||recl.first_name||'</div>');  
                  end loop;
                  if first_entry = false then
                          WriteToClob(res,'''}, '''||rec.id||''', ''Wyk³adowcy'']
    ');  
                  end if;
                end if;  
              end;
              
              declare
                first_entry boolean := true;
              begin
                if pinclude_sub in ('Y') then
                  for recs in (
                        select id, name from subjects
                         where orguni_id = rec.id
                          and (pentire_db='Y'
                            or id in (select sub_id from sub_pla where pla_id = ppla_id)) 
                          order by name      
                  ) loop
                      if first_entry then
                          WriteToClob(res,comma||'[{v:"SUBJECTS'||rec.id||'", f:''Przedmioty''}, '''||rec.id||''', ''Przedmioty'']
    ');  
                          first_entry := false;
                      end if;
                      WriteToClob(res,comma||'[{v:"'||recs.id||'", f:'''||recs.name||'<div style="color:green; font-style:italic">Przedmiot</div>''}, ''SUBJECTS'||rec.id||''', ''Przedmiot'']
    ');  
                  end loop;
                end if;  
                if pinclude_sub in ('C') then
                  for recs in (
                        select id, name from subjects  
                         where orguni_id = rec.id
                          and (pentire_db='Y'
                            or id in (select sub_id from sub_pla where pla_id = ppla_id)) 
                        order by name      
                  ) loop
                      if first_entry then
                          WriteToClob(res,comma||'[{v:"SUBJECTS'||rec.id||'", f:''Przedmioty');  
                          first_entry := false;
                      end if;
                      WriteToClob(res,'<div style="color:green; font-style:italic">'||recs.name||'</div>');  
                  end loop;
                  if first_entry = false then
                          WriteToClob(res,'''}, '''||rec.id||''', ''Przedmioty'']
    ');  
                  end if;
                end if;  
              end;
              
              declare
                first_entry boolean := true;
              begin
                if pinclude_gro in ('Y') then
                  for recg in (
                        select id, name from groups  
                         where orguni_id = rec.id
                          and (pentire_db='Y'
                            or id in (select gro_id from gro_pla where pla_id = ppla_id)) 
                        order by name      
                  ) loop
                      if first_entry then
                          WriteToClob(res,comma||'[{v:"GROUPS'||rec.id||'", f:''Grupy''}, '''||rec.id||''', ''Grupy'']
    ');  
                          first_entry := false;
                      end if;
                      WriteToClob(res,comma||'[{v:"'||recg.id||'", f:'''||recg.name||'<div style="color:blue; font-style:italic">Grupa</div>''}, ''GROUPS'||rec.id||''', ''Grupa'']
    ');  
                  end loop;
                end if;  
                if pinclude_gro in ('C') then
                  for recg in (
                        select id, name from groups  
                         where orguni_id = rec.id
                          and (pentire_db='Y'
                            or id in (select gro_id from gro_pla where pla_id = ppla_id)) 
                        order by name      
                  ) loop
                      if first_entry then
                          WriteToClob(res,comma||'[{v:"GROUPS'||rec.id||'", f:''Grupy');  
                          first_entry := false;
                      end if;
                      WriteToClob(res,'<div style="color:blue; font-style:italic">'||recg.name||'</div>');  
                  end loop;
                  if first_entry = false then
                          WriteToClob(res,'''}, '''||rec.id||''', ''Grupy'']
    ');  
                  end if;
                end if;  
              end;
              
              declare
                first_entry boolean := true;
              begin
                if pinclude_rom in ('Y') then
                  for recr in (
                        select id, name from rooms  
                         where orguni_id = rec.id
                          and (pentire_db='Y'
                            or id in (select rom_id from rom_pla where pla_id = ppla_id)) 
                        order by name      
                  ) loop
                      if first_entry then
                          WriteToClob(res,comma||'[{v:"ROOMS'||rec.id||'", f:''Zasoby''}, '''||rec.id||''', ''Zasoby'']
    ');  
                          first_entry := false;
                      end if;
                      WriteToClob(res,comma||'[{v:"'||recr.id||'", f:'''||recr.name||'<div style="color:red; font-style:italic">Zasób</div>''}, ''ROOMS'||rec.id||''', ''Zasób'']
    ');  
                  end loop;
                end if;  
                if pinclude_rom in ('C') then
                  for recr in (
                        select id, name from rooms  
                         where orguni_id = rec.id
                          and (pentire_db='Y'
                            or id in (select rom_id from rom_pla where pla_id = ppla_id)) 
                        order by name      
                  ) loop
                      if first_entry then
                          WriteToClob(res,comma||'[{v:"ROOMS'||rec.id||'", f:''Zasoby');  
                          first_entry := false;
                      end if;
                      WriteToClob(res,'<div style="color:red; font-style:italic">'||recr.name||'</div>');  
                  end loop;
                  if first_entry = false then
                          WriteToClob(res,'''}, '''||rec.id||''', ''Zasoby'']
    ');  
                  end if;
                end if;  
              end;
              
          end loop;
        end;
        -------------------------------------------------------------- 
                
    WriteToClob(res,' 
        ]);       
        var chart = new google.visualization.OrgChart(document.getElementById("chart_div"));
        chart.draw(data, {allowHtml:true,allowCollapse:true});
      }
   </script>
   <style type="text/css">
       .google-visualization-orgchart-node {
           width: 240px;
       }
       .google-visualization-orgchart-node-medium {
           vertical-align: top;
       }
   </style>  
    </head>
  <body>
    <div id="chart_div"></div>
  </body>
</html>');

--declare
-- x clob;
--begin
-- newClob(x,'');
-- writeToClob(x,'Test123456789MaciejSzymczakPolska;');
-- ChunkClob(x);
--end;

    ChunkClob(res);
    --return res;  
    end getOrgChart;  
end;
/
