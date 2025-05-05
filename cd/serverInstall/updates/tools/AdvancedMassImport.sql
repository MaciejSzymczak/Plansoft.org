Follow the instructions described in user Guide, chapter "2.2.1.8.6 Zaawansowany import danych- scalanie"

SUBJECTS
=====================================================
select * from subjects where name like 'XX%'

--mass merge
declare
	procedure merge (pName varchar2) is
		psave_id number;
		pdelete_id number;
	begin
		Xxmsz_Tools.insertIntoEventLog('Merging:'||pName, 'I', 'MassMerge');
		select count(id) into psave_id from subjects where name = pName;
		if psave_id<>1 then Xxmsz_Tools.insertIntoEventLog('NOT Merged(1):'||pName, 'I', 'MassMerge'); return; end if;
		select count(id) into pdelete_id from subjects where name = 'XX'||pName;
		if pdelete_id<>1 then Xxmsz_Tools.insertIntoEventLog('NOT Merged(1):'||pName, 'I', 'MassMerge'); return; end if;
		select id into psave_id from subjects where name = pName;
		select id into pdelete_id from subjects where name = 'XX'||pName;
		update subjects 
		   set desc1=nvl(desc1,(select desc1 from subjects where id=pdelete_id))
		     , desc2=nvl(desc2,(select desc2 from subjects where id=pdelete_id)) 
		     , integration_id=nvl(integration_id,(select integration_id||'_UKID' from subjects where id=pdelete_id)) 
		     , orguni_id=nvl(orguni_id,(select orguni_id from subjects where id=pdelete_id)) 
		 where id = psave_id;
		planner_utils.merge_SUB (psave_id, pdelete_id, 'Y');
		update subjects 
		 set integration_id = replace(integration_id, '_UKID','')
		where id = psave_id;
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

--review issues / check results
select * from xxmsztools_eventlog WHERE MODULE_NAME = 'MassMerge' order by id desc

--update not merged subjects
update subjects set name = replace(name,'XX','') where name like 'XX%';
-- dealing with abbreviations
select replace(abbreviation,'XX','') abbreviation, count(1) from subjects group by replace(abbreviation,'XX','') having count(1)>1
select Id, abbreviation, name from subjects where replace(abbreviation,'XX','') in (select replace(abbreviation,'XX','') abbreviation from subjects group by replace(abbreviation,'XX','') having count(1)>1) order by abbreviation
update subjects set abbreviation = 'Psek' where id = 4099497;
begin planner_utils.merge_SUB ('4102510','4095585', 'Y'); end;
update subjects set abbreviation = replace(abbreviation,'XX','') where abbreviation like 'XX%';
update subjects set integration_id = replace(integration_id,'XX','') where integration_id like 'XX%';
commit



GROUPS
=============================================
select * from groups where name like 'XX%'

select id, abbreviation, name, created_by from groups where name in (
select name from
(
select replace(name,'XX','') name, count(1) from groups group by replace(name,'XX','') having count(1)>1
)
)
order by name


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

begin planner_utils.merge_GRO ('4098441', '4095056', 'Y'); end;

update groups set name = replace(name,'XX','') where name like 'XX%';
update groups set abbreviation = replace(abbreviation,'XX','') where abbreviation like 'XX%';

commit



GROUP HIERARCHY
=====================================================

update TEMP_H set child = 'XX'||child;
update TEMP_H set parent = 'XX'||parent;
commit;
alter table TEMP_H add (parent_id number, child_id number, error_message varchar2(500));
update TEMP_H set parent_id = (select id from groups where abbreviation = parent);
update TEMP_H set child_id = (select id from groups where abbreviation = child);
Verification: 
select * from TEMP_H 
select * from TEMP_H where parent_id is null or child_id is null

declare
 em varchar2(500);
begin
 for rec in (select temp_h.*, rowid from temp_h where parent_id is not null and child_id is not null) loop
    -- +=one parent -=more than one parent
    em := planner_utils.insert_str_elem (rec.parent_id, rec.child_id, 'STREAM', '-');
    update 	temp_h set error_message = em where rowid = rec.rowid;
 end loop;
 commit;
end;



LECTURERS
=====================================================
select replace(TITLE || FIRST_NAME || LAST_NAME,'XX','') abbreviation, count(1) from lecturers group by replace(TITLE || FIRST_NAME || LAST_NAME,'XX','') having count(1)>1
select * from lecturers where LAST_NAME like 'XX%'

