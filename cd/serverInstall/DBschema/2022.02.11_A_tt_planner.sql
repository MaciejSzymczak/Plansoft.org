INSERT INTO system_parameters (name,value) VALUES ('VERSION 2022.01.30', 'INSTALLED');
commit;

alter table TT_COMBINATIONS add (PER_ID number);
alter table TT_COMBINATIONS add (LEC_ID number);
alter table TT_COMBINATIONS add (SUB_ID number);
alter table TT_COMBINATIONS add (FOR_ID number);
alter table TT_COMBINATIONS add (GRO_ID number);
alter table TT_COMBINATIONS add (ROM_ID number);
alter table TT_COMBINATIONS add (RES_ID number);
alter table TT_COMBINATIONS add (PLA_ID number);
alter table TT_COMBINATIONS add (INTEGRATION_ID varchar2(20));
create unique index INTEGRATION_ID_TTC on TT_COMBINATIONS (INTEGRATION_ID); 
create index TTC_PER_ID on TT_COMBINATIONS (PER_ID);
create index TTC_LEC_ID on TT_COMBINATIONS (LEC_ID);
create index TTC_SUB_ID on TT_COMBINATIONS (SUB_ID);
create index TTC_FOR_ID on TT_COMBINATIONS (FOR_ID);
create index TTC_GRO_ID on TT_COMBINATIONS (GRO_ID);
create index TTC_ROM_ID on TT_COMBINATIONS (ROM_ID);
create index TTC_RES_ID on TT_COMBINATIONS (RES_ID);
create index TTC_PLA_ID on TT_COMBINATIONS (PLA_ID);

--MERGE INTO TT_COMBINATIONS m USING (select tt_comb_id, res_id from tt_resource_lists where res_id in (select Id from lecturers)) ON (m.id = tt_comb_id) WHEN MATCHED THEN UPDATE SET lec_id = res_id;
--MERGE INTO TT_COMBINATIONS m USING (select tt_comb_id, res_id from tt_resource_lists where res_id in (select Id from groups)) ON (m.id = tt_comb_id) WHEN MATCHED THEN UPDATE SET gro_id = res_id;
--MERGE INTO TT_COMBINATIONS m USING (select tt_comb_id, res_id from tt_resource_lists where res_id in (select Id from subjects)) ON (m.id = tt_comb_id) WHEN MATCHED THEN UPDATE SET sub_id = res_id;
--MERGE INTO TT_COMBINATIONS m USING (select tt_comb_id, res_id from tt_resource_lists where res_id in (select Id from forms)) ON (m.id = tt_comb_id) WHEN MATCHED THEN UPDATE SET for_id = res_id;
--MERGE INTO TT_COMBINATIONS m USING (select tt_comb_id, res_id from tt_resource_lists where res_id in (select Id from periods)) ON (m.id = tt_comb_id) WHEN MATCHED THEN UPDATE SET per_id = res_id;
--commit;

create or replace package tt_planner is 
 
   /***************************************************************************************************************************** 
   |* Public api to create available combinations and check if there available combination exists 
   |  Do not change database manually. instead of this, use this package. 
   |  TT is a shorcut for time table.  
   | 
   |   Data model 
   |    
   |      TT_RESCAT_COMBINATIONS   
   |       -< TT_COMBINATIONS                 [RESCAT_COMB_ID] NULLABLE:N CNAME:TT_COMBINATIONS_FK1 
   |           -< TT_INCLUSIONS               [TT_COMB_ID]     NULLABLE:N CNAME:TT_INCLUSIONS_FK1 
   |           -< TT_RESOURCE_LISTS           [TT_COMB_ID]     NULLABLE:N CNAME:TT_RESOURCE_LISTS_FK1 
   |           -< TT_CLA                      [TT_COMB_ID]     NULLABLE:N CNAME:TT_CLA_FK2 
   |               >- CLASSES                 [CLA_ID]         NULLABLE:N CNAME:TT_CLA_FK1 
   |       -< TT_PLA                          [RESCAT_COMB_ID] NULLABLE:N CNAME:TT_PLA_FK2 
   |           >- PLANNERS                    [PLA_ID]         NULLABLE:N CNAME:TT_PLA_FK1 
   |       -< TT_RESCAT_COMBINATIONS_DTL      [RESCAT_COMB_ID] NULLABLE:N CNAME:TT_RESCAT_COMBINATIONS_DTL_FK1 
   |           >- RESOURCE_CATEGORIES         [RESCAT_ID]      NULLABLE:N CNAME:TT_RESCAT_COMBINATIONS_DTL_FK2 
   |       
   |  Summary 
   |    function  put_combination - Adds/updates combination and returns combination id 
   |    procedure put_combination - Same as function, does not returns combination id (for your convienence)  
   |   
   |    function verify           - Checks whether combination exists, populates result table tt_check_results 
   |    procedure verify        - Same as function, does not returns status (for yout convienence) 
   | 
   |    get_review_sql            - Gets sql to review combinations in user frendly way. sql shows combinations according do passed resources and resource categories only 
   | 
   |***************************************************************************************************************************** 
   | History 
   | 2011.08.07 Maciej Szymczak created  
   | 2013.11.03 bugfixing   
   | 2022.01.09 changes: get_filter   
   | 2022.01.10 changes: recalc_combination122   
   \-----------------------------------------------------------------------------------------------------------------------------*/ 

