unit UFBrowseFIN_DOCS;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFBrowseParent, DB, ADODB, ImgList, ExtCtrls, StrHlder, Menus,
  ToolEdit, RXDBCtrl, Mask, DBCtrls, StdCtrls, ComCtrls, Grids, DBGrids,
  Buttons, OleServer, WordXP, ExcelXP;

type
  TFBrowseFIN_DOCS = class(TFBrowseParent)
    BATCH_ID: TDBEdit;
    LabelBATCH_ID: TLabel;
    PARTY_FROM_ID: TDBEdit;
    LabelPARTY_FROM_ID: TLabel;
    PARTY_TO_ID: TDBEdit;
    LabelPARTY_TO_ID: TLabel;
    DOC_TYPE_ID: TDBEdit;
    LabelDOC_TYPE_ID: TLabel;
    NUM: TDBEdit;
    LabelNUM: TLabel;
    DOC_DATE: TDBDateEdit;
    LabelDOC_DATE: TLabel;
    SALES_DATE: TDBDateEdit;
    LabelSALES_DATE: TLabel;
    STR_KEY: TDBEdit;
    LabelSTR_KEY: TLabel;
    FEEDER_SYSTEM_REF: TDBEdit;
    LabelFEEDER_SYSTEM_REF: TLabel;
    AUX_DESC1: TDBEdit;
    LabelAUX_DESC1: TLabel;
    AUX_DESC2: TDBEdit;
    LabelAUX_DESC2: TLabel;
    ID: TDBEdit;
    LabelID: TLabel;
    PAYMENT_STATUS: TDBCheckBox;
    BATCH_ID_VALUE: TEdit;
    BSelectBATCH_ID: TBitBtn;
    BClearBATCH_ID: TBitBtn;
    PARTY_FROM_ID_VALUE: TEdit;
    PARTY_TO_ID_VALUE: TEdit;
    DOC_TYPE_ID_VALUE: TEdit;
    BSelectPARTY_FROM_ID: TBitBtn;
    BSelectPARTY_TO_ID: TBitBtn;
    BSelectDOC_TYPE_ID: TBitBtn;
    CON_BATCH_ID: TEdit;
    CON_BATCH_ID_VALUE: TEdit;
    BSelectCON_BATCH_ID: TBitBtn;
    BClearCON_BATCH_ID: TBitBtn;
    Label1: TLabel;
    CON_PARTY_FROM_ID: TEdit;
    CON_PARTY_FROM_ID_VALUE: TEdit;
    BSelectPARTY_FROM: TBitBtn;
    BClearPARTY_FROM: TBitBtn;
    BClearPARTY_TO: TBitBtn;
    BSelectPARTY_TO: TBitBtn;
    CON_PARTY_TO_ID_VALUE: TEdit;
    CON_PARTY_TO_ID: TEdit;
    Label2: TLabel;
    Label4: TLabel;
    WordApplication1: TWordApplication;
    Doc: TWordDocument;
    ParaFmt: TWordParagraphFormat;
    WordFont1: TWordFont;
    BitBtn1: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure BATCH_IDChange(Sender: TObject);
    procedure BATCH_ID_VALUEDblClick(Sender: TObject);
    procedure BSelectBATCH_IDClick(Sender: TObject);
    procedure BClearBATCH_IDClick(Sender: TObject);
    procedure PARTY_FROM_IDChange(Sender: TObject);
    procedure PARTY_TO_IDChange(Sender: TObject);
    procedure DOC_TYPE_IDChange(Sender: TObject);
    procedure BSelectPARTY_FROM_IDClick(Sender: TObject);
    procedure BSelectPARTY_TO_IDClick(Sender: TObject);
    procedure BSelectDOC_TYPE_IDClick(Sender: TObject);
    procedure CON_BATCH_IDChange(Sender: TObject);
    procedure BSelectCON_BATCH_IDClick(Sender: TObject);
    procedure CON_BATCH_ID_VALUEDblClick(Sender: TObject);
    procedure BClearCON_BATCH_IDClick(Sender: TObject);
    procedure CON_PARTY_FROM_IDChange(Sender: TObject);
    procedure CON_PARTY_TO_IDChange(Sender: TObject);
    procedure BSelectPARTY_FROMClick(Sender: TObject);
    procedure CON_PARTY_FROM_ID_VALUEDblClick(Sender: TObject);
    procedure BSelectPARTY_TOClick(Sender: TObject);
    procedure CON_PARTY_TO_ID_VALUEDblClick(Sender: TObject);
    procedure BClearPARTY_FROMClick(Sender: TObject);
    procedure BClearPARTY_TOClick(Sender: TObject);
    procedure BUpdChild1Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    Function  CheckRecord : Boolean; override;
    Procedure DefaultValues; override;
    Procedure GetTableName;  override;
    Procedure CustomConditions;      override;
  end;

