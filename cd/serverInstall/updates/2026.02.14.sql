--select * from system_parameters where name like 'VERSION%' order by name desc
INSERT INTO system_parameters (name,value) VALUES ('VERSION 2026.02.14', 'INSTALLED');
commit;

alter table fin_lookup_values modify (description varchar2(200));

*** install package usos_dz_prowadzacy_grup
