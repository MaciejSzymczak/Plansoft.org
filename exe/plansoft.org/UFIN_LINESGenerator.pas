unit UFIN_LINESGenerator;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormConfig, StdCtrls, Buttons, ExtCtrls, Mask, DBCtrls;

type
  TFFIN_LINESGenerator = class(TFormConfig)
    LabelHEADER_ID: TLabel;
    HEADER_ID_VALUE: TEdit;
    BSelectHEADER_ID: TBitBtn;
    BClearHEADER_ID: TBitBtn;
    LabelDESCRIPTION: TLabel;
    LabelUNIT_PRICE: TLabel;
    LabelQTY: TLabel;
    LabelUOM_ID: TLabel;
    UOM_ID_VALUE: TEdit;
    BSelectUOM_ID: TBitBtn;
    BClearUOM_ID: TBitBtn;
    LabelTAX_ID: TLabel;
    TAX_ID_VALUE: TEdit;
    BSelectTAX_ID: TBitBtn;
    BClearTAX_ID: TBitBtn;
    LabelNET_AMOUNT: TLabel;
    LabelTAX_AMOUNT: TLabel;
    LabelGROSS_AMOUNT: TLabel;
    LabelAUX_DESC1: TLabel;
    LabelAUX_DESC2: TLabel;
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    AUX_DESC1: TEdit;
    AUX_DESC2: TEdit;
    UNIT_PRICE: TEdit;
    DESCRIPTION: TEdit;
    HEADER_ID: TEdit;
    QTY: TEdit;
    NET_AMOUNT: TEdit;
    TAX_AMOUNT: TEdit;
    GROSS_AMOUNT: TEdit;
    TAX_ID: TEdit;
    UOM_ID: TEdit;
    Label1: TLabel;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure HEADER_IDChange(Sender: TObject);
    procedure UOM_IDChange(Sender: TObject);
    procedure TAX_IDChange(Sender: TObject);
    procedure BSelectHEADER_IDClick(Sender: TObject);
    procedure BSelectUOM_IDClick(Sender: TObject);
    procedure BSelectTAX_IDClick(Sender: TObject);
    procedure BClearHEADER_IDClick(Sender: TObject);
    procedure BClearUOM_IDClick(Sender: TObject);
    procedure BClearTAX_IDClick(Sender: TObject);
    procedure HEADER_ID_VALUEDblClick(Sender: TObject);
    procedure UOM_ID_VALUEDblClick(Sender: TObject);
    procedure TAX_ID_VALUEDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    procedure insertLine (pdesc, pqty : string);
  end;

var
  FFIN_LINESGenerator: TFFIN_LINESGenerator;

implementation

{$R *.dfm}

Uses UutilityParent, DM, autocreate;

procedure TFFIN_LINESGenerator.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  canClose := true;
  if modalResult = mrOK then begin
    if
      (HEADER_ID.Text='') or
      (UNIT_PRICE.Text='') or
      (UOM_ID.Text='') or
      (TAX_ID.Text='')
    then begin
      info('Wszystkie pola oznaczone kolorem czerwonym musz¹ zostaæ wype³nione');
      canClose := false;
      exit;
    end;
    //
    try
      strToFloat (UNIT_PRICE.Text);
    except
      info ('Wartoœæ w polu CENA JEDNOSTKOWA musi byæ liczb¹');
      canClose := false;
      exit;
    end;
  end;

    
end;

procedure TFFIN_LINESGenerator.HEADER_IDChange(Sender: TObject);
begin
  DModule.RefreshLookupEdit(Self, TControl(Sender).Name,'num || '' z dnia '' || to_char(doc_date,''YYYY-MM-DD'') ','fin_docs','');
end;

procedure TFFIN_LINESGenerator.UOM_IDChange(Sender: TObject);
begin
  DModule.RefreshLookupEdit(Self, TControl(Sender).Name,'DESCRIPTION ','fin_lookup_values','');
end;

procedure TFFIN_LINESGenerator.TAX_IDChange(Sender: TObject);
begin
  DModule.RefreshLookupEdit(Self, TControl(Sender).Name,'DESCRIPTION ','fin_lookup_values','');
