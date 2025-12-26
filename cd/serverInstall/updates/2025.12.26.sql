--select * from system_parameters where name like 'VERSION%' order by name desc
INSERT INTO system_parameters (name,value) VALUES ('VERSION 2025.12.26', 'INSTALLED');
commit;

CREATE GLOBAL TEMPORARY TABLE holiday_days_temp
ON COMMIT PRESERVE ROWS
AS
SELECT *
FROM holiday_days
WHERE 1 = 0;

CREATE PUBLIC SYNONYM holiday_days_temp for planner.holiday_days_temp;
