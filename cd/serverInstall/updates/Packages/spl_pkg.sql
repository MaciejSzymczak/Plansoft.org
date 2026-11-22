create or replace package SPL_PKG is

   /*****************************************************************************************************************************
   |* Study plan 2 (Plan2) - module SPL_ (Study PLan)
   |
   |  SPL_ITEMS     - study plan items: period, group, subject, form, lecturer (optional), planned hours
   |  SPL_ITEM_CLA  - classes linked to a study plan item (equivalent of TT_CLA)
   |
   |  A class is linked to an item when:
   |    - classes.day is within the item period (periods.date_from .. periods.date_to)
   |    - classes.hour <= periods.hours_per_day
   |    - classes.for_id = item form
   |    - classes.sub_id = item subject, or the item subject is a child of classes.sub_id (STR_ELEMS)
   |    - at least one group of the class (GRO_CLA, also derived child groups) = item group
   |    - item lecturer is empty, or at least one lecturer of the class (LEC_CLA) = item lecturer
   |  Hours of a class = fill/100 * grids.duration (the same formula as TT_CLA.UNITS), rounded to GRID_DECIMAL_PLACES.
   |
   |  Oracle 10g compatible (no LISTAGG, no identity columns).
   |  The procedures do NOT commit - the application controls the transaction.
   |
   | History
   | 2026.11.21 Maciej Szymczak created
   \-----------------------------------------------------------------------------------------------------------------------------*/

    -- Recalculates links (SPL_ITEM_CLA) and SPL_ITEMS.SCHEDULED_HOURS.
    -- Scope: one item (pItemId), or all items of a period (pPerId), or all items (both null).
    procedure recalc (pPerId number default null, pItemId number default null);

    -- Recalculates the items given as a comma separated list of ids, e.g. '12,15,18'.
    procedure recalc_items (pItemIds varchar2);

    -- Deletes the study plan of the period for the given group OR lecturer OR subject (exactly one of them)
    -- and generates it again from the classes of the period. Returns the number of created items.
    -- Items are created per group, subject, form; the lecturer is set only when generating for a lecturer.
    function generate_from_classes (pPerId number, pGroId number default null, pLecId number default null, pSubId number default null) return number;

    -- "Utworz plan na podstawie zajec": the plan of group pGroTo in period pPerTo is replaced by the items created from
    -- the classes of group pGroFrom (directly assigned) in period pPerFrom - one item per subject and form,
    -- with pWithLecturers = 'Y' per subject, form and lecturer (a class with two lecturers counts for both;
    -- a class without lecturer gives an item without lecturer). Then the new items are linked to the classes of pPerTo.
    procedure create_from_classes (pPerFrom number, pGroFrom number, pPerTo number, pGroTo number, pWithLecturers varchar2 default 'N');

    -- Hours of the classes still to be planned (planned - scheduled, not less than 0).
    function hours_to_schedule (pItemId number) return number;

    -- Scheduled hours of the item calculated from the current classes (the same rules as recalc),
    -- without changing SPL_ITEM_CLA / SPL_ITEMS (no DML - no row locks between planners).
    -- Used by the "Plan studiow" list in the main window, which is refreshed after every change of classes.
    function scheduled_hours_now (pItemId number) return number;

    -- "Pobierz dane z programu Excel" | "Plan studiow" when Plan2 is switched on.
    -- The rows of the file are in TT_INTERFACE (created_by = user), the same template as for TT_COMBINATIONS:
    -- lecturer (optional), group, subject, form, period, number of classes (= planned hours).
    -- Rows with unknown objects get TT_INTERFACE.MESSAGE (shown by tt_interface_pkg.getReport).
    -- pDeleteExisting = 'Y': the current plan of the groups and periods of the file is deleted first.
    -- A row with Integration Id (column G) updates the item with this Integration Id; a row without it - the item with
    -- the same period, group, subject, form and lecturer. Items are created or updated (planned hours), then linked to
    -- the classes (recalc). A row with Integration Id only (other columns empty) deletes the item - in UFMassImport.
    procedure import_from_interface (pDeleteExisting varchar2 default 'N');
end;
/

create or replace package body SPL_PKG is

gDecimalPlaces number := 4;

---------------------------------------------------------------------------------------------------------------------------------------
procedure recalc_scope (pPerId number, pItemId number, pItemIds varchar2
                       , pGroId number default null, pLecId number default null, pSubId number default null) is
