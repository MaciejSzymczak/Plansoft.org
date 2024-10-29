INSERT INTO system_parameters (name,value) VALUES ('VERSION 2024.10.29', 'INSTALLED');
commit;

alter table usos_temp add (classes_sub_id number);

*** package USOS;