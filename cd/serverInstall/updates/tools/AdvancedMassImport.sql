SUBJECTS
=====================================================
select * from subjects where name like 'XX%'

--mass merge
declare
procedure merge (pName varchar2) is
psave_id number;
pdelete_id number;
begin
select count(id) into psave_id from subjects where name = pName;
if psave_id<>1 then Xxmsz_Tools.insertIntoEventLog('NOT Merged(1):'||pName, 'I', 'MassMerge'); return; end if;
select count(id) into pdelete_id from subjects where name = 'XX'||pName;
if pdelete_id<>1 then Xxmsz_Tools.insertIntoEventLog('NOT Merged(1):'||pName, 'I', 'MassMerge'); return; end if;
select id into psave_id from subjects where name = pName;
select id into pdelete_id from subjects where name = 'XX'||pName;
--TO DO: update rooms set desc1=nvl(desc1,(select desc1 from rooms where id=pdelete_id)), desc2=nvl(desc2,(select desc2 from rooms where id=pdelete_id)) where id = psave_id;
planner_utils.merge_SUB (psave_id, pdelete_id, 'Y');
Xxmsz_Tools.insertIntoEventLog('Merged:'||pName, 'I', 'MassMerge');
end;
begin
Xxmsz_Tools.insertIntoEventLog('START', 'I', 'MassMerge');
for rec in (select replace(name,'XX','') name, count(1) from subjects group by replace(name,'XX','') having count(1)>1) loop
merge (rec.Name);
end loop;
commit;
Xxmsz_Tools.insertIntoEventLog('STOP', 'I', 'MassMerge');
end;

--check results
select * from xxmsztools_eventlog WHERE MODULE_NAME = 'MassMerge' order by id desc

--update not merged subjects
update subjects set name = replace(name,'XX','') where name like 'XX%';
-- dealing with abbreviations
select replace(abbreviation,'XX','') abbreviation, count(1) from subjects group by replace(abbreviation,'XX','') having count(1)>1
select Id, abbreviation, name from subjects where replace(abbreviation,'XX','') in (select replace(abbreviation,'XX','') abbreviation from subjects group by replace(abbreviation,'XX','') having count(1)>1) order by abbreviation
update subjects set abbreviation = 'Psek' where id = 4099497;
begin planner_utils.merge_SUB ('4102510','4095585', 'Y'); end;
update subjects set abbreviation = replace(abbreviation,'XX','') where abbreviation like 'XX%';
commit

GROUPS
=============================================
select * from groups where name like 'XX%'

--mass merge
declare
procedure merge (pName varchar2) is
psave_id number;
pdelete_id number;
begin
select count(id) into psave_id from groups where name = pName;
if psave_id<>1 then Xxmsz_Tools.insertIntoEventLog('NOT Merged(1):'||pName, 'I', 'MassMerge'); return; end if;
select count(id) into pdelete_id from groups where name = 'XX'||pName;
if pdelete_id<>1 then Xxmsz_Tools.insertIntoEventLog('NOT Merged(1):'||pName, 'I', 'MassMerge'); return; end if;
select id into psave_id from groups where name = pName;
select id into pdelete_id from groups where name = 'XX'||pName;
--TO DO: update rooms set desc1=nvl(desc1,(select desc1 from rooms where id=pdelete_id)), desc2=nvl(desc2,(select desc2 from rooms where id=pdelete_id)) where id = psave_id;
planner_utils.merge_GRO (psave_id, pdelete_id, 'Y');
Xxmsz_Tools.insertIntoEventLog('Merged:'||pName, 'I', 'MassMerge');
end;
begin
Xxmsz_Tools.insertIntoEventLog('START', 'I', 'MassMerge');
for rec in (select replace(name,'XX','') name, count(1) from groups group by replace(name,'XX','') having count(1)>1) loop
merge (rec.Name);
end loop;
Xxmsz_Tools.insertIntoEventLog('STOP', 'I', 'MassMerge');
commit;
end;

--check results
select * from xxmsztools_eventlog WHERE MODULE_NAME = 'MassMerge' order by id desc

NOT Merged(1):195IC_A
select id, abbreviation, name, creation_date, created_by from groups where name like '%195IC_B%'
4098441	195IC.A	195IC_A	23/01/10	AAAAAAA
4095056	195IC_A	195IC_A	21/08/11	PLANNER
begin planner_utils.merge_GRO ('4098441', '4095056', 'Y'); end;

update groups set name = replace(name,'XX','') where name like 'XX%';
update groups set abbreviation = replace(abbreviation,'XX','') where abbreviation like 'XX%';

commit

LECTURERS
=====================================================
select * from lecturers where abbreviation like 'XX%'

