--select * from system_parameters where name like 'VERSION%' order by name desc
INSERT INTO system_parameters (name,value) VALUES ('VERSION 2025.10.24', 'INSTALLED');
commit;

*** install package tt_interface_pkg