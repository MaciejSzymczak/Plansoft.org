create or replace package cla_interface_pkg is

   /*****************************************************************************************************************************
   |* Import ułożonego rozkładu zajęć z pliku Excel (Pobieranie danych z programu Excel | Ułożony rozkład zajęć)
   |* Program wstawia wiersze pliku do CLA_INTERFACE (created_by = user), potem wywołuje import i getReport.
   |* import: każdy wiersz osobno (savepoint) - wiersz z błędem jest pomijany, pozostałe są importowane.
   |*         Brakujący wykładowcy, grupy, sale, przedmioty i formy są tworzone.
   |*         Nie zatwierdza transakcji (commit / rollback - program, rollback = uruchomienie testowe).
   |*         Wiersz identyczny z istniejącymi zajęciami (ponowny import) jest pomijany (status DUP), a nie zgłaszany jako konflikt.
   |* exportName: nazwa obiektu do pliku (Dane | Zapisz rozkład zajęć w Excel), którą import rozpozna jako ten sam obiekt.
   |* Kolumny opcjonalne: Opis 3, Opis 4, Wypełnienie (10, 20, ... 100; puste = 100), Kolor (liczba jak CLASSES.COLOUR; puste = brak).
   |* @author Maciej Szymczak @version 2026.10.29
   \-----------------------------------------------------------------------------------------------------------------------------*/

    procedure import;
    function  getReport (pTestRun varchar2 default 'N') return clob;
    -- porównywanie nazw: wielkie litery, pojedyncze spacje (używana w SQL)
    function  norm (s varchar2) return varchar2;
    -- losowy pastelowy kolor nowego obiektu (używana w SQL)
    function  randomColour return number;
    -- nazwa obiektu, którą import dopasuje dokładnie do tego obiektu (te same reguły - findId); null: brak takiej nazwy
    -- pkind: L wykładowca, G grupa, R sala, S przedmiot, F forma
    function  exportName (pkind varchar2, pid number) return varchar2;
    -- STREFA NIEBEZPIECZNA: kasuje całą zawartość bazy danych (zajęcia, historię, wykładowców, grupy, sale, przedmioty, formy ...)
    -- przed importem ułożonego rozkładu zajęć do pustej bazy (pole "Skasuj całą zawartość bazy danych"). Tylko użytkownik PLANNER.
    -- Zatwierdza transakcję (truncate) - nie da się jej cofnąć ani uruchomić testowo.
    procedure deleteAllData;
end;
/

