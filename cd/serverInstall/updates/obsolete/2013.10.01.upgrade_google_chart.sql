CREATE OR REPLACE package google_chart is  
    function getChart (  
                      kpis varchar2  
                    , top_values number  
                    , pperiod_type varchar2  
                    , pperiod_count number  
                    , pas_of_date date  
                    , pla_id varchar2  
                    , entire_db varchar2  
                    , row_number_rank varchar2 
                    , pie_or_column varchar2 
                    , graph_width varchar2 
                    , graph_height varchar2  
                    , matrix_or_column varchar2  
                    ) return clob;  
end;
/

CREATE OR REPLACE package body google_chart is  
     res clob;  
  
----------------------------------------------------------------------------------------------------------------- 
--Wyk³adowcy=L  
     sql_l varchar2(4000) := '
select (select title||'' ''||first_name||'' ''||last_name  from lecturers where id = lec_id) lab, cnt val from
(
select lec_id
     , %function() over ( partition by null order by cnt desc) afunction
     , cnt
from (
    select lec_id, count(*) cnt
      from classes
         , lec_cla
      where classes.id = lec_cla.cla_id
         and %access_where
         and %time_limitation
   group by lec_id
)
) where afunction <= %top_values
';  
  
----------------------------------------------------------------------------------------------------------------- 
--Grupy=G  
     sql_g varchar2(4000) := '
select (select nvl(name,abbreviation) from groups where id = gro_id) lab, cnt val from
(
select gro_id
     , %function() over ( partition by null order by cnt desc) afunction
     , cnt
from (
    select gro_id, count(*) cnt
      from classes
         , gro_cla
      where classes.id = gro_cla.cla_id
         and %access_where
         and %time_limitation
   group by gro_id
)
) where afunction <= %top_values
';  
  
----------------------------------------------------------------------------------------------------------------- 
--Zasoby=R  
     sql_r varchar2(4000) := '
select (select attribs_01||'' ''||name from rooms where id = rom_id) lab, cnt val from
(
select rom_id
     , %function() over ( partition by null order by cnt desc) afunction
     , cnt
from (
    select rom_id, count(*) cnt
      from classes
         , rom_cla
      where classes.id = rom_cla.cla_id
         and %access_where
         and %time_limitation
   group by rom_id
)
) where afunction <= %top_values
';  
  
----------------------------------------------------------------------------------------------------------------- 
--Przedmioty=S  
     sql_s varchar2(4000) := '
select (select name from subjects where id = sub_id) lab, cnt val from
(
select sub_id
     , %function() over ( partition by null order by cnt desc) afunction
     , cnt
from (
    select sub_id, count(*) cnt
      from classes
      where %access_where
        and %time_limitation
   group by sub_id
)
) where afunction <= %top_values
';  
  
----------------------------------------------------------------------------------------------------------------- 
--Formy zajeæ=F  
     sql_f varchar2(4000) := '
select (select name from forms where id = for_id) lab, cnt val from
(
select for_id
     , %function() over ( partition by null order by cnt desc) afunction
     , cnt
from (
    select for_id, count(*) cnt
      from classes
      where %access_where
        and %time_limitation
   group by for_id
)
) where afunction <= %top_values
';  
  
----------------------------------------------------------------------------------------------------------------- 
--Planiœci=P  
     sql_p varchar2(4000) := '
select created_by, cnt from
(
select created_by
     , %function() over ( partition by null order by cnt desc) afunction
     , cnt
from (
    select created_by, count(*) cnt
      from classes
      where %access_where
        and %time_limitation
   group by created_by
)
) where afunction <= %top_values
';  
  
----------------------------------------------------------------------------------------------------------------- 
--Przedmioty + formy zajeæ=M  
     sql_m varchar2(4000) := '
