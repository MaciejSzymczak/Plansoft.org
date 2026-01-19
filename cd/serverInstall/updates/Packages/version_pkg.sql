create or replace package version_pkg is 

   /***************************************************************************************************************************** 
   |* version_pkg
   |***************************************************************************************************************************** 
   | History 
   | 2025.11.27 Maciej Szymczak created  
   \-----------------------------------------------------------------------------------------------------------------------------*/ 

    --returns ver_id
    function createVersion (ver_name varchar2, per_id number, planners varchar2, userOrRoleID varchar2) return number;
    procedure createVersion (ver_name varchar2, per_id number, planners varchar2, userOrRoleID varchar2);
    
    --returns number of errors. 0 means no errors
    function restoreVersion (ver_id number) return number;
    procedure restoreVersion (ver_id number);
    function getReport(pver_id number)  return clob;  
    
    procedure deleteVersion (ver_id number);
end;
/

create or replace PACKAGE BODY version_pkg AS
    res clob;  


  -----------------------------------------------------------------------------------------------------------
  procedure debug (message varchar2) as
  begin
    return;
    Xxmsz_Tools.insertIntoEventLog( message );
  end;

  -----------------------------------------------------------------------------------------------------------
  procedure createVersion (ver_name varchar2, per_id number, planners varchar2, userOrRoleID varchar2) as
  dummy number;
  begin
    dummy := createVersion (ver_name , per_id , planners, userOrRoleID);
  end;
  
  -----------------------------------------------------------------------------------------------------------
  function createVersion (ver_name varchar2, per_id number, planners varchar2, userOrRoleID varchar2) return number as
   vdate_from date;
   vdate_to date;
   curr_ver_id number;
  BEGIN  
    select date_from, date_to into vdate_from, vdate_to from periods where id=per_id;
    insert into versions (Id, name, per_id, date_from, date_to, planners, userOrRoleID ) 
      select main_seq.nextval, ver_name, per_id, periods.date_from, periods.date_to, planners, userOrRoleID from periods where id=per_id;
      
    select main_seq.currval into curr_ver_id from dual;  

    insert into classes_ver (ver_id, ID, DAY, HOUR, FILL, SUB_ID, FOR_ID, DESC1, DESC2, CALC_LECTURERS, CALC_GROUPS, CALC_ROOMS, CALC_LEC_IDS, CALC_GRO_IDS, CALC_ROM_IDS, CREATED_BY, OWNER, STATUS, COLOUR, CREATION_DATE, CALC_RESCAT_IDS, DESC3, DESC4, EFFECTIVE_START_DATE, EFFECTIVE_END_DATE, LAST_UPDATED_BY, OPERATION_FLAG, ATTRIBN_01, ATTRIBN_02, ATTRIBN_03, ATTRIBN_04, ATTRIBN_05)
      select curr_ver_id, ID, DAY, HOUR, FILL, SUB_ID, FOR_ID, DESC1, DESC2, CALC_LECTURERS, CALC_GROUPS, CALC_ROOMS, CALC_LEC_IDS, CALC_GRO_IDS, CALC_ROM_IDS, CREATED_BY, OWNER, STATUS, COLOUR, CREATION_DATE, CALC_RESCAT_IDS, DESC3, DESC4, EFFECTIVE_START_DATE, EFFECTIVE_END_DATE, LAST_UPDATED_BY, OPERATION_FLAG, ATTRIBN_01, ATTRIBN_02, ATTRIBN_03, ATTRIBN_04, ATTRIBN_05 
      from classes 
      where day between vdate_from and vdate_to         
        /* user is owner OR user is supervisor of owner
        and exists (
                select 1
                from (
                    select name planner from planners where parent like '%'||planners||'%'
                    union all
                    select planners from dual
                ) p
                where classes.owner like '%' || p.planner || '%'
        )
        */
        and id in (
          select cla_id from gro_cla where day between vdate_from and vdate_to and gro_id in (select gro_id from gro_pla where pla_id = userOrRoleID)
          union
          select cla_id from lec_cla where day between vdate_from and vdate_to and lec_id in (select lec_id from lec_pla where pla_id = userOrRoleID)
          union
          select cla_id from rom_cla where day between vdate_from and vdate_to and rom_id in (select rom_id from rom_pla where pla_id = userOrRoleID)
          )
          and
          (
          sub_id in (select sub_id from sub_pla where pla_id = userOrRoleID)
          or
          for_id in (select id from forms where kind = 'R' intersect select for_id from for_pla where pla_id = userOrRoleID)
          )
          ;

    insert into lec_cla_ver (ver_id, ID, LEC_ID, CLA_ID, DAY, HOUR, IS_CHILD, EFFECTIVE_START_DATE, EFFECTIVE_END_DATE, LAST_UPDATED_BY, OPERATION_FLAG, CREATED_BY, CREATION_DATE, LAST_UPDATE_DATE, DESC1, DESC2, DESC3, DESC4, NO_CONFLICT_FLAG, PARENT_ID)
      select curr_ver_id, ID, LEC_ID, CLA_ID, DAY, HOUR, IS_CHILD, EFFECTIVE_START_DATE, EFFECTIVE_END_DATE, LAST_UPDATED_BY, OPERATION_FLAG, CREATED_BY, CREATION_DATE, LAST_UPDATE_DATE, DESC1, DESC2, DESC3, DESC4, NO_CONFLICT_FLAG, PARENT_ID 
      from lec_cla where cla_id in (select id from classes_ver where ver_id=curr_ver_id);

    insert into gro_cla_ver (ver_id, ID, GRO_ID, CLA_ID, DAY, HOUR, IS_CHILD, EFFECTIVE_START_DATE, EFFECTIVE_END_DATE, LAST_UPDATED_BY, OPERATION_FLAG, CREATED_BY, CREATION_DATE, LAST_UPDATE_DATE, NO_CONFLICT_FLAG, PARENT_ID)
      select curr_ver_id, ID, GRO_ID, CLA_ID, DAY, HOUR, IS_CHILD, EFFECTIVE_START_DATE, EFFECTIVE_END_DATE, LAST_UPDATED_BY, OPERATION_FLAG, CREATED_BY, CREATION_DATE, LAST_UPDATE_DATE, NO_CONFLICT_FLAG, PARENT_ID 
      from gro_cla where cla_id in (select id from classes_ver where ver_id=curr_ver_id);

    insert into rom_cla_ver (ver_id, ID, ROM_ID, CLA_ID, DAY, HOUR, IS_CHILD, EFFECTIVE_START_DATE, EFFECTIVE_END_DATE, LAST_UPDATED_BY, OPERATION_FLAG, NO_CONFLICT_FLAG, PARENT_ID)
      select curr_ver_id, ID, ROM_ID, CLA_ID, DAY, HOUR, IS_CHILD, EFFECTIVE_START_DATE, EFFECTIVE_END_DATE, LAST_UPDATED_BY, OPERATION_FLAG, NO_CONFLICT_FLAG, PARENT_ID 
      from rom_cla where cla_id in (select id from classes_ver where ver_id=curr_ver_id);

    commit;
    return main_seq.currval;
  END createVersion;

  -----------------------------------------------------------------------------------------------------------
  procedure checkConflicts(ver_id number) is 
  pragma autonomous_transaction;
   ver versions%rowtype;
  begin
    select * into ver from  versions where id = ver_id;
    delete from version_restore_messages where ver_id = ver.id;
    --check dict existence
    insert into version_restore_messages (id, ver_id, message)
    select main_seq.nextval, ver.id, 'Brakuje wykładowcy: ' || title ||' ' || first_name ||' ' || last_name ||' #' || Id from lecturers where id in (select lec_id from lec_cla where ver_id = ver.id minus select id from lecturers); 
    insert into version_restore_messages (id, ver_id, message)
    select main_seq.nextval, ver.id, 'Brakuje grupy: ' || name  ||' #' || Id from groups where id in (select gro_id from gro_cla where ver_id = ver.id minus select id from groups); 
    insert into version_restore_messages (id, ver_id, message)
    select main_seq.nextval, ver.id, 'Brakuje sali: ' || name || ' ' || attribs_01 ||' #' || Id from rooms where id in (select rom_id from rom_cla where ver_id = ver.id minus select id from rooms); 
    --check conflicts
    insert into version_restore_messages (id, ver_id, message, cla_id)
    select main_seq.nextval, ver.id, 'WYKŁADOWCA MA ZAJĘCIA:' || to_char(day) ||':'|| to_char(hour) ||':'|| (select title ||' ' || first_name ||' ' || last_name ||' #' || Id from lecturers where id=lec_id), cla_id 
    from lec_cla 
    where (day, hour, lec_id) in (
        --intersect what we already have in in the classes
        select day, hour, lec_id from lec_cla where day between ver.date_from and ver.date_to
        -- with what we plan to restore
        intersect
        select day, hour, lec_id from lec_cla_ver where ver_id = ver.id
    );
    --
    debug('version:'||ver_id);
    debug('version:'||ver.date_from);
    debug('version:'||ver_id);
    insert into version_restore_messages (id, ver_id, message, cla_id)
    select main_seq.nextval, ver.id, 'GRUPA MA ZAJĘCIA:' || to_char(day) ||':'|| to_char(hour) ||':'|| (select name ||' #' || Id from groups where id=gro_id) , cla_id
    from gro_cla 
    where (day, hour, gro_id) in (
        select day, hour, gro_id from gro_cla where day between ver.date_from and ver.date_to
        intersect
        select day, hour, gro_id from gro_cla_ver where ver_id = ver.id
    );
    debug('version:'||sql%ROWCOUNT);
    --
    insert into version_restore_messages (id, ver_id, message, cla_id)
    select main_seq.nextval, ver.id, 'SALA MA ZAJĘCIA:' || to_char(day) ||':'|| to_char(hour) ||':'|| (select name || ' ' || attribs_01 ||' #' || Id from rooms where id=rom_id), cla_id 
    from rom_cla 
    where (day, hour, rom_id) in (
        select day, hour, rom_id from rom_cla where day between ver.date_from and ver.date_to
        intersect
        select day, hour, rom_id from rom_cla_ver where ver_id = ver.id
    );
    -- now delete no conflicts (quicker approach than using "and cla_id not in ..."
    delete from version_restore_messages where ver_id = ver.id
    and cla_id in (
        -- query (1). Keep query (1) and (2) consistent.
        select id from classes where day between ver.date_from and ver.date_to 
            -- user is owner OR supervisor of owner
            and exists (
                    select 1
                    from (
                        select name planner from planners where parent like '%'||ver.planners||'%'
                        union all
                        select ver.planners from dual
                    ) p
                    where classes.owner like '%' || p.planner || '%'
            )
            and id in (
            select cla_id from gro_cla where gro_id in (select gro_id from gro_pla where pla_id = ver.userOrRoleID)
            union 
            select cla_id from lec_cla where lec_id in (select lec_id from lec_pla where pla_id = ver.userOrRoleID)
            union 
            select cla_id from rom_cla where rom_id in (select rom_id from rom_pla where pla_id = ver.userOrRoleID)
            )
            and
            (
            sub_id in (select sub_id from sub_pla where pla_id = ver.userOrRoleID)
            or
            for_id in (select id from forms where kind = 'R' intersect select for_id from for_pla where pla_id = ver.userOrRoleID)
            )
    );
   commit;
  end;
  
  -----------------------------------------------------------------------------------------------------------
  procedure restoreVersion (ver_id number) as
  dummy number;
  begin
   dummy := restoreVersion (ver_id);
  end;

  -----------------------------------------------------------------------------------------------------------
  function restoreVersion (ver_id number) return number as
   ver versions%rowtype;
  BEGIN  
    SAVEPOINT before_problem;
    select * into ver from  versions where id = ver_id;
    checkConflicts(ver_id);
    declare
     errCnt number;
    begin
     select count(1) into errCnt from version_restore_messages where ver_id = ver.id;
     debug('version:errCnt'||errCnt);
     if errCnt > 0 then
        ROLLBACK TO before_problem;return errCnt;
     else
        --restore
        -- query (2). Keep query (1) and (2) consistent.
        delete from classes where day between ver.date_from and ver.date_to 
            -- user is owner OR supervisor of owner
            and exists (
                    select 1
                    from (
                        select name planner from planners where parent like '%'||ver.planners||'%'
                        union all
                        select ver.planners from dual
                    ) p
                    where classes.owner like '%' || p.planner || '%'
            )
            and id in (
            select cla_id from gro_cla where gro_id in (select gro_id from gro_pla where pla_id = ver.userOrRoleID)
            union 
            select cla_id from lec_cla where lec_id in (select lec_id from lec_pla where pla_id = ver.userOrRoleID)
            union 
            select cla_id from rom_cla where rom_id in (select rom_id from rom_pla where pla_id = ver.userOrRoleID)
            )
            and
            (
            sub_id in (select sub_id from sub_pla where pla_id = ver.userOrRoleID)
            or
            for_id in (select id from forms where kind = 'R' intersect select for_id from for_pla where pla_id = ver.userOrRoleID)
            )
            ;
        insert into classes (ID, DAY, HOUR, FILL, SUB_ID, FOR_ID, DESC1, DESC2, CALC_LECTURERS, CALC_GROUPS, CALC_ROOMS, CALC_LEC_IDS, CALC_GRO_IDS, CALC_ROM_IDS, CREATED_BY, OWNER, STATUS, COLOUR, CREATION_DATE, CALC_RESCAT_IDS, DESC3, DESC4, EFFECTIVE_START_DATE, EFFECTIVE_END_DATE, LAST_UPDATED_BY, OPERATION_FLAG, ATTRIBN_01, ATTRIBN_02, ATTRIBN_03, ATTRIBN_04, ATTRIBN_05)
          select ID, DAY, HOUR, FILL, SUB_ID, FOR_ID, DESC1, DESC2, CALC_LECTURERS, CALC_GROUPS, CALC_ROOMS, CALC_LEC_IDS, CALC_GRO_IDS, CALC_ROM_IDS, CREATED_BY, OWNER, STATUS, COLOUR, CREATION_DATE, CALC_RESCAT_IDS, DESC3, DESC4, EFFECTIVE_START_DATE, EFFECTIVE_END_DATE, LAST_UPDATED_BY, OPERATION_FLAG, ATTRIBN_01, ATTRIBN_02, ATTRIBN_03, ATTRIBN_04, ATTRIBN_05 
          from classes_ver where ver_id = ver.id;
        insert into lec_cla (ID, LEC_ID, CLA_ID, DAY, HOUR, IS_CHILD, EFFECTIVE_START_DATE, EFFECTIVE_END_DATE, LAST_UPDATED_BY, OPERATION_FLAG, CREATED_BY, CREATION_DATE, LAST_UPDATE_DATE, DESC1, DESC2, DESC3, DESC4, NO_CONFLICT_FLAG, PARENT_ID)
          select ID, LEC_ID, CLA_ID, DAY, HOUR, IS_CHILD, EFFECTIVE_START_DATE, EFFECTIVE_END_DATE, LAST_UPDATED_BY, OPERATION_FLAG, CREATED_BY, CREATION_DATE, LAST_UPDATE_DATE, DESC1, DESC2, DESC3, DESC4, NO_CONFLICT_FLAG, PARENT_ID 
          from lec_cla_ver where ver_id = ver.id;
        insert into gro_cla (ID, GRO_ID, CLA_ID, DAY, HOUR, IS_CHILD, EFFECTIVE_START_DATE, EFFECTIVE_END_DATE, LAST_UPDATED_BY, OPERATION_FLAG, CREATED_BY, CREATION_DATE, LAST_UPDATE_DATE, NO_CONFLICT_FLAG, PARENT_ID)
          select ID, GRO_ID, CLA_ID, DAY, HOUR, IS_CHILD, EFFECTIVE_START_DATE, EFFECTIVE_END_DATE, LAST_UPDATED_BY, OPERATION_FLAG, CREATED_BY, CREATION_DATE, LAST_UPDATE_DATE, NO_CONFLICT_FLAG, PARENT_ID 
          from gro_cla_ver where ver_id = ver.id;
        insert into rom_cla (ID, ROM_ID, CLA_ID, DAY, HOUR, IS_CHILD, EFFECTIVE_START_DATE, EFFECTIVE_END_DATE, LAST_UPDATED_BY, OPERATION_FLAG, NO_CONFLICT_FLAG, PARENT_ID)
          select ID, ROM_ID, CLA_ID, DAY, HOUR, IS_CHILD, EFFECTIVE_START_DATE, EFFECTIVE_END_DATE, LAST_UPDATED_BY, OPERATION_FLAG, NO_CONFLICT_FLAG, PARENT_ID 
          from rom_cla_ver where ver_id = ver.id;
        return errCnt;  
     end if;
    end;
  EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK TO before_problem;
        raise;
  END restoreVersion;

  -----------------------------------------------------------------------------------------------------------
  procedure deleteVersion (ver_id number) as begin
    delete from versions where id =ver_id;
    --next, cascade deletion deletes all tables
  end deleteVersion;



    ------------------------------------------------------------------------------------------------------------------------------------------------------- 
    function getReport(pver_id number) return clob is 

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
  <title>Przywracanie wersji: Błędy</title>
</head>
  <body>
');    

WriteToClob(res,'
  <h1>Przywrócenie wersji niemożliwe z powodu błędów:</h1>
  <table>');  
 WriteToClob(res, '<tr><th>Komunikat</th><th>Id zajęcia</th><th>Właściciel</th></tr>'||chr(13)||chr(10));
 for rec in (
     select id, message, cla_id, (select owner from classes where id = cla_id) owner
       from version_restore_messages 
       where ver_id =  pver_id
       order by id         
 ) loop
     WriteToClob(res, '<tr>'
       || '<td>' || rec.message 
       || '</td><td>' || rec.cla_id 
       || '</td><td>' || rec.owner 
       ||'</td></tr>'||chr(13)||chr(10));
 end loop;
WriteToClob(res,'
  </table>');  

WriteToClob(res,'
  </body>
</html>');  

       return res;  

   end getReport;

END version_pkg;
/