begin
    -- remove the old links of the items in scope
    delete from spl_item_cla
     where item_id in (select id from spl_items i
                        where (pItemId  is null or i.id = pItemId)
                          and (pPerId   is null or i.per_id = pPerId)
                          and (pItemIds is null or instr(','||pItemIds||',', ','||i.id||',') > 0)
                          and (pGroId is null and pLecId is null and pSubId is null
                               or (pGroId is not null and i.gro_id = pGroId)
                               or (pLecId is not null and i.lec_id = pLecId)
                               or (pSubId is not null and i.sub_id = pSubId)));

    -- link the matching classes
    insert into spl_item_cla (id, item_id, cla_id, hours)
    select spl_seq.nextval, item_id, cla_id, hours
      from (
        select i.id   item_id
             , cla.id cla_id
             , round(nvl(cla.fill,100)/100 * nvl(g.duration,1), gDecimalPlaces) hours
          from spl_items i
             , periods   per
             , classes   cla
             , grids     g
         where (pItemId  is null or i.id = pItemId)
           and (pPerId   is null or i.per_id = pPerId)
           and (pItemIds is null or instr(','||pItemIds||',', ','||i.id||',') > 0)
           and (pGroId is null and pLecId is null and pSubId is null
                or (pGroId is not null and i.gro_id = pGroId)
                or (pLecId is not null and i.lec_id = pLecId)
                or (pSubId is not null and i.sub_id = pSubId))
           and per.id  = i.per_id
           and cla.day between per.date_from and per.date_to
           and cla.hour <= nvl(per.hours_per_day, cla.hour)
           and g.no    = cla.hour
           and cla.for_id = i.for_id
           and (   cla.sub_id = i.sub_id
                or exists (select 1 from str_elems se where se.parent_id = cla.sub_id and se.child_id = i.sub_id))
           and exists (select 1 from gro_cla gc where gc.cla_id = cla.id and gc.gro_id = i.gro_id)
           and (   i.lec_id is null
                or exists (select 1 from lec_cla lc where lc.cla_id = cla.id and lc.lec_id = i.lec_id))
      );

    -- scheduled hours
    update spl_items i
       set scheduled_hours = nvl((select sum(hours) from spl_item_cla c where c.item_id = i.id), 0)
         , recalc_date     = sysdate
     where (pItemId  is null or i.id = pItemId)
       and (pPerId   is null or i.per_id = pPerId)
       and (pItemIds is null or instr(','||pItemIds||',', ','||i.id||',') > 0)
       and (pGroId is null and pLecId is null and pSubId is null
            or (pGroId is not null and i.gro_id = pGroId)
            or (pLecId is not null and i.lec_id = pLecId)
            or (pSubId is not null and i.sub_id = pSubId));
end;

---------------------------------------------------------------------------------------------------------------------------------------
procedure recalc (pPerId number default null, pItemId number default null) is
begin
    recalc_scope(pPerId, pItemId, null);
end;

---------------------------------------------------------------------------------------------------------------------------------------
procedure recalc_items (pItemIds varchar2) is
begin
    if pItemIds is null then return; end if;
    recalc_scope(null, null, replace(pItemIds, ' ', ''));
end;

---------------------------------------------------------------------------------------------------------------------------------------
function generate_from_classes (pPerId number, pGroId number default null, pLecId number default null, pSubId number default null) return number is
  vCount number;
  vScope number := 0;
begin
    if pPerId is null then
      raise_application_error(-20001, 'Podaj okres');
    end if;
    if pGroId is not null then vScope := vScope + 1; end if;
    if pLecId is not null then vScope := vScope + 1; end if;
    if pSubId is not null then vScope := vScope + 1; end if;
    if vScope <> 1 then
      raise_application_error(-20001, 'Podaj grupę albo wykładowcę albo przedmiot');
    end if;

    -- delete the current plan in scope (links are deleted by ON DELETE CASCADE)
    delete from spl_items
     where per_id = pPerId
       and (   (pGroId is not null and gro_id = pGroId)
            or (pLecId is not null and lec_id = pLecId)
            or (pSubId is not null and sub_id = pSubId));

    -- create the items from the classes of the period (directly assigned groups / lecturers only)
    insert into spl_items (id, per_id, gro_id, sub_id, for_id, lec_id, planned_hours, scheduled_hours)
    select spl_seq.nextval, pPerId, gro_id, sub_id, for_id, lec_id, hours, 0
      from (
        select gc.gro_id
             , cla.sub_id
             , cla.for_id
             , pLecId lec_id
             , round(sum(nvl(cla.fill,100)/100 * nvl(g.duration,1)), gDecimalPlaces) hours
          from periods per
             , classes cla
             , grids   g
             , gro_cla gc
         where per.id = pPerId
           and cla.day between per.date_from and per.date_to
           and cla.hour <= nvl(per.hours_per_day, cla.hour)
           and g.no      = cla.hour
           and gc.cla_id = cla.id
           and gc.is_child = 'N'
           and cla.sub_id is not null
           and cla.for_id is not null
           and (pGroId is null or gc.gro_id = pGroId)
           and (pSubId is null or cla.sub_id = pSubId)
           and (pLecId is null or exists (select 1 from lec_cla lc where lc.cla_id = cla.id and lc.lec_id = pLecId and lc.is_child = 'N'))
         group by gc.gro_id, cla.sub_id, cla.for_id
      );
    vCount := sql%rowcount;

    -- link the classes and calculate the scheduled hours of the new items only
    recalc_scope(pPerId, null, null, pGroId, pLecId, pSubId);
    return vCount;
