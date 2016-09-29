CREATE SEQUENCE   "MAIN_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1481 CACHE 20 NOORDER  NOCYCLE ;


CREATE TABLE  "SRV_ACTIVITIES" 
   (	"ID" NUMBER NOT NULL ENABLE, 
	"REQUEST_ID" NUMBER NOT NULL ENABLE, 
	"CREATION_DATE" DATE, 
	"CREATED_BY" VARCHAR2(255), 
	"NOTES" VARCHAR2(4000) NOT NULL ENABLE, 
	 CONSTRAINT "SRV_ACTIVITIES_PK" PRIMARY KEY ("ID") ENABLE
   ) ;
CREATE OR REPLACE TRIGGER  "BI_SRV_ACTIVITIES" 
  before insert on "SRV_ACTIVITIES"               
  for each row  
begin   
  if :NEW."ID" is null then 
    select "MAIN_SEQ".nextval into :NEW."ID" from dual; 
  end if; 
end; 

/
ALTER TRIGGER  "BI_SRV_ACTIVITIES" ENABLE;


CREATE TABLE  "SRV_DOCUMENTS" 
   (	"ID" NUMBER, 
	"BFILE" BLOB NOT NULL ENABLE, 
	"FILE_NAME" VARCHAR2(500), 
	"MIME" VARCHAR2(500), 
	"CREATED_BY" VARCHAR2(30) DEFAULT user, 
	"LAST_UPDATED_BY" VARCHAR2(30) DEFAULT user, 
	"CREATION_DATE" DATE DEFAULT sysdate, 
	"LAST_UPDATE_DATE" DATE DEFAULT sysdate, 
	"COMMENTS" VARCHAR2(4000), 
	 PRIMARY KEY ("ID") ENABLE
   ) ;



 

CREATE TABLE  "SRV_LOOKUP_TYPES" 
   (	"ID" NUMBER, 
	"LOOKUP_TYPE" VARCHAR2(100), 
	"CREATION_DATE" DATE DEFAULT sysdate NOT NULL ENABLE, 
	"CREATED_BY" VARCHAR2(30) DEFAULT user NOT NULL ENABLE, 
	"LAST_UPDATE_DATE" DATE DEFAULT sysdate NOT NULL ENABLE, 
	"LAST_UPDATED_BY" VARCHAR2(30) DEFAULT user NOT NULL ENABLE, 
	 PRIMARY KEY ("ID") ENABLE
   ) ;


CREATE TABLE  "SRV_LOOKUP_VALUES" 
   (	"ID" NUMBER, 
	"LOOKUP_CODE" VARCHAR2(100) NOT NULL ENABLE, 
	"MEANING" VARCHAR2(100) NOT NULL ENABLE, 
	"DESCRIPTION" VARCHAR2(500), 
	"ENABLED_FLAG" CHAR(1) DEFAULT 'Y' NOT NULL ENABLE, 
	"START_DATE_ACTIVE" DATE, 
	"END_DATE_ACTIVE" DATE, 
	"CREATION_DATE" DATE DEFAULT sysdate NOT NULL ENABLE, 
	"CREATED_BY" VARCHAR2(30) DEFAULT user NOT NULL ENABLE, 
	"LAST_UPDATE_DATE" DATE DEFAULT sysdate NOT NULL ENABLE, 
	"LAST_UPDATED_BY" VARCHAR2(30) DEFAULT user NOT NULL ENABLE, 
	"LOOKUP_TYPE_ID" NUMBER, 
	"ATTRIBUTES" VARCHAR2(500), 
	"ATTRN1" NUMBER, 
	"ATTRN2" NUMBER, 
	"ATTRN3" NUMBER, 
	"ATTRN4" NUMBER, 
	"ATTRN5" NUMBER, 
	"ATTRS1" VARCHAR2(255), 
	"ATTRS2" VARCHAR2(255), 
	"ATTRS3" VARCHAR2(255), 
	"ATTRS4" VARCHAR2(255), 
	"ATTRS5" VARCHAR2(255), 
	 PRIMARY KEY ("ID") ENABLE
   ) ;ALTER TABLE  "SRV_LOOKUP_VALUES" ADD CONSTRAINT "SRV_LOOKUP_VALUES_CON" FOREIGN KEY ("LOOKUP_TYPE_ID")
	  REFERENCES  "SRV_LOOKUP_TYPES" ("ID") ENABLE;
