unit UFBrowseFLEX_COL_USAGE;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFBrowseParent, ExtCtrls, StrHlder, Menus, DB, DBTables,
  RxQuery, StdCtrls, ToolEdit, RXDBCtrl, Mask, DBCtrls, ComCtrls, Grids,
  DBGrids, Buttons, ADODB, ImgList, OleServer, ExcelXP;

type
  TFBrowseFLEX_COL_USAGE = class(TFBrowseParent)
    ID: TDBEdit;
    LabelID: TLabel;
    FORM_NAME: TDBEdit;
    LabelFORM_NAME: TLabel;
    CONTEXT_NAME: TDBEdit;
    LabelCONTEXT_NAME: TLabel;
    ATTR_NAME: TDBEdit;
    LabelATTR_NAME: TLabel;
    CUSTOM_NAME: TDBEdit;
    LabelCUSTOM_NAME: TLabel;
    CAPTION: TDBEdit;
    LabelCAPTION: TLabel;
    WIDTH: TDBEdit;
    LabelWIDTH: TLabel;
    VALUE_SET_ID: TDBEdit;
    LabelVALUE_SET_ID: TLabel;
    SQL_DEFAULT_VALUE: TDBEdit;
    LabelSQL_DEFAULT_VALUE: TLabel;
    SQL_CHECK_PROCEDURE: TDBEdit;
    LabelSQL_CHECK_PROCEDURE: TLabel;
    SQL_CHECK_MESSAGE: TDBEdit;
    LabelSQL_CHECK_MESSAGE: TLabel;
    GroupBox1: TGroupBox;
    LabelLABEL_POS_X: TLabel;
    LABEL_POS_X: TDBEdit;
    LABEL_POS_Y: TDBEdit;
    FIELD_POS_Y: TDBEdit;
    LabelFIELD_POS_X: TLabel;
    FIELD_POS_X: TDBEdit;
    REQUIRED: TDBCheckBox;
    SHOW_IN_LIST: TDBCheckBox;
    SHOW_IN_ORDER_BY: TDBCheckBox;
    SYSTEM_FLAG: TDBCheckBox;
    SHOW_IN_WHERE: TDBCheckBox;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
   Procedure BeforeEdit;                    override; // CurrOperation mo¿e przyjmowaæ wartoœci {AINSERT, ACOPY, AEDIT}
   Function  CanInsert    : Boolean;        override;
   Function  CanDelete    : Boolean;        override;
   Procedure AddClick;                      override;
   Procedure CopyClick;	            	      override;

   Procedure DeleteAllClick;                override;
  end;

var
  FBrowseFLEX_COL_USAGE: TFBrowseFLEX_COL_USAGE;

implementation

{$R *.dfm}

uses uutilityParent;

{
Procedure TFBrowseFLEX_COL_USAGE.DefaultValues;
Begin
 Query.FieldByName('DOS_ID').AsString := CONDOSTAWCY.Value;
 Query['ID'] := DModule.SingleValue('SELECT flex_col_usage_seq.NEXTVAL FROM DUAL');
End;
}

Function  TFBrowseFLEX_COL_USAGE.CanInsert    : Boolean;
begin
 result := false;
end;

Function  TFBrowseFLEX_COL_USAGE.CanDelete    : Boolean;
begin
 if not Query.Active then exit;
 if Query.FieldByName('SYSTEM_FLAG').AsString = '+' Then Begin
  Info('Nie mo¿na usuwaæ pól systemowych. Ten atrybut jest niebêdny do funkcjonowania wielu funkcji programu i nie mo¿e zostaæ usuniêty.');
  Result := False;
 End
 Else Result := True;
end;

Procedure TFBrowseFLEX_COL_USAGE.AddClick;
begin
 info ('Za pomoc¹ tego formularza nie mo¿na dodawaæ atrybutów. Dodaj atrybut na formularzu, którego on dotyczy, np. na formularzu zasoby');
end;

Procedure TFBrowseFLEX_COL_USAGE.CopyClick;
begin
 info ('Ta funkcja na tym formularzu jest nieaktywna');
end;


Procedure TFBrowseFLEX_COL_USAGE.DeleteAllClick;
begin
 info ('Ta funkcja na tym formularzu jest nieaktywna');
end;

Procedure TFBrowseFLEX_COL_USAGE.BeforeEdit;
begin
 SYSTEM_FLAG.ReadOnly := true;
 if CurrOperation in [AInsert,ACopy] then
  CONTEXT_NAME.ReadOnly        := SYSTEM_FLAG.Checked;
  ATTR_NAME.ReadOnly           := SYSTEM_FLAG.Checked;
  CUSTOM_NAME.ReadOnly         := SYSTEM_FLAG.Checked;
  CAPTION.ReadOnly             := SYSTEM_FLAG.Checked;
  WIDTH.ReadOnly               := SYSTEM_FLAG.Checked;
  SQL_DEFAULT_VALUE.ReadOnly   := SYSTEM_FLAG.Checked;
  SQL_CHECK_PROCEDURE.ReadOnly := SYSTEM_FLAG.Checked;
  SQL_CHECK_MESSAGE.ReadOnly   := SYSTEM_FLAG.Checked;
  SHOW_IN_LIST.ReadOnly        := SYSTEM_FLAG.Checked;
  SHOW_IN_WHERE.ReadOnly       := SYSTEM_FLAG.Checked;
  SHOW_IN_ORDER_BY.ReadOnly    := SYSTEM_FLAG.Checked;
  SYSTEM_FLAG.ReadOnly         := SYSTEM_FLAG.Checked;
  LABEL_POS_X.ReadOnly         := SYSTEM_FLAG.Checked;
  LABEL_POS_Y.ReadOnly         := SYSTEM_FLAG.Checked;
  FIELD_POS_X.ReadOnly         := SYSTEM_FLAG.Checked;
  FIELD_POS_Y.ReadOnly         := SYSTEM_FLAG.Checked;
  REQUIRED.ReadOnly            := SYSTEM_FLAG.Checked;
  if SYSTEM_FLAG.Checked then SYSTEM_FLAG.Font.Color := clRed;
  if not SYSTEM_FLAG.Checked then SYSTEM_FLAG.Font.Color := clBlack;
end;


procedure TFBrowseFLEX_COL_USAGE.FormCreate(Sender: TObject);
begin
  inherited;
  flexEnabled     := true;
end;

end.
