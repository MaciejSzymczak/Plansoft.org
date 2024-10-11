drop TRIGGER for_required_integration_id;
drop TRIGGER gro_required_integration_id;
drop TRIGGER lec_required_integration_id;
drop TRIGGER rom_required_integration_id;
drop TRIGGER sub_required_integration_id;

create or replace TRIGGER sub_required_integration_id
before INSERT ON subjects
REFERENCING NEW AS NEW
FOR EACH ROW
DECLARE
BEGIN
  if :new.integration_id is null then
    raise_application_error(-20000, 'Wprowadzanie ręczne przedmiotów zostało wyłączone, rekordy są pobierane z systemu Bazus/Usos.');
  end if;
END;
/

create or replace TRIGGER gro_required_integration_id
before INSERT ON groups
REFERENCING NEW AS NEW
FOR EACH ROW
DECLARE
BEGIN
  if :new.integration_id is null then
    raise_application_error(-20000, 'Wprowadzanie ręczne grup zostało zabronione, rekordy są pobierane z systemu Bazus/Usos.');
  end if;
END;
/

create or replace TRIGGER rom_required_integration_id
before INSERT ON rooms
REFERENCING NEW AS NEW
FOR EACH ROW
DECLARE
BEGIN
  if :new.integration_id is null then
    raise_application_error(-20000, 'Wprowadzanie ręczne sal zostało zabronione, rekordy są pobierane z systemu Bazus/Usos.');
  end if;
END;
/


create or replace TRIGGER lec_required_integration_id
before INSERT ON lecturers
REFERENCING NEW AS NEW
FOR EACH ROW
DECLARE
BEGIN
  if :new.integration_id is null then
    raise_application_error(-20000, 'Wprowadzanie ręczne wykładowców zostało zabronione, rekordy są pobierane z systemu Bazus/Usos.');
  end if;
END;
/

create or replace TRIGGER for_required_integration_id
before INSERT ON forms
REFERENCING NEW AS NEW
FOR EACH ROW
DECLARE
BEGIN
  if :new.integration_id is null then
    raise_application_error(-20000, 'Wprowadzanie ręczne form zostało zabronione, rekordy są pobierane z systemu Bazus/Usos.');
  end if;
END;
/

