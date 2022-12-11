CREATE OR REPLACE VIEW RESOURCES ("ID", "NAME") AS
select id, name from rooms 
union select id, nvl(abbreviation, name) from groups 
union select id, title||' '||last_name||' '||first_name from lecturers;