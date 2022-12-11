create or replace package api is 
 
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
   | 2013.11.03 bugfixing   
   | 2018.09.24 improvements
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
                                                                      (Zaplanowanie tego zajęcia spodowałoby konflikty z innymi zajęciami) 
                                                                      This is frequently occured error 
          "ORA-12899: value too large for column "PLANNER"."PLANNERS"."NAME" (actual: 71, maximum: 30)" - creator or owner name is too long 
          "ORA-01722: invalid number" - values in plec_ids, ogro_ids, prom_ids are not separated by ";", but by another char 
          "ORA-20002: Class without lecturer and group and resource" - (Wskaż przynajmniej jeden z obiektow: wykładowcę, grupę lub salę) 
          internal errors:                                                              
          "ORA-20000: API version error" - API version does not respond to external system version. 
          "ORA-20001: Wrong owner name" - owner has to be user of type USER 
  */         
  procedure insert_class( 
      papiversion  number 
     ,pday            date
     ,phour           number
     ,pfill           number
     ,psub_id         number
     ,pfor_id         number
     ,powner          varchar2 default null
     ,pcalc_lec_ids   varchar2
     ,pcalc_gro_ids   varchar2
     ,pcalc_rom_ids   varchar2
     ,pcolour         number   default null
     ,pdesc1          varchar2 default null
     ,pdesc2          varchar2 default null
     ,pdesc3          varchar2 default null
     ,pdesc4          varchar2 default null
     ,ptt_comb_ids    varchar2 default null
     ,pcalc_lecturers varchar2 default null
     ,pcalc_groups    varchar2 default null
     ,pcalc_rooms     varchar2 default null
     -- prefreshLGR ustaw na wartosc 'N' gdy 6 parametrow powyzej ( kolumny zaczynajace sie od pcalc%) zawieraja dobre wartosci
     -- prefreshLGR ustaw na wartosc 'Y' gdy 6 parametrow powyzej ( kolumny zaczynajace sie od pcalc%) nie zawieraja dobrych wartosci
     --   uwaga: identyfikatory musisz podawac zawsze (pcalc_lec_ids, pcalc_gro_ids, pcalc_rom_ids)
     ,pcreator          varchar2 default null
     ,prefreshLGR       varchar2 default 'Y'
     ,pgrantPermissions varchar2 default 'N'
      --used by public api. it is assumed external system keeps by himself grants (its grants may differ from grants of planner) and thus "knows" who is allowed to modify database
     ,pcalc_rescat_ids  varchar2 default null
     --,out_class_id out number 
   ); 
      
  ----------------------------------------------------------------------------------------------------------------------------------------------------- 
  -- Checks whether given class can be added, returns Y(insert is allowed) or exception is raised 
  -- Procedure insert_class validates whether it is possible to add class as well. Thus you do not need to use this function. 
  -- However, you may use it to inform user whether user action will be performed sucesfully in advance.  
  function can_insert_class( 
     papiversion  number 
   ,pday            date
     ,phour           number
     ,pfill           number
     ,psub_id         number
     ,pfor_id         number
     ,powner          varchar2 default null
     ,pcalc_lec_ids   varchar2
     ,pcalc_gro_ids   varchar2
     ,pcalc_rom_ids   varchar2
     ,pcolour         number   default null
     ,pdesc1          varchar2 default null
     ,pdesc2          varchar2 default null
     ,pdesc3          varchar2 default null
     ,pdesc4          varchar2 default null
     ,ptt_comb_ids    varchar2 default null
     ,pcalc_lecturers varchar2 default null
     ,pcalc_groups    varchar2 default null
     ,pcalc_rooms     varchar2 default null
     -- prefreshLGR ustaw na wartosc 'N' gdy 6 parametrow powyzej ( kolumny zaczynajace sie od pcalc%) zawieraja dobre wartosci
     -- prefreshLGR ustaw na wartosc 'Y' gdy 6 parametrow powyzej ( kolumny zaczynajace sie od pcalc%) nie zawieraja dobrych wartosci
     --   uwaga: identyfikatory musisz podawac zawsze (pcalc_lec_ids, pcalc_gro_ids, pcalc_rom_ids)
     ,pcreator          varchar2 default null
     ,prefreshLGR       varchar2 default 'Y'
     ,pgrantPermissions varchar2 default 'N'
      --used by public api. it is assumed external system keeps by himself grants (its grants may differ from grants of planner) and thus "knows" who is allowed to modify database
     ,pcalc_rescat_ids  varchar2 default null
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
 
    
  --almost the same as procedure delete_class. it allow you use this procedure directly in SQL ( no PL/SQL block is required )  
  --this procedure does commit. 
  function delete_class ( pid number ) return varchar2;   
    
   -- procedure purges database from classes out of periods 
   procedure delete_orphaned (p_user varchar2 ); 
    
   function translate_message (psqlerrm varchar2) return varchar2; 
 
end;
/

create or replace package body api is 
 
  debug_enabled boolean := to_char(sysdate,'yyyy') in ('2010','2011'); 
 
  ----------------------------------------------------------------------------------------------------------------------------------------------------- 
  procedure debug (m varchar2) is 
  begin 
    if debug_enabled then 
      xxmsz_tools.insertIntoEventLog(m,'I','API'); 
    end if; 
  end debug; 
  
  
  ----------------------------------------------------------------------------------------------------------------------------------------------------- 
  function translate_message (psqlerrm varchar2) return varchar2 is 
     dsp varchar2(240); 
  begin 
     select meaning into dsp from lookups where lookup_type = 'DBMESSAGE_TRANSLATION' and instr(psqlerrm, code)<>0; 
     return dsp; 
  exception 
     when no_data_found then  
         return psqlerrm; 
  end translate_message; 
  
  ----------------------------------------------------------------------------------------------------------------------------------------------------- 
  procedure insert_class( 
     papiversion  number 
     ,pday            date
     ,phour           number
     ,pfill           number
     ,psub_id         number
     ,pfor_id         number
     ,powner          varchar2 default null
     ,pcalc_lec_ids   varchar2
     ,pcalc_gro_ids   varchar2
     ,pcalc_rom_ids   varchar2
     ,pcolour         number   default null
     ,pdesc1          varchar2 default null
     ,pdesc2          varchar2 default null
     ,pdesc3          varchar2 default null
     ,pdesc4          varchar2 default null
     ,ptt_comb_ids    varchar2 default null
     ,pcalc_lecturers varchar2 default null
     ,pcalc_groups    varchar2 default null
     ,pcalc_rooms     varchar2 default null
     -- prefreshLGR ustaw na wartosc 'N' gdy 6 parametrow powyzej ( kolumny zaczynajace sie od pcalc%) zawieraja dobre wartosci
     -- prefreshLGR ustaw na wartosc 'Y' gdy 6 parametrow powyzej ( kolumny zaczynajace sie od pcalc%) nie zawieraja dobrych wartosci
     --   uwaga: identyfikatory musisz podawac zawsze (pcalc_lec_ids, pcalc_gro_ids, pcalc_rom_ids)
     ,pcreator          varchar2 default null
     ,prefreshLGR       varchar2 default 'Y'
     ,pgrantPermissions varchar2 default 'N'
      --used by public api. it is assumed external system keeps by himself grants (its grants may differ from grants of planner) and thus "knows" who is allowed to modify database
     ,pcalc_rescat_ids  varchar2 default null
     --,out_class_id out number 
  ) is 
  begin 
    debug ('insert_class:' ||  
      papiversion  ||':'|| 
     to_char(pday,'yyyy-mm-dd')            ||':'||
     phour           ||':'||
     pfill           ||':'||
     psub_id         ||':'||
     pfor_id         ||':'||
     powner          ||':'||  
     pcalc_lec_ids   ||':'||
     pcalc_gro_ids   ||':'||
     pcalc_rom_ids   ||':'||
     pcolour         ||':'||    
     pdesc1          ||':'||  
     pdesc2          ||':'||  
     pdesc3          ||':'||  
     pdesc4          ||':'||  
     ptt_comb_ids    ||':'||  
     pcalc_lecturers ||':'||  
     pcalc_groups    ||':'||  
     pcalc_rooms     ||':'||  
     -- prefreshLGR ustaw na wartosc 'N' gdy 6 parametrow powyzej ( kolumny zaczynajace sie od pcalc%) zawieraja dobre wartosci
     -- prefreshLGR ustaw na wartosc 'Y' gdy 6 parametrow powyzej ( kolumny zaczynajace sie od pcalc%) nie zawieraja dobrych wartosci
     --   uwaga: identyfikatory musisz podawac zawsze (pcalc_lec_ids, pcalc_gro_ids, pcalc_rom_ids)
     pcreator          ||':'||  
     prefreshLGR       ||':'|| 
     pgrantPermissions ||':'|| 
      --used by public api. it is assumed external system keeps by himself grants (its grants may differ from grants of planner) and thus "knows" who is allowed to modify database
     pcalc_rescat_ids);      
    
    if papiversion <> 2 then  
      raise_application_error(planner_utils.exc_API_ver_error, 'API version error'); 
    end if; 
    
    if pday is null then 
      raise_application_error(planner_utils.exc_lecgrorom_null, 'pday is required value'); 
    end if;   

    if phour is null then 
      raise_application_error(planner_utils.exc_lecgrorom_null, 'pday is required value'); 
    end if;   

    if pcalc_lec_ids is null and pcalc_gro_ids is null and pcalc_rom_ids is null then 
      raise_application_error(planner_utils.exc_lecgrorom_null, 'Class without lecturer and group and resource'); 
    end if;   
    --savepoint planner_api; 
    -- 
    --begin     
    --  insert into planners (id, name, type, colour) values ( main_seq.nextval, pcreator, 'EXTERNAL',  dbms_random.value(0,255) + 256*dbms_random.value(0,255) + 256*256*dbms_random.value(0,255)  );  
    --exception 
    -- when dup_val_on_index then null; 
    --end; 
    -- 
    --declare 
    -- ppla_id number; 
    --begin 
    -- select id into ppla_id from planners where name = powner; 
    --exception 
    --  when no_data_found then raise_application_error(planner_utils.exc_wrong_owner_name, 'Wrong owner name'); 
    --end; 
    -- 
    planner_utils.insert_classes( 
      pday            
     ,phour           
     ,pfill           
     ,psub_id         
     ,pfor_id         
     ,powner            
     ,pcalc_lec_ids   
     ,pcalc_gro_ids   
     ,pcalc_rom_ids   
     ,pcolour             
     ,pdesc1           
     ,pdesc2         
     ,pdesc3          
     ,pdesc4          
     ,ptt_comb_ids    
     ,pcalc_lecturers 
     ,pcalc_groups     
     ,pcalc_rooms       
     ,pcreator          
     ,prefreshLGR       
     ,pgrantPermissions 
     ,pcalc_rescat_ids  
    ); 
    --out_class_id  := planner_utils.output_param_num1;  
  exception 
  when others then 
    rollback; -- to savepoint planner_api; 
    raise;   
  end insert_Class; 
   
  ----------------------------------------------------------------------------------------------------------------------------------------------------- 
  function can_insert_class( 
      papiversion  number 
     ,pday            date
     ,phour           number
     ,pfill           number
     ,psub_id         number
     ,pfor_id         number
     ,powner          varchar2 default null
     ,pcalc_lec_ids   varchar2
     ,pcalc_gro_ids   varchar2
     ,pcalc_rom_ids   varchar2
     ,pcolour         number   default null
     ,pdesc1          varchar2 default null
     ,pdesc2          varchar2 default null
     ,pdesc3          varchar2 default null
     ,pdesc4          varchar2 default null
     ,ptt_comb_ids    varchar2 default null
     ,pcalc_lecturers varchar2 default null
     ,pcalc_groups    varchar2 default null
     ,pcalc_rooms     varchar2 default null
     -- prefreshLGR ustaw na wartosc 'N' gdy 6 parametrow powyzej ( kolumny zaczynajace sie od pcalc%) zawieraja dobre wartosci
     -- prefreshLGR ustaw na wartosc 'Y' gdy 6 parametrow powyzej ( kolumny zaczynajace sie od pcalc%) nie zawieraja dobrych wartosci
     --   uwaga: identyfikatory musisz podawac zawsze (pcalc_lec_ids, pcalc_gro_ids, pcalc_rom_ids)
     ,pcreator          varchar2 default null
     ,prefreshLGR       varchar2 default 'Y'
     ,pgrantPermissions varchar2 default 'N'
      --used by public api. it is assumed external system keeps by himself grants (its grants may differ from grants of planner) and thus "knows" who is allowed to modify database
     ,pcalc_rescat_ids  varchar2 default null
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
     ,powner          
     ,pcalc_lec_ids   
     ,pcalc_gro_ids   
     ,pcalc_rom_ids   
     ,pcolour        
     ,pdesc1          
     ,pdesc2          
     ,pdesc3          
     ,pdesc4          
     ,ptt_comb_ids    
     ,pcalc_lecturers 
     ,pcalc_groups    
     ,pcalc_rooms     
     ,pcreator          
     ,prefreshLGR      
     ,pgrantPermissions 
     ,pcalc_rescat_ids  
     --, out_class_id
    ); 
    rollback; 
    return 'Y'; 
  end can_insert_class;  
 
  
 
  ----------------------------------------------------------------------------------------------------------------------------------------------------- 
  function delete_class ( pid number ) return varchar2 is 
  pragma autonomous_transaction;
  begin 
    delete_class(pid); 
    commit; 
    return null; 
  end delete_class; 

  ----------------------------------------------------------------------------------------------------------------------------------------------------- 
  procedure delete_class ( pid number ) is 
  begin 
    planner_utils.delete_class ( pid ); 
  end; 
 
  ----------------------------------------------------------------------------------------------------------------------------------------------------- 
  procedure delete_orphaned (p_user varchar2 ) is 
  begin 
    for rec in (select id from classes where not exists (select 1 from periods where day between date_from and date_to) and owner= p_user) loop 
      delete_class ( rec.id ); 
    end loop; 
  end delete_orphaned;  
 
end;
/