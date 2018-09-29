-- 2012.06.06
--LOCAL: YES
--LOCALPRIV: NO
--ININSTALL: YES
--WAT  : YES
--WROC : NO
--PWWA : YES
--SOPOT: YES



--drop table fin_lookup_values;
--drop table fin_batches;
--drop table fin_docs; 
--drop table fin_lines;
--drop table fin_parties; 

-- uoms, doc_types

create sequence fin_main_seq;

create table fin_lookup_values ( id number primary key, lookup_type varchar2(100) not null, description varchar2(100) not null, str_key varchar2(100) );

create index fin_lookup_values_i1 on fin_lookup_values (lookup_type);

create index fin_lookup_values_isk on fin_lookup_values (str_key);

insert into fin_lookup_values (id, lookup_type, description) values (fin_main_seq.nextval, 'UOM', 'Szt');
insert into fin_lookup_values (id, lookup_type, description) values (fin_main_seq.nextval, 'DOC_TYPE', 'Faktura');
insert into fin_lookup_values (id, lookup_type, description) values (fin_main_seq.nextval, 'DOC_TYPE', 'Rachunek');
insert into fin_lookup_values (id, lookup_type, description) values (fin_main_seq.nextval, 'DOC_TYPE', 'Wp³ata');
insert into fin_lookup_values (id, lookup_type, description) values (fin_main_seq.nextval, 'DOC_TYPE', 'P³atnoœæ');

insert into fin_lookup_values (id, lookup_type, description) values (fin_main_seq.nextval, 'TAX', '0%');
insert into fin_lookup_values (id, lookup_type, description) values (fin_main_seq.nextval, 'TAX', 'ZW');
insert into fin_lookup_values (id, lookup_type, description) values (fin_main_seq.nextval, 'TAX', 'NP');
insert into fin_lookup_values (id, lookup_type, description) values (fin_main_seq.nextval, 'TAX', '23%');


create table fin_batches ( id number primary key, description varchar2(100), str_key varchar2(100), feeder_system_ref varchar2(100));

create index fin_batches_isk on fin_batches (str_key);

-- ra invoices, ap invoices, payments
create table fin_docs ( id number primary key, batch_id number, party_from_id number not null, party_to_id number not null, doc_type_id number not null, num varchar2(100) not null, doc_date date not null, sales_date date, payment_status char(1) not null, str_key varchar2(100), feeder_system_ref varchar2(100));

create index fin_docs_isk on fin_docs (str_key);

create index fin_docs_i1 on fin_docs (party_from_id);
 
create index fin_docs_i2 on fin_docs (party_to_id);

create index fin_docs_i3 on fin_docs (doc_type_id);

create index fin_docs_i4 on fin_docs (batch_id);


create table fin_lines ( id number primary key, header_id number not null, description varchar2(500) not null, unit_price number not null, qty number not null, uom_id number not null, tax_id  number, net_amount number not null, gross_amount number not null, tax_amount number );

create index fin_lines_i1 on fin_lines (header_id);

create index fin_lines_i2 on fin_lines (uom_id);

create table FIN_PARTIES ( 
id number primary key, customer_name_line1 varchar2(500) not null, customer_name_line2 varchar2(500),tax_num varchar2(100) not null, stat_num varchar2(100),  
address_street  varchar2(100), address_street_num  varchar2(100), address_building_num  varchar2(100), address_postal_code  varchar2(20),  addres_place  varchar2(100), address_country varchar2(100) , str_key varchar2(100), bank_account_num varchar2(500), feeder_system_ref varchar2(100) );

create index fin_parties_isk on fin_parties (str_key);

alter table fin_lookup_values add ( aux_desc1 varchar2(200), aux_desc2 varchar2(200) );
alter table fin_batches add ( aux_desc1 varchar2(200), aux_desc2 varchar2(200) );
alter table fin_docs add ( aux_desc1 varchar2(200), aux_desc2 varchar2(200) );
alter table fin_lines add ( aux_desc1 varchar2(200), aux_desc2 varchar2(200) );
alter table fin_parties add ( aux_desc1 varchar2(200), aux_desc2 varchar2(200) );

