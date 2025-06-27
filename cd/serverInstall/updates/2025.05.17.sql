--select * from system_parameters where name like 'VERSION%' order by name desc
INSERT INTO system_parameters (name,value) VALUES ('VERSION 2025.05.17', 'INSTALLED');
commit;

alter table periods modify (ATTRIBS_14 varchar2(2000));
