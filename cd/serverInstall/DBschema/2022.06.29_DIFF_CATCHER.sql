 CREATE TABLE "PLANNER"."DIFF_CATCHER_HELPER" 
   (	"DAY" DATE, 
	"NO_FROM" NUMBER, 
	"NO_TO" NUMBER, 
	"SUM" NUMBER, 
	"FROM_HOUR" VARCHAR2(5 BYTE), 
	"FROM_MIN" VARCHAR2(5 BYTE), 
	"TO_HOUR" VARCHAR2(5 BYTE), 
	"TO_MIN" VARCHAR2(5 BYTE), 
	"CALC_GROUPS" VARCHAR2(500 BYTE), 
	"CALC_ROOMS" VARCHAR2(500 BYTE), 
	"DESC2" VARCHAR2(200 BYTE), 
	"DIM" VARCHAR2(30 BYTE), 
	"DIFF_FLAG" VARCHAR2(10 BYTE), 
	"LEC_ID" NUMBER, 
	"OWNER" VARCHAR2(255 BYTE), 
	"SUB_ID" NUMBER, 
	"FOR_ID" NUMBER, 
	"CREATION_DATE" DATE
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;

  CREATE INDEX "PLANNER"."DIFF_CATCHER_HELPER1" ON "PLANNER"."DIFF_CATCHER_HELPER" ("DIM") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;

  CREATE INDEX "PLANNER"."DIFF_CATCHER_HELPER2" ON "PLANNER"."DIFF_CATCHER_HELPER" ("DAY") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
  

  create or replace package  diff_catcher is  
    
    /* Difference catcher 
       Use this code to schedule the Difference catcher

            begin
              dbms_scheduler.create_job(
                  job_name => 'DIFF_CATCHER_JOB'
                 ,job_type => 'PLSQL_BLOCK'
                 ,job_action => 'begin diff_catcher.diff; end;'
                 ,repeat_interval => 'freq=daily; byhour=20'
                 --,repeat_interval => 'freq=minutely'
                 ,enabled => TRUE
                 ,comments => '');
            --EXECUTE NOW           :  begin diff_catcher.diff; end;
            --DIS'PLAY SCHEDULED JOBS:  select * from dba_scheduler_jobs
            --DROP JOB              :  begin dbms_scheduler.drop_job('DIFF_CATCHER'); end;
            --LOG: select to_char(created,'yyyy-mm-dd hh24:mi:ss'), message from xxmsztools_eventlog where module_name = 'DIFF_CATCHER' order by id desc
            end;   

       @author Maciej Szymczak
       @version 2022-06-29
       
     */
    procedure fill (pDate_from date, pDate_to date, pdim varchar2);  
    procedure diff;  
    function getDiff  return clob;  
    
end;
/

create or replace package body diff_catcher is  
     res clob;  

    ------------------------------------------------------------------------------------------------------------------------------------------------------- 
    procedure diff  is
     trace varchar2(1000);
     pDateFrom date := trunc(sysdate);
     pDateTo date := trunc(sysdate)+180;
     ComparisionInterval number := 1;
    begin 
        xxmsz_tools.insertIntoEventLog('START', 'I', 'DIFF_CATCHER' );
        delete from DIFF_CATCHER_HELPER where dim in ('PRIOR','DIFF-7');
        -- keep last 7 DIFFs
        update DIFF_CATCHER_HELPER set dim = 'DIFF-7' where dim = 'DIFF-6';
        update DIFF_CATCHER_HELPER set dim = 'DIFF-6' where dim = 'DIFF-5';
        update DIFF_CATCHER_HELPER set dim = 'DIFF-5' where dim = 'DIFF-4';
        update DIFF_CATCHER_HELPER set dim = 'DIFF-4' where dim = 'DIFF-3';
        update DIFF_CATCHER_HELPER set dim = 'DIFF-3' where dim = 'DIFF-2';
        update DIFF_CATCHER_HELPER set dim = 'DIFF-2' where dim = 'DIFF-1';
        update DIFF_CATCHER_HELPER set dim = 'DIFF-1' where dim = 'DIFF';
        --
        update DIFF_CATCHER_HELPER set dim = 'PRIOR' where dim = 'CURRENT';
        diff_catcher.fill( pDateFrom, pDateTo, 'CURRENT'); 
        insert into DIFF_CATCHER_HELPER (owner, lec_id, calc_groups, calc_rooms, desc2, sub_id, for_id, day, from_hour, from_min, to_hour, to_min,sum,diff_flag, dim)
        (
        select owner, lec_id, calc_groups, calc_rooms, desc2,sub_id,for_id,day,from_hour, from_min, to_hour, to_min,sum,'DELETE' DIFF_FLAG, 'DIFF' dim from DIFF_CATCHER_HELPER where dim ='PRIOR'
        and day between pDateFrom and pDateTo-ComparisionInterval
        minus
        select owner, lec_id, calc_groups, calc_rooms, desc2,sub_id,for_id,day,from_hour, from_min, to_hour, to_min,sum,'DELETE' DIFF_FLAG, 'DIFF' dim from DIFF_CATCHER_HELPER where dim ='CURRENT'
        and day between pDateFrom and pDateTo-ComparisionInterval
        )
        union all
        (
        select owner, lec_id, calc_groups, calc_rooms, desc2,sub_id,for_id,day,from_hour, from_min, to_hour, to_min,sum,'INSERT' DIFF_FLAG, 'DIFF' dim from DIFF_CATCHER_HELPER where dim ='CURRENT'
        and day between pDateFrom and pDateTo-ComparisionInterval
        minus
        select owner, lec_id, calc_groups, calc_rooms, desc2,sub_id,for_id,day,from_hour, from_min, to_hour, to_min,sum,'INSERT' DIFF_FLAG, 'DIFF' dim from DIFF_CATCHER_HELPER where dim ='PRIOR'
        and day between pDateFrom and pDateTo-ComparisionInterval
        );  
        commit;
        xxmsz_tools.insertIntoEventLog('STOP', 'I', 'DIFF_CATCHER' );
        delete from xxmsztools_eventlog where module_name = 'DIFF_CATCHER' and created < sysdate - 14;
        commit;
    exception
        when others then
        xxmsz_tools.insertIntoEventLog(substrb( trace ||': '||sqlerrm,1,230), 'I', 'DIFF_CATCHER' );
    end;

    ------------------------------------------------------------------------------------------------------------------------------------------------------- 
    procedure fill (pDate_from date, pDate_to date, pdim varchar2) is
    begin
            declare
                prior_rec DIFF_CATCHER_HELPER%rowtype;
                prior_rec_rowid varchar2(250);
            begin
                delete from DIFF_CATCHER_HELPER where dim = pdim;
                insert into DIFF_CATCHER_HELPER (owner, lec_id, calc_groups, calc_rooms, desc2, sub_id, for_id, day, no_from,no_to,sum, dim, creation_date)
                select
                      cla.owner
                    , lec.id
                    , nvl(cla.calc_groups,'-') calc_groups
                    , nvl(cla.calc_rooms,'-') calc_rooms
                    , nvl(cla.desc2,'-') desc2 
                    , nvl(cla.sub_id,0) sub_id
                    , cla.for_id
                    , cla.day day
                    , grids.no no_from
                    , grids.no no_to
                    , sum(grids.duration * (fill/100)) sum
                    , pdim
                    , sysdate
                from  classes cla
                    , grids
                    , lec_cla
                    , lecturers lec
                where
                     lec_cla.cla_id = cla.id
                     and lec.id = lec_cla.lec_id
                     and lec.id>0
                     and (sub_id>0 or sub_id is null)
                     and 0=0
                     and cla.hour = grids.no
                     and cla.day between pDate_from and pDate_to
                group by                       
                      cla.owner
                    , lec.id
                    , cla.calc_groups
                    , cla.calc_rooms
                    , cla.desc2
                    , cla.sub_id
                    , cla.for_id
                    , cla.day 
                    , grids.no 
                    , grids.no 
                order by 1,2,3,4,5,6,7,8,9,10;
                commit;
                for rec in (
                    select rowid, day, no_from, no_to, owner, lec_id, calc_groups, calc_rooms, desc2, sub_id, for_id, sum 
                      from DIFF_CATCHER_HELPER 
                      where dim = pdim
                       and (owner, lec_id, calc_groups, calc_rooms, desc2, sub_id, for_id, day) in 
                      (
                          select owner, lec_id, calc_groups, calc_rooms, desc2, sub_id, for_id, day
                            from DIFF_CATCHER_HELPER
                            where  dim = pdim
                            group by owner, lec_id, calc_groups, calc_rooms, desc2, sub_id, for_id, day
                            having count(1)>1  
                      )
                    order by owner, lec_id, calc_groups, calc_rooms, desc2, sub_id, for_id, day, no_from, no_to 
                 ) loop
                     if       rec.day          = prior_rec.day
                         and rec.owner         = prior_rec.owner
                         and rec.lec_id        = prior_rec.lec_id
                         and rec.calc_groups   = prior_rec.calc_groups
                         and rec.calc_rooms    = prior_rec.calc_rooms
                         and rec.desc2         = prior_rec.desc2
                         and rec.sub_id        = prior_rec.sub_id
                         and rec.for_id        = prior_rec.for_id
                         and rec.no_from       = prior_rec.no_to+1
                     then
                         --merge current record into prior record
                         prior_rec.no_to := rec.no_to;
                         update DIFF_CATCHER_HELPER set no_to = rec.no_to, sum = sum + rec.sum where rowid = prior_rec_rowid; 
                         delete from DIFF_CATCHER_HELPER where rowid = rec.rowid;
                     else
                         prior_rec_rowid  := rec.rowid;
                         prior_rec.day        := rec.day;
                         prior_rec.no_from    := rec.no_from;
                         prior_rec.no_to      := rec.no_to;
                         prior_rec.owner      := rec.owner;
                         prior_rec.lec_id     := rec.lec_id;
                         prior_rec.calc_groups:= rec.calc_groups;
                         prior_rec.calc_rooms := rec.calc_rooms;
                         prior_rec.desc2      := rec.desc2;
                         prior_rec.sub_id     := rec.sub_id;
                         prior_rec.for_id     := rec.for_id;
                     end if;
                 end loop;
                update DIFF_CATCHER_HELPER
                  set from_hour = (select substr(hour_from,1,2) from grids where no = no_from)
                     ,from_min  = (select substr(hour_from,4,2) from grids where no = no_from)
                     ,to_hour   = (select substr(hour_to,1,2) from grids where no = no_to)
                     ,to_min    = (select substr(hour_to,4,2) from grids where no = no_to)
                 where dim = pdim;
                 commit;       
            end;
    end fill;
     
     
    ------------------------------------------------------------------------------------------------------------------------------------------------------- 
    function getDiff return clob is 

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
  <title>Zmiany w rozkładzie zajęć</title>
</head>
  <body>
  <table>
');    

         WriteToClob(res, '<tr>
<th>Planista</th>
<th>Tytuł</th>
<th>Imię</th>
<th>Nazwisko</th>
<th>Dzień</th>
<th>Godz.</th>
<th>Godz. do</th>
<th>Przedmiot</th>
<th>Forma</th>
<th>Grupa</th>
<th>Sala</th>
<th>Opis</th>
<th>Suma</th>
<th>Różnica</th></tr>'||chr(13)||chr(10));
         for rec in ( 
                    select owner
                         , lec.title
                         , lec.first_name
                         , lec.last_name
                         , to_char(day,'yyyy-mm-dd') day
                         , from_hour
                         , from_min
                         , to_hour
                         , to_min
                         , sub.name sub_name
                         , frm.name frm_name
                         , calc_groups
                         , calc_rooms
                         , DIFF_CATCHER_HELPER.desc2
                         , rtrim(to_char(sum, 'FM0.99'), '.')  sum
                         , decode(diff_flag,'DELETE','Usunięcie','Wstawienie') diff_flag
                      from DIFF_CATCHER_HELPER
                         , lecturers lec
                         , subjects sub
                         , forms frm
                      where lec_id = lec.id
                        and sub_id = sub.id(+)
                        and for_id = frm.id
                        and dim = 'DIFF' 
                      order by  
                           owner
                         , lec.title
                         , lec.first_name
                         , lec.last_name
                         , day
                         , from_hour
                         , from_min
                         , to_hour
                         , to_min
                         , sub.name 
                         , frm.name 
                         , calc_groups
                         , calc_rooms
                         , DIFF_CATCHER_HELPER.desc2
                         , sum 
                         , diff_flag
                    ) loop
             WriteToClob(res, '<tr><td>'
               || rec.owner 
               || '</td><td>' || rec.title 
               || '</td><td>' || rec.first_name 
               || '</td><td>' || rec.last_name 
               || '</td><td>' || rec.day 
               || '</td><td>' || rec.from_hour ||':'|| rec.from_min 
               || '</td><td>' || rec.to_hour ||':'|| rec.to_min 
               || '</td><td>' || rec.sub_name 
               || '</td><td>' || rec.frm_name 
               || '</td><td>' || rec.calc_groups 
               || '</td><td>' || rec.calc_rooms 
               || '</td><td>' || rec.desc2
               || '</td><td>' || rec.sum  
               || '</td><td>' || rec.diff_flag
               ||'</td></tr>'||chr(13)||chr(10));         
            end loop;

WriteToClob(res,'
  </table>
  </body>
</html>');  

       return res;  
      
   end getDiff;
     
     
end;
/