alter table fin_parties add (
  ATTRIBS_01        VARCHAR2(240 BYTE),
  ATTRIBS_02        VARCHAR2(240 BYTE),
  ATTRIBS_03        VARCHAR2(240 BYTE),
  ATTRIBS_04        VARCHAR2(240 BYTE),
  ATTRIBS_05        VARCHAR2(240 BYTE),
  ATTRIBS_06        VARCHAR2(240 BYTE),
  ATTRIBS_07        VARCHAR2(240 BYTE),
  ATTRIBS_08        VARCHAR2(240 BYTE),
  ATTRIBS_09        VARCHAR2(240 BYTE),
  ATTRIBS_10        VARCHAR2(240 BYTE),
  ATTRIBS_11        VARCHAR2(240 BYTE),
  ATTRIBS_12        VARCHAR2(240 BYTE),
  ATTRIBS_13        VARCHAR2(240 BYTE),
  ATTRIBS_14        VARCHAR2(240 BYTE),
  ATTRIBS_15        VARCHAR2(240 BYTE),
  ATTRIBD_01        DATE,
  ATTRIBD_02        DATE,
  ATTRIBD_03        DATE,
  ATTRIBD_04        DATE,
  ATTRIBD_05        DATE,
  ATTRIBD_06        DATE,
  ATTRIBD_07        DATE,
  ATTRIBD_08        DATE,
  ATTRIBD_09        DATE,
  ATTRIBD_10        DATE,
  ATTRIBD_11        DATE,
  ATTRIBD_12        DATE,
  ATTRIBD_13        DATE,
  ATTRIBD_14        DATE,
  ATTRIBD_15        DATE,
  ATTRIBN_01        NUMBER,
  ATTRIBN_02        NUMBER,
  ATTRIBN_03        NUMBER,
  ATTRIBN_04        NUMBER,
  ATTRIBN_05        NUMBER,
  ATTRIBN_06        NUMBER,
  ATTRIBN_07        NUMBER,
  ATTRIBN_08        NUMBER,
  ATTRIBN_09        NUMBER,
  ATTRIBN_10        NUMBER,
  ATTRIBN_11        NUMBER,
  ATTRIBN_12        NUMBER,
  ATTRIBN_13        NUMBER,
  ATTRIBN_14        NUMBER,
  ATTRIBN_15        NUMBER,
  CREATION_DATE     DATE                        DEFAULT sysdate               NOT NULL,
  CREATED_BY        VARCHAR2(30 BYTE)           DEFAULT user                  NOT NULL,
  LAST_UPDATE_DATE  DATE                        DEFAULT sysdate               NOT NULL,
  LAST_UPDATED_BY   VARCHAR2(30 BYTE)           DEFAULT user                  NOT NULL
);

alter table fin_batches add (
  ATTRIBS_01        VARCHAR2(240 BYTE),
  ATTRIBS_02        VARCHAR2(240 BYTE),
  ATTRIBS_03        VARCHAR2(240 BYTE),
  ATTRIBS_04        VARCHAR2(240 BYTE),
  ATTRIBS_05        VARCHAR2(240 BYTE),
  ATTRIBS_06        VARCHAR2(240 BYTE),
  ATTRIBS_07        VARCHAR2(240 BYTE),
  ATTRIBS_08        VARCHAR2(240 BYTE),
  ATTRIBS_09        VARCHAR2(240 BYTE),
  ATTRIBS_10        VARCHAR2(240 BYTE),
  ATTRIBS_11        VARCHAR2(240 BYTE),
  ATTRIBS_12        VARCHAR2(240 BYTE),
  ATTRIBS_13        VARCHAR2(240 BYTE),
  ATTRIBS_14        VARCHAR2(240 BYTE),
  ATTRIBS_15        VARCHAR2(240 BYTE),
  ATTRIBD_01        DATE,
  ATTRIBD_02        DATE,
  ATTRIBD_03        DATE,
  ATTRIBD_04        DATE,
  ATTRIBD_05        DATE,
  ATTRIBD_06        DATE,
  ATTRIBD_07        DATE,
  ATTRIBD_08        DATE,
  ATTRIBD_09        DATE,
  ATTRIBD_10        DATE,
  ATTRIBD_11        DATE,
  ATTRIBD_12        DATE,
  ATTRIBD_13        DATE,
  ATTRIBD_14        DATE,
  ATTRIBD_15        DATE,
  ATTRIBN_01        NUMBER,
  ATTRIBN_02        NUMBER,
  ATTRIBN_03        NUMBER,
  ATTRIBN_04        NUMBER,
  ATTRIBN_05        NUMBER,
  ATTRIBN_06        NUMBER,
  ATTRIBN_07        NUMBER,
  ATTRIBN_08        NUMBER,
  ATTRIBN_09        NUMBER,
  ATTRIBN_10        NUMBER,
  ATTRIBN_11        NUMBER,
  ATTRIBN_12        NUMBER,
  ATTRIBN_13        NUMBER,
  ATTRIBN_14        NUMBER,
  ATTRIBN_15        NUMBER,
  CREATION_DATE     DATE                        DEFAULT sysdate               NOT NULL,
  CREATED_BY        VARCHAR2(30 BYTE)           DEFAULT user                  NOT NULL,
  LAST_UPDATE_DATE  DATE                        DEFAULT sysdate               NOT NULL,
  LAST_UPDATED_BY   VARCHAR2(30 BYTE)           DEFAULT user                  NOT NULL
);



