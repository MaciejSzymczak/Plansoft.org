create or replace package planner_utils_ext AUTHID CURRENT_USER is

   /*
   Schools specific validations
   @version 2026.05.18
   @author Maciej Szymczak
   */


  function before_insert_classes(pday    in out        date
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
                        ) return boolean;

  procedure after_insert_classes(pday            date
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


end planner_utils_ext;
/

create or replace package body planner_utils_ext is

  function before_insert_classes(pday       in out   date
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
                        ) return boolean is
begin
 /* PUT HERE SCHOOL SPECIFIC CODE OR VALIDATIONS*/
 return true;
end;

  procedure after_insert_classes(pday              date
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
res1 varchar2(100) := '4098147';
res2 varchar2(100) := '4098148';
cboth number;
c1 number;
c2 number;

begin
 /* PUT HERE SCHOOL SPECIFIC CODE OR VALIDATIONS*/
 /* YOU CAN REMOVE EXAMPLE CONTENT BELOW*/

 -- W danym dniu można albo prowadzić wszystkie zajęcia w połączonej sali 1.9-1.10 albo używać sale 1.9 i 1.10 oddzielnie.
 if user like 'WLO%' and
    (pcalc_rom_ids like '%'||res1||'%' or pcalc_rom_ids like '%'||res2||'%') 
 then
        --both
        select count(1) into cboth
        from(
        select cla_id from rom_cla where rom_id = 4098147 and day=pday
        intersect
        select cla_id from rom_cla where rom_id = 4098148 and day=pday
        );
        
        --only res1
        select count(1) into c1 
        from(
        select cla_id from rom_cla where rom_id = 4098147 and day=pday
        minus
        (
        select cla_id from rom_cla where rom_id = 4098147 and day=pday
        intersect
        select cla_id from rom_cla where rom_id = 4098148 and day=pday
        )
        );
        
        --only res2
        select count(1)  into c2
        from(
        select cla_id from rom_cla where rom_id = 4098148 and day=pday
        minus
        (
        select cla_id from rom_cla where rom_id = 4098147 and day=pday
        intersect
        select cla_id from rom_cla where rom_id = 4098148 and day=pday
        )
        );
        
        if cboth>0 and (c1>0 or c2>0) then
            raise_application_error(-20000, 'W danym dniu można planować wszystkie zajęcia ALBO w połączonych ALBO w rozdzielonych salach 1.9-1.10.');
        end if;
 end if;
end;
 
end planner_utils_ext;
/
