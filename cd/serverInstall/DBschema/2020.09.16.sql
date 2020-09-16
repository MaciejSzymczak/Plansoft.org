create unique index org_units_code on org_units (code);

insert into lookups (id, value_set_id, lookup_type, code, meaning, enabled) values (lookups_seq.nextval, (select id from VALUE_SETS where name = 'DBMESSAGE_TRANSLATION'), 'DBMESSAGE_TRANSLATION','ORG_UNITS_CODE','Nie można zapisać danych, ponieważ istnieje jednostka organizacyjna o podanym KODZIE','Y')
/
