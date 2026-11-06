--select * from system_parameters where name like 'VERSION%' order by name desc
INSERT INTO system_parameters (name,value) VALUES ('VERSION 2026.11.04', 'INSTALLED');
commit;

-- Edycja | Kopiuj rozkład zajęć (program od wersji 2026-11-04):
--   Metoda I, przycisk "3. Usuń rozkład zajęć według pliku" - cla_interface_pkg.matchForDelete (wiersz pliku -> zajęcia)
--     i getDeleteReport; zajęcia usuwa program (api.delete_class), z uprawnieniami jak przy ręcznym usuwaniu
--   Metoda III "Przesuń rozkład" - cla_interface_pkg.moveClasses (przesunięcie zajęć o liczbę dni) i getMoveReport
-- Bez nowych tabel i innych obiektów - korzysta z CLA_INTERFACE (2026.10.29.sql).
-- Wymaga wcześniejszego 2026.10.29.sql (tabela CLA_INTERFACE).

*** install package cla_interface_pkg
