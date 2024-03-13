INSERT INTO system_parameters (name,value) VALUES ('VERSION 2024.03.08', 'INSTALLED');
commit;

create table owners (id number primary key, res_id number, pla_id number);
alter table owners add (CREATION_DATE DATE DEFAULT sysdate NOT NULL, CREATED_BY VARCHAR2(30 BYTE) DEFAULT USER NOT NULL, LAST_UPDATED_BY VARCHAR2(30 BYTE) DEFAULT USER NOT NULL, LAST_UPDATE_DATE DATE DEFAULT sysdate NOT NULL);
create index owner_res on owners (res_id);
create index owner_pla on owners (pla_id);
create sequence owner_seq;
create or replace type t_number_list is table of number;
create public synonym owners for owners;
CREATE GLOBAL TEMPORARY TABLE HELPER_RES (ID NUMBER) ON COMMIT DELETE ROWS;

*** PACKAGES INSTALLATION: PLANNER_UTILS

 