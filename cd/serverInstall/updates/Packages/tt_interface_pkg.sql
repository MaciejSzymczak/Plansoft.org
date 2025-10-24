create or replace package tt_interface_pkg is 

   /***************************************************************************************************************************** 
   |* Importing Plan to Plansoft.org @author Maciej Szymczak @version 2025.09.27 
   \-----------------------------------------------------------------------------------------------------------------------------*/ 

    procedure import (deleteExisting varchar2 default 'N');
    function getReport  return clob;  
end;
/

create or replace package body tt_interface_pkg is 
     res clob;  
     
   /***************************************************************************************************************************** 
   |* Importing Plan to Plansoft.org @author Maciej Szymczak @version 2025.09.25 
   \-----------------------------------------------------------------------------------------------------------------------------*/ 

    procedure import (deleteExisting varchar2 default 'N') as 
 trace varchar2(200);
begin
    -- ******************************************************************
    -- *************TT_INTERFACE *************************************
    -- ******************************************************************
    declare
     prescat_comb_id number;
    begin
        trace := 'MATCHING';
        update tt_interface set integration_id ='DUMMY:'||TT_SEQ.NEXTVAL where created_by=user and integration_id is null;
        update TT_INTERFACE set 
               LEC_INTEGRATION_ID = trim(upper(LEC_INTEGRATION_ID))
              ,GRO_INTEGRATION_ID = trim(upper(GRO_INTEGRATION_ID))
              ,SUB_INTEGRATION_ID = trim(upper(SUB_INTEGRATION_ID))
              ,FOR_INTEGRATION_ID = trim(upper(FOR_INTEGRATION_ID))
              ,PER_INTEGRATION_ID = trim(upper(PER_INTEGRATION_ID))
              ,message=null
        where created_by=user;
        begin
          BEGIN update TT_INTERFACE set LEC_ID = (select Id from lecturers where trim(upper(integration_id))                        = LEC_INTEGRATION_ID ) where created_by=user and LEC_ID is null; EXCEPTION WHEN OTHERS THEN  null; END;
          BEGIN update TT_INTERFACE set LEC_ID = (select Id from lecturers where to_char(id)                                        = LEC_INTEGRATION_ID ) where created_by=user and LEC_ID is null; EXCEPTION WHEN OTHERS THEN  null; END;
          BEGIN update TT_INTERFACE set LEC_ID = (select Id from lecturers where trim(upper(abbreviation))                          = LEC_INTEGRATION_ID ) where created_by=user and LEC_ID is null; EXCEPTION WHEN OTHERS THEN  null; END;
          BEGIN update TT_INTERFACE set LEC_ID = (select Id from lecturers where trim(upper(title||' '||first_name||' '||last_name))= LEC_INTEGRATION_ID ) where created_by=user and LEC_ID is null; EXCEPTION WHEN OTHERS THEN  null; END;
          BEGIN update TT_INTERFACE set LEC_ID = (select Id from lecturers where trim(upper(first_name||' '||last_name))            = LEC_INTEGRATION_ID ) where created_by=user and LEC_ID is null; EXCEPTION WHEN OTHERS THEN  null; END;
          BEGIN update TT_INTERFACE set LEC_ID = (select Id from lecturers where trim(upper(abbreviation||' '||title||' '||first_name||' '||last_name)) LIKE '%'||LEC_INTEGRATION_ID||'%') where created_by=user and LEC_ID is null; EXCEPTION WHEN OTHERS THEN null; END;
        end;        
        
        --record-level attempt
        for rec in (select rowid from tt_interface where created_by=user and LEC_ID is null) loop
          BEGIN update TT_INTERFACE set LEC_ID = (select Id from lecturers where trim(upper(title||' '||first_name||' '||last_name))= LEC_INTEGRATION_ID ) where rowid=rec.rowid; EXCEPTION WHEN OTHERS THEN  null; END;
          BEGIN update TT_INTERFACE set LEC_ID = (select Id from lecturers where trim(upper(first_name||' '||last_name))            = LEC_INTEGRATION_ID ) where rowid=rec.rowid; EXCEPTION WHEN OTHERS THEN  null; END;
          BEGIN update TT_INTERFACE set LEC_ID = (select Id from lecturers where trim(upper(abbreviation||' '||title||' '||first_name||' '||last_name)) LIKE '%'||LEC_INTEGRATION_ID||'%') where  rowid=rec.rowid; EXCEPTION WHEN OTHERS THEN null; END;
        end loop;
        
        begin
          BEGIN update TT_INTERFACE set GRO_ID = (select Id from groups where trim(upper(integration_id))                        = GRO_INTEGRATION_ID ) where created_by=user and GRO_ID is null; EXCEPTION WHEN OTHERS THEN null; END;
          BEGIN update TT_INTERFACE set GRO_ID = (select Id from groups where to_char(id)                                        = GRO_INTEGRATION_ID ) where created_by=user and GRO_ID is null; EXCEPTION WHEN OTHERS THEN null; END;
          BEGIN update TT_INTERFACE set GRO_ID = (select Id from groups where trim(upper(abbreviation))                          = GRO_INTEGRATION_ID ) where created_by=user and GRO_ID is null; EXCEPTION WHEN OTHERS THEN null; END;
          BEGIN update TT_INTERFACE set GRO_ID = (select Id from groups where trim(upper(name))                                  = GRO_INTEGRATION_ID ) where created_by=user and GRO_ID is null; EXCEPTION WHEN OTHERS THEN null; END;
          BEGIN update TT_INTERFACE set GRO_ID = (select Id from groups where trim(upper(abbreviation||' '||name)) LIKE '%'||GRO_INTEGRATION_ID||'%') where created_by=user and GRO_ID is null; EXCEPTION WHEN OTHERS THEN null; END;
        end;
        
        begin
          BEGIN update TT_INTERFACE set SUB_ID = (select Id from subjects where trim(upper(integration_id))                        = SUB_INTEGRATION_ID ) where created_by=user and SUB_ID is null; EXCEPTION WHEN OTHERS THEN null; END;
          BEGIN update TT_INTERFACE set SUB_ID = (select Id from subjects where to_char(id)                                        = SUB_INTEGRATION_ID ) where created_by=user and SUB_ID is null; EXCEPTION WHEN OTHERS THEN null; END;
          BEGIN update TT_INTERFACE set SUB_ID = (select Id from subjects where trim(upper(abbreviation))                          = SUB_INTEGRATION_ID ) where created_by=user and SUB_ID is null; EXCEPTION WHEN OTHERS THEN null; END;
          BEGIN update TT_INTERFACE set SUB_ID = (select Id from subjects where trim(upper(name))                                  = SUB_INTEGRATION_ID ) where created_by=user and SUB_ID is null; EXCEPTION WHEN OTHERS THEN null; END;
          BEGIN update TT_INTERFACE set SUB_ID = (select Id from subjects where trim(upper(abbreviation||' '||name)) LIKE '%'||SUB_INTEGRATION_ID||'%') where created_by=user and SUB_ID is null; EXCEPTION WHEN OTHERS THEN null; END;
        end;

        begin
          BEGIN update TT_INTERFACE set FOR_ID = (select Id from forms where trim(upper(integration_id))                        = FOR_INTEGRATION_ID ) where created_by=user and FOR_ID is null; EXCEPTION WHEN OTHERS THEN null; END;
          BEGIN update TT_INTERFACE set FOR_ID = (select Id from forms where to_char(id)                                        = FOR_INTEGRATION_ID ) where created_by=user and FOR_ID is null; EXCEPTION WHEN OTHERS THEN null; END;
          BEGIN update TT_INTERFACE set FOR_ID = (select Id from forms where trim(upper(abbreviation))                          = FOR_INTEGRATION_ID ) where created_by=user and FOR_ID is null; EXCEPTION WHEN OTHERS THEN null; END;
          BEGIN update TT_INTERFACE set FOR_ID = (select Id from forms where trim(upper(name))                                  = FOR_INTEGRATION_ID ) where created_by=user and FOR_ID is null; EXCEPTION WHEN OTHERS THEN null; END;
          BEGIN update TT_INTERFACE set FOR_ID = (select Id from forms where trim(upper(abbreviation||' '||name)) LIKE '%'||FOR_INTEGRATION_ID||'%') where created_by=user and FOR_ID is null; EXCEPTION WHEN OTHERS THEN null; END;
        end;

        begin
          BEGIN update TT_INTERFACE set PER_ID = (select Id from periods where trim(upper(integration_id))                        = PER_INTEGRATION_ID ) where created_by=user and PER_ID is null; EXCEPTION WHEN OTHERS THEN null; END;
          BEGIN update TT_INTERFACE set PER_ID = (select Id from periods where to_char(id)                                        = PER_INTEGRATION_ID ) where created_by=user and PER_ID is null; EXCEPTION WHEN OTHERS THEN null; END;
          BEGIN update TT_INTERFACE set PER_ID = (select Id from periods where trim(upper(name))                                  = PER_INTEGRATION_ID ) where created_by=user and PER_ID is null; EXCEPTION WHEN OTHERS THEN null; END;
        end;

        update TT_INTERFACE set message = 'Błąd' 
          where created_by=user and (lec_id is null or gro_id is null or sub_id is null or for_id is null or per_id is null);
          
        update TT_INTERFACE set message = 'Błąd: Podaj liczbę zajęć' 
          where created_by=user and classes_cnt is null;
        
        trace := 'GET. USOS_RESCAT_COMB_ID';
        select value into prescat_comb_id from system_parameters where name = 'USOS_RESCAT_COMB_ID';


        --link combination type with cycle
        trace := 'COMBINATIONS. INSERT TT_PLA';
        delete from TT_PLA where Pla_Id = (select id from planners where name=user);
        insert into TT_PLA (Id, pla_id, rescat_comb_id) values (TT_SEQ.NEXTVAL, (select id from planners where name=user), prescat_comb_id);
        ---  
        -- ******************************************************************
        -- *************TT_COMBINATIONS *************************************
        -- ******************************************************************
        -- TT_COMBINATIONS
        trace := 'COMBINATIONS.MERGE';
         if (deleteExisting='Y') then
            delete from TT_COMBINATIONS where created_by=user;
         end if;
         merge into TT_COMBINATIONS  m 
         using (select * from TT_INTERFACE where created_by=user and message is null) usos
            on (m.INTEGRATION_ID = usos.integration_id)
          when not matched then insert (
               Id 
             , rescat_comb_id 
             , weight 
             , AVAIL_TYPE 
             , ENABLED 
             , avail_orig 
             , avail_curr
             , PER_ID
             , LEC_ID
             , GRO_ID
             , ROM_ID
             , SUB_ID
             , FOR_ID
             , integration_id
          ) 
          values (
                TT_SEQ.NEXTVAL
              , prescat_comb_id
              , (select COMBINATION_NUMBER from TT_RESCAT_COMBINATIONS where Id = prescat_comb_id ) 
              , 'L'
              , 'Y'
              , usos.CLASSES_CNT
              , usos.CLASSES_CNT      
              , usos.PER_ID
              , usos.LEC_ID
              , usos.GRO_ID
              , usos.ROM_ID
              , usos.SUB_ID
              , usos.FOR_ID
              , usos.integration_id
          )
          when matched then 
          update set 
              avail_orig =  usos.CLASSES_CNT
             , weight = (select COMBINATION_NUMBER from TT_RESCAT_COMBINATIONS where Id = prescat_comb_id )
             , PER_ID    = usos.PER_ID
             , LEC_ID    = usos.LEC_ID
             , GRO_ID    = usos.GRO_ID
             , ROM_ID    = usos.ROM_ID
             , SUB_ID    = usos.SUB_ID
             , FOR_ID    = usos.FOR_ID;
         --
    ---  
    -- ******************************************************************
    -- *************TT_RESOURCE_LISTS *************************************
    -- ******************************************************************
         if (deleteExisting='Y') then
            trace := 'COMBINATIONS.DEL TT_RESOURCE_LISTS';
            delete from tt_resource_lists where tt_comb_id in (select Id from TT_COMBINATIONS where integration_id in (select integration_id from TT_INTERFACE where created_by=user and message is null) );
         end if;
         trace := 'COMBINATIONS.INS TT_RESOURCE_LISTS';
         insert into tt_resource_lists (id, tt_comb_id, res_id)
          select TT_SEQ.NEXTVAL, id, res_id from 
          (
          select id, per_id res_id from TT_COMBINATIONS where integration_id in (select integration_id from TT_INTERFACE where created_by=user and message is null)
          union
          select id, LEC_ID from TT_COMBINATIONS where LEC_ID is not null and integration_id in (select integration_id from TT_INTERFACE where created_by=user and message is null)
          union
          select id, SUB_ID from TT_COMBINATIONS where SUB_ID is not null and integration_id in (select integration_id from TT_INTERFACE where created_by=user and message is null)
          union
          select id, FOR_ID from TT_COMBINATIONS where FOR_ID is not null and integration_id in (select integration_id from TT_INTERFACE where created_by=user and message is null )
          union
          select id, GRO_ID from TT_COMBINATIONS where GRO_ID is not null and integration_id in (select integration_id from TT_INTERFACE where created_by=user and message is null)
          union
          select id, ROM_ID from TT_COMBINATIONS where ROM_ID is not null and integration_id in (select integration_id from TT_INTERFACE where created_by=user and message is null)
          minus
          select tt_comb_id, res_id from tt_resource_lists
          ); 
          --remove obsolete items
         delete from tt_resource_lists where id in (select l.id from tt_resource_lists l, tt_combinations ttc where ttc.id = l.tt_comb_id and l.res_id in (select Id from groups) and l.res_id <> ttc.gro_id);
         delete from tt_resource_lists where id in (select l.id from tt_resource_lists l, tt_combinations ttc where ttc.id = l.tt_comb_id and l.res_id in (select Id from lecturers) and l.res_id <> ttc.lec_id);
         delete from tt_resource_lists where id in (select l.id from tt_resource_lists l, tt_combinations ttc where ttc.id = l.tt_comb_id and l.res_id in (select Id from rooms) and l.res_id <> ttc.rom_id);
         delete from tt_resource_lists where id in (select l.id from tt_resource_lists l, tt_combinations ttc where ttc.id = l.tt_comb_id and l.res_id in (select Id from subjects) and l.res_id <> ttc.sub_id);
         delete from tt_resource_lists where id in (select l.id from tt_resource_lists l, tt_combinations ttc where ttc.id = l.tt_comb_id and l.res_id in (select Id from forms) and l.res_id <> ttc.for_id);
    ---  
    -- ******************************************************************
    -- *************TT_INCLUSIONS LIST *************************************
    -- ******************************************************************
          delete from TT_INCLUSIONS where inclusion_type = 'ALL' and tt_comb_id in (select Id from TT_COMBINATIONS where integration_id in (select integration_id from TT_INTERFACE where created_by=user and message is null) );
          if (deleteExisting='Y') then
            trace := 'COMBINATIONS.DEL TT_INCLUSIONS';
            delete from TT_INCLUSIONS where tt_comb_id in (select Id from TT_COMBINATIONS where integration_id in (select integration_id from TT_INTERFACE where created_by=user and message is null ) );
          end if;
          trace := 'COMBINATIONS.INS TT_INCLUSIONS';
         insert into  TT_INCLUSIONS (id, tt_comb_id, rescat_id, inclusion_type)
          (
          select TT_SEQ.NEXTVAL, Id, rescat_id, inclusion_type
          from (
          select c.Id, rescat_id, 'LIST' inclusion_type
           from 
              (select id from TT_COMBINATIONS where integration_id in (select integration_id from TT_INTERFACE where created_by=user and message is null)) c --for each TT_COMBINATIONS ... (no where)
             , (select rescat_id from TT_RESCAT_COMBINATIONS_DTL where rescat_comb_id=prescat_comb_id) -- ... add the resource types
          minus
          select tt_comb_id, rescat_id, inclusion_type from TT_INCLUSIONS
          )
          );
    ---  
    -- ******************************************************************
    -- *************TT_INCLUSIONS ALL *************************************
    -- ******************************************************************
          update TT_INCLUSIONS 
             set inclusion_type ='ALL' 
           where inclusion_type = 'LIST'
             and rescat_id = -4 
             and tt_comb_id in (
                    select Id 
                      from TT_COMBINATIONS 
                     where integration_id in (select integration_id from TT_INTERFACE where created_by=user and message is null) 
                      and lec_id is null
                 );
          update TT_INCLUSIONS 
             set inclusion_type ='ALL' 
           where inclusion_type = 'LIST'
             and rescat_id = -2 
             and tt_comb_id in (
                    select Id 
                      from TT_COMBINATIONS 
                     where integration_id in (select integration_id from TT_INTERFACE where created_by=user and message is null) 
                      and for_id is null
                 );
          update TT_INCLUSIONS 
             set inclusion_type ='ALL' 
           where inclusion_type = 'LIST'
             and rescat_id = -3 
             and tt_comb_id in (
                    select Id 
                      from TT_COMBINATIONS 
                     where integration_id in (select integration_id from TT_INTERFACE where created_by=user and message is null) 
                      and sub_id is null
                 );
          update TT_INCLUSIONS 
             set inclusion_type ='ALL' 
           where inclusion_type = 'LIST'
             and rescat_id = -5 
             and tt_comb_id in (
                    select Id 
                      from TT_COMBINATIONS 
                     where integration_id in (select integration_id from TT_INTERFACE where created_by=user and message is null) 
                      and gro_id is null
                 );
          update TT_INCLUSIONS 
             set inclusion_type ='ALL' 
           where inclusion_type = 'LIST'
             and rescat_id = -6 
             and tt_comb_id in (
                    select Id 
                      from TT_COMBINATIONS 
                     where integration_id in (select integration_id from TT_INTERFACE where created_by=user and message is null) 
                      and pla_id is null
                 );
          update TT_INCLUSIONS 
             set inclusion_type ='ALL' 
           where inclusion_type = 'LIST'
             and rescat_id = -7 
             and tt_comb_id in (
                    select Id 
                      from TT_COMBINATIONS 
                     where integration_id in (select integration_id from TT_INTERFACE where created_by=user and message is null) 
                      and per_id is null
                 );
    end;   

    ---  
    -- ******************************************************************
    -- *************recalc_combination122  ******************************
    -- ******************************************************************
    tt_planner.recalc_combination122( deleteExisting );

    xxmsz_tools.insertIntoEventLog('FROM USOS_PLAN:'||deleteExisting||': OK', 'I', 'INTEGRATION_FROM_USOS' );
    delete from xxmsztools_eventlog where module_name = 'INTEGRATION_FROM_USOS' and created < sysdate - 7;
    commit;
    end;



    ------------------------------------------------------------------------------------------------------------------------------------------------------- 
    function getReport return clob is 

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
      declare
          rok number;
          rerr number;
      begin
        select count(1) into rok from tt_interface where  created_by=user and message is null;
        select count(1) into rerr from tt_interface where  created_by=user and message is not null;

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
  <title>Import planu studiów: Wyniki</title>
