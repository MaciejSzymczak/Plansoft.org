prompt ### INSTALLED ON WAT, POLLUB


prompt ### EXTENTION BEGIN
prompt ### EXTENTION NAME:Core changes 1
prompt ### DATE:2013.11.01

CREATE OR REPLACE package planner_utils is

   /*****************************************************************************************************************************
   |* toolkit
   |*****************************************************************************************************************************
   | Maciej Szymczak
   | 2004.11.21 usuniecie problemu zwiazanego z nie dodawaniem rezerwacji dla sali
   | 2005.04.19 dodanie funkcji get_class_coeffficient
   | 2005.05.15 rozwiazanie problemu zwiazanego z konwersja number -> string (,.)
   | 2007.05.05 zmiany, wersja 3.4
   | 2010.03.14 flexs
   | 2010.11.01 copy_data - bugfix   
   | 2012.03.17 periods.locked_flag   
   | 2012.06.17 update_lgr, copy_data - changes ( user sorting demand)   
   | 2012.06.18 insert_classes - changes ( desc1..desc4)   
   | 2013.03.06 track history - changes  
   | 2013.11.03 bugfixing  
   \*-----------------------------------------------------------------------------------------------------------------------------*/

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
   funkcja zwraca wartoœæ wspó³czynnika dla zajêcia wyliczonego za pomoca odnalezionej formu³y.
   funkcja zwraca zero, jezeli wystapi b³¹d.
   algotytm wyznaczania formu³y:
   dla ka¿dego wyk³adowcy:
     pobierz formu³ê na dzieñ i wylicz wartosc formuly. podstaw liczba studentów = liczba wszystkich studentów spoœród grup w zajêciu.
     je¿eli nie znaleziono formu³y, pobierz formu³ê dla jednostki nadrzêdnej. powtórz operacje a¿ do odnalezienia formu³y lub wyst¹pienia b³êdu.
   je¿eli dla poszczególnych wyk³adowców wspó³czynniki ró¿ni¹ siê, wówczas zg³oœ b³¹d.

   w przypadku b³êdu funkcja zwraca wartoœæ 0. komunikat o b³êdzie odczytaj wówczas za pomoc¹ funkcji get_last_error. w celu diagnostyki b³edu sprawdŸ zmienne o nazwach zaczynaj¹cych siê od last
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
    
  
  --
  -- returns error_message (is any) by get_output_param_char1 
  --         copied records         by get_output_param_num1
  --         conflict records       by get_output_param_num2
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
   
   function  insert_str_elem ( pparent_id number, pchild_id number, pstr_name_lov varchar2 default 'STREAM') return varchar2;           
   procedure insert_str_elem ( pparent_id number, pchild_id number, pstr_name_lov varchar2 default 'STREAM');           

  -- zwraca wolny atrybut albo null
  --   
  function  flexGetFieldName (pmax_flex_num number, pform_name varchar2, pcontext_name varchar2, pfield_type varchar2 default 'S') return varchar2;

  function get_available_lec ( plec_id number ) return number;
  function get_available_gro ( pgro_id number ) return number;
  function get_available_rom ( prom_id number ) return number;

  function get_classes_selected_count return number;
    
  -- since wm_concat does not exist in Oracle10g  
  function get_group_types (pclass_id number) return varchar2;

end planner_utils;
/

prompt ### EXTENTION END
prompt ### EXTENTION BEGIN
prompt ### EXTENTION NAME:Core changes 2
prompt ### DATE:2013.11.02

