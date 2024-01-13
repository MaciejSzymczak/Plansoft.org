alter table lecturers add (diff_message varchar2(500));
alter table lecturers_history add (diff_message varchar2(500));
create index lec_diff_message on lecturers (diff_message);