</head>
  <body>
  
<h1>PLAN STUDIÓW: Import z pliku Excel</h1>  
<h2>Nie zaimportowano rekordów:'||to_char(rerr)||' </h2>
<h2>Zaimportowano rekordów:'||to_char(rok)||'</h2>

<style>
  table {
    border-collapse: collapse;
    width: 100%;
  }
  th, td {
    border: 1px solid #000;
    padding: 8px;
  }
  /* Make last 6 columns grey */
  th:nth-last-child(-n+6),
  td:nth-last-child(-n+6) {
    background-color: #d3d3d3; /* light grey */
  }
</style>  
  
  <table>
');    

      end;
      
         WriteToClob(res, '<tr><th>ID Planu Studiów</th><th>Wykładowca(Plansoft)</th><th>Grupa(Plansoft)</th><th>Przedmiot(Plansoft)</th><th>Forma(Plansoft)</th><th>Semestr(Plansoft)</th><th>Liczba zajęć</th><th>Komunikat</th><th>Wykładowca</th><th>Grupa</th><th>Przedmiot</th><th>Forma</th><th>Semestr</th></tr>'||chr(13)||chr(10));
         for rec in (
                select 
                   integration_id
                 , (select title||' '||first_name||' '||last_name from lecturers where id=lec_id) lec_dsp
                 , (select name from groups where id=gro_id) gro_dsp
                 , (select name from subjects where id=sub_id) sub_dsp
                 , (select name from forms where id=for_id) for_dsp
                 , (select name from periods where id=per_id) per_dsp
                 , classes_cnt
                 , message
                 , lec_integration_id
                 , gro_integration_id 
                 , sub_integration_id
                 , for_integration_id
                 , per_integration_id
                from tt_interface
                where created_by=user
                order by integration_id         
            ) loop
             WriteToClob(res, '<tr><td>'
               || rec.integration_id 
               || '</td><td>' || rec.lec_dsp
               || '</td><td>' || rec.gro_dsp
               || '</td><td>' || rec.sub_dsp 
               || '</td><td>' || rec.for_dsp 
               || '</td><td>' || rec.per_dsp 
               || '</td><td>' || rec.classes_cnt 
               || '</td><td>' || rec.message 
               || '</td><td>' || rec.lec_integration_id 
               || '</td><td>' || rec.gro_integration_id 
               || '</td><td>' ||  rec.sub_integration_id  
               || '</td><td>' ||  rec.for_integration_id  
               || '</td><td>' ||  rec.per_integration_id  
               ||'</td></tr>'||chr(13)||chr(10));
         end loop;

WriteToClob(res,'
  </table>
  </body>
</html>');  

       return res;  

   end getReport;


end;
/