end;

---------------------------------------------------------------------------------------------------------------------------------------
procedure create_from_classes (pPerFrom number, pGroFrom number, pPerTo number, pGroTo number, pWithLecturers varchar2 default 'N') is
begin
    if pPerFrom is null or pGroFrom is null or pPerTo is null or pGroTo is null then
      raise_application_error(-20001, 'Podaj okres i grupę (skąd i dokąd)');
    end if;

    delete from spl_items where per_id = pPerTo and gro_id = pGroTo;

    if pWithLecturers = 'Y' then
      insert into spl_items (id, per_id, gro_id, sub_id, for_id, lec_id, planned_hours, scheduled_hours)
      select spl_seq.nextval, pPerTo, pGroTo, sub_id, for_id, lec_id, hours, 0
        from (
          select cla.sub_id, cla.for_id, lc.lec_id
               , round(sum(nvl(cla.fill,100)/100 * nvl(g.duration,1)), gDecimalPlaces) hours
            from periods per, classes cla, grids g, gro_cla gc, lec_cla lc
           where per.id = pPerFrom
             and cla.day between per.date_from and per.date_to
             and cla.hour <= nvl(per.hours_per_day, cla.hour)
             and g.no = cla.hour
             and gc.cla_id = cla.id and gc.gro_id = pGroFrom and gc.is_child = 'N'
             and cla.sub_id is not null and cla.for_id is not null
             and lc.cla_id (+) = cla.id and lc.is_child (+) = 'N'
           group by cla.sub_id, cla.for_id, lc.lec_id
        );
    else
      insert into spl_items (id, per_id, gro_id, sub_id, for_id, lec_id, planned_hours, scheduled_hours)
      select spl_seq.nextval, pPerTo, pGroTo, sub_id, for_id, null, hours, 0
        from (
          select cla.sub_id, cla.for_id
               , round(sum(nvl(cla.fill,100)/100 * nvl(g.duration,1)), gDecimalPlaces) hours
            from periods per, classes cla, grids g, gro_cla gc
           where per.id = pPerFrom
             and cla.day between per.date_from and per.date_to
             and cla.hour <= nvl(per.hours_per_day, cla.hour)
             and g.no = cla.hour
             and gc.cla_id = cla.id and gc.gro_id = pGroFrom and gc.is_child = 'N'
             and cla.sub_id is not null and cla.for_id is not null
           group by cla.sub_id, cla.for_id
        );
    end if;

    recalc_scope(pPerTo, null, null, pGroTo);
end;

---------------------------------------------------------------------------------------------------------------------------------------
function hours_to_schedule (pItemId number) return number is
  vResult number;
begin
    select greatest(nvl(planned_hours,0) - nvl(scheduled_hours,0), 0)
      into vResult
      from spl_items
     where id = pItemId;
    return vResult;
exception
    when no_data_found then return 0;
end;

---------------------------------------------------------------------------------------------------------------------------------------
function scheduled_hours_now (pItemId number) return number is
  vResult number;
begin
    select nvl(sum(round(nvl(cla.fill,100)/100 * nvl(g.duration,1), gDecimalPlaces)), 0)
      into vResult
      from spl_items i
         , periods   per
         , classes   cla
         , grids     g
     where i.id    = pItemId
       and per.id  = i.per_id
       and cla.day between per.date_from and per.date_to
       and cla.hour <= nvl(per.hours_per_day, cla.hour)
       and g.no    = cla.hour
       and cla.for_id = i.for_id
       and (   cla.sub_id = i.sub_id
            or exists (select 1 from str_elems se where se.parent_id = cla.sub_id and se.child_id = i.sub_id))
       and exists (select 1 from gro_cla gc where gc.cla_id = cla.id and gc.gro_id = i.gro_id)
       and (   i.lec_id is null
            or exists (select 1 from lec_cla lc where lc.cla_id = cla.id and lc.lec_id = i.lec_id));
    return vResult;
