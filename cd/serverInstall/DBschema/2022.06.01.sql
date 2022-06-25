alter table lecturers add (is_active varchar2(1) default '1');
alter table lecturers_history add (is_active varchar2(1) default '1');
alter table groups add (is_active varchar2(1) default '1');
alter table groups_history add (is_active varchar2(1) default '1');
alter table rooms add (is_active varchar2(1) default '1');
alter table rooms_history add (is_active varchar2(1) default '1');
alter table subjects add (is_active varchar2(1) default '1');
alter table subjects_history add (is_active varchar2(1) default '1');
alter table forms add (is_active varchar2(1) default '1');
alter table forms_history add (is_active varchar2(1) default '1');

alter table forms modify abbreviation varchar2(30);
alter table forms_history modify abbreviation varchar2(30);

alter table subjects modify name varchar2(250);
alter table subjects_history modify name varchar2(250);

alter table subjects modify abbreviation varchar2(250);
alter table subjects_history modify abbreviation varchar2(250);

alter table groups modify abbreviation varchar2(50);
alter table groups_history modify abbreviation varchar2(50);

alter table TT_INTERFACE add (cycle_name varchar2(100));
