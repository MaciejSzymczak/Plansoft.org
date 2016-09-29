REM ***************************************************************
REM * Autor: Maciej Szymczak
REM * Wykonywany jest po imporcie danych z pliku- zob. funkcja import z pliku w aplikacji
REM * Skrypt musi byæ uruchamiany przez u¿ytkownika planner
REM ***************************************************************


DECLARE  CURSOR TEMP
	IS
	select 'DROP PUBLIC SYNONYM '||SNAME S from SYS.SYNONYMS WHERE CREATOR = USER AND SYNTYPE = 'PUBLIC';
	C INTEGER;
BEGIN
	FOR REC_TEMP IN TEMP
	LOOP
           C := DBMS_SQL.OPEN_CURSOR;
           DBMS_SQL.PARSE(C, REC_TEMP.S,DBMS_SQL.V7);
           DBMS_SQL.CLOSE_CURSOR(C);	 		  
  END LOOP; 
EXCEPTION
 WHEN OTHERS
   THEN NULL; 
END;
/

DECLARE 
	CURSOR TEMP
	IS
	select 'CREATE PUBLIC SYNONYM '||object_name||' FOR '||object_name S from sys.all_objects where owner = user and OBJECT_TYPE NOT IN ('SYNONYM', 'INDEX', 'PACKAGE BODY') order by object_name;
	C INTEGER;
BEGIN
	FOR REC_TEMP IN TEMP
	LOOP
         C := DBMS_SQL.OPEN_CURSOR;
         BEGIN           
           DBMS_SQL.PARSE(C, REC_TEMP.S,DBMS_SQL.V7);           	 		  
         EXCEPTION -- ZABLOKOWANIE ZATRZYMANIA Z POWODU B£ÊDÓW
           WHEN OTHERS THEN 
             NULL; -- POLECENIE RAISE PODNOSI WYJ¥TEK
         END;
         DBMS_SQL.CLOSE_CURSOR(C);
  END LOOP;  
END;
/

rem Jeœli nie ma komunikatów o b³êdach, wpisz Exit i naciœnij Enter
exit
