begin
insert into subjects (id, abbreviation, name, orguni_id,colour) values (-1,'POD','Podgrupa', (select min(id) from org_units), 192+192*256+192*256*256);
insert into subjects (id, abbreviation, name, orguni_id,colour) values (-2,'NAD','Nadgrupa', (select min(id) from org_units), 192+192*256+192*256*256);
insert into forms (id, abbreviation, name,colour) values (-1,'POD','Podgrupa', 192+192*256+192*256*256);
insert into forms (id, abbreviation, name,colour) values (-2,'NAD','Nadgrupa', 192+192*256+192*256*256);
commit;
end;
/

alter table str_elems add (exclusive_parent varchar2(1) default '+');

CREATE OR REPLACE FORCE VIEW STR_ELEMS_V ("ID", "PARENT_ID", "CHILD_ID", "STR_NAME_LOV", "CHILD_DSP", "PARENT_DSP", exclusive_parent) AS 
select 
str_elems.id,str_elems.parent_id,str_elems.child_id,str_elems.str_name_lov
,(select name from resources where id = child_id) child_dsp 
,(select name from resources where id = parent_id) parent_dsp 
, exclusive_parent 
from str_elems;
/

drop  INDEX GRO_CLA_U;
alter table GRO_CLA add (no_conflict_flag varchar2(1));
alter table GRO_CLA_history add (no_conflict_flag varchar2(1));
create unique index GRO_CLA_U on GRO_CLA(case when no_conflict_flag is null  THEN  GRO_ID||DAY||HOUR ELSE null END);

drop  INDEX ROM_CLA_U;
alter table ROM_CLA add (no_conflict_flag varchar2(1));
alter table ROM_CLA_history add (no_conflict_flag varchar2(1));
create unique index ROM_CLA_U on ROM_CLA(case when no_conflict_flag is null  THEN  ROM_ID||DAY||HOUR ELSE null END);

drop  INDEX LEC_CLA_U;
alter table LEC_CLA add (no_conflict_flag varchar2(1));
alter table LEC_CLA_history add (no_conflict_flag varchar2(1));
create unique index LEC_CLA_U on LEC_CLA(case when no_conflict_flag is null  THEN  LEC_ID||DAY||HOUR ELSE null END);
