connect planner;

truncate table lec_cla;
truncate table gro_cla;
truncate table rom_cla;
delete from classes;
truncate table classes_history;
delete from subjects where id > 0;
delete from groups where id > 0;
delete from lecturers where id > 0;
delete from rooms where id > 0;
delete from form_formulas where id > 0;
delete from forms where id > 0;
commit;