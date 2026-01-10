--select * from system_parameters where name like 'VERSION%' order by name desc
INSERT INTO system_parameters (name,value) VALUES ('VERSION 2026.01.09', 'INSTALLED');
commit;

*** install package rep_usos_overlaps

create public synonym rep_usos_overlaps for rep_usos_overlaps;

alter table exclusions add (print_exclusion char(1) default '-');
alter table exclusions add (type varchar2(10));


CREATE OR REPLACE VIEW "PLANNER"."EXCLUSIONS_V" ("ID", "RES_ID", "RES_ID_EXCLUDED", "DATE_FROM", "DATE_TO", "RES_DSP", "RES_EXCLUDED_DSP", print_exclusion, type) AS 
select 
id, res_id, res_id_excluded, date_from, date_to
,(select name from resources where id = res_id) res_dsp 
,(select name from resources where id = res_id_excluded) res_excluded_dsp  
, decode(print_exclusion,'-','Nie','Tak')  print_exclusion
, type
from exclusions;
