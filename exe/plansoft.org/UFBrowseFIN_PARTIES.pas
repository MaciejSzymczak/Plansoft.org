unit UFBrowseFIN_PARTIES;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFBrowseParent, DB, ADODB, ImgList, ExtCtrls, StrHlder, Menus,
  ToolEdit, RXDBCtrl, Mask, DBCtrls, StdCtrls, ComCtrls, Grids, DBGrids,
  Buttons, OleServer, ExcelXP;

type
  TFBrowseFIN_PARTIES = class(TFBrowseParent)
    ID: TDBEdit;
    LabelID: TLabel;
    CUSTOMER_NAME_LINE1: TDBEdit;
    LabelCUSTOMER_NAME_LINE1: TLabel;
    CUSTOMER_NAME_LINE2: TDBEdit;
    LabelCUSTOMER_NAME_LINE2: TLabel;
    TAX_NUM: TDBEdit;
    LabelTAX_NUM: TLabel;
    STAT_NUM: TDBEdit;
    LabelSTAT_NUM: TLabel;
    STR_KEY: TDBEdit;
    LabelSTR_KEY: TLabel;
    BANK_ACCOUNT_NUM: TDBEdit;
    LabelBANK_ACCOUNT_NUM: TLabel;
    FEEDER_SYSTEM_REF: TDBEdit;
    LabelFEEDER_SYSTEM_REF: TLabel;
    AUX_DESC1: TDBEdit;
    LabelAUX_DESC1: TLabel;
    AUX_DESC2: TDBEdit;
    LabelAUX_DESC2: TLabel;
    AddressBox: TGroupBox;
    LabelADDRESS_STREET: TLabel;
    ADDRESS_STREET: TDBEdit;
    ADDRESS_STREET_NUM: TDBEdit;
    ADDRESS_BUILDING_NUM: TDBEdit;
    LabelADDRESS_POSTAL_CODE: TLabel;
    ADDRESS_POSTAL_CODE: TDBEdit;
    LabelADDRES_PLACE: TLabel;
    ADDRES_PLACE: TDBEdit;
    LabelADDRESS_COUNTRY: TLabel;
    ADDRESS_COUNTRY: TDBEdit;
    con_label: TLabel;
    CON_FEEDER_SYSTEM_REF: TEdit;
    con_clear: TBitBtn;
    procedure con_clearClick(Sender: TObject);
    procedure CON_FEEDER_SYSTEM_REFChange(Sender: TObject);
    procedure BUpdChild1Click(Sender: TObject);
    procedure BUpdChild2Click(Sender: TObject);
  private
    { Private declarations }
  public
    Function  CheckRecord : Boolean; override;
    Procedure DefaultValues; override;
    Procedure CustomConditions;      override;
  end;

var
  FBrowseFIN_PARTIES: TFBrowseFIN_PARTIES;

implementation

uses DM, UUtilityParent, AutoCreate;

{$R *.dfm}

Function  TFBrowseFIN_PARTIES.CheckRecord : Boolean;
Begin
  Result := CheckValid.ReducRestrictEmpty(Self, [CUSTOMER_NAME_LINE1, TAX_NUM, BANK_ACCOUNT_NUM, ADDRES_PLACE]);
End;

Procedure TFBrowseFIN_PARTIES.DefaultValues;
Begin
 Query['ID'] := DModule.SingleValue('select main_seq.nextval from dual');
 Query.FieldByName('FEEDER_SYSTEM_REF').AsString := CON_FEEDER_SYSTEM_REF.Text;
End;

Procedure TFBrowseFIN_PARTIES.CustomConditions;
Begin
 If CON_FEEDER_SYSTEM_REF.Text = ''
     Then DM.macros.setMacro(query, 'CON_FEEDER_SYSTEM_REF', '0=0')
     Else DM.macros.setMacro(query, 'CON_FEEDER_SYSTEM_REF', 'FEEDER_SYSTEM_REF LIKE '''+CON_FEEDER_SYSTEM_REF.Text+'%''');
End;

procedure TFBrowseFIN_PARTIES.con_clearClick(Sender: TObject);
begin
  CON_FEEDER_SYSTEM_REF.Text := '';
end;

procedure TFBrowseFIN_PARTIES.CON_FEEDER_SYSTEM_REFChange(Sender: TObject);
begin
  BRefreshClick(nil);
end;

procedure TFBrowseFIN_PARTIES.BUpdChild1Click(Sender: TObject);
begin
  AutoCreate.FIN_DOCSShowModalAsBrowser( '', Query['ID'], '');
end;

procedure TFBrowseFIN_PARTIES.BUpdChild2Click(Sender: TObject);
begin
  AutoCreate.FIN_DOCSShowModalAsBrowser( '', '', Query['ID'] );
end;

end.
