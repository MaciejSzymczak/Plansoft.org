declare
 l_user_id number;
 procedure lec_pla is
 begin
   INSERT INTO LEC_PLA (ID, PLA_ID, LEC_ID) VALUES (LECPLA_SEQ.NEXTVAL, l_user_id,main_seq.currval);
 end;
 procedure sub_pla is
 begin
   INSERT INTO sub_PLA (ID, PLA_ID, sub_ID) VALUES (subPLA_SEQ.NEXTVAL, l_user_id,main_seq.currval);
 end;
 procedure for_pla is
 begin
   INSERT INTO for_PLA (ID, PLA_ID, for_ID) VALUES (forPLA_SEQ.NEXTVAL, l_user_id,main_seq.currval);
 end;
begin
  delete from FLEX_COL_USAGE;
  --
  update resource_categories set name = 'Laptop',PLURAL_NAME='laptopy', NAME_ACCUSATIVE='laptopa', NAME_GENITIVE='laptopa' where id = 1;
  update resource_categories set name = 'Rzutnik',PLURAL_NAME='rzutniki', NAME_ACCUSATIVE='rzutnik', NAME_GENITIVE='rzutnik' where id = 2; 
  --
  update lookups set meaning = 'Rodzaj1' where code = 'STATIONARY' and LOOKUP_TYPE = 'GROUP_TYPE';
  update lookups set meaning = 'Rodzaj2' where code = 'EXTRAMURAL' and LOOKUP_TYPE = 'GROUP_TYPE' ;
  update lookups set meaning = 'Inny' where code = 'OTHER' and LOOKUP_TYPE = 'GROUP_TYPE';
  update lookups set MEANING = 'Klas.dodatkowa' where  CODE = 'C' and LOOKUP_TYPE = 'FORM_TYPE';
  commit;
  --
  select id into l_user_id from planners where name = 'PLANNER';
  delete from periods;
  delete from tt_combinations;
  delete from tt_rescat_combinations;
  delete from classes;
  delete from planners where name not like 'PLANNER%';
  delete from lecturers;
  delete from groups;
  delete from rooms;
  delete from subjects;
  delete from forms;
  delete from periods;
  insert into periods (id, name, date_from, date_to, SHOW_MON, SHOW_TUE, SHOW_WED, SHOW_THU, SHOW_FRI, SHOW_SAT, SHOW_SUN, HOURS_PER_DAY) 
  values (main_seq.nextval,'Przyk³adowy okres', date'2012-01-01', date'2012-03-31', '+', '+', '+', '+', '+', '-', '-', 8);
  insert into lecturers (id, abbreviation, title, first_name, last_name, colour, orguni_id) values (main_seq.nextval,'XPP','Pan','Przyk³adowy ','Pracownik 1','10026728','111');
  lec_pla;
  insert into lecturers (id, abbreviation, title, first_name, last_name, colour, orguni_id) values (main_seq.nextval,'XPP2','Pan','Przyk³adowy ','Pracownik 2','7171796','111');
  lec_pla;
  insert into lecturers (id, abbreviation, title, first_name, last_name, colour, orguni_id) values (main_seq.nextval,'XPP3','Pan','Przyk³adowy ','Pracownik 3','1225415','111');
  lec_pla;
  insert into subjects (id, abbreviation, name, colour) values (main_seq.nextval, 'P','Zap³acone',3602277 );
  sub_pla;
  insert into subjects (id, abbreviation, name, colour) values (main_seq.nextval, 'N','Zaplanowane',13559009 );
  sub_pla;
  insert into subjects (id, abbreviation, name, colour) values (main_seq.nextval, 'W','Wykonane',14611849 );
  sub_pla;
  insert into forms (id, abbreviation, name, kind, colour) values (main_seq.nextval, 'PRJ','Projektowanie','C',14113198);
  for_pla;
  insert into forms (id, abbreviation, name, kind, colour) values (main_seq.nextval, 'PRG','Programowanie','C',6878764);
  for_pla;
  insert into forms (id, abbreviation, name, kind, colour) values (main_seq.nextval, 'ANA','Analiza','C',13559009);
  for_pla;
  insert into forms (id, abbreviation, name, kind, colour) values (main_seq.nextval, 'TST','Testowanie','C',8586549);
  for_pla;
  insert into forms (id, abbreviation, name, kind, colour) values (main_seq.nextval, 'URL','Urlop','R',9689581);
  for_pla;
  commit;
end;
/

