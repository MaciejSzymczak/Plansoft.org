create or replace package planner_utils AUTHID CURRENT_USER is

   /*
   Toolkit
   @version 2025.09.17
   @author Maciej Szymczak
   */

  exc_API_ver_error    number := -20000; --API version error
  exc_wrong_owner_name number := -20001; --Wrong owner name
  exc_lecgrorom_null   number := -20002; --Class without lecturer and group and resource
   
  classes_selected_count number := -1;

  -- output parameters do not work in BDE: Ora-6502 String buffer is to small; no return value is passed
  -- I use this workaround   
  output_param_char1 varchar2(1000);
  output_param_char2 varchar2(1000);
  output_param_char3 varchar2(1000);
  output_param_num1  number; 
  output_param_num2  number;
  output_param_num3  number;
  output_param_num4  number;
  output_param_num5  number;
  output_param_num6  number;
  output_param_num7  number;
  output_param_num8  number;
  output_param_num9  number;
  output_param_num10 number;

   
  -- parametry diagnostyczne dla procedury
  last_error             varchar2(1000);
  last_cnt               number;
  last_orguni_id         number;
  last_lec_id            number;
  last_for_id            number;

  last_ffid              number;
  last_formula           varchar2(1000);
  last_horus             number;
  last_number_of_peoples number;

  procedure enable_trial;
  procedure disable_trial;

  procedure insert_classes(pday            date
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
                        );

  procedure insert_dependency_classes (pres_id number, pres_type varchar2, pper_id number, pcleanUpMode varchar2 default null);
  procedure update_lgrs;

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

  /*
   funkcja zwraca wartosc wspólczynnika dla zajecia wyliczonego za pomoca odnalezionej formuly.
   funkcja zwraca zero, jezeli wystapi blad.
   algotytm wyznaczania formuly:
   dla kazdego wykladowcy:
     pobierz formule na dzien i wylicz wartosc formuly. podstaw liczba studentów = liczba wszystkich studentów sposród grup w zajeciu.
     jezeli nie znaleziono formuly, pobierz formule dla jednostki nadrzednej. powtórz operacje az do odnalezienia formuly lub wystapienia bledu.
   jezeli dla poszczególnych wykladowców wspólczynniki róznia sie, wówczas zglos blad.

   w przypadku bledu funkcja zwraca wartosc 0. komunikat o bledzie odczytaj wówczas za pomoca funkcji get_last_error. w celu diagnostyki bledu sprawdz zmienne o nazwach zaczynajacych sie od last
  */
  function get_class_coeffficient ( aid number, aform_formula_type varchar2, aday date default sysdate) return number;
  function get_last_error return varchar2;
  function get_class_coeffficient_tester ( aid number, aform_formula_type varchar2, aday date default sysdate) return varchar2;
  
  function get_output_param_char1 return varchar2;
  function get_output_param_char2 return varchar2;
  function get_output_param_char3 return varchar2;
  function get_output_param_num1  return number;
  function get_output_param_num2  return number;
  function get_output_param_num3  return number;
  function get_output_param_num4  return number;
  function get_output_param_num5  return number;
  function get_output_param_num6  return number;
  function get_output_param_num7  return number;
  function get_output_param_num8  return number;
  function get_output_param_num9  return number;
  function get_output_param_num10 return number;

  function get_session_id return number;
    
  

  -- returns error_message (is any) by get_output_param_char1 
  --         copied records         by get_output_param_num1
  --         conflict records       by get_output_param_num2
  procedure copy_data_v2(source_date_from date
                    , source_date_to   date
                    , dest_date_from   date
                    , dest_period_must_be_empty varchar2
                    , own_classes      varchar2
                    , planner_id       number
                    , selected_lec_id  number default -1
                    , selected_gro_id  number default -1
                    , selected_res_id  number default -1
                    , replace_with_Id  number default -1
                    , CopyC            varchar2
                    , CopyR            varchar2
                    , overlapAllowed   varchar2
                    , copyAllOrNothing varchar2
                    );

  -- *** DEPRECIATED. USE copy_data_v2 instead
  procedure copy_data(source_date_from date
                    , source_date_to   date
                    , dest_date_from   date
                    , dest_period_must_be_empty varchar2
                    , own_classes      varchar2
                    , planner_id       number
                    , selected_lec_id  number default -1
                    , selected_gro_id  number default -1
                    , selected_res_id  number default -1
                    );

  --
  -- returns classes_deleted by 
  --         classes_deleted - get_output_param_num1
  --         lec_deleted     - get_output_param_num2
  --         gro_deleted     - get_output_param_num3
  --         rom_deleted     - get_output_param_num4
  --         sub_deleted     - get_output_param_num5
  --         per_deleted     - get_output_param_num6                    
   procedure preview_before_purge_data 
                       (pdate_from date, pdate_to date
                       , del_lec_flag varchar2, del_gro_flag varchar2, del_rom_flag varchar2, del_sub_flag varchar2, del_per_flag varchar2
                       --, classes_deleted out number, lec_deleted out number, gro_deleted out number, rom_deleted out number, sub_deleted out number, per_deleted out number
                       ,session_id number
                       );
   procedure purge_data (pdate_from date, pdate_to date
                       , del_lec_flag varchar2, del_gro_flag varchar2, del_rom_flag varchar2, del_sub_flag varchar2, del_per_flag varchar2
                       --, classes_deleted out number, lec_deleted out number, gro_deleted out number, rom_deleted out number, sub_deleted out number, per_deleted out number
                       , test_flag varchar2 default 'N');
                       
                       
   procedure merge_RES (save_id number, delete_id number, administrator_merging varchar2);                    
   procedure merge_LEC (save_id number, delete_id number, administrator_merging varchar2);                    
   procedure merge_GRO (save_id number, delete_id number, administrator_merging varchar2);        
   procedure merge_SUB (save_id number, delete_id number, administrator_merging varchar2);        
   procedure merge_FOR (save_id number, delete_id number, administrator_merging varchar2);        
   
   function  insert_str_elem ( pparent_id number, pchild_id number, pstr_name_lov varchar2 default 'STREAM', pexclusive_parent varchar2) return varchar2;           
   procedure insert_str_elem ( pparent_id number, pchild_id number, pstr_name_lov varchar2 default 'STREAM', pexclusive_parent varchar2);           

  -- zwraca wolny atrybut albo null
  --   
  function  flexGetFieldName (pmax_flex_num number, pform_name varchar2, pcontext_name varchar2, pfield_type varchar2 default 'S') return varchar2;

  function get_available_lec ( plec_id number ) return number;
  function get_available_gro ( pgro_id number ) return number;
  function get_available_rom ( prom_id number ) return number;

  function get_classes_selected_count return number;
    
  -- since wm_concat does not exist in Oracle10g  
  function get_group_types (pclass_id number) return varchar2;
  
  function killSessions return varchar2;
  
  FUNCTION get_excluded_res_ids(p1 IN VARCHAR2) RETURN VARCHAR2;
  PROCEDURE clone_holidays (source_per_id IN NUMBER,target_per_id    IN NUMBER,delete_target   varchar2);

end planner_utils;
/

