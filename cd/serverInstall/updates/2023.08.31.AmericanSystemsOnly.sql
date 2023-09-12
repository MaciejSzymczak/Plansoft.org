prompt *** this update is optional, for AmericanSystems only ***

alter table lecturers modify (desc1 varchar2(3000));
alter table lecturers_history modify (desc1 varchar2(3000));

alter table forms modify (integration_id varchar2(40));
alter table forms_history modify (integration_id varchar2(40));
alter table lecturers modify (integration_id varchar2(40));
alter table lecturers_history modify (integration_id varchar2(40));
alter table groups modify (integration_id varchar2(40));
alter table groups_history modify (integration_id varchar2(40));
alter table rooms modify (integration_id varchar2(40));
alter table rooms_history modify (integration_id varchar2(40));
alter table groups modify (integration_id varchar2(40));
alter table groups_history modify (integration_id varchar2(40));
alter table subjects modify (integration_id varchar2(40));
alter table subjects_history modify (integration_id varchar2(40));

