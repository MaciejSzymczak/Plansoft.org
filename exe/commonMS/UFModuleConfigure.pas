unit UFModuleConfigure;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, DBCtrls, UFormConfig, ComCtrls, Grids,
  StrHlder, UUtilityParent;
type
  TFModuleConfigure = class(TFormConfig)
    BottomPanel: TPanel;
    Anuluj: TBitBtn;
    OK: TBitBtn;
    Page: TPageControl;
    TabMain: TTabSheet;
    TabPrzyciski: TTabSheet;
    Label1: TLabel;
    FormCaption: TEdit;
    GroupBox1: TGroupBox;
    Label3: TLabel;
    Label5: TLabel;
    TabLista: TTabSheet;
    GroupBox2: TGroupBox;
    GridLayout: TMemo;
    Label8: TLabel;
    GridHint: TEdit;
    BFontChange: TBitBtn;
    FDialog: TFontDialog;
    LGridFont: TLabel;
    Label11: TLabel;
    SortOrder: TMemo;
    BrakUprawnien: TMemo;
    Label12: TLabel;
    TabFiltrowanie: TTabSheet;
    Label13: TLabel;
    AvailColumnsWhereClause: TMemo;
    LKryterium: TLabel;
    LLKryterium: TEdit;
    HKFiltrowanie: THotKey;
    Label14: TLabel;
    EdytujE: TEdit;
    DodajE: TEdit;
    KopiujE: TEdit;
    UsunE: TEdit;
    UsunAllE: TEdit;
    ZamknijE: TEdit;
    SzukajE: TEdit;
    WybierzE: TEdit;
    AnulujE: TEdit;
    EdytujHint: TEdit;
    DodajHint: TEdit;
    KopiujHint: TEdit;
    UsunHint: TEdit;
    UsunAllHint: TEdit;
    ZamknijHint: TEdit;
    SzukajHint: TEdit;
    WybierzHint: TEdit;
    AnulujHint: TEdit;
    TFirst: TEdit;
    TPrev: TEdit;
    TNext: TEdit;
    TLast: TEdit;
    Odswiez: TEdit;
    Eksportuj: TEdit;
    Configure: TEdit;
    EUpraw: TEdit;
    Zaawansowane: TTabSheet;
    Label9: TLabel;
    BEdytuj: TBitBtn;
    BDodaj: TBitBtn;
    BitBtn5: TBitBtn;
    BUsun: TBitBtn;
    BUsunAll: TBitBtn;
    BZamknij: TBitBtn;
    BSzukaj: TBitBtn;
    BWybierz: TBitBtn;
    BAnuluj: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn1: TBitBtn;
    BitBtn4: TBitBtn;
    BOdswiez: TBitBtn;
    Eksport: TBitBtn;
    BConfigure: TBitBtn;
    Upraw: TSpeedButton;
    Filtr: TSpeedButton;
    EFiltr: TEdit;
    OTHERS: TMemo;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Memo1: TMemo;
    Memo2: TMemo;
    BMODULPODSUMOWANIA: TSpeedButton;
    BModulZobrazowania: TSpeedButton;
    ESummariesModule: TEdit;
    EGraphModule: TEdit;
    SGGridLayout: TStringGrid;
    Holder: TStrHolder;
    BCopyToGrid: TBitBtn;
    BCopyFromGrid: TBitBtn;
    BOleExport: TBitBtn;
    EOleExport: TEdit;
    Memo3: TMemo;
    TabSheet1: TTabSheet;
    GroupBox3: TGroupBox;
    SQL: TMemo;
    BCrossCombination: TSpeedButton;
    ECrossCombination: TEdit;
    Memo4: TMemo;
    Panel1: TPanel;
    BitBtn6: TBitBtn;
    BLauchSQL: TBitBtn;
    BLaunchDiagnostics: TBitBtn;
    Adv: TCheckBox;
    procedure FormShow(Sender: TObject);
    procedure BFontChangeClick(Sender: TObject);
    procedure BCopyToGridClick(Sender: TObject);
    procedure BCopyFromGridClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BLauchSQLClick(Sender: TObject);
    procedure BLaunchDiagnosticsClick(Sender: TObject);
    procedure AdvClick(Sender: TObject);
  private
     flexContextName : string;
  public
    { Public declarations }
  end;

