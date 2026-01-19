--select * from system_parameters where name like 'VERSION%' order by name desc
INSERT INTO system_parameters (name,value) VALUES ('VERSION 2026.01.19', 'INSTALLED');
commit;

*** install package version_pkg