var
  FBrowseFIN_DOCS: TFBrowseFIN_DOCS;

implementation

uses DM, UUtilityParent, AutoCreate, ComObj;

{$R *.dfm}

Function  TFBrowseFIN_DOCS.CheckRecord : Boolean;
Begin
  Result := CheckValid.ReducRestrictEmpty(Self, [PARTY_FROM_ID, PARTY_TO_ID, DOC_TYPE_ID, NUM, DOC_DATE]);
End;

Procedure TFBrowseFIN_DOCS.DefaultValues;
Begin
 Query['ID'] := DModule.SingleValue('select main_seq.nextval from dual');
 Query.FieldByName('BATCH_ID').AsString := CON_BATCH_ID.Text;
 Query.FieldByName('PARTY_FROM_ID').AsString := CON_PARTY_FROM_ID.Text;
 Query.FieldByName('PARTY_TO_ID').AsString := CON_PARTY_TO_ID.Text;
 Query['PAYMENT_STATUS'] := '-';
End;

procedure TFBrowseFIN_DOCS.FormCreate(Sender: TObject);
begin
  inherited;
  SetNotUpdatable([PARTY_FROM_ID, PARTY_TO_ID, DOC_TYPE_ID, NUM, DOC_DATE, BSelectPARTY_FROM_ID, BSelectPARTY_TO_ID, BSelectDOC_TYPE_ID], [LabelPARTY_FROM_ID, LabelPARTY_TO_ID, LabelDOC_TYPE_ID, LabelNUM, LabelDOC_DATE]);
end;

Procedure TFBrowseFIN_DOCS.GetTableName;
Begin
  Self.TableName := 'FIN_DOCS';
End;


procedure TFBrowseFIN_DOCS.BATCH_IDChange(Sender: TObject);
begin
  DModule.RefreshLookupEdit(Self, TControl(Sender).Name,'DESCRIPTION ','FIN_BATCHES','');
end;

procedure TFBrowseFIN_DOCS.BATCH_ID_VALUEDblClick(Sender: TObject);
begin
BSelectBATCH_IDClick(nil);
end;

procedure TFBrowseFIN_DOCS.BSelectBATCH_IDClick(Sender: TObject);
Var ID : ShortString;
begin
  ID := BATCH_ID.Text;
  If AutoCreate.FIN_BATCHESShowModalAsSelect(ID) = mrOK Then Query.FieldByName('BATCH_ID').AsString := ID;
end;

procedure TFBrowseFIN_DOCS.BClearBATCH_IDClick(Sender: TObject);
begin
  inherited;
 Query.FieldByName('BATCH_ID').Clear;
end;

procedure TFBrowseFIN_DOCS.PARTY_FROM_IDChange(Sender: TObject);
begin
  DModule.RefreshLookupEdit(Self, TControl(Sender).Name,'CUSTOMER_NAME_LINE1||'' ''||ADDRESS_STREET||'' ''||TAX_NUM ','FIN_PARTIES','');
end;

procedure TFBrowseFIN_DOCS.PARTY_TO_IDChange(Sender: TObject);
begin
  DModule.RefreshLookupEdit(Self, TControl(Sender).Name,'CUSTOMER_NAME_LINE1||'' ''||ADDRESS_STREET||'' ''||TAX_NUM ','FIN_PARTIES','');
end;