var
  FModuleConfigure: TFModuleConfigure;

Procedure Create ( aflexContextName : string );
Procedure Free;

implementation

{$R *.DFM}

Procedure Create ( aflexContextName : string );
Begin
 FModuleConfigure := TFModuleConfigure.Create(Application);
 FModuleConfigure.flexContextName := aflexContextName;
End;

Procedure Free;
Begin
 FModuleConfigure.Free;
End;

procedure TFModuleConfigure.FormShow(Sender: TObject);
begin
 If Page.ActivePage = TabMain Then ActiveControl := FormCaption;
 SGGridLayout.Cells[0,0] := Holder.Strings[0];
 SGGridLayout.Cells[1,0] := Holder.Strings[1];
 SGGridLayout.Cells[2,0] := Holder.Strings[2];
 SGGridLayout.Cells[3,0] := Holder.Strings[3];
 SGGridLayout.Cells[4,0] := Holder.Strings[4];
 BCopyToGridClick(nil);
 AdvClick(nil);
end;

procedure TFModuleConfigure.BFontChangeClick(Sender: TObject);
begin
  inherited;
 FDialog.Font := LGridFont.Font;
 If FDialog.Execute Then LGridFont.Font := FDialog.Font;
end;

procedure TFModuleConfigure.BCopyToGridClick(Sender: TObject);
Var t : Integer;
begin
  //@@@w zasadzie podobny mechanizm powinien byc przy sort order ! (obecnie sort order pokazuje dane z roznych fleksow)
  SGGridLayout.RowCount := GridLayout.LINES.Count + 1;
  for t := 0 To GridLayout.LINES.Count - 1 do begin
   try SGGridLayout.Cells[0,t+1] := ExtractWord(1,GridLayout.lines[t],['|']); except end; // field
   try SGGridLayout.Cells[1,t+1] := ExtractWord(2,GridLayout.lines[t],['|']); except end; // caption
   try SGGridLayout.Cells[2,t+1] := ExtractWord(3,GridLayout.lines[t],['|']); except end; // width
   try SGGridLayout.Cells[3,t+1] := ExtractWord(4,GridLayout.lines[t],['|']); except end; // CATEGORY:category name or CATEGORY:DEFAULT
   //hide items from other flexes
   if (ExtractWord(4,GridLayout.lines[t],['|']) <> 'CATEGORY:DEFAULT')
      and
      (ExtractWord(4,GridLayout.lines[t],['|']) <> 'CATEGORY:'+flexContextName)
   then
     SGGridLayout.RowHeights[t+1] := 0
   else
     SGGridLayout.RowHeights[t+1] := 20;
  end;
end;

procedure TFModuleConfigure.BCopyFromGridClick(Sender: TObject);
Var t : Integer;
begin
  inherited;
  GridLayout.LINES.Clear;
  For t := 1 To SGGridLayout.RowCount - 1 Do Begin
   GridLayout.lines.Add(
      SGGridLayout.Cells[0,t]+'|'+ // field
      SGGridLayout.Cells[1,t]+'|'+ // caption
      SGGridLayout.Cells[2,t]+'|'+ // width
      SGGridLayout.Cells[3,t]      // CATEGORY:category name or CATEGORY:DEFAULT
   );
  End;
end;

procedure TFModuleConfigure.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  BCopyfromGridClick(nil);
end;

procedure TFModuleConfigure.BLauchSQLClick(Sender: TObject);
begin
  inherited;
   ExecuteFileAndWait('trickSQL\trickSQL.exe');
end;

procedure TFModuleConfigure.BLaunchDiagnosticsClick(Sender: TObject);
begin
  inherited;
   ExecuteFileAndWait('MemoryStatus.exe');
End;

procedure TFModuleConfigure.AdvClick(Sender: TObject);
begin
  TabMain.TabVisible := Adv.Checked;
  TabPrzyciski.TabVisible := Adv.Checked;
  //TabLista
  TabFiltrowanie.TabVisible := Adv.Checked;
  Zaawansowane.TabVisible := Adv.Checked;
  TabSheet1.TabVisible := Adv.Checked;
end;

end.
