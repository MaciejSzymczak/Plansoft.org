--select * from system_parameters where name like 'VERSION%' order by name desc
INSERT INTO system_parameters (name,value) VALUES ('VERSION 2026.01.09', 'INSTALLED');
commit;

*** install package rep_usos_overlaps

create public synonym rep_usos_overlaps for rep_usos_overlaps;