create or replace package body planner_utils is
  deleted_class_id number := null;

  function killSessions return varchar2 is
  sessionKilled varchar2(1) := 'N';
  begin
    DBMS_APPLICATION_INFO.SET_CLIENT_INFO('CHECKING OTHER INSTANCES');
    for rec in (
      select  sid,serial#,status,username
       from gv$session
      where lower(module) = 'planowanie.exe'
        and nvl(client_info,'-') <> 'CHECKING OTHER INSTANCES'
        and username = user) loop
      begin
        execute immediate 'ALTER SYSTEM KILL SESSION '''||rec.sid||', '||rec.serial#||''' IMMEDIATE';
        sessionKilled := 'Y';
      exception
        when others then null;
      end;
    end loop;
    DBMS_APPLICATION_INFO.SET_CLIENT_INFO(null);
    return sessionKilled;
  end;

  procedure enable_trial is
  begin
    classes_history_pkg.trial_active  := true;
    forms_history_pkg.trial_active    := true;
    subjects_history_pkg.trial_active := true;
    lec_cla_history_pkg.trial_active  := true;
    gro_cla_history_pkg.trial_active  := true;
    classes_history_pkg.trial_active  := true;
    lecturers_history_pkg.trial_active:= true;
    groups_history_pkg.trial_active   := true;
    rooms_history_pkg.trial_active    := true;
  end enable_trial;

  procedure disable_trial is
  begin
    classes_history_pkg.trial_active  := false;
    forms_history_pkg.trial_active    := false;
    subjects_history_pkg.trial_active := false;
    lec_cla_history_pkg.trial_active  := false;
    gro_cla_history_pkg.trial_active  := false;
    classes_history_pkg.trial_active  := false;
    lecturers_history_pkg.trial_active:= false;
    groups_history_pkg.trial_active   := false;
    rooms_history_pkg.trial_active    := false;
  end disable_trial;


  -----------------------------------------------------------------------------------------------------------------------------------------------------
  function has_common_part(
     pa1 date default to_date('1000-01-01','yyyy-mm-dd') 
   , pa2 date default to_date('4000-12-31','yyyy-mm-dd') 
   , pb1 date default to_date('1000-01-01','yyyy-mm-dd') 
   , pb2 date default to_date('4000-12-31','yyyy-mm-dd')
   ) return varchar2 is
       a1 date;
       a2 date;
       b1 date;
       b2 date;
  begin
    a1 := nvl(pa1, to_date('1000-01-01','yyyy-mm-dd')); 
    a2 := nvl(pa2, to_date('4000-12-31','yyyy-mm-dd')); 
    b1 := nvl(pb1, to_date('1000-01-01','yyyy-mm-dd')); 
    b2 := nvl(pb2, to_date('4000-12-31','yyyy-mm-dd'));     

    -- Okres czasowy (A1,A2) ma czesc wspólna z okresem czasowym (B1,B2), gdy spelniony jest nastepujacy warunek logiczny:  
    if  (A1 >= B1 or A2 >= B1) and (A1 <= B2 or A2 <= B2)  then
      return 'Y';
    else
      return 'N';
    end if; 
  end has_common_part;

  -----------------------------------------------------------------------------------------------------------------------------------------------------
  procedure copy_data_v2(source_date_from date
                    , source_date_to   date
                    , dest_date_from   date
                    , dest_period_must_be_empty varchar2
                    , own_classes      varchar2
                    , planner_id       number
                    , selected_lec_id  number default -1
                    , selected_gro_id  number default -1
                    , selected_res_id  number default -1
                    , replace_with_Id  number default -1
                    , CopyC            varchar2
                    , CopyR            varchar2
                    , overlapAllowed   varchar2
                    , copyAllOrNothing varchar2
                    ) is
    current_class classes%rowtype;
    current_lec   lec_cla%rowtype;
    current_gro   gro_cla%rowtype;
    current_rom   rom_cla%rowtype;
    dest_date_to  date;
    offset number;
    replace_with_Dsp groups.name%type;
  begin
    if replace_with_Id is not null then
      select name into replace_with_Dsp from groups where Id=replace_with_Id;
    end if;
  
    output_param_char1 := '';
    dest_date_to := dest_date_from + to_number(source_date_to - source_date_from);

    if (overlapAllowed='N') then 
      if has_common_part(source_date_from,source_date_to,dest_date_from,dest_date_to) = 'Y' then    
        output_param_char1 := 'Okresy zródlowy i docelowy nie moga sie pokrywac';
        return;
      end if;   
    end if;

    if dest_period_must_be_empty = 'Y' then
     declare
      c number;
     begin
     select count(*) 
       into c 
       from classes
       where day between dest_date_from and dest_date_to
         and owner != 'AUTO';
     if c > 0 then
       output_param_char1 := 'Nie mozna wykonac czynnosci, poniewaz w obszarze docelowym sa juz zaplanowane zajecia. Jezeli mimo to chcesz kontynuowac, zezwól na skopiowanie odznaczajac pole wyboru na formularzu';
       return; 
     end if;
     end;  
    end if;

    output_param_num1 := 0; --sucess records
    output_param_num2 := 0; --failed records
    offset := dest_date_from - source_date_from;
    for rec in ( select * 
                   from classes 
                  where day between source_date_from and source_date_to
                    and for_id in (
                       select id from forms where kind='R' and CopyR='Y'
                       union 
                       select id from forms where kind='C' and CopyR='Y'
                    )
                    -- permissions
                    and id in 
                      (
                       select cla_id from lec_cla where lec_id in (select lec_id from lec_pla where pla_id =  planner_id and (lec_id = selected_lec_id or selected_lec_id =-1) )
                       union
                       select cla_id from gro_cla where gro_id in (select gro_id from gro_pla where pla_id =  planner_id and (gro_id = selected_gro_id or selected_gro_id =-1))
                       union
                       select cla_id from rom_cla where rom_id in (select rom_id from rom_pla where pla_id =  planner_id and (rom_id = selected_res_id or selected_res_id =-1))
                      )
               )
    loop
    savepoint roll;
    begin
      current_class := rec;
      select cla_seq.nextval into current_class.id from dual;
      current_class.day        := current_class.day + offset;
      current_class.created_by := user;
      current_class.creation_date := sysdate;
      current_class.last_updated_by := user;
      if own_classes = 'Y' then 
        current_class.owner      := user;
      end if;  
      
      if replace_with_Id is not null then
        current_class.calc_groups  := replace_with_Dsp;
        current_class.calc_gro_ids := replace_with_Id;
      end if;
      
      insert into classes values current_class;

      for rec_lec in ( select * from lec_cla where cla_id = rec.id order by id)
      loop
        current_lec := rec_lec;
        select leccla_seq.nextval into current_lec.id from dual;
        current_lec.cla_id:= current_class.id;
        current_lec.day   := current_class.day;
        insert into lec_cla values current_lec;
      end loop;

      for rec_gro in ( select * from gro_cla where cla_id = rec.id order by id)
      loop
        current_gro := rec_gro;
        select grocla_seq.nextval into current_gro.id from dual;
        current_gro.cla_id:= current_class.id;
        current_gro.day   := current_class.day;
        if replace_with_Id is not null then
          current_gro.gro_id := replace_with_Id;
        end if;
        insert into gro_cla values current_gro;
      end loop;

      for rec_rom in ( select * from rom_cla where cla_id = rec.id order by id)
      loop
        current_rom := rec_rom;
        select romcla_seq.nextval into current_rom.id from dual;
        current_rom.cla_id:= current_class.id;
        current_rom.day   := current_class.day;
        insert into rom_cla values current_rom;
      end loop;

    output_param_num1 := output_param_num1 + 1;  
    exception
      when others then 
        if copyAllOrNothing='Y' then raise; end if;
        output_param_num2 := output_param_num2 + 1;
        rollback to savepoint roll;
        -- .. and proceed
    end;
    end loop;
  end;


  -----------------------------------------------------------------------------------------------------------------------------------------------------
  -- *** DEPRECIATED. USE copy_data_v2 instead
  procedure copy_data(source_date_from date
                    , source_date_to   date
                    , dest_date_from   date
                    , dest_period_must_be_empty varchar2
                    , own_classes      varchar2
                    , planner_id       number
                    , selected_lec_id  number default -1
                    , selected_gro_id  number default -1
                    , selected_res_id  number default -1
                    ) is
    current_class classes%rowtype;
    current_lec   lec_cla%rowtype;
    current_gro   gro_cla%rowtype;
    current_rom   rom_cla%rowtype;
    dest_date_to  date;
    offset number;
  begin
    output_param_char1 := '';
    dest_date_to := dest_date_from + to_number(source_date_to - source_date_from);

    if has_common_part(source_date_from,source_date_to,dest_date_from,dest_date_to) = 'Y' then    
      output_param_char1 := 'Okresy zródlowy i docelowy nie moga sie pokrywac';
      return;
    end if;   

    if dest_period_must_be_empty = 'Y' then
     declare
      c number;
     begin
     select count(*) 
       into c 
       from classes
       where day between dest_date_from and dest_date_to
         and owner != 'AUTO';
     if c > 0 then
       output_param_char1 := 'Nie mozna wykonac czynnosci, poniewaz w obszarze docelowym sa juz zaplanowane zajecia. Jezeli mimo to chcesz kontynuowac, zezwól na skopiowanie odznaczajac pole wyboru na formularzu';
       return; 
     end if;
     end;  
    end if;

    output_param_num1 := 0; --sucess records
    output_param_num2 := 0; --failed records
    offset := dest_date_from - source_date_from;
    for rec in ( select * 
                   from classes 
                  where day between source_date_from and source_date_to
                    -- permissions
                    and id in 
                      (
                       select cla_id from lec_cla where lec_id in (select lec_id from lec_pla where pla_id =  planner_id and (lec_id = selected_lec_id or selected_lec_id =-1) )
                       union
                       select cla_id from gro_cla where gro_id in (select gro_id from gro_pla where pla_id =  planner_id and (gro_id = selected_gro_id or selected_gro_id =-1))
                       union
                       select cla_id from rom_cla where rom_id in (select rom_id from rom_pla where pla_id =  planner_id and (rom_id = selected_res_id or selected_res_id =-1))
                      )
               )
    loop
    savepoint roll;
    begin
      current_class := rec;
      select cla_seq.nextval into current_class.id from dual;
      current_class.day        := current_class.day + offset;
      current_class.created_by := user;
      if own_classes = 'Y' then 
        current_class.owner      := user;
      end if;  
      insert into classes values current_class;

      for rec_lec in ( select * from lec_cla where cla_id = rec.id order by id)
      loop
        current_lec := rec_lec;
        select leccla_seq.nextval into current_lec.id from dual;
        current_lec.cla_id:= current_class.id;
        current_lec.day   := current_class.day;
        insert into lec_cla values current_lec;
      end loop;

      for rec_gro in ( select * from gro_cla where cla_id = rec.id order by id)
      loop
        current_gro := rec_gro;
        select grocla_seq.nextval into current_gro.id from dual;
        current_gro.cla_id:= current_class.id;
        current_gro.day   := current_class.day;
        insert into gro_cla values current_gro;
      end loop;

      for rec_rom in ( select * from rom_cla where cla_id = rec.id order by id)
      loop
        current_rom := rec_rom;
        select romcla_seq.nextval into current_rom.id from dual;
        current_rom.cla_id:= current_class.id;
        current_rom.day   := current_class.day;
        insert into rom_cla values current_rom;
      end loop;

    output_param_num1 := output_param_num1 + 1;  
    exception
      when others then 
        output_param_num2 := output_param_num2 + 1;
        rollback to savepoint roll;
        -- .. and proceed
    end;
    end loop;
  end;

  -----------------------------------------------------------------------------------------------------------------------------------------------------
  procedure purge_data (pdate_from date, pdate_to date
                       , del_lec_flag varchar2, del_gro_flag varchar2, del_rom_flag varchar2, del_sub_flag varchar2, del_per_flag varchar2
                       --, classes_deleted out number, lec_deleted out number, gro_deleted out number, rom_deleted out number, sub_deleted out number, per_deleted out number
                       , test_flag varchar2 default 'N') is
    classes_deleted number;
    lec_deleted number;
    gro_deleted number; 
    rom_deleted number; 
    sub_deleted number; 
    per_deleted number;                  
  begin
   if del_lec_flag = 'Y' then
     delete from tmp_numbers;
     insert into tmp_numbers
       select unique lec_id from
       (
        select lec_id from lec_cla where cla_id in ( select id from classes where day between pdate_from and pdate_to )
        minus
        select lec_id from lec_cla where cla_id not in ( select id from classes where day between pdate_from and pdate_to )
       );       
     lec_deleted := sql%rowcount;
     if test_flag = 'N' then
       delete from lec_cla   where lec_id in (select id from tmp_numbers  );
       delete from lec_pla   where lec_id in (select id from tmp_numbers  );
       delete from str_elems where child_id in  (select id from tmp_numbers  );
       delete from str_elems where parent_id in  (select id from tmp_numbers  );
       delete from lecturers where id in (select id from tmp_numbers  );
     end if;
   end if;

   if del_gro_flag = 'Y' then
     delete from tmp_numbers;
     insert into tmp_numbers
       select unique gro_id from
       (
        select gro_id from gro_cla where cla_id in ( select id from classes where day between pdate_from and pdate_to )       
        minus
        select gro_id from gro_cla where cla_id not in ( select id from classes where day between pdate_from and pdate_to )
       );       
     gro_deleted := sql%rowcount;
     if test_flag = 'N' then
      delete from gro_cla   where gro_id in (select id from tmp_numbers  );
      delete from gro_pla   where gro_id in (select id from tmp_numbers  );
      delete from str_elems where child_id in  (select id from tmp_numbers  );
      delete from str_elems where parent_id in  (select id from tmp_numbers  );
      delete from groups    where id in (select id from tmp_numbers  );
     end if;
   end if;

   if del_rom_flag = 'Y' then
     delete from tmp_numbers;
     insert into tmp_numbers
       select unique rom_id from
       (
        select rom_id from rom_cla where cla_id in ( select id from classes where day between pdate_from and pdate_to )       
        minus
        select rom_id from rom_cla where cla_id  not  in ( select id from classes where day between pdate_from and pdate_to )
       );       
     rom_deleted := sql%rowcount;
     if test_flag = 'N' then
      delete from rom_cla   where rom_id in (select id from tmp_numbers  );
      delete from rom_pla   where rom_id in (select id from tmp_numbers  );
      delete from str_elems where child_id in  (select id from tmp_numbers  );
      delete from str_elems where parent_id in  (select id from tmp_numbers  );
      delete from rooms    where id in (select id from tmp_numbers  );
     end if;
   end if;

   if test_flag = 'N' then
     -- lec_cla, gro_cla, rom_cla are not cleared cascadely due defferable relation    
     delete from lec_cla where cla_id in (select id from classes where day between pdate_from and pdate_to);
     delete from gro_cla where cla_id in (select id from classes where day between pdate_from and pdate_to);
     delete from rom_cla where cla_id in (select id from classes where day between pdate_from and pdate_to);
     -- tt_cla is cleared cascadely     
     delete 
       from classes 
      where day between pdate_from and pdate_to;
     classes_deleted := sql%rowcount;
   else
     select count(1) into classes_deleted 
       from classes 
      where day between pdate_from and pdate_to;
     --delete 
     --  from classes 
     -- where day between pdate_from and pdate_to;
     --classes_deleted := sql%rowcount;
     -- raise_application_error(-20000, 'classes_deleted:'||classes_deleted ||' '|| to_char(pdate_from,'yyyy-mm-dd') ||' '|| to_char(pdate_to,'yyyy-mm-dd'));
   end if;  

   if del_sub_flag = 'Y' then
     delete from tmp_numbers;
     insert into tmp_numbers
       select unique sub_id from
       (
        select sub_id from classes where day between pdate_from and pdate_to       
        minus
        select sub_id from classes where day not between pdate_from and pdate_to
       );       
     sub_deleted := sql%rowcount;
     if test_flag = 'N' then
      delete from subjects where id in (select id from tmp_numbers  );
     end if;
   end if;

   if del_per_flag = 'Y' then
     if test_flag = 'N' then
       delete from periods where pdate_from <= date_from and pdate_to >= date_to;  
       per_deleted := sql%rowcount;
     else
       select count(*) into per_deleted from periods where pdate_from <= date_from and pdate_to >= date_to;  
     end if;  
   end if;

   output_param_num1 := classes_deleted;
   output_param_num2 := lec_deleted;
   output_param_num3 := gro_deleted; 
   output_param_num4 := rom_deleted; 
   output_param_num5 := sub_deleted; 
   output_param_num6 := per_deleted;         
  end;

  -----------------------------------------------------------------------------------------------------------------------------------------------------
  procedure preview_before_purge_data 
                       (pdate_from date, pdate_to date
                       , del_lec_flag varchar2, del_gro_flag varchar2, del_rom_flag varchar2, del_sub_flag varchar2, del_per_flag varchar2
                       --, classes_deleted out number, lec_deleted out number, gro_deleted out number, rom_deleted out number, sub_deleted out number, per_deleted out number
                       ,session_id number
                       )
  is                     
  begin
    delete from tmp_varchar2 where sessionid = session_id and param='LEC';
    delete from tmp_varchar2 where sessionid = session_id and param='GRO';
    delete from tmp_varchar2 where sessionid = session_id and param='RES';
    delete from tmp_varchar2 where sessionid = session_id and param='SUB';
    delete from tmp_varchar2 where sessionid = session_id and param='PER';

    insert into tmp_varchar2 (sessionid, param, value)
      select session_id,'LEC',
             substr(first_name || ' ' || last_name,1,240) 
        from lecturers
       where id in 
         (
           select lec_id from lec_cla where cla_id in ( select id from classes where day between pdate_from and pdate_to )
           minus
           select lec_id from lec_cla where cla_id not in ( select id from classes where day between pdate_from and pdate_to )       
         );     

    insert into tmp_varchar2 (sessionid, param, value)
      select session_id,'GRO'
             ,substr(name ,1,240)
        from groups
       where id in 
         (
           select gro_id from gro_cla where cla_id in ( select id from classes where day between pdate_from and pdate_to )
           minus
           select gro_id from gro_cla where cla_id not in ( select id from classes where day between pdate_from and pdate_to )       
         );     

    insert into tmp_varchar2 (sessionid, param, value)
      select session_id,'RES'
            ,substr(name ,1,240)
        from rooms
       where id in 
         (
           select rom_id from rom_cla where cla_id in ( select id from classes where day between pdate_from and pdate_to )
           minus
           select rom_id from rom_cla where cla_id not in ( select id from classes where day between pdate_from and pdate_to )       
         );     

    insert into tmp_varchar2 (sessionid, param, value)
      select session_id,'SUB'
            ,substr(name ,1,240)
        from subjects
        where id in
         (
          select sub_id from classes where day between pdate_from and pdate_to       
          minus
          select sub_id from classes where day not between pdate_from and pdate_to
         );           

    insert into tmp_varchar2 (sessionid, param, value)
      select session_id,'PER'
            ,substr(name ,1,240)
        from periods
        where pdate_from <= date_from and pdate_to >= date_to;

    purge_data (pdate_from, pdate_to                       
              , del_lec_flag, del_gro_flag, del_rom_flag, del_sub_flag, del_per_flag
              --, classes_deleted, lec_deleted, gro_deleted, rom_deleted, sub_deleted, per_deleted
              , 'Y' /*test_flag*/  );
  end;


  -----------------------------------------------------------------------------------------------------------------------------------------------------
  procedure calculate_lgr(     
     cla_id      number,
     l       out classes.calc_lecturers%type,
     g       out classes.calc_groups%type,
     r       out classes.calc_rooms%type,
     l_id    out classes.calc_lec_ids%type,
     g_id    out classes.calc_gro_ids%type,
     r_id    out classes.calc_rom_ids%type,
     r_resid out classes.calc_rescat_ids%type
   );

  -----------------------------------------------------------------------------------------------------------------------------------------------------
  procedure insert_classes(pday              date
                         ,phour             number
                         ,pfill             number
                         ,psub_id           number
                         ,pfor_id           number
                         ,powner            varchar2 default null
                         ,pcalc_lec_ids     varchar2
                         ,pcalc_gro_ids     varchar2
                         ,pcalc_rom_ids     varchar2
                         ,pcolour           number   default null
                         ,pdesc1            varchar2 default null
                         ,pdesc2            varchar2 default null
                         ,pdesc3            varchar2 default null
                         ,pdesc4            varchar2 default null
                         ,ptt_comb_ids      varchar2 default null
                         ,pcalc_lecturers   varchar2 default null
                         ,pcalc_groups      varchar2 default null
                         ,pcalc_rooms       varchar2 default null
                         ,pcreator          varchar2 default null
                         ,prefreshLGR       varchar2 default 'Y'
                         ,pgrantPermissions varchar2 default 'N'
                         ,pcalc_rescat_ids  varchar2 default null --@@@todo: this parameter should be passed by interface
                        ) is

    vcalc_lecturers  classes.calc_lecturers%type := pcalc_lecturers;
    vcalc_groups     classes.calc_groups%type := pcalc_groups;
    vcalc_rooms      classes.calc_rooms%type := pcalc_rooms;
    vcalc_lec_ids    classes.calc_lec_ids%type := pcalc_lec_ids;
    vcalc_gro_ids    classes.calc_gro_ids%type := pcalc_gro_ids;
    vcalc_rom_ids    classes.calc_rom_ids%type := pcalc_rom_ids;
    vcalc_rescat_ids classes.calc_rescat_ids%type := pcalc_rescat_ids;
    pno_conflict_flag varchar2(1) := null;

    cla_seq_nextval number;
    t               number;
    debug_cnt       number := 0;
    procedure auto_grant_permissions is
    --used by public API
    --adds automatically permissions to owner
    --creator can be external user, so permissions to creator are not granted
      ppla_id number;
    begin
      select id into ppla_id from planners where name = powner;
      for t in 1 .. xxmsz_tools.wordcount(pcalc_lec_ids, ';') loop
        begin
          insert into lec_pla (id,pla_id,lec_id) values (lecpla_seq.nextval,ppla_id,xxmsz_tools.extractword(t,pcalc_lec_ids,';'));
        exception
         when dup_val_on_index then null;
        end;
      end loop;
      for t in 1 .. xxmsz_tools.wordcount(pcalc_gro_ids, ';') loop
        begin
          insert into gro_pla (id,pla_id,gro_id) values (gropla_seq.nextval,ppla_id,xxmsz_tools.extractword(t,pcalc_gro_ids,';'));
        exception
         when dup_val_on_index then null;
        end;
      end loop;
      for t in 1 .. xxmsz_tools.wordcount(pcalc_rom_ids, ';') loop
        begin
          insert into rom_pla (id,pla_id,rom_id) values (rompla_seq.nextval,ppla_id,xxmsz_tools.extractword(t,pcalc_rom_ids,';'));
        exception
         when dup_val_on_index then null;
        end;
      end loop;
      begin
        insert into sub_pla (id,pla_id,sub_id) values (subpla_seq.nextval,ppla_id,psub_id);       
      exception
       when dup_val_on_index then null;
      end;
      begin
        insert into for_pla (id,pla_id,for_id) values (forpla_seq.nextval,ppla_id,pfor_id); 
      exception
       when dup_val_on_index then null;
      end;
    end;
    --procedure debug ( m varchar2 ) is begin
    --  insert into xxmsztools_eventlog (id, message) values (xxmsztools_eventlog_seq.nextval, m);
    --  commit;
    --end;

      ----------------------------------------------
    procedure IdsIntoHelper (lec varchar2, gro varchar2, res varchar2, sub varchar2, frm varchar2) is
      ids  t_number_list := NEW t_number_list();
      cnt  number;
      tmp  varchar2(4000);
    begin
      delete from HELPER_RES;          
      tmp := Xxmsz_Tools.merge(lec, gro, ';');
      tmp := Xxmsz_Tools.merge(tmp, res, ';');
      tmp := Xxmsz_Tools.merge(tmp, sub, ';');
      tmp := Xxmsz_Tools.merge(tmp, frm, ';');          
      for t in 1 .. xxmsz_tools.wordcount(tmp, ';') loop
          cnt:=nvl(ids.last,0)+1;
          ids.extend;
          ids(cnt) := xxmsz_tools.extractword(t,tmp,';');
      end loop;          
      insert into HELPER_RES (id)
      select value(x) from table(ids) x;
      ids.delete;
    end;
    ----------------------------------------------
    procedure check_locks is 
    begin
      IdsIntoHelper (pcalc_lec_ids, pcalc_gro_ids,pcalc_rom_ids,'','' );
       for rec in (
            select (select title||' '||last_name||' '||first_name from lecturers where id=timetable_notes.res_id) 
                || (select nvl(abbreviation, name) from groups where id=timetable_notes.res_id)
                || (select name from rooms where id=timetable_notes.res_id)
                   name 
                 , LOCKED_BY
                 , locked_reason 
                 , (select name from periods where id = timetable_notes.per_id) period_name
              from timetable_notes 
             where locked_by is not null
               --time table found by pday
               and per_id in (select id from periods where pday between date_from and date_to)
               and res_id in (select id from HELPER_RES) 
               -- user is not the locker
               and instr(';'||locked_by,';'||user)=0                 
            ) loop
         raise_application_error(-20000, 'Planowanie zajec w terminie '||to_char(pday,'yyyy-mm-dd')||' dla '||rec.name||' zostalo zablokowane w semestrze "'|| rec.period_name||'" przez uzytkownika '||rec.locked_by||' z powodu '||rec.locked_reason);                 
       end loop;   
    end;
    

  ----------------------------------------------
  function addOwners (owners varchar2, lec varchar2, gro varchar2, res varchar2, sub varchar2, frm varchar2) return varchar2 is 
    out_owners varchar2(1000) := owners;
  begin
      IdsIntoHelper(lec, gro, res, sub, frm);
      out_owners := replace(';'||owners,' ','');
      for rec in (select unique pla.name from owners, planners pla where owners.pla_id = pla.id and res_id in (select id from HELPER_RES)) loop
        if INSTR(out_owners, ';'||rec.name) = 0 then
          out_owners := out_owners || ';' || rec.name;
        end if;
      end loop;
      select substr(out_owners,2,2000) into out_owners from dual;
    return out_owners;
  end addOwners;

  ----------------------------------------------------------------------------------------  
  begin

    if (psub_id=-1 or psub_id=-2) then
      pno_conflict_flag := '+';
    else
        -- prevent from planning in locked periods
        for rec in (
          select * 
            from periods
           where pday between date_from and date_to
             and locked_flag = '+'
             and created_by <> user 
             and rownum =1
        )
        loop
          raise_application_error(-20000, 'Planowanie zajec w terminie od '||to_char(rec.date_from,'yyyy-mm-dd')||' do '||to_char(rec.date_to,'yyyy-mm-dd')||' zostalo zablokowane przez uzytkownika '||rec.created_by);
        end loop;   
        check_locks;
        --
        if pgrantPermissions = 'Y' then auto_grant_permissions; end if;
    end if;

    cla_seq_nextval := null;
    if deleted_class_id is not null then
      -- use the same id, thus update will return the same id
      -- rollback could restore the record
      declare
       c number;
      begin
       select count(1) into c from classes where id = deleted_class_id and rownum = 1;
       if c = 0 then 
          cla_seq_nextval := deleted_class_id;
          deleted_class_id := null; 
       end if;
      end;
    end if;
    --
    if cla_seq_nextval is null then 
      select cla_seq.nextval
        into cla_seq_nextval
        from dual;
    end if;    

    output_param_num1 := cla_seq_nextval;     

    --declare
    --  c number;
    --begin
    --  select count(1) into c from lec_cla where lec_id = 4006793 and day = date'2012-12-24' and hour=2;
      --raise_application_error(-20000, 'trace=' || c );
    --end;


    declare
      plec_id number;
      desc1Cnt number := xxmsz_tools.wordcount(pdesc1,',');
      desc2Cnt number := xxmsz_tools.wordcount(pdesc2,',');
      desc3Cnt number := xxmsz_tools.wordcount(pdesc3,',');
      desc4Cnt number := xxmsz_tools.wordcount(pdesc4,',');
      lecsCnt  number := xxmsz_tools.wordcount(pcalc_lec_ids, ';');
      lecdesc1 varchar2(200);
      lecdesc2 varchar2(200);
      lecdesc3 varchar2(200);
      lecdesc4 varchar2(200);
      ----------------------------------------------
      function getLecDesc(descCnt number, pdesc varchar2, t number) return varchar2 is begin
        case when descCnt = 1       then return pdesc;
             when descCnt = lecsCnt then return xxmsz_tools.extractword(t,pdesc,',');
             else return null;
        end case;     
      end;
    begin      
      for t in 1 .. lecsCnt loop
        plec_id := xxmsz_tools.extractword(t,pcalc_lec_ids,';');
        lecdesc1 := getLecDesc(desc1Cnt, pdesc1, t);
        lecdesc2 := getLecDesc(desc2Cnt, pdesc2, t);
        lecdesc3 := getLecDesc(desc3Cnt, pdesc3, t);
        lecdesc4 := getLecDesc(desc4Cnt, pdesc4, t);
        insert into lec_cla (id, lec_id, cla_id, is_child, day, hour, desc1, desc2, desc3, desc4,no_conflict_flag) values (leccla_seq.nextval,plec_id,cla_seq_nextval, 'N', pday, phour
        , lecdesc1, lecdesc2, lecdesc3, lecdesc4, pno_conflict_flag);    

      -- "and pno_conflict_flag is null" means "do not add child records when you create an alert record" 
      if pno_conflict_flag is null then
          for rec in (
              select child_id
                from str_elems
                where level=1 and STR_NAME_LOV='STREAM'
                    and exclusive_parent = '+'
                CONNECT BY PRIOR STR_NAME_LOV='STREAM' and prior child_id = parent_id  and exclusive_parent = '+'
                start with parent_id= xxmsz_tools.extractword(t,pcalc_lec_ids,';')          
           )
          loop
            if instr(pcalc_lec_ids,rec.child_id)=0 then 
                insert into lec_cla (id, lec_id, cla_id, is_child, day, hour,no_conflict_flag, parent_id) values (leccla_seq.nextval,rec.child_id,cla_seq_nextval, 'Y', pday, phour,pno_conflict_flag, xxmsz_tools.extractword(t,pcalc_lec_ids,';') );   
            end if;
          end loop;
      end if;

      end loop;
    --exception
    --  when others then
    --    raise_application_error(-20000, 'lec='||plec_id||' day='||to_char(pday,'yyyy-mm-dd')||' hour='||phour);
    end;  

    for t in 1 .. xxmsz_tools.wordcount(pcalc_gro_ids, ';') loop
      insert into gro_cla (id, gro_id, cla_id, is_child, day, hour,no_conflict_flag) values (grocla_seq.nextval,xxmsz_tools.extractword(t,pcalc_gro_ids,';'),cla_seq_nextval, 'N', pday, phour,pno_conflict_flag);   
      if pno_conflict_flag is null then
          for rec in (
              select child_id
                from str_elems
                where level=1 and STR_NAME_LOV='STREAM' and exclusive_parent = '+'
                CONNECT BY PRIOR STR_NAME_LOV='STREAM' and prior child_id = parent_id  and exclusive_parent = '+'
                start with parent_id= xxmsz_tools.extractword(t,pcalc_gro_ids,';')          
           )
          loop
            if instr(pcalc_gro_ids,rec.child_id)=0  then 
                    insert into gro_cla (id, gro_id, cla_id, is_child, day, hour,no_conflict_flag, parent_id) values (grocla_seq.nextval,rec.child_id,cla_seq_nextval, 'Y', pday, phour,pno_conflict_flag, xxmsz_tools.extractword(t,pcalc_gro_ids,';'));   
            end if;
          end loop;
      end if;
    end loop;

    for t in 1 .. xxmsz_tools.wordcount(pcalc_rom_ids, ';') loop
      insert into rom_cla (id, rom_id, cla_id, is_child, day, hour,no_conflict_flag) values (romcla_seq.nextval,xxmsz_tools.extractword(t,pcalc_rom_ids,';'),cla_seq_nextval,'N', pday, phour,pno_conflict_flag);
      if pno_conflict_flag is null then
          for rec in (
              select child_id
                from str_elems
                where level=1 and STR_NAME_LOV='STREAM' and exclusive_parent = '+'
                CONNECT BY PRIOR STR_NAME_LOV='STREAM' and prior child_id = parent_id  and exclusive_parent = '+' 
                start with parent_id= xxmsz_tools.extractword(t,pcalc_rom_ids,';')          
           )
          loop
            if instr(pcalc_rom_ids,rec.child_id)=0  then 
                insert into rom_cla (id, rom_id, cla_id, is_child, day, hour,no_conflict_flag, parent_id) values (romcla_seq.nextval,rec.child_id,cla_seq_nextval, 'Y', pday, phour,pno_conflict_flag, xxmsz_tools.extractword(t,pcalc_rom_ids,';'));   
            end if;
          end loop;
      end if;
    end loop;

    if prefreshLGR = 'Y' then calculate_lgr(cla_seq_nextval, vcalc_lecturers, vcalc_groups, vcalc_rooms, vcalc_lec_ids, vcalc_gro_ids, vcalc_rom_ids, vcalc_rescat_ids); end if;

    declare
     eOwners varchar2(4000) := addOwners (powner, vcalc_lec_ids, vcalc_gro_ids, vcalc_rom_ids, psub_id, pfor_id);
    begin
        insert into classes
                    (id             , day  ,hour  ,fill  ,sub_id  ,for_id  ,owner  ,calc_lec_ids , calc_gro_ids , calc_rom_ids , calc_lecturers , calc_groups , calc_rooms , created_by        , colour  , desc1, desc2, desc3, desc4, calc_rescat_ids)
             values (cla_seq_nextval, pday ,phour ,pfill ,psub_id ,pfor_id ,eOwners,vcalc_lec_ids, vcalc_gro_ids, vcalc_rom_ids, vcalc_lecturers, vcalc_groups, vcalc_rooms, nvl(pcreator,user), pcolour ,pdesc1,pdesc2,pdesc3,pdesc4, vcalc_rescat_ids);
    end;

    if ptt_comb_ids is not null then
      declare
       l_tt_comb_ids  varchar2(4000) := replace(ptt_comb_ids,';',',');
       l_comb_id      number; 
       l_duration     number;
      begin
        select duration into l_duration from grids where no = phour;
        for t in 1 .. xxmsz_tools.wordcount( l_tt_comb_ids, ',') loop
          l_comb_id := regexp_substr(l_tt_comb_ids, '([0-9]|[-])+', 1, t/*get t-th element*/); 
          tt_planner.book_combination ( l_comb_id, pfill/100 * l_duration );
          insert into tt_cla (id, cla_id, tt_comb_id, units) values (tt_seq.nextval, cla_seq_nextval, l_comb_id, pfill/100);
        end loop;  
      end;
    end if;  


  end insert_classes;

  -----------------------------------------------------------------------------------------------------------------------------------------------------
  procedure update_lgrs is
  begin
    disable_trial;
    update classes
         set    
         calc_lecturers = 
            (select listagg(abbreviation,'; ') WITHIN GROUP (ORDER BY lec_cla.id)
             from lecturers l,lec_cla  
             where l.id =lec_id and is_child = 'N' and cla_id=classes.id)
          ,calc_groups    = 
            (select listagg(abbreviation,'; ') WITHIN GROUP (ORDER BY gro_cla.id)
             from groups g, gro_cla 
             where g.id =gro_id and is_child = 'N' and cla_id=classes.id)
         ,calc_rooms     = 
            (select listagg(r.name||' '||r.attribs_01,'; ') WITHIN GROUP (ORDER BY rom_cla.id)
             from rooms r, rom_cla
             where r.id = rom_id and is_child = 'N' and  cla_id=classes.id)
         ,calc_lec_ids   = 
            (select listagg(l.id,';') WITHIN GROUP (ORDER BY lec_cla.id)
             from lecturers l,lec_cla  
             where l.id =lec_id and is_child = 'N' and cla_id=classes.id)
         ,calc_gro_ids   = 
            (select listagg(g.id,';') WITHIN GROUP (ORDER BY gro_cla.id)
             from groups g, gro_cla 
             where g.id =gro_id and is_child = 'N' and cla_id=classes.id)
         ,calc_rom_ids   = 
            (select listagg(r.id,';') WITHIN GROUP (ORDER BY rom_cla.id)
             from rooms r, rom_cla
             where r.id = rom_id and is_child = 'N' and  cla_id=classes.id)
         ,calc_rescat_ids= 
            (select listagg(r.rescat_id,';') WITHIN GROUP (ORDER BY rom_cla.id)
             from rooms r, rom_cla
             where r.id = rom_id and is_child = 'N' and  cla_id=classes.id)
     where             
          nvl(calc_lecturers,'null') <> 
            nvl((select listagg(abbreviation,'; ') WITHIN GROUP (ORDER BY lec_cla.id)
             from lecturers l,lec_cla  
             where l.id =lec_id and is_child = 'N' and cla_id=classes.id),'null') 
          or nvl(calc_groups,'null')    <> 
            nvl((select listagg(abbreviation,'; ') WITHIN GROUP (ORDER BY gro_cla.id)
             from groups g, gro_cla 
             where g.id =gro_id and is_child = 'N' and cla_id=classes.id),'null') 
         or nvl(calc_rooms,'null')     <> 
            nvl((select listagg(r.name||' '||r.attribs_01,'; ') WITHIN GROUP (ORDER BY rom_cla.id)
             from rooms r, rom_cla
             where r.id = rom_id and is_child = 'N' and  cla_id=classes.id),'null') 
         or nvl(calc_lec_ids,'null')   <>
            nvl((select listagg(l.id,';') WITHIN GROUP (ORDER BY lec_cla.id)
             from lecturers l,lec_cla  
             where l.id =lec_id and is_child = 'N' and cla_id=classes.id),'null') 
         or nvl(calc_gro_ids,'null')   <> 
            nvl((select listagg(g.id,';') WITHIN GROUP (ORDER BY gro_cla.id)
             from groups g, gro_cla 
             where g.id =gro_id and is_child = 'N' and cla_id=classes.id),'null') 
         or nvl(calc_rom_ids,'null')   <> 
            nvl((select listagg(r.id,';') WITHIN GROUP (ORDER BY rom_cla.id)
             from rooms r, rom_cla
             where r.id = rom_id and is_child = 'N' and  cla_id=classes.id),'null') 
         or nvl(calc_rescat_ids,'null') <> 
            nvl((select listagg(r.rescat_id,';') WITHIN GROUP (ORDER BY rom_cla.id)
             from rooms r, rom_cla
             where r.id = rom_id and is_child = 'N' and  cla_id=classes.id),'null');
     commit;
    enable_trial;
  end;

  -----------------------------------------------------------------------------------------------------------------------------------------------------
  procedure update_lgr (cla_id number) is
    l       classes.calc_lecturers%type;
    g       classes.calc_groups%type;
    r       classes.calc_rooms%type;
    l_id    classes.calc_lec_ids%type;
    g_id    classes.calc_gro_ids%type;
    r_id    classes.calc_rom_ids%type;
    r_resid classes.calc_rescat_ids%type;
  begin
     calculate_lgr(cla_id, l, g, r, l_id, g_id, r_id, r_resid);
     update classes
     set    calc_lecturers = l,
            calc_groups    = g,
            calc_rooms     = r,
            calc_lec_ids   = l_id,
            calc_gro_ids   = g_id,
            calc_rom_ids   = r_id,
            calc_rescat_ids= r_resid
     where id = cla_id;
  end;

  -----------------------------------------------------------------------------------------------------------------------------------------------------
  procedure calculate_lgr(
     cla_id number,
     l       out classes.calc_lecturers%type,
     g       out classes.calc_groups%type,
     r       out classes.calc_rooms%type,
     l_id    out classes.calc_lec_ids%type,
     g_id    out classes.calc_gro_ids%type,
     r_id    out classes.calc_rom_ids%type,
     r_resid out classes.calc_rescat_ids%type
  ) is
    cursor cur_l(pcla_id number) is
      select lec.abbreviation x
           , lec.id
        from lecturers lec
           , lec_cla
       where lec.id = lec_id 
         and is_child = 'N'
             -- params
         and cla_id = pcla_id
             -- sort by user creating order  
       order by lec_cla.id; 
    --
    cursor cur_g(pcla_id number) is
      select gro.abbreviation x
           , gro.id
        from groups gro
           , gro_cla
       where gro.id = gro_id
         and is_child = 'N'
          -- params
         and cla_id = pcla_id
       order by gro_cla.id;
    --
    cursor cur_r(pcla_id number) is
      select rom.name||' '||rom.attribs_01 x
           , rom.id
           , rom.rescat_id 
        from rooms rom
           , rom_cla
       where rom.id = rom_id
         and is_child = 'N'
          -- params
         and cla_id = pcla_id
       order by rom_cla.id;
    --
  begin
    l    := '';
    l_id := '';
    for rec_l in cur_l(cla_id) loop
     l    := xxmsz_tools.merge(l   , rec_l.x , '; ');
     l_id := xxmsz_tools.merge(l_id, rec_l.id, ';');
    end loop;
    g    := '';
    g_id := '';
    for rec_g in cur_g(cla_id) loop
     g    := xxmsz_tools.merge(g   , rec_g.x , '; ');
     g_id := xxmsz_tools.merge(g_id, rec_g.id, ';');
    end loop;
    r    := '';
    r_id := '';
    for rec_r in cur_r(cla_id) loop
     r       := xxmsz_tools.merge(r      , rec_r.x        , '; ');
     r_id    := xxmsz_tools.merge(r_id   , rec_r.id       , ';' );
     r_resid := xxmsz_tools.merge(r_resid, rec_r.rescat_id, ';' ); 
    end loop;
  end;

  -----------------------------------------------------------------------------------------------------------------------------------------------------
  procedure insert_dependency_classes (pres_id number, pres_type varchar2, pper_id number, pcleanUpMode varchar2) is
    vdate_from date;
    vdate_to date;
    pchild_names varchar2(4000) := '';
    non_exclusive_parent varchar2(1):='Y';
  begin

    select date_from, date_to into vdate_from, vdate_to from periods where id = pper_id;

       --recreate exclusive parent=-
       if (pres_type='R') then
           if  (pcleanUpMode='+') then
              for rec in (
                  select child_id
                    from str_elems
                    where level=1 and STR_NAME_LOV='STREAM' and exclusive_parent = '+'
                    CONNECT BY PRIOR STR_NAME_LOV='STREAM' and prior child_id = parent_id  and exclusive_parent = '+'
                    start with parent_id= pres_id          
               )
              loop
                if instr(pres_id,rec.child_id)=0  then
                        delete from rom_cla
                         where (rom_id, cla_id, day, hour) in (select rec.child_id,cla_id, day, hour from rom_cla where rom_id = pres_id)
                           and (is_child = 'Y' or no_conflict_flag = '+');
                        insert into rom_cla (id, rom_id, cla_id, is_child, day, hour,no_conflict_flag, parent_Id) 
                        select romcla_seq.nextval,rec.child_id,cla_id, 'Y', day, hour,null, pres_id from rom_cla 
                        where parent_id is null and rom_id = pres_id and no_conflict_flag is null; 
                end if;
              end loop;
          end if;
      end if;
      if (pres_type='G') then
           if  (pcleanUpMode='+') then
              for rec in (
                  select child_id
                    from str_elems
                    where level=1 and STR_NAME_LOV='STREAM' and exclusive_parent = '+'
                    CONNECT BY PRIOR STR_NAME_LOV='STREAM' and prior child_id = parent_id  and exclusive_parent = '+'
                    start with parent_id= pres_id          
               )
              loop
                if instr(pres_id,rec.child_id)=0  then
                        delete from gro_cla
                         where (gro_id, cla_id, day, hour) in (select rec.child_id,cla_id, day, hour from gro_cla where gro_id = pres_id)
                           and (is_child = 'Y' or no_conflict_flag = '+');
                        insert into gro_cla (id, gro_id, cla_id, is_child, day, hour,no_conflict_flag, parent_Id) 
                        select grocla_seq.nextval,rec.child_id,cla_id, 'Y', day, hour,null, pres_id from gro_cla 
                        where parent_id is null and gro_id = pres_id and no_conflict_flag is null; 
                end if;
              end loop;
          end if;
      end if;
       if (pres_type='L') then
           if  (pcleanUpMode='+') then
             for rec in (
                  select child_id
                    from str_elems
                    where level=1 and STR_NAME_LOV='STREAM' and exclusive_parent = '+'
                    CONNECT BY PRIOR STR_NAME_LOV='STREAM' and prior child_id = parent_id  and exclusive_parent = '+'
                    start with parent_id= pres_id          
               )
              loop
                if instr(pres_id,rec.child_id)=0  then
                        delete from lec_cla
                         where (lec_id, cla_id, day, hour) in (select rec.child_id,cla_id, day, hour from lec_cla where lec_id = pres_id)
                           and (is_child = 'Y' or no_conflict_flag = '+');
                        insert into lec_cla (id, lec_id, cla_id, is_child, day, hour,no_conflict_flag, parent_Id) 
                        select leccla_seq.nextval,rec.child_id,cla_id, 'Y', day, hour,null, pres_id from lec_cla 
                        where parent_id is null and lec_id = pres_id and no_conflict_flag is null;   
                end if;
              end loop;
          end if;
      end if;

    -- recreate exclusive parent=+
     delete from helper1;
     insert into helper1 (id, attribs_01)
          --childs
          (select child_id id, 'C'
            from str_elems_v
            where level=1 and STR_NAME_LOV='STREAM' 
            CONNECT BY PRIOR STR_NAME_LOV='STREAM' and prior child_id = parent_id
            start with parent_id=pres_id)
           union 
          --parents
           (select parent_id id, 'P'
              from str_elems_v
              where level=1 and STR_NAME_LOV='STREAM' 
            CONNECT BY PRIOR STR_NAME_LOV='STREAM' and prior parent_id = child_id
            start with child_id=pres_id
           );

    if (pres_type='R') then

         -- optional clean up
         -- clean up may be necesarry when the hierarchy of resources was modified
         -- as it recreates all dependencies, do not overdose this option!
         if (pcleanUpMode='+') then
           for rec in (
             --candidate to delete
             select unique cla_id
               from rom_cla
               where no_conflict_flag = '+'
                and rom_id  = pres_id 
                and day between vdate_from and vdate_to
           ) 
           loop
             delete_class (rec.cla_id);
           end loop;
         end if;    

         -- delete dependency classes with wrong description 
         for rec in (
           select * from
           (
             select existing_dep.desc2, existing_dep.id
                  , (
                    select listagg(rom.attribs_01||' '||rom.name, '; ') within group (order by rom.attribs_01||' '||rom.name)
                      from rom_cla
                         , rooms rom 
                    where no_conflict_flag is null
                     and rom_cla.rom_id = rom.id 
                       and rom_id in 
                            (select id from helper1) 
                       and day = existing_dep.day and hour = existing_dep.hour) correct_desc2
               from
                     (
                       select unique cla.id, desc2, cla.day, cla.hour
                         from rom_cla
                            , classes cla
                         where no_conflict_flag = '+'
                          and rom_cla.cla_id = cla.id
                          and rom_id  = pres_id 
                          and rom_cla.day between vdate_from and vdate_to
                      ) existing_dep
          ) where desc2 <> correct_desc2
         ) 
         loop
           delete_class (rec.id);
         end loop;

         --create child dependencies
         for rec in (
            --classes of childs
            select unique day, hour  
              from rom_cla 
            where no_conflict_flag is null
             and rom_id in 
              (select child_id id
                from str_elems_v
                where level=1 and STR_NAME_LOV='STREAM'
                connect by prior STR_NAME_LOV='STREAM' and prior child_id = parent_id
                start with parent_id = pres_id)
            and day between vdate_from and vdate_to
            --do not create dependency classes if base resource has already the classes, either own classes or dependency classes created earlier
            and (day,hour) not in 
              (select day,hour 
                from rom_cla 
                where rom_id  = pres_id 
                 and day between vdate_from and vdate_to
              )
         ) 
         loop
            select listagg(rom.attribs_01||' '||rom.name, '; ') within group (order by rom.attribs_01||' '||rom.name)
              into pchild_names
              from rom_cla
                 , rooms rom 
            where no_conflict_flag is null
             and rom_cla.rom_id = rom.id 
               and rom_id in 
                  --childs
                  (select child_id id
                    from str_elems_v
                    where level=1 and STR_NAME_LOV='STREAM'
                    connect by prior STR_NAME_LOV='STREAM' and prior child_id = parent_id
                    start with parent_id=pres_id)
               and day = rec.day and hour = rec.hour;
            insert_classes(rec.day
               ,rec.hour
               ,100
               ,-1
               ,-1
               ,'AUTO'
               ,-1 /*lec*/
               ,-1 /*gro*/
               ,pres_id /*res*/
               ,null
               ,'Zajecia podrzedne'           
               , substrb(pchild_names,1,200)
               ,null            
               ,null);            
         end loop;

         --create parent dependencies
         for rec in (
            --classes of parents
            select unique day, hour  
              from rom_cla 
            where no_conflict_flag is null
             and rom_id in 
              (select parent_id id
                 from str_elems_v
                where level=1 and STR_NAME_LOV='STREAM'
              connect by prior STR_NAME_LOV='STREAM' and prior parent_id = child_id
              start with child_id = pres_id)
            and day between vdate_from and vdate_to
            --do not create dependency classes if base resource has already the classes, either own classes or dependency classes created earlier
            and (day,hour) not in 
              (select day,hour 
                from rom_cla 
                where rom_id  = pres_id 
                 and day between vdate_from and vdate_to)) 
         loop
            select listagg(rom.attribs_01||' '||rom.name, '; ') within group (order by rom.attribs_01||' '||rom.name)
              into pchild_names
              from rom_cla
                 , rooms rom 
            where no_conflict_flag is null
              and rom_cla.rom_id = rom.id 
              and rom_id in 
                  --parents
                  (select parent_id id
                     from str_elems_v
                    where level=1 and STR_NAME_LOV='STREAM'
                  connect by prior STR_NAME_LOV='STREAM' and prior parent_id = child_id
                  start with child_id = pres_id)
              and day = rec.day and hour = rec.hour;
            insert_classes(rec.day
               ,rec.hour
               ,100
               ,-2
               ,-2
               ,'AUTO'
               ,-2 /*lec*/
               ,-2 /*gro*/
               ,pres_id /*res*/
               ,null
               ,'Zajecia nadrzedne'           
               , substrb(pchild_names,1,200)
               ,null            
               ,null);            
         end loop;

         for rec in (
           --candidate to delete
           select unique cla_id
             from rom_cla
             where no_conflict_flag = '+'
              and rom_id  = pres_id 
              and day between vdate_from and vdate_to
              --dependency no longer exists
              and (day,hour) not in 
                (        
                  select unique day, hour  
                    from rom_cla 
                  where no_conflict_flag is null
                    and rom_id in
                        (select id from helper1) 
                  and day between vdate_from and vdate_to     
                  minus
                  --delete record if class for base record exists
                  select day,hour 
                  from rom_cla 
                  where rom_id  = pres_id 
                   and no_conflict_flag is null
                   and day between vdate_from and vdate_to
               )
         ) 
         loop
           delete_class (rec.cla_id);
         end loop;

    end if; --if (pres_type='R')

    -- very similar code for groups
    if (pres_type='G') then

         -- optional clean up
         -- clean up may be necesary when the hierarchy of resources was modified
         -- as it recreates all dependencies, do not overuse this option!
         if (pcleanUpMode='+') then
           for rec in (
             --candidate for delete
             select unique cla_id
               from gro_cla
               where no_conflict_flag = '+'
                and gro_id  = pres_id 
                and day between vdate_from and vdate_to
           ) 
           loop
             delete_class (rec.cla_id);
           end loop;
         end if;    

         -- delete dependency classes with wrong description 
         --Xxmsz_Tools.insertIntoEventLog('idc1');
         delete from helper2;
         insert into helper2
             select unique cla.id, desc2, cla.day, cla.hour
             from gro_cla
                , classes cla
             where no_conflict_flag = '+'
              and gro_cla.cla_id = cla.id
              and gro_id  = pres_id 
              and gro_cla.day between vdate_from and vdate_to;

         --Xxmsz_Tools.insertIntoEventLog('idc2 '||pres_id);
         delete from helper3;
         insert into helper3 (day, hour, str)
                    select day, hour, listagg(gro.abbreviation, '; ') within group (order by gro.abbreviation) descCorrect
                      from gro_cla
                         , groups gro 
                    where no_conflict_flag is null
                     and gro_cla.gro_id = gro.id 
                       and gro_id in 
                            (select id from helper1)
                       and gro_cla.day between vdate_from and vdate_to
                      group by day, hour;      
         for rec in (

             select existing_dep.id, existing_dep.desc2, correct_desc2.descCorrect, existing_dep.day , correct_desc2.hour
               from helper2 existing_dep
                  , (select day, hour, str descCorrect from helper3 ) correct_desc2
           where correct_desc2.day = existing_dep.day and correct_desc2.hour = existing_dep.hour
             and existing_dep.desc2 <> correct_desc2.descCorrect         
         ) 
         loop
           --Xxmsz_Tools.insertIntoEventLog('.'|| rec.desc2 ||'<< VS >>'||rec.descCorrect||' day:'||rec.day||' hour:'||rec.hour );
           delete_class (rec.id);
         end loop;

         --Xxmsz_Tools.insertIntoEventLog('idc3');
         --create child dependencies
         for rec in (
            --classes of childs
            select day, hour
                 , listagg(gro.abbreviation, '; ') within group (order by gro.abbreviation) child_parent_names
                 , listagg(helper1.attribs_01, '; ') within group (order by gro.abbreviation) child_parent_flag
              from gro_cla 
                 , groups gro 
                 , helper1
            where no_conflict_flag is null
             and gro_cla.gro_id = gro.id 
             and gro_id = helper1.id
            and day between vdate_from and vdate_to
            --do not create dependency classes if a base group has already the classes, either own classes or dependency classes created earlier
            and (day,hour) not in 
              (select day,hour 
                from gro_cla 
                where gro_id  = pres_id 
                 and day between vdate_from and vdate_to
              )
			group by day, hour  
         ) 
         loop
            if (instr(rec.child_parent_flag,'C')>0) then
                --Xxmsz_Tools.insertIntoEventLog('.');
                insert_classes(rec.day
                   ,rec.hour
                   ,100
                   ,-1
                   ,-1
                   ,'AUTO'
                   ,-1 /*lec*/
                   ,pres_id /*gro*/
                   ,-1 /*res*/
                   ,null
                   ,'Zajecia podrzedne'           
                   , substrb(rec.child_parent_names,1,200)
                   ,null            
                   ,null);         
            else
                --Xxmsz_Tools.insertIntoEventLog('..');
                insert_classes(rec.day
                   ,rec.hour
                   ,100
                   ,-2
                   ,-2
                   ,'AUTO'
                   ,-2 /*lec*/
                   ,pres_id /*gro*/
                   ,-2 /*res*/
                   ,null
                   ,'Zajecia nadrzedne'           
                   , substrb(rec.child_parent_names,1,200)
                   ,null            
                   ,null);            
            end if;
         end loop;

         --Xxmsz_Tools.insertIntoEventLog('idc5');
         delete from helper2;
         insert into helper2 (day, hour)
                  select unique day, hour  
                    from gro_cla 
                  where no_conflict_flag is null
                    and gro_id in (select id from helper1)
                  and day between vdate_from and vdate_to     
                  minus
                  --delete record if class for base record exists
                  select day,hour 
                  from gro_cla 
                  where gro_id  = pres_id 
                   and no_conflict_flag is null
                   and day between vdate_from and vdate_to;
         for rec in (
           --candidate to delete
           select unique cla_id
             from gro_cla
             where no_conflict_flag = '+'
              and gro_id  = pres_id 
              and day between vdate_from and vdate_to
              --dependency no longer exists
              and (day,hour) not in 
                (select day, hour from helper2)
         ) 
         loop
           delete_class (rec.cla_id);
         end loop;
         --Xxmsz_Tools.insertIntoEventLog('idc6');

    end if; --if (pres_type='G')

    -- very similar code for Lecturers
    if (pres_type='L') then

         -- optional clean up
         -- clean up may be necesarry when the hierarchy of resources was modified
         -- as it recreates all dependencies, do not overdose this option!
         if (pcleanUpMode='+') then
           for rec in (
             --candidate to delete
             select unique cla_id
               from lec_cla
               where no_conflict_flag = '+'
                and lec_id  = pres_id 
                and day between vdate_from and vdate_to
           ) 
           loop
             delete_class (rec.cla_id);
           end loop;
         end if;    

         -- delete dependency classes with wrong description 
         for rec in (
           select * from
           (
             select existing_dep.desc2, existing_dep.id
                  , (
                    select listagg(lec.title||' '||lec.first_name||' '||lec.last_name, '; ') within group (order by lec.last_name)
                      from lec_cla
                         , lecturers lec 
                    where no_conflict_flag is null
                     and lec_cla.lec_id = lec.id 
                       and lec_id in 
                            (select id from helper1) 
                       and day = existing_dep.day and hour = existing_dep.hour) correct_desc2
               from
                     (
                       select unique cla.id, cla.desc2, cla.day, cla.hour
                         from lec_cla
                            , classes cla
                         where no_conflict_flag = '+'
                          and lec_cla.cla_id = cla.id
                          and lec_id  = pres_id 
                          and lec_cla.day between vdate_from and vdate_to
                      ) existing_dep
          ) where desc2 <> correct_desc2
         ) 
         loop
           delete_class (rec.id);
         end loop;

         --create child dependencies
         for rec in (
            --classes of childs
            select unique day, hour  
              from lec_cla 
            where no_conflict_flag is null
             and lec_id in 
              (select child_id id
                from str_elems_v
                where level=1 and STR_NAME_LOV='STREAM'
                connect by prior STR_NAME_LOV='STREAM' and prior child_id = parent_id
                start with parent_id = pres_id)
            and day between vdate_from and vdate_to
            --do not create dependency classes if base group has already the classes, either own classes or dependency classes created earlier
            and (day,hour) not in 
              (select day,hour 
                from lec_cla 
                where lec_id  = pres_id 
                 and day between vdate_from and vdate_to
              )
         ) 
         loop
            select listagg(lec.title||' '||lec.first_name||' '||lec.last_name, '; ') within group (order by lec.last_name)
              into pchild_names
              from lec_cla
                 , lecturers lec 
            where no_conflict_flag is null
             and lec_cla.lec_id = lec.id 
               and lec_id in 
                  --childs
                  (select child_id id
                    from str_elems_v
                    where level=1 and STR_NAME_LOV='STREAM'
                    connect by prior STR_NAME_LOV='STREAM' and prior child_id = parent_id
                    start with parent_id=pres_id)
               and day = rec.day and hour = rec.hour;
            insert_classes(rec.day
               ,rec.hour
               ,100
               ,-1
               ,-1
               ,'AUTO'
               ,pres_id /*lec*/
               ,-1 /*gro*/
               ,-1 /*res*/
               ,null
               ,'Zajecia podrzedne'           
               , substrb(pchild_names,1,200)
               ,null            
               ,null);            
         end loop;

         --create parent dependencies
         for rec in (
            --classes of parents
            select unique day, hour  
              from lec_cla 
            where no_conflict_flag is null
             and lec_id in 
              (select parent_id id
                 from str_elems_v
                where level=1 and STR_NAME_LOV='STREAM'
              connect by prior STR_NAME_LOV='STREAM' and prior parent_id = child_id
              start with child_id = pres_id)
            and day between vdate_from and vdate_to
            --do not create dependency classes if base group has already the classes, either own classes or dependency classes created earlier
            and (day,hour) not in 
              (select day,hour 
                from lec_cla 
                where lec_id  = pres_id 
                 and day between vdate_from and vdate_to)) 
         loop
            select listagg(lec.title||' '||lec.first_name||' '||lec.last_name, '; ') within group (order by lec.last_name)
              into pchild_names
              from lec_cla
                 , lecturers lec 
            where no_conflict_flag is null
              and lec_cla.lec_id = lec.id 
              and lec_id in 
                  --parents
                  (select parent_id id
                     from str_elems_v
                    where level=1 and STR_NAME_LOV='STREAM'
                  connect by prior STR_NAME_LOV='STREAM' and prior parent_id = child_id
                  start with child_id = pres_id)
              and day = rec.day and hour = rec.hour;
            insert_classes(rec.day
               ,rec.hour
               ,100
               ,-2
               ,-2
               ,'AUTO'
               ,pres_id /*lec*/
               ,-2 /*gro*/
               ,-2 /*res*/
               ,null
               ,'Zajecia nadrzedne'           
               , substrb(pchild_names,1,200)
               ,null            
               ,null);            
         end loop;

         for rec in (
           --candidate to delete
           select unique cla_id
             from lec_cla
             where no_conflict_flag = '+'
              and lec_id  = pres_id 
              and day between vdate_from and vdate_to
              --dependency no longer exists
              and (day,hour) not in 
                (        
                  select unique day, hour  
                    from lec_cla 
                  where no_conflict_flag is null
                    and lec_id in
                       (select id from helper1) 
                  and day between vdate_from and vdate_to     
                  minus
                  --delete record if class for base record exists
                  select day,hour 
                  from lec_cla 
                  where lec_id  = pres_id 
                   and no_conflict_flag is null
                   and day between vdate_from and vdate_to
               )
         ) 
         loop
           delete_class (rec.cla_id);
         end loop;

    end if; --if (pres_type='L')

  end;

  -----------------------------------------------------------------------------------------------------------------------------------------------------
    function get_class_coeffficient ( aid number, aform_formula_type varchar2, aday date default sysdate) return number is
      afor_id            number;
      coe                number;
      prior_coe          number;
      anumber_of_peoples number;
      ahours             number;
      acalc_lecturers    classes.calc_lecturers%type;
      acalc_groups       classes.calc_groups%type;

      function get_lec_coefficient (alec_id number) return number is
        aorguni_id number;
        coe        number;
        guard      number := 0;
        ffformula  varchar2(500);
          function get_orguni_formula ( aorguni_id number ) return varchar2 is
            ffid       number;
            ffformula  varchar2(500);
            parent_orguni_id number;
          begin
            begin
              -- wyszukiwanie formuly
              last_orguni_id := aorguni_id;
              select id,formula
                into ffid,ffformula
                  from form_formulas
               where for_id       = afor_id
                 and orguni_id    = aorguni_id
                 and formula_type = aform_formula_type
                 and aday between date_from and nvl(date_to,aday);
               last_ffid := ffid;
               return ffformula;
            exception
             when too_many_rows then
               last_error := '(01)Odnaleziono kilka formul dla podanej formy, jednostki, typu formuly, daty)';
               return 0;
             when no_data_found then
               guard := guard + 1;
               if guard > 100 then
                 last_error := '(02)Przekroczono dopuszczalna liczbe zagniezdzen w strukturze organizacyjnej ( 100 ). Sprawdz, czy struktura organizacyjna nie zawiera cykli';
                 return null;
               else
                 select parent_id
                   into parent_orguni_id
                   from org_units
                  where id = aorguni_id;
                  if parent_orguni_id is null then
                    last_error := '(03)Nie odnaleziono formuly dla formy prowadzenia zajec, zadanego dnia oraz jedn.org (oraz jednostek nadrzednych)';
                    return null;
                  else
                   return  get_orguni_formula ( parent_orguni_id );
                  end if;
               end if;
             when others        then
               last_error := '(04)Wyszukiwanie formuly - blad: ' || to_char (sqlcode) || ' ' || sqlerrm;
               return null;
            end;
          end;
      begin
        begin
          select orguni_id
            into aorguni_id
            from lecturers where id = alec_id;
        exception
          when others        then
            last_error := '(05)Nie powiodlo sie wyznaczenie jednostki organizacyjnej dla wykladowcy. Blad: ' || to_char (sqlcode) || ' ' || sqlerrm;
            return 0;
        end;

        if aorguni_id is null then
           last_error := '(06)Dla wykladowcy nie okreslono jednostki organizacyjnej - nie mozna wyznaczyc formuly';
           return 0;
        end if;

        ffformula := get_orguni_formula ( aorguni_id );
        if ffformula is null then --blad
         return 0;
        end if;

        ffformula := replace (ffformula, 'Zaograglij'      , 'Round');
        --ffformula := replace (ffformula, 'Liczba_godz'     , to_char(ahours,'99999.0000') );
        --ffformula := replace (ffformula, 'Liczba_studentów', to_char(anumber_of_peoples,'99999.0000'));
        ffformula := replace (ffformula, 'Liczba_godz'     , ' xxmsz_tools.strToNumber(' || to_char(ahours)             ||') ' );
        ffformula := replace (ffformula, 'Liczba_studentów', ' xxmsz_tools.strToNumber(' || to_char(anumber_of_peoples) ||') ' );
        -- xxmsz_tools.strtonumber chyba niepotrzebne, przy okazji to przetestowania i ew. do usuniecia

        last_formula := ffformula;

        begin
          return xxmsz_tools.getsqlvalue('SELECT '||ffformula||' FROM DUAL');
        exception
          when others then
            last_error := '(07)Blad podczas wyliczania formuly "' || FFFORMULA || '" Blad: ' || to_char (sqlcode) || ' ' || sqlerrm;
            return 0;
        end;
      end;

    begin
      last_error     := null;
      last_formula   := null;
      last_orguni_id := null;
      last_horus     := null;
      last_number_of_peoples := null;
      last_lec_id    := null;
      last_for_id    := null;

      select for_id, 2 * fill / 100, calc_lecturers, calc_groups
        into afor_id, ahours, acalc_lecturers, acalc_groups
        from classes
        where id = aid;

      if acalc_lecturers is null then
        last_error := '(08)Nie mozna wyznaczyc wspólczynnika, poniewaz nie okreslono wykladowcy';
        return 0;
      end if;

      if acalc_groups is null then
        last_error := '(09)Nie mozna wyznaczyc wspólczynnika, poniewaz nie okreslono grup';
        return 0;
      end if;

      select nvl( sum ( number_of_peoples ), 0)
        into anumber_of_peoples
        from groups
        where id in ( select gro_id from gro_cla where cla_id = aid );

      if anumber_of_peoples = 0 then
        last_error := '(10)Nie mozna wyznaczyc wspólczynnika, poniewaz nie okreslono licznosci grup';
        return 0;
      end if;

      last_for_id            := afor_id;
      last_horus             := ahours;
      last_number_of_peoples := anumber_of_peoples;

      -- wyznacz wspólczynnik dla kazdego wykladowcy
      coe := 0;
      for rec_lec in ( select lec_id from lec_cla where cla_id = aid ) loop
        prior_coe   := coe;
        last_lec_id := rec_lec.lec_id;
        coe := get_lec_coefficient (rec_lec.lec_id);
        if coe = 0 then -- blad
          exit;
        end if;
        if prior_coe <> 0 then
          if prior_coe <> coe then
            last_error := '(11)Otrzymano rózne wartosci wspólczynnika dla wykladowców prowadzacych zajecie (' || prior_coe || ', '||  coe || ')';
            return 0;
          end if;
        end if;
      end loop;

      if last_error is not null then
        last_error := last_error || ' wywolanie: GET_CLASS_COEFFFICIENT ( '||aid||','''||aform_formula_type||''',TO_DATE(' || to_char(aday,'YYYY-MM-DD') || ',''YYYY-MM-DD''))';
      end if;

      return coe;
    end;

  -----------------------------------------------------------------------------------------------------------------------------------------------------
  function get_last_error return varchar2 is
  begin
    return last_error;
  end get_last_error;

  -----------------------------------------------------------------------------------------------------------------------------------------------------
  function get_class_coeffficient_tester ( aid number, aform_formula_type varchar2, aday date  default sysdate) return varchar2 is
   coe number;
  begin
    coe  := get_class_coeffficient ( aid, aform_formula_type, aday);
    return ' COE='                   || to_char ( coe )
         ||' LAST_ERROR='            || last_error
         ||' LAST_ORGUNI_ID='        || last_orguni_id
         ||' LAST_LEC_ID='           || last_lec_id
         ||' LAST_FOR_ID='           || last_for_id
         ||' LAST_FFID='             || last_ffid
         ||' LAST_FORMULA='          || last_formula
         ||' LAST_HORUS='            || last_horus
         ||' LAST_NUMBER_OF_PEOPLES='|| last_number_of_peoples;
  end get_class_coeffficient_tester;

  -----------------------------------------------------------------------------------------------------------------------------------------------------
  function get_output_param_char1 return varchar2 is begin return output_param_char1; end;
  function get_output_param_char2 return varchar2 is begin return output_param_char2; end;
  function get_output_param_char3 return varchar2 is begin return output_param_char3; end;
  function get_output_param_num1  return number is begin return output_param_num1; end;
  function get_output_param_num2  return number is begin return output_param_num2; end;
  function get_output_param_num3  return number is begin return output_param_num3; end;
  function get_output_param_num4  return number is begin return output_param_num4; end;
  function get_output_param_num5  return number is begin return output_param_num5; end;
  function get_output_param_num6  return number is begin return output_param_num6; end;
  function get_output_param_num7  return number is begin return output_param_num7; end;
  function get_output_param_num8  return number is begin return output_param_num8; end;
  function get_output_param_num9  return number is begin return output_param_num9; end;
  function get_output_param_num10 return number is begin return output_param_num10; end;

  -----------------------------------------------------------------------------------------------------------------------------------------------------
  function get_session_id return number is
  begin
   return userenv('sessionid');
  end get_session_id;


  -----------------------------------------------------------------------------------------------------------------------------------------------------
  procedure merge_helper_owners (save_id number, delete_id number) is begin
    delete owners x
     where res_id = delete_id
       and exists ( select 1 from owners where res_id = save_id and pla_id = x.pla_id);
    update owners set res_id = save_id where res_id = delete_id;    
  end;

  -----------------------------------------------------------------------------------------------------------------------------------------------------
  procedure merge_helper_smart (save_id number, delete_id number) is begin
    update lecturers
      set desc1 = nvl(desc1, (select desc1 from lecturers where id=delete_id ))
        , desc2 = nvl(desc2, (select desc2 from lecturers where id=delete_id ))
        , email = nvl(email, (select email from lecturers where id=delete_id ))
        , integration_id = nvl(integration_id, (select integration_id from lecturers where id=delete_id ))
    where id = save_id;  
    
    update groups
      set desc1 = nvl(desc1, (select desc1 from groups where id=delete_id ))
        , desc2 = nvl(desc2, (select desc2 from groups where id=delete_id ))
        , email = nvl(email, (select email from groups where id=delete_id ))
        , integration_id = nvl(integration_id, (select integration_id from groups where id=delete_id ))
    where id = save_id;  
    
    update rooms
      set desc1 = nvl(desc1, (select desc1 from rooms where id=delete_id ))
        , desc2 = nvl(desc2, (select desc2 from rooms where id=delete_id ))
        , email = nvl(email, (select email from rooms where id=delete_id ))
        , integration_id = nvl(integration_id, (select integration_id from rooms where id=delete_id ))
    where id = save_id;  
    
    update subjects
      set desc1 = nvl(desc1, (select desc1 from subjects where id=delete_id ))
        , desc2 = nvl(desc2, (select desc2 from subjects where id=delete_id ))
        , integration_id = nvl(integration_id, (select integration_id from subjects where id=delete_id ))
    where id = save_id;  
    
    update forms
      set desc1 = nvl(desc1, (select desc1 from forms where id=delete_id ))
        , desc2 = nvl(desc2, (select desc2 from forms where id=delete_id ))
        , integration_id = nvl(integration_id, (select integration_id from forms where id=delete_id ))
    where id = save_id;  
  end;

  -----------------------------------------------------------------------------------------------------------------------------------------------------
  procedure merge_res (save_id number, delete_id number, administrator_merging varchar2) is
   cla_id_list t_number_list;
   i number;
  begin
    if administrator_merging = 'N' then
      declare
       c number;
      begin
       select count(1)
         into c
         from rom_cla 
            , classes c 
        where c.id = rom_cla.cla_id
          and rom_id = delete_id
          and c.owner <> user;
       if c > 0 then
         raise_application_error(-20000, 'Zasób, który probujesz scalic, zostal uzyty przez innych planistów. Jezeli mimo to chcesz dokonac scalenia, zaznacz pole wyboru "Zezwól na scalanie jezeli istnieja zajecia zaplanowane przez innych planistów"');
       end if;  
      end;           
    end if;
    merge_helper_smart(save_id, delete_id);
    -- delete record which would make conflicts after merging
    delete rom_pla x
     where rom_id = delete_id
       -- such record which would be created after update already exists
       and exists ( select 1 from rom_pla where rom_id = save_id and pla_id = x.pla_id);
    output_param_num1 := sql%rowcount;
    delete rom_cla x
     where rom_id = delete_id
       -- such record which would be created after update already exists
       and exists ( select 1 from rom_cla where rom_id = save_id and day = x.day and hour = x.hour)    
     returning cla_id
     bulk collect into cla_id_list;
    output_param_num2 := sql%rowcount;
    i := cla_id_list.first; 
    while i is not null loop
       update_lgr( cla_id_list (i) );
       i := cla_id_list.next(i); 
    end loop;  
    delete from classes 
     where calc_lecturers is null and calc_groups is null and calc_rooms is null
      and id in (select * from table(cla_id_list));
    cla_id_list.delete;  
    update str_elems set child_id = save_id where child_id = delete_id;
    update str_elems set parent_id = save_id where parent_id = delete_id;
    update rom_pla set rom_id = save_id where rom_id = delete_id;
    output_param_num3 := sql%rowcount;
    update rom_cla set rom_id = save_id where rom_id = delete_id
     returning cla_id
     bulk collect into cla_id_list;
    output_param_num4 := sql%rowcount;
    i := cla_id_list.first; 
    while i is not null loop
       update_lgr( cla_id_list (i) );
       i := cla_id_list.next(i); 
    end loop;    
    delete from rooms where id = delete_id;
    output_param_num5 := sql%rowcount;
    merge_helper_owners (save_id, delete_id);
  end merge_res;                   

  -----------------------------------------------------------------------------------------------------------------------------------------------------
  procedure merge_lec (save_id number, delete_id number, administrator_merging varchar2) is
   cla_id_list t_number_list;
   i number;
  begin
    if administrator_merging = 'N' then
      declare
       c number;
      begin
       select count(1)
         into c
         from lec_cla 
            , classes c 
        where c.id = lec_cla.cla_id
          and lec_id = delete_id
          and c.owner <> user;
       if c > 0 then
         raise_application_error(-20000, 'Dane o wykladowcy, które próbujesz scalic, zostaly uzyte przez innych planistów. Jezeli mimo to chcesz dokonac scalenia, zaznacz pole wyboru "Zezwól na scalanie jezeli istnieja zajecia zaplanowane przez innych planistów"');
       end if;  
      end;           
    end if;
    merge_helper_smart(save_id, delete_id);    
    delete lec_pla x
     where lec_id = delete_id
       and exists ( select 1 from lec_pla where lec_id = save_id and pla_id = x.pla_id);
    output_param_num1 := sql%rowcount;
    delete lec_cla x
     where lec_id = delete_id
       and exists ( select 1 from lec_cla where lec_id = save_id and day = x.day and hour = x.hour)    
     returning cla_id
     bulk collect into cla_id_list;
    output_param_num2 := sql%rowcount;
    i := cla_id_list.first; 
    while i is not null loop
       update_lgr( cla_id_list (i) );
       i := cla_id_list.next(i); 
    end loop;    
    delete from classes 
     where calc_lecturers is null and calc_groups is null and calc_rooms is null
      and id in (select * from table(cla_id_list));
    cla_id_list.delete;  
    update str_elems set child_id = save_id where child_id = delete_id;
    update str_elems set parent_id = save_id where parent_id = delete_id;
    update lec_pla set lec_id = save_id where lec_id = delete_id;
    output_param_num3 := sql%rowcount;
    update lec_cla set lec_id = save_id where lec_id = delete_id
     returning cla_id
     bulk collect into cla_id_list;
    output_param_num4 := sql%rowcount;
    i := cla_id_list.first;  
    while i is not null loop
       update_lgr( cla_id_list (i) );
       i := cla_id_list.next(i); 
    end loop;
    delete from lecturers where id = delete_id;
    output_param_num5 := sql%rowcount;
    merge_helper_owners (save_id, delete_id);
  end merge_lec;                   

  -----------------------------------------------------------------------------------------------------------------------------------------------------
  procedure merge_gro (save_id number, delete_id number, administrator_merging varchar2) is
   cla_id_list t_number_list;
   i number;
  begin
    if administrator_merging = 'N' then
      declare
       c number;
      begin
       select count(1)
         into c
         from gro_cla 
            , classes c 
        where c.id = gro_cla.cla_id
          and gro_id = delete_id
          and c.owner <> user;
       if c > 0 then
         raise_application_error(-20000, 'Dane o grupie, które probujesz scalic, zostaly uzyte przez innych planistów. Jezeli mimo to chcesz dokonac scalenia, zaznacz pole wyboru "Zezwól na scalanie jezeli istnieja zajecia zaplanowane przez innych planistów"');
       end if;  
      end;           
    end if;
    merge_helper_smart(save_id, delete_id);
    delete gro_pla x
     where gro_id = delete_id
       and exists ( select 1 from gro_pla where gro_id = save_id and pla_id = x.pla_id);
    output_param_num1 := sql%rowcount;
    delete gro_cla x
     where gro_id = delete_id
       and exists ( select 1 from gro_cla where gro_id = save_id and day = x.day and hour = x.hour)    
     returning cla_id
     bulk collect into cla_id_list;
    output_param_num2 := sql%rowcount;
    i := cla_id_list.first; 
    while i is not null loop
       update_lgr( cla_id_list (i) );
       i := cla_id_list.next(i); 
    end loop;   
    delete from classes 
     where calc_lecturers is null and calc_groups is null and calc_rooms is null
      and id in (select * from table(cla_id_list));    
    cla_id_list.delete;  
    update str_elems set child_id = save_id where child_id = delete_id;
    update str_elems set parent_id = save_id where parent_id = delete_id;
    update gro_pla set gro_id = save_id where gro_id = delete_id;
    output_param_num3 := sql%rowcount;
    update gro_cla set gro_id = save_id where gro_id = delete_id
     returning cla_id
     bulk collect into cla_id_list;
    output_param_num4 := sql%rowcount;
    i := cla_id_list.first;  
    while i is not null loop
       update_lgr( cla_id_list (i) );
       i := cla_id_list.next(i); 
    end loop;
    delete from groups where id = delete_id;
    output_param_num5 := sql%rowcount;
    merge_helper_owners (save_id, delete_id);
  end merge_gro;                   

  -----------------------------------------------------------------------------------------------------------------------------------------------------
  procedure merge_SUB (save_id number, delete_id number, administrator_merging varchar2) is
   i number;
  begin
    if administrator_merging = 'N' then
      declare
       c number;
      begin
       select count(1)
         into c
         from classes c 
        where sub_id = delete_id
          and c.owner <> user;
       if c > 0 then
         raise_application_error(-20000, 'Przedmiot, który probujesz scalic, zostal uzyty przez innych planistów. Jezeli mimo to chcesz dokonac scalenia, zaznacz pole wyboru "Zezwól na scalanie jezeli istnieja zajecia zaplanowane przez innych planistów"');
       end if;  
      end;           
    end if;
    merge_helper_smart(save_id, delete_id);
    delete sub_pla x
     where sub_id = delete_id
       and exists ( select 1 from sub_pla where sub_id = save_id and pla_id = x.pla_id);
    output_param_num1 := sql%rowcount;
    output_param_num2 := 0; 
    update sub_pla set sub_id = save_id where sub_id = delete_id;
    output_param_num3 := sql%rowcount;
    update classes set sub_id = save_id where sub_id = delete_id;
    output_param_num4 := sql%rowcount;
    delete from subjects where id = delete_id;
    output_param_num5 := sql%rowcount;
    merge_helper_owners (save_id, delete_id);
  end merge_SUB;                   

  -----------------------------------------------------------------------------------------------------------------------------------------------------
  procedure merge_FOR (save_id number, delete_id number, administrator_merging varchar2) is
   i number;
  begin
    if administrator_merging = 'N' then
      declare
       c number;
      begin
       select count(1)
         into c
         from classes c 
        where for_id = delete_id
          and c.owner <> user;
       if c > 0 then
         raise_application_error(-20000, 'Przedmiot, który probujesz scalic, zostal uzyty przez innych planistów. Jezeli mimo to chcesz dokonac scalenia, zaznacz pole wyboru "Zezwól na scalanie jezeli istnieja zajecia zaplanowane przez innych planistów"');
       end if;  
      end;           
    end if;
    merge_helper_smart(save_id, delete_id);
    delete for_pla x
     where for_id = delete_id
       and exists ( select 1 from for_pla where for_id = save_id and pla_id = x.pla_id);
    output_param_num1 := sql%rowcount;
    output_param_num2 := 0; 
    update for_pla set for_id = save_id where for_id = delete_id;
    output_param_num3 := sql%rowcount;
    update form_formulas set for_id = save_id where for_id = delete_id;
    update classes set for_id = save_id where for_id = delete_id;
    output_param_num4 := sql%rowcount;
    delete from forms where id = delete_id;
    output_param_num5 := sql%rowcount;
    merge_helper_owners (save_id, delete_id);
  end merge_FOR;                   

  -----------------------------------------------------------------------------------------------------------------------------------------------------
  function insert_str_elem ( pparent_id number, pchild_id number, pstr_name_lov varchar2 default 'STREAM', pexclusive_parent varchar2) return varchar2 is
   c number;
  begin
    if pparent_id = pchild_id then return 'Zasób nie moze byc sam dla siebie podrzedny ani nadrzedny'; end if;
    --avoid cycles
    select count(*)
     into c 
     from
     (select parent_id id_list
        from str_elems
        where str_name_lov = pstr_name_lov
        connect by prior parent_id = child_id   
        start with child_id=pparent_id)
    where id_list = pchild_id;
    if c > 0 then return 'Dodanie rekordu spowodowaloby zapetlenie danych. Elementem nadrzednym nie moze byc element, który juz jest elementem podrzednym'; end if;
    select count(*)
     into c 
     from
     (select child_id id_list
        from str_elems
        where str_name_lov = pstr_name_lov
        connect by prior child_id = parent_id  
        start with parent_id=pchild_id)
    where id_list = pparent_id;    
    if c > 0 then return 'Dodanie rekordu spowodowaloby zapetlenie danych. Elementem podrzednym nie moze byc element, który juz jest elementem nadrzednym'; end if;    
    begin
      insert into str_elems (id, parent_id, child_id, str_name_lov, exclusive_parent) values (main_seq.nextval, pparent_id, pchild_id,pstr_name_lov, pexclusive_parent);
      return '';
    exception 
      when others then 
        if sqlcode = -1 then return 'Ta kombinacja juz istnieje. Rekord nie zostal dodany ponownie'; else return sqlerrm; end if;
    end;
  end insert_str_elem;           

  -----------------------------------------------------------------------------------------------------------------------------------------------------
  procedure insert_str_elem ( pparent_id number, pchild_id number, pstr_name_lov varchar2 default 'STREAM', pexclusive_parent varchar2) is
  begin
    output_param_char1 := insert_str_elem (pparent_id, pchild_id, pstr_name_lov,pexclusive_parent);
  end insert_str_elem;

  -----------------------------------------------------------------------------------------------------------------------------------------------------
  function  flexGetFieldName (pmax_flex_num number, pform_name varchar2, pcontext_name varchar2, pfield_type varchar2 default 'S') return varchar2 is
    res varchar2(100);
  begin
   select min (field_name)
     into res 
     from 
       (
       select lpad(rownum,2,'0') field_name from dual connect by rownum  <= pmax_flex_num
       minus
       select substr(attr_name,-2) from flex_col_usage where form_name = pform_name and context_name = pcontext_name and attr_name like 'ATTRIB'||pfield_type||'%'
       );
   return res;
  end flexGetFieldName;



  -----------------------------------------------------------------------------------------------------------------------------------------------------
  function get_available_lec ( plec_id number ) return number is
    vres number;
  begin
    select case when planner_utils.classes_selected_count = 0 then 100
                else round ( ( (planner_utils.classes_selected_count-count(1)) * 100) / planner_utils.classes_selected_count ) end 
      into vres
      from lec_cla 
     where lec_id = plec_id
       and ( day, hour ) in ( select day,hour from tmp_selected_dates where sessionid = userenv('sessionid') ); 
    return vres;
  end get_available_lec;

  -----------------------------------------------------------------------------------------------------------------------------------------------------
  function get_available_gro ( pgro_id number ) return number is
    vres number;
  begin
    if planner_utils.classes_selected_count = 0 then return 100; end if;
    select case when planner_utils.classes_selected_count = 0 then 100
                else round ( ( (planner_utils.classes_selected_count-count(1)) * 100) / planner_utils.classes_selected_count ) end 
      into vres
      from gro_cla 
     where gro_id = pgro_id
       and ( day, hour ) in ( select day,hour from tmp_selected_dates where sessionid = userenv('sessionid') ); 
    return vres;
  end get_available_gro;


  -----------------------------------------------------------------------------------------------------------------------------------------------------
  function get_available_rom ( prom_id number ) return number is
    vres number;
  begin
    if planner_utils.classes_selected_count = 0 then return 100; end if;
    select case when planner_utils.classes_selected_count = 0 then 100
                else round ( ( (planner_utils.classes_selected_count-count(1)) * 100) / planner_utils.classes_selected_count ) end 
      into vres
      from rom_cla 
     where rom_id = prom_id
       and ( day, hour ) in ( select day,hour from tmp_selected_dates where sessionid = userenv('sessionid') ); 
    return vres;
  end get_available_rom;

  function get_classes_selected_count return number is
  begin
   return planner_utils.classes_selected_count;
  end get_classes_selected_count;

 -----------------------------------------------------------------------------------------------------------------------------------------------------
 function get_group_types (pclass_id number) return varchar2 is
   l_res varchar2(500) := '';
 begin
   for rec in (
   select unique substr(meaning,1,50) group_type_dsp
    into l_res
    from groups   g  
    ,    gro_cla  c  
    ,    lookups  l
    where g.id = c.gro_id
     and l.lookup_type = 'GROUP_TYPE' and  l.code  = g.group_type
     and cla_id = pclass_id
   ) loop
    l_res := l_res || rec.group_type_dsp || ' ';
   end loop;  
   return l_res;     
 end get_group_types; 


 -----------------------------------------------------------------------------------------------------------------------------------------------------
 procedure delete_class ( pid number ) is
  l_sum_units number;
 begin 
   --debug('delete_class:'||pid);   
   for rec in (select tt_comb_id from tt_cla where cla_id = pid) loop
     select sum(units) into l_sum_units from tt_cla where cla_id = pid and tt_comb_id = rec.tt_comb_id;
     tt_planner.unbook_combination ( rec.tt_comb_id, l_sum_units );
   end loop;
   delete from classes where id = pid;
   -- lec_cla, gro_cla, rom_cla are not cleared cascadely due defferable relation    
   delete from lec_cla where cla_id = pid;
   delete from gro_cla where cla_id = pid;
   delete from rom_cla where cla_id = pid;
   -- tt_cla is cleared cascadely

   -- do not uncomment this line. caching problems during classes are moved on the grid
   deleted_class_id := pid;
 exception
 when others then
   rollback; 
   raise;  
 end delete_class;
 
 
 -----------------------------------------------------------------------------------------------------------------------------------------------------
FUNCTION get_excluded_res_ids(p1 IN VARCHAR2) RETURN VARCHAR2
IS
    v_result VARCHAR2(4000);
BEGIN
    SELECT LISTAGG(res_id_excluded, ',') 
           WITHIN GROUP (ORDER BY res_id_excluded)
    INTO v_result
    FROM (
        SELECT DISTINCT res_id_excluded
        FROM exclusions
        WHERE TRUNC(SYSDATE) BETWEEN NVL(DATE_FROM,TRUNC(SYSDATE)) AND NVL(DATE_TO,TRUNC(SYSDATE))
          AND res_id IN (
                SELECT TO_NUMBER(REGEXP_SUBSTR(REPLACE(p1, ',', ';'), '[^;]+', 1, LEVEL))
                FROM dual
                CONNECT BY LEVEL <= REGEXP_COUNT(REPLACE(p1, ',', ';'), ';') + 1
          )
    );

    RETURN v_result;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
    WHEN OTHERS THEN
        RETURN 'ERROR: ' || SQLERRM;
END;

-----------------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE clone_holidays (source_per_id IN NUMBER,target_per_id    IN NUMBER,delete_target   varchar2)
IS
    currrec holiday_days%ROWTYPE;
BEGIN
    if delete_target='Y' then delete from holiday_days where per_id= target_per_id; end if;
    FOR rec IN (SELECT * FROM holiday_days WHERE per_id = source_per_id
     and (day, hour) in (
       SELECT day, hour FROM holiday_days WHERE per_id = source_per_id
       minus
       SELECT day, hour FROM holiday_days WHERE per_id = target_per_id
       )
    
    ) LOOP
        currrec := rec;
        currrec.id := RES_SEQ.NEXTVAL;
        currrec.per_id := target_per_id;

        INSERT INTO holiday_days VALUES currrec;
    END LOOP;
END;
 
end planner_utils;
/
