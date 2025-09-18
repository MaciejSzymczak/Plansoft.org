--select * from system_parameters where name like 'VERSION%' order by name desc
INSERT INTO system_parameters (name,value) VALUES ('VERSION 2025.09.17', 'INSTALLED');
commit;

alter table timetable_notes add (SEARCHABLE_TEXT  varchar2(4000));
   
CREATE OR REPLACE TRIGGER trg_timetable_notes_biu
BEFORE INSERT OR UPDATE
ON timetable_notes
FOR EACH ROW
BEGIN
  :NEW.SEARCHABLE_TEXT :=
    xxmsz_tools.erasePolishChars(
      UPPER(
        SUBSTR(
          TO_CLOB(NVL(:NEW.notes_before, ''))
          || NVL(:NEW.notes_after, '')
          || NVL(:NEW.internal_notes, ''),
          1,
          4000
        )
      )
    );
END;
/


*** Install 
	https://github.com/MaciejSzymczak/Plansoft.org/blob/master/cd/serverInstall/updates/Packages/planner_utils.sql