CREATE OR REPLACE package body planner_utils is

  deleted_class_id number := null;

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
  end;
  
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
  end;

  
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
  
    -- Okres czasowy (A1,A2) ma czêœæ wspóln¹ z okresem czasowym (B1,B2), gdy spe³niony jest nastêpuj¹cy warunek logiczny:  
    if  (A1 >= B1 or A2 >= B1) and (A1 <= B2 or A2 <= B2)  then
      return 'Y';
    else
      return 'N';
    end if; 
  end;

  -----------------------------------------------------------------------------------------------------------------------------------------------------
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
      output_param_char1 := 'Okresy Ÿród³owy i docelowy nie mog¹ siê pokrywaæ';
      return;
    end if;   
  
    if dest_period_must_be_empty = 'Y' then
     declare
      c number;
     begin
     select count(*) 
       into c 
       from classes
       where day between dest_date_from and dest_date_to;
     if c > 0 then
       output_param_char1 := 'Nie mo¿na wykonaæ czynnoœci, poniewa¿ w obszarze docelowym s¹ ju¿ zaplanowane zajêcia. Je¿eli mimo to chcesz kontynuowaæ, zezwól na skopiowanie odznaczaj¹c pole wyboru na formularzu';
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
     select count(*) into classes_deleted 
       from classes 
      where day between pdate_from and pdate_to;
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
                         ,pcalc_rescat_ids  varchar2 default null --@@@todo: this parameter should be passed by interace
                        ) is
                        
    vcalc_lecturers  classes.calc_lecturers%type := pcalc_lecturers;
    vcalc_groups     classes.calc_groups%type := pcalc_groups;
    vcalc_rooms      classes.calc_rooms%type := pcalc_rooms;
    vcalc_lec_ids    classes.calc_lec_ids%type := pcalc_lec_ids;
    vcalc_gro_ids    classes.calc_gro_ids%type := pcalc_gro_ids;
    vcalc_rom_ids    classes.calc_rom_ids%type := pcalc_rom_ids;
    vcalc_rescat_ids classes.calc_rescat_ids%type := pcalc_rescat_ids;
    cla_seq_nextval number;
    t               number;
    debug_cnt       number := 0;
    procedure auto_grant_permissions is
    --used by public API
    --adds automatically perrmisions to owner
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
      for t in 1 .. xxmsz_tools.wordcount(pcalc_lec_ids, ';') loop
        begin
          insert into gro_pla (id,pla_id,gro_id) values (gropla_seq.nextval,ppla_id,xxmsz_tools.extractword(t,pcalc_gro_ids,';'));
        exception
         when dup_val_on_index then null;
        end;
      end loop;
      for t in 1 .. xxmsz_tools.wordcount(pcalc_lec_ids, ';') loop
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
  ----------------------------------------------------------------------------------------  
  begin
    -- prevent from planning in locked periods
    for rec in (
      select * 
        from periods
       where pday between date_from and date_to
         and locked_flag = '+'
         and created_by <> user 
    )
    loop
      raise_application_error(-20000, 'Planowanie zajêæ w terminie od '||to_char(rec.date_from,'yyyy-mm-dd')||' do '||to_char(rec.date_to,'yyyy-mm-dd')||' zosta³o zablokowane przez u¿ytkownika '||rec.created_by);
    end loop;    
    --
    if pgrantPermissions = 'Y' then auto_grant_permissions; end if;
  
  
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
    begin
      for t in 1 .. xxmsz_tools.wordcount(pcalc_lec_ids, ';') loop
        plec_id := xxmsz_tools.extractword(t,pcalc_lec_ids,';');
        insert into lec_cla (id, lec_id, cla_id, is_child, day, hour) values (leccla_seq.nextval,plec_id,cla_seq_nextval, 'N', pday, phour);      
        /*     
        for rec in (
            select unique child_id--, parent_id, level
              from lec_str_elems
             where str_name_lov='STREAM'
            connect by prior str_name_lov='STREAM' and prior child_id = parent_id  
            start with parent_id= xxmsz_tools.extractword(t,pcalc_lec_ids,';')
        )
        loop
          insert into lec_cla (id, lec_id, cla_id, is_child) values (leccla_seq.nextval,rec.child_id,cla_seq_nextval, 'Y');      
        end loop;
        */
      end loop;
    --exception
    --  when others then
    --    raise_application_error(-20000, 'lec='||plec_id||' day='||to_char(pday,'yyyy-mm-dd')||' hour='||phour);
    end;  
    
    for t in 1 .. xxmsz_tools.wordcount(pcalc_gro_ids, ';') loop
      insert into gro_cla (id, gro_id, cla_id, is_child, day, hour) values (grocla_seq.nextval,xxmsz_tools.extractword(t,pcalc_gro_ids,';'),cla_seq_nextval, 'N', pday, phour);
      /*     
      for rec in (
          select unique child_id --, parent_id, level
            from gro_str_elems
           where str_name_lov='STREAM'
          connect by prior str_name_lov='STREAM' and prior child_id = parent_id  
          start with parent_id= xxmsz_tools.extractword(t,pcalc_gro_ids,';')
       )
      loop
        insert into gro_cla (id, gro_id, cla_id, is_child) values (grocla_seq.nextval,rec.child_id,cla_seq_nextval, 'Y');      
      end loop;
      */
    end loop;

    for t in 1 .. xxmsz_tools.wordcount(pcalc_rom_ids, ';') loop
      insert into rom_cla (id, rom_id, cla_id, is_child, day, hour) values (romcla_seq.nextval,xxmsz_tools.extractword(t,pcalc_rom_ids,';'),cla_seq_nextval,'N', pday, phour);
      /*     
      for rec in (
          select unique child_id --, parent_id, level
            from res_str_elems
           where str_name_lov='STREAM'
          connect by prior str_name_lov='STREAM' and prior child_id = parent_id  
          start with parent_id= xxmsz_tools.extractword(t,pcalc_rom_ids,';')
      )
      loop
        insert into rom_cla (id, rom_id, cla_id, is_child) values (romcla_seq.nextval,rec.child_id,cla_seq_nextval, 'Y');      
      end loop;
      */
    end loop;

    if prefreshLGR = 'Y' then calculate_lgr(cla_seq_nextval, vcalc_lecturers, vcalc_groups, vcalc_rooms, vcalc_lec_ids, vcalc_gro_ids, vcalc_rom_ids, vcalc_rescat_ids); end if;
    insert into classes
                (id             , day  ,hour  ,fill  ,sub_id  ,for_id  ,owner  ,calc_lec_ids , calc_gro_ids , calc_rom_ids , calc_lecturers , calc_groups , calc_rooms , created_by        , colour  , desc1, desc2, desc3, desc4, calc_rescat_ids)
         values (cla_seq_nextval, pday ,phour ,pfill ,psub_id ,pfor_id ,powner ,vcalc_lec_ids, vcalc_gro_ids, vcalc_rom_ids, vcalc_lecturers, vcalc_groups, vcalc_rooms, nvl(pcreator,user), pcolour ,pdesc1,pdesc2,pdesc3,pdesc4, vcalc_rescat_ids);
    
    if ptt_comb_ids is not null then
      declare
       l_tt_comb_ids  varchar2(4000) := replace(ptt_comb_ids,';',',');
       l_comb_id      number; 
      begin
        for t in 1 .. xxmsz_tools.wordcount( l_tt_comb_ids, ',') loop
          l_comb_id := regexp_substr(l_tt_comb_ids, '([0-9]|[-])+', 1, t/*get t-th element*/); 
          tt_planner.book_combination ( l_comb_id, pfill/100 );
          insert into tt_cla (id, cla_id, tt_comb_id, units) values (tt_seq.nextval, cla_seq_nextval, l_comb_id, pfill/100);
        end loop;  
      end;
    end if;  
    
  end insert_classes;

  -----------------------------------------------------------------------------------------------------------------------------------------------------
  procedure update_lgrs is
    cursor cur is select id from classes;
    l       classes.calc_lecturers%type;
    g       classes.calc_groups%type;
    r       classes.calc_rooms%type;
    l_id    classes.calc_lec_ids%type;
    g_id    classes.calc_gro_ids%type;
    r_id    classes.calc_rom_ids%type;
    r_resid classes.calc_rescat_ids%type;
  begin
    disable_trial;
    for rec in cur loop
     calculate_lgr(rec.id, l, g, r, l_id, g_id, r_id, r_resid);
     update classes
     set    calc_lecturers = l,
            calc_groups    = g,
            calc_rooms     = r,
            calc_lec_ids   = l_id,
            calc_gro_ids   = g_id,
            calc_rom_ids   = r_id,
            calc_rescat_ids= r_resid
     where id = rec.id;
     commit;
    end loop;
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
               last_error := '(01)Odnaleziono kilka formu³ dla podanej formy, jednostki, typu formu³y, daty)';
               return 0;
             when no_data_found then
               guard := guard + 1;
               if guard > 100 then
                 last_error := '(02)Przekroczono dopuszczaln¹ liczbê zagnie¿d¿eñ w strukturze organizacyjnej ( 100 ). SprawdŸ, czy struktura organizacyjna nie zawiera cykli';
                 return null;
               else
                 select parent_id
                   into parent_orguni_id
                   from org_units
                  where id = aorguni_id;
                  if parent_orguni_id is null then
                    last_error := '(03)Nie odnaleziono formu³y dla formy prowadzenia zajêæ, zadanego dnia oraz jedn.org (oraz jednostek nadrzêdnych)';
                    return null;
                  else
                   return  get_orguni_formula ( parent_orguni_id );
                  end if;
               end if;
             when others        then
               last_error := '(04)Wyszukiwanie formu³y - b³¹d: ' || to_char (sqlcode) || ' ' || sqlerrm;
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
            last_error := '(05)Nie powiod³o siê wyznaczenie jednostki organizacyjnej dla wyk³adowcy. B³¹d: ' || to_char (sqlcode) || ' ' || sqlerrm;
            return 0;
        end;

        if aorguni_id is null then
           last_error := '(06)Dla wyk³adowcy nie okreœlono jednostki organizacyjnej - nie mo¿na wyznaczyæ formu³y';
           return 0;
        end if;

        ffformula := get_orguni_formula ( aorguni_id );
        if ffformula is null then --blad
         return 0;
        end if;

        ffformula := replace (ffformula, 'Zaogr¹glij'      , 'Round');
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
            last_error := '(07)B³¹d podczas wyliczania formu³y "' || FFFORMULA || '" B³¹d: ' || to_char (sqlcode) || ' ' || sqlerrm;
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
        last_error := '(08)Nie mo¿na wyznaczyæ wspó³czynnika, poniewa¿ nie okreœlono wyk³adowcy';
        return 0;
      end if;

      if acalc_groups is null then
        last_error := '(09)Nie mo¿na wyznaczyæ wspó³czynnika, poniewa¿ nie okreœlono grup';
        return 0;
      end if;

      select nvl( sum ( number_of_peoples ), 0)
        into anumber_of_peoples
        from groups
        where id in ( select gro_id from gro_cla where cla_id = aid );

      if anumber_of_peoples = 0 then
        last_error := '(10)Nie mo¿na wyznaczyæ wspó³czynnika, poniewa¿ nie okreœlono licznoœci grup';
        return 0;
      end if;

      last_for_id            := afor_id;
      last_horus             := ahours;
      last_number_of_peoples := anumber_of_peoples;

      -- wyznacz wspó³czynnik dla ka¿dego wyk³adowcy
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
            last_error := '(11)Otrzymano ró¿ne wartoœci wspó³czynnika dla wyk³adowców prowadz¹cych zajêcie (' || prior_coe || ', '||  coe || ')';
            return 0;
          end if;
        end if;
      end loop;

      if last_error is not null then
        last_error := last_error || ' wywo³anie: GET_CLASS_COEFFFICIENT ( '||aid||','''||aform_formula_type||''',TO_DATE(' || to_char(aday,'YYYY-MM-DD') || ',''YYYY-MM-DD''))';
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
  procedure merge_res (save_id number, delete_id number, administrator_merging varchar2) is
   TYPE tcla_id_list IS TABLE OF NUMBER(15);
   cla_id_list tcla_id_list;
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
         raise_application_error(-20000, 'Zasób, który probujesz scaliæ, zosta³ u¿yty przez innych planistów. Je¿eli mimo to chcesz dokonaæ scalenia, zaznacz pole wyboru "Zezwól na scalanie je¿eli istniej¹ zajêcia zaplanowane przez innych planistów"');
       end if;  
      end;           
    end if;
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
  end merge_res;                   

  -----------------------------------------------------------------------------------------------------------------------------------------------------
  procedure merge_lec (save_id number, delete_id number, administrator_merging varchar2) is
   TYPE tcla_id_list IS TABLE OF NUMBER(15);
   cla_id_list tcla_id_list;
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
         raise_application_error(-20000, 'Dane o wyk³adowcy, które próbujesz scaliæ, zosta³y u¿yte przez innych planistów. Je¿eli mimo to chcesz dokonaæ scalenia, zaznacz pole wyboru "Zezwól na scalanie je¿eli istniej¹ zajêcia zaplanowane przez innych planistów"');
       end if;  
      end;           
    end if;
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
  end merge_lec;                   
    
  -----------------------------------------------------------------------------------------------------------------------------------------------------
  procedure merge_gro (save_id number, delete_id number, administrator_merging varchar2) is
   TYPE tcla_id_list IS TABLE OF NUMBER(15);
   cla_id_list tcla_id_list;
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
         raise_application_error(-20000, 'Dane o grupie, które probujesz scaliæ, zosta³y u¿yte przez innych planistów. Je¿eli mimo to chcesz dokonaæ scalenia, zaznacz pole wyboru "Zezwól na scalanie je¿eli istniej¹ zajêcia zaplanowane przez innych planistów"');
       end if;  
      end;           
    end if;
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
         raise_application_error(-20000, 'Przedmiot, który probujesz scaliæ, zosta³ u¿yty przez innych planistów. Je¿eli mimo to chcesz dokonaæ scalenia, zaznacz pole wyboru "Zezwól na scalanie je¿eli istniej¹ zajêcia zaplanowane przez innych planistów"');
       end if;  
      end;           
    end if;
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
         raise_application_error(-20000, 'Przedmiot, który probujesz scaliæ, zosta³ u¿yty przez innych planistów. Je¿eli mimo to chcesz dokonaæ scalenia, zaznacz pole wyboru "Zezwól na scalanie je¿eli istniej¹ zajêcia zaplanowane przez innych planistów"');
       end if;  
      end;           
    end if;
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
  end merge_FOR;                   

  -----------------------------------------------------------------------------------------------------------------------------------------------------
  function insert_str_elem ( pparent_id number, pchild_id number, pstr_name_lov varchar2 default 'STREAM') return varchar2 is
   c number;
  begin
    if pparent_id = pchild_id then return 'Zasób nie mo¿e byæ sam dla siebie podrzêdny ani nadrzêdny'; end if;
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
    if c > 0 then return 'Dodanie rekordu spowodowa³oby zapêtlenie danych. Elementem nadrzêdnym nie mo¿e byæ element, który ju¿ jest elementem podrzêdnym'; end if;
    select count(*)
     into c 
     from
     (select child_id id_list
        from str_elems
        where str_name_lov = pstr_name_lov
        connect by prior child_id = parent_id  
        start with parent_id=pchild_id)
    where id_list = pparent_id;    
    if c > 0 then return 'Dodanie rekordu spowodowa³oby zapêtlenie danych. Elementem podrzêdnym nie mo¿e byæ element, który ju¿ jest elementem nadrzêdnym'; end if;    
    begin
      insert into str_elems (id, parent_id, child_id, str_name_lov) values (main_seq.nextval, pparent_id, pchild_id,pstr_name_lov);
      return '';
    exception 
      when others then 
        if sqlcode = -1 then return 'Ta kombinacja ju¿ istnieje. Rekord nie zosta³ dodany ponownie'; else return sqlerrm; end if;
    end;
  end insert_str_elem;           

  -----------------------------------------------------------------------------------------------------------------------------------------------------
  procedure insert_str_elem ( pparent_id number, pchild_id number, pstr_name_lov varchar2 default 'STREAM') is
  begin
    output_param_char1 := insert_str_elem (pparent_id, pchild_id, pstr_name_lov);
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

end planner_utils;
/
prompt ### EXTENTION END
prompt ### EXTENTION BEGIN
prompt ### EXTENTION NAME:Core changes 3
prompt ### DATE:2013.11.03

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
   | 2013.11.03 bugfixing  
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
  -- updated class has the same id (in_out_class_id).
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
   
   function translate_message (psqlerrm varchar2) return varchar2;

end;
/

prompt ### EXTENTION END
prompt ### EXTENTION BEGIN
prompt ### EXTENTION NAME:Core changes 4
prompt ### DATE:2013.11.04

CREATE OR REPLACE package body api is

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
  end can_insert_class; 

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
  end insert_class; 


  -----------------------------------------------------------------------------------------------------------------------------------------------------
  function delete_class ( pid number ) return varchar2 is
  pragma autonomous_transaction; 
  begin
    delete_class(pid);
    commit;
    return null;
  end delete_class;
  

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
  end update_class;

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
  end update_class; 


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

prompt ### EXTENTION END
prompt ### EXTENTION BEGIN
prompt ### EXTENTION NAME:Core changes 5
prompt ### DATE:2013.11.05

CREATE OR REPLACE package tt_planner is

   /*****************************************************************************************************************************
   |* Public api to create available combinations and check if there available combination exists
   |  Do not change database manually. instead of this, use this package.
   |  TT is a shorcut for time table. 
   |
   |   Data model
   |   
   |      TT_RESCAT_COMBINATIONS  
   |       -< TT_COMBINATIONS                 [RESCAT_COMB_ID] NULLABLE:N CNAME:TT_COMBINATIONS_FK1
   |           -< TT_INCLUSIONS               [TT_COMB_ID]     NULLABLE:N CNAME:TT_INCLUSIONS_FK1
   |           -< TT_RESOURCE_LISTS           [TT_COMB_ID]     NULLABLE:N CNAME:TT_RESOURCE_LISTS_FK1
   |           -< TT_CLA                      [TT_COMB_ID]     NULLABLE:N CNAME:TT_CLA_FK2
   |               >- CLASSES                 [CLA_ID]         NULLABLE:N CNAME:TT_CLA_FK1
   |       -< TT_PLA                          [RESCAT_COMB_ID] NULLABLE:N CNAME:TT_PLA_FK2
   |           >- PLANNERS                    [PLA_ID]         NULLABLE:N CNAME:TT_PLA_FK1
   |       -< TT_RESCAT_COMBINATIONS_DTL      [RESCAT_COMB_ID] NULLABLE:N CNAME:TT_RESCAT_COMBINATIONS_DTL_FK1
   |           >- RESOURCE_CATEGORIES         [RESCAT_ID]      NULLABLE:N CNAME:TT_RESCAT_COMBINATIONS_DTL_FK2
   |      
   |  Summary
   |    function  put_combination - Adds/updates combination and returns combination id
   |    procedure put_combination - Same as function, does not returns combination id (for your convienence) 
   |  
   |    function verify           - Checks whether combination exists, populates result table tt_check_results
   |    procedure verify        - Same as function, does not returns status (for yout convienence)
   |
   |    get_review_sql            - Gets sql to review combinations in user frendly way. sql shows combinations according do passed resources and resource categories only
   |
   |*****************************************************************************************************************************
   | History
   | 2011.08.07 Maciej Szymczak created 
   | 2011.09.01 Maciej Szymczak updates
   | 2011.11.17 Maciej Szymczak updates (bind params)
   | 2011.11.27 Maciej Szymczak updates (performance improvement)
   | 2011.11.29 Maciej Szymczak updates (log improvement)
   | 2012.01.14 Maciej Szymczak disable_res_limitation 
   | 2012.02.18 Maciej Szymczak get_rescat_desc - changes
   | 2012.07.14 Maciej Szymczak function get_res_desc - changes, function get_tt_comb_res_desc - new
   | 2013.11.03 bugfixing  
   \-----------------------------------------------------------------------------------------------------------------------------*/
   
g_form      number := -2;
g_subject   number := -3;
g_lecturer  number := -4;
g_group     number := -5;
g_planner   number := -6;
g_period    number := -7;
g_date_hour number := -8;


----------------------------------------------------------------------------------------------------------------------------------------------
/*
function         : put_combination
description      : inserts or updates combination. 
Impact on tables : tt_combinations, tt_inclusions, tt_resource_lists
used by          : TFBrowseTT_COMBINATIONS.AfterPost
parameters       : p_res_ids           - comma separated resource list
                   p_all_rescat_ids    - comma separated resource category list. all resources of this category are always permitted (parameter p_res_ids should not contain resources of this type)
                   p_tt_comb_id        - on insert should be null
                                         on update should be tt_combinations.id
                   p_avail_type        - 'N' for non limit combination (any number of combinations is permitted) , 'L' for limit combination (plan table)
                   p_avail_orig        - when p_avail_type is 'N' then left null
                                         when p_avail_type is 'L' then original numer of classes to plan
                   p_avail_curr        - on insert should be null
                                         ob update this is p_avail_orig - numer of scheduled classes
                   p_enabled           - 'Y' for combination enabled, 'N' for combination disabled ( not active )
                   p_sort_order        - sort order which may be used on form ( for visual effect )
return value     : new tt_class id
*/
function put_combination (
  p_rescat_comb_id  number
 ,p_res_ids         varchar2
 ,p_all_rescat_ids  varchar2 default null
 ,p_tt_comb_id      number   default null
 ,p_avail_type      varchar2  
 ,p_avail_orig      number  
 ,p_avail_curr      number 
 ,p_enabled         char 
 ,p_sort_order      number
) return number;
      
----------------------------------------------------------------------------------------------------------------------------------------------
-- does the same as function put_combination, no result value
procedure put_combination (
  p_rescat_comb_id  number
 ,p_res_ids         varchar2
 ,p_all_rescat_ids  varchar2 default null
 ,p_tt_comb_id      number   default null
 ,p_avail_type      varchar2  
 ,p_avail_orig      number  
 ,p_avail_curr      number 
 ,p_enabled         char 
 ,p_sort_order      number
);

----------------------------------------------------------------------------------------------------------------------------------------------
/*
function         : verify
description      : verifies whether combination is valid 
Impact on tables : no impact
used by          : TFmain.insertClasses
                   TFTTCheckResults.fbrowseClick ( after new combination is added)
                   TFBrowseTT_COMBINATIONS.checkRecord ( to check, wheter this combination really must be insert )                    
parameters       : p_pla_id          - planners.id. Only tt_combinations active for this planners are validated ( table TT_PLA )
                   p_res_ids         - comma separated resource list 
                   p_auto_fix        - 'Y' means that missed combination will automatically added to the system configuration. When p_auto_fix=Y then function always returns N
                   p_current_comb_id - eliminates current combination from checking. Parametr used by TFBrowseTT_COMBINATIONS.checkRecord only on update record
                   p_no_subsets      - 'Y' means that subcombinations are not examined. parameter curently not used.
return value     :'N' - there is a problem, not all combinations required were found. Use this sql to see details
                        select * from tt_check_results
                  'Y' - OK      
examples
  declare
   l_res varchar2(100);
  begin
   l_Res := planner_tt.verify ('1000117,4000403,4000401', 'Y');
   --raise_application_error(-20000, 'l_res=' || l_res);
  end;
  select id, found_tt, res_id1, rescat_id1, res_desc1, res_id2, rescat_id2, res_desc2, res_id3, rescat_id3, res_desc3, res_id4, rescat_id4, res_desc4, res_id5, rescat_id5, res_desc5, res_id6, rescat_id6, res_desc6, res_id7, rescat_id7, res_desc7, res_id8, rescat_id8, res_desc8, res_id9, rescat_id9, res_desc9, res_id10, rescat_id10, res_desc10 from tt_check_results
*/
function  verify ( p_pla_id number, p_res_ids  varchar2, p_auto_fix varchar2 default 'N', p_current_comb_id number default -1, p_no_subsets varchar2 default 'N' ) return varchar2;   
procedure verify ( p_pla_id number, p_res_ids  varchar2, p_auto_fix varchar2 default 'N', p_current_comb_id number default -1, p_no_subsets varchar2 default 'N' );         
   

-------------------------------------------------------------------------------------------------------------------------------------------------------
/*
function         : get_rescat_id, get_res_desc
description      : return resource category id and resource description for given resource id
Impact on tables : no impact
used by          : TFmain.BSelectCombClick
                   UFDetails.BSelectCombClick
                   TFBrowseTT_COMBINATIONS.BeforeEdit
parameters       : p_res_id - resource id lecturer.id or group.id of rooms.id or planners.id or periods.id of forms.id or subjects.id
return value     : get_rescat_id - resource category id ( resource_categories.id)
                   get_res_desc  - name of resource
*/
function get_rescat_id   (p_res_id number) return number;
function get_res_desc    (p_res_id number, p_rescat_id number default null, p_include_res_type varchar2 default 'Y') return varchar2;



-------------------------------------------------------------------------------------------------------------------------------------------------------
/*
function         : get_resource_cat_names
description      : gets names of resource categories selected in combination type (table tt_rescat_combinations)
Impact on tables : no impact
used by          : module DM
                   UFBrowseTT_COMBINATIONS.RESCAT_COMB_IDChange
parameters       : prescat_comb_id - tt_rescat_combinations.id
return value     : names of resource categories selected in combination type 
*/
function get_resource_cat_names ( prescat_comb_id number ) return varchar2;


-------------------------------------------------------------------------------------------------------------------------------------------------------
/*
function         : populate_rescat_comb_dtl
description      : gets names of resource categories selected in combination type (table tt_rescat_combinations)
Impact on tables : tt_rescat_combinations_dtl ( insert / delete ) 
used by          : TFBrowseTT_RESCAT_COMBINATIONS.AfterPost
parameters       : prescat_comb_id - tt_rescat_combinations.id
                   l_rescat_ids    - comma separated list of resource categories ( resource_categories.id )
return value     : - 
*/
procedure populate_rescat_comb_dtl (prescat_comb_id number, l_rescat_ids varchar2);

-------------------------------------------------------------------------------------------------------------------------------------------------------
/*
function         : get_filter
description      : gets where clause for statement: select * from tt_combinations where ...
Impact on tables : - 
used by          : TFBrowseTT_COMBINATIONS.CustomConditions
parameters       : p_res_ids - comma separated list od resources
return value     : - 
*/
function get_filter (p_res_ids varchar2) return varchar2;

-------------------------------------------------------------------------------------------------------------------------------------------------------
/*
function         : set_res_limitation
description      : gets where clause for statement: select * from <resource table> where ...
                   limits LOV of resources to available resources only
Impact on tables : - 
used by          : TFDetails.setResLimitation
parameters       : p_pla_id    - planners.id. Only tt_combinations active for this planners are validated ( table TT_PLA )
                   p_res_ids   - comma separated list of values selected by user formaly
                   p_rescat_id - LOV resource category id (resource_categories.id)
return value     : no return value. Non available resource list is saved to temporary table tt_ids. 
                   Then, application limits LOV this way: <resource table>.id in (select id from <resource table> minus select  id from tt_ids)
*/
procedure set_res_limitation ( p_pla_id number, p_res_ids  varchar2, p_rescat_id number);
 
----------------------------------------------------------------------------------------------------------------------------------------------
/*
function         : book_combination, unbook_combination
description      : book_combination decreates current use combination ( tt_combinations.avail_cur ) 
                   unbook_combination increates current use combination ( tt_combinations.avail_cur )
Impact on tables : tt_cla (select)
used by          : planner_utils.insert_classes
parameters       : p_tt_comb_id - combination to increase/decrease
return value     : comma separated tt_cla.tt_comb_id values
*/
procedure book_combination ( p_tt_comb_id number, punits number );
procedure unbook_combination ( p_tt_comb_id number, punits number  );

----------------------------------------------------------------------------------------------------------------------------------------------
/*
function         : recalc_book_combination
description      : complex function, which recalculates utilization of combination
Impact on tables : tt_combinations (update)
used by          : TFBrowseTT_COMBINATIONS.Recalculate_AVAIL_CURR
parameters       : p_tt_comb_id - combination recualculation
return value     : -
*/
procedure recalc_book_combination ( p_tt_comb_id number );    
 
----------------------------------------------------------------------------------------------------------------------------------------------
/*
function         : set_res_limitation
description      : gets comma separated tt_cla records for given classed.id. Used by : move, copy and other group functions
                   does not check combinations. just use old ones and thus makes operation faster
Impact on tables : tt_cla (select)
used by          : TFMain.modifyClass
parameters       : p_cla_id - classes.id
return value     : comma separated tt_cla.tt_comb_id values
*/
function get_tt_cla ( p_cla_id number ) return varchar2;





------------------------------------- internal routines ----------------------------------------------------------------------------------------------
/*
function         : bitor
description      : calculates distinct sum of wieghts of resource caterogies
Impact on tables : - 
used by          : tt_planner.verify
parameters       : x1..x30 numbers (this numbers are from domain: 2^0, 2^1, 2^2, 2^3, .. )
return value     : logical OR
*/
function bitor(x1 in number
             , x2 in number default 0
             , x3 in number default 0
             , x4 in number default 0
             , x5 in number default 0
             , x6 in number default 0
             , x7 in number default 0
             , x8 in number default 0
             , x9 in number default 0
             , x10 in number default 0
             , x11 in number default 0
             , x12 in number default 0
             , x13 in number default 0
             , x14 in number default 0
             , x15 in number default 0
             , x16 in number default 0
             , x17 in number default 0
             , x18 in number default 0
             , x19 in number default 0
             , x20 in number default 0
             , x21 in number default 0
             , x22 in number default 0
             , x23 in number default 0
             , x24 in number default 0
             , x25 in number default 0
             , x26 in number default 0
             , x27 in number default 0
             , x28 in number default 0
             , x29 in number default 0
             , x30 in number default 0
             )
  return number deterministic parallel_enable;


---------------------------------- Currently not used routines --------------------------------------------------------------------------------
/*
function         : get_review_sql 
description      : gets sql to review combinations in user frendly way
                   sql shows combinations according do passed resources and resource categories only
                   Currently not used.
Impact on tables : no impact
used by          : TFTTCombinations.BRefreshClick             
parameters       : p_res_ids    - comma separated list of resources
                   p_rescat_ids - comma separated list of resource categories
return value     : sql statement
*/
function get_review_sql (p_res_ids varchar2, p_rescat_ids varchar2) return varchar2;

-- used by get_review_sql
function get_rescat_desc (p_rescat_id number) return varchar2;
function get_tt_comb_res_desc (p_tt_comb_id number, p_rescat_id number default null) return varchar2;

end tt_planner;
/

prompt ### EXTENTION END
prompt ### EXTENTION BEGIN
prompt ### EXTENTION NAME:Core changes 6
prompt ### DATE:2013.11.06

CREATE OR REPLACE package body tt_planner is

debug_mode boolean;
disable_res_limitation boolean;

--used by functions function execute_immediate
   g_table      dbms_sql.varchar2s;
   g_c          number;
   g_rc         number;
   g_result     varchar2(4000);

-------------------------------------------------------------------------------------------------------------------------------------------------------
procedure wlog ( pmessage varchar2, pparameters clob) is
pragma autonomous_transaction;
begin
 if not debug_mode then return; end if;
 insert into tt_log (id, message, parameters) values (tt_seq.nextval, pmessage, pparameters);
 commit;
end wlog;

-------------------------------------------------------------------------------------------------------------------------------------------------------
function bitor(x1 in number
             , x2 in number default 0
             , x3 in number default 0
             , x4 in number default 0
             , x5 in number default 0
             , x6 in number default 0
             , x7 in number default 0
             , x8 in number default 0
             , x9 in number default 0
             , x10 in number default 0
             , x11 in number default 0
             , x12 in number default 0
             , x13 in number default 0
             , x14 in number default 0
             , x15 in number default 0
             , x16 in number default 0
             , x17 in number default 0
             , x18 in number default 0
             , x19 in number default 0
             , x20 in number default 0
             , x21 in number default 0
             , x22 in number default 0
             , x23 in number default 0
             , x24 in number default 0
             , x25 in number default 0
             , x26 in number default 0
             , x27 in number default 0
             , x28 in number default 0
             , x29 in number default 0
             , x30 in number default 0
             )
  return number deterministic parallel_enable
is
    function or2args(x in number, y in number)
      return number deterministic parallel_enable
    is
    begin
      return x + y - bitand(x, y);
    end;
begin
  return or2args(or2args(or2args(or2args(or2args(or2args(or2args(or2args(or2args(or2args(or2args(or2args(or2args(or2args(or2args(or2args(or2args(or2args(or2args(or2args(or2args(or2args(or2args(or2args(or2args(or2args(or2args(or2args(or2args(x1, x2),x3),x4),x5),x6),x7),x8),x9),x10),x11),x12),x13),x14),x15),x16),x17),x18),x19),x20),x21),x22),x23),x24),x25),x26),x27),x28),x29),x30);
end bitor;


-------------------------------------------------------------------------------------------------------------------------------------------------------
function get_rescat_id (p_res_id number) return number is
  res number;
begin
  select coalesce (
        (select g_form     from forms     where id = p_res_id)
       ,(select g_subject  from subjects  where id = p_res_id)
       ,(select g_lecturer from lecturers where id = p_res_id)
       ,(select g_group    from groups    where id = p_res_id)
       ,(select rescat_id  from rooms     where id = p_res_id)
       ,(select g_planner  from planners  where id = p_res_id)
       ,(select g_period   from periods   where id = p_res_id)
       ) 
  into res
  from dual;
  return res;
end get_rescat_id; 

-------------------------------------------------------------------------------------------------------------------------------------------------------
function get_resource_table_name (p_rescat_id number) return varchar2 is
begin
  case p_rescat_id 
    when g_form     then return 'forms'; 
    when g_subject  then return 'subjects';
    when g_lecturer then return 'lecturers';
    when g_group    then return 'groups';
    when g_planner  then return 'planners';
    when g_period   then return 'periods';
    else return 'rooms';  
  end case;
end get_resource_table_name; 



-------------------------------------------------------------------------------------------------------------------------------------------------------
function get_res_desc (p_res_id number, p_rescat_id number default null, p_include_res_type varchar2 default 'Y') return varchar2 is
  res        varchar2(240);
  res_name   varchar2(240);
  l_rescat_id number := p_rescat_id;
begin
  if p_res_id is null then return null; end if;
  --
  if l_rescat_id is null then
    l_rescat_id :=  get_rescat_id (p_res_id);
  end if;
  --
  select sql_name
    into res_name 
    from resource_categories where id = l_rescat_id;
 
  case l_rescat_id 
    when  g_form     then execute immediate 'select ' || res_name || ' from forms     where id = :id' into res using p_res_id;
    when  g_subject  then execute immediate 'select ' || res_name || ' from subjects  where id = :id' into res using p_res_id;
    when  g_lecturer then execute immediate 'select ' || res_name || ' from lecturers where id = :id' into res using p_res_id;
    when  g_group    then execute immediate 'select ' || res_name || ' from groups    where id = :id' into res using p_res_id;
    when  g_planner  then execute immediate 'select ' || res_name || ' from planners  where id = :id' into res using p_res_id;
    when  g_period   then execute immediate 'select ' || res_name || ' from periods   where id = :id' into res using p_res_id;
    -- rescat_id
    else                  
      select name||' '||substr(attribs_01,1,55)                                   
        into res 
        from rooms   
       where id = p_res_id;                              
  end case;
  if p_include_res_type = 'Y' then return get_rescat_desc (l_rescat_id) || ': ' || res;
                              else return res; end if;
exception
 when others then   
   raise_application_error(-20000, 'get_res_desc. p_res_id=' || p_res_id || ' l_rescat_id=' || l_rescat_id || 'sqlerrm=' || sqlerrm);
end get_res_desc; 


-------------------------------------------------------------------------------------------------------------------------------------------------------
function get_rescat_desc (p_rescat_id number) return varchar2 is
  res varchar2(240);
begin
  select upper(name) 
    into res
    from resource_categories 
   where id = p_rescat_id;
  -- 
  return res;
exception
 when others then   
   raise_application_error(-20000, 'get_rescat_desc. p_rescat_id=' || p_rescat_id);
end get_rescat_desc; 

-------------------------------------------------------------------------------------------------------------------------------------------------------
procedure parse_immediate (p_clobe_proc clob, p_return_value boolean) is
  ------------------------------------------------------------------------------------
  procedure clob_to_table (p_clob in clob, p_table in out nocopy dbms_sql.varchar2s) is
    c_length       constant number := 200; --not 256 : polish chars can be stored on 2 bytes
    v_licznik      binary_integer;
    v_rozmiar      number;
  begin
    v_rozmiar := dbms_lob.getlength(p_clob);
    v_licznik := ceil(v_rozmiar / c_length);
    if v_licznik > 0 then
      p_table.delete;
      for i in 1..v_licznik loop
        if i != v_licznik then
          p_table(i) := dbms_lob.substr(p_clob, c_length, (i - 1) * c_length + 1);
        else
          p_table(i) := dbms_lob.substr(p_clob, v_rozmiar - (i - 1) * c_length, (i - 1) * c_length + 1);
        end if;
      end loop;
    end if;
  end;
  ------------------------------------------------------------------------------------
begin
    g_table.delete;
    clob_to_table(p_clobe_proc, g_table);
    g_c := dbms_sql.open_cursor;
    dbms_sql.parse(g_c, g_table, g_table.first, g_table.last, false, 1);
    if p_return_value then        
      dbms_sql.define_column(g_c,1,g_result,4000);
    end if;
end parse_immediate;

-------------------------------------------------------------------------------------------------------------------------------------------------------
function execute_immediate (p_return_value boolean) return varchar2 is
begin
    g_rc := dbms_sql.execute(g_c);
    
    if p_return_value then        
      if dbms_sql.fetch_rows(g_c) >0 then
        dbms_sql.column_value(g_c, 1, g_result);
      end if;        
    end if;
    
    dbms_sql.close_cursor(g_c);
    return g_result;
end execute_immediate;



-------------------------------------------------------------------------------------------------------------------------------------------------------
function put_combination (
  p_rescat_comb_id  number
 ,p_res_ids         varchar2
 ,p_all_rescat_ids  varchar2 default null
 ,p_tt_comb_id      number   default null
 ,p_avail_type      varchar2  
 ,p_avail_orig      number  
 ,p_avail_curr      number 
 ,p_enabled         char 
 ,p_sort_order      number
) return number is
 l_tt_comb_id      number;
 l_res_ids         varchar2(32000) := replace(p_res_ids,';',',');
 l_all_rescat_ids  varchar2(32000) := replace(p_all_rescat_ids,';',',');
 --
 procedure add_inclusion (p_rescat_id number, p_rescat_incl_type varchar2) is
 begin
   insert into tt_inclusions (id, tt_comb_id, rescat_id, inclusion_type) values (tt_seq.nextval, l_tt_comb_id, p_rescat_id, p_rescat_incl_type);
 exception
  when dup_val_on_index then null; --ignore duplicates
  when others then raise_application_error(-20000, 'p_rescat_id=' || p_rescat_id || ' ' || sqlerrm);
 end;
--------------- 
begin
  -- erase redundand commas, for example: 1,,,2,,,,, --> 1,2
  -- redundant commas are generated by put_combination inside verify
  l_res_ids := trim(',' from l_res_ids);
  --while length( l_res_ids ) <> length ( replace(l_res_ids,',,',',') ) loop
  --  l_res_ids := replace(l_res_ids, ',,',',');
  --end loop;
  --   
  wlog('put_combination(+)', l_res_ids);
  savepoint put_combination;
  if p_tt_comb_id is null then
    select tt_seq.nextval into l_tt_comb_id from dual;
    insert into tt_combinations (id, rescat_comb_id, avail_type, avail_orig, avail_curr, enabled, sort_order) values ( l_tt_comb_id, p_rescat_comb_id, p_avail_type, p_avail_orig, p_avail_curr, p_enabled, p_sort_order );
  else
    delete from tt_inclusions     where tt_comb_id = p_tt_comb_id;
    delete from tt_resource_lists where tt_comb_id = p_tt_comb_id;
    l_tt_comb_id := p_tt_comb_id;
  end if;   
  --
  declare
    l_res_id number;
  begin
    for t in 1 .. xxmsz_tools.wordcount( l_res_ids, ',') loop
      l_res_id := regexp_substr(l_res_ids, '([0-9]|[-])+', 1, t/*get t-th element*/); 
      if l_res_id is not null then 
        insert into tt_resource_lists (id, tt_comb_id, res_id) values (tt_seq.nextval, l_tt_comb_id,  l_res_id );
        add_inclusion ( get_rescat_id(l_res_id), 'LIST' );
      end if;
    end loop;
  end; 
  --
  declare
    l_rescat_id number;
  begin
    for t in 1 .. xxmsz_tools.wordcount( l_all_rescat_ids, ',') loop
      l_rescat_id := regexp_substr(l_all_rescat_ids, '([0-9]|[-])+', 1, t/*get t-th element*/);  
      if l_rescat_id is not null then 
        add_inclusion ( l_rescat_id, 'ALL' );
      end if;
    end loop;
  end;
  -- 
  update tt_combinations c
     set rescat_comb_id = p_rescat_comb_id
       , weight         = (select sum( (select weight from resource_categories rc where rc.id = ri.rescat_id) ) from tt_inclusions ri where tt_comb_id = c.id)
       , avail_type     = p_avail_type        
       , avail_orig     = p_avail_orig        
       , avail_curr     = p_avail_curr       
       , enabled        = p_enabled          
       , sort_order     = p_sort_order      
   where id = l_tt_comb_id;
  return l_tt_comb_id;
end put_combination; 

-------------------------------------------------------------------------------------------------------------------------------------------------------
procedure put_combination (
  p_rescat_comb_id  number
 ,p_res_ids             varchar2
 ,p_all_rescat_ids      varchar2 default null
 ,p_tt_comb_id          number   default null
 ,p_avail_type          varchar2  
 ,p_avail_orig          number  
 ,p_avail_curr          number 
 ,p_enabled             char 
 ,p_sort_order          number
) is
 l_dummy  number;
begin
 l_dummy := put_combination (
    p_rescat_comb_id
   ,p_res_ids   
   ,p_all_rescat_ids 
   ,p_tt_comb_id
   ,p_avail_type        
   ,p_avail_orig        
   ,p_avail_curr       
   ,p_enabled          
   ,p_sort_order      
   );
end put_combination;


-------------------------------------------------------------------------------------------------------------------------------------------------------
function verify ( p_pla_id number, p_res_ids  varchar2, p_auto_fix varchar2 default 'N', p_current_comb_id number default -1, p_no_subsets varchar2 default 'N') return varchar2 
is
  l_res_ids     varchar2(32000) := replace(p_res_ids, ';', ',' );
  l_complete_sql varchar2(32000);
  --
  l_select_cols        varchar2(32000);
  l_select_cols_sel    varchar2(32000);
  l_where_clause       varchar2(32000);
  l_data_select        varchar2(32000);
  l_where_weight       varchar2(4000);
  l_where_cardinality  varchar2(4000);
  l_order_by           varchar2(4000);
  l_no_subsets         varchar2(4000);
  l_elem_count         number;
  --l_rescat_count       number := 0;
  --l_sum_rescat_weight  number := 0;
-------------------------------------------------------
begin
  wlog('verify(+)', 'p_res_ids=' || p_res_ids );
  declare
    l_col_name      varchar2(10);
  begin
    l_elem_count := xxmsz_tools.wordcount( l_res_ids, ','); 
    for t in 1 .. l_elem_count  loop
      l_col_name  := 'res_id'||t;
      -- not already added => add 
      --if bitand(l_sum_rescat_weight, l_rescat_weight) = 0 then
      --  l_sum_rescat_weight := l_sum_rescat_weight + l_rescat_weight; 
      --  l_rescat_count := l_rescat_count + 1;
      --end if;
      l_select_cols        := l_select_cols || l_col_name ||', rescat_id'||t||', res_desc'||t||',';
      l_select_cols_sel    := l_select_cols_sel || l_col_name ||', rescat_id'||t||', decode('||l_col_name||',null,null,res_desc'||t||'),';
      l_where_clause       := l_where_clause || 'and ( ttc.id in ( select tt_comb_id from tt_resource_lists where res_id = res_id'||t||' ) or res_id'||t||' =0 or ttc.id in (select tt_comb_id from tt_inclusions where rescat_id = rescat_id'||t||' and inclusion_type = ''ALL'') ) ';
      l_data_select        := xxmsz_tools.merge( 
                                 l_data_select 
                               , '( select :id'||t||' '||l_col_name||', :rc_id'||t||' rescat_id'||t||', :rc_w'||t||' rescat_weight'||t||', :r_desc'||t||' res_desc'||t||', 1 grouping_res_id'||t||' from dual union all select 0,0,0,''-'',0 from dual)'
                               , ',');
      -- combination (group, subject, form)  has weight 8 + 32 + 64 = 104     and cardinality 3
      -- combination (lecturer, subject)     has weight 16 + 32     = 48      and cardinality 2
      -- combination (group, group, subject) has weight 8 + 8 + 32  = 48 (!!) and cardinality 3
      -- thus thanks cardinality combination (group, group, subject) differs from (lecturer, subject) 
      -- moreover thanks to cardinality we can identity combination (group, group) which has weight 8+8=16 (same as lecturer) but cardinality 2
      l_where_weight       := xxmsz_tools.merge( l_where_weight, 'rescat_weight'||t, '+' ); 
      l_where_cardinality  := xxmsz_tools.merge( l_where_cardinality, 'grouping_res_id'||t, '+' ); 
      l_order_by           := xxmsz_tools.merge( l_order_by, to_char(t*3), ', ' );
      l_no_subsets         := xxmsz_tools.merge( l_no_subsets, 'grouping_res_id'||t||'=1', ' and ');
    end loop;
  end;
  --
  delete from tt_check_results;
  --
  l_complete_sql := 
  'insert into tt_check_results (id, '||l_select_cols||' found_tt, rescat_comb_id)
  select tt_check_results_seq.nextval, '||l_select_cols_sel ||'
         (select ttc.id 
            from tt_combinations ttc, tt_rescat_combinations  ttrc, tt_pla 
            where rownum = 1 and tt_pla.pla_id = :p_pla_id1 and ttrc.id  = ttc.rescat_comb_id and tt_pla.rescat_comb_id = ttrc.id and ttc.enabled = ''Y'' /*and (avail_type=''N'' or (avail_type=''L'' and avail_curr > 0))*/ and ttc.weight=distinct_weight_sum and ttc.id<>:p_current
              '|| l_where_clause ||'
         ) tt_found
         , ( select id from tt_rescat_combinations where combination_number = this_weight and cardinality = this_cardinality )
    from (
         select '||l_select_cols||' tt_planner.bitor('|| replace(l_where_weight,'+',',')  ||') distinct_weight_sum, '|| l_where_weight || ' this_weight,' || l_where_cardinality ||' this_cardinality
           from '|| l_data_select ||'
         where ('|| l_where_weight || ',' || l_where_cardinality ||') in (select combination_number, cardinality from tt_rescat_combinations ttrc, tt_pla where tt_pla.rescat_comb_id = ttrc.id and tt_pla.pla_id = :p_pla_id2) 
             and '|| xxmsz_tools.iif(p_no_subsets='Y', l_no_subsets, '0=0' )  ||'
          order by '||l_order_by||'
         )
  ';  
  
  wlog('l_complete_sql', l_complete_sql);
  
  declare
    l_dummy varchar2(1);
    l_cnt   number;
    l_comb_id number;
    l_res_id        varchar2(100);
    l_rescat_id     number;
    l_rescat_weight number;
  begin
    delete from tt_check_results;
    begin 
      parse_immediate ( l_complete_sql, false);
      for t in 1 .. l_elem_count  loop
        l_res_id    := regexp_substr(l_res_ids, '([0-9]|[-])+', 1, t/*get t-th element*/); 
        if l_res_id is null then
          raise_application_error(-20000, 'verify t='||t||' p_res_ids='||p_res_ids);
        end if;
        l_rescat_id := get_rescat_id(l_res_id);
        select weight
          into l_rescat_weight 
          from resource_categories 
         where id = l_rescat_id;
        dbms_sql.bind_variable( g_c, ':id'    ||t , to_number(l_res_id) );
        dbms_sql.bind_variable( g_c, ':rc_id' ||t , l_rescat_id         );
        dbms_sql.bind_variable( g_c, ':rc_w'  ||t , l_rescat_weight     );      
        dbms_sql.bind_variable( g_c, ':r_desc'||t , get_res_desc(l_res_id, l_rescat_id)   );      
        wlog( ':id'    ||t , l_res_id );
        wlog( ':rc_id' ||t , to_char(l_rescat_id)         );
        wlog( ':rc_w'  ||t , to_char(l_rescat_weight)     );      
        wlog( ':r_desc'||t , get_res_desc(l_res_id, l_rescat_id)   );      
      end loop;  
      dbms_sql.bind_variable( g_c, ':p_pla_id1'  , p_pla_id );      
      dbms_sql.bind_variable( g_c, ':p_pla_id2'  , p_pla_id );      
      dbms_sql.bind_variable( g_c, ':p_current'  , p_current_comb_id );      
      wlog( ':p_pla_id1'  , to_char(p_pla_id) );      
      wlog( ':p_pla_id2'  , to_char(p_pla_id) );      
      wlog( ':p_current'  , to_char(p_current_comb_id) );            
      l_dummy := execute_immediate ( false);
    exception
      when others then
      raise; 
    end;
    select count(1) into l_cnt from tt_check_results where found_tt is null;
    if l_cnt > 0 then 
      -- at least combination not found
      if p_auto_fix = 'Y' then        
        for rec in (select tt_check_results_rowid, concatenated_res_ids, rescat_comb_id from tt_check_results_v where found_tt is null)
        loop
          l_comb_id := put_combination ( rec.rescat_comb_id, rec.concatenated_res_ids, '', '', 'N', null,null,'Y',null );          
          update tt_check_results set found_tt = l_comb_id where rowid = rec.tt_check_results_rowid ; 
        end loop;
        return 'Y';
      else
        return 'N'; 
      end if;
    else 
      -- no records found
      return 'Y'; 
    end if;
  end;
end verify;


-------------------------------------------------------------------------------------------------------------------------------------------------------
-- p_res_ids   - currently selected resources
-- p_rescat_id - resource to select ( get limitation for this resource type )
procedure set_res_limitation ( p_pla_id number, p_res_ids  varchar2, p_rescat_id number) 
is
  l_res_ids     varchar2(32000) := replace(p_res_ids, ';', ',' );
  l_complete_sql varchar2(32000);
  --
  l_select_cols         varchar2(32000);
  l_where_clause        varchar2(32000);
  l_data_select         varchar2(32000);
  l_where_weight        varchar2(4000);
  l_where_cardinality   varchar2(4000);
  l_order_by            varchar2(4000);
  l_resource_table_name varchar2(30);
  l_elem_count          number;
-------------------------------------------------------
begin
  if disable_res_limitation then return; end if;
  wlog('set_res_limitation(+)', 'p_res_ids=' || p_res_ids ||' p_rescat_id=' || p_rescat_id);
  delete from tt_ids;
  if p_res_ids is null then 
    -- no limitation
    return; 
  end if;
  l_resource_table_name := get_resource_table_name (p_rescat_id);
  declare
    l_col_name      varchar2(10);
  begin
    l_elem_count := xxmsz_tools.wordcount( l_res_ids, ','); 
    for t in 1 .. l_elem_count  loop
      l_col_name  := 'res_id'||t;
      l_select_cols        := l_select_cols || l_col_name ||', rescat_id'||t||',';
      l_where_clause       := l_where_clause || 'and ( ttc.id in ( select tt_comb_id from tt_resource_lists where res_id = res_id'||t||' ) or res_id'||t||' =0 or ttc.id in (select tt_comb_id from tt_inclusions where rescat_id = rescat_id'||t||' and inclusion_type = ''ALL'') ) ';
      l_data_select        := xxmsz_tools.merge( 
                                 l_data_select 
                               , '( select '||':id'||t||' '||l_col_name||', '||':rc_id'||t||' rescat_id'||t||', '||':rc_w'||t||' rescat_weight'||t||', '||':r_desc'||t||' res_desc'||t||', 1 grouping_res_id'||t||' from dual union all select 0,0,0,''-'',0 from dual)'
                               , ',');
      l_where_weight       := xxmsz_tools.merge( l_where_weight, 'rescat_weight'||t, '+' ); 
      l_where_cardinality  := xxmsz_tools.merge( l_where_cardinality, 'grouping_res_id'||t, '+' ); 
      l_order_by           := xxmsz_tools.merge( l_order_by, to_char(t*3), ', ' );
    end loop;
  end;
  -- add x
   l_data_select        := xxmsz_tools.merge( 
                              l_data_select 
                            , '( select :xrc_w rescat_weightx, 1 grouping_res_idx from dual x)'
                            , ',');
  l_where_weight       := xxmsz_tools.merge( l_where_weight, 'rescat_weightx', '+' ); 
  l_where_cardinality  := xxmsz_tools.merge( l_where_cardinality, 'grouping_res_idx', '+' ); 
  l_where_clause       := l_where_clause || 'and ( ttc.id in ( select tt_comb_id from tt_resource_lists where res_id = res_idx ) or res_idx =0 or ttc.id in (select tt_comb_id from tt_inclusions where rescat_id = rescat_idx and inclusion_type = ''ALL'') ) ';
  --
  l_complete_sql :=
 -- there is no condition present in verify : (select count(*) from tt_inclusions where tt_comb_id = ttc.id)='||l_rescat_count
 -- because we allow incomplete combination too (combination is W1,G1,S1, user selected W1, then he should see G1 on list even S has not choosen yet)   
'insert into tt_ids (id, tt_found)
 select res_idx, tt_found from
 (
  select res_idx
        ,(select ttc.id 
            from tt_combinations ttc, tt_rescat_combinations  ttrc, tt_pla
           where rownum = 1 and tt_pla.pla_id = :p_pla_id1 and ttrc.id  = ttc.rescat_comb_id and tt_pla.rescat_comb_id = ttrc.id and ttc.enabled = ''Y'' and (avail_type=''N'' or (avail_type=''L'' and avail_curr > 0)) '|| l_where_clause ||'
         ) tt_found 
    from (
         select '||l_select_cols||' null
           from '|| l_data_select ||'
         where ('|| l_where_weight || ',' || l_where_cardinality ||') in (select combination_number, cardinality from tt_rescat_combinations ttrc, tt_pla where tt_pla.rescat_comb_id = ttrc.id and tt_pla.pla_id = :p_pla_id2) 
         )
        ,'||  '( select x.id res_idx, :xrc_id rescat_idx from '||l_resource_table_name||' x)' || ' 
 )';
  wlog('l_complete_sql', l_complete_sql);
  
  --execute immediate l_complete_sql;
  declare
    l_cursor number := dbms_sql.open_cursor;
    l_ignore number;
    --
    l_res_id              varchar2(100);
    l_rescat_id           number;
    l_rescat_weight       number;
  begin
    dbms_sql.parse( l_cursor,  l_complete_sql, dbms_sql.native );
    for t in 1 .. l_elem_count  loop
      l_res_id    := regexp_substr(l_res_ids, '([0-9]|[-])+', 1, t/*get t-th element*/); 
      if l_res_id is null then
        raise_application_error(-20000, 'verify t='||t||' p_res_ids='||p_res_ids);
      end if;
      l_rescat_id := get_rescat_id(l_res_id);
      begin
      select weight
        into l_rescat_weight 
        from resource_categories 
       where id = l_rescat_id;
      exception
       when no_data_found then
         raise_application_error(-20000, 'l_res_id='||l_res_id|| '    l_rescat_id=' || l_rescat_id || ' ' || sqlerrm );
      end; 
      dbms_sql.bind_variable( l_cursor, ':id'    ||t , to_number(l_res_id) );
      dbms_sql.bind_variable( l_cursor, ':rc_id' ||t , l_rescat_id         );
      dbms_sql.bind_variable( l_cursor, ':rc_w'  ||t , l_rescat_weight     );      
      dbms_sql.bind_variable( l_cursor, ':r_desc'||t , get_res_desc(l_res_id, l_rescat_id)   );      
      wlog( ':id'    ||t , l_res_id );
      wlog( ':rc_id' ||t , to_char(l_rescat_id));
      wlog( ':rc_w'  ||t , to_char(l_rescat_weight));      
      wlog( ':r_desc'||t , get_res_desc(l_res_id, l_rescat_id)   );      
    end loop;  
    --add x
    select weight
      into l_rescat_weight 
      from resource_categories 
     where id = p_rescat_id;    
    dbms_sql.bind_variable( l_cursor, ':xrc_id' , p_rescat_id );      
    dbms_sql.bind_variable( l_cursor, ':xrc_w'  , l_rescat_weight );      
    --
    dbms_sql.bind_variable( l_cursor, ':p_pla_id1'  , p_pla_id );      
    dbms_sql.bind_variable( l_cursor, ':p_pla_id2'  , p_pla_id );   
    wlog( ':xrc_id' , to_char(p_rescat_id) );      
    wlog( ':xrc_w'  , to_char(l_rescat_weight) );      
    wlog( ':p_pla_id1'  , to_char(p_pla_id) );      
    wlog( ':p_pla_id2'  , to_char(p_pla_id) );   
    wlog('set_res_limitation', 'before execute');   
    l_ignore := dbms_sql.execute( l_cursor );
    wlog('set_res_limitation', 'after execute');
    delete from tt_ids where tt_found is null;  
    wlog('set_res_limitation', 'after delete');
    dbms_sql.close_cursor( l_cursor );
  end;
   
  --return 'select id from '|| l_resource_table_name ||' minus select id from tt_ids';
end set_res_limitation;





-------------------------------------------------------------------------------------------------------------------------------------------------------
procedure verify ( p_pla_id number, p_res_ids  varchar2, p_auto_fix varchar2 default 'N', p_current_comb_id number default -1, p_no_subsets varchar2 default 'N' ) is
 l_dummy varchar2(1);
begin
 l_dummy :=  verify ( p_pla_id, p_res_ids, p_auto_fix, p_current_comb_id, p_no_subsets  );
end verify; 

-------------------------------------------------------------------------------------------------------------------------------------------------------
-- get sql to review combinations in user frendly way
-- sql shows combinations according do passed resources and resource categories only  
function get_review_sql (p_res_ids varchar2, p_rescat_ids varchar2) return varchar2
is
  l_res_ids         varchar2(32000) := replace(p_res_ids,';',',');
  l_rescat_ids      varchar2(32000) := replace(p_rescat_ids,';',',');
  l_complete_sql    varchar2(32000);
  l_rescat_include1 varchar2(32000);
  l_rescat_include2 varchar2(32000);
  l_res_include     varchar2(32000);
  l_res_exclude     varchar2(32000);
  l_res_id          number;
  l_rescat_id       number;
begin
  if p_res_ids is null or p_rescat_ids is null then
    raise_application_error(-20000, 'p_res_ids and p_rescat_ids have to be not null' );
  end if;
  -- 
  for t in 1 .. xxmsz_tools.wordcount( l_rescat_ids, ',') loop
    l_rescat_id := regexp_substr(l_rescat_ids, '([0-9]|[-])+', 1, t/*get t-th element*/);  
    l_rescat_include1 := xxmsz_tools.merge ( l_rescat_include1 , 'planner_tt.get_rescat_id(res_id)='||l_rescat_id||chr(10), ' or ');
    l_rescat_include2 := xxmsz_tools.merge ( l_rescat_include2 , 'rescat_id='||l_rescat_id||chr(10), ' or ');
  end loop;
  l_rescat_include1 := 'and ('||l_rescat_include1||')';
  l_rescat_include2 := 'and ('||l_rescat_include2||')';
  
  for t in 1 .. xxmsz_tools.wordcount( l_res_ids, ',') loop
    l_res_id := regexp_substr(l_res_ids, '([0-9]|[-])+', 1, t/*get t-th element*/); 
    l_res_include := l_res_include ||   
         'and ('||chr(10)||
             'tt_comb_id in ( select tt_comb_id from tt_resource_lists where res_id = '||l_res_id||' )'||chr(10)||
          'or tt_comb_id in ( select tt_comb_id from tt_inclusions where rescat_id = '||get_rescat_id (l_res_id)||' and inclusion_type = ''ALL'')'||chr(10)||
             ')'||chr(10);
    l_res_exclude := l_res_exclude ||   
         'and res_id <> '||l_res_id||chr(10);
  end loop;

  l_complete_sql := 
    -- show from inclusions of type 'LIST'
   'select tt_comb_id, planner_tt.get_res_desc (res_id, planner_tt.get_rescat_id (res_id)) description, res_id, ''RES_ID'' type'||chr(10)||
     'from tt_resource_lists'||chr(10)||
     'where 0=0'||chr(10)||
        -- show these categories only:
       l_rescat_include1||
        -- show combination associated with res_id
       l_res_include||
        -- do not show current object, that would be confused for user
       l_res_exclude||
   'union all'||chr(10)||
    -- show from inclusions of type 'ALL'
   'select tt_comb_id, planner_tt.get_rescat_desc ( rescat_id ) || '' - WSZYSCY'' description, rescat_id, ''RESCAT_ID'' type'||chr(10)||
     'from tt_inclusions'||chr(10)||
     'where inclusion_type= ''ALL'''||chr(10)||
        -- show these categories only:
       l_rescat_include2||
        -- show combination associated with res_id
       l_res_include;
 return l_complete_sql;
