--select * from system_parameters where name like 'VERSION%' order by name desc
INSERT INTO system_parameters (name,value) VALUES ('VERSION 2026.10.28', 'INSTALLED');
commit;

-- Wersja programu planowanie.exe w sesji bazy danych + dziennik logowań
--
-- 1. Program (od wersji 2026-10-28) zaraz po zalogowaniu ustawia w sesji swoją wersję:
--      dbms_application_info.set_action('ver=YYYY-MM-DD')
--    podgląd na żywo, kto pracuje i na jakiej wersji (pusty ACTION = stara wersja programu):
--      select username, osuser, machine, action from gv$session where lower(module) = 'planowanie.exe';
--
-- 2. planner_utils przy inicjalizacji pakietu (pierwsze wywołanie w sesji) odrzuca sesje planowanie.exe
--    które podały wersję starszą niż planner_utils.min_app_version (2026-01-01) - błąd ORA-20000 "Ta wersja
--    programu Plansoft.org jest nieaktualna...". Programy sprzed tej zmiany (np. 2026-09-09) nie ustawiają
--    wersji w sesji i NIE są blokowane - pakiet można zainstalować bez aktualizacji programu u użytkowników.
--    Joby, integracje i inne programy (MODULE <> planowanie.exe) nie są sprawdzane.
--
-- 3. Dziennik logowań (bez nowej tabeli): xxmsztools_eventlog, zapis z programu (TFMain.logSession)
--      select created, message_type, message from xxmsztools_eventlog where module_name = 'PLANOWANIE.SESSION' order by id desc;
--    ostatnia wersja programu każdego użytkownika:
--      select regexp_substr(message,'user=([^;]*)',1,1,null,1) usr,
--             max(regexp_substr(message,'ver=([^;]*)',1,1,null,1)) keep (dense_rank last order by id) ver,
--             max(created) last_logon
--        from xxmsztools_eventlog
--       where module_name = 'PLANOWANIE.SESSION' and message_type = 'LOGON'
--       group by regexp_substr(message,'user=([^;]*)',1,1,null,1)
--       order by ver, usr;
--    brak LOGOFF po LOGON = nieprawidłowe zakończenie programu (awaria, zabity proces, zerwane połączenie)

*** Install package planner_utils
