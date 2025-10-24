--select * from system_parameters where name like 'VERSION%' order by name desc
INSERT INTO system_parameters (name,value) VALUES ('VERSION 2025.10.24', 'INSTALLED');
commit;

update system_parameters set value=(select Id from TT_RESCAT_COMBINATIONS where combination_number=122) where name = 'USOS_RESCAT_COMB_ID';
commit;

*** install package tt_interface_pkg

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