end get_review_sql;

-------------------------------------------------------------------------------------------------------------------------------------------------------
function get_filter (p_res_ids varchar2) return varchar2
is
  l_res_ids    varchar2(32000) := replace(p_res_ids,';',',');
  l_filer      varchar2(32000) := '';
  l_res_id     number;
begin
  -- 
  for t in 1 .. xxmsz_tools.wordcount( l_res_ids, ',') loop
    l_res_id := regexp_substr(l_res_ids, '([0-9]|[-])+', 1, t/*get t-th element*/); 
    l_filer := xxmsz_tools.merge( 
                 l_filer   
                ,  ' ('||chr(10)||
                    'id in ( select tt_comb_id from tt_resource_lists where res_id = '||l_res_id||' )'||chr(10)||
                 'or id in ( select tt_comb_id from tt_inclusions where rescat_id = '||get_rescat_id (l_res_id)||' and inclusion_type = ''ALL'')'||chr(10)||
                    ')'||chr(10)
                ,' and ');
  end loop;
 return l_filer;
end get_filter;

-------------------------------------------------------------------------------------------------------------------------------------------------------
function get_resource_cat_names ( prescat_comb_id number ) return varchar2 is 
    res        varchar2(4000);
    l_cat_name varchar2(100);
begin
  for rec in (
    select (select name from resource_categories where id = rescat_id) name
      from tt_rescat_combinations_dtl
      where prescat_comb_id = rescat_comb_id
    order by id  
  ) 
  loop
    res := res || ',' || rec.name;  
  end loop;
  return trim(',' from res);