create or replace package body cla_interface_pkg is

    type t_names is table of varchar2(400) index by varchar2(400);
    g_created   t_names;         -- utworzone obiekty słownikowe (tylko z zaimportowanych wierszy)
    g_row_new   t_names;         -- utworzone w bieżącym wierszu
    g_pla_id    number;
    g_orguni_id number;

    e_row exception;
    pragma exception_init(e_row, -20500);
    -- wiersz pominięty: identyczne zajęcia już są w rozkładzie (np. ponowny import tego samego pliku)
    e_duplicate exception;
    pragma exception_init(e_duplicate, -20501);

    -----------------------------------------------------------------------------------------------------------------------------
    procedure fail(msg varchar2) is
    begin
      raise_application_error(-20500, msg);
    end;

    function norm(s varchar2) return varchar2 is
    begin
      return upper(trim(regexp_replace(s, '\s+', ' ')));
    end;

    function h(s varchar2) return varchar2 is
    begin
      return replace(replace(replace(s, chr(38), chr(38) || 'amp;'), '<', chr(38) || 'lt;'), '>', chr(38) || 'gt;');
    end;

    function randomColour return number is
    begin
      -- pastelowy, jak getRandomColor w programie
      return trunc(dbms_random.value(127, 255)) + 256 * trunc(dbms_random.value(127, 255)) + 65536 * trunc(dbms_random.value(127, 255));
    end;

    procedure noteCreated(kind varchar2, name varchar2) is
    begin
      g_row_new(kind || ': ' || name) := kind;
    end;

    -----------------------------------------------------------------------------------------------------------------------------
    -- uprawnienie importującego planisty do utworzonego obiektu (jak FMassImport.addPermission)
    procedure grantTo(plaId number, alias varchar2, objId number) is
    begin
      if plaId is null then return; end if;
      execute immediate
        'merge into ' || alias || '_PLA m using (select :pla_id pla_id, :obj_id obj_id from dual) n'||
        ' on (m.PLA_ID = n.pla_id and m.' || alias || '_ID = n.obj_id)'||
        ' when not matched then insert (id, PLA_ID, ' || alias || '_ID) values (' || alias || 'PLA_SEQ.NEXTVAL, n.pla_id, n.obj_id)'
        using plaId, objId;
    end;

    procedure grantToUser(alias varchar2, objId number) is
    begin
      grantTo(g_pla_id, alias, objId);
    end;

    -- kilku właścicieli: uprawnienia każdego właściciela do wykładowców, grup i sal zajęć
    -- (jak pgrantPermissions => 'Y' w planner_utils.insert_classes, które obsługuje tylko jednego właściciela)
    procedure grantToOwners(owners varchar2, lecIds varchar2, groIds varchar2, romIds varchar2) is
      plaId number;
    begin
      for o in 1 .. regexp_count(owners, '[^;]+') loop
        select max(id) into plaId from planners where name = regexp_substr(owners, '[^;]+', 1, o);
        for i in 1 .. regexp_count(nvl(lecIds, ' '), '[^;]+') loop grantTo(plaId, 'LEC', to_number(regexp_substr(lecIds, '[^;]+', 1, i))); end loop;
        for i in 1 .. regexp_count(nvl(groIds, ' '), '[^;]+') loop grantTo(plaId, 'GRO', to_number(regexp_substr(groIds, '[^;]+', 1, i))); end loop;
        for i in 1 .. regexp_count(nvl(romIds, ' '), '[^;]+') loop grantTo(plaId, 'ROM', to_number(regexp_substr(romIds, '[^;]+', 1, i))); end loop;
      end loop;
    end;

    -----------------------------------------------------------------------------------------------------------------------------
    -- nazwa z pliku -> obiekt; cnt: liczba pasujących obiektów (1 = jednoznacznie). Te same reguły w imporcie i w exportName.
    function findId(kind varchar2, txt varchar2, cnt out number) return number is
      n   varchar2(400) := norm(txt);
      id_ number;
    begin
      case kind
        when 'L' then
          select count(distinct id), min(id) into cnt, id_
            from lecturers
           where norm(abbreviation) = n
              or norm(title || ' ' || first_name || ' ' || last_name) = n
              or norm(first_name || ' ' || last_name) = n
              or norm(last_name || ' ' || first_name) = n
              or norm(integration_id) = n;
        when 'G' then
          select count(distinct id), min(id) into cnt, id_
            from groups
           where norm(abbreviation) = n or norm(name) = n or norm(integration_id) = n;
        when 'R' then
          select count(distinct id), min(id) into cnt, id_
            from rooms
           where norm(name) = n
              or norm(name || ' ' || attribs_01) = n
              or norm(attribs_01 || ' ' || name) = n
              or norm(integration_id) = n;
        when 'S' then
          select count(distinct id), min(id) into cnt, id_
            from subjects
           where norm(abbreviation) = n or norm(name) = n or norm(integration_id) = n;
        else
          select count(distinct id), min(id) into cnt, id_
            from forms
           where norm(abbreviation) = n or norm(name) = n or norm(integration_id) = n;
      end case;
      return id_;
    end;

    -----------------------------------------------------------------------------------------------------------------------------
    function exportName (pkind varchar2, pid number) return varchar2 is
      cnt number;
    begin
      -- kandydaci od najczytelniejszego; w listach (L, G, R) bez przecinka - import dzieli listy po przecinkach
      for c in (select v from (
                  select 1 o, trim(regexp_replace(title || ' ' || first_name || ' ' || last_name, '\s+', ' ')) v from lecturers where pkind = 'L' and id = pid
                  union all select 2, abbreviation    from lecturers where pkind = 'L' and id = pid
                  union all select 3, integration_id  from lecturers where pkind = 'L' and id = pid
                  union all select 1, abbreviation    from groups    where pkind = 'G' and id = pid
                  union all select 2, name            from groups    where pkind = 'G' and id = pid
                  union all select 3, integration_id  from groups    where pkind = 'G' and id = pid
                  union all select 1, name            from rooms     where pkind = 'R' and id = pid
                  union all select 2, trim(name || ' ' || attribs_01) from rooms where pkind = 'R' and id = pid
                  union all select 3, integration_id  from rooms     where pkind = 'R' and id = pid
                  union all select 1, name            from subjects  where pkind = 'S' and id = pid
                  union all select 2, abbreviation    from subjects  where pkind = 'S' and id = pid
                  union all select 3, integration_id  from subjects  where pkind = 'S' and id = pid
                  union all select 1, name            from forms     where pkind = 'F' and id = pid
                  union all select 2, abbreviation    from forms     where pkind = 'F' and id = pid
                  union all select 3, integration_id  from forms     where pkind = 'F' and id = pid)
                 where trim(v) is not null
                 order by o) loop
        if (pkind not in ('L', 'G', 'R') or instr(c.v, ',') = 0) and lengthb(c.v) <= 400 then
          if findId(pkind, c.v, cnt) = pid and cnt = 1 then return trim(c.v); end if;
        end if;
      end loop;
      return null;
    end;

    -----------------------------------------------------------------------------------------------------------------------------
    function lecturerId(txt varchar2) return number is
      cnt   number;
      id_   number;
      w     varchar2(100);
      words number;
      title varchar2(400);
      fname varchar2(400);
      lname varchar2(400);
      abbr  varchar2(400);
      i     number;
    begin
      id_ := findId('L', txt, cnt);
      if cnt = 1 then return id_; end if;
      if cnt > 1 then fail('Wykładowca "' || txt || '" jest niejednoznaczny - pasuje do kilku wykładowców. Podaj skrót wykładowcy'); end if;

      -- nowy wykładowca: początkowe "dr", "mgr", "inż.", "r. pr.", "SSO", "prok." ... = tytuł, potem imię i nazwisko
      -- inicjał imienia ("G.") nie jest tytułem
      words := regexp_count(trim(txt), '\S+');
      i := 1;
      while i <= words loop
        w := regexp_substr(trim(txt), '\S+', 1, i);
        exit when regexp_like(w, '^[[:upper:]]\.$');
        exit when not (w like '%.' or lower(w) in ('dr', 'mgr', 'inż', 'inz', 'prof', 'hab', 'lic', 'doc', 'n',
                                                    'sso', 'ssr', 'ssa', 'ssn', 'sędzia', 'sedzia', 'prok', 'asesor', 'adw', 'adwokat', 'pg'));
        title := trim(title || ' ' || w);
        i := i + 1;
      end loop;
      if i > words then fail('Wykładowca "' || txt || '": brak nazwiska'); end if;
      if i < words then
        fname := regexp_substr(trim(txt), '\S+', 1, i);
        i := i + 1;
      end if;
      while i <= words loop
        lname := trim(lname || ' ' || regexp_substr(trim(txt), '\S+', 1, i));
        i := i + 1;
      end loop;
      if lengthb(title) > 30 or lengthb(fname) > 30 or lengthb(lname) > 30 then
        fail('Wykładowca "' || txt || '": tytuł, imię i nazwisko mogą mieć najwyżej po 30 znaków');
      end if;

      -- skrót: inicjał imienia + nazwisko, unikalny
      abbr := substrb(upper(substr(fname, 1, 1)) || lname, 1, 20);   -- kolumna: 20 bajtów
      i := 1;
      loop
        select count(1) into cnt from lecturers where upper(abbreviation) = upper(abbr);
        exit when cnt = 0;
        i := i + 1;
        abbr := substrb(upper(substr(fname, 1, 1)) || lname, 1, 20 - length(i)) || i;
      end loop;

      select main_seq.nextval into id_ from dual;
      insert into lecturers (id, abbreviation, title, first_name, last_name, colour, orguni_id, diff_notifications)
           values (id_, abbr, title, fname, lname, randomColour, g_orguni_id, '-');
      grantToUser('LEC', id_);
      noteCreated('Wykładowca', trim(txt));
      return id_;
    end;

    -----------------------------------------------------------------------------------------------------------------------------
    function groupId(txt varchar2) return number is
      cnt number;
      id_ number;
    begin
      id_ := findId('G', txt, cnt);
      if cnt = 1 then return id_; end if;
      if cnt > 1 then fail('Grupa "' || txt || '" jest niejednoznaczna - pasuje do kilku grup'); end if;
      if lengthb(trim(txt)) > 50 then fail('Grupa "' || txt || '": nazwa nowej grupy może mieć najwyżej 50 znaków'); end if;

      select main_seq.nextval into id_ from dual;
      insert into groups (id, abbreviation, name, colour, group_type, orguni_id)
           values (id_, trim(txt), trim(txt), randomColour, 'STATIONARY', g_orguni_id);
      grantToUser('GRO', id_);
      noteCreated('Grupa', trim(txt));
      return id_;
    end;

    -----------------------------------------------------------------------------------------------------------------------------
    function roomId(txt varchar2) return number is
      cnt number;
      id_ number;
    begin
      id_ := findId('R', txt, cnt);
      if cnt = 1 then return id_; end if;
      if cnt > 1 then fail('Sala "' || txt || '" jest niejednoznaczna - pasuje do kilku sal. Podaj salę razem z budynkiem'); end if;
      if lengthb(trim(txt)) > 25 then fail('Sala "' || txt || '": nazwa nowej sali może mieć najwyżej 25 znaków'); end if;

      select main_seq.nextval into id_ from dual;
      insert into rooms (id, name, colour, rescat_id, orguni_id)
           values (id_, trim(txt), randomColour, 1, g_orguni_id);
      grantToUser('ROM', id_);
      noteCreated('Sala', trim(txt));
      return id_;
    end;

    -----------------------------------------------------------------------------------------------------------------------------
    function subjectId(txt varchar2) return number is
      cnt number;
      id_ number;
    begin
      id_ := findId('S', txt, cnt);
      if cnt = 1 then return id_; end if;
      if cnt > 1 then fail('Przedmiot "' || txt || '" jest niejednoznaczny - pasuje do kilku przedmiotów'); end if;
      if lengthb(trim(txt)) > 250 then fail('Przedmiot "' || txt || '": nazwa nowego przedmiotu może mieć najwyżej 250 znaków'); end if;

      select main_seq.nextval into id_ from dual;
      insert into subjects (id, abbreviation, name, colour, orguni_id)
           values (id_, trim(txt), trim(txt), randomColour, g_orguni_id);
      grantToUser('SUB', id_);
      noteCreated('Przedmiot', trim(txt));
      return id_;
    end;

    -----------------------------------------------------------------------------------------------------------------------------
    function formId(txt varchar2, pkind varchar2) return number is
      cnt number;
      id_ number;
    begin
      id_ := findId('F', txt, cnt);
      if cnt = 1 then return id_; end if;
      if cnt > 1 then fail('Forma "' || txt || '" jest niejednoznaczna - pasuje do kilku form zajęć'); end if;
      if lengthb(trim(txt)) > 30 then fail('Forma "' || txt || '": nazwa nowej formy zajęć może mieć najwyżej 30 znaków'); end if;

      select main_seq.nextval into id_ from dual;
      insert into forms (id, abbreviation, name, kind, colour)
           values (id_, trim(txt), trim(txt), pkind, randomColour);
      grantToUser('FOR', id_);
      noteCreated('Forma zajęć', trim(txt));
      return id_;
    end;

    -----------------------------------------------------------------------------------------------------------------------------
    -- lista "a, b, c" -> identyfikatory "1;2;3" (bez powtórzeń); kind: L / G / R
    function idList(kind varchar2, txt varchar2) return varchar2 is
      res  varchar2(4000);
      elem varchar2(400);
      id_  number;
    begin
      for i in 1 .. regexp_count(nvl(txt, ' '), '[^,]+') loop
        elem := trim(regexp_substr(txt, '[^,]+', 1, i));
        if elem is not null then
          case kind
            when 'L' then id_ := lecturerId(elem);
            when 'G' then id_ := groupId(elem);
            else          id_ := roomId(elem);
          end case;
          if instr(';' || res || ';', ';' || id_ || ';') = 0 then
            res := xxmsz_tools.merge(res, to_char(id_), ';');
          end if;
        end if;
      end loop;
      return res;
    end;

    -----------------------------------------------------------------------------------------------------------------------------
    function parseDate(txt varchar2) return date is
      t varchar2(100) := trim(txt);
      d date;
    begin
      if t is null then fail('Brak daty'); end if;
      -- liczba = data Excela (dni od 1899-12-30)
      if regexp_like(t, '^\d+([.,]\d*)?$') then
        return date '1899-12-30' + to_number(regexp_substr(t, '^\d+'));
      end if;
      for f in (select column_value fmt from table(sys.odcivarchar2list('YYYY-MM-DD', 'DD.MM.YYYY', 'DD-MM-YYYY', 'YYYY.MM.DD', 'DD/MM/YYYY', 'YYYY/MM/DD'))) loop
        begin
          d := to_date(regexp_substr(t, '^\S+'), 'FX' || f.fmt);
          return d;
        exception when others then null;
        end;
      end loop;
      fail('Nieprawidłowa data "' || txt || '". Użyj formatu daty Excela albo RRRR-MM-DD lub DD.MM.RRRR');
    end;

    -----------------------------------------------------------------------------------------------------------------------------
    -- Wypełnienie: 10, 20, ... 100 (jak w oknie Szczegóły zajęć); puste = 100
    function parseFill(txt varchar2) return number is
      t varchar2(100) := trim(txt);
    begin
      if t is null then return 100; end if;
      if not regexp_like(t, '^(10|20|30|40|50|60|70|80|90|100)([.,]0*)?$') then
        fail('Nieprawidłowe wypełnienie "' || txt || '". Podaj 10, 20, 30, ... 100 albo zostaw puste (= 100)');
      end if;
      return to_number(regexp_substr(t, '^\d+'));
    end;

    -- Kolor: liczba jak w programie (CLASSES.COLOUR), 0 .. 16777215; puste = brak koloru zajęć
    function parseColour(txt varchar2) return number is
      t varchar2(100) := trim(txt);
    begin
      if t is null then return null; end if;
      if not regexp_like(t, '^\d{1,8}([.,]0*)?$') or to_number(regexp_substr(t, '^\d+')) > 16777215 then
        fail('Nieprawidłowy kolor "' || txt || '". Podaj liczbę od 0 do 16777215 albo zostaw puste');
      end if;
      return to_number(regexp_substr(t, '^\d+'));
    end;

    -----------------------------------------------------------------------------------------------------------------------------
    -- przed wstawieniem: czytelna lista zajętych zasobów (w tym zajęcia z wcześniejszych wierszy pliku)
    -- wyszukiwanie po indeksach LEC_ID / GRO_ID / ROM_ID (bez przeszukiwania całych tabel)
    procedure checkConflicts(pday date, phour number, lecIds varchar2, groIds varchar2, romIds varchar2) is
      msg   varchar2(4000);
      claId number;
      resId varchar2(40);

      function classDsp(id_ number) return varchar2 is
        r varchar2(1000);
      begin
        select sub.name || ' (' || frm.name || ')' into r
          from classes c, subjects sub, forms frm
         where c.id = id_ and sub.id(+) = c.sub_id and frm.id(+) = c.for_id;
        return r;
      exception when no_data_found then return null;
      end;

      procedure add(resDsp varchar2) is
      begin
        msg := substr(xxmsz_tools.merge(msg, resDsp || ' ma już zajęcia w tym terminie: ' || classDsp(claId), '; '), 1, 3000);
      end;
    begin
      for i in 1 .. regexp_count(nvl(lecIds, ' '), '[^;]+') loop
        resId := regexp_substr(lecIds, '[^;]+', 1, i);
        select max(cla_id) into claId from lec_cla
         where lec_id = to_number(resId) and day = pday and hour = phour and no_conflict_flag is null;
        if claId is not null then
          for l in (select trim(title || ' ' || first_name || ' ' || last_name) n from lecturers where id = resId) loop add('Wykładowca ' || l.n); end loop;
        end if;
      end loop;
      for i in 1 .. regexp_count(nvl(groIds, ' '), '[^;]+') loop
        resId := regexp_substr(groIds, '[^;]+', 1, i);
        select max(cla_id) into claId from gro_cla
         where gro_id = to_number(resId) and day = pday and hour = phour and no_conflict_flag is null;
        if claId is not null then
          for g in (select nvl(abbreviation, name) n from groups where id = resId) loop add('Grupa ' || g.n); end loop;
        end if;
      end loop;
      for i in 1 .. regexp_count(nvl(romIds, ' '), '[^;]+') loop
        resId := regexp_substr(romIds, '[^;]+', 1, i);
        select max(cla_id) into claId from rom_cla
         where rom_id = to_number(resId) and day = pday and hour = phour and no_conflict_flag is null;
        if claId is not null then
          for r in (select name n from rooms where id = resId) loop add('Sala ' || r.n); end loop;
        end if;
      end loop;
      if msg is not null then fail('Konflikt. ' || msg); end if;
    end;

    -----------------------------------------------------------------------------------------------------------------------------
    function friendlyError(code number, msg varchar2) return varchar2 is
      m varchar2(4000) := regexp_substr(msg, '^[^' || chr(10) || ']*');
    begin
      if code = -1 then
        if    instr(msg, 'LEC_CLA_U') > 0 then return 'Konflikt: wykładowca ma już zajęcia w tym terminie';
        elsif instr(msg, 'GRO_CLA_U') > 0 then return 'Konflikt: grupa ma już zajęcia w tym terminie';
        elsif instr(msg, 'ROM_CLA_U') > 0 then return 'Konflikt: sala ma już zajęcia w tym terminie';
        end if;
      end if;
      -- bez "ORA-20500: " itp.
      return regexp_replace(m, '^ORA-\d+: ', '');
    end;

    -----------------------------------------------------------------------------------------------------------------------------
    -- "3;1;2" -> "1;2;3" (porównywanie kompletów niezależnie od kolejności)
    function sortedIds(ids varchar2) return varchar2 is
      res varchar2(4000);
    begin
      select listagg(n, ';') within group (order by n) into res
        from (select distinct to_number(trim(regexp_substr(ids, '[^;]+', 1, level))) n
                from dual
             connect by level <= regexp_count(nvl(ids, ' '), '[^;]+'))
       where n is not null;
      return res;
    end;

    -----------------------------------------------------------------------------------------------------------------------------
    -- identyczne zajęcia: ten sam termin, przedmiot, forma i ten sam komplet wykładowców, grup i sal.
    -- Takie zajęcia zajmują pierwszy zasób wiersza w tym terminie - jedyny kandydat jest wyszukiwany po indeksie.
    function identicalExists(pday date, phour number, psub number, pfor number, lecIds varchar2, groIds varchar2, romIds varchar2) return boolean is
      claId number;
      firstId number;
    begin
      if lecIds is not null then
        firstId := to_number(regexp_substr(lecIds, '[^;]+'));
        select max(cla_id) into claId from lec_cla where lec_id = firstId and day = pday and hour = phour and no_conflict_flag is null;
      elsif groIds is not null then
        firstId := to_number(regexp_substr(groIds, '[^;]+'));
        select max(cla_id) into claId from gro_cla where gro_id = firstId and day = pday and hour = phour and no_conflict_flag is null;
      else
        firstId := to_number(regexp_substr(romIds, '[^;]+'));
        select max(cla_id) into claId from rom_cla where rom_id = firstId and day = pday and hour = phour and no_conflict_flag is null;
      end if;
      if claId is null then return false; end if;

      -- komplety z LEC_CLA / GRO_CLA / ROM_CLA (calc_*_ids w CLASSES są obcinane do 255 znaków)
      for c in (select sub_id, for_id
                     , (select listagg(lec_id, ';') within group (order by lec_id) from lec_cla where cla_id = claId and is_child = 'N') lec
                     , (select listagg(gro_id, ';') within group (order by gro_id) from gro_cla where cla_id = claId and is_child = 'N') gro
                     , (select listagg(rom_id, ';') within group (order by rom_id) from rom_cla where cla_id = claId and is_child = 'N') rom
                  from classes where id = claId) loop
        return nvl(c.sub_id, -1) = nvl(psub, -1) and nvl(c.for_id, -1) = pfor
           and nvl(c.lec, '-') = nvl(sortedIds(lecIds), '-')
           and nvl(c.gro, '-') = nvl(sortedIds(groIds), '-')
           and nvl(c.rom, '-') = nvl(sortedIds(romIds), '-');
      end loop;
      return false;
    end;

    -----------------------------------------------------------------------------------------------------------------------------
    procedure deleteAllData is
    begin
      if user <> 'PLANNER' then
        fail('Kasowanie całej zawartości bazy danych może uruchomić tylko użytkownik PLANNER');
      end if;
      for c in (select column_value s from table(sys.odcivarchar2list(
                   'truncate table lec_cla'
                 , 'truncate table gro_cla'
                 , 'truncate table rom_cla'
                 , 'truncate table lec_cla_history'
                 , 'truncate table gro_cla_history'
                 , 'truncate table rom_cla_history'
                 , 'truncate table RECENTLY_USED'
                 , 'truncate table RESERVATIONS'
                 , 'truncate table RES_HINTS'
                 , 'truncate table ROOMS_HISTORY'
                 , 'truncate table FORMS_HISTORY'
                 , 'truncate table GROUPS_HISTORY'
                 , 'truncate table LECTURERS_HISTORY'
                 , 'truncate table SUBJECTS_HISTORY'
                 , 'truncate table TT_LOG'
                 , 'truncate table CLASSES_HISTORY'
                 , 'truncate table DIFF_CATCHER_HELPER'
                 , 'truncate table INT_CLASSES'
                 , 'truncate table INT_CLASSES_DIFF'
                 , 'truncate table INT_CLASS_MEMBERS'
                 , 'truncate table INT_CLASS_MEMBERS_DIFF'
                 , 'truncate table TIMETABLE_NOTES'
                 , 'truncate table TMP_SELECTED_DATES'
                 , 'truncate table TT_RESOURCE_LISTS'
                 , 'truncate table TT_INCLUSIONS'
                 , 'truncate table TT_CLA'
                 , 'delete from TT_COMBINATIONS'
                 , 'truncate table xxmsztools_eventlog'
                 , 'delete from classes'
                 , 'truncate table classes_history'
                 , 'truncate table res_pla_history'
                 , 'delete from subjects where id > 0'
                 , 'delete from groups where id > 0'
                 , 'delete from lecturers where id > 0'
                 , 'delete from rooms where id > 0'
                 , 'delete from form_formulas where id > 0'
                 , 'delete from forms where id > 0'
                 , 'delete from periods where name like ''%(%'' and name like ''%)%''')))
      loop
        begin
          execute immediate c.s;
        exception when others then
          raise_application_error(-20500, c.s || ': ' || sqlerrm);
        end;
      end loop;
      commit;
    end;

    -----------------------------------------------------------------------------------------------------------------------------
    procedure import is
      vday    date;
      vhour   number;
      lecIds  varchar2(4000);
      groIds  varchar2(4000);
      romIds  varchar2(4000);
      vsub    number;
      vfor    number;
      vowner  varchar2(255);
      vfill   number;
      vcolour number;
      vpla    varchar2(30);
      elem    varchar2(400);
      cnt     number;
      before_ number;
      k       varchar2(400);
    begin
      g_created.delete;
      select max(id) into g_pla_id from planners where name = user;
      select min(id) into g_orguni_id from org_units;

      update cla_interface set status = null, message = null, cla_id = null, day = null, hour = null where created_by = user;

      for rec in (select rowid rid, t.* from cla_interface t where created_by = user order by line_no) loop
        savepoint cla_row;
        g_row_new.delete;
        begin
          vday := parseDate(rec.day_txt);

          if trim(rec.hour_txt) is null then fail('Brak godziny'); end if;
          if not regexp_like(trim(rec.hour_txt), '^\d+$') then
            fail('Nieprawidłowa godzina "' || rec.hour_txt || '". Podaj numer godziny z siatki godzin, np. 1, 2, 3');
          end if;
          vhour := to_number(trim(rec.hour_txt));
          select count(1) into cnt from grids where no = vhour and hour_from is not null;
          if cnt = 0 then fail('Godziny nr ' || vhour || ' nie ma w siatce godzin (Słowniki | Siatka godzin)'); end if;

          if trim(rec.for_txt) is null then fail('Brak formy zajęć'); end if;
          vfill   := parseFill(rec.fill_txt);
          vcolour := parseColour(rec.colour_txt);

          -- kilku właścicieli: "A;B" (jak w rozkładzie) albo "A, B"
          vowner := null;
          for i in 1 .. regexp_count(nvl(rec.owner_txt, ' '), '[^;,]+') loop
            elem := trim(regexp_substr(rec.owner_txt, '[^;,]+', 1, i));
            if elem is not null then
              select max(name) into vpla from planners where upper(name) = upper(elem);
              if vpla is null then fail('Nie znaleziono planisty "' || elem || '" (kolumna Właściciel)'); end if;
              if instr(';' || vowner || ';', ';' || vpla || ';') = 0 then
                vowner := xxmsz_tools.merge(vowner, vpla, ';');
              end if;
            end if;
          end loop;
          if vowner is null then vowner := user; end if;

          lecIds := idList('L', rec.lec_txt);
          groIds := idList('G', rec.gro_txt);
          romIds := idList('R', rec.rom_txt);
          if lecIds is null and groIds is null and romIds is null then
            fail('Podaj co najmniej jednego wykładowcę, grupę albo salę');
          end if;
          -- bez przedmiotu: rezerwacja (nowa forma jest tworzona jako rezerwacja)
          vsub := case when trim(rec.sub_txt) is not null then subjectId(rec.sub_txt) end;
          vfor := formId(rec.for_txt, case when vsub is null then 'R' else 'C' end);

          if identicalExists(vday, vhour, vsub, vfor, lecIds, groIds, romIds) then
            raise_application_error(-20501, 'Pominięto - takie zajęcia już są w rozkładzie');
          end if;
          checkConflicts(vday, vhour, lecIds, groIds, romIds);

          before_ := planner_utils.get_output_param_num1;
          planner_utils.insert_classes(
               pday              => vday
             , phour             => vhour
             , pfill             => vfill
             , psub_id           => vsub
             , pfor_id           => vfor
             , powner            => vowner
             , pcalc_lec_ids     => lecIds
             , pcalc_gro_ids     => groIds
             , pcalc_rom_ids     => romIds
             , pcolour           => vcolour
             , pdesc1            => substrb(rec.desc1, 1, 200)  -- info dla planistów (kolumny CLASSES.DESC* - długość w bajtach)
             , pdesc2            => substrb(rec.desc2, 1, 200)  -- info dla studentów
             , pdesc3            => substrb(rec.desc3, 1, 100)
             , pdesc4            => substrb(rec.desc4, 1, 100)
             , pcreator          => user
             , pgrantPermissions => case when instr(vowner, ';') = 0 then 'Y' else 'N' end);
          if nvl(planner_utils.get_output_param_num1, -1) = nvl(before_, -1) then
            fail('Zajęcia pominięte - brak uprawnień do przedmiotu');
          end if;
          if instr(vowner, ';') > 0 then grantToOwners(vowner, lecIds, groIds, romIds); end if;

          update cla_interface
             set status = 'OK', day = vday, hour = vhour, cla_id = planner_utils.get_output_param_num1
           where rowid = rec.rid;
          k := g_row_new.first;
          while k is not null loop
            g_created(k) := g_row_new(k);
            k := g_row_new.next(k);
          end loop;
        exception
          when e_duplicate then
            rollback to savepoint cla_row;
            update cla_interface set status = 'DUP', message = 'Pominięto - takie zajęcia już są w rozkładzie', day = vday where rowid = rec.rid;
          when others then
            declare
              m varchar2(4000) := friendlyError(sqlcode, sqlerrm);
            begin
              rollback to savepoint cla_row;
              update cla_interface set status = 'ERR', message = m, day = vday where rowid = rec.rid;
            end;
        end;
        vday := null;
      end loop;

      xxmsz_tools.insertIntoEventLog('CLA_INTERFACE: OK', 'I', 'CLA_INTERFACE');
    end;

    -----------------------------------------------------------------------------------------------------------------------------
    function getReport (pTestRun varchar2 default 'N') return clob is
      res  clob;
      rok  number;
      rerr number;
      rdup number;
      k    varchar2(400);
      procedure w(s varchar2) is
      begin
        dbms_lob.writeappend(res, length(s), s);
      end;
    begin
      dbms_lob.createtemporary(res, true, dbms_lob.session);
      select count(case when status = 'OK' then 1 end), count(case when status = 'ERR' then 1 end), count(case when status = 'DUP' then 1 end)
        into rok, rerr, rdup
        from cla_interface where created_by = user;

      w('<!DOCTYPE html>
<html lang="pl">
<head>
<meta charset="utf-8">
<title>Import rozkładu zajęć: wyniki</title>
<style>
  body { font-family: "Segoe UI", Arial, sans-serif; color: #1f2937; margin: 24px; }
  h1 { font-size: 22px; margin: 0 0 4px; }
  .sub { color: #6b7280; margin-bottom: 18px; }
  .cards { display: flex; gap: 12px; margin-bottom: 22px; flex-wrap: wrap; }
  .card { border-radius: 8px; padding: 12px 18px; min-width: 150px; }
  .card b { display: block; font-size: 26px; }
  .ok { background: #dcfce7; } .err { background: #fee2e2; } .new { background: #e0f2fe; } .dup { background: #f3f4f6; }
  .test { background: #fef9c3; border: 1px solid #eab308; padding: 10px 14px; border-radius: 8px; margin-bottom: 18px; }
  h2 { font-size: 17px; margin: 24px 0 8px; }
  table { border-collapse: collapse; width: 100%; font-size: 13px; }
  th, td { border: 1px solid #d1d5db; padding: 5px 8px; text-align: left; vertical-align: top; }
  th { background: #f3f4f6; }
  td.msg { color: #b91c1c; font-weight: 600; }
  td:nth-child(3), td:nth-child(4) { white-space: nowrap; }
  ul { columns: 3; font-size: 13px; }
</style>
</head>
<body>
<h1>Ułożony rozkład zajęć: import z pliku Excel</h1>
<div class="sub">' || to_char(sysdate, 'YYYY-MM-DD HH24:MI') || ', ' || h(user) || '</div>
');
      if pTestRun = 'Y' then
        w('<div class="test"><b>Uruchomienie testowe</b> - dane nie zostały zapisane w bazie danych. Raport pokazuje, co zostałoby zaimportowane.</div>');
      end if;
      w('<div class="cards"><div class="card ok"><b>' || rok || '</b>zaimportowanych zajęć</div>'||
        '<div class="card err"><b>' || rerr || '</b>wierszy z błędami (pominiętych)</div>'||
        '<div class="card dup"><b>' || rdup || '</b>pominiętych - już są w rozkładzie</div>'||
        '<div class="card new"><b>' || g_created.count || '</b>utworzonych obiektów</div></div>');

      if rerr > 0 then
        w('<h2>Wiersze, których nie zaimportowano</h2><table><tr><th>Wiersz</th><th>Błąd</th><th>Data</th><th>Godzina</th><th>Wykładowca</th><th>Grupa</th><th>Sala</th><th>Przedmiot</th><th>Forma</th><th>Właściciel</th></tr>');
        for rec in (select * from cla_interface where created_by = user and status = 'ERR' order by line_no) loop
          w('<tr><td>' || rec.line_no || '</td><td class="msg">' || h(rec.message) ||
            '</td><td>' || h(nvl(to_char(rec.day, 'YYYY-MM-DD'), rec.day_txt)) || '</td><td>' || h(rec.hour_txt) ||
            '</td><td>' || h(rec.lec_txt) || '</td><td>' || h(rec.gro_txt) || '</td><td>' || h(rec.rom_txt) ||
            '</td><td>' || h(rec.sub_txt) || '</td><td>' || h(rec.for_txt) || '</td><td>' || h(rec.owner_txt) || '</td></tr>' || chr(10));
        end loop;
        w('</table>');
      end if;

      if g_created.count > 0 then
        w('<h2>Utworzone obiekty</h2><ul>');
        k := g_created.first;
        while k is not null loop
          w('<li>' || h(k) || '</li>');
          k := g_created.next(k);
        end loop;
        w('</ul>');
      end if;

      if rerr = 0 then
        w('<h2>Brak błędów.</h2>');
      end if;
      if rdup > 0 then
        w('<p>Wiersze pominięte jako już istniejące (np. przy ponownym imporcie tego samego pliku) to zajęcia o tym samym terminie, '||
          'przedmiocie, formie oraz tym samym komplecie wykładowców, grup i sal. Nie są błędem i nie zostały zaimportowane drugi raz.</p>');
      end if;
      w('</body></html>');
      return res;
    end getReport;

end;
/
