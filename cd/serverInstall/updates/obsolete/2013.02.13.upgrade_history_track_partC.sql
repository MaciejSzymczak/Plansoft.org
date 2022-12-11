CREATE OR REPLACE package api is

   /*****************************************************************************************************************************
   |* Public api to insert, update and delete classes
   |  Do not change database manually. instead of this, use this package.
   |
   |  Summary
   |    procedure insert_class    - Adds new class.
   |    function  can_insert_class- Checks if new class can be added. Does not add new class. 
   |    procedure delete_class    - Deletes existing class. 
   |    procedure update_class    - Updates class.
   |  
   |    function insert_class     - SQL equivalent for procedure insert_class (you can use this in SQL, no PLSQL is required).
   |    function update_class     - SQL equivalent for procedure update_class.
   |    function delete_class     - SQL equivalent for procedure delete_class.
   |
   |*****************************************************************************************************************************
   | History
   | 2010.06.04 created Maciej Szymczak
   | 2013.02.27 change Maciej Szymczak track history - change in delete_class
   \-----------------------------------------------------------------------------------------------------------------------------*/
   
  -----------------------------------------------------------------------------------------------------------------------------------------------------
  /* procedure adds a new class
     arguments:
       papiversion    API version. always set 1. 
       pday           class date
       phour          class hour
       pfill          block utilization ( 1-100 )
       psub_id        class subject (=subjects.id)
       pfor_id        class form (=forms.id)
       plec_ids       class lecturer (=lecturers.id). this parameter is optional. You can pass more values separated by ";", for instance "1;2;3"
       pgro_ids       class group of students (=groups.id). this parameter is optional. You can pass more values separated by ";", for instance "1;2;3"
       prom_ids       class resource (=rooms.id). this parameter is optional. You can pass more values separated by ";", for instance "1;2;3"
       powner         =owner name, max. 30chars. it has to be the name of planner for instance BPLATA.
       pcreator       =creator name, max. 30chars. Any name uniquely indicated who actually created this class.
       out_class_id   id of just created class ( =class.id )
     remarks:
       it is assumed that dictionaries like subjects, forms, lecturers, groups, resources are given in database at the moment when you call this procedure.
       this procedure grant automatically to owner permissions to see class in planner system.
       this procedure adds creator into planners table.       
     results:
         Any errors are reported by exception, examples:
          "ORA-00001: unique constraint (PLANNER.LEC_CLA_U) violated" means that you cannot add this class due to conflict with another one
                                                                      (Zaplanowanie tego zajêcia spodowa³oby konflikty z innymi zajêciami)
                                                                      This is frequently occured error
          "ORA-12899: value too large for column "PLANNER"."PLANNERS"."NAME" (actual: 71, maximum: 30)" - creator or owner name is too long
          "ORA-01722: invalid number" - values in plec_ids, ogro_ids, prom_ids are not separated by ";", but by another char
          "ORA-20002: Class without lecturer and group and resource" - (Wska¿ przynajmniej jeden z obiektow: wyk³adowcê, grupê lub salê)
          internal errors:                                                             
          "ORA-20000: API version error" - API version does not respond to external system version.
          "ORA-20001: Wrong owner name" - owner has to be user of type USER
  */        
  procedure insert_class(
     papiversion  number
    ,pday      date
    ,phour     number
    ,pfill     number
    ,psub_id   number
    ,pfor_id   number
    ,plec_ids  varchar2
    ,pgro_ids  varchar2
    ,prom_ids  varchar2
    ,powner    varchar2
    ,pcreator  varchar2
    ,out_class_id out number
   );
    
  -----------------------------------------------------------------------------------------------------------------------------------------------------
  -- Checks whether given class can be added, returns Y(insert is allowed) or exception is raised
  -- Procedure insert_class validates whether it is possible to add class as well. Thus you do not need to use this function.
  -- However, you may use it to inform user whether user action will be performed sucesfully in advance. 
  function can_insert_class(
     papiversion  number
    ,pday      date
    ,phour     number
    ,pfill     number
    ,psub_id   number
    ,pfor_id   number
    ,plec_ids  varchar2
    ,pgro_ids  varchar2
    ,prom_ids  varchar2
    ,powner    varchar2
    ,pcreator  varchar2
   ) return varchar2;

  -----------------------------------------------------------------------------------------------------------------------------------------------------
  /* procedure deletes the class of given id
     arguments:
       pid            class id (=classes.id) 
     remarks:
       this procedure deletes class from database (grants to lecturer, group, resource, subject and form are not deleted. Creator in table planners is not deleted as well).
       THIS PROCEDURE DOES NOT CHECK WHETHER CURRENT USER HAS PERMISSIONS TO DO IT, IT IS A RESPONSIBILITY OF A SYSTEM WHICH USES THIS API.
         justification: 
           External system functionality can differ from planner desktop functionality.
           For example, planner desktop allows changes to owner only (owner is a planner - employee,internal user ).
           In opossite, external system can allow changes to creator rather than to owner (creator may NOT be a planner, it can be any external user for example a lecturer or a student).
           Usually the scenerio of plannig is:
            1. First, external users plans its classes
            2. Next,  external users are disallowed to change data
            3. Next,  planner (insernal user) reviews plans, assigns rooms were missing and so on.            
           It is important to implement appropriate safety rules on external system side, including period of time when external user are allowed to modifi data.
     results:
         Function returs no result. Any errors are reported by exception
  */        
  procedure delete_class ( pid number ); 

  -----------------------------------------------------------------------------------------------------------------------------------------------------
  /* function adds a new class
      Similar to procedure insert_class with the exceptions:
      - you can call this procedure in select statement ( no pl/sql block is required )
      - this procedure performs commit
      
     sample code shows how to use this function. 
  
      select api.insert_class(
           2
          ,date'2010-06-04'               -- pday    
          ,'1'                            -- phour     number
          ,100                            -- pfill     number
          ,(select max(id) from subjects) -- psub_id   number
          ,(select max(id) from forms)    -- pfor_id   number
          ,(select max(id) from lecturers)
                                          -- pcalc_lec_ids   varchar2
          ,(select max(id) from groups)
                                          -- pcalc_gro_ids   varchar2
          ,(select max(id) from rooms)
                                          -- pcalc_rom_ids   varchar2
          ,'BPLATA'                       -- powner    varchar2
          ,'WYKLADOWCA A'                 -- pcreator  varchar2 
         ) result
      from dual
      
     results:
      function returns id of class
  */       
  function insert_class(
     papiversion  number
    ,pday      date
    ,phour     number
    ,pfill     number
    ,psub_id   number
    ,pfor_id   number
    ,plec_ids  varchar2
    ,pgro_ids  varchar2
    ,prom_ids  varchar2
    ,powner    varchar2
    ,pcreator  varchar2 
   ) return number;
   
  --almost the same as procedure delete_class. it allow you use this procedure directly in SQL ( no PL/SQL block is required ) 
  --this procedure does commit.
  function delete_class ( pid number ) return varchar2;  
  
  --updates class.
  -- you need pass all elements of the class ( NOT only changed elements )
  -- rememeber: updated class has another id (in_out_class_id).
  procedure update_class(
    papiversion number
   ,pday       date
   ,phour      number
   ,pfill      number
   ,psub_id    number
   ,pfor_id    number
   ,plec_ids   varchar2
   ,pgro_ids   varchar2
   ,prom_ids   varchar2
   ,powner     varchar2
   ,pcreator   varchar2
   ,in_out_class_id in out number);

  --SQL version equivalent   
  function update_class(
     papiversion  number
    ,pday      date
    ,phour     number
    ,pfill     number
    ,psub_id   number
    ,pfor_id   number
    ,plec_ids  varchar2
    ,pgro_ids  varchar2
    ,prom_ids  varchar2
    ,powner    varchar2
    ,pcreator  varchar2
    ,pclass_id in number 
   ) return number;   
   
   -- procedure purges database from classes out of periods
   procedure delete_orphaned (p_user varchar2 );

