unit UFBrowseFIN_LINES;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFBrowseParent, DB, ADODB, ImgList, ExtCtrls, StrHlder, Menus,
  ToolEdit, RXDBCtrl, Mask, DBCtrls, StdCtrls, ComCtrls, Grids, DBGrids,
  Buttons, OleServer, ExcelXP;

type
  TFBrowseFIN_LINES = class(TFBrowseParent)
    ID: TDBEdit;
    LabelID: TLabel;
    HEADER_ID: TDBEdit;
    LabelHEADER_ID: TLabel;
    LabelDESCRIPTION: TLabel;
    UNIT_PRICE: TDBEdit;
    LabelUNIT_PRICE: TLabel;
    QTY: TDBEdit;
    LabelQTY: TLabel;
    UOM_ID: TDBEdit;
    LabelUOM_ID: TLabel;
    TAX_ID: TDBEdit;
    LabelTAX_ID: TLabel;
    NET_AMOUNT: TDBEdit;
    LabelNET_AMOUNT: TLabel;
    TAX_AMOUNT: TDBEdit;
    LabelTAX_AMOUNT: TLabel;
    GROSS_AMOUNT: TDBEdit;
    LabelGROSS_AMOUNT: TLabel;
    AUX_DESC1: TDBEdit;
    LabelAUX_DESC1: TLabel;
    AUX_DESC2: TDBEdit;
    LabelAUX_DESC2: TLabel;
    DESCRIPTION: TDBEdit;
    TAX_ID_VALUE: TEdit;
    BSelectTAX_ID: TBitBtn;
    BClearTAX_ID: TBitBtn;
    UOM_ID_VALUE: TEdit;
    BSelectUOM_ID: TBitBtn;
    BClearUOM_ID: TBitBtn;
    BClearHEADER_ID: TBitBtn;
    BSelectHEADER_ID: TBitBtn;
    HEADER_ID_VALUE: TEdit;
    Label4: TLabel;
    CON_HEADER_ID: TEdit;
    CON_HEADER_ID_VALUE: TEdit;
    BSelectCON_HEADER_ID: TBitBtn;
    BClearCON_HEADER_ID: TBitBtn;
    procedure HEADER_IDChange(Sender: TObject);
    procedure UOM_IDChange(Sender: TObject);
    procedure TAX_IDChange(Sender: TObject);
    procedure BClearHEADER_IDClick(Sender: TObject);
    procedure BClearUOM_IDClick(Sender: TObject);
    procedure BClearTAX_IDClick(Sender: TObject);
    procedure BSelectHEADER_IDClick(Sender: TObject);
    procedure BSelectUOM_IDClick(Sender: TObject);
    procedure BSelectTAX_IDClick(Sender: TObject);
    procedure HEADER_ID_VALUEDblClick(Sender: TObject);
    procedure UOM_ID_VALUEDblClick(Sender: TObject);
    procedure TAX_ID_VALUEDblClick(Sender: TObject);
    procedure CON_HEADER_IDChange(Sender: TObject);
    procedure BSelectCON_HEADER_IDClick(Sender: TObject);
    procedure BClearCON_HEADER_IDClick(Sender: TObject);
    procedure CON_HEADER_ID_VALUEDblClick(Sender: TObject);
    procedure QTYExit(Sender: TObject);
    procedure QueryAfterOpen(DataSet: TDataSet);
  private
    { Private declarations }
  public
    Function  CheckRecord : Boolean; override;
    Procedure DefaultValues; override;
    Procedure GetTableName;  override;
    Procedure CustomConditions;      override;
  end;

var
  FBrowseFIN_LINES: TFBrowseFIN_LINES;

implementation

uses DM, UUtilityParent, autocreate;

{$R *.dfm}

Function  TFBrowseFIN_LINES.CheckRecord : Boolean;
Begin
  Result := CheckValid.ReducRestrictEmpty(Self, [HEADER_ID, DESCRIPTION, UNIT_PRICE, QTY, UOM_ID, TAX_ID, NET_AMOUNT, TAX_AMOUNT, GROSS_AMOUNT]);
End;

Procedure TFBrowseFIN_LINES.DefaultValues;
Begin
 Query['ID'] := DModule.SingleValue('select main_seq.nextval from dual');
 Query.FieldByName('HEADER_ID').AsString := CON_HEADER_ID.Text;
End;

Procedure TFBrowseFIN_LINES.CustomConditions;
Begin
 If CON_HEADER_ID.Text = ''
     Then DM.macros.setMacro(query, 'CON_HEADER_ID', '0=0')
     Else DM.macros.setMacro(query, 'CON_HEADER_ID', 'HEADER_ID ='+CON_HEADER_ID.Text);

End;

Procedure TFBrowseFIN_LINES.GetTableName;
Begin
  Self.TableName := 'FIN_LINES';
End;

procedure TFBrowseFIN_LINES.HEADER_IDChange(Sender: TObject);
begin
  DModule.RefreshLookupEdit(Self, TControl(Sender).Name,'num || '' z dnia '' || to_char(doc_date,''YYYY-MM-DD'') ','fin_docs','');
end;

procedure TFBrowseFIN_LINES.UOM_IDChange(Sender: TObject);
begin
  DModule.RefreshLookupEdit(Self, TControl(Sender).Name,'DESCRIPTION ','fin_lookup_values','');
end;

procedure TFBrowseFIN_LINES.TAX_IDChange(Sender: TObject);
begin
  DModule.RefreshLookupEdit(Self, TControl(Sender).Name,'DESCRIPTION ','fin_lookup_values','');
