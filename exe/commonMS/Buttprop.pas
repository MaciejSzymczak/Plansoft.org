unit ButtProp;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons, DB, DBTables, Grids, DBGrids, ListaBat, Spin,
  ExtDlgs, IntlFunc;

type
  TDButtProp = class(TForm)
    Dwa: TGroupBox;
    Podpowiedz: TEdit;
    Raz: TGroupBox;
    Naglowek: TEdit;
    Trzy: TGroupBox;
    Lokal: TRadioGroup;
    AddBitmap: TBitBtn;
    ResTitle: TGroupBox;
    Panel1: TPanel;
    OK: TBitBtn;
    Anuluj: TBitBtn;
    SB: TScrollBox;
    REZULTAT: TComboBox;
    DBG: TDBGrid;
    DS: TDataSource;
    MARGINES: TSpinEdit;
    StaticText1: TStaticText;
    Stt: TStaticText;
    NGlyphs: TSpinEdit;
    FD: TFontDialog;
    OPD: TOpenPictureDialog;
    RESEDIT: TEdit;
    Font: TBitBtn;
    StaticText2: TStaticText;
    POKAZRYS: TRadioGroup;
    procedure FormCreate(Sender: TObject);
    procedure NaglowekChange(Sender: TObject);
    procedure PodpowiedzChange(Sender: TObject);
    procedure FontClick(Sender: TObject);
    procedure NGlyphsChange(Sender: TObject);
    procedure LokalClick(Sender: TObject);
    procedure MARGINESChange(Sender: TObject);
    procedure REZULTATDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure OKClick(Sender: TObject);
    procedure AddBitmapClick(Sender: TObject);
    procedure DBGEnter(Sender: TObject);
    procedure DBGExit(Sender: TObject);
    procedure DBGDblClick(Sender: TObject);
    procedure POKAZRYSClick(Sender: TObject);
  private
    { Private declarations }
  public
    B:TLBitBtn;
    DF:TField;
    FQuery:TQuery;
    FTable:TTable;
    Kind:WORD;
    VF:TField;
  end;

var
  DButtProp: TDButtProp;

implementation

{$R *.DFM}

procedure TDButtProp.FormCreate(Sender: TObject);
begin
  DBG.Columns[0].Width:=DBG.Width-GetSystemMetrics(SM_CXVSCROLL)-4;
  SetCaptionsEx('ITLLIB1.DLL',1,self);
  B:=TLBitBtn.Create(SB);
  B.Parent:=SB;
  B.Width:=SB.Width-20;
  B.FixedHeight:=0;
  B.Show;
end;

procedure TDButtProp.NaglowekChange(Sender: TObject);
begin
  B.Caption:=Naglowek.Text;
end;

procedure TDButtProp.PodpowiedzChange(Sender: TObject);
begin
  B.Hint:=Podpowiedz.Text;
end;

procedure TDButtProp.FontClick(Sender: TObject);
begin
  FD.Font.Assign(B.Font);
  if FD.Execute then begin
    B.Font.Assign(FD.Font);
    B.CalcHeight;
  end;
end;

procedure TDButtProp.NGlyphsChange(Sender: TObject);
begin
  if NGlyphs.Value<>B.NumGlyphs then B.NumGlyphs:=NGlyphs.Value;
end;

procedure TDButtProp.LokalClick(Sender: TObject);
begin
  if Lokal.ItemIndex<>Ord(B.Layout) then begin
    B.Layout:=TButtonLayout(Lokal.ItemIndex);
    B.CalcHeight;
  end;
end;

procedure TDButtProp.MARGINESChange(Sender: TObject);
begin
  try
    if Margines.Value<>B.Margins then begin
      B.Margins:=Margines.Value;
      B.CalcHeight;
    end;
  except
    Margines.Value:=0;
    B.Margins:=0;
    B.CalcHeight;
  end;
end;

procedure TDButtProp.REZULTATDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var L:STRING;
    i:WORD;
begin
  L:=REZULTAT.Items[Index];
  i:=Pos('=',L);
  if i<>0 then L:=Copy(L,1,i-1);
  with REZULTAT.Canvas do begin
    TextRect(Rect,Rect.Left,Rect.Top,L);
  end;
end;

procedure TDButtProp.OKClick(Sender: TObject);
var L:STRING;
begin
  case Kind of
    0:begin
      //Result - ComboBox
      if REZULTAT.ItemIndex<>-1 then
        L:=REZULTAT.Items.Values[REZULTAT.Items.Names[REZULTAT.ItemIndex]]
      else begin
        if IntlMessageboxEx('ITLLIB1.DLL',64001,64002,MB_YESNO+MB_TASKMODAL+MB_ICONQUESTION)=IDNO then exit;
        L:='';
      end;
    end;
    1,2:L:=VF.AsString;
    3:L:=RESEDIT.Text;
  end;  
  B.Result_:=L;
  ModalResult:=mrOK;
end;

procedure TDButtProp.AddBitmapClick(Sender: TObject);
begin
  if OPD.Execute then begin
    B.BitmapFile:=OPD.FileName;
    B.Glyph.LoadFromFile(OPD.FileName);
    NGlyphs.Value:=1;
    B.CalcHeight;
  end;
end;

procedure TDButtProp.DBGEnter(Sender: TObject);
begin
  ResTitle.Height:=74;
  DBG.Height:=57;
end;

procedure TDButtProp.DBGExit(Sender: TObject);
begin
  ResTitle.Height:=41;
  DBG.Height:=21;
end;

procedure TDButtProp.DBGDblClick(Sender: TObject);
begin
  OK.SetFocus;
end;

procedure TDButtProp.POKAZRYSClick(Sender: TObject);
begin
  if POKAZRYS.ItemIndex=1 then begin
    B.BitmapFile:='';
    B.Glyph:=NIL;
    NGlyphs.Value:=1;
    B.CalcHeight;
    AddBitmap.Enabled:=FALSE;
  end else AddBitmap.Enabled:=TRUE;
end;

end.