procedure TFBrowseFIN_DOCS.DOC_TYPE_IDChange(Sender: TObject);
begin
  DModule.RefreshLookupEdit(Self, TControl(Sender).Name,'DESCRIPTION ','FIN_LOOKUP_VALUES','');
end;

procedure TFBrowseFIN_DOCS.BSelectPARTY_FROM_IDClick(Sender: TObject);
Var ID : ShortString;
begin
  ID := PARTY_FROM_ID.Text;
  If AutoCreate.FIN_PARTIESShowModalAsSelect(ID) = mrOK Then Query.FieldByName('PARTY_FROM_ID').AsString := ID;
end;

procedure TFBrowseFIN_DOCS.BSelectPARTY_TO_IDClick(Sender: TObject);
Var ID : ShortString;
begin
  ID := PARTY_TO_ID.Text;
  If AutoCreate.FIN_PARTIESShowModalAsSelect(ID) = mrOK Then Query.FieldByName('PARTY_TO_ID').AsString := ID;
end;

procedure TFBrowseFIN_DOCS.BSelectDOC_TYPE_IDClick(Sender: TObject);
Var ID : ShortString;
begin
  ID := DOC_TYPE_ID.Text;
  If AutoCreate.FIN_LOOKUP_VALUESShowModalAsSelect('DOC_TYPE', ID) = mrOK Then Query.FieldByName('DOC_TYPE_ID').AsString := ID;
end;

Procedure TFBrowseFIN_DOCS.CustomConditions;
Begin
 If CON_BATCH_ID.Text = ''
     Then DM.macros.setMacro(query, 'CON_BATCH_ID', '0=0')
     Else DM.macros.setMacro(query, 'CON_BATCH_ID', 'BATCH_ID ='+CON_BATCH_ID.Text);

 If CON_PARTY_FROM_ID.Text = ''
     Then DM.macros.setMacro(query, 'CON_PARTY_FROM_ID', '0=0')
     Else DM.macros.setMacro(query, 'CON_PARTY_FROM_ID', 'PARTY_FROM_ID ='+CON_PARTY_FROM_ID.Text);

 If CON_PARTY_TO_ID.Text = ''
     Then DM.macros.setMacro(query, 'CON_PARTY_TO_ID', '0=0')
     Else DM.macros.setMacro(query, 'CON_PARTY_TO_ID', 'PARTY_TO_ID ='+CON_PARTY_TO_ID.Text);

End;

procedure TFBrowseFIN_DOCS.CON_BATCH_IDChange(Sender: TObject);
begin
  DModule.RefreshLookupEdit(Self, TControl(Sender).Name,'DESCRIPTION ','FIN_BATCHES','');
  BRefreshClick(nil);
end;

procedure TFBrowseFIN_DOCS.BSelectCON_BATCH_IDClick(Sender: TObject);
Var ID : ShortString;
begin
  ID := CON_BATCH_ID.Text;
  If AutoCreate.FIN_BATCHESShowModalAsSelect(ID) = mrOK Then CON_BATCH_ID.Text := ID;
end;

procedure TFBrowseFIN_DOCS.CON_BATCH_ID_VALUEDblClick(Sender: TObject);
begin
  BSelectCON_BATCH_IDClick(nil);
end;

procedure TFBrowseFIN_DOCS.BClearCON_BATCH_IDClick(Sender: TObject);
begin
  CON_BATCH_ID.Text := '';
end;

procedure TFBrowseFIN_DOCS.CON_PARTY_FROM_IDChange(Sender: TObject);
begin
  DModule.RefreshLookupEdit(Self, TControl(Sender).Name,'CUSTOMER_NAME_LINE1||'' ''||ADDRESS_STREET||'' ''||TAX_NUM','FIN_PARTIES','');
  BRefreshClick(nil);
end;

procedure TFBrowseFIN_DOCS.CON_PARTY_TO_IDChange(Sender: TObject);
begin
  DModule.RefreshLookupEdit(Self, TControl(Sender).Name,'CUSTOMER_NAME_LINE1||'' ''||ADDRESS_STREET||'' ''||TAX_NUM','FIN_PARTIES','');
  BRefreshClick(nil);
