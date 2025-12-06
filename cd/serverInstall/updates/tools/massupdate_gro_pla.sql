--check missing and create (manually)
SELECT value
FROM (
select 'WLO22FP1N1' value from dual union all
select 'WLO22FP1S1' from dual union all
select 'WLO21EW1S0' from dual
)
MINUS
SELECT name FROM groups


--select id from planners where name = '<NAME>'
declare
ppla_id number := <setId>;
begin
for rec in (
select Id pobj_id from groups where name IN (
'WLO22FP1N1',
'WLO22FP1S1',
'WLO21EW1S0'
)
) 
	loop
		begin
		insert into gro_pla (id, PLA_ID, GRO_ID) values (GROPLA_SEQ.NEXTVAL, ppla_id, rec.pobj_id);
		exception
			when others then null;
		end;
	end loop;
	commit;
end;

--final check
select * from gro_pla where PLA_ID = (select id from planners where name = '<NAME>') and gro_id in (
select Id from groups where name IN (
'WLO22FP1N1',
'WLO22FP1S1',
'WLO21EW1S0'
)
)