end get_resource_cat_names;


-------------------------------------------------------------------------------------------------------------------------------------------------------
procedure populate_rescat_comb_dtl (prescat_comb_id number, l_rescat_ids varchar2) is
  l_rescat_id number;
  l_weight number;
begin
 delete from tt_rescat_combinations_dtl where rescat_comb_id = prescat_comb_id;
 for t in 1 .. xxmsz_tools.wordcount( l_rescat_ids, ',') loop
   l_weight := regexp_substr(l_rescat_ids, '([0-9]|[-])+', 1, t/*get t-th element*/);  
   select id
     into l_rescat_id
     from resource_categories 
     where weight = l_weight;
   insert into tt_rescat_combinations_dtl (id, rescat_comb_id, rescat_id) values( tt_seq.nextval, prescat_comb_id, l_rescat_id );
 end loop;  
end populate_rescat_comb_dtl;


-------------------------------------------------------------------------------------------------------------------------------------------------------
function get_tt_cla ( p_cla_id number ) return varchar2 is 
 result varchar2(4000) := '';
begin
 for rec in (select tt_comb_id from tt_cla where cla_id = p_cla_id order by id ) loop
   result := result || ',' || rec.tt_comb_id;
 end loop;
 return trim(',' from result);
end get_tt_cla;

