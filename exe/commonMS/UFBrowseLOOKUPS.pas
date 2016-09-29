unit UFBrowseLOOKUPS;

interface

//to do                       
// -- dodaj naglowki dla   LOOKUPS_GROUP_TYPE oraz LOOKUPS_FORM_FORMULA_TYPE
// -- zszyj formaty lookups i sets
// --na sets przycisk do wprowadzania wartosci / ukrywanie sql
// --na sets przycisk do testowania sql
// --na sets okno pokazujace wartosci
// id i who powinny byc ukryte
// SRODA
// implementacja fleksów
//   okno do definiowania flexa (default value,maska wyswietlania numeru)
//   implementacja fleksa
//     okno szczegoly - wyswietlanie i wprowadzania
//     filtrowanie
//     okno siatka
// zmigruj do fleksów
// koncepcja who dla calej bazy
// opisz standardy
// zmien nazwy polskich funkcji, ujednolic do forms
// usun widoki LOOKUPS_GROUP_TYPE oraz LOOKUPS_FORM_FORMULA_TYPE

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFBrowseParent, ExtCtrls, StrHlder, Menus, DB, DBTables,
  RxQuery, ComCtrls, Grids, DBGrids, RXDBCtrl, StdCtrls, Buttons, ToolEdit,
  RxLookup, DBCtrls, Mask, ImgList, ADODB, OleServer, ExcelXP;

type
  TFBrowseLOOKUPS = class(TFBrowseParent)
    ID: TDBEdit;
    LabelID: TLabel;
    LOOKUP_TYPE: TDBEdit;
    LabelLOOKUP_TYPE: TLabel;
    CODE: TDBEdit;
    LabelCODE: TLabel;
    MEANING: TDBEdit;
    LabelMEANING: TLabel;
    DESCRIPTION: TDBMemo;
    LabelDESCRIPTION: TLabel;
    LabelENABLED: TLabel;
    BSelectVALUE_SET_ID: TBitBtn;
    DSVALUE_SETS: TDataSource;
    WHO_CREATION_DATE: TDBDateEdit;
    LabelWHO_CREATION_DATE: TLabel;
    WHO_LAST_UPDATE_DATE: TDBDateEdit;
    LabelWHO_LAST_UPDATE_DATE: TLabel;
    WHO_CREATED_BY: TDBEdit;
    LabelWHO_CREATED_BY: TLabel;
    WHO_LAST_UPDATED_BY: TDBEdit;
    LabelWHO_LAST_UPDATED_BY: TLabel;
    WHO_LAST_UPDATE_LOGIN: TDBEdit;
    LabelWHO_LAST_UPDATE_LOGIN: TLabel;
    ENABLED: TDBCheckBox;
    VALUE_SET_ID: TDBEdit;
    Label5: TLabel;
    CON_value_set_ID: TEdit;
    CON_value_set_ID_VALUE: TEdit;
    BSelectValueSet: TBitBtn;
    BClearValueSet: TBitBtn;
    LVALUE_SETS: TADOQuery;
    procedure FormCreate(Sender: TObject);
    procedure BSelectVALUE_SET_IDClick(Sender: TObject);
    procedure BSelectValueSetClick(Sender: TObject);
    procedure BClearValueSetClick(Sender: TObject);
    procedure CON_value_set_ID_VALUEDblClick(Sender: TObject);
    procedure CON_value_set_IDChange(Sender: TObject);
  private
    { Private declarations }
  public
    Function  CheckRecord : Boolean; override;
    Procedure DefaultValues; override;
    procedure BeforeEdit;   override;
    Procedure CustomConditions; override;
  end;

var
  FBrowseLOOKUPS: TFBrowseLOOKUPS;

implementation

{$R *.dfm}

uses DM, UUtilityParent, AutoCreate, ufLookupWindow;



