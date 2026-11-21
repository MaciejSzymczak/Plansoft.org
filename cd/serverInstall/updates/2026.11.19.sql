--select * from system_parameters where name like 'VERSION%' order by name desc
INSERT INTO system_parameters (name,value) VALUES ('VERSION 2026.11.19', 'INSTALLED');
commit;

-- USOS integration - planning the next semester (package usos, application from version 2026-11-20)
--
-- 1. New optional parameter USOS_PLAN_ONLY_CYKL (GUI field "Opcjonalnie: Kod cyklu tylko do pobrania planu"):
--      empty        = previous behaviour (download and send according to USOS_CYKL)
--      cycle code   = dictionaries and plan (USOS ==> Plansoft.org) are downloaded for USOS_CYKL AND for
--                     USOS_PLAN_ONLY_CYKL; the schedule (Plansoft.org ==> USOS) is sent for USOS_CYKL only.
--                     The plan of the current semester is still updated (it may change until the last day).
--    At the end of the transition period: USOS_CYKL := new cycle, USOS_PLAN_ONLY_CYKL := empty.
--    NOTE: the parameter name deliberately does NOT start with USOS_CYKL (queries use like 'USOS_CYKL%').
--    Like USOS_CYKL, the application also stores the value per user/role as '<user or role id>:USOS_PLAN_ONLY_CYKL'
--    (faculties may enter the transition period on different days). Package usos reads only the global value;
--    the per user/role value is prepared for packages that receive puserOrRoleId (e.g. usos_v2).
--    The package can be installed before the client upgrades the application - the old application does not
--    know the parameter, so it works as before. The transition mode can also be switched on/off without
--    the new application:
--      insert into system_parameters (name, value) values ('USOS_PLAN_ONLY_CYKL', '<cycle code>'); commit;
--      delete from system_parameters where name = 'USOS_PLAN_ONLY_CYKL'; commit;
--
-- 2. "Skasuj poprzednie dane" (clean-up mode) with two cycles: combinations from USOS are deleted once and
--    downloaded again for both cycles; links of groups shared by both cycles to the other cycle's role are kept.
--
-- 3. The period (PERIODS) created by the integration is made available to all users and roles (PER_PLA).
--    Requires table PER_PLA (2025.10.06.sql).
--
-- Log: select * from xxmsztools_eventlog where module_name = 'INTEGRATION_FROM_USOS' order by id desc;
--      (the message now contains the downloaded cycle codes, e.g. FROM USOS_PLAN:N:2026Z,2026L: OK)

*** Install package usos
