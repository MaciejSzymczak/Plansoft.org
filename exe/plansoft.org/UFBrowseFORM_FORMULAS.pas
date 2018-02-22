unit UFBrowseFORM_FORMULAS;


interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFBrowseParent, ExtCtrls, StrHlder, Menus, DB, DBTables,
  RxQuery, ComCtrls, Grids, DBGrids, RXDBCtrl, StdCtrls, Buttons, ToolEdit,
  Mask, DBCtrls, ImgList, ADODB, OleServer, ExcelXP;

type
  TFBrowseFORM_FORMULAS = class(TFBrowseParent)
    ID: TDBEdit;
    LabelID: TLabel;
    FOR_ID: TDBEdit;
    LabelFOR_ID: TLabel;
    ORGUNI_ID: TDBEdit;
    LabelORGUNI_ID: TLabel;
    FORMULA_TYPE: TDBEdit;
    LabelFORMULA_TYPE: TLabel;
    FORMULA: TDBEdit;
    LabelFORMULA: TLabel;
    DATE_FROM: TDBDateEdit;
    LabelDATE_FROM: TLabel;
    DATE_TO: TDBDateEdit;
    LabelDATE_TO: TLabel;
    DESC1: TDBEdit;
    LabelDESC1: TLabel;
    DESC2: TDBEdit;
    LabelDESC2: TLabel;
    Label5: TLabel;
    CON_ORGUNI_ID: TEdit;
    CON_ORGUNI_ID_VALUE: TEdit;
    BitBtn3: TBitBtn;
    BitBtn6: TBitBtn;
    ORGUNI_ID_VALUE: TEdit;
    BSelectORGUNI_ID: TBitBtn;
    BClearORGUNI_ID: TBitBtn;
    FOR_ID_VALUE: TEdit;
    BSelectFOR_ID: TBitBtn;
    BClearFOR_ID: TBitBtn;
    Label2: TLabel;
    CON_FOR_ID: TEdit;
    CON_FOR_ID_VALUE: TEdit;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    FORMULA_TYPE_VALUE: TEdit;
    BSELECTFORMULA_TYPE: TBitBtn;
    BCLEARFORMULA_TYPE: TBitBtn;
    Label3: TLabel;
    CON_FORMULA_TYPE: TEdit;
    CON_FORMULA_TYPE_VALUE: TEdit;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    Memo1: TMemo;
    BitBtn7: TBitBtn;
    BitBtn8: TBitBtn;
    BitBtn9: TBitBtn;
    BitBtn10: TBitBtn;
    procedure CON_ORGUNI_IDChange(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn6Click(Sender: TObject);
    procedure CON_ORGUNI_ID_VALUEDblClick(Sender: TObject);
    procedure ORGUNI_IDChange(Sender: TObject);
    procedure BSelectORGUNI_IDClick(Sender: TObject);
    procedure BClearORGUNI_IDClick(Sender: TObject);
    procedure ORGUNI_ID_VALUEDblClick(Sender: TObject);
    procedure FOR_IDChange(Sender: TObject);
    procedure BSelectFOR_IDClick(Sender: TObject);
    procedure BClearFOR_IDClick(Sender: TObject);
    procedure CON_FOR_IDChange(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure CON_FOR_ID_VALUEDblClick(Sender: TObject);
    procedure FORMULA_TYPEChange(Sender: TObject);
    procedure BSELECTFORMULA_TYPEClick(Sender: TObject);
    procedure BCLEARFORMULA_TYPEClick(Sender: TObject);
    procedure FORMULA_TYPE_VALUEDblClick(Sender: TObject);
    procedure CON_FORMULA_TYPEChange(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure BitBtn8Click(Sender: TObject);
    procedure BitBtn9Click(Sender: TObject);
    procedure BitBtn10Click(Sender: TObject);
    procedure BitBtn7Click(Sender: TObject);
  private
    { Private declarations }
  public
    Function  CheckRecord : Boolean; override;
    Procedure DefaultValues; override;
    Procedure CustomConditions; override;
    function checkFormula : string;
  end;

var
  FBrowseFORM_FORMULAS: TFBrowseFORM_FORMULAS;

implementation

{$R *.dfm}

uses DM, UUtilityParent, UFMain, AutoCreate, ufLookupWindow;

Function  TFBrowseFORM_FORMULAS.CheckRecord : Boolean;
var alert : string;
Begin

 With UUtilityParent.CheckValid Do Begin //Metody: Init, addError(S : String), AddWarning(S : String),   ShowMessage : Boolean = czy wszystko jest ok ?
   Init(Self);
   RestrictEmpty([FOR_ID, ORGUNI_ID, FORMULA_TYPE, FORMULA, DATE_FROM ]);
   alert := checkFormula;
   If not isBlank(alert) Then addError(alert);
   Result := ShowMessage;
 End;
End;

Procedure TFBrowseFORM_FORMULAS.DefaultValues;
Begin
 Query['ID'] := DModule.SingleValue('SELECT FORFOR_SEQ.NEXTVAL FROM DUAL');
 if CON_ORGUNI_ID.Text    <> '' then Query['ORGUNI_ID']    := CON_ORGUNI_ID.Text;
 if CON_FOR_ID.Text       <> '' then Query['FOR_ID']       := CON_FOR_ID.Text;
 if CON_FORMULA_TYPE.Text <> '' then Query['FORMULA_TYPE'] := CON_FORMULA_TYPE.Text;
 Query['DATE_FROM'] := date();
End;

Procedure TFBrowseFORM_FORMULAS.CustomConditions;
Begin
 //Query.MacroByName('CONPERMISSIONS').AsString := getWhereClause(tableName);

 If CON_ORGUNI_ID.Text = '' Then DM.macros.setMacro(query, 'CON_ORGUNI_ID', '0=0')
                            Else DM.macros.setMacro(query, 'CON_ORGUNI_ID', 'ORGUNI_ID IN ( SELECT ID FROM ORG_UNITS WHERE STRUCT_CODE LIKE '''+dmodule.singleValue('SELECT STRUCT_CODE FROM ORG_UNITS WHERE ID = '+CON_ORGUNI_ID.Text)+'%'')');

 If CON_FOR_ID.Text = ''    Then DM.macros.setMacro(query, 'CON_FOR_ID', '0=0')
                            Else DM.macros.setMacro(query, 'CON_FOR_ID', 'FOR_ID = '+CON_FOR_ID.Text);

 If CON_FORMULA_TYPE.Text = '' Then DM.macros.setMacro(query, 'CON_FORMULA_TYPE', '0=0')
                               Else DM.macros.setMacro(query, 'CON_FORMULA_TYPE', 'FORMULA_TYPE = '''+CON_FORMULA_TYPE.Text+'''');

End;

procedure TFBrowseFORM_FORMULAS.CON_ORGUNI_IDChange(Sender: TObject);
begin
  If Trim(CON_ORGUNI_ID.TEXT) <> '' Then CON_ORGUNI_ID_VALUE.Text := DMOdule.SingleValue('SELECT NAME FROM ORG_UNITS WHERE ID='+CON_ORGUNI_ID.TEXT)
                                    Else CON_ORGUNI_ID_VALUE.Text := '';
  BRefreshClick(nil);
end;

procedure TFBrowseFORM_FORMULAS.BitBtn3Click(Sender: TObject);
Var ID : ShortString;
begin
  ID := CON_ORGUNI_ID.Text;
  If LookupWindow(DModule.ADOConnection, 'ORG_UNITS','','SUBSTR(NAME ||'' (''||STRUCT_CODE||'')'',1,63)','NAZWA I KOD STRUKTURY','NAME','0=0','',ID) = mrOK Then CON_ORGUNI_ID.Text := ID;
end;

procedure TFBrowseFORM_FORMULAS.BitBtn6Click(Sender: TObject);
begin
  CON_ORGUNI_ID.Text := '';
end;

procedure TFBrowseFORM_FORMULAS.CON_ORGUNI_ID_VALUEDblClick(
  Sender: TObject);
begin
  inherited;
  BitBtn3Click( nil );
end;

procedure TFBrowseFORM_FORMULAS.ORGUNI_IDChange(Sender: TObject);
begin
  inherited;
    DModule.RefreshLookupEdit(Self, TControl(Sender).Name,'NAME','ORG_UNITS','');
end;

procedure TFBrowseFORM_FORMULAS.BSelectORGUNI_IDClick(Sender: TObject);
Var ID : ShortString;
begin
  ID := ORGUNI_ID.Text;
  //If AutoCreate.ORG_UNITSShowModalAsSelect(ID) = mrOK Then Query.FieldByName('ORGUNI_ID').AsString := ID;
  If LookupWindow(DModule.ADOConnection, 'ORG_UNITS','','SUBSTR(NAME ||'' (''||STRUCT_CODE||'')'',1,63)','NAZWA I KOD STRUKTURY','NAME','0=0','',ID) = mrOK Then Query.FieldByName('ORGUNI_ID').AsString := ID;
end;

procedure TFBrowseFORM_FORMULAS.BClearORGUNI_IDClick(Sender: TObject);
begin
  Query.FieldByName('ORGUNI_ID').Clear;
end;

procedure TFBrowseFORM_FORMULAS.ORGUNI_ID_VALUEDblClick(Sender: TObject);
begin
  inherited;
  BSelectORGUNI_IDClick( nil );
end;

procedure TFBrowseFORM_FORMULAS.FOR_IDChange(Sender: TObject);
begin
  inherited;
    DModule.RefreshLookupEdit(Self, TControl(Sender).Name,'NAME','FORMS','');
end;

procedure TFBrowseFORM_FORMULAS.BSelectFOR_IDClick(Sender: TObject);
Var ID : ShortString;
begin
  ID := FOR_ID.Text;
  //If AutoCreate.ORG_UNITSShowModalAsSelect(ID) = mrOK Then Query.FieldByName('ORGUNI_ID').AsString := ID;
  If LookupWindow(DModule.ADOConnection, 'FORMS','','SUBSTR(NAME,1,250)','NAZWA','NAME','0=0','',ID) = mrOK Then Query.FieldByName('FOR_ID').AsString := ID;
end;

procedure TFBrowseFORM_FORMULAS.BClearFOR_IDClick(Sender: TObject);
begin
  inherited;
  Query.FieldByName('FOR_ID').Clear;
end;

procedure TFBrowseFORM_FORMULAS.CON_FOR_IDChange(Sender: TObject);
begin
  If Trim(CON_FOR_ID.TEXT) <> '' Then CON_FOR_ID_VALUE.Text := DMOdule.SingleValue('SELECT NAME FROM FORMS WHERE ID='+CON_FOR_ID.TEXT)
                                 Else CON_FOR_ID_VALUE.Text := '';
  BRefreshClick(nil);
end;

procedure TFBrowseFORM_FORMULAS.BitBtn1Click(Sender: TObject);
Var ID : ShortString;
begin
  ID := CON_FOR_ID.Text;
  If LookupWindow(DModule.ADOConnection, 'FORMS','','SUBSTR(NAME,1,250)','NAZWA','NAME','0=0','',ID) = mrOK Then CON_FOR_ID.Text := ID;
end;

procedure TFBrowseFORM_FORMULAS.BitBtn2Click(Sender: TObject);
begin
  CON_FOR_ID.Text := '';
end;

procedure TFBrowseFORM_FORMULAS.CON_FOR_ID_VALUEDblClick(Sender: TObject);
begin
  inherited;
  BitBtn1Click( nil );
end;

procedure TFBrowseFORM_FORMULAS.FORMULA_TYPEChange(Sender: TObject);
begin
  inherited;
  DModule.RefreshLookupEdit(Self, TControl(Sender).Name,'NAME','LOOKUPS_FORM_FORMULA_TYPE','CODE='''+TDBEdit(Sender).TEXT+'''');
end;

procedure TFBrowseFORM_FORMULAS.BSELECTFORMULA_TYPEClick(Sender: TObject);
Var ID : ShortString;
begin
  ID := FORMULA_TYPE.Text;
  If LookupWindow(DModule.ADOConnection, 'LOOKUPS_FORM_FORMULA_TYPE','CODE','NAME','TYP FORMU£Y','NAME','0=0','',ID) = mrOK Then Query.FieldByName('FORMULA_TYPE').AsString := ID;
end;

procedure TFBrowseFORM_FORMULAS.BCLEARFORMULA_TYPEClick(Sender: TObject);
begin
  inherited;
  Query.FieldByName('FORMULA_TYPE').Clear;
end;

procedure TFBrowseFORM_FORMULAS.FORMULA_TYPE_VALUEDblClick(
  Sender: TObject);
begin
  inherited;
  BSELECTFORMULA_TYPEClick( nil );
end;

procedure TFBrowseFORM_FORMULAS.CON_FORMULA_TYPEChange(Sender: TObject);
begin
  If Trim(CON_FORMULA_TYPE.TEXT) <> '' Then CON_FORMULA_TYPE_VALUE.Text := DMOdule.SingleValue('SELECT NAME FROM LOOKUPS_FORM_FORMULA_TYPE WHERE CODE='''+CON_FORMULA_TYPE.TEXT+'''')
                                       Else CON_FORMULA_TYPE_VALUE.Text := '';
  BRefreshClick(nil);
end;

procedure TFBrowseFORM_FORMULAS.BitBtn4Click(Sender: TObject);
Var ID : ShortString;
begin
  ID := CON_FORMULA_TYPE.Text;
  If LookupWindow(DModule.ADOConnection, 'LOOKUPS_FORM_FORMULA_TYPE','CODE','SUBSTR(NAME,1,250)','NAZWA','NAME','0=0','',ID) = mrOK Then CON_FORMULA_TYPE.Text := ID;
end;

procedure TFBrowseFORM_FORMULAS.BitBtn5Click(Sender: TObject);
begin
  CON_FORMULA_TYPE.Text := '';
end;

procedure TFBrowseFORM_FORMULAS.BitBtn8Click(Sender: TObject);
begin
  Query['FORMULA'] := FORMULA.Text + 'Zaogr¹glij(  )';
end;

procedure TFBrowseFORM_FORMULAS.BitBtn9Click(Sender: TObject);
begin
  Query['FORMULA'] := FORMULA.Text + 'Liczba_godz';
end;

procedure TFBrowseFORM_FORMULAS.BitBtn10Click(Sender: TObject);
begin
  Query['FORMULA'] := FORMULA.Text + 'Liczba_studentów';
end;

function TFBrowseFORM_FORMULAS.checkFormula : string;
var vformula : string;
begin
  vformula := FORMULA.Text;
  vformula := replace (vformula, 'Zaogr¹glij','Round');
  vformula := replace (vformula, 'Liczba_godz','1');
  vformula := replace (vformula, 'Liczba_studentów','1');
  try
   dmodule.singleValue('select '+vformula+' from dual');
   result := '';
  except
  on E:exception do result :=  'Formu³a '+vformula+ ' zawiera b³êdy.'+cr+' Komuniat o b³êdzie: ' + E.Message;
 End;
end;

procedure TFBrowseFORM_FORMULAS.BitBtn7Click(Sender: TObject);
var alert : string;
begin
  alert := checkFormula;
  if isBlank(alert) then info ('Formu³a nie zawiera b³êdów')
                       else Serror( alert );
end;


end.