--mass merge
declare
procedure merge (pabbreviation varchar2) is
psave_id number;
pdelete_id number;
begin
select count(id) into psave_id from lecturers where abbreviation = pabbreviation;
if psave_id<>1 then Xxmsz_Tools.insertIntoEventLog('NOT Merged(1):'||pabbreviation, 'I', 'MassMerge'); return; end if;
select count(id) into pdelete_id from lecturers where abbreviation = 'XX'||pabbreviation;
if pdelete_id<>1 then Xxmsz_Tools.insertIntoEventLog('NOT Merged(1):'||pabbreviation, 'I', 'MassMerge'); return; end if;
select id into psave_id from lecturers where abbreviation = pabbreviation;
select id into pdelete_id from lecturers where abbreviation = 'XX'||pabbreviation;
--TO DO: update rooms set desc1=nvl(desc1,(select desc1 from rooms where id=pdelete_id)), desc2=nvl(desc2,(select desc2 from rooms where id=pdelete_id)) where id = psave_id;
planner_utils.merge_LEC (psave_id, pdelete_id, 'Y');
Xxmsz_Tools.insertIntoEventLog('Merged:'||pabbreviation, 'I', 'MassMerge');
end;
begin
Xxmsz_Tools.insertIntoEventLog('START', 'I', 'MassMerge');
for rec in (select replace(abbreviation,'XX','') abbreviation, count(1) from lecturers group by replace(abbreviation,'XX','') having count(1)>1) loop
merge (rec.abbreviation);
end loop;
Xxmsz_Tools.insertIntoEventLog('STOP', 'I', 'MassMerge');
commit;
end;

--check results
select * from xxmsztools_eventlog WHERE MODULE_NAME = 'MassMerge' order by id desc

select replace(last_name,'XX','') last_name, count(1) from lecturers group by replace(last_name,'XX','') having count(1)>1
select Id, abbreviation, last_name, first_name, title from lecturers where replace(last_name,'XX','') in (select replace(last_name,'XX','') last_name from lecturers group by replace(last_name,'XX','') having count(1)>1) order by last_name
select Id, abbreviation, last_name, first_name, title from lecturers where replace(last_name,'XX','')||replace(first_name,'XX','')||replace(title,'XX','') in (select replace(last_name,'XX','')||replace(first_name,'XX','')||replace(title,'XX','') from lecturers group by replace(last_name,'XX','')||replace(first_name,'XX','')||replace(title,'XX','') having count(1)>1) order by last_name


4099926	MarB	BIELAWSKI	Marek	mgr
4102548	BiMa	XXBIELAWSKI	Marek	mgr

declare
 psave_id number := '4099926';
 pdelete_id number := '4102548';
begin
update lecturers set desc1 = nvl(desc1, (select desc1 from lecturers where id=pdelete_id)) where id = psave_id;
planner_utils.merge_LEC (psave_id, pdelete_id, 'Y');
commit;
end;


update lecturers set abbreviation = replace(abbreviation,'XX','') where abbreviation like 'XX%';
update lecturers set last_name = replace(last_name,'XX','') where last_name like 'XX%';
commit;


ROOMS
=====================================================
select * from ROOMS where name like 'XX%'

--mass merge
declare
procedure merge (pName varchar2) is
psave_id number;
pdelete_id number;
begin
select count(id) into psave_id from rooms where name = pName;
if psave_id<>1 then Xxmsz_Tools.insertIntoEventLog('NOT Merged(1):'||pName, 'I', 'MassMerge'); return; end if;
select count(id) into pdelete_id from rooms where name = 'XX'||pName;
if pdelete_id<>1 then Xxmsz_Tools.insertIntoEventLog('NOT Merged(1):'||pName, 'I', 'MassMerge'); return; end if;
select id into psave_id from rooms where name = pName;
select id into pdelete_id from rooms where name = 'XX'||pName;
update rooms set desc1=nvl(desc1,(select desc1 from rooms where id=pdelete_id)), desc2=nvl(desc2,(select desc2 from rooms where id=pdelete_id)) where id = psave_id;
planner_utils.merge_RES (psave_id, pdelete_id, 'Y');
Xxmsz_Tools.insertIntoEventLog('Merged:'||pName, 'I', 'MassMerge');
end;
begin
Xxmsz_Tools.insertIntoEventLog('START', 'I', 'MassMerge');
for rec in (select replace(name,'XX','') name, count(1) from rooms group by replace(name,'XX','') having count(1)>1) loop
merge (rec.Name);
end loop;
commit;
Xxmsz_Tools.insertIntoEventLog('STOP', 'I', 'MassMerge');
end;

--check results
select * from xxmsztools_eventlog WHERE MODULE_NAME = 'MassMerge' order by id desc

update rooms set name = replace(name,'XX','') where name like 'XX%';
commit;

-- TODO: final data review
select id, title, first_name, last_name, email, created_by, desc1, desc2, creation_date from lecturers order by creation_date desc
