--select * from system_parameters where name like 'VERSION%' order by name desc
INSERT INTO system_parameters (name,value) VALUES ('VERSION 2026.11.21', 'INSTALLED');
commit;

-- Study plan 2 (Plan2) - new module SPL_ (Study PLan), application from version 2026-11-21.
-- Used when "Plan studiow 2" is switched on in Plik | Ustawienia programu; otherwise the application
-- keeps using TT_COMBINATIONS / TT_CLA as before.
--
--   SPL_ITEMS     - study plan items: period, group, subject, form, lecturer (optional), planned hours,
--                   scheduled hours (calculated by spl_pkg.recalc)
--   SPL_ITEM_CLA  - classes linked to a study plan item (equivalent of TT_CLA)
--   SPL_SEQ       - sequence for both tables
--   SPL_PKG       - recalculation, generating the plan from classes
--
-- Oracle 10g compatible. The script can be run more than once (existing objects are skipped).

declare
  procedure ddl(s varchar2, ignore_code number) is
  begin
    execute immediate s;
  exception
    when others then
      if sqlcode <> ignore_code then raise; end if;
  end;
begin
  ddl('create sequence spl_seq cache 1000', -955);  -- ORA-00955: name is already used

  ddl('create table spl_items ('||
      '  id               number        not null'||
      ' ,per_id           number        not null'||
      ' ,gro_id           number        not null'||
      ' ,sub_id           number        not null'||
      ' ,for_id           number        not null'||
      ' ,lec_id           number'||
      ' ,planned_hours    number        default 0 not null'||
      ' ,scheduled_hours  number        default 0 not null'||
      ' ,recalc_date      date'||
      ' ,sort_order       number'||
      ' ,integration_id   varchar2(80)'||
      ' ,desc1            varchar2(1000)'||
      ' ,creation_date    date          default sysdate not null'||
      ' ,created_by       varchar2(30)  default user    not null'||
      ' ,last_update_date date          default sysdate not null'||
      ' ,last_updated_by  varchar2(30)  default user    not null'||
      ' ,constraint spl_items_pk     primary key (id)'||
      ' ,constraint spl_items_per_fk foreign key (per_id) references periods   (id) on delete cascade'||
      ' ,constraint spl_items_gro_fk foreign key (gro_id) references groups    (id) on delete cascade'||
      ' ,constraint spl_items_sub_fk foreign key (sub_id) references subjects  (id) on delete cascade'||
      ' ,constraint spl_items_for_fk foreign key (for_id) references forms     (id) on delete cascade'||
      ' ,constraint spl_items_lec_fk foreign key (lec_id) references lecturers (id) on delete cascade'||
      ')', -955);
  -- order of the items in the plan (default sort order of the window "Plan studiow"); for databases where
  -- spl_items was created by an earlier version of this script
  ddl('alter table spl_items add (sort_order number)', -1430);  -- ORA-01430: column being added already exists
  -- identifier of the item in an external system / in the Excel file (Pobierz dane z programu Excel | Plan studiow);
  -- empty - the item is recognized by period, group, subject, form and lecturer
  ddl('alter table spl_items add (integration_id varchar2(80))', -1430);
  ddl('create unique index spl_items_int_uk on spl_items (integration_id)', -955);
  -- one item per period, group, subject, form and lecturer (an empty lecturer counts as one value)
  ddl('create unique index spl_items_uk on spl_items (per_id, gro_id, sub_id, for_id, nvl(lec_id, 0))', -955);
  ddl('create index spl_items_gro_i on spl_items (gro_id)', -955);
  ddl('create index spl_items_sub_i on spl_items (sub_id)', -955);
  ddl('create index spl_items_for_i on spl_items (for_id)', -955);
  ddl('create index spl_items_lec_i on spl_items (lec_id)', -955);

  ddl('create table spl_item_cla ('||
      '  id       number not null'||
      ' ,item_id  number not null'||
      ' ,cla_id   number not null'||
      ' ,hours    number default 0 not null'||
      ' ,constraint spl_item_cla_pk      primary key (id)'||
      ' ,constraint spl_item_cla_item_fk foreign key (item_id) references spl_items (id) on delete cascade'||
      ' ,constraint spl_item_cla_cla_fk  foreign key (cla_id)  references classes   (id) on delete cascade'||
      ')', -955);
  ddl('create unique index spl_item_cla_uk on spl_item_cla (item_id, cla_id)', -955);
  ddl('create index spl_item_cla_cla_i on spl_item_cla (cla_id)', -955);
end;
/

create or replace trigger spl_items_bu
  before update on spl_items
  for each row
begin
  :new.last_update_date := sysdate;
  :new.last_updated_by  := user;
end;
/

*** Install package spl_pkg
