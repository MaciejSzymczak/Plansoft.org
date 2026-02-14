create or replace package usos_dz_prowadzacy_grup  is 
   /***************************************************************************************************************************** 
   |* version_pkg
   |***************************************************************************************************************************** 
   | History 
   | 2026.01.28 Maciej Szymczak created  
   \-----------------------------------------------------------------------------------------------------------------------------*/ 


    /*
    Creates missing records in table dz_prowadzacy_grup@usos.

        select id from planners where name like 'USOS: LIDER ROZ'
        4206575
        
        begin
         usos_dz_prowadzacy_grup.insertRecords(4206575);
        end;
        
        select * from  xxmsztools_eventlog where module_name = 'INTEGRATION_TO_USOS_LEC' order by id desc

    Parameters:
        puserOrRoleId = select Id from planners where name = :your authorization name
        (optional) pper_id = select Id from periods where name = :your periods name

    @author Maciej Szymczak
    @version 2026.01.28
    */
    procedure insertRecords( puserOrRoleId number, pper_id number default null);

end;
/

create or replace PACKAGE BODY usos_dz_prowadzacy_grup AS

usosCykl varchar2(200) := 'USOS_CYKL%';

procedure buildUsosCykl(puserOrRoleId varchar2) as begin
  if puserOrRoleId is null then return; end if;
  usosCykl := puserOrRoleId||':USOS_CYKL';
end;

procedure insertRecords( puserOrRoleId number, pper_id number default null) is 
begin 
 declare
   pdate_from date;
   pdate_to date;
 begin
    if pper_id is not null then
      select date_from, date_to into pdate_from, pdate_to from periods where id = pper_id;
    else
      buildUsosCykl(puserOrRoleId);
      select date_from, date_to into pdate_from, pdate_to from periods where integration_id = (select value from system_parameters where name like usosCykl);
    end if;

    insert into HELPER_USOS_LEC (gr_nr, zaj_cyk_id, prac_id, lec_id, gro_id, sub_id, for_id)
    select unique
          (select unique usos_gr_nr from tt_combinations where  gro_id = gro_cla.gro_id and sub_id = cla.sub_id and for_id = cla.for_id) gr_nr
        , (select unique usos_zaj_cyk_id from tt_combinations where  gro_id = gro_cla.gro_id and sub_id = cla.sub_id and for_id = cla.for_id) zaj_cyk_id
        , (select unique prac.id from dz_pracownicy@USOS prac where os_id = lec.integration_id) prac_id
        , lec_id
        , gro_cla.gro_id
        , cla.sub_id
        , cla.for_id
      from classes cla
      ,      gro_cla
      ,      lec_cla
      ,        lecturers lec
      where gro_cla.cla_id = cla.id
        and lec_cla.cla_id = cla.id
        and lec.id = lec_cla.lec_id
        and calc_lec_ids is not null
        and calc_gro_ids is not null
        and sub_id is not null
        -- specific authorization 
        and sub_id in (select sub_id from sub_pla where pla_id= nvl(puserOrRoleId, pla_id)  )
        -- specific periods 
        and cla.day between pdate_from and pdate_to
        --plan with no lec
        and (gro_id, sub_id, for_id) in (
            select gro_id, sub_id, for_id from tt_combinations 
            where lec_id is null
        );
  
    --Generate changes history (log)
    for rec in (
        select gr_nr, zaj_cyk_id, prac_id from HELPER_USOS_LEC
        minus
        select gr_nr, zaj_cyk_id, prac_id from dz_prowadzacy_grup@usos    
    ) loop
      xxmsz_tools.insertIntoEventLog('INSERT INTO dz_prowadzacy_grup(gr_nr, zaj_cyk_id, prac_id) values('||rec.gr_nr||','||rec.zaj_cyk_id||','||rec.prac_id||')', 'I', 'INTEGRATION_TO_USOS_LEC' );
    end loop;
    delete from xxmsztools_eventlog where module_name = 'INTEGRATION_TO_USOS_LEC' and created < sysdate - 365;

    insert into dz_prowadzacy_grup@usos (gr_nr, zaj_cyk_id, prac_id) 
    select gr_nr, zaj_cyk_id, prac_id from HELPER_USOS_LEC
    minus
    select gr_nr, zaj_cyk_id, prac_id from dz_prowadzacy_grup@usos;

    commit;   
 end;
end insertRecords;

END usos_dz_prowadzacy_grup;
/
