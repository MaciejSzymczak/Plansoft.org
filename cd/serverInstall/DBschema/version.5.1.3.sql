-- 2012.10.27: 
--LOCAL: YES (but automatic update)
--LOCALPRIV: YES
--ININSTALL: NO (but automatic update)
--WAT  : NO (but automatic update)
--WROC : NO (but automatic update)
--PWWA : NO (but automatic update)
--SOPOT: NO (but automatic update)

CREATE TABLE GRIDS
(
  ID                NUMBER(10) primary key,
  NO                number,
  CAPTION           VARCHAR2(50),
  HOUR_FROM         char(5),
  HOUR_TO           char(5),
  DURATION          NUMBER,  
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
  CREATED_BY        VARCHAR2(30 BYTE)           DEFAULT USER,
  CREATION_DATE     DATE                        DEFAULT sysdate               NOT NULL,
  LAST_UPDATE_DATE  DATE                        DEFAULT sysdate               NOT NULL,
  LAST_UPDATED_BY   VARCHAR2(30 BYTE)           DEFAULT user                  NOT NULL
);

CREATE PUBLIC SYNONYM GRIDS FOR GRIDS;
GRANT SELECT ON  GRIDS TO PLANNERREPORTS;