g_form      number := -2; 
g_subject   number := -3; 
g_lecturer  number := -4; 
g_group     number := -5; 
g_planner   number := -6; 
g_period    number := -7; 
g_date_hour number := -8; 


---------------------------------------------------------------------------------------------------------------------------------------------- 
/* 
function         : put_combination 
description      : inserts or updates combination.  
Impact on tables : tt_combinations, tt_inclusions, tt_resource_lists 
used by          : TFBrowseTT_COMBINATIONS.AfterPost 
parameters       : p_res_ids           - comma separated resource list 
                   p_all_rescat_ids    - comma separated resource category list. all resources of this category are always permitted (parameter p_res_ids should not contain resources of this type) 
                   p_tt_comb_id        - on insert should be null 
                                         on update should be tt_combinations.id 
                   p_avail_type        - 'N' for non limit combination (any number of combinations is permitted) , 'L' for limit combination (plan table) 
                   p_avail_orig        - when p_avail_type is 'N' then left null 
                                         when p_avail_type is 'L' then original numer of classes to plan 
                   p_avail_curr        - on insert should be null 
                                         ob update this is p_avail_orig - numer of scheduled classes 
                   p_enabled           - 'Y' for combination enabled, 'N' for combination disabled ( not active ) 
                   p_sort_order        - sort order which may be used on form ( for visual effect ) 
return value     : new tt_class id 
*/ 
function put_combination ( 
  p_rescat_comb_id  number 
 ,p_res_ids         varchar2 
 ,p_all_rescat_ids  varchar2 default null 
 ,p_tt_comb_id      number   default null 
 ,p_avail_type      varchar2   
 ,p_avail_orig      number   
 ,p_avail_curr      number  
 ,p_enabled         char  
 ,p_sort_order      number 
) return number; 

---------------------------------------------------------------------------------------------------------------------------------------------- 
-- does the same as function put_combination, no result value 
procedure put_combination ( 
  p_rescat_comb_id  number 
 ,p_res_ids         varchar2 
 ,p_all_rescat_ids  varchar2 default null 
 ,p_tt_comb_id      number   default null 
 ,p_avail_type      varchar2   
 ,p_avail_orig      number   
 ,p_avail_curr      number  
 ,p_enabled         char  
 ,p_sort_order      number 
); 

---------------------------------------------------------------------------------------------------------------------------------------------- 
/* 
function         : verify 
description      : verifies whether combination is valid  
Impact on tables : no impact 
used by          : TFmain.insertClasses 
                   TFTTCheckResults.fbrowseClick ( after new combination is added) 
                   TFBrowseTT_COMBINATIONS.checkRecord ( to check, wheter this combination really must be insert )                     
parameters       : p_pla_id          - planners.id. Only tt_combinations active for this planners are validated ( table TT_PLA ) 
                   p_res_ids         - comma separated resource list  
                   p_auto_fix        - 'Y' means that missed combination will automatically added to the system configuration. When p_auto_fix=Y then function always returns N 
                   p_current_comb_id - eliminates current combination from checking. Parametr used by TFBrowseTT_COMBINATIONS.checkRecord only on update record 
                   p_no_subsets      - 'Y' means that subcombinations are not examined. parameter curently not used. 
return value     :'N' - there is a problem, not all combinations required were found. Use this sql to see details 
                        select * from tt_check_results 
                  'Y' - OK       
examples 
  declare 
   l_res varchar2(100); 
  begin 
   l_Res := planner_tt.verify ('1000117,4000403,4000401', 'Y'); 
   --raise_application_error(-20000, 'l_res=' || l_res); 
  end; 
  select id, found_tt, res_id1, rescat_id1, res_desc1, res_id2, rescat_id2, res_desc2, res_id3, rescat_id3, res_desc3, res_id4, rescat_id4, res_desc4, res_id5, rescat_id5, res_desc5, res_id6, rescat_id6, res_desc6, res_id7, rescat_id7, res_desc7, res_id8, rescat_id8, res_desc8, res_id9, rescat_id9, res_desc9, res_id10, rescat_id10, res_desc10 from tt_check_results 
*/ 
function  verify ( p_pla_id number, p_res_ids  varchar2, p_auto_fix varchar2 default 'N', p_current_comb_id number default -1, p_no_subsets varchar2 default 'N' ) return varchar2;    
procedure verify ( p_pla_id number, p_res_ids  varchar2, p_auto_fix varchar2 default 'N', p_current_comb_id number default -1, p_no_subsets varchar2 default 'N' );          


