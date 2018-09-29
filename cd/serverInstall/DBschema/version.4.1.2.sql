--LOCAL: YES
--LOCALPRIV: YES , BUT NO planner_utils
--ININSTALL: YES
--WAT  : YES
--WROC : NO
--PWWA : YES
--SOPOT: YES

! package tt_planner - changes
! package planner_utils - changes

alter table planner.groups modify ( NUMBER_OF_PEOPLES number );

begin
update LOOKUPS set meaning = 'Obci¹¿enie wyk³adowców' where LOOKUP_TYPE='FORM_FORMULA_TYPE' and  CODE = 'LEC_UTILIZATION';
update LOOKUPS set meaning = 'Usuniêcie zabronione, rekord (%C1.) zosta³ u¿yty podczas planowania' where LOOKUP_TYPE='DBMESSAGE_TRANSLATION' and  CODE = 'CLA_SUB_FK';
update LOOKUPS set meaning = 'Usuniêcie zabronione, rekord (%C2.) zosta³ u¿yty podczas definowania formu³' where LOOKUP_TYPE='DBMESSAGE_TRANSLATION' and  CODE = 'FORFOR_FOR_FK';
update LOOKUPS set meaning = 'Usuniêcie zabronione, rekord (%G.) zosta³ u¿yty podczas planowania' where LOOKUP_TYPE='DBMESSAGE_TRANSLATION' and  CODE = 'GROCLA_GRO_FK';
update LOOKUPS set meaning = 'Usuniêcie zabronione, rekord (%L.) zosta³ u¿yty podczas planowania' where LOOKUP_TYPE='DBMESSAGE_TRANSLATION' and  CODE = 'LECCLA_LEC_FK';
update LOOKUPS set meaning = 'Usuniêcie zabronione, w tej jednostce organizacyjnej s¹ ju¿ rekordy(rekord (%Ls.))' where LOOKUP_TYPE='DBMESSAGE_TRANSLATION' and  CODE = 'LECTURERS_ORGUNI_FK';
update LOOKUPS set meaning = 'Usuniêcie zabronione, autoryzacja zosta³a u¿yta podczas definiowania %PERIODgen.' where LOOKUP_TYPE='DBMESSAGE_TRANSLATION' and  CODE = 'PER_ROL_FK';
update LOOKUPS set meaning = 'Usuniêcie zabronione, zasób zosta³ u¿yty podczas planowania' where LOOKUP_TYPE='DBMESSAGE_TRANSLATION' and  CODE = 'ROMCLA_ROM_FK';
update LOOKUPS set meaning = 'Usuniêcie zabronione, rekord (%C2.) zosta³ u¿yty podczas planowania' where LOOKUP_TYPE='DBMESSAGE_TRANSLATION' and  CODE = 'CLA_FOR_FK';
update LOOKUPS set meaning = 'Usuniêcie zabronione, rekord (%C2.) zosta³ u¿yty w planie' where LOOKUP_TYPE='DBMESSAGE_TRANSLATION' and  CODE = 'TIMTAB_FOR_FK';
update LOOKUPS set meaning = 'Usuniêcie zabronione, rekord (%G.) zosta³ u¿yty w planie' where LOOKUP_TYPE='DBMESSAGE_TRANSLATION' and  CODE = 'TIMTAB_GRO_FK';
update LOOKUPS set meaning = 'Usuniêcie zabronione, rekord (%PERIOD.) zosta³ u¿yty w planie' where LOOKUP_TYPE='DBMESSAGE_TRANSLATION' and  CODE = 'TIMTAB_PER_FK';
update LOOKUPS set meaning = 'Usuniêcie zabronione, rekord (%C1.) zosta³ u¿yty w planie' where LOOKUP_TYPE='DBMESSAGE_TRANSLATION' and  CODE = 'TIMTAB_SUB_FK';
update LOOKUPS set meaning = 'Nie mo¿na zapisaæ danych, poniewa¿ istnieje rekord(%C1.) o podanej NAZWIE' where LOOKUP_TYPE='DBMESSAGE_TRANSLATION' and  CODE = 'SUB_NAME_I';
update LOOKUPS set meaning = 'Nie mo¿na zapisaæ danych, poniewa¿ istnieje rekord(%C1.) o podanym SKRÓCIE' where LOOKUP_TYPE='DBMESSAGE_TRANSLATION' and  CODE = 'SUB_ABBREVIATION_I';
update LOOKUPS set meaning = 'Kombinacja nazwy formularza, kontekstu i nazwy atrybutu musi byæ unikatowa' where LOOKUP_TYPE='DBMESSAGE_TRANSLATION' and  CODE = 'FLEX_UI';
update LOOKUPS set meaning = 'Nie mo¿na zapisaæ danych, poniewa¿ istnieje rekord(%C2.) o podanym SKRÓCIE' where LOOKUP_TYPE='DBMESSAGE_TRANSLATION' and  CODE = 'FRM_ABBREVIATION_I';
update LOOKUPS set meaning = 'Nie mo¿na zapisaæ danych, poniewa¿ istnieje rekord(%G.) o podanym SKRÓCIE' where LOOKUP_TYPE='DBMESSAGE_TRANSLATION' and  CODE = 'GRO_ABBREVIATION_I';
update LOOKUPS set meaning = 'Nie mo¿na zapisaæ danych, poniewa¿ istnieje rekord(%L.) o podanym SKRÓCIE' where LOOKUP_TYPE='DBMESSAGE_TRANSLATION' and  CODE = 'LEC_ABBREVIATION_I';
update LOOKUPS set meaning = 'Nie mo¿na zapisaæ danych, poniewa¿ istnieje jednostka organizacyjna o podanej NAZWIE' where LOOKUP_TYPE='DBMESSAGE_TRANSLATION' and  CODE = 'ORGUNI_NAME_FK_I';
update LOOKUPS set meaning = 'Nie mo¿na zapisaæ danych, poniewa¿ istnieje rekord(%PLANNER.) lub autoryzacja o podanej NAZWIE' where LOOKUP_TYPE='DBMESSAGE_TRANSLATION' and  CODE = 'PLA_UK';
update LOOKUPS set meaning = 'Nie mo¿na zapisaæ danych, poniewa¿ istnieje rekord(%C2.) o podanej NAZWIE' where LOOKUP_TYPE='DBMESSAGE_TRANSLATION' and  CODE = 'FOR_NAME_UI';
update LOOKUPS set meaning = 'Nie mo¿na zapisaæ danych, poniewa¿ istnieje rekord o podanym NUMERZE i BUDYNKU' where LOOKUP_TYPE='DBMESSAGE_TRANSLATION' and  CODE = 'ROOM_UK';
update LOOKUPS set meaning = 'Nie mo¿na zapisaæ danych, poniewa¿ istnieje rekord(%L.) o takim samym IMIENIU, NAZWISKU i TYTULE' where LOOKUP_TYPE='DBMESSAGE_TRANSLATION' and  CODE = 'LEC_NAME_UI';
update LOOKUPS set meaning = 'Nie mo¿na ponownie dodaæ tego samego %PLANNERgen.' where LOOKUP_TYPE='DBMESSAGE_TRANSLATION' and  CODE = 'TT_PLA_U1';
commit;
end;



prompt triggers - delete owner prefix It was: on planner.lec_cla It is: on lec_cla:

CREATE OR REPLACE TRIGGER lec_cla_trg
before insert or update
on lec_cla
referencing new as new old as old
for each row
begin
  select day, hour
    into :new.day, :new.hour
    from classes where id = :new.cla_id;
end;
/

CREATE OR REPLACE TRIGGER gro_cla_trg
before insert or update
on gro_cla
referencing new as new old as old
for each row
begin
  select day, hour
    into :new.day, :new.hour
    from classes where id = :new.cla_id;
end;
/

CREATE OR REPLACE TRIGGER rom_cla_trg
before insert or update
on rom_cla
referencing new as new old as old
for each row
begin
  select day, hour
    into :new.day, :new.hour
    from classes where id = :new.cla_id;
end;
/

--2012.03.17
-- alter table plannerpriv.periods add ( locked_flag  char(1) default '-'); <-- automatically 
