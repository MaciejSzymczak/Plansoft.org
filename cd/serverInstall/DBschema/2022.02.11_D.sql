--CREATE PUBLIC DATABASE LINK USOS CONNECT TO PLANER IDENTIFIED BY "xxxx" USING '10.100.200.43';

alter table  planner.lecturers add (integration_id varchar2(20));
alter table planner.lecturers_history add (integration_id varchar2(20));
create unique index lintegration_id on lecturers (integration_id);
insert into system_parameters (name, value) values ('USOS_CYKL', '2020L');
insert into system_parameters (name, value) values ('USOS_HOURS_PER_DAY', '52');

alter table planner.periods add (integration_id varchar2(20));
create unique index pintegration_id_per on planner.periods (integration_id);

alter table planner.planners add (integration_id varchar2(20));
create unique index integration_id_pla on planner.planners (integration_id);

alter table planner.subjects add (integration_id varchar2(20));
alter table planner.subjects_history add (integration_id varchar2(20));
create unique index integration_id_sub on planner.subjects (integration_id);

alter table planner.rooms add (integration_id varchar2(20));
alter table planner.rooms_history add (integration_id varchar2(20));
create unique index integration_id_rom on planner.rooms (integration_id);

alter table planner.forms add (integration_id varchar2(20));
alter table planner.forms_history  add (integration_id varchar2(20));
create unique index integration_id_for on planner.forms (integration_id);

alter table planner.groups add (integration_id varchar2(20));
alter table planner.groups_history  add (integration_id varchar2(20));
create unique index integration_id_gro1 on planner.groups (integration_id);

alter table planner.groups add (usos_period varchar2(20));
alter table planner.groups_history  add (usos_period varchar2(20));
create index integration_id_gro2 on planner.groups (usos_period);

drop table TT_INTERFACE;

create table TT_INTERFACE (
 integration_id varchar2(40)
 ,PER_ID NUMBER
 ,LEC_ID NUMBER
 ,SUB_ID NUMBER
 ,FOR_ID NUMBER
 ,GRO_ID NUMBER
 ,ROM_ID NUMBER
 ,CLASSES_CNT NUMBER
 ,PER_INTEGRATION_ID VARCHAR2(20)
 ,LEC_INTEGRATION_ID VARCHAR2(20)
 ,SUB_INTEGRATION_ID VARCHAR2(20)
 ,FOR_INTEGRATION_ID VARCHAR2(20)
 ,GRO_INTEGRATION_ID VARCHAR2(20)
 ,ROM_INTEGRATION_ID VARCHAR2(20)
);

create unique index integration_id_tt on planner.TT_INTERFACE (integration_id);

alter table TT_COMBINATIONS modify ( integration_id varchar2(40));

alter table TT_COMBINATIONS add ( usos_gr_nr number);
alter table TT_COMBINATIONS add ( usos_zaj_cyk_id number);

alter table TT_INTERFACE add ( usos_gr_nr number);
alter table TT_INTERFACE add ( usos_zaj_cyk_id number);

alter table forms modify (name varchar2(30));

drop table usos_temp;

create table usos_temp (
day date
,no_from number(2,0)
,no_to number(2,0)
,lec_id number
,gro_id number
,rom_id number
,sub_id number
,for_id number
--
,trm_id number
,from_hour number
,from_min number
,to_hour number
,to_min number
--
,gr_nr number
, sl_id number
, zaj_cyk_id number
);