-------------------------------------------------------------------------------------------------------------------------------------------------------
procedure book_combination ( p_tt_comb_id number, punits number)  is
begin
 for rec in ( select rowid from tt_combinations where id = p_tt_comb_id for update ) loop
   update tt_combinations 
      set avail_curr = avail_curr - punits
    where rowid = rec.rowid;
 end loop;
end;

-------------------------------------------------------------------------------------------------------------------------------------------------------
procedure unbook_combination ( p_tt_comb_id number, punits number  )  is
begin
 for rec in ( select rowid from tt_combinations where id = p_tt_comb_id for update ) loop
   update tt_combinations 
      set avail_curr = avail_curr + punits
    where rowid = rec.rowid;
 end loop;
end;

-------------------------------------------------------------------------------------------------------------------------------------------------------
-- this function calculates current utilization of combination
-- in some sense this function is an inverse of function verify
-- use this function when
--   combination has been changed
--   combination has been added after classes were added to the system
procedure recalc_book_combination ( p_tt_comb_id number )  is
 l_cnt          number := 0;
 l_cla_id       number;
 l_fill         number;
 l_fill_sum     number := 0;
 l_complete_sql varchar2(32000);
 l_lec_cond     varchar2(4000);
 l_gro_cond     varchar2(4000);
 l_per_cond     varchar2(4000);
 l_for_cond     varchar2(4000);
 l_sub_cond     varchar2(4000);
 l_pla_cond     varchar2(4000);
 l_res_cond     varchar2(4000);
 type genericcurtyp is ref cursor;
 cur  genericcurtyp;