alter table fin_docs add (
  ATTRIBS_01        VARCHAR2(240 BYTE),
  ATTRIBS_02        VARCHAR2(240 BYTE),
  ATTRIBS_03        VARCHAR2(240 BYTE),
  ATTRIBS_04        VARCHAR2(240 BYTE),
  ATTRIBS_05        VARCHAR2(240 BYTE),
  ATTRIBS_06        VARCHAR2(240 BYTE),
  ATTRIBS_07        VARCHAR2(240 BYTE),
  ATTRIBS_08        VARCHAR2(240 BYTE),
  ATTRIBS_09        VARCHAR2(240 BYTE),
  ATTRIBS_10        VARCHAR2(240 BYTE),
  ATTRIBS_11        VARCHAR2(240 BYTE),
  ATTRIBS_12        VARCHAR2(240 BYTE),
  ATTRIBS_13        VARCHAR2(240 BYTE),
  ATTRIBS_14        VARCHAR2(240 BYTE),
  ATTRIBS_15        VARCHAR2(240 BYTE),
  ATTRIBD_01        DATE,
  ATTRIBD_02        DATE,
  ATTRIBD_03        DATE,
  ATTRIBD_04        DATE,
  ATTRIBD_05        DATE,
  ATTRIBD_06        DATE,
  ATTRIBD_07        DATE,
  ATTRIBD_08        DATE,
  ATTRIBD_09        DATE,
  ATTRIBD_10        DATE,
  ATTRIBD_11        DATE,
  ATTRIBD_12        DATE,
  ATTRIBD_13        DATE,
  ATTRIBD_14        DATE,
  ATTRIBD_15        DATE,
  ATTRIBN_01        NUMBER,
  ATTRIBN_02        NUMBER,
  ATTRIBN_03        NUMBER,
  ATTRIBN_04        NUMBER,
  ATTRIBN_05        NUMBER,
  ATTRIBN_06        NUMBER,
  ATTRIBN_07        NUMBER,
  ATTRIBN_08        NUMBER,
  ATTRIBN_09        NUMBER,
  ATTRIBN_10        NUMBER,
  ATTRIBN_11        NUMBER,
  ATTRIBN_12        NUMBER,
  ATTRIBN_13        NUMBER,
  ATTRIBN_14        NUMBER,
  ATTRIBN_15        NUMBER,
  CREATION_DATE     DATE                        DEFAULT sysdate               NOT NULL,
  CREATED_BY        VARCHAR2(30 BYTE)           DEFAULT user                  NOT NULL,
  LAST_UPDATE_DATE  DATE                        DEFAULT sysdate               NOT NULL,
  LAST_UPDATED_BY   VARCHAR2(30 BYTE)           DEFAULT user                  NOT NULL
);



