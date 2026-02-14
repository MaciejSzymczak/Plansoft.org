--select * from system_parameters where name like 'VERSION%' order by name desc
INSERT INTO system_parameters (name,value) VALUES ('VERSION 2026.02.11', 'INSTALLED');

SET DEFINE OFF;
DELETE FROM system_parameters where name in ('externalURL_LEC','externalURL_GRO','externalURL_ROM','externalURL_SUB');
INSERT INTO system_parameters (name,value) VALUES ('externalURL_LEC', 'http://www.oracle.com?authId={pla_id}&lec_id={lec_id}');
INSERT INTO system_parameters (name,value) VALUES ('externalURL_GRO', 'http://www.oracle.com?authId={pla_id}&gro_id={gro_id}');
INSERT INTO system_parameters (name,value) VALUES ('externalURL_ROM', 'http://www.oracle.com?authId={pla_id}&rom_id={rom_id}');
INSERT INTO system_parameters (name,value) VALUES ('externalURL_SUB', 'http://www.oracle.com?authId={pla_id}&sub_id={sub_id}');
commit;
