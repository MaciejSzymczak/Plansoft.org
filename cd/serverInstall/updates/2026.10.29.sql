--select * from system_parameters where name like 'VERSION%' order by name desc
INSERT INTO system_parameters (name,value) VALUES ('VERSION 2026.10.29', 'INSTALLED');
commit;

-- Pobieranie danych z programu Excel | Ułożony rozkład zajęć
-- Program wstawia wiersze pliku do CLA_INTERFACE (każdy użytkownik ma swoje wiersze - created_by),
-- cla_interface_pkg.import tworzy zajęcia, cla_interface_pkg.getReport zwraca raport HTML (dziennik błędów).
create table CLA_INTERFACE (
  line_no          number
 ,day_txt          varchar2(100)
 ,hour_txt         varchar2(100)
 ,lec_txt          varchar2(4000)
 ,gro_txt          varchar2(4000)
 ,rom_txt          varchar2(4000)
 ,sub_txt          varchar2(1000)
 ,for_txt          varchar2(1000)
 ,desc2            varchar2(1000)   -- info dla studentów
 ,desc1            varchar2(1000)   -- info dla planistów
 ,owner_txt        varchar2(255)    -- kilku właścicieli: "A;B"
 ,desc3            varchar2(1000)
 ,desc4            varchar2(1000)
 ,fill_txt         varchar2(100)    -- wypełnienie 10 .. 100, puste = 100
 ,colour_txt       varchar2(100)    -- kolor zajęć (liczba), puste = brak
 ,day              date
 ,hour             number
 ,cla_id           number
 ,status           varchar2(3)      -- OK / ERR / DUP (pominięty - takie zajęcia już są w rozkładzie)
 ,message          varchar2(4000)
 ,creation_date    date         default sysdate not null
 ,created_by       varchar2(30) default user    not null
);

create index cla_interface_i1 on CLA_INTERFACE (created_by, line_no);

*** install package cla_interface_pkg


DECLARE
CURSOR TEMP
IS
select 'CREATE PUBLIC SYNONYM '||object_name||' FOR '||object_name S from sys.all_objects where owner = user and
OBJECT_TYPE NOT IN ('SYNONYM', 'INDEX', 'PACKAGE BODY') order by object_name;
BEGIN
FOR REC_TEMP IN TEMP
	LOOP
		 BEGIN
			execute immediate REC_TEMP.S;
		 EXCEPTION
		 WHEN OTHERS THEN
			NULL;
		 END;
	END LOOP;
END;
/