end;

procedure TFBrowseFIN_DOCS.BSelectPARTY_FROMClick(Sender: TObject);
Var ID : ShortString;
begin
  ID := CON_PARTY_FROM_ID.Text;
  If AutoCreate.FIN_PARTIESShowModalAsSelect(ID) = mrOK Then CON_PARTY_FROM_ID.Text := ID;
end;

procedure TFBrowseFIN_DOCS.BSelectPARTY_TOClick(Sender: TObject);
Var ID : ShortString;
begin
  ID := CON_PARTY_TO_ID.Text;
  If AutoCreate.FIN_PARTIESShowModalAsSelect(ID) = mrOK Then CON_PARTY_TO_ID.Text := ID;
end;

procedure TFBrowseFIN_DOCS.CON_PARTY_FROM_ID_VALUEDblClick(
  Sender: TObject);
begin
  BSelectPARTY_FROMClick(nil);
end;


procedure TFBrowseFIN_DOCS.CON_PARTY_TO_ID_VALUEDblClick(Sender: TObject);
begin
  BSelectPARTY_TOClick(nil);
end;

procedure TFBrowseFIN_DOCS.BClearPARTY_FROMClick(Sender: TObject);
begin
  CON_PARTY_FROM_ID.Text := '';
end;

procedure TFBrowseFIN_DOCS.BClearPARTY_TOClick(Sender: TObject);
begin
  CON_PARTY_TO_ID.Text := '';
end;

procedure TFBrowseFIN_DOCS.BUpdChild1Click(Sender: TObject);
begin
  AutoCreate.FIN_LINESShowModalAsBrowser( Query['Id'] );
end;

