create user PLANNERREPORTS identified by "123";
grant CONNECT to PLANNERREPORTS;
grant RESOURCE to PLANNERREPORTS;
--select 'grant select on planner.'||lower(table_name)||' to plannerreports;' from cat where table_type = 'TABLE' order by
grant execute on planner.getSQLValues to plannerreports;

BEGIN
   FOR t IN (SELECT table_name FROM all_tables WHERE owner = 'PLANNER') LOOP
      EXECUTE IMMEDIATE 'GRANT SELECT ON PLANNER.' || t.table_name || ' TO PLANNERREPORTS';
   END LOOP;
END;
/

