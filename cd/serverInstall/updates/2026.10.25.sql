--select * from system_parameters where name like 'VERSION%' order by name desc
INSERT INTO system_parameters (name,value) VALUES ('VERSION 2026.10.25', 'INSTALLED');
commit;

-- Tygodnie okresu (Okresy | "Utwórz tygodnie"), niewidoczne w GUI:
--   SUB_PERIOD_PARENT = PERIODS.ID okresu (semestru), z którego utworzono tydzień
--   SUB_PERIOD_NUM    = kolejny numer tygodnia w okresie (1, 2, ...)
-- Program (od wersji 2026-10-25) tworzy te kolumny sam przy logowaniu, jeżeli ich brakuje - dlatego skrypt
-- pomija to, co już istnieje (można go uruchomić wielokrotnie).
declare
  procedure ddl(s varchar2, ignore_code number) is
  begin
    execute immediate s;
  exception
    when others then
      if sqlcode <> ignore_code then raise; end if;
  end;
begin
  ddl('alter table periods add (sub_period_parent number)', -1430);  -- ORA-01430: kolumna już istnieje
  ddl('alter table periods add (sub_period_num number)', -1430);
  ddl('alter table periods add constraint periods_sub_period_parent_fk foreign key (sub_period_parent) references periods (id) on delete set null enable novalidate', -2275);  -- ORA-02275: więzy już istnieją
  ddl('create index periods_sub_period_parent_i on periods (sub_period_parent)', -955);  -- ORA-00955: nazwa już użyta
end;
/