end;

procedure TFFIN_LINESGenerator.BSelectHEADER_IDClick(Sender: TObject);
Var ID : ShortString;
begin
  ID := HEADER_ID.Text;
  If AutoCreate.FIN_DOCSShowModalAsSelect(ID) = mrOK Then HEADER_ID.Text := ID;
end;

procedure TFFIN_LINESGenerator.BSelectUOM_IDClick(Sender: TObject);
Var ID : ShortString;
begin
  ID := UOM_ID.Text;
  If AutoCreate.FIN_LOOKUP_VALUESShowModalAsSelect('UOM',ID) = mrOK Then UOM_ID.Text := ID;
end;

procedure TFFIN_LINESGenerator.BSelectTAX_IDClick(Sender: TObject);
Var ID : ShortString;
begin
  ID := TAX_ID.Text;
  If AutoCreate.FIN_LOOKUP_VALUESShowModalAsSelect('TAX',ID) = mrOK Then begin
    TAX_ID.Text := ID;
  end;
end;

procedure TFFIN_LINESGenerator.BClearHEADER_IDClick(Sender: TObject);
begin
  HEADER_ID.Text := '';
end;

procedure TFFIN_LINESGenerator.BClearUOM_IDClick(Sender: TObject);
begin
  UOM_ID.Text := '';
end;

procedure TFFIN_LINESGenerator.BClearTAX_IDClick(Sender: TObject);
begin
  TAX_ID.Text := '';
end;

procedure TFFIN_LINESGenerator.HEADER_ID_VALUEDblClick(Sender: TObject);
begin
  BSelectHEADER_IDClick(nil);
end;

procedure TFFIN_LINESGenerator.UOM_ID_VALUEDblClick(Sender: TObject);
begin
  BSelectUOM_IDClick(nil);
end;

procedure TFFIN_LINESGenerator.TAX_ID_VALUEDblClick(Sender: TObject);
begin
  BSelectTAX_IDClick(nil);
end;

procedure TFFIN_LINESGenerator.insertLine (pdesc, pqty : string);
 var
  punitPrice  : string;
  pnetAmount  : string;
  ptaxAmount  : string;
  pgrossAmount: string;
  pnetAmountf  : double;
  ptaxAmountf  : double;
  pgrossAmountf: double;
 function strToOracle ( s : string ) : string;
 begin
   result := searchAndReplace(searchAndReplace(s, ' ', ''), ',','.');
 end;
begin
  pnetAmountf   := strToFloat(pqty)*strToFloat(UNIT_PRICE.Text);
  try
  ptaxAmountf   := pnetAmountf * StrToFloat( searchAndReplace(TAX_ID_VALUE.Text,'%','') ) / 100;
  except
    ptaxAmountf   := 0;
  end;
  pgrossAmountf := pnetAmountf  + ptaxAmountf;
  //
  punitPrice   := strToOracle ( UNIT_PRICE.Text );
  pqty         := strToOracle ( pqty );
  pnetAmount   := strToOracle (floatToStr(pnetAmountf));
  ptaxAmount   := strToOracle (floatToStr(ptaxAmountf));
  pgrossAmount := strToOracle (floatToStr(pgrossAmountf));
  dmodule.SQL('insert into fin_lines (id, header_id, description, unit_price, qty, uom_id, tax_id, net_amount, tax_amount, gross_amount, aux_desc1, aux_desc2) '+'values (main_seq.nextval, :header_id, :description, :unit_price, :qty, :uom_id, :tax_id, :net_amount, :tax_amount, :gross_amount, :aux_desc1, :aux_desc2)'
    , 'header_id='+header_id.Text+';description='+pdesc+';unit_price='+punitPrice+';qty='+pqty+';uom_id='+UOM_ID.text+';tax_id='+TAX_ID.TEXT+';net_amount='+pnetAmount+';tax_amount='+ptaxAmount+';gross_amount='+pgrossAmount+';aux_desc1='+AUX_DESC1.text+';aux_desc2='+AUX_DESC2.text);
end;

end.