------------------------------------------------------------------------------------------------------------------------------------------------------- 
/* 
function         : get_rescat_id, get_res_desc 
description      : return resource category id and resource description for given resource id 
Impact on tables : no impact 
used by          : TFmain.BSelectCombClick 
                   UFDetails.BSelectCombClick 
                   TFBrowseTT_COMBINATIONS.BeforeEdit 
parameters       : p_res_id - resource id lecturer.id or group.id of rooms.id or planners.id or periods.id of forms.id or subjects.id 
return value     : get_rescat_id - resource category id ( resource_categories.id) 
                   get_res_desc  - name of resource 
*/ 
function get_rescat_id   (p_res_id number) return number; 
function get_res_desc    (p_res_id number, p_rescat_id number default null, p_include_res_type varchar2 default 'Y') return varchar2; 



------------------------------------------------------------------------------------------------------------------------------------------------------- 
/* 
function         : get_resource_cat_names 
description      : gets names of resource categories selected in combination type (table tt_rescat_combinations) 
Impact on tables : no impact 
used by          : module DM 
                   UFBrowseTT_COMBINATIONS.RESCAT_COMB_IDChange 
parameters       : prescat_comb_id - tt_rescat_combinations.id 
return value     : names of resource categories selected in combination type  
*/ 
function get_resource_cat_names ( prescat_comb_id number ) return varchar2; 


------------------------------------------------------------------------------------------------------------------------------------------------------- 
/* 
function         : populate_rescat_comb_dtl 
description      : gets names of resource categories selected in combination type (table tt_rescat_combinations) 
Impact on tables : tt_rescat_combinations_dtl ( insert / delete )  
used by          : TFBrowseTT_RESCAT_COMBINATIONS.AfterPost 
parameters       : prescat_comb_id - tt_rescat_combinations.id 
                   l_rescat_ids    - comma separated list of resource categories ( resource_categories.id ) 
return value     : -  
*/ 
procedure populate_rescat_comb_dtl (prescat_comb_id number, l_rescat_ids varchar2); 

------------------------------------------------------------------------------------------------------------------------------------------------------- 
/* 
function         : get_filter 
description      : gets where clause for statement: select * from tt_combinations where ... 
Impact on tables : -  
used by          : TFBrowseTT_COMBINATIONS.CustomConditions 
parameters       : p_res_ids - comma separated list od resources 
return value     : -  
*/ 
function get_filter (p_res_ids varchar2, p_include_all varchar2 default 'N') return varchar2; 

------------------------------------------------------------------------------------------------------------------------------------------------------- 
/* 
function         : set_res_limitation 
description      : gets where clause for statement: select * from <resource table> where ... 
                   limits LOV of resources to available resources only 
Impact on tables : -  
used by          : TFDetails.setResLimitation 
parameters       : p_pla_id    - planners.id. Only tt_combinations active for this planners are validated ( table TT_PLA ) 
                   p_res_ids   - comma separated list of values selected by user formaly 
                   p_rescat_id - LOV resource category id (resource_categories.id) 
return value     : no return value. Non available resource list is saved to temporary table tt_ids.  
                   Then, application limits LOV this way: <resource table>.id in (select id from <resource table> minus select  id from tt_ids) 
*/ 
procedure set_res_limitation ( p_pla_id number, p_res_ids  varchar2, p_rescat_id number); 

