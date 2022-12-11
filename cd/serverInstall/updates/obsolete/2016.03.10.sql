alter table CLASSES modify (desc1 varchar2(255), desc2 varchar2(255), desc3 varchar2(255), desc4 varchar2(255) );
alter table CLASSES_history modify (desc1 varchar2(255), desc2 varchar2(255), desc3 varchar2(255), desc4 varchar2(255) );
alter table CLASSES_h_temp modify (desc1 varchar2(255), desc2 varchar2(255), desc3 varchar2(255), desc4 varchar2(255) );

update lecturers set email = xxmsz_tools.erasePolishChars(first_name) ||'.'|| xxmsz_tools.erasePolishChars(last_name) ||'@demo.pl' where email is null;
alter table lecturers modify (email not null);