CREATE INDEX  "SRV_LOOKUP_VALUES_I3" ON  "SRV_LOOKUP_VALUES" ("LOOKUP_TYPE_ID") 
  ;
CREATE BITMAP INDEX  "SRV_LOOKUP_VALUES_I4" ON  "SRV_LOOKUP_VALUES" ("ENABLED_FLAG") 
  ;

CREATE TABLE  "SRV_REQUESTS" 
   (	"ID" NUMBER NOT NULL ENABLE, 
	"CUSTOMER_ID" NUMBER NOT NULL ENABLE, 
	"CUSTOMER_SR_NUMBER" VARCHAR2(255), 
	"STATUS" VARCHAR2(255), 
	"AREA" VARCHAR2(255), 
	"PRIORITY" VARCHAR2(255), 
	"DEADLINE" DATE, 
	"SUBJECT" VARCHAR2(4000), 
	"COMMENTS" VARCHAR2(4000), 
	"PERFORMER" VARCHAR2(255), 
	"CREATION_DATE" DATE NOT NULL ENABLE, 
	"CREATED_BY" VARCHAR2(255) NOT NULL ENABLE, 
	"LAST_UPDATE_DATE" DATE NOT NULL ENABLE, 
	"LAST_UPDATED_BY" VARCHAR2(255) NOT NULL ENABLE, 
	 CONSTRAINT "SRV_REQUESTS_PK" PRIMARY KEY ("ID") ENABLE
   ) ;
CREATE OR REPLACE TRIGGER  "BI_SRV_REQUESTS" 
  before insert on "SRV_REQUESTS"               
  for each row  
begin   
  if :NEW."ID" is null then 
    select "MAIN_SEQ".nextval into :NEW."ID" from dual; 
  end if; 
end; 

/
ALTER TRIGGER  "BI_SRV_REQUESTS" ENABLE;

create or replace package SRV_UTILS as

-- Y = is service Employee    
function is_service return varchar2;

function lookup_meaning ( plookup_type varchar2, plookup_code varchar2 ) return varchar2; 
function localsysdate return date;
function localsysdateYYYYMMDDHH24MISS  return varchar2;

end;


create or replace package body "SRV_UTILS" is

---------------------------------------------------------------------------------------------------
function IS_SERVICE return VARCHAR2
as
begin
 if  upper( v('APP_USER') ) = 'PLANNER' then
   return 'Y';
 else
  return 'N';
 end if;
end IS_SERVICE;

---------------------------------------------------------------------------------------------------
function lookup_meaning ( plookup_type varchar2, plookup_code varchar2 ) return varchar2 is
 res varchar2(4000);
begin
  select meaning
    into res
    from srv_lookup_values
   where lookup_type_id = (select id from srv_lookup_types where lookup_type = plookup_type)
     and enabled_flag = 'Y'
     and trunc(sysdate) between nvl(start_date_active, trunc(sysdate)) and  nvl(end_date_active, trunc(sysdate))
     and lookup_code = plookup_code;
  return res;
end lookup_meaning;

---------------------------------------------------------------------------------------------------
 function localsysdate return date is
begin
 return sysdate+7/24;
end localsysdate;

---------------------------------------------------------------------------------------------------
function localsysdateYYYYMMDDHH24MISS  return varchar2 is
begin
 return to_char(localsysdate,'YYYY-MM-DD HH24:MI:SS');
end localsysdateYYYYMMDDHH24MISS;


end "SRV_UTILS";


create or replace function lookup_meaning ( plookup_type varchar2, plookup_code varchar2 ) return varchar2 is
 res varchar2(4000);
begin
  select meaning
    into res 
    from srv_lookup_values
   where lookup_type_id = (select id from srv_lookup_types where lookup_type = plookup_type)
     and enabled_flag = 'Y'
     and trunc(sysdate) between nvl(start_date_active, trunc(sysdate)) and  nvl(end_date_active, trunc(sysdate))
     and lookup_code = plookup_code; 
  return res;
end;


create or replace function localsysdateYYYYMMDDHH24MISS  return varchar2 is
begin
 return to_char(localsysdate,'YYYY-MM-DD HH24:MI:SS');
end;


create or replace function localsysdate return date is
begin
 return sysdate+7/24;
end;