select (select name from subjects where id = sub_id)||'', ''||(select name from forms where id = for_id) lab, cnt from
(
select sub_id,for_id
     , %function() over ( partition by null order by cnt desc) afunction
     , cnt
from (
    select sub_id,for_id, count(*) cnt
      from classes
      where %access_where
        and %time_limitation
   group by sub_id,for_id
)
) where afunction <= %top_values
';  
  
    ------------------------------------------------------------------------------------------------------------------------------------------------------- 
    procedure wlog ( pmessage varchar2, pparameters clob) is 
    pragma autonomous_transaction; 
    begin 
     insert into tt_log (id, message, parameters) values (tt_seq.nextval, pmessage, pparameters);  
     commit; 
    end wlog; 
 
    ------------------------------------------------------------------------------------------------------------------------------------------------------- 
    procedure clear_log is 
    pragma autonomous_transaction; 
    begin 
     delete from tt_log where message in ('GOOGLE_CHART:L','GOOGLE_CHART:G','GOOGLE_CHART:R','GOOGLE_CHART:S','GOOGLE_CHART:F','GOOGLE_CHART:M','GOOGLE_CHART:P'); 
     commit; 
    end clear_log; 
     
    --------------------------------------------------------------  
    function getChart (  
                      kpis varchar2  
                    , top_values number  
                    , pperiod_type varchar2  
                    , pperiod_count number  
                    , pas_of_date date  
                    , pla_id varchar2  
                    , entire_db varchar2  
                    , row_number_rank varchar2 
                    , pie_or_column varchar2  
                    , graph_width varchar2 
                    , graph_height varchar2 
                    , matrix_or_column varchar2  
    ) return clob is  
     t   integer;  
     r   integer;  
     counter number := 0;  
     row_nums number := length(kpis);  
  
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
            procedure insert_pie_or_column_chart( 
                pie_or_column varchar2 
              , graph_width number 
              , graph_height number  
              , pname varchar2 
              , ptitle varchar2 
              , psql varchar2  
            ) is  
              type genericcurtyp is ref cursor;  
              cur genericcurtyp;  
              lab varchar2(255);  
              val number;  
            begin  
                WriteToClob(res,'
            <script type="text/javascript">
              function drawVisualization1() {
                // Create and populate the data table.
                var data = google.visualization.arrayToDataTable([
                  [''Lab'', ''Liczba'']');  
              open cur for psql;  
              loop  
                 fetch cur  
                  into lab, val;  
                 exit when cur%notfound;  
                WriteToClob(res,'
                  ,['''||lab||''', '||val||']');  
              end loop;  
              close cur;  
                WriteToClob(res,'
                ]);
                new google.visualization.'||pie_or_column||'Chart(document.getElementById(''visualization'||pname||''')).
                    draw(data, {title:"'||ptitle||'", width:'||graph_width||', height:'||graph_height||'});
              }
              google.setOnLoadCallback(drawVisualization1);
            </script>');    
            end insert_pie_or_column_chart;    
               
            --------------------------------------------------------------  
            procedure insert_column_chart( pname varchar2, ptitle varchar2, psql varchar2 ) is  
              type genericcurtyp is ref cursor;  
              cur genericcurtyp;  
              lab varchar2(255);  
              val number;  
            begin  
                WriteToClob(res,'
            <script type="text/javascript">
              function drawVisualization1() {
                // Create and populate the data table.
                var data = google.visualization.arrayToDataTable([[''''');  
              open cur for psql;  
              loop  
                 fetch cur  
                  into lab, val;  
                 exit when cur%notfound;  
                WriteToClob(res,'
                  ,'''||lab||'''');  
              end loop;  
                WriteToClob(res,'],[''''');  
              open cur for psql;  
              loop  
                 fetch cur  
                  into lab, val;  
                 exit when cur%notfound;  
                WriteToClob(res,'
                  ,'||val);  
              end loop;  
              close cur;  
                WriteToClob(res,'
                ]]);
                new google.visualization.ColumnChart(document.getElementById(''visualization'||pname||''')).
                    draw(data, {title:"'||ptitle||'", width:2*600, height:2*400,});
              }
              google.setOnLoadCallback(drawVisualization1);
            </script>');    
            end insert_column_chart;    
 
            --------------------------------------------------------------   
            function get_sql (kpi varchar2, top_values number, pperiod_type varchar2, pperiod_num number, pas_of_date date) return varchar2 is   
                    /*   
                    kpi  
                        Planiœci=P  
                        Wyk³adowcy=L  
                        Grupy=G  
                        Zasoby=R  
                        Przedmioty=S  
                        Formy zajeæ=F  
                        Przedmioty + formy zajeæ=M  
                    */      
                    sqlstmt varchar2(4000);  
  
                    --------------------------------------------------------------   
                    function get_time_limitation(pperiod_type varchar2, pperiod_num number, pas_of_date date) return varchar2 is    
                        l_date_from date;    
                        l_date_to   date;    
                    begin    
                      case when pperiod_type = 'yyyy' then  
                                select trunc(pas_of_date-pperiod_num*365,'yyyy'),trunc(pas_of_date+365-pperiod_num*365,'yyyy')-1  into l_date_from, l_date_to from dual;    
                           when pperiod_type = 'q'    then    
                                select add_months (trunc (pas_of_date, 'q'), 0-pperiod_num*3), add_months (trunc (pas_of_date, 'q'), 3-pperiod_num*3)-1 into l_date_from, l_date_to from dual;  
                           when pperiod_type = 'rm'   then  
                                select add_months (trunc (pas_of_date, 'rm'), 0-pperiod_num*1), add_months (trunc (pas_of_date, 'rm'), 1-pperiod_num*1)-1 into l_date_from, l_date_to from dual;  
                           when pperiod_type = 'w'    then  
                                select trunc (pas_of_date, 'ww')-pperiod_num*7, trunc (pas_of_date, 'ww')+6-pperiod_num*7 into l_date_from, l_date_to from dual;  
                      end case;  
                      return 'classes.day between to_date('''|| to_char(l_date_from,'yyyy-mm-dd') ||''',''yyyy-mm-dd'') and to_date('''|| to_char(l_date_to,'yyyy-mm-dd') ||''',''yyyy-mm-dd'')';  
                    end;  
  
                    --------------------------------------------------------------  
                    function get_where_clause ( table_name  varchar2, user_or_role_id varchar2 ) return varchar2 is  
                     tn     varchar2(50);  
                     result varchar2(500);  
                    begin  
                     tn := Upper(table_Name);  
                     tn := replace(tn,'PLANNER.','');  
                     result := '0=1';  
                     if tn = 'LECTURERS' then result := tn||'.ID IN (SELECT LEC_ID FROM LEC_PLA WHERE PLA_ID = '||user_or_role_id||')'; end if;  
                     if tn = 'GROUPS'    then result := tn||'.ID IN (SELECT GRO_ID FROM GRO_PLA WHERE PLA_ID = '||user_or_role_id||')'; end if;  
                     if tn = 'ROOMS'     then result := tn||'.ID IN (SELECT ROM_ID FROM ROM_PLA WHERE PLA_ID = '||user_or_role_id||')'; end if;  
                     if tn = 'SUBJECTS'  then result := tn||'.ID IN (SELECT SUB_ID FROM SUB_PLA WHERE PLA_ID = '||user_or_role_id||')'; end if;  
                     if tn = 'FORMS'     then result := tn||'.ID IN (SELECT FOR_ID FROM FOR_PLA WHERE PLA_ID = '||user_or_role_id||')'; end if;  
                     if tn = 'PERIODS'   then result := '0=0'; end if;  
                     if tn = 'PLANNERS'  then result := '0=0'; end if;  
                     if result = '0=1' then raise_application_error(-20000, 'B³¹d programu - funkcja getWhereClause, wartoœæ ' || tn); end if;  
                     return result;  
                    end;  
                      
                    function get_access_where return varchar2 is  
                        access_l varchar2(500);  
                        access_g varchar2(500);  
                        access_r varchar2(500);  
                        access_s varchar2(500);  
                        access_f varchar2(500);  
                    begin  
                        access_l := 'classes.id in ((select cla_id from lec_cla where lec_id in (select id from lecturers where '||get_where_clause('LECTURERS', pla_id)||' )) union all select id from classes where calc_lec_ids is null)';  
                        access_g := 'classes.id in ((select cla_id from gro_cla where gro_id in (select id from groups    where '||get_where_clause('GROUPS', pla_id)||' )) union all select id from classes where calc_gro_ids is null)';  
                        access_r := 'classes.id in ((select cla_id from rom_cla where rom_id in (select id from rooms     where '||get_where_clause('ROOMS', pla_id)||' )) union all select id from classes where calc_rom_ids is null)';  
                        access_s := '(classes.sub_id in (select id from subjects  where '||get_where_clause('SUBJECTS', pla_id)||') or classes.sub_id is null)';  
                        access_f := '(classes.for_id in (select id from forms     where '||get_where_clause('FORMS', pla_id)||') or classes.for_id is null )';  
                        return access_l ||' and ' || access_g ||' and ' || access_r ||' and ' || access_s ||' and ' || access_f;  
                    end;  
                      
            begin  
                case   
                    when kpi='L' then sqlstmt := sql_l;  
                    when kpi='G' then sqlstmt := sql_g;  
                    when kpi='R' then sqlstmt := sql_r;  
                    when kpi='S' then sqlstmt := sql_s;  
                    when kpi='F' then sqlstmt := sql_f;  
                    when kpi='M' then sqlstmt := sql_m;  
                    when kpi='P' then sqlstmt := sql_p;  
                end case;  
                  
                sqlstmt := replace(sqlstmt, '%time_limitation', get_time_limitation(pperiod_type,pperiod_num, pas_of_date));  
                sqlstmt := replace(sqlstmt, '%top_values', top_values);  
                sqlstmt := replace(sqlstmt, '%function', row_number_rank);  
                if entire_db='Y' then sqlstmt := replace(sqlstmt, '%access_where'   , '0=0');  
                                 else sqlstmt := replace(sqlstmt, '%access_where'   , get_access_where );  
                end if;                     
                wlog('GOOGLE_CHART:' || kpi,sqlstmt);                  
                return sqlstmt;  
            end get_sql;   
    --------------------------------------------------------------   
    begin --getChart 
        clear_log; 
        NewClob(res, '');   
        WriteToClob(res,     
'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <meta http-equiv="content-type" content="text/html; charset=windows-1250"/>
    <title>
      Plansoft.org - wskaŸniki efektywnoœci
    </title>
    <script type="text/javascript" src="http://www.google.com/jsapi"></script>
    <script type="text/javascript">
      google.load(''visualization'', ''1'', {packages: [''corechart'']});
    </script>');    
        
    for r in 1..row_nums loop    
    for t in 1..pperiod_count loop    
        counter := counter + 1;    
        declare   
            chart_title varchar2(500);   
        begin   
            select decode(substr(kpis,r,1),'L','Najaktywniejsi wyk³adowcy','G','Najaktywniejsze grupy','R','Najw. zu¿ycie sal','S','Przedmioty','F','Formy zajêæ','M','Przedmioty+formy','P','Planiœci','???')||'. Okres: '||   
                   decode(pperiod_type,'yyyy','rok','q','kwarta³','rm','miesi¹c','w','tydzieñ','???')||' '||   
                   decode(t-1,0,'obecny',1,'poprzedni','-'||to_char(t-1))   
              into chart_title   
              from dual;   
            insert_pie_or_column_chart (  
                pie_or_column 
              , graph_width 
              , graph_height     
              , to_char(counter)  
              , chart_title   
              , get_sql( substr(kpis,r,1), top_values, pperiod_type,t-1, pas_of_date)    
            );    
        end;   
    end loop;    
    end loop;   
        WriteToClob(res,'    
  </head>
  <body style="font-family: Arial;border: 0 none;">
  <table>
  ');  
  
    counter := 0;  
    if matrix_or_column = 'Matrix' then 
        for r in 1..row_nums loop  
            WriteToClob(res,'
            <tr>');  
        for t in 1..pperiod_count loop  
            counter := counter + 1;  
            WriteToClob(res,'
                <td><div id="visualization'||to_char(counter)||'"></div></td>');  
        end loop;  
            WriteToClob(res,'
            </tr>');  
        end loop;  
    else --column 
        WriteToClob(res,'
        <tr><td>');  
        for r in 1..row_nums loop  
        for t in 1..pperiod_count loop  
            counter := counter + 1;  
            WriteToClob(res,'
                <div id="visualization'||to_char(counter)||'"></div>');  
        end loop;  
        end loop;  
        WriteToClob(res,'
        </td></tr>');  
    end if; 
  
WriteToClob(res,'
  </table>
  </body>
</html>');  
  
        return res;  
    end getChart;  
end;
/