begin
  wlog('recalc_book_combination(+)', 'p_tt_comb_id=' || p_tt_comb_id );
  for rec in (
    select id, rowid, weight
      from tt_combinations
     where id = p_tt_comb_id
       -- do not calc booking for combinations without limit
       and avail_type = 'L'
  ) loop
     l_complete_sql := 'select id, fill/100 from classes cla where 0=0 '; 
     for rec_incl in ( select rescat_id
                            , inclusion_type 
                         from tt_inclusions 
                        where tt_comb_id = rec.id ) 
     loop
       if rec_incl.inclusion_type = 'LIST' then 
         l_res_cond := ' and rom_cla.rom_id in (select res_id from tt_resource_lists where tt_planner.get_rescat_id(res_id)='|| rec_incl.rescat_id ||' and tt_comb_id = '||rec.id||')';
         l_lec_cond := ' and         lec_id in (select res_id from tt_resource_lists where tt_planner.get_rescat_id(res_id)='|| rec_incl.rescat_id ||' and tt_comb_id = '||rec.id||')';
         l_gro_cond := ' and         gro_id in (select res_id from tt_resource_lists where tt_planner.get_rescat_id(res_id)='|| rec_incl.rescat_id ||' and tt_comb_id = '||rec.id||')';
         l_per_cond := ' and             id in (select res_id from tt_resource_lists where tt_planner.get_rescat_id(res_id)='|| rec_incl.rescat_id ||' and tt_comb_id = '||rec.id||')';
         l_for_cond := ' and cla.for_id in (select res_id from tt_resource_lists where tt_comb_id = '||rec.id||')';
         l_sub_cond := ' and cla.sub_id in (select res_id from tt_resource_lists where tt_comb_id = '||rec.id||')';
         l_pla_cond := ' and cla.owner in  (select p.name from tt_resource_lists tt, planners p where tt.res_id = p.id tt_comb_id = '||rec.id||')';
       else -- ='ALL'
         l_res_cond := ' and r.rescat_id = ' || rec_incl.rescat_id; 
         l_lec_cond := ' '; 
         l_gro_cond := ' '; 
         l_per_cond := ' '; 
         l_for_cond := ' and cla.for_id is not null';
         l_sub_cond := ' and cla.for_id is not null';
         l_pla_cond := ' and cla.owner is not null';
       end if;         
       -- 
       case rec_incl.rescat_id
        when g_date_hour then raise_application_error(-20000, 'g_date_hour is currently not used');
        when g_planner   then l_complete_sql := l_complete_sql || l_pla_cond; 
        when g_subject   then l_complete_sql := l_complete_sql || l_sub_cond; 
        when g_form      then l_complete_sql := l_complete_sql || l_for_cond; 
        when g_lecturer  then l_complete_sql := l_complete_sql || 'and exists (select 1 from lec_cla          where cla_id = cla.id '||l_lec_cond||')'; 
        when g_group     then l_complete_sql := l_complete_sql || 'and exists (select 1 from gro_cla          where cla_id = cla.id '||l_gro_cond||')'; 
        when g_period    then l_complete_sql := l_complete_sql || 'and exists (select 1 from periods where cla.day between date_from and date_to '||l_per_cond||')'; 
        else                  l_complete_sql := l_complete_sql || 'and exists (select 1 from rom_cla, rooms r where rom_id = r.id and cla_id = cla.id '||l_res_cond||')'; 
       end case;
     end loop;   
     --
     wlog('l_complete_sql', l_complete_sql);
     --
     delete from tt_cla where tt_comb_id = p_tt_comb_id;
     open cur for l_complete_sql;
     loop
       fetch cur into l_cla_id, l_fill;
       exit when cur%notfound;
       insert into tt_cla (id, cla_id, tt_comb_id, units) values (tt_seq.nextval, l_cla_id, p_tt_comb_id, l_fill);
       l_cnt := l_cnt + 1;
       l_fill_sum := l_fill_sum + l_fill;
     end loop;
     close cur;
     --
     update tt_combinations 
        set  avail_curr = avail_orig - l_fill_sum
      where rowid = rec.rowid; 
  end loop;
  wlog('recalc_book_combination(-)',null);  