end;

procedure TFBrowseFIN_LINES.BClearHEADER_IDClick(Sender: TObject);
begin
 Query.FieldByName('HEADER_ID').Clear;
end;

procedure TFBrowseFIN_LINES.BClearUOM_IDClick(Sender: TObject);
begin
 Query.FieldByName('UOM_ID').Clear;
end;

procedure TFBrowseFIN_LINES.BClearTAX_IDClick(Sender: TObject);
begin
 Query.FieldByName('TAX_ID').Clear;
end;

procedure TFBrowseFIN_LINES.BSelectHEADER_IDClick(Sender: TObject);
Var ID : ShortString;
begin
  ID := HEADER_ID.Text;
  If AutoCreate.FIN_DOCSShowModalAsSelect(ID) = mrOK Then Query.FieldByName('HEADER_ID').AsString := ID;
end;

procedure TFBrowseFIN_LINES.BSelectUOM_IDClick(Sender: TObject);
Var ID : ShortString;
begin
  ID := UOM_ID.Text;
  If AutoCreate.FIN_LOOKUP_VALUESShowModalAsSelect('UOM',ID) = mrOK Then Query.FieldByName('UOM_ID').AsString := ID;
end;

procedure TFBrowseFIN_LINES.BSelectTAX_IDClick(Sender: TObject);
Var ID : ShortString;
begin
  ID := TAX_ID.Text;
  If AutoCreate.FIN_LOOKUP_VALUESShowModalAsSelect('TAX',ID) = mrOK Then begin
    Query.FieldByName('TAX_ID').AsString := ID;
    try
      Query['TAX_AMOUNT'] :=  StrToFloat( NET_AMOUNT.Text ) * StrToFloat( searchAndReplace(TAX_ID_VALUE.Text,'%','') ) / 100;
      Query['GROSS_AMOUNT'] :=  StrToFloat( NET_AMOUNT.Text ) + StrToFloat( TAX_AMOUNT.Text );
    except
    end;
  end;
end;

procedure TFBrowseFIN_LINES.HEADER_ID_VALUEDblClick(Sender: TObject);
begin
 BSelectHEADER_IDClick(nil);
end;

procedure TFBrowseFIN_LINES.UOM_ID_VALUEDblClick(Sender: TObject);
begin
 BSelectUOM_IDClick(nil);
end;

procedure TFBrowseFIN_LINES.TAX_ID_VALUEDblClick(Sender: TObject);
begin
  BSelectTAX_IDClick(nil);
end;

procedure TFBrowseFIN_LINES.CON_HEADER_IDChange(Sender: TObject);
begin
  DModule.RefreshLookupEdit(Self, TControl(Sender).Name,'num || '' z dnia '' || to_char(doc_date,''YYYY-MM-DD'')','fin_docs','');
  BRefreshClick(nil);
end;

procedure TFBrowseFIN_LINES.BSelectCON_HEADER_IDClick(Sender: TObject);
Var ID : ShortString;
begin
  ID := CON_HEADER_ID.Text;
  If AutoCreate.FIN_DOCSShowModalAsSelect(ID) = mrOK Then CON_HEADER_ID.Text := ID;
end;

procedure TFBrowseFIN_LINES.BClearCON_HEADER_IDClick(Sender: TObject);
begin
  CON_HEADER_ID.Text := '';
end;

procedure TFBrowseFIN_LINES.CON_HEADER_ID_VALUEDblClick(Sender: TObject);
begin
  BSelectCON_HEADER_IDClick(nil);
end;

procedure TFBrowseFIN_LINES.QTYExit(Sender: TObject);
begin
 try
   Query['NET_AMOUNT'] :=  StrToFloat( UNIT_PRICE.Text ) * StrToFloat( QTY.Text );
   Query['TAX_AMOUNT'] :=  StrToFloat( NET_AMOUNT.Text ) * StrToFloat( searchAndReplace(TAX_ID_VALUE.Text,'%','') ) / 100;
   Query['GROSS_AMOUNT'] :=  StrToFloat( NET_AMOUNT.Text ) + StrToFloat( TAX_AMOUNT.Text );
 except
 end;
end;

procedure TFBrowseFIN_LINES.QueryAfterOpen(DataSet: TDataSet);
begin
  TFloatField(Query.FieldByName('UNIT_PRICE')).DisplayFormat  := '###,###,###,##0.00';
  TFloatField(Query.FieldByName('UNIT_PRICE')).EditFormat     := '###########0.00';
  TFloatField(Query.FieldByName('QTY')).DisplayFormat         := '###,###,###,##0.00';
  TFloatField(Query.FieldByName('QTY')).EditFormat            := '###########0.00';
  TFloatField(Query.FieldByName('NET_AMOUNT')).DisplayFormat  := '###,###,###,##0.00';
  TFloatField(Query.FieldByName('NET_AMOUNT')).EditFormat     := '###########0.00';
  TFloatField(Query.FieldByName('TAX_AMOUNT')).DisplayFormat  := '###,###,###,##0.00';
  TFloatField(Query.FieldByName('TAX_AMOUNT')).EditFormat     := '###########0.00';
  TFloatField(Query.FieldByName('GROSS_AMOUNT')).DisplayFormat:= '###,###,###,##0.00';
  TFloatField(Query.FieldByName('GROSS_AMOUNT')).EditFormat   := '###########0.00';
end;

end.
