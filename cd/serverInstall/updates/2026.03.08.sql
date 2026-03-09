--select * from system_parameters where name like 'VERSION%' order by name desc
INSERT INTO system_parameters (name,value) VALUES ('VERSION 2026.03.08', 'INSTALLED');
commit;

alter table system_parameters modify (value varchar2(2000));

update resource_categories set 
name='Okres'
, plural_name='Okresy'
, name_accusative='okres'
, name_genitive='okresu'
where id = -7;

commit;

*** install package planner_utils.
