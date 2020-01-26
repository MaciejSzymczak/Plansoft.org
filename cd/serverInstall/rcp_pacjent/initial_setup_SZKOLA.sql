-- inital setup for schools

begin
delete from FLEX_COL_USAGE;
Insert into FLEX_COL_USAGE
   (ID, FORM_NAME, CONTEXT_NAME, ATTR_NAME, CUSTOM_NAME, CAPTION, WIDTH, REQUIRED, LABEL_POS_X, LABEL_POS_Y, FIELD_POS_X, FIELD_POS_Y, SHOW_IN_LIST, SHOW_IN_ORDER_BY, SYSTEM_FLAG, SHOW_IN_WHERE, CREATION_DATE, CREATED_BY, LAST_UPDATE_DATE, LAST_UPDATED_BY)
 Values
   (1, 'FBrowseROOMS', 'Sala', 'ATTRIBS_01', 'BUILDING', 'Budynek', 300, '-', 0, 16, 89, 8, '+', '+', '+', '+', TO_DATE('10/09/2010 11:04:30', 'MM/DD/YYYY HH24:MI:SS'), 'PLANNER', TO_DATE('10/09/2010 11:04:30', 'MM/DD/YYYY HH24:MI:SS'), 'PLANNER');
Insert into FLEX_COL_USAGE
   (ID, FORM_NAME, CONTEXT_NAME, ATTR_NAME, CUSTOM_NAME, CAPTION, WIDTH, REQUIRED, LABEL_POS_X, LABEL_POS_Y, FIELD_POS_X, FIELD_POS_Y, SHOW_IN_LIST, SHOW_IN_ORDER_BY, SYSTEM_FLAG, SHOW_IN_WHERE, CREATION_DATE, CREATED_BY, LAST_UPDATE_DATE, LAST_UPDATED_BY)
 Values
   (2, 'FBrowseROOMS', 'Sala', 'ATTRIBN_01', 'CAPACITY', 'Pojemnoœæ', 100, '-', 517, 16, 605, 8, '+', '+', '+', '+', TO_DATE('10/09/2010 11:04:30', 'MM/DD/YYYY HH24:MI:SS'), 'PLANNER', TO_DATE('10/09/2010 11:04:30', 'MM/DD/YYYY HH24:MI:SS'), 'PLANNER');
COMMIT;
end;
/

begin
 update lookups set meaning = 'Dzienne' where code = 'STATIONARY' and LOOKUP_TYPE = 'GROUP_TYPE';
 update lookups set meaning = 'Zaoczne' where code = 'EXTRAMURAL' and LOOKUP_TYPE = 'GROUP_TYPE';
 update lookups set meaning = 'Inne' where code = 'OTHER' and LOOKUP_TYPE = 'GROUP_TYPE';
 update lookups set   MEANING = 'Zajêcie' where  CODE = 'C' and LOOKUP_TYPE = 'FORM_TYPE';
 commit;
end;
/

begin 
 update resource_categories set name = 'Sala' where id = 1; 
 update resource_categories set name = 'Rzutnik' where id = 2; 
 commit; 
end;
/



