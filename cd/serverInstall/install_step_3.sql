DECLARE CURSOR TEMP
IS
select 'DROP PUBLIC SYNONYM '||SNAME S from SYS.SYNONYMS WHERE CREATOR = USER AND SYNTYPE = 'PUBLIC';
BEGIN
FOR REC_TEMP IN TEMP
LOOP
 execute immediate REC_TEMP.S;
 END LOOP;
END;
/

DECLARE
CURSOR TEMP
IS
select 'CREATE PUBLIC SYNONYM '||object_name||' FOR '||object_name S from sys.all_objects where owner = user and
OBJECT_TYPE NOT IN ('SYNONYM', 'INDEX', 'PACKAGE BODY') order by object_name;
BEGIN
FOR REC_TEMP IN TEMP
	LOOP
		 BEGIN
			execute immediate REC_TEMP.S;
		 EXCEPTION 
		 WHEN OTHERS THEN
			NULL;
		 END;
	END LOOP;
END;
/

begin
delete from SYSTEM_PARAMETERS where name = 'PLANOWANIE.LICENCE_FOR';
insert into SYSTEM_PARAMETERS (name, value) values ('PLANOWANIE.LICENCE_FOR', 'DEMO');
commit;
end;
/