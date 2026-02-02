--select * from system_parameters where name like 'VERSION%' order by name desc
INSERT INTO system_parameters (name,value) VALUES ('VERSION 2026.02.02', 'INSTALLED');
commit;

*** install package usos_dz_prowadzacy_grup
