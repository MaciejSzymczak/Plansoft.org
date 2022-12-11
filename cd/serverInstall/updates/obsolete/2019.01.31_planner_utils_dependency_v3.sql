begin
insert into lecturers (id, abbreviation, first_name, orguni_id,colour, email) values (-1,'POD','POD', (select min(id) from org_units), 192+192*256+192*256*256,'dummy@dommy.com');
insert into lecturers (id, abbreviation, first_name, orguni_id,colour, email) values (-2,'NAD','NAD', (select min(id) from org_units), 192+192*256+192*256*256,'dummy@dommy.com');
insert into groups (id, abbreviation, name, orguni_id,colour) values (-1,'POD','Podgrupa', (select min(id) from org_units), 192+192*256+192*256*256);
insert into groups (id, abbreviation, name, orguni_id,colour) values (-2,'NAD','Nadgrupa', (select min(id) from org_units), 192+192*256+192*256*256);
insert into rooms (id, attribs_01, name, orguni_id,colour,rescat_id) values (-1,'POD','POD', (select min(id) from org_units), 192+192*256+192*256*256, 1);
insert into rooms (id, attribs_01, name, orguni_id,colour,rescat_id) values (-2,'NAD','NAD', (select min(id) from org_units), 192+192*256+192*256*256, 1);
commit;
end;
/
