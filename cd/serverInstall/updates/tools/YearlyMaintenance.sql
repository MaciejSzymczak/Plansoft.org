ALTER SYSTEM SET cursor_sharing = FORCE SCOPE=BOTH;

CHECK OCCUPATION (LIMIT 12GB!)
=======================================================

SELECT
    ROUND(SUM(bytes)/1024/1024/1024,2) AS used_gb,
    12 AS limit_gb,
    ROUND((12-SUM(bytes)/1024/1024/1024),2) AS free_gb,
    ROUND(SUM(bytes)/1024/1024/1024/12*100,2) AS used_percent
FROM dba_segments;

SELECT owner,
       segment_name,
       segment_type,
       ROUND(bytes/1024/1024,2) MB
FROM dba_segments
ORDER BY bytes DESC
FETCH FIRST 20 ROWS ONLY;

ALTER TABLE CLASSES ENABLE ROW MOVEMENT;
ALTER TABLE CLASSES SHRINK SPACE CASCADE;
ALTER TABLE CLASSES DISABLE ROW MOVEMENT;

SELECT owner,
       ROUND(SUM(bytes)/1024/1024/1024,2) GB
FROM dba_segments
GROUP BY owner
ORDER BY GB DESC;

SELECT COUNT(DISTINCT sql_id)
FROM v$sql;


BEGIN
  DBMS_WORKLOAD_REPOSITORY.MODIFY_SNAPSHOT_SETTINGS(
    topnsql => 30,
    interval => 60
  );
END;
/

BEGIN
  DBMS_WORKLOAD_REPOSITORY.MODIFY_SNAPSHOT_SETTINGS(
    retention => 11520  -- 8 dni
  );
END;
/

BEGIN
  DBMS_WORKLOAD_REPOSITORY.DROP_SNAPSHOT_RANGE(
    low_snap_id  => 1,
    high_snap_id => 200
  );
END;
/

BEGIN
  DBMS_WORKLOAD_REPOSITORY.MODIFY_BASELINE_WINDOW_SIZE(window_size => 5);
END;
/

--confirmation
SELECT baseline_id, baseline_name, baseline_type, moving_window_size
FROM dba_hist_baseline
WHERE baseline_type = 'MOVING_WINDOW';


SELECT COUNT(*) FROM dba_hist_snapshot
WHERE end_interval_time < SYSDATE - 9;

-- sprawdź czy segment ma movement enabled
SELECT table_name, row_movement 
FROM dba_tables 
WHERE table_name = 'WRH$_SQLTEXT';

-- jeśli DISABLED, włącz:
ALTER TABLE SYS.WRH$_SQLTEXT ENABLE ROW MOVEMENT;

SELECT name, open_mode FROM v$pdbs;
ALTER SESSION SET CONTAINER = XEPDB1;


ALTER SESSION SET CONTAINER = CDB$ROOT;
ALTER TABLE SYS.WRH$_SQLTEXT SHRINK SPACE;

SELECT * FROM TABLE(dbms_space.asa_recommendations()) 
WHERE tablespace_name = 'SYSAUX';


REBUILD
=======================================================


BEGIN
  FOR idx IN (
    SELECT index_name
    FROM dba_indexes
    WHERE owner = 'PLANNER'
  ) LOOP
    BEGIN
    EXECUTE IMMEDIATE 'ALTER INDEX "' || idx.index_name || '" REBUILD';
    EXCEPTION WHEN OTHERS THEN NULL; END;
  END LOOP;
END;
/

SOFT CLEAN
=======================================================
select table_name, num_rows from all_tables where owner = 'PLANNER' order by num_rows desc
truncate table CLASSES_HISTORY;
truncate table LECTURERS_HISTORY;
truncate table GRO_CLA_HISTORY;
truncate table LEC_CLA_HISTORY;
truncate table ROM_CLA_HISTORY;
truncate table FORMS_HISTORY;

begin
delete from xxmsztools_eventlog where created < sysdate - 90;
delete from classes_history where effective_start_date < sysdate - 90;
commit;
end;


CLEAN SYSTEM OBJECTS
=======================================================
connect as sys

select sum(bytes)/1024/1024/1024 size_in_gb from dba_segments 

--search for candidates to clear
select * from dba_segments order by bytes desc

purge dba_recyclebin;
truncate table aud$;
begin dbms_stats.purge_stats(sysdate-10); end;

truncate table WRI$_ADV_OBJECTS;
truncate table WRI$_SQLSET_PLAN_LINES;

select tablespace_name,sum(bytes)/1024/1024/1024 size_in_gb, file_name from dba_data_files group by tablespace_name, file_name


--not working ORA-03297
--alter database datafile 'C:\APP\EXT.MSZYMCZAK\PRODUCT\21C\ORADATA\XE\XEPDB1\SYSAUX01.DBF' resize 6g; 



2. Health check
SELECT LISTAGG(name, ', ') WITHIN GROUP (ORDER BY name) AS GRUPY_DUPLIKATY
FROM groups
GROUP BY upper(name)
having count(1)>1
order by 1




