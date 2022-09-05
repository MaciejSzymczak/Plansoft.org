alter table groups modify (INTEGRATION_ID varchar2(30));
alter table groups_history modify (INTEGRATION_ID varchar2(30));
alter table tt_interface modify (gro_INTEGRATION_ID varchar2(30));