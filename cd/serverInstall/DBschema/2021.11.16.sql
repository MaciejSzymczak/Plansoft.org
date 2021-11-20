INSERT INTO system_parameters (name,value) VALUES ('VERSION 2021.11.16', 'INSTALLED');
commit;
alter table groups modify (ABBREVIATION varchar2(25));
alter table groups_history modify (ABBREVIATION varchar2(25));