procedure TFBrowseFIN_DOCS.BitBtn1Click(Sender: TObject);
  //--------------------------
  procedure openWord;
  begin
    WordApplication1.Connect;
    WordApplication1.Visible := True;
    Doc.ConnectTo(WordApplication1.Documents.Add(EmptyParam, EmptyParam ,EmptyParam,EmptyParam));
  end;
  //--------------------------
  procedure enterText;
  var
      S: WordSelection;
      R: Range;
      Direction, Separator, Format, Story: OleVariant;
      T: Table;
      C : column;
      lp : integer;
      procedure header ( header: string );
      begin
        WordFont1.Size := WordFont1.Size + 5;
        WordFont1.Bold := wdToggle;
        S.TypeText( header );
        WordFont1.Bold := wdToggle;
        WordFont1.Size := WordFont1.Size - 5;
      end;
      procedure TypeTextLn ( header, str: string );
      begin
        if str = '' then exit;
        R.InsertAfter( header + chr(9) );
        R.InsertAfter( str);
        R.InsertParagraphAfter;
      end;
  begin
      S := WordApplication1.Selection;
      WordFont1.ConnectTo(S.Font);
      WordFont1.Size := 8;

     with dmodule do begin
       opensql(
        'select (select description from fin_batches where id = d.batch_id) batch_dsp ' + cr +
        '     , (select description from fin_lookup_values where lookup_type = ''DOC_TYPE'' and id = d.doc_type_id) doc_type_dsp ' + cr +
        '     , d.num ' + cr +
        '     , to_char(d.doc_date,''yyyy-mm-dd'') doc_date ' + cr +
        '     , to_char(d.sales_date, ''yyyy-mm-dd'') sales_date ' + cr +
        '     , decode(d.payment_status,''-'',''nie zap³acone'', ''zap³acone'') payment_status_dsp ' + cr +
        '     , d.aux_desc1 ' + cr +
        '     , d.aux_desc2 ' + cr +
        '     , d.id ' + cr +
        '     -- ' + cr +
        '     , seller.customer_name_line1         seller_customer_name_line1    ' + cr +
        '     , seller.customer_name_line2         seller_customer_name_line2    ' + cr +
        '     , seller.tax_num                     seller_tax_num                ' + cr +
        '     , seller.stat_num                    seller_stat_num               ' + cr +
        '     , seller.address_street              seller_address_street         ' + cr +
        '     , seller.address_street_num          seller_address_street_num     ' + cr +
        '     , seller.address_building_num        seller_address_building_num   ' + cr +
        '     , seller.address_postal_code         seller_address_postal_code    ' + cr +
        '     , seller.addres_place                seller_addres_place           ' + cr +
        '     , seller.address_country             seller_address_country        ' + cr +
        '     , seller.bank_account_num            seller_bank_account_num       ' + cr +
        '     , seller.aux_desc1                   seller_aux_desc1              ' + cr +
        '     , seller.aux_desc2                   seller_aux_desc2              ' + cr +
        '     --                                  --                             ' + cr +
        '     , buyer.customer_name_line1          buyer_customer_name_line1     ' + cr +
        '     , buyer.customer_name_line2          buyer_customer_name_line2     ' + cr +
        '     , buyer.tax_num                      buyer_tax_num                 ' + cr +
        '     , buyer.stat_num                     buyer_stat_num                ' + cr +
        '     , buyer.address_street               buyer_address_street          ' + cr +
        '     , buyer.address_street_num           buyer_address_street_num      ' + cr +
        '     , buyer.address_building_num         buyer_address_building_num    ' + cr +
        '     , buyer.address_postal_code          buyer_address_postal_code     ' + cr +
        '     , buyer.addres_place                 buyer_addres_place            ' + cr +
        '     , buyer.address_country              buyer_address_country         ' + cr +
        '     , buyer.bank_account_num             buyer_bank_account_num        ' + cr +
        '     , buyer.aux_desc1                    buyer_aux_desc1               ' + cr +
        '     , buyer.aux_desc2                    buyer_aux_desc2               ' + cr +
        'from fin_docs d ' + cr +
        '   , fin_parties seller ' + cr +
        '   , fin_parties buyer ' + cr +
        'where seller.id = d.party_from_id ' + cr +
        '  and buyer.id = d.party_to_id ' + cr +
        '  and d.id = ' + query.fieldbyName('ID').AsString );
       qwork.First;
       while not qwork.Eof do begin

          header('Dane o dokumencie');
          S.TypeParagraph;

          R := S.Range;
          Direction := wdCollapseEnd;

          typeTextLn(  'Partia'          , qwork.fieldbyname('BATCH_DSP').AsString  );
          typeTextLn(  'Typ dokumentu'   , qwork.fieldbyname('DOC_TYPE_DSP').AsString  );
          typeTextLn(  'Numer'           , qwork.fieldbyname('NUM').AsString  );
          typeTextLn(  'Data dokumentu'  , qwork.fieldbyname('DOC_DATE').AsString  );
          typeTextLn(  'Data sprzeda¿y'  , qwork.fieldbyname('SALES_DATE').AsString  );
          typeTextLn(  'Status p³atnoœci', qwork.fieldbyname('PAYMENT_STATUS_DSP').AsString  );
          typeTextLn(  'Opis 1'          , qwork.fieldbyname('AUX_DESC1').AsString  );
          typeTextLn(  'Opis 2'          , qwork.fieldbyname('AUX_DESC2').AsString  );
          typeTextLn(  'Identyfikator'   , qwork.fieldbyname('ID').AsString  );

          Separator := chr(9);
          Format := wdTableFormatGrid1;
          R.ConvertToTable(Separator, EmptyParam, EmptyParam,
                       EmptyParam, Format, EmptyParam,
                       EmptyParam, EmptyParam, EmptyParam,
                       EmptyParam, EmptyParam, EmptyParam,
                       EmptyParam, EmptyParam,EmptyParam,EmptyParam);

          Story := wdStory;
          S.EndKey(Story,EmptyParam);
          S.Select;

          header('Dane o wystawcy dokumentu');
          S.TypeParagraph;

          R := S.Range;
          Direction := wdCollapseEnd;

          typeTextLn(  'Nazwa', qwork.fieldbyname('SELLER_CUSTOMER_NAME_LINE1').AsString  );
          typeTextLn(  '', qwork.fieldbyname('SELLER_CUSTOMER_NAME_LINE2').AsString  );
          typeTextLn(  'NIP', qwork.fieldbyname('SELLER_TAX_NUM').AsString  );
          typeTextLn(  'REGON', qwork.fieldbyname('SELLER_STAT_NUM').AsString  );
          typeTextLn(  '', qwork.fieldbyname('SELLER_ADDRESS_STREET').AsString +' '+ qwork.fieldbyname('SELLER_ADDRESS_STREET_NUM').AsString +' '+ qwork.fieldbyname('SELLER_ADDRESS_BUILDING_NUM').AsString);
          typeTextLn(  '', qwork.fieldbyname('SELLER_ADDRESS_POSTAL_CODE').AsString + ' ' + qwork.fieldbyname('SELLER_ADDRES_PLACE').AsString );
          typeTextLn(  '', qwork.fieldbyname('SELLER_ADDRESS_COUNTRY').AsString  );
          typeTextLn(  'Konto', qwork.fieldbyname('SELLER_BANK_ACCOUNT_NUM').AsString  );
          typeTextLn(  'Dodatkowe informacje', qwork.fieldbyname('SELLER_AUX_DESC1').AsString  );
          typeTextLn(  'Dodatkowe informacje', qwork.fieldbyname('SELLER_AUX_DESC2').AsString  );

          Separator := chr(9);
          Format := wdTableFormatGrid1;
          R.ConvertToTable(Separator, EmptyParam, EmptyParam,
                       EmptyParam, Format, EmptyParam,
                       EmptyParam, EmptyParam, EmptyParam,
                       EmptyParam, EmptyParam, EmptyParam,
                       EmptyParam, EmptyParam,EmptyParam,EmptyParam);

          Story := wdStory;
          S.EndKey(Story,EmptyParam);
          S.Select;

          header('Dane o odbiorcy dokumentu');
          S.TypeParagraph;

          R := S.Range;
          Direction := wdCollapseEnd;

          typeTextLn(  'Nazwa', qwork.fieldbyname('BUYER_CUSTOMER_NAME_LINE1').AsString  );
          typeTextLn(  '', qwork.fieldbyname('BUYER_CUSTOMER_NAME_LINE2').AsString  );
          typeTextLn(  'NIP', qwork.fieldbyname('BUYER_TAX_NUM').AsString  );
          typeTextLn(  'REGON', qwork.fieldbyname('BUYER_STAT_NUM').AsString  );
          typeTextLn(  '', qwork.fieldbyname('BUYER_ADDRESS_STREET').AsString +' '+ qwork.fieldbyname('BUYER_ADDRESS_STREET_NUM').AsString +' '+ qwork.fieldbyname('BUYER_ADDRESS_BUILDING_NUM').AsString);
          typeTextLn(  '', qwork.fieldbyname('BUYER_ADDRESS_POSTAL_CODE').AsString + ' ' + qwork.fieldbyname('BUYER_ADDRES_PLACE').AsString );
          typeTextLn(  '', qwork.fieldbyname('BUYER_ADDRESS_COUNTRY').AsString  );
          typeTextLn(  'Konto', qwork.fieldbyname('BUYER_BANK_ACCOUNT_NUM').AsString  );
          typeTextLn(  ''+'Dodatkowe informacje', qwork.fieldbyname('BUYER_AUX_DESC1').AsString  );
          typeTextLn(  ''+'Dodatkowe informacje', qwork.fieldbyname('BUYER_AUX_DESC2').AsString  );

          Separator := chr(9);
          Format := wdTableFormatGrid1;
          R.ConvertToTable(Separator, EmptyParam, EmptyParam,
                       EmptyParam, Format, EmptyParam,
                       EmptyParam, EmptyParam, EmptyParam,
                       EmptyParam, EmptyParam, EmptyParam,
                       EmptyParam, EmptyParam,EmptyParam,EmptyParam);
          Story := wdStory;
          S.EndKey(Story,EmptyParam);
          S.Select;

          qwork.Next;
       end;
     end;

      //Doc.Bookmarks.Add('FirstRealPara', EmptyParam);

      header('Linie dokumentu');
      S.TypeParagraph;
      R := S.Range;
      Direction := wdCollapseEnd;
      R.Collapse(Direction);
      R.InsertAfter(
        'LP'+chr(9)+
        'Opis'+chr(9)+
        'Cena jednostkowa'+chr(9)+
        'Iloœæ'+chr(9)+
        'JM'+chr(9)+
        'Kod podatku'+chr(9)+
        'Netto'+chr(9)+
        'Podatek'+chr(9)+
        'Brutto'+chr(9)+
        'Opis'+chr(9)+
        'Opis'
      );
      R.InsertParagraphAfter;
      lp := 1;
      with dmodule do begin
        opensql(
         'select null '+cr+
         '     ||chr(9)|| l.description '+cr+
         '     ||chr(9)|| unit_price '+cr+
         '     ||chr(9)|| l.qty '+cr+
         '     ||chr(9)|| (select description from fin_lookup_values where lookup_type = ''UOM'' and id = l.uom_id) '+cr+
         '     ||chr(9)|| (select description from fin_lookup_values where lookup_type = ''TAX'' and id = l.tax_id) '+cr+
         '     ||chr(9)|| l.net_amount '+cr+
         '     ||chr(9)|| l.tax_amount '+cr+
         '     ||chr(9)|| l.gross_amount '+cr+
         '     ||chr(9)|| l.aux_desc1 '+cr+
         '     ||chr(9)|| l.aux_desc2 '+cr+
         '  from fin_lines l '+cr+
         '  where header_id = ' + query.fieldbyName('ID').AsString + ' order by creation_date' );
        qwork.First;
        while not qwork.Eof do begin
           R.InsertAfter( intToStr(lp) + qwork.Fields[0].AsString  );
           inc(lp);
           R.InsertParagraphAfter;
           qwork.Next;
        end;
      end;
      Separator := chr(9);
      Format := wdTableFormatGrid3;
      R.ConvertToTable(Separator, EmptyParam, EmptyParam,
                       EmptyParam, Format, EmptyParam,
                       EmptyParam, EmptyParam, EmptyParam,
                       EmptyParam, EmptyParam, EmptyParam,
                       EmptyParam, EmptyParam,EmptyParam,EmptyParam);
      S.EndKey(Story,EmptyParam);
      S.Select;

      t :=  WordApplication1.ActiveDocument.Tables.Item(4);

      c := t.Columns.Item(3);
      c.Select;
      S := WordApplication1.Selection;
      S.ParagraphFormat.Alignment := wdAlignParagraphRight;

      c := t.Columns.Item(4);
      c.Select;
      S := WordApplication1.Selection;
      S.ParagraphFormat.Alignment := wdAlignParagraphRight;

      c := t.Columns.Item(5);
      c.Select;
      S := WordApplication1.Selection;
      S.ParagraphFormat.Alignment := wdAlignParagraphRight;

      c := t.Columns.Item(6);
      c.Select;
      S := WordApplication1.Selection;
      S.ParagraphFormat.Alignment := wdAlignParagraphRight;

      c := t.Columns.Item(7);
      c.Select;
      S := WordApplication1.Selection;
      S.ParagraphFormat.Alignment := wdAlignParagraphRight;

      c := t.Columns.Item(8);
      c.Select;
      S := WordApplication1.Selection;
      S.ParagraphFormat.Alignment := wdAlignParagraphRight;

      c := t.Columns.Item(9);
      c.Select;
      S := WordApplication1.Selection;
      S.ParagraphFormat.Alignment := wdAlignParagraphRight;

  end;
  //--------------------------
  procedure saveAs;
  begin
    Hide;
    try
      WordApplication1.Dialogs.Item(wdDialogFileSaveAs).Show(EmptyParam);
    finally
      Show;
    end;
  end;
  //--------------------------
  procedure closeWord;
  var
    SaveChanges: OleVariant;
  begin
    SaveChanges := wdDoNotSaveChanges;
    WordApplication1.Quit(SaveChanges);
    WordApplication1.Disconnect;
  end;

begin
  // http://www.djpate.freeserve.co.uk/DelphiLinks.htm
  openWord;
  enterText;
  saveAs;
  closeWord;
end;

end.