---------------------------------------------------------------------------------------------------------------------------------------------- 
/* 
function         : book_combination, unbook_combination 
description      : book_combination decreates current use combination ( tt_combinations.avail_cur )  
                   unbook_combination increates current use combination ( tt_combinations.avail_cur ) 
Impact on tables : tt_cla (select) 
used by          : planner_utils.insert_classes 
parameters       : p_tt_comb_id - combination to increase/decrease 
return value     : comma separated tt_cla.tt_comb_id values 
*/ 
procedure book_combination ( p_tt_comb_id number, punits number ); 
procedure unbook_combination ( p_tt_comb_id number, punits number  ); 

---------------------------------------------------------------------------------------------------------------------------------------------- 
/* 
function         : recalc_book_combination 
description      : complex function, which recalculates utilization of combination 
Impact on tables : tt_combinations (update), tt_cla(upsert) 
used by          : TFBrowseTT_COMBINATIONS.Recalculate_AVAIL_CURR 
parameters       : p_tt_comb_id - combination recualculation 
return value     : - 
*/ 
procedure recalc_book_combination ( p_tt_comb_id number );     


---------------------------------------------------------------------------------------------------------------------------------------------- 
/* 
function         : recalc_combination122 
description      : this is performance optimized version of procedure recalc_book_combination for combination 122: LEC-GRO-SUB-FOR-PER 
Impact on tables : tt_combinations (update), tt_cla(upsert) 
used by          : TFBrowseTT_COMBINATIONS.FUSOS 
parameters       : pClearMode - deletes and recreates tt_cla 
return value     : - 
*/ 
procedure recalc_combination122 (pClearMode varchar2 default 'N');

---------------------------------------------------------------------------------------------------------------------------------------------- 
/* 
function         : set_res_limitation 
description      : gets comma separated tt_cla records for given classed.id. Used by : move, copy and other group functions 
                   does not check combinations. just use old ones and thus makes operation faster 
Impact on tables : tt_cla (select) 
used by          : TFMain.modifyClass 
parameters       : p_cla_id - classes.id 
return value     : comma separated tt_cla.tt_comb_id values 
*/ 
function get_tt_cla ( p_cla_id number ) return varchar2; 





------------------------------------- internal routines ---------------------------------------------------------------------------------------------- 
/* 
function         : bitor 
description      : calculates distinct sum of wieghts of resource caterogies 
Impact on tables : -  
used by          : tt_planner.verify 
parameters       : x1..x30 numbers (this numbers are from domain: 2^0, 2^1, 2^2, 2^3, .. ) 
return value     : logical OR 
*/ 
function bitor(x1 in number 
             , x2 in number default 0 
             , x3 in number default 0 
             , x4 in number default 0 
             , x5 in number default 0 
             , x6 in number default 0 
             , x7 in number default 0 
             , x8 in number default 0 
             , x9 in number default 0 
             , x10 in number default 0 
             , x11 in number default 0 
             , x12 in number default 0 
             , x13 in number default 0 
             , x14 in number default 0 
             , x15 in number default 0 
             , x16 in number default 0 
             , x17 in number default 0 
             , x18 in number default 0 
             , x19 in number default 0 
             , x20 in number default 0 
             , x21 in number default 0 
             , x22 in number default 0 
             , x23 in number default 0 
             , x24 in number default 0 
             , x25 in number default 0 
             , x26 in number default 0 
             , x27 in number default 0 
             , x28 in number default 0 
             , x29 in number default 0 
             , x30 in number default 0 
             ) 
  return number deterministic parallel_enable; 


---------------------------------- Currently not used routines -------------------------------------------------------------------------------- 
/* 
function         : get_review_sql  
description      : gets sql to review combinations in user frendly way 
                   sql shows combinations according do passed resources and resource categories only 
                   Currently not used. 
Impact on tables : no impact 
used by          : TFTTCombinations.BRefreshClick              
parameters       : p_res_ids    - comma separated list of resources 
                   p_rescat_ids - comma separated list of resource categories 
return value     : sql statement 
*/ 
function get_review_sql (p_res_ids varchar2, p_rescat_ids varchar2) return varchar2; 

-- used by get_review_sql 
function get_rescat_desc (p_rescat_id number) return varchar2; 
function get_tt_comb_res_desc (p_tt_comb_id number, p_rescat_id number default null) return varchar2; 

end tt_planner;