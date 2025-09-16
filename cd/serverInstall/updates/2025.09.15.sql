--select * from system_parameters where name like 'VERSION%' order by name desc
INSERT INTO system_parameters (name,value) VALUES ('VERSION 2025.09.15', 'INSTALLED');
commit;

*** Install https://github.com/MaciejSzymczak/Plansoft.org/blob/master/cd/serverInstall/updates/Packages/Xxmsz_Tools.sql
