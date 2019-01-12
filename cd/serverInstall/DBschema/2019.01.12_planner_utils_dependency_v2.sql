create or replace package planner_utils AUTHID CURRENT_USER is

   /*
   Toolkit
   2004.11.21 usuniecie problemu zwiazanego z nie dodawaniem rezerwacji dla sali
   2005.04.19 dodanie funkcji get_class_coeffficient
   2005.05.15 rozwiazanie problemu zwiazanego z konwersja number -> string (,.)
   2007.05.05 zmiany, wersja 3.4
   2010.03.14 flexs
   2010.11.01 copy_data - bugfix   
   2012.03.17 periods.locked_flag   
   2012.06.17 update_lgr, copy_data - changes ( user sorting demand)   
   2012.06.18 insert_classes - changes ( desc1..desc4)   
   2013.03.06 track history - changes  
   2013.11.03 bugfixing  
   2017.01.02 function killSessions return varchar2
   2017.04.05 merged version
   2018.04.21 check_locks
   2018.06.22 AUTHID CURRENT_USER
   2018.01.12 NAD-POD

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

end planner_utils;
/

create or replace package planner_utils AUTHID CURRENT_USER is

   /*
   Toolkit
   2004.11.21 usuniecie problemu zwiazanego z nie dodawaniem rezerwacji dla sali
   2005.04.19 dodanie funkcji get_class_coeffficient
   2005.05.15 rozwiazanie problemu zwiazanego z konwersja number -> string (,.)
   2007.05.05 zmiany, wersja 3.4
   2010.03.14 flexs
   2010.11.01 copy_data - bugfix   
   2012.03.17 periods.locked_flag   
   2012.06.17 update_lgr, copy_data - changes ( user sorting demand)   
   2012.06.18 insert_classes - changes ( desc1..desc4)   
   2013.03.06 track history - changes  
   2013.11.03 bugfixing  
   2017.01.02 function killSessions return varchar2
   2017.04.05 merged version
   2018.04.21 check_locks
   2018.06.22 AUTHID CURRENT_USER
   2018.01.12 NAD-POD

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

end planner_utils;
/