alter table fin_lines add (
  ATTRIBS_01        VARCHAR2(240 BYTE),
  ATTRIBS_02        VARCHAR2(240 BYTE),
  ATTRIBS_03        VARCHAR2(240 BYTE),
  ATTRIBS_04        VARCHAR2(240 BYTE),
  ATTRIBS_05        VARCHAR2(240 BYTE),
  ATTRIBS_06        VARCHAR2(240 BYTE),
  ATTRIBS_07        VARCHAR2(240 BYTE),
  ATTRIBS_08        VARCHAR2(240 BYTE),
  ATTRIBS_09        VARCHAR2(240 BYTE),
  ATTRIBS_10        VARCHAR2(240 BYTE),
  ATTRIBS_11        VARCHAR2(240 BYTE),
  ATTRIBS_12        VARCHAR2(240 BYTE),
  ATTRIBS_13        VARCHAR2(240 BYTE),
  ATTRIBS_14        VARCHAR2(240 BYTE),
  ATTRIBS_15        VARCHAR2(240 BYTE),
  ATTRIBD_01        DATE,
  ATTRIBD_02        DATE,
  ATTRIBD_03        DATE,
  ATTRIBD_04        DATE,
  ATTRIBD_05        DATE,
  ATTRIBD_06        DATE,
  ATTRIBD_07        DATE,
  ATTRIBD_08        DATE,
  ATTRIBD_09        DATE,
  ATTRIBD_10        DATE,
  ATTRIBD_11        DATE,
  ATTRIBD_12        DATE,
  ATTRIBD_13        DATE,
  ATTRIBD_14        DATE,
  ATTRIBD_15        DATE,
  ATTRIBN_01        NUMBER,
  ATTRIBN_02        NUMBER,
  ATTRIBN_03        NUMBER,
  ATTRIBN_04        NUMBER,
  ATTRIBN_05        NUMBER,
  ATTRIBN_06        NUMBER,
  ATTRIBN_07        NUMBER,
  ATTRIBN_08        NUMBER,
  ATTRIBN_09        NUMBER,
  ATTRIBN_10        NUMBER,
  ATTRIBN_11        NUMBER,
  ATTRIBN_12        NUMBER,
  ATTRIBN_13        NUMBER,
  ATTRIBN_14        NUMBER,
  ATTRIBN_15        NUMBER,
  CREATION_DATE     DATE                        DEFAULT sysdate               NOT NULL,
  CREATED_BY        VARCHAR2(30 BYTE)           DEFAULT user                  NOT NULL,
  LAST_UPDATE_DATE  DATE                        DEFAULT sysdate               NOT NULL,
  LAST_UPDATED_BY   VARCHAR2(30 BYTE)           DEFAULT user                  NOT NULL
);

alter table FIN_LOOKUP_VALUES add (
  ATTRIBS_01        VARCHAR2(240 BYTE),
  ATTRIBS_02        VARCHAR2(240 BYTE),
  ATTRIBS_03        VARCHAR2(240 BYTE),
  ATTRIBS_04        VARCHAR2(240 BYTE),
  ATTRIBS_05        VARCHAR2(240 BYTE),
  ATTRIBS_06        VARCHAR2(240 BYTE),
  ATTRIBS_07        VARCHAR2(240 BYTE),
  ATTRIBS_08        VARCHAR2(240 BYTE),
  ATTRIBS_09        VARCHAR2(240 BYTE),
  ATTRIBS_10        VARCHAR2(240 BYTE),
  ATTRIBS_11        VARCHAR2(240 BYTE),
  ATTRIBS_12        VARCHAR2(240 BYTE),
  ATTRIBS_13        VARCHAR2(240 BYTE),
  ATTRIBS_14        VARCHAR2(240 BYTE),
  ATTRIBS_15        VARCHAR2(240 BYTE),
  ATTRIBD_01        DATE,
  ATTRIBD_02        DATE,
  ATTRIBD_03        DATE,
  ATTRIBD_04        DATE,
  ATTRIBD_05        DATE,
  ATTRIBD_06        DATE,
  ATTRIBD_07        DATE,
  ATTRIBD_08        DATE,
  ATTRIBD_09        DATE,
  ATTRIBD_10        DATE,
  ATTRIBD_11        DATE,
  ATTRIBD_12        DATE,
  ATTRIBD_13        DATE,
  ATTRIBD_14        DATE,
  ATTRIBD_15        DATE,
  ATTRIBN_01        NUMBER,
  ATTRIBN_02        NUMBER,
  ATTRIBN_03        NUMBER,
  ATTRIBN_04        NUMBER,
  ATTRIBN_05        NUMBER,
  ATTRIBN_06        NUMBER,
  ATTRIBN_07        NUMBER,
  ATTRIBN_08        NUMBER,
  ATTRIBN_09        NUMBER,
  ATTRIBN_10        NUMBER,
  ATTRIBN_11        NUMBER,
  ATTRIBN_12        NUMBER,
  ATTRIBN_13        NUMBER,
  ATTRIBN_14        NUMBER,
  ATTRIBN_15        NUMBER,
  CREATION_DATE     DATE                        DEFAULT sysdate               NOT NULL,
  CREATED_BY        VARCHAR2(30 BYTE)           DEFAULT user                  NOT NULL,
  LAST_UPDATE_DATE  DATE                        DEFAULT sysdate               NOT NULL,
  LAST_UPDATED_BY   VARCHAR2(30 BYTE)           DEFAULT user                  NOT NULL
);


