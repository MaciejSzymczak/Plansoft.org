--select * from system_parameters where name like 'VERSION%' order by name desc
INSERT INTO system_parameters (name,value) VALUES ('VERSION 2026.10.09', 'INSTALLED');
commit;

*** Install package usos_dz_prowadzacy_grup

connect as sys:
ALTER SYSTEM SET cursor_sharing = FORCE SCOPE=BOTH;