end;

-------------------------------------------------------------------------------------------------------------------------------------------------------
function get_tt_comb_res_desc (p_tt_comb_id number, p_rescat_id number default null) return varchar2 is
 c number;
 res varchar2(2000);
begin
 select count(1)
   into c 
   from tt_inclusions
   where tt_comb_id = p_tt_comb_id 
     and rescat_id = p_rescat_id
     and INCLUSION_TYPE = 'ALL';
 if c <> 0 then return 'WSZYSCY'; end if;    
 --
 res := null;
 for rec in (
    select tt_planner.get_res_desc ( res_id, p_rescat_id, 'N') res
       from tt_resource_lists  x
       where tt_comb_id = p_tt_comb_id
         and tt_planner.get_rescat_id (res_id) = p_rescat_id
 )
 loop
   if res is null then res := rec.res;
                  else res := res ||', '|| rec.res; end if;
 end loop;
 return res;
end get_tt_comb_res_desc; 


begin
  declare
   l_tmp VARCHAR2(100);
  begin
   select value into l_tmp from system_parameters where name = 'TT_LOG';
   debug_mode := l_tmp = 'Y';
   select value into l_tmp from system_parameters where name = 'TT_DISABLE_RES_LIMITATION';
   disable_res_limitation := l_tmp = 'Y'; 
  end;
end tt_planner;
/

prompt ### EXTENTION END