--mass merge
declare
	procedure merge (pLNAME varchar2) is
		psave_id number;
		pdelete_id number;
	begin
		select count(id) into psave_id from lecturers where LAST_NAME || FIRST_NAME || TITLE = pLNAME;
		if psave_id<>1 then Xxmsz_Tools.insertIntoEventLog('NOT Merged(1):'||pLNAME, 'I', 'MassMerge'); return; end if;
		select count(id) into pdelete_id from lecturers where LAST_NAME || FIRST_NAME || TITLE = 'XX'||pLNAME;
		if pdelete_id<>1 then Xxmsz_Tools.insertIntoEventLog('NOT Merged(1):'||pLNAME, 'I', 'MassMerge'); return; end if;
		select id into psave_id from lecturers where LAST_NAME || FIRST_NAME || TITLE = pLNAME;
		select id into pdelete_id from lecturers where LAST_NAME || FIRST_NAME || TITLE = 'XX'||pLNAME;
		update lecturers 
		   set desc1=nvl(desc1,(select desc1 from lecturers where id=pdelete_id))
		     , desc2=nvl(desc2,(select desc2 from lecturers where id=pdelete_id)) 
		     , integration_id=nvl(integration_id,(select integration_id||'_UKID' from lecturers where id=pdelete_id)) 
		 where id = psave_id;
		planner_utils.merge_LEC (psave_id, pdelete_id, 'Y');
		update lecturers 
		 set integration_id = replace(integration_id, '_UKID','')
		where id = psave_id;
		Xxmsz_Tools.insertIntoEventLog('Merged:'||pLNAME, 'I', 'MassMerge');
	end;
begin
	Xxmsz_Tools.insertIntoEventLog('START', 'I', 'MassMerge');
	for rec in (select replace(LAST_NAME || FIRST_NAME || TITLE,'XX','') LNAME , count(1) from lecturers group by replace(LAST_NAME || FIRST_NAME || TITLE,'XX','') having count(1)>1) loop
	merge (rec.LNAME);
	end loop;
	Xxmsz_Tools.insertIntoEventLog('STOP', 'I', 'MassMerge');
	commit;
end;

--check results
select * from xxmsztools_eventlog WHERE MODULE_NAME = 'MassMerge' order by id desc

MANUAL FIX:
psave_id number := '4016728';
pdelete_id number := '4012027';
--
psave_id number := '4018583';
pdelete_id number := '4017467';
--
psave_id number := '4015187';
pdelete_id number := '4018607';
--
psave_id number := '4017447';
pdelete_id number := '4018631';
--
psave_id number := '4018641';
pdelete_id number := '4011421';
--
declare
 psave_id number := '4016728';
 pdelete_id number := '4012027';
begin
update lecturers 
   set desc1=nvl(desc1,(select desc1 from lecturers where id=pdelete_id))
	 , desc2=nvl(desc2,(select desc2 from lecturers where id=pdelete_id)) 
	 , integration_id=nvl(integration_id,(select integration_id||'_UKID' from lecturers where id=pdelete_id)) 
where id = psave_id;
planner_utils.merge_LEC (psave_id, pdelete_id, 'Y');
		update lecturers 
		 set integration_id = replace(integration_id, '_UKID','')
		where id = psave_id;
commit;
end;

MANUAL FIX:
update lecturers set abbreviation = 'DaMae' where abbreviation='XXDaMa';
commit;

select replace(abbreviation,'XX','') abbreviation, count(1) from lecturers group by replace(abbreviation,'XX','') having count(1)>1
update lecturers set last_name = replace(last_name,'XX','') where last_name like 'XX%';
update lecturers set abbreviation = replace(abbreviation,'XX','') where abbreviation like 'XX%';
update lecturers set integration_id = replace(integration_id,'XX','') where integration_id like 'XX%';
commit;

--final check
select replace(last_name,'XX','') last_name, count(1) from lecturers group by replace(last_name,'XX','') having count(1)>1
select Id, abbreviation, last_name, first_name, title from lecturers where replace(last_name,'XX','') in (select replace(last_name,'XX','') last_name from lecturers group by replace(last_name,'XX','') having count(1)>1) order by last_name
select Id, abbreviation, last_name, first_name, title from lecturers where replace(last_name,'XX','')||replace(first_name,'XX','')||replace(title,'XX','') in (select replace(last_name,'XX','')||replace(first_name,'XX','')||replace(title,'XX','') from lecturers group by replace(last_name,'XX','')||replace(first_name,'XX','')||replace(title,'XX','') having count(1)>1) order by last_name


-- final data review
select id, title, first_name, last_name, email, created_by, desc1, desc2, creation_date from lecturers order by creation_date desc


ROOMS
=====================================================
select * from ROOMS where name like 'XX%'

--consider to change the criteria with: name, attribs_01

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
		update rooms 
		   set desc1=nvl(desc1,(select desc1 from rooms where id=pdelete_id))
		     , desc2=nvl(desc2,(select desc2 from rooms where id=pdelete_id)) 
		 where id = psave_id;
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