Function  TFBrowseLOOKUPS.CheckRecord : Boolean;
Begin
  Result := CheckValid.ReducRestrictEmpty(Self, [LOOKUP_TYPE, CODE, MEANING]);
End;

Procedure TFBrowseLOOKUPS.DefaultValues;
Begin
 Query['ID']      := DModule.SingleValue('SELECT lookups_seq.nextval FROM DUAL');
 Query['ENABLED'] := 'Y';
 if CON_value_set_ID.Text <> '' then begin
   Query['VALUE_SET_ID'] := CON_value_set_ID.Text;
   Query['LOOKUP_TYPE'] := CON_value_set_ID_VALUE.Text;
 end;
 //
 Query['WHO_CREATION_DATE']     := DModule.SingleValue('SELECT TRUNC(SYSDATE) FROM DUAL');
 Query['WHO_CREATED_BY']        := UutilityParent.User;
 Query['WHO_LAST_UPDATE_DATE']  := DModule.SingleValue('SELECT TRUNC(SYSDATE) FROM DUAL');
 Query['WHO_LAST_UPDATED_BY']   := UutilityParent.User;
 Query['WHO_LAST_UPDATE_LOGIN'] := DModule.SingleValue('select userenv(''sessionid'') from dual');
End;

procedure TFBrowseLOOKUPS.BeforeEdit;
begin
 inherited;
 Query['WHO_LAST_UPDATE_DATE']  := DModule.SingleValue('SELECT TRUNC(SYSDATE) FROM DUAL');
 Query['WHO_LAST_UPDATED_BY']   := UutilityParent.User;
 Query['WHO_LAST_UPDATE_LOGIN'] := DModule.SingleValue('select userenv(''sessionid'') from dual');
end;



procedure TFBrowseLOOKUPS.FormCreate(Sender: TObject);
begin
  inherited;
  SetNotUpdatable([ CODE], [labelCODE]);
end;

procedure TFBrowseLOOKUPS.BSelectVALUE_SET_IDClick(Sender: TObject);
Var ID : ShortString;
begin
  inherited;
  ID := value_set_id.text;
  If AutoCreate.VALUE_SETSShowModalAsSelect(ID) = mrOK Then Begin
    Query.FieldByName('value_set_id').AsString := ID;
    Query['LOOKUP_TYPE'] := DModule.SingleValue('select NAME from VALUE_SETS where id='+id);
  End;
end;

procedure TFBrowseLOOKUPS.BSelectValueSetClick(Sender: TObject);
Var ID : ShortString;
begin
  ID := CON_value_set_ID.Text;
  If LookupWindow( DModule.ADOConnection, 'VALUE_SETS','','NAME','NAZWA','NAME','SET_TYPE=''LOOKUP''','',ID) = mrOK Then CON_value_set_ID.Text := ID;
end;

procedure TFBrowseLOOKUPS.BClearValueSetClick(Sender: TObject);
begin
  inherited;
  CON_value_set_ID.Text := '';
end;

procedure TFBrowseLOOKUPS.CON_value_set_ID_VALUEDblClick(Sender: TObject);
begin
  inherited;
  BSelectValueSetClick(nil);
end;

procedure TFBrowseLOOKUPS.CON_value_set_IDChange(Sender: TObject);
begin
  If Trim(CON_value_set_ID.TEXT) <> '' Then CON_value_set_ID_VALUE.Text := DMOdule.SingleValue('SELECT NAME FROM VALUE_SETS WHERE ID='+CON_value_set_ID.TEXT)
                                       Else CON_value_set_ID_VALUE.Text := '';
  BRefreshClick(nil);
end;

Procedure TFBrowseLOOKUPS.CustomConditions;
Begin
 If CON_value_set_ID.Text = '' Then DM.macros.setMacro(query, 'CON_value_set_ID', '0=0')
                               Else DM.macros.setMacro(query, 'CON_value_set_ID', 'lookup_type = '''+CON_value_set_ID_value.text+'''');

End;


end.
