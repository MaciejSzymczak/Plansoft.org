----------------------------------------------------
detail view
  --select id, day, hour_dsp, day_in_say_pl,form, subject, lecturer_name, group_name, resource_name, desc4, week_iso from CLASSES_V
  --as simple as possible !
  translate
  import all lecturers as users
  filter only current user
add class
   form
   select tt_planner.get_tt_cla ( -1 ) from dual
  allow/disallow planning
  limit lists
  limit days (user, period, planner_user)
edit class
  allow/disallow editing not mine classes
add/insert - who columns
delete class  
edit dictionaries
  allow/disallow
user guide
pricing policy
test: install on wat
----------------------------------------------------

CREATE OR REPLACE VIEW CLASSES_V
AS 
select  c.DAY 
      , to_char( c.DAY , 'IW') week_iso 
      , grids.caption hour_dsp 
      , sub.name subject 
      , form.name||','||form.abbreviation form 
      , gro.abbreviation group_name 
      , lec.TITLE||' '||lec.LAST_NAME||' '||lec.FIRST_NAME lecturer_name 
      , rom.NAME||' '||substr(rom.attribs_01,1,55) resource_name 
      , c.FILL 
      , c.DESC1 
      , c.DESC2 
      , c.DESC3 
      , c.DESC4 
      , to_char( c.DAY , 'WW') week 
      , to_char( c.DAY,'d') day_of_week 
      , to_char( c.DAY,'d') day_of_month 
      , TRUNC(c.DAY,'d') first_day_of_week 
      , TRUNC(c.DAY,'mm') first_day_of_month 
      , TRUNC(c.DAY,'Q')  first_day_of_quarter 
      , TRUNC(c.DAY,'yyyy')  first_day_of_year 
      , to_char(c.DAY, 'DAY','NLS_DATE_LANGUAGE=''POLISH''') day_in_say_pl 
      , to_char(c.DAY, 'DAY','NLS_DATE_LANGUAGE=''AMERICAN''') day_in_say_us 
      , to_char(c.DAY, 'MONTH', 'NLS_DATE_LANGUAGE=''POLISH''') month_in_say_pl 
      , to_char(c.DAY, 'MONTH','NLS_DATE_LANGUAGE=''AMERICAN''') month_in_say_us 
      , to_char(c.DAY, 'YEAR','NLS_DATE_LANGUAGE=''POLISH''') year_in_say_pl 
      , to_char(c.DAY, 'YEAR','NLS_DATE_LANGUAGE=''AMERICAN''') year_in_say_us 
      , c.ID 
      , c.CREATED_BY 
      , c.OWNER 
      , c.STATUS 
      , c.COLOUR 
      , c.CREATION_DATE 
      -- 
      , grids.duration 
      , c.CALC_LECTURERS 
      , c.CALC_GROUPS 
      , c.CALC_ROOMS 
      , grids.HOUR_FROM 
      , grids.hour_to 
      , c.HOUR 
      , c.SUB_ID 
      , c.FOR_ID 
      , c.CALC_LEC_IDS 
      , c.CALC_GRO_IDS 
      , c.CALC_ROM_IDS 
      , c.CALC_RESCAT_IDS 
      , null DUMMY_NULL 
      , lec.COLOUR col_lec
      , gro.COLOUR col_gro
      , rom.COLOUR col_res
      , sub.COLOUR col_sub
      , form.COLOUR col_form
      , owner.COLOUR col_owner
      , created_by.colour col_created_by
      , c.colour col_class
  from classes c 
     , subjects sub 
     , forms form 
     , lec_cla 
     , gro_cla 
     , rom_cla 
     , lecturers lec 
     , groups    gro 
     , rooms     rom 
     , grids
     , planners owner
     , planners created_by 
      /* 
      classes 
       -< gro_cla         [cla_id] 
           >- groups      [gro_id] 
       -< lec_cla         [cla_id] 
           >- lecturers   [lec_id] 
       -< rom_cla         [cla_id] 
           >- rooms       [lec_id] 
       >- forms           [for_id] 
       >- subjects 
      */ 
  where sub.id(+) = c.sub_id 
   and  form.id(+) = c.for_id 
   and lec_cla.cla_id(+) = c.id 
   and gro_cla.cla_id(+) = c.id 
   and rom_cla.cla_id(+) = c.id 
   and lec.id(+) = lec_cla.lec_id 
   and gro.id(+) = gro_cla.gro_id 
   and rom.id(+) = rom_cla.rom_id 
   and grids.no(+) = c.hour
   and owner.name(+) = c.owner 
   and created_by.name(+) = c.created_by 
/

grant select on  planner.classes to plansoft;

grant select on  planner.classes_v to plansoft;

google charts - graphs
			--liczba zajêæ w poszczególnych miesi¹cach
			select to_char(day,'yyyy-mm'), count(*) from classes
			group by to_char(day,'yyyy-mm')
			order by count(*) desc 
			
			
----------------------------------------------------
Admin Ponie!456 
logowanie: PLANSOFT BPLATA BPLATA
----------------------------------------------------
