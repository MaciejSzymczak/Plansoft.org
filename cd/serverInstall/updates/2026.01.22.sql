--select * from system_parameters where name like 'VERSION%' order by name desc
INSERT INTO system_parameters (name,value) VALUES ('VERSION 2026.01.22', 'INSTALLED');
commit;

create unique index periods_U on periods(Name);

CREATE GLOBAL TEMPORARY TABLE PLANNER.HELPER_USOS_LEC ( gr_nr number, zaj_cyk_id number, prac_id number, lec_id number, gro_id number, sub_id number, for_id number) ON COMMIT DELETE ROWS ;

*** install package usos_dz_prowadzacy_grup

create public synonym HELPER_USOS_LEC for PLANNER.HELPER_USOS_LEC;
create public synonym usos_dz_prowadzacy_grup for PLANNER.usos_dz_prowadzacy_grup;