end;

---------------------------------------------------------------------------------------------------------------------------------------
procedure import_from_interface (pDeleteExisting varchar2 default 'N') is
    vId number;
    -- sets pIdCol of the not matched rows: <id of pTable> where <pExpr> = <pIntCol>; ambiguous values are skipped
    procedure match (pIdCol varchar2, pTable varchar2, pExpr varchar2, pIntCol varchar2, pLike boolean default false) is
    begin
      execute immediate
        'update tt_interface set '||pIdCol||' = (select id from '||pTable||' where '||pExpr||
        case when pLike then ' like ''%''||'||pIntCol||'||''%''' else ' = '||pIntCol end ||')'||
        ' where created_by = user and '||pIdCol||' is null and '||pIntCol||' is not null';
    exception
      when others then null; -- e.g. ORA-01427: more than one object - other rules are tried
    end;
begin
    update tt_interface
       set lec_integration_id = trim(upper(lec_integration_id))
         , gro_integration_id = trim(upper(gro_integration_id))
         , sub_integration_id = trim(upper(sub_integration_id))
         , for_integration_id = trim(upper(for_integration_id))
         , per_integration_id = trim(upper(per_integration_id))
         , message = null
     where created_by = user;

    -- the same matching rules as tt_interface_pkg.import
    match('lec_id', 'lecturers', 'trim(upper(integration_id))', 'lec_integration_id');
    match('lec_id', 'lecturers', 'to_char(id)', 'lec_integration_id');
    match('lec_id', 'lecturers', 'trim(upper(abbreviation))', 'lec_integration_id');
    match('lec_id', 'lecturers', 'trim(upper(title||'' ''||first_name||'' ''||last_name))', 'lec_integration_id');
    match('lec_id', 'lecturers', 'trim(upper(first_name||'' ''||last_name))', 'lec_integration_id');
    match('lec_id', 'lecturers', 'trim(upper(abbreviation||'' ''||title||'' ''||first_name||'' ''||last_name))', 'lec_integration_id', true);
    -- record-level attempt (one ambiguous row does not block the others)
    for rec in (select rowid rid from tt_interface where created_by = user and lec_id is null and lec_integration_id is not null) loop
      begin update tt_interface set lec_id = (select id from lecturers where trim(upper(title||' '||first_name||' '||last_name)) = lec_integration_id) where rowid = rec.rid and lec_id is null; exception when others then null; end;
      begin update tt_interface set lec_id = (select id from lecturers where trim(upper(first_name||' '||last_name)) = lec_integration_id) where rowid = rec.rid and lec_id is null; exception when others then null; end;
      begin update tt_interface set lec_id = (select id from lecturers where trim(upper(abbreviation||' '||title||' '||first_name||' '||last_name)) like '%'||lec_integration_id||'%') where rowid = rec.rid and lec_id is null; exception when others then null; end;
    end loop;

    match('gro_id', 'groups', 'trim(upper(integration_id))', 'gro_integration_id');
    match('gro_id', 'groups', 'to_char(id)', 'gro_integration_id');
    match('gro_id', 'groups', 'trim(upper(abbreviation))', 'gro_integration_id');
    match('gro_id', 'groups', 'trim(upper(name))', 'gro_integration_id');
    match('gro_id', 'groups', 'trim(upper(abbreviation||'' ''||name))', 'gro_integration_id', true);

    match('sub_id', 'subjects', 'trim(upper(integration_id))', 'sub_integration_id');
    match('sub_id', 'subjects', 'to_char(id)', 'sub_integration_id');
    match('sub_id', 'subjects', 'trim(upper(abbreviation))', 'sub_integration_id');
    match('sub_id', 'subjects', 'trim(upper(name))', 'sub_integration_id');
    match('sub_id', 'subjects', 'trim(upper(abbreviation||'' ''||name))', 'sub_integration_id', true);

    match('for_id', 'forms', 'trim(upper(integration_id))', 'for_integration_id');
    match('for_id', 'forms', 'to_char(id)', 'for_integration_id');
    match('for_id', 'forms', 'trim(upper(abbreviation))', 'for_integration_id');
    match('for_id', 'forms', 'trim(upper(name))', 'for_integration_id');
    match('for_id', 'forms', 'trim(upper(abbreviation||'' ''||name))', 'for_integration_id', true);

    match('per_id', 'periods', 'trim(upper(integration_id))', 'per_integration_id');
    match('per_id', 'periods', 'to_char(id)', 'per_integration_id');
    match('per_id', 'periods', 'trim(upper(name))', 'per_integration_id');

    -- the lecturer is optional: an error only when given and not found
    update tt_interface
       set message = substr('Błąd: nie znaleziono: '||rtrim(
                         case when gro_id is null then 'grupa, ' end
                       ||case when sub_id is null then 'przedmiot, ' end
                       ||case when for_id is null then 'forma, ' end
                       ||case when per_id is null then 'semestr, ' end
                       ||case when lec_id is null and lec_integration_id is not null then 'wykładowca, ' end, ', '), 1, 500)
     where created_by = user
       and (gro_id is null or sub_id is null or for_id is null or per_id is null or (lec_id is null and lec_integration_id is not null));
    update tt_interface set message = 'Błąd: Podaj liczbę zajęć'
     where created_by = user and message is null and classes_cnt is null;

    if pDeleteExisting = 'Y' then
      delete from spl_items i
       where exists (select 1 from tt_interface t
                      where t.created_by = user and t.message is null and t.per_id = i.per_id and t.gro_id = i.gro_id);
    end if;

    -- rows with Integration Id: the item with this Integration Id, otherwise the item with the same period, group,
    -- subject, form and lecturer without Integration Id (it gets the Integration Id), otherwise a new item
    for r in (select rowid rid, t.* from tt_interface t
               where created_by = user and message is null and integration_id is not null and integration_id not like 'DUMMY:%') loop
      vId := null;
      begin
        select id into vId from spl_items where integration_id = r.integration_id;
      exception
        when no_data_found then
          begin
            select id into vId from spl_items
             where per_id = r.per_id and gro_id = r.gro_id and sub_id = r.sub_id and for_id = r.for_id
               and nvl(lec_id,0) = nvl(r.lec_id,0) and integration_id is null;
          exception
            when no_data_found then vId := null;
          end;
      end;
      begin
        if vId is null then
          insert into spl_items (id, per_id, gro_id, sub_id, for_id, lec_id, planned_hours, scheduled_hours, integration_id)
          values (spl_seq.nextval, r.per_id, r.gro_id, r.sub_id, r.for_id, r.lec_id, r.classes_cnt, 0, r.integration_id);
        else
          update spl_items
             set per_id = r.per_id, gro_id = r.gro_id, sub_id = r.sub_id, for_id = r.for_id, lec_id = r.lec_id
               , planned_hours = r.classes_cnt, integration_id = r.integration_id
           where id = vId;
        end if;
      exception
        when dup_val_on_index then
          update tt_interface set message = 'Błąd: taka pozycja planu (okres, grupa, przedmiot, forma, wykładowca) ma już inne Integration Id'
           where rowid = r.rid;
      end;
    end loop;

    -- rows without Integration Id: recognized by period, group, subject, form and lecturer; rows with the same item are summed up
    merge into spl_items m
    using (select per_id, gro_id, sub_id, for_id, lec_id, sum(classes_cnt) hours
             from tt_interface
            where created_by = user and message is null and (integration_id is null or integration_id like 'DUMMY:%')
            group by per_id, gro_id, sub_id, for_id, lec_id) n
       on (m.per_id = n.per_id and m.gro_id = n.gro_id and m.sub_id = n.sub_id and m.for_id = n.for_id and nvl(m.lec_id,0) = nvl(n.lec_id,0))
     when matched then update set planned_hours = n.hours
     when not matched then insert (id, per_id, gro_id, sub_id, for_id, lec_id, planned_hours, scheduled_hours)
                           values (spl_seq.nextval, n.per_id, n.gro_id, n.sub_id, n.for_id, n.lec_id, n.hours, 0);

    -- links and scheduled hours, per period and group of the file
    for rec in (select distinct per_id, gro_id from tt_interface where created_by = user and message is null) loop
      recalc_scope(rec.per_id, null, null, rec.gro_id);
    end loop;
end;

---------------------------------------------------------------------------------------------------------------------------------------
begin
    begin
      select to_number(value) into gDecimalPlaces from system_parameters where name = 'GRID_DECIMAL_PLACES';
    exception
      when others then null; -- default 4, the same as tt_planner
    end;
end SPL_PKG;
/