end;
/

CREATE OR REPLACE package body api is

  debug_enabled boolean := to_char(sysdate,'yyyy') in ('2010','2011');

  -----------------------------------------------------------------------------------------------------------------------------------------------------
  procedure debug (m varchar2) is
  begin
    if debug_enabled then
      xxmsz_tools.insertIntoEventLog(m,'I','API');
    end if;
  end;
 
  -----------------------------------------------------------------------------------------------------------------------------------------------------
  procedure insert_class(
    papiversion number
   ,pday       date
   ,phour      number
   ,pfill      number
   ,psub_id    number
   ,pfor_id    number
   ,plec_ids   varchar2
   ,pgro_ids   varchar2
   ,prom_ids   varchar2
   ,powner     varchar2
   ,pcreator   varchar2
   ,out_class_id out number    
  ) is
  begin
    debug ('insert_class:' || 
      papiversion||':'||
      to_char(pday,'yyyy-mm-dd')||':'||
      phour      ||':'||
      pfill      ||':'||
      psub_id    ||':'||
      pfor_id    ||':'||
      plec_ids   ||':'||
      pgro_ids   ||':'||
      prom_ids   ||':'||
      powner     ||':'||
      pcreator );
    if papiversion <> 1 then 
      raise_application_error(planner_utils.exc_API_ver_error, 'API version error');
    end if;
    if plec_ids is null and pgro_ids is null and prom_ids is null then
      raise_application_error(planner_utils.exc_lecgrorom_null, 'Class without lecturer and group and resource');
    end if;  
    --savepoint planner_api;
    --
    begin    
      insert into planners (id, name, type, colour) values ( main_seq.nextval, pcreator, 'EXTERNAL',  dbms_random.value(0,255) + 256*dbms_random.value(0,255) + 256*256*dbms_random.value(0,255)  ); 
    exception
     when dup_val_on_index then null;
    end;
    --
    declare
     ppla_id number;
    begin
     select id into ppla_id from planners where name = powner;
    exception
      when no_data_found then raise_application_error(planner_utils.exc_wrong_owner_name, 'Wrong owner name');
    end;
    --
    planner_utils.insert_classes(
      pday             => pday           
     ,phour            => phour           
     ,pfill            => pfill           
     ,psub_id          => psub_id        
     ,pfor_id          => pfor_id         
     ,pcalc_lec_ids    => plec_ids   
     ,pcalc_gro_ids    => pgro_ids  
     ,pcalc_rom_ids    => prom_ids   
     ,pcalc_lecturers  => null 
     ,pcalc_groups     => null   
     ,pcalc_rooms      => null     
     ,powner           => powner      
     ,pcreator         => pcreator     
     ,prefreshLGR      => 'Y'
     ,pgrantPermissions=> 'Y'
    );
    out_class_id  := planner_utils.output_param_num1; 
  exception
  when others then
    rollback; -- to savepoint planner_api;
    raise;  
  end insert_Class;
  
  -----------------------------------------------------------------------------------------------------------------------------------------------------
  function can_insert_class(
     papiversion  number
    ,pday      date
    ,phour     number
    ,pfill     number
    ,psub_id   number
    ,pfor_id   number
    ,plec_ids  varchar2
    ,pgro_ids  varchar2
    ,prom_ids  varchar2
    ,powner    varchar2
    ,pcreator  varchar2
   ) return varchar2 is
  pragma autonomous_transaction;
  out_class_id number; 
  begin
    debug('can_insert_class');    
    insert_class(
     papiversion 
    ,pday      
    ,phour     
    ,pfill     
    ,psub_id   
    ,pfor_id   
    ,plec_ids   
    ,pgro_ids   
    ,prom_ids   
    ,powner    
    ,pcreator  
    ,out_class_id
    );
    rollback;
    return 'Y';
  end; 

  -----------------------------------------------------------------------------------------------------------------------------------------------------
  procedure delete_class ( pid number ) is
   l_sum_units number;
  begin 
    debug('delete_class:'||pid);
    select sum(units) into l_sum_units from tt_cla where cla_id = pid;
    for rec in (select tt_comb_id from tt_cla where cla_id = pid) loop
      tt_planner.unbook_combination ( rec.tt_comb_id, l_sum_units );
    end loop;
    delete from classes where id = pid;
    -- lec_cla, gro_cla, rom_cla are not cleared cascadely due defferable relation    
    delete from lec_cla where cla_id = pid;
    delete from gro_cla where cla_id = pid;
    delete from rom_cla where cla_id = pid;
    -- tt_cla is cleared cascadely
  exception
  when others then
    rollback; 
    raise;  
  end;

  -----------------------------------------------------------------------------------------------------------------------------------------------------
  function insert_class(
     papiversion  number
    ,pday      date
    ,phour     number
    ,pfill     number
    ,psub_id   number
    ,pfor_id   number
    ,plec_ids  varchar2
    ,pgro_ids  varchar2
    ,prom_ids  varchar2
    ,powner    varchar2
    ,pcreator  varchar2 
   ) return number is
  pragma autonomous_transaction;
  out_class_id number; 
  begin
    insert_class(
     papiversion 
    ,pday      
    ,phour     
    ,pfill     
    ,psub_id   
    ,pfor_id   
    ,plec_ids   
    ,pgro_ids   
    ,prom_ids   
    ,powner    
    ,pcreator  
    ,out_class_id
    );
    commit;
    return out_class_id;
  end; 


  -----------------------------------------------------------------------------------------------------------------------------------------------------
  function delete_class ( pid number ) return varchar2 is
  pragma autonomous_transaction; 
  begin
    delete_class(pid);
    commit;
    return null;
  end;
  

  -----------------------------------------------------------------------------------------------------------------------------------------------------
  procedure update_class(
    papiversion number
   ,pday       date
   ,phour      number
   ,pfill      number
   ,psub_id    number
   ,pfor_id    number
   ,plec_ids   varchar2
   ,pgro_ids   varchar2
   ,prom_ids   varchar2
   ,powner     varchar2
   ,pcreator   varchar2
   ,in_out_class_id in out number    
  ) is
  begin
    debug('update_class:'||in_out_class_id);
    delete_class ( in_out_class_id );
    insert_class(
     papiversion 
    ,pday      
    ,phour     
    ,pfill     
    ,psub_id   
    ,pfor_id   
    ,plec_ids   
    ,pgro_ids   
    ,prom_ids   
    ,powner    
    ,pcreator  
    ,in_out_class_id
    );
  exception
  when others then
    rollback; 
    raise;  
  end;

  -----------------------------------------------------------------------------------------------------------------------------------------------------
  function update_class(
     papiversion  number
    ,pday      date
    ,phour     number
    ,pfill     number
    ,psub_id   number
    ,pfor_id   number
    ,plec_ids  varchar2
    ,pgro_ids  varchar2
    ,prom_ids  varchar2
    ,powner    varchar2
    ,pcreator  varchar2
    ,pclass_id in number 
   ) return number is
  pragma autonomous_transaction;
  in_out_class_id number;
  begin
    in_out_class_id := pclass_id;
    update_class(
     papiversion 
    ,pday      
    ,phour     
    ,pfill     
    ,psub_id   
    ,pfor_id   
    ,plec_ids   
    ,pgro_ids   
    ,prom_ids   
    ,powner    
    ,pcreator  
    ,in_out_class_id
    );
    commit;
    return in_out_class_id;
  end; 

  -----------------------------------------------------------------------------------------------------------------------------------------------------
  procedure delete_orphaned (p_user varchar2 ) is
  begin
    for rec in (select id from classes where not exists (select 1 from periods where day between date_from and date_to) and owner= p_user) loop
      delete_class ( rec.id );
    end loop;
  end; 

end;
/
