INSERT INTO system_parameters (name,value) VALUES ('VERSION 2024.06.22', 'INSTALLED');
commit;

alter table usos_temp add (desc2 varchar2(200));
create table usos_streaming_room_map (id number, streaming_id number );
create index usos_streaming_room_map1 on usos_streaming_room_map(id);

*** package USOS;