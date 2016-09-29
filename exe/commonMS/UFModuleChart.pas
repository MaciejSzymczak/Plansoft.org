unit UFModuleChart;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ComCtrls, Tabnotbk, TeEngine, TeeFunci, Series,
  ExtCtrls, TeeProcs, Chart, DBChart, Spin, ExtDlgs, Db, DBTables,DBGrids,
  StrHlder,GanttCh,BubbleCh, TeeShape, Menus, adodb;

type
  TFModuleChart = class(TForm)
    DBChart1: TDBChart;
    Zakladki: TTabbedNotebook;
    ListBox1: TListBox;
    ListBoxX: TListBox;
    Label1: TLabel;
    Label2: TLabel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    BitBtn5: TBitBtn;
    BitBtn6: TBitBtn;
    BitBtn7: TBitBtn;
    BitBtn10: TBitBtn;
    ColorDialog1: TColorDialog;
    FontDialog1: TFontDialog;
    Legenda: TGroupBox;
    Lwidoczna: TCheckBox;
    Label15: TLabel;
    LMargines: TSpinEdit;
    Lpolozenie: TRadioGroup;
    GroupBox2: TGroupBox;
    GWidoczny: TCheckBox;
    Label16: TLabel;
    GKEnd: TShape;
    Label17: TLabel;
    GKStart: TShape;
    GKierunek: TRadioGroup;
    Panel: TGroupBox;
    PObrazek: TBitBtn;
    Pstyl: TRadioGroup;
    Pwsrodku: TCheckBox;
    Margines: TGroupBox;
    Mgora: TSpinEdit;
    Mlewo: TSpinEdit;
    Mdol: TSpinEdit;
    Mprawo: TSpinEdit;
    Tytul: TGroupBox;
    Twidoczny: TCheckBox;
    TWyrownanie: TRadioGroup;
    Tczcionka: TBitBtn;
    Wymiar: TGroupBox;
    Label7: TLabel;
    WD3: TCheckBox;
    WPD3: TSpinEdit;
    Label8: TLabel;
    Opisosi: TGroupBox;
    Label3: TLabel;
    Otytul: TEdit;
    Oczcionka: TBitBtn;
    Osiatka: TCheckBox;
    Osie: TRadioGroup;
    Skala: TGroupBox;
    Sautomatyczna: TCheckBox;
    SautomatycznaX: TCheckBox;
    SautomatycznaY: TCheckBox;
    Label10: TLabel;
    Label11: TLabel;
    Panel1: TPanel;
    Zapisz: TBitBtn;
    Otworz: TBitBtn;
    Zamknij: TBitBtn;
    szczegoly: TCheckBox;
    TTytul: TMemo;
    BitBtn12: TBitBtn;
    BitBtn13: TBitBtn;
    BitBtn14: TBitBtn;
    OpenPictureDialog1: TOpenPictureDialog;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    SMax: TEdit;
    SMIN: TEdit;
    Widoczne: TCheckBox;
    OPokaz: TCheckBox;
    Label5: TLabel;
    ListBoxY: TListBox;
    StrHolder1: TStrHolder;
    TPolozenie: TSpinEdit;
    Label6: TLabel;
    Drukowanie: TGroupBox;
    DDruk: TBitBtn;
    DEksport: TBitBtn;
    PopupMenu1: TPopupMenu;
    Pokazszczeg1: TMenuItem;
    Eksportdopliku1: TMenuItem;
    Drukuj1: TMenuItem;
    OdswiezWyk: TBitBtn;
    PrintDialog1: TPrintDialog;
    procedure szczegolyClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure PObrazekClick(Sender: TObject);
    procedure PwsrodkuClick(Sender: TObject);
    procedure GWidocznyClick(Sender: TObject);
    procedure PstylClick(Sender: TObject);
    procedure PdlugoscChange(Sender: TObject);
    procedure LwidocznaClick(Sender: TObject);
    procedure LpolozenieClick(Sender: TObject);
    procedure GKStartMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure GKEndMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure GKierunekClick(Sender: TObject);
    procedure SautomatycznaClick(Sender: TObject);
    procedure SautomatycznaXClick(Sender: TObject);
    procedure SautomatycznaYClick(Sender: TObject);
    procedure SMaxChange(Sender: TObject);
    procedure SMINChange(Sender: TObject);
    procedure OPokazClick(Sender: TObject);
    procedure WidoczneClick(Sender: TObject);
    procedure OtytulChange(Sender: TObject);
    procedure OsiatkaClick(Sender: TObject);
    procedure OczcionkaClick(Sender: TObject);
    procedure MgoraChange(Sender: TObject);
    procedure MlewoChange(Sender: TObject);
    procedure MprawoChange(Sender: TObject);
    procedure MdolChange(Sender: TObject);
    procedure DDrukClick(Sender: TObject);
    procedure DEksportClick(Sender: TObject);
    procedure TwidocznyClick(Sender: TObject);
    procedure TTytulChange(Sender: TObject);
    procedure TWyrownanieClick(Sender: TObject);
    procedure TczcionkaClick(Sender: TObject);
    procedure WD3Click(Sender: TObject);
    procedure WPD3Change(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure BitBtn6Click(Sender: TObject);
    procedure BitBtn7Click(Sender: TObject);
    procedure BitBtn10Click(Sender: TObject);
    procedure BitBtn12Click(Sender: TObject);
    procedure BitBtn13Click(Sender: TObject);
    procedure BitBtn14Click(Sender: TObject);
    procedure LMarginesChange(Sender: TObject);
    procedure OsieClick(Sender: TObject);
    procedure TPolozenieChange(Sender: TObject);
    procedure ZapiszClick(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
    procedure ListBoxXDblClick(Sender: TObject);
    procedure ListBoxYDblClick(Sender: TObject);
    procedure OtworzClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Pokazszczeg1Click(Sender: TObject);
    procedure Eksportdopliku1Click(Sender: TObject);
    procedure Drukuj1Click(Sender: TObject);
    procedure OdswiezWykClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


function SaveChartToFile( MFullPath : string ) : Boolean;
function LoadChartFromFile( MFullPath : string ) : Boolean;
procedure MyShowChart( Q : TADOQuery; G : TDBGrid; T : string ; MyFullPath : String; Typ : String);
var
  FModuleChart: TFModuleChart;
  MWQ : TADOQuery;
  MWG : TDBGrid;
  PIC_SCIEZKA : string;
  TYP_WYK : string='0';

implementation

{$R *.DFM}
//uses Unit1;

procedure TFModuleChart.szczegolyClick(Sender: TObject);
begin
 Zakladki.Visible:=szczegoly.Checked;
end;

procedure TFModuleChart.FormShow(Sender: TObject);
begin
 FormResize(Nil);
 szczegolyClick(Nil);
end;

procedure TFModuleChart.PObrazekClick(Sender: TObject);
begin
if PObrazek.Caption='Obrazek w tle' then
 begin
  if OpenPictureDialog1.Execute then
   begin
    try
     DBChart1.BackImage.LoadFromFile(OpenPictureDialog1.FileName);
     PIC_SCIEZKA:=OpenPictureDialog1.FileName;
     PObrazek.Caption:='Wyczyœæ';
    except
     PIC_SCIEZKA:='';
    end;
   end;
 end
else
  begin
   try
    DBChart1.BackImage.LoadFromFile('');
   finally
    PObrazek.Caption:='Obrazek w tle';
    PIC_SCIEZKA:='';
   end;
  end;
end;

procedure TFModuleChart.PwsrodkuClick(Sender: TObject);
begin
 if Pwsrodku.Checked then
  begin
   DBChart1.BackImageInside:=True;
  end
 else
  begin
   DBChart1.BackImageInside:=False;
  end;
end;

procedure TFModuleChart.GWidocznyClick(Sender: TObject);
begin
 if GWidoczny.Checked then
  begin
   Label16.Enabled:=True;
   Label17.Enabled:=True;
   GKStart.Enabled:=True;
   GKEnd.Enabled:=True;
   GKierunek.Enabled:=True;
   DBChart1.Gradient.Visible:=True;
  end
 else
  begin
   //GKStart.Brush.Color:=clWhite;
   //DBChart1.Gradient.StartColor:=clWhite;
   //DBChart1.Gradient.EndColor:=clWhite;
   //GKEnd.Brush.Color:=clWhite;
   Label16.Enabled:=False;
   Label17.Enabled:=False;
   GKStart.Enabled:=False;
   GKEnd.Enabled:=False;
   GKierunek.Enabled:=False;
   DBChart1.Gradient.Visible:=False;
  end;
end;

procedure TFModuleChart.PstylClick(Sender: TObject);
begin
 if PStyl.ItemIndex=0 then
  DBChart1.BackImageMode:=pbmStretch;
 if PStyl.ItemIndex=1 then
  DBChart1.BackImageMode:=pbmTile;
 if PStyl.ItemIndex=2 then
  DBChart1.BackImageMode:=pbmCenter;
end;

procedure TFModuleChart.PdlugoscChange(Sender: TObject);
begin
 //PDlugosc.Value:=DBChart1.ChartWidth;
 //DBChart1.ChartWidth:=PDlugosc.Value;
end;

procedure TFModuleChart.LwidocznaClick(Sender: TObject);
begin
 if LWidoczna.Checked then
  begin
   Label15.Enabled:=True;
   LMargines.Enabled:=True;
   LPolozenie.Enabled:=True;
   DBChart1.Legend.Visible:=True;
  end
 else
  begin
   Label15.Enabled:=False;
   LMargines.Enabled:=False;
   LPolozenie.Enabled:=False;
   DBChart1.Legend.Visible:=False;
  end;
end;

procedure TFModuleChart.LpolozenieClick(Sender: TObject);
begin
 if LPolozenie.ItemIndex=0 then
  DBChart1.Legend.Alignment:=laRight;
 if LPolozenie.ItemIndex=2 then
  DBChart1.Legend.Alignment:=laTop;
 if LPolozenie.ItemIndex=1 then
  DBChart1.Legend.Alignment:=laLeft;
 if LPolozenie.ItemIndex=3 then
  DBChart1.Legend.Alignment:=laBottom;
end;

procedure TFModuleChart.GKStartMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
 if ColorDialog1.Execute then
  begin
   GKStart.Brush.Color:=ColorDialog1.Color;
   DBChart1.Gradient.StartColor:=GKStart.Brush.Color;
  end;
end;

procedure TFModuleChart.GKEndMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
 if ColorDialog1.Execute then
  begin
   GKEnd.Brush.Color:=ColorDialog1.Color;
   DBChart1.Gradient.EndColor:=GKEnd.Brush.Color;
  end;
end;

procedure TFModuleChart.GKierunekClick(Sender: TObject);
begin
{ @@@!!!
 if Gkierunek.ItemIndex=0 then
  DBChart1.Gradient.Direction:=gdLeftRight;
 if Gkierunek.ItemIndex=1 then
  DBChart1.Gradient.Direction:=gdRightLeft;
 if Gkierunek.ItemIndex=2 then
  DBChart1.Gradient.Direction:=gdTopBottom;
 if Gkierunek.ItemIndex=3 then
  DBChart1.Gradient.Direction:=gdBottomTop;}

end;


procedure TFModuleChart.SautomatycznaClick(Sender: TObject);
begin
 if Osie.ItemIndex=0 then
  begin
   if Sautomatyczna.Checked then
    begin
     Sautomatycznax.Enabled:=False;
     Sautomatycznay.Enabled:=False;
     DBChart1.LeftAxis.Automatic:=True;
     Sautomatycznax.Checked:=True;
     Sautomatycznay.Checked:=True;
    end
   else
    begin
     Sautomatycznax.Enabled:=True;
     Sautomatycznay.Enabled:=True;
     DBChart1.LeftAxis.Automatic:=False;
     Sautomatycznax.Checked:=False;
     Sautomatycznay.Checked:=False;
    end;
  end;

 if Osie.ItemIndex=1 then
  begin
   if Sautomatyczna.Checked then
    begin
     Sautomatycznax.Enabled:=False;
     Sautomatycznay.Enabled:=False;
     DBChart1.RightAxis.Automatic:=True;
     Sautomatycznax.Checked:=True;
     Sautomatycznay.Checked:=True;
    end
   else
    begin
     Sautomatycznax.Enabled:=True;
     Sautomatycznay.Enabled:=True;
     DBChart1.RightAxis.Automatic:=False;
     Sautomatycznax.Checked:=False;
     Sautomatycznay.Checked:=False;
    end;
  end;

 if Osie.ItemIndex=2 then
  begin
   if Sautomatyczna.Checked then
    begin
     Sautomatycznax.Enabled:=False;
     Sautomatycznay.Enabled:=False;
     DBChart1.TopAxis.Automatic:=True;
     Sautomatycznax.Checked:=True;
     Sautomatycznay.Checked:=True;
    end
   else
    begin
     Sautomatycznax.Enabled:=True;
     Sautomatycznay.Enabled:=True;
     DBChart1.TopAxis.Automatic:=False;
     Sautomatycznax.Checked:=False;
     Sautomatycznay.Checked:=False;
    end;
  end;

  if Osie.ItemIndex=3 then
  begin
   if Sautomatyczna.Checked then
    begin
     Sautomatycznax.Enabled:=False;
     Sautomatycznay.Enabled:=False;
     DBChart1.BottomAxis.Automatic:=True;
     Sautomatycznax.Checked:=True;
     Sautomatycznay.Checked:=True;
    end
   else
    begin
     Sautomatycznax.Enabled:=True;
     Sautomatycznay.Enabled:=True;
     DBChart1.BottomAxis.Automatic:=False;
     Sautomatycznax.Checked:=False;
     Sautomatycznay.Checked:=False;
    end;
  end;
end;

procedure TFModuleChart.SautomatycznaXClick(Sender: TObject);
begin
 if Osie.ItemIndex=0 then
  begin
   if SautomatycznaX.Checked then
    begin
     SMAX.Text:='';
     SMAX.Enabled:=False;
     Label10.Enabled:=False;
     DBChart1.LeftAxis.AutomaticMaximum:=True;
    end
   else
    begin
     SMAX.Enabled:=True;
     Label10.Enabled:=True;
     SMAX.Text:=FloatToStr(DBChart1.LeftAxis.Maximum);
     DBChart1.LeftAxis.AutomaticMaximum:=False;
    end;
  end;
 if Osie.ItemIndex=1 then
  begin
   if SautomatycznaX.Checked then
    begin
     SMAX.Text:='';
     SMAX.Enabled:=False;
     Label10.Enabled:=False;
     DBChart1.RightAxis.AutomaticMaximum:=True;
    end
   else
    begin
     SMAX.Enabled:=True;
     Label10.Enabled:=True ;
     SMAX.Text:=FloatToStr(DBChart1.RightAxis.Maximum);
     DBChart1.RightAxis.AutomaticMaximum:=False;
    end;
  end;
 if Osie.ItemIndex=2 then
  begin
   if SautomatycznaX.Checked then
    begin
     SMAX.Text:='';
     Label10.Enabled:=False;
     SMAX.Enabled:=False;
     DBChart1.TopAxis.AutomaticMaximum:=True;
    end
   else
    begin
     SMAX.Enabled:=True;
     Label10.Enabled:=True;
     SMAX.Text:=FloatToStr(DBChart1.TopAxis.Maximum);
     DBChart1.TopAxis.AutomaticMaximum:=False;
    end;
  end;
 if Osie.ItemIndex=3 then
  begin
   if SautomatycznaX.Checked then
    begin
     SMAX.Text:='';
     Label10.Enabled:=False;
     SMAX.Enabled:=False;
     DBChart1.BottomAxis.AutomaticMaximum:=True;
    end
   else
    begin
     SMAX.Enabled:=True;
     Label10.Enabled:=True;
     SMAX.Text:=FloatToStr(DBChart1.BottomAxis.Maximum);
     DBChart1.BottomAxis.AutomaticMaximum:=False;
    end;
  end;
end;

procedure TFModuleChart.SautomatycznaYClick(Sender: TObject);
begin
 if Osie.ItemIndex=0 then
  begin
   if SautomatycznaY.Checked then
    begin
     SMIN.Text:='';
     SMIN.Enabled:=False;
     Label11.Enabled:=False;
     DBChart1.LeftAxis.AutomaticMinimum:=True;
    end
   else
    begin
     SMIN.Enabled:=True;
     Label11.Enabled:=True;
     SMIN.Text:=FloatToStr(DBChart1.LeftAxis.Minimum);
     DBChart1.LeftAxis.AutomaticMinimum:=False;
    end;
  end;
 if Osie.ItemIndex=1 then
  begin
   if SautomatycznaY.Checked then
    begin
     SMIN.Text:='';
     SMIN.Enabled:=False;
     Label11.Enabled:=False;
     DBChart1.RightAxis.AutomaticMinimum:=True;
    end
   else
    begin
     SMIN.Enabled:=True;
     Label11.Enabled:=True;
     SMIN.Text:=FloatToStr(DBChart1.RightAxis.Minimum);
     DBChart1.RightAxis.AutomaticMinimum:=False;
    end;
  end;
 if Osie.ItemIndex=2 then
  begin
   if SautomatycznaY.Checked then
    begin
     SMIN.Text:='';
     SMIN.Enabled:=False;
     Label11.Enabled:=False;
     DBChart1.TopAxis.AutomaticMinimum:=True;
    end
   else
    begin
     SMIN.Enabled:=True;
     Label11.Enabled:=True;
     SMIN.Text:=FloatToStr(DBChart1.TopAxis.Minimum);
     DBChart1.TopAxis.AutomaticMinimum:=False;
    end;
  end;
 if Osie.ItemIndex=3 then
  begin
   if SautomatycznaY.Checked then
    begin
     SMIN.Text:='';
     SMIN.Enabled:=False;
     Label11.Enabled:=False;
     DBChart1.BottomAxis.AutomaticMinimum:=True;
    end
   else
    begin
     SMIN.Enabled:=True;
     Label11.Enabled:=True;
     SMIN.Text:=FloatToStr(DBChart1.BottomAxis.Minimum);
     DBChart1.BottomAxis.AutomaticMinimum:=False;
    end;
  end;
end;

procedure TFModuleChart.SMaxChange(Sender: TObject);
var
 a : double;
begin
if Osie.ItemIndex=0 then
 begin
  try
   a:=StrToFloat(SMAX.Text);
   DBChart1.LeftAxis.Maximum:=a;
  except
  end;
 end;
 if Osie.ItemIndex=1 then
 begin
  try
   a:=StrToFloat(SMAX.Text);
   DBChart1.RightAxis.Maximum:=a;
  except
  end;
 end;
 if Osie.ItemIndex=2 then
 begin
  try
   a:=StrToFloat(SMAX.Text);
   DBChart1.TopAxis.Maximum:=a;
  except
  end;
 end;
 if Osie.ItemIndex=3 then
 begin
  try
   a:=StrToFloat(SMAX.Text);
   DBChart1.BottomAxis.Maximum:=a;
  except
  end;
 end;
end;

procedure TFModuleChart.SMINChange(Sender: TObject);
var
 a : double;
begin
if Osie.ItemIndex=0 then
 begin
  try
   a:=StrToFloat(SMIN.Text);
   DBChart1.LeftAxis.Minimum:=a;
  except
  end;
 end;
 if Osie.ItemIndex=1 then
 begin
  try
   a:=StrToFloat(SMIN.Text);
   DBChart1.RightAxis.Minimum:=a;
  except
  end;
 end;
 if Osie.ItemIndex=2 then
 begin
  try
   a:=StrToFloat(SMIN.Text);
   DBChart1.TopAxis.Minimum:=a;
  except
  end;
 end;
 if Osie.ItemIndex=3 then
 begin
  try
   a:=StrToFloat(SMIN.Text);
   DBChart1.BottomAxis.Minimum:=a;
  except
  end;
 end;
end;

procedure TFModuleChart.OPokazClick(Sender: TObject);
begin
 if OPokaz.Checked then
  DBCHart1.AxisVisible:=True
 else
  DBCHart1.AxisVisible:=False;
end;

procedure TFModuleChart.WidoczneClick(Sender: TObject);
begin
 if Osie.ItemIndex=0 then
  begin
   if Widoczne.Checked then
    begin
     DBChart1.LeftAxis.Visible:=True;
     Label3.Enabled:=True;
     Otytul.Enabled:=True;
     Oczcionka.Enabled:=True;
     Osiatka.Enabled:=True;
    end
   else
    begin
     DBChart1.LeftAxis.Visible:=False;
     Label3.Enabled:=False;
     Otytul.Enabled:=False;
     Oczcionka.Enabled:=False;
     Osiatka.Enabled:=False;
    end;
  end;
 if Osie.ItemIndex=1 then
  begin
   if Widoczne.Checked then
    begin
     DBChart1.RightAxis.Visible:=True;
     Label3.Enabled:=True;
     Otytul.Enabled:=True;
     Oczcionka.Enabled:=True;
     Osiatka.Enabled:=True;
    end
   else
    begin
     DBChart1.RightAxis.Visible:=False;
     Label3.Enabled:=False;
     Otytul.Enabled:=False;
     Oczcionka.Enabled:=False;
     Osiatka.Enabled:=False;
    end;
  end;
 if Osie.ItemIndex=2 then
  begin
   if Widoczne.Checked then
    begin
     DBChart1.TopAxis.Visible:=True;
     Label3.Enabled:=True;
     Otytul.Enabled:=True;
     Oczcionka.Enabled:=True;
     Osiatka.Enabled:=True;
    end
   else
    begin
     DBChart1.TopAxis.Visible:=False;
     Label3.Enabled:=False;
     Otytul.Enabled:=False;
     Oczcionka.Enabled:=False;
     Osiatka.Enabled:=False;
    end;
  end;
 if Osie.ItemIndex=3 then
  begin
   if Widoczne.Checked then
    begin
     DBChart1.BottomAxis.Visible:=True;
     Label3.Enabled:=True;
     Otytul.Enabled:=True;
     Oczcionka.Enabled:=True;
     Osiatka.Enabled:=True;
    end
   else
    begin
     DBChart1.BottomAxis.Visible:=False;
     Label3.Enabled:=False;
     Otytul.Enabled:=False;
     Oczcionka.Enabled:=False;
     Osiatka.Enabled:=False;
    end;
  end;

end;

procedure TFModuleChart.OtytulChange(Sender: TObject);
begin
 if Osie.ItemIndex=0 then
  begin
   DBChart1.LeftAxis.Title.Caption:=OTytul.Text;
  end;

 if Osie.ItemIndex=1 then
  begin
   DBChart1.RightAxis.Title.Caption:=OTytul.Text;
  end;

 if Osie.ItemIndex=2 then
  begin
   DBChart1.TopAxis.Title.Caption:=OTytul.Text;
  end;

 if Osie.ItemIndex=3 then
  begin
   DBChart1.BottomAxis.Title.Caption:=OTytul.Text;
  end;
end;

procedure TFModuleChart.OsiatkaClick(Sender: TObject);
begin
 if Osie.ItemIndex=0 then
  begin
   DBChart1.LeftAxis.Grid.Visible:=Osiatka.Checked;
  end;

 if Osie.ItemIndex=1 then
  begin
   DBChart1.RightAxis.Grid.Visible:=Osiatka.Checked;
  end;

 if Osie.ItemIndex=2 then
  begin
   DBChart1.TopAxis.Grid.Visible:=Osiatka.Checked;
  end;

 if Osie.ItemIndex=3 then
  begin
   DBChart1.BottomAxis.Grid.Visible:=Osiatka.Checked;
  end;
end;


procedure TFModuleChart.OczcionkaClick(Sender: TObject);
begin
 if Osie.ItemIndex=0 then
   FontDialog1.Font.Assign(DBChart1.LeftAxis.Title.Font);
 if Osie.ItemIndex=1 then
   FontDialog1.Font.Assign(DBChart1.RightAxis.Title.Font);
 if Osie.ItemIndex=2 then
   FontDialog1.Font.Assign(DBChart1.TopAxis.Title.Font);
 if Osie.ItemIndex=3 then
   FontDialog1.Font.Assign(DBChart1.BottomAxis.Title.Font);

 if FontDialog1.Execute then
  begin
   if Osie.ItemIndex=0 then
    begin
     DBChart1.LeftAxis.Title.Font.Assign(FontDialog1.Font);
    end;
   if Osie.ItemIndex=1 then
    begin
     DBChart1.RightAxis.Title.Font.Assign(FontDialog1.Font);
    end;
   if Osie.ItemIndex=2 then
    begin
     DBChart1.TopAxis.Title.Font.Assign(FontDialog1.Font);
    end;
   if Osie.ItemIndex=3 then
    begin
     DBChart1.BottomAxis.Title.Font.Assign(FontDialog1.Font);
    end;
  end;
end;

procedure TFModuleChart.MgoraChange(Sender: TObject);
begin
 DBChart1.MarginTop:=Mgora.Value;
end;

procedure TFModuleChart.MlewoChange(Sender: TObject);
begin
 DBChart1.MarginLeft:=Mlewo.Value;
end;

procedure TFModuleChart.MprawoChange(Sender: TObject);
begin
 DBChart1.MarginRight:=Mprawo.Value;
end;

procedure TFModuleChart.MdolChange(Sender: TObject);
begin
 DBChart1.MarginBottom:=Mdol.Value;
end;

procedure TFModuleChart.DDrukClick(Sender: TObject);
begin
if PrintDialog1.Execute then DBChart1.Print;
end;

procedure TFModuleChart.DEksportClick(Sender: TObject);
begin
 SaveDialog1.DefaultExt:='bmp';
 SaveDialog1.Filter:='Plik BMP (*.BMP) |*.bmp|Plik WMF (*.WMF) |*.wmf|Plik EMF (*.emf) |*.emf';
 if SaveDialog1.Execute then
  begin
   try DBChart1.SaveToBitmapFile(SaveDialog1.FileName); except end;
  end;

end;

procedure TFModuleChart.TwidocznyClick(Sender: TObject);
begin
 if Twidoczny.Checked then
  begin
   TTytul.Enabled:=True;
   TCzcionka.Enabled:=True;
   TWyrownanie.Enabled:=True;
   DBChart1.Title.Visible:=True;
  end
 else
  begin
   TTytul.Enabled:=False;
   TCzcionka.Enabled:=False;
   TWyrownanie.Enabled:=False;
   DBChart1.Title.Visible:=False;
  end;
end;

procedure TFModuleChart.TTytulChange(Sender: TObject);
begin
 DBChart1.Title.Text.Clear;
 DBChart1.Title.Text.Assign(TTytul.lines);
 DBChart1.Title.Repaint;
end;

procedure TFModuleChart.TWyrownanieClick(Sender: TObject);
begin
 if TWyrownanie.ItemIndex=0 then
  DBChart1.Title.Alignment:=taLeftJustify;
 if TWyrownanie.ItemIndex=1 then
  DBChart1.Title.Alignment:=taCenter;
 if TWyrownanie.ItemIndex=2 then
  DBChart1.Title.Alignment:=taRightJustify;
end;

procedure TFModuleChart.TczcionkaClick(Sender: TObject);
begin
 FontDialog1.Font.Assign(DBChart1.Title.Font);
 if FontDialog1.execute then
  begin
    DBChart1.Title.Font.Assign(FontDialog1.Font);
  end;
end;

procedure TFModuleChart.WD3Click(Sender: TObject);
begin
 if WD3.Checked then
  begin
   DBChart1.View3D:=True;
   WPD3.Enabled:=True;
   Label7.Enabled:=True;
  end
 else
  begin
   DBChart1.View3D:=False;
   WPD3.Enabled:=False;
   Label7.Enabled:=False;
  end;
end;

procedure TFModuleChart.WPD3Change(Sender: TObject);
var
 a : integer;
begin
 try
  a:=WPD3.Value;
  DBChart1.Chart3DPercent:=a;
 except
 end;
end;

procedure TFModuleChart.BitBtn5Click(Sender: TObject);
var
 i : integer;
 SL : TLineSeries;
begin
 try
 if ((ListBoxX.Items.Count=1) or (ListBoxY.Items.Count=1)) then
 begin
 TYP_WYK:='1';
 if DBChart1.SeriesCount>0 then
  begin
   //DBChart1.RemoveSeries(DBChart1.Series[0]);
   DBChart1.Series[0].Destroy;
  end;
 SL:=TLineSeries.Create(self);
 DBChart1.AddSeries(SL);
 DBChart1.Series[0].Marks.Visible:=False;
 DBChart1.Series[0].ColorEachPoint:=True;
 DBChart1.Series[0].DataSource:=MWQ;
 if ListBoxX.Items.Count>0 then
  begin
   for i:=0 to MWQ.FieldCount-1 do
    begin
     if ListBoxX.Items[0]=MWQ.Fields[i].DisplayLabel then
      begin
       if (MWQ.Fields[i].DataType=ftInteger) or (MWQ.Fields[i].DataType=ftWord) or  (MWQ.Fields[i].DataType=ftFloat) then
        DBChart1.Series[0].XValues.ValueSource:=MWQ.Fields[i].FieldName;
       DBChart1.Series[0].XLabelsSource:=MWQ.Fields[i].FieldName;
      end;
    end;
  end;

 if ListBoxY.Items.Count>0 then
  begin
   for i:=0 to MWQ.FieldCount-1 do
    begin
     if ListBoxY.Items[0]=MWQ.Fields[i].DisplayLabel then
      DBChart1.Series[0].YValues.ValueSource:=MWQ.Fields[i].FieldName;
    end;
  end;
 end; 
 except
  TYP_WYK:='1';
 end;
end;

procedure TFModuleChart.BitBtn6Click(Sender: TObject);
var
 i : integer;
 SA :  TAreaSeries;
begin
 try
 if ((ListBoxX.Items.Count=1) or (ListBoxY.Items.Count=1)) then
 begin
 TYP_WYK:='2';
 if DBChart1.SeriesCount>0 then
  begin
   //DBChart1.RemoveSeries(DBChart1.Series[0]);
   DBChart1.Series[0].Destroy;
  end;
 SA:=TAreaSeries.Create(self);
 DBChart1.AddSeries(SA);
 DBChart1.Series[0].Marks.Visible:=False;
 DBChart1.Series[0].ColorEachPoint:=True;
 DBChart1.Series[0].DataSource:=MWQ;
 if ListBoxX.Items.Count>0 then
  begin
   for i:=0 to MWQ.FieldCount-1 do
    begin
     if ListBoxX.Items[0]=MWQ.Fields[i].DisplayLabel then
      begin
       if (MWQ.Fields[i].DataType=ftInteger) or (MWQ.Fields[i].DataType=ftWord) or  (MWQ.Fields[i].DataType=ftFloat) then
        DBChart1.Series[0].XValues.ValueSource:=MWQ.Fields[i].FieldName;
       DBChart1.Series[0].XLabelsSource:=MWQ.Fields[i].FieldName;
      end;
    end;
  end;
 if ListBoxY.Items.Count>0 then
  begin
   for i:=0 to MWQ.FieldCount-1 do
    begin
     if ListBoxY.Items[0]=MWQ.Fields[i].DisplayLabel then
      DBChart1.Series[0].YValues.ValueSource:=MWQ.Fields[i].FieldName;
    end;
  end;
 end; 
 except
  TYP_WYK:='2';
 end;
end;

procedure TFModuleChart.BitBtn7Click(Sender: TObject);
var
 i : integer;
 SB : TBarSeries;
begin
 try
 if ((ListBoxX.Items.Count=1) or (ListBoxY.Items.Count=1)) then
 begin
 TYP_WYK:='4';
 if DBChart1.SeriesCount>0 then
  begin
   //DBChart1.RemoveSeries(DBChart1.Series[0]);
   DBChart1.Series[0].Destroy;
  end;
 SB:=TBarSeries.Create(self);
 DBChart1.AddSeries(SB);
 //DBChart1.Series[0].Marks.Visible:=False;
 DBChart1.Series[0].ColorEachPoint:=True;
 DBChart1.Series[0].DataSource:=MWQ;
 if ListBoxX.Items.Count>0 then
  begin
   for i:=0 to MWQ.FieldCount-1 do
    begin
     if ListBoxX.Items[0]=MWQ.Fields[i].DisplayLabel then
      begin
       DBChart1.Series[0].XLabelsSource:=MWQ.Fields[i].FieldName;
       if (MWQ.Fields[i].DataType=ftInteger) or (MWQ.Fields[i].DataType=ftWord) or  (MWQ.Fields[i].DataType=ftFloat) then
        DBChart1.Series[0].XValues.ValueSource:=MWQ.Fields[i].FieldName;
      end;
    end;
  end;

 if ListBoxY.Items.Count>0 then
  begin
   for i:=0 to MWQ.FieldCount-1 do
    begin
     if ListBoxY.Items[0]=MWQ.Fields[i].DisplayLabel then
      DBChart1.Series[0].YValues.ValueSource:=MWQ.Fields[i].FieldName;
    end;
  end;
 end; 
 except
  TYP_WYK:='4';
 end;
end;

procedure TFModuleChart.BitBtn10Click(Sender: TObject);
var
 i : integer;
 SFL : TFastLineSeries;
begin
 try
 if ((ListBoxX.Items.Count=1) or (ListBoxY.Items.Count=1)) then
 begin
 TYP_WYK:='3';
 if DBChart1.SeriesCount>0 then
  begin
   //DBChart1.RemoveSeries(DBChart1.Series[0]);
   DBChart1.Series[0].Destroy;
  end;
 SFL:=TFastLineSeries.Create(self);
 DBChart1.AddSeries(SFL);
 DBChart1.Series[0].Marks.Visible:=False;
 DBChart1.Series[0].ColorEachPoint:=True;
 DBChart1.Series[0].DataSource:=MWQ;
 if ListBoxX.Items.Count>0 then
  begin
   for i:=0 to MWQ.FieldCount-1 do
    begin
     if ListBoxX.Items[0]=MWQ.Fields[i].DisplayLabel then
      begin
       if (MWQ.Fields[i].DataType=ftInteger) or (MWQ.Fields[i].DataType=ftWord) or  (MWQ.Fields[i].DataType=ftFloat) then
        DBChart1.Series[0].XValues.ValueSource:=MWQ.Fields[i].FieldName;
       DBChart1.Series[0].XLabelsSource:=MWQ.Fields[i].FieldName;
      end;
    end;
  end;

 if ListBoxY.Items.Count>0 then
  begin
   for i:=0 to MWQ.FieldCount-1 do
    begin
     if ListBoxY.Items[0]=MWQ.Fields[i].DisplayLabel then
      DBChart1.Series[0].YValues.ValueSource:=MWQ.Fields[i].FieldName;
    end;
  end;
 end; 
 except
  TYP_WYK:='3';
 end;
end;

procedure TFModuleChart.BitBtn12Click(Sender: TObject);
var
 i : integer;
 SHB : THorizBarSeries;
begin
 try
 if ((ListBoxX.Items.Count=1) or (ListBoxY.Items.Count=1)) then
 begin
 TYP_WYK:='6';
 if DBChart1.SeriesCount>0 then
  begin
   //DBChart1.RemoveSeries(DBChart1.Series[0]);
   DBChart1.Series[0].Destroy;
  end;
 SHB:=THorizBarSeries.Create(self);
 DBChart1.AddSeries(SHB);
 DBChart1.Series[0].Marks.Visible:=False;
 DBChart1.Series[0].ColorEachPoint:=True;
 DBChart1.Series[0].DataSource:=MWQ;
 if ListBoxX.Items.Count>0 then
  begin
   for i:=0 to MWQ.FieldCount-1 do
    begin
     if ListBoxX.Items[0]=MWQ.Fields[i].DisplayLabel then
      begin
       if (MWQ.Fields[i].DataType=ftInteger) or (MWQ.Fields[i].DataType=ftWord) or  (MWQ.Fields[i].DataType=ftFloat) then
        DBChart1.Series[0].XValues.ValueSource:=MWQ.Fields[i].FieldName;
       DBChart1.Series[0].XLabelsSource:=MWQ.Fields[i].FieldName;
      end;
    end;
  end;

 if ListBoxY.Items.Count>0 then
  begin
   for i:=0 to MWQ.FieldCount-1 do
    begin
     if ListBoxY.Items[0]=MWQ.Fields[i].DisplayLabel then
      DBChart1.Series[0].YValues.ValueSource:=MWQ.Fields[i].FieldName;
    end;
  end;
 end; 
 except
  TYP_WYK:='1';
 end;
end;

procedure TFModuleChart.BitBtn13Click(Sender: TObject);
var
 i : integer;
 SP : TPieSeries;
begin
try
 if ((ListBoxX.Items.Count=1) or (ListBoxY.Items.Count=1)) then
 begin
 TYP_WYK:='5';
 if DBChart1.SeriesCount>0 then
  begin
   //DBChart1.RemoveSeries(DBChart1.Series[0]);
   DBChart1.Series[0].Destroy;
  end;
 SP:=TPieSeries.Create(self);
 DBChart1.AddSeries(SP);
 DBChart1.Series[0].Marks.Visible:=False;
 DBChart1.Series[0].ColorEachPoint:=True;
 DBChart1.Series[0].DataSource:=MWQ;
 if ListBoxX.Items.Count>0 then
  begin
   for i:=0 to MWQ.FieldCount-1 do
    begin
     if ListBoxX.Items[0]=MWQ.Fields[i].DisplayLabel then
      begin
       if (MWQ.Fields[i].DataType=ftInteger) or (MWQ.Fields[i].DataType=ftWord) or  (MWQ.Fields[i].DataType=ftFloat) then
        DBChart1.Series[0].XValues.ValueSource:=MWQ.Fields[i].FieldName;
       DBChart1.Series[0].XLabelsSource:=MWQ.Fields[i].FieldName;
      end;
    end;
  end;

 if ListBoxY.Items.Count>0 then
  begin
   for i:=0 to MWQ.FieldCount-1 do
    begin
     if ListBoxY.Items[0]=MWQ.Fields[i].DisplayLabel then
      DBChart1.Series[0].YValues.ValueSource:=MWQ.Fields[i].FieldName;
    end;
  end;
 end; 
 except
  TYP_WYK:='1';
 end;
end;

procedure TFModuleChart.BitBtn14Click(Sender: TObject);
var
 i : integer;
 SPS : TPointSeries;
begin
 try
 if ((ListBoxX.Items.Count=1) or (ListBoxY.Items.Count=1)) then
 begin
 TYP_WYK:='7';
 if DBChart1.SeriesCount>0 then
  begin
   //DBChart1.RemoveSeries(DBChart1.Series[0]);
   DBChart1.Series[0].Destroy;
  end;
 SPS:=TPointSeries.Create(self);
 DBChart1.AddSeries(SPS);
 DBChart1.Series[0].Marks.Visible:=False;
 DBChart1.Series[0].ColorEachPoint:=True;
 DBChart1.Series[0].DataSource:=MWQ;
 if ListBoxX.Items.Count>0 then
  begin
   for i:=0 to MWQ.FieldCount-1 do
    begin
     if ListBoxX.Items[0]=MWQ.Fields[i].DisplayLabel then
      begin
       if (MWQ.Fields[i].DataType=ftInteger) or (MWQ.Fields[i].DataType=ftWord) or  (MWQ.Fields[i].DataType=ftFloat) then
        DBChart1.Series[0].XValues.ValueSource:=MWQ.Fields[i].FieldName;
       DBChart1.Series[0].XLabelsSource:=MWQ.Fields[i].FieldName;
      end;
    end;
  end;

 if ListBoxY.Items.Count>0 then
  begin
   for i:=0 to MWQ.FieldCount-1 do
    begin
     if ListBoxY.Items[0]=MWQ.Fields[i].DisplayLabel then
      DBChart1.Series[0].YValues.ValueSource:=MWQ.Fields[i].FieldName;
    end;
  end;
 end; 
 except
 TYP_WYK:='1';
 end;
end;

function SaveChartToFile( MFullPath : string ) : Boolean;
var
 i : integer;
 fi : TextFile;
 s : string;
 t_font : shortint;
 l :  real;
begin
 try
  with FModuleChart do
   begin
    AssignFile(fi,MFullPath);
    Rewrite(fi);
    writeln(fi,MWQ.FieldCount);
    for i:=0 to MWQ.FieldCount-1 do
     begin
      writeln(fi,MWQ.Fields[i].FieldName);
     end;
    writeln(fi,TYP_WYK);
    if szczegoly.Checked then
     writeln(fi,1)
    else
     writeln(fi,0);
    writeln(fi,DBChart1.MarginLeft);
    writeln(fi,DBChart1.MarginRight);
    writeln(fi,DBChart1.MarginTop);
    writeln(fi,DBChart1.MarginBottom);
    if DBChart1.View3d then
     writeln(fi,1)
    else
     writeln(fi,0);
    writeln(fi,DBChart1.Chart3DPercent);
    if DBChart1.Title.Visible then
     writeln(fi,1)
    else
     writeln(fi,0);
    //writeln(fi,DEksportujdo.ItemIndex);

    writeln(fi,DBChart1.Title.Font.PixelsPerInch);
    writeln(fi,ABS(DBChart1.Title.Font.Height));
    writeln(fi,DBChart1.Title.Font.Color);
    writeln(fi,DBChart1.Title.Font.Size);
    t_font:=0;
    if fsBold in DBChart1.Title.Font.Style then t_font:=t_font+1;
    if fsItalic in DBChart1.Title.Font.Style then t_font:=t_font+2;
    if fsUnderline in DBChart1.Title.Font.Style then t_font:=t_font+4;
    if fsStrikeOut in DBChart1.Title.Font.Style then t_font:=t_font+8;
    s:=IntToStr(t_font);
    writeln(fi,s);
    writeln(fi,DBChart1.Title.Font.Name);
    writeln(fi,DBChart1.Title.Font.Charset);

    writeln(fi,DBChart1.Title.Text.Count);
    for i:=0 to DBChart1.Title.Text.Count-1 do
     writeln(fi,DBChart1.Title.Text.Strings[i]);
    if DBChart1.Title.Alignment=taLeftJustify then
     writeln(fi,0)
    else if DBChart1.Title.Alignment=taRightJustify then
     writeln(fi,2)
    else
     writeln(fi,1);
    //Osie
    writeln(fi,Osie.ItemIndex);
    if DBChart1.AxisVisible then
     writeln(fi,1)
    else
     writeln(fi,0);
    if DBChart1.LeftAxis.Visible then
     writeln(fi,1)
    else
     writeln(fi,0);
    if DBChart1.LeftAxis.Grid.Visible then
     writeln(fi,1)
    else
     writeln(fi,0);
    writeln(fi,DBChart1.LeftAxis.Title.Caption);
    writeln(fi,DBChart1.LeftAxis.Title.Angle);
    writeln(fi,DBChart1.LeftAxis.Title.Font.PixelsPerInch);
    writeln(fi,ABS(DBChart1.LeftAxis.Title.Font.Height));
    writeln(fi,DBChart1.LeftAxis.Title.Font.Color);
    writeln(fi,DBChart1.LeftAxis.Title.Font.Size);
    t_font:=0;
    if fsBold in DBChart1.LeftAxis.Title.Font.Style then t_font:=t_font+1;
    if fsItalic in DBChart1.LeftAxis.Title.Font.Style then t_font:=t_font+2;
    if fsUnderline in DBChart1.LeftAxis.Title.Font.Style then t_font:=t_font+4;
    if fsStrikeOut in DBChart1.LeftAxis.Title.Font.Style then t_font:=t_font+8;
    s:=IntToStr(t_font);
    writeln(fi,s);
    writeln(fi,DBChart1.LeftAxis.Title.Font.Name);
    writeln(fi,DBChart1.LeftAxis.Title.Font.Charset);
    l:=DBChart1.LeftAxis.Maximum;
    writeln(fi,FormatFloat('0.00',l));
    l:=DBChart1.LeftAxis.Minimum;
    writeln(fi,FormatFloat('0.00',l));
    if DBChart1.LeftAxis.Automatic then
     writeln(fi,1)
    else
     writeln(fi,0);
    if DBChart1.LeftAxis.AutomaticMaximum then
     writeln(fi,1)
    else
     writeln(fi,0);
    if DBChart1.LeftAxis.AutomaticMinimum then
     writeln(fi,1)
    else
     writeln(fi,0);


    if DBChart1.RightAxis.Visible then
     writeln(fi,1)
    else
     writeln(fi,0);
    if DBChart1.RightAxis.Grid.Visible then
     writeln(fi,1)
    else
     writeln(fi,0);
    writeln(fi,DBChart1.RightAxis.Title.Caption);
    writeln(fi,DBChart1.RightAxis.Title.Angle);
    writeln(fi,DBChart1.RightAxis.Title.Font.PixelsPerInch);
    writeln(fi,ABS(DBChart1.RightAxis.Title.Font.Height));
    writeln(fi,DBChart1.RightAxis.Title.Font.Color);
    writeln(fi,DBChart1.RightAxis.Title.Font.Size);
    t_font:=0;
    if fsBold in DBChart1.RightAxis.Title.Font.Style then t_font:=t_font+1;
    if fsItalic in DBChart1.RightAxis.Title.Font.Style then t_font:=t_font+2;
    if fsUnderline in DBChart1.RightAxis.Title.Font.Style then t_font:=t_font+4;
    if fsStrikeOut in DBChart1.RightAxis.Title.Font.Style then t_font:=t_font+8;
    s:=IntToStr(t_font);
    writeln(fi,s);
    writeln(fi,DBChart1.RightAxis.Title.Font.Name);
    writeln(fi,DBChart1.RightAxis.Title.Font.Charset);
    l:=DBChart1.RightAxis.Maximum;
    writeln(fi,FormatFloat('0.00',l));
    l:=DBChart1.RightAxis.Minimum;
    writeln(fi,FormatFloat('0.00',l));
    if DBChart1.RightAxis.Automatic then
     writeln(fi,1)
    else
     writeln(fi,0);
    if DBChart1.RightAxis.AutomaticMaximum then
     writeln(fi,1)
    else
     writeln(fi,0);
    if DBChart1.RightAxis.AutomaticMinimum then
     writeln(fi,1)
    else
     writeln(fi,0);

    if DBChart1.TopAxis.Visible then
     writeln(fi,1)
    else
     writeln(fi,0);
    if DBChart1.TopAxis.Grid.Visible then
     writeln(fi,1)
    else
     writeln(fi,0);
    writeln(fi,DBChart1.TopAxis.Title.Caption);
    writeln(fi,DBChart1.TopAxis.Title.Angle);
    writeln(fi,DBChart1.TopAxis.Title.Font.PixelsPerInch);
    writeln(fi,ABS(DBChart1.TopAxis.Title.Font.Height));
    writeln(fi,DBChart1.TopAxis.Title.Font.Color);
    writeln(fi,DBChart1.TopAxis.Title.Font.Size);
    t_font:=0;
    if fsBold in DBChart1.TopAxis.Title.Font.Style then t_font:=t_font+1;
    if fsItalic in DBChart1.TopAxis.Title.Font.Style then t_font:=t_font+2;
    if fsUnderline in DBChart1.TopAxis.Title.Font.Style then t_font:=t_font+4;
    if fsStrikeOut in DBChart1.TopAxis.Title.Font.Style then t_font:=t_font+8;
    s:=IntToStr(t_font);
    writeln(fi,s);
    writeln(fi,DBChart1.TopAxis.Title.Font.Name);
    writeln(fi,DBChart1.TopAxis.Title.Font.Charset);
    l:=DBChart1.TopAxis.Maximum;
    writeln(fi,FormatFloat('0.00',l));
    l:=DBChart1.TopAxis.Minimum;
    writeln(fi,FormatFloat('0.00',l));
    if DBChart1.TopAxis.Automatic then
     writeln(fi,1)
    else
     writeln(fi,0);
    if DBChart1.TopAxis.AutomaticMaximum then
     writeln(fi,1)
    else
     writeln(fi,0);
    if DBChart1.TopAxis.AutomaticMinimum then
     writeln(fi,1)
    else
     writeln(fi,0);

    if DBChart1.BottomAxis.Visible then
     writeln(fi,1)
    else
     writeln(fi,0);
    if DBChart1.BottomAxis.Grid.Visible then
     writeln(fi,1)
    else
     writeln(fi,0);
    writeln(fi,DBChart1.BottomAxis.Title.Caption);
    writeln(fi,DBChart1.BottomAxis.Title.Angle);
    writeln(fi,DBChart1.BottomAxis.Title.Font.PixelsPerInch);
    writeln(fi,ABS(DBChart1.BottomAxis.Title.Font.Height));
    writeln(fi,DBChart1.BottomAxis.Title.Font.Color);
    writeln(fi,DBChart1.BottomAxis.Title.Font.Size);
    t_font:=0;
    if fsBold in DBChart1.BottomAxis.Title.Font.Style then t_font:=t_font+1;
    if fsItalic in DBChart1.BottomAxis.Title.Font.Style then t_font:=t_font+2;
    if fsUnderline in DBChart1.BottomAxis.Title.Font.Style then t_font:=t_font+4;
    if fsStrikeOut in DBChart1.BottomAxis.Title.Font.Style then t_font:=t_font+8;
    s:=IntToStr(t_font);
    writeln(fi,s);
    writeln(fi,DBChart1.BottomAxis.Title.Font.Name);
    writeln(fi,DBChart1.BottomAxis.Title.Font.Charset);
    l:=DBChart1.BottomAxis.Maximum;
    writeln(fi,FormatFloat('0.00',l));
    l:=DBChart1.BottomAxis.Minimum;
    writeln(fi,FormatFloat('0.00',l));
    if DBChart1.BottomAxis.Automatic then
     writeln(fi,1)
    else
     writeln(fi,0);
    if DBChart1.BottomAxis.AutomaticMaximum then
     writeln(fi,1)
    else
     writeln(fi,0);
    if DBChart1.BottomAxis.AutomaticMinimum then
     writeln(fi,1)
    else
     writeln(fi,0);
    //Legenda
    if DBChart1.Legend.Visible then
     writeln(fi,1)
    else
     writeln(fi,0);
    writeln(fi,LMargines.Value);
    writeln(fi,LPolozenie.ItemIndex);
    //Panel
    //writeln(fi,PDlugosc.Value);
    if DBChart1.BackImageInside then
     writeln(fi,1)
    else
     writeln(fi,0);
    writeln(fi,PIC_SCIEZKA);
    writeln(fi,PStyl.ItemIndex);
    //Gradient
    if DBChart1.Gradient.Visible then
     writeln(fi,1)
    else
     writeln(fi,0);
    writeln(fi,DBChart1.Gradient.StartColor);
    writeln(fi,DBChart1.Gradient.EndColor);
    writeln(fi,GKierunek.ItemIndex);
    writeln(fi,ListBox1.Items.Count);
    if ListBox1.Items.count>0 then
     begin
      for i:=0 to ListBox1.Items.Count-1 do
       begin
        writeln(fi,ListBox1.Items[i])
       end;
     end;
    writeln(fi,ListBoxX.Items.Count);
    if ListBoxX.Items.count>0 then
     begin
      for i:=0 to ListBoxX.Items.Count-1 do
       begin
        writeln(fi,ListBoxX.Items[i])
       end;
     end;
    writeln(fi,ListBoxY.Items.Count);
    if ListBoxY.Items.count>0 then
     begin
      for i:=0 to ListBoxY.Items.Count-1 do
       begin
        writeln(fi,ListBoxY.Items[i])
       end;
     end;
    CloseFile(fi);
    SaveChartToFile:=True;
   end;
  except
   SaveChartToFile:=False;
  end;
end;

function CheckQuery( var Mfile : TextFile ; NumberOfField : integer ) : Boolean;
var
 i,j : integer;
 s : string;
 w : Boolean;
 wp : Boolean;
begin
 wp:=True;
 for i:=1 to  NumberOfField do
  begin
   readln(Mfile,s);
   j:=0;
   w:=False;
   while j<MWQ.FieldCount do
    begin
     if MWQ.Fields[j].FieldName=s then
      begin
       w:=True;
       j:=MWQ.FieldCount;
      end;
     j:=j+1;
    end;
   if w=False then
    wp:=False;
  end;
  if wp then
   Result:=True
  else
   Result:=False;
end;

function LoadChartFromFile(MFullPath : string) : Boolean;
var
 i,j : integer;
 fi : TextFile;
 s,s1 : string;
 t_font : shortint;
begin
 try
   AssignFile(fi,MFullPath);
   Reset(fi);
   readln(fi,s);
   if CheckQuery(fi,StrToInt(s)) then
    begin
    with FModuleChart do
     begin
//--------------
      readln(fi,s);
      TYP_WYK:=s;
      readln(fi,s);
      if s='1' then
       szczegoly.Checked:=True
      else
       szczegoly.Checked:=False;
      readln(fi,s);
      Mlewo.Value:=StrTOInt(s);
      readln(fi,s);
      Mprawo.Value:=StrTOInt(s);
      readln(fi,s);
      Mgora.Value:=StrTOInt(s);
      readln(fi,s);
      Mdol.Value:=StrTOInt(s);
      readln(fi,s);
      if s='1' then
       WD3.Checked:=True
      else
       WD3.Checked:=False;
      readln(fi,s);
      WPD3.Value:=StrTOInt(s);
      readln(fi,s);
      if s='1' then
       Twidoczny.Checked:=True
      else
       Twidoczny.Checked:=False;
      readln(fi,s);
      //DEksportujdo.ItemIndex:=StrToInt(s);

      readln(fi,s);
      DBChart1.Title.Font.PixelsPerInch:=StrTOInt(s);
      readln(fi,s);
      DBChart1.Title.Font.Height:=-1*StrTOInt(s);
      readln(fi,s);
      DBChart1.Title.Font.Color:=StrTOInt(s);
      readln(fi,s);
      DBChart1.Title.Font.Size:=StrTOInt(s);
      readln(fi,s);
      t_font:=StrToInt(s);
      if (t_font AND 1)=1 then DBChart1.Title.Font.Style:=DBChart1.Title.Font.Style + [fsBold];
      if (t_font AND 2)=2 then DBChart1.Title.Font.Style:=DBChart1.Title.Font.Style + [fsItalic] ;
      if (t_font AND 4)=4 then DBChart1.Title.Font.Style:=DBChart1.Title.Font.Style + [fsUnderline];
      if (t_font AND 8)=8 then DBChart1.Title.Font.Style:=DBChart1.Title.Font.Style + [fsStrikeOut];
      readln(fi,s);
      DBChart1.Title.Font.Name:=s;
      readln(fi,s);
      DBChart1.Title.Font.Charset:=StrTOInt(s);

      readln(fi,s);
      j:=StrTOInt(s);
      Ttytul.Lines.Clear;
      for i:=0 to j-1 do
       begin
        readln(fi,s);
        Ttytul.Lines.Add(s);
       end;
      readln(fi,s);
      if s='0' then
       Twyrownanie.ItemIndex:=0
      else if s='1' then
       Twyrownanie.ItemIndex:=1
      else
       Twyrownanie.ItemIndex:=2;
      //Osie
      readln(fi,s);
      Osie.ItemIndex:=StrToInt(s);
      s1:=s;
      readln(fi,s);
      if s='1' then
       Opokaz.Checked:=True
      else
       Opokaz.Checked:=False;
      readln(fi,s);
      if s='1' then
       DBChart1.LeftAxis.Visible:=True
      else
       DBChart1.LeftAxis.Visible:=False;
      readln(fi,s);
      if s='1' then
       DBChart1.LeftAxis.Grid.Visible:=True
      else
       DBChart1.LeftAxis.Grid.Visible:=False;

      readln(fi,s);
      DBChart1.LeftAxis.Title.Caption:=s;
      readln(fi,s);
      DBChart1.LeftAxis.Title.Angle:=StrToInt(s);
      readln(fi,s);
      DBChart1.LeftAxis.Title.Font.PixelsPerInch:=StrToInt(s);
      readln(fi,s);
      DBChart1.LeftAxis.Title.Font.Height:=StrToInt(s);
      readln(fi,s);
      DBChart1.LeftAxis.Title.Font.Color:=StrToInt(s);
      readln(fi,s);
      DBChart1.LeftAxis.Title.Font.Size:=StrToInt(s);
      readln(fi,s);
      t_font:=StrToInt(s);
      if (t_font AND 1)=1 then DBChart1.LeftAxis.Title.Font.Style:=DBChart1.LeftAxis.Title.Font.Style + [fsBold];
      if (t_font AND 2)=2 then DBChart1.LeftAxis.Title.Font.Style:=DBChart1.LeftAxis.Title.Font.Style + [fsItalic] ;
      if (t_font AND 4)=4 then DBChart1.LeftAxis.Title.Font.Style:=DBChart1.LeftAxis.Title.Font.Style + [fsUnderline];
      if (t_font AND 8)=8 then DBChart1.LeftAxis.Title.Font.Style:=DBChart1.LeftAxis.Title.Font.Style + [fsStrikeOut];
      readln(fi,s);
      DBChart1.LeftAxis.Title.Font.Name:=s;
      readln(fi,s);
      DBChart1.LeftAxis.Title.Font.Charset:=StrToInt(s);
      readln(fi,s);
      DBChart1.LeftAxis.Maximum:=StrToFloat(s);
      readln(fi,s);
      DBChart1.LeftAxis.Minimum:=StrToFloat(s);
      readln(fi,s);
      if s='1' then
       DBChart1.LeftAxis.Automatic:=True
      else
       DBChart1.LeftAxis.Automatic:=False;
      readln(fi,s);
      if s='1' then
       DBChart1.LeftAxis.AutomaticMaximum:=True
      else
       DBChart1.LeftAxis.AutomaticMaximum:=False;
      readln(fi,s);
      if s='1' then
       DBChart1.LeftAxis.AutomaticMinimum:=True
      else
       DBChart1.LeftAxis.AutomaticMinimum:=False;

      readln(fi,s);
      if s='1' then
       DBChart1.RightAxis.Visible:=True
      else
       DBChart1.RightAxis.Visible:=False;
      readln(fi,s);
      if s='1' then
       DBChart1.RightAxis.Grid.Visible:=True
      else
       DBChart1.RightAxis.Grid.Visible:=False;

      readln(fi,s);
      DBChart1.RightAxis.Title.Caption:=s;
      readln(fi,s);
      DBChart1.RightAxis.Title.Angle:=StrToInt(s);
      readln(fi,s);
      DBChart1.RightAxis.Title.Font.PixelsPerInch:=StrToInt(s);
      readln(fi,s);
      DBChart1.RightAxis.Title.Font.Height:=StrToInt(s);
      readln(fi,s);
      DBChart1.RightAxis.Title.Font.Color:=StrToInt(s);
      readln(fi,s);
      DBChart1.RightAxis.Title.Font.Size:=StrToInt(s);
      readln(fi,s);
      t_font:=StrToInt(s);
      if (t_font AND 1)=1 then DBChart1.RightAxis.Title.Font.Style:=DBChart1.RightAxis.Title.Font.Style + [fsBold];
      if (t_font AND 2)=2 then DBChart1.RightAxis.Title.Font.Style:=DBChart1.RightAxis.Title.Font.Style + [fsItalic] ;
      if (t_font AND 4)=4 then DBChart1.RightAxis.Title.Font.Style:=DBChart1.RightAxis.Title.Font.Style + [fsUnderline];
      if (t_font AND 8)=8 then DBChart1.RightAxis.Title.Font.Style:=DBChart1.RightAxis.Title.Font.Style + [fsStrikeOut];
      readln(fi,s);
      DBChart1.RightAxis.Title.Font.Name:=s;
      readln(fi,s);
      DBChart1.RightAxis.Title.Font.Charset:=StrToInt(s);
      readln(fi,s);
      DBChart1.RightAxis.Maximum:=StrToFloat(s);
      readln(fi,s);
      DBChart1.RightAxis.Minimum:=StrToFloat(s);
      readln(fi,s);
      if s='1' then
       DBChart1.RightAxis.Automatic:=True
      else
       DBChart1.RightAxis.Automatic:=False;
      readln(fi,s);
      if s='1' then
       DBChart1.RightAxis.AutomaticMaximum:=True
      else
       DBChart1.RightAxis.AutomaticMaximum:=False;
      readln(fi,s);
      if s='1' then
       DBChart1.RightAxis.AutomaticMinimum:=True
      else
       DBChart1.RightAxis.AutomaticMinimum:=False;

      readln(fi,s);
      if s='1' then
       DBChart1.TopAxis.Visible:=True
      else
       DBChart1.TopAxis.Visible:=False;
      readln(fi,s);
      if s='1' then
       DBChart1.TopAxis.Grid.Visible:=True
      else
       DBChart1.TopAxis.Grid.Visible:=False;

      readln(fi,s);
      DBChart1.TopAxis.Title.Caption:=s;
      readln(fi,s);
      DBChart1.TopAxis.Title.Angle:=StrToInt(s);
      readln(fi,s);
      DBChart1.TopAxis.Title.Font.PixelsPerInch:=StrToInt(s);
      readln(fi,s);
      DBChart1.TopAxis.Title.Font.Height:=StrToInt(s);
      readln(fi,s);
      DBChart1.TopAxis.Title.Font.Color:=StrToInt(s);
      readln(fi,s);
      DBChart1.TopAxis.Title.Font.Size:=StrToInt(s);
      readln(fi,s);
      t_font:=StrToInt(s);
      if (t_font AND 1)=1 then DBChart1.TopAxis.Title.Font.Style:=DBChart1.TopAxis.Title.Font.Style + [fsBold];
      if (t_font AND 2)=2 then DBChart1.TopAxis.Title.Font.Style:=DBChart1.TopAxis.Title.Font.Style + [fsItalic] ;
      if (t_font AND 4)=4 then DBChart1.TopAxis.Title.Font.Style:=DBChart1.TopAxis.Title.Font.Style + [fsUnderline];
      if (t_font AND 8)=8 then DBChart1.TopAxis.Title.Font.Style:=DBChart1.TopAxis.Title.Font.Style + [fsStrikeOut];
      readln(fi,s);
      DBChart1.TopAxis.Title.Font.Name:=s;
      readln(fi,s);
      DBChart1.TopAxis.Title.Font.Charset:=StrToInt(s);
      readln(fi,s);
      DBChart1.TopAxis.Maximum:=StrToFloat(s);
      readln(fi,s);
      DBChart1.TopAxis.Minimum:=StrToFloat(s);
      readln(fi,s);
      if s='1' then
       DBChart1.TopAxis.Automatic:=True
      else
       DBChart1.TopAxis.Automatic:=False;
      readln(fi,s);
      if s='1' then
       DBChart1.TopAxis.AutomaticMaximum:=True
      else
       DBChart1.TopAxis.AutomaticMaximum:=False;
      readln(fi,s);
      if s='1' then
       DBChart1.TopAxis.AutomaticMinimum:=True
      else
       DBChart1.TopAxis.AutomaticMinimum:=False;

      readln(fi,s);
      if s='1' then
       DBChart1.BottomAxis.Visible:=True
      else
       DBChart1.BottomAxis.Visible:=False;
      readln(fi,s);
      if s='1' then
       DBChart1.BottomAxis.Grid.Visible:=True
      else
       DBChart1.BottomAxis.Grid.Visible:=False;

      readln(fi,s);
      DBChart1.BottomAxis.Title.Caption:=s;
      readln(fi,s);
      DBChart1.BottomAxis.Title.Angle:=StrToInt(s);
      readln(fi,s);
      DBChart1.BottomAxis.Title.Font.PixelsPerInch:=StrToInt(s);
      readln(fi,s);
      DBChart1.BottomAxis.Title.Font.Height:=StrToInt(s);
      readln(fi,s);
      DBChart1.BottomAxis.Title.Font.Color:=StrToInt(s);
      readln(fi,s);
      DBChart1.BottomAxis.Title.Font.Size:=StrToInt(s);
      readln(fi,s);
      t_font:=StrToInt(s);
      if (t_font AND 1)=1 then DBChart1.BottomAxis.Title.Font.Style:=DBChart1.BottomAxis.Title.Font.Style + [fsBold];
      if (t_font AND 2)=2 then DBChart1.BottomAxis.Title.Font.Style:=DBChart1.BottomAxis.Title.Font.Style + [fsItalic] ;
      if (t_font AND 4)=4 then DBChart1.BottomAxis.Title.Font.Style:=DBChart1.BottomAxis.Title.Font.Style + [fsUnderline];
      if (t_font AND 8)=8 then DBChart1.BottomAxis.Title.Font.Style:=DBChart1.BottomAxis.Title.Font.Style + [fsStrikeOut];
      readln(fi,s);
      DBChart1.BottomAxis.Title.Font.Name:=s;
      readln(fi,s);
      DBChart1.BottomAxis.Title.Font.Charset:=StrToInt(s);
      readln(fi,s);
      DBChart1.BottomAxis.Maximum:=StrToFloat(s);
      readln(fi,s);
      DBChart1.BottomAxis.Minimum:=StrToFloat(s);
      readln(fi,s);
      if s='1' then
       DBChart1.BottomAxis.Automatic:=True
      else
       DBChart1.BottomAxis.Automatic:=False;
      readln(fi,s);
      if s='1' then
       DBChart1.BottomAxis.AutomaticMaximum:=True
      else
       DBChart1.BottomAxis.AutomaticMaximum:=False;
      readln(fi,s);
      if s='1' then
       DBChart1.BottomAxis.AutomaticMinimum:=True
      else
       DBChart1.BottomAxis.AutomaticMinimum:=False;
      if s1='0' then
       begin
        Widoczne.Checked:=DBChart1.LeftAxis.Visible;
        Osiatka.Checked:=DBChart1.LeftAxis.Grid.Visible;
        Otytul.Text:=DBChart1.LeftAxis.Title.Caption;
        Tpolozenie.Value:=DBChart1.LeftAxis.Title.Angle;
       end;
      if s1='1' then
       begin
        Widoczne.Checked:=DBChart1.RightAxis.Visible;
        Osiatka.Checked:=DBChart1.RightAxis.Grid.Visible;
        Otytul.Text:=DBChart1.RightAxis.Title.Caption;
        Tpolozenie.Value:=DBChart1.RightAxis.Title.Angle;
       end;
      if s1='2' then
       begin
        Widoczne.Checked:=DBChart1.TopAxis.Visible;
        Osiatka.Checked:=DBChart1.TopAxis.Grid.Visible;
        Otytul.Text:=DBChart1.TopAxis.Title.Caption;
        Tpolozenie.Value:=DBChart1.TopAxis.Title.Angle;
       end;
      if s1='3' then
       begin
        Widoczne.Checked:=DBChart1.BottomAxis.Visible;
        Osiatka.Checked:=DBChart1.BottomAxis.Grid.Visible;
        Otytul.Text:=DBChart1.BottomAxis.Title.Caption;
        Tpolozenie.Value:=DBChart1.BottomAxis.Title.Angle;
       end;
      //Legenda
      readln(fi,s);
      if s='1' then
       Lwidoczna.Checked:=True
      else
       Lwidoczna.Checked:=False;
      readln(fi,s);
      LMargines.Value:=StrTOInt(s);
      readln(fi,s);
      LPolozenie.ItemIndex:=StrTOInt(s);
      //Panel
      //readln(fi,s);
      //PDlugosc.Value:=StrTOInt(s);
      readln(fi,s);
      if s='1' then
       begin
        DBChart1.BackImageInside:=True;
        Pwsrodku.Checked:=True;
       end
      else
       begin
        DBChart1.BackImageInside:=False;
        Pwsrodku.Checked:=False;
       end;
      readln(fi,PIC_SCIEZKA);
      if PIC_SCIEZKA<>'' then
       begin
        try
         DBChart1.BackImage.LoadFromFile(PIC_SCIEZKA);
        except
        end;
       end;
      readln(fi,s);
      PStyl.ItemIndex:=StrToInt(s);
      //Gradient
      readln(fi,s);
      if s='1' then
       GWidoczny.Checked:=True
      else
       GWidoczny.Checked:=False;
      readln(fi,s);
      DBChart1.Gradient.StartColor:=StrToInt(s);
      GKStart.Brush.Color:=StrToInt(s);
      readln(fi,s);
      DBChart1.Gradient.EndColor:=StrToInt(s);
      GKEnd.Brush.Color:=StrToInt(s);
      readln(fi,s);
      GKierunek.ItemIndex:=StrToInt(s);
      readln(fi,s);
      j:=StrToInt(s);
      if j>0 then
       begin
        for i:=0 to j-1 do
         begin
          readln(fi,s);
          StrHolder1.Strings.Add(s);
         end;
       end;
      ListBox1.Items.Clear;
      ListBox1.Items.Assign(StrHolder1.Strings);
      readln(fi,s);
      j:=StrToInt(s);
      if (j>0) and (ListBoxX.Items.Count=0) then
       begin
        for i:=0 to j-1 do
         begin
          readln(fi,s);
          ListBoxX.Items.Add(s);
         end;
       end;
      readln(fi,s);
      j:=StrToInt(s);
      if (j>0) and (ListBoxY.Items.Count=0) then
       begin
        for i:=0 to j-1 do
         begin
          readln(fi,s);
          ListBoxY.Items.Add(s);
         end;
       end;
      if TYP_WYK='1' then
       BitBtn5Click(nil);
      if TYP_WYK='2' then
       BitBtn6Click(nil);
      if TYP_WYK='3' then
       BitBtn10Click(nil);
      if TYP_WYK='4' then
       BitBtn7Click(nil);
      if TYP_WYK='5' then
       BitBtn13Click(nil);
      if TYP_WYK='6' then
       BitBtn12Click(nil);
      if TYP_WYK='7' then
       BitBtn14Click(nil);
//--------------
      end;
     CloseFile(fi);
     LoadChartFromFile:=True;
    end
   else
    begin
     CloseFile(fi);
     ShowMessage('Plik konfiguracyjny nie odpowiada wybranemu wykresowi');
     Result:=False;
    end;
 except
  Result:=False;
 end;
end;

procedure MyShowChart( Q : TADOQuery; G : TDBGrid; T : string ; MyFullPath : String; Typ : String);
var
 i,j : integer;
begin
 MWQ:=Q;
 if G<>nil then MWG:=G;
 try
  FModuleChart:=TFModuleChart.Create(nil);
  if G<>nil then
  begin
  for i:=0 to MWQ.FieldCount-1 do
   begin
    j:=0;
    while j<MWG.Columns.Count-1 do
     begin
      if MWQ.Fields[i].FieldName=MWG.Columns[j].FieldName then
       begin
         MWQ.Fields[i].DisplayLabel:=MWG.Columns[j].Title.Caption;
         j:=MWG.Columns.Count;
       end;
       j:=j+1;
     end;
   end;
   end;
  if not LoadChartFromFile(MyFullPath) then
  begin
   for i:=0 to MWQ.FieldCount-1 do
    begin
     if typ='Numeryczne' then
      begin
       if (MWQ.Fields[i].DataType=ftInteger) or (MWQ.Fields[i].DataType=ftWord) or  (MWQ.Fields[i].DataType=ftFloat) then
        FModuleChart.StrHolder1.Strings.Add(MWQ.Fields[i].DisplayLabel);
      end
     else
      FModuleChart.StrHolder1.Strings.Add(MWQ.Fields[i].DisplayLabel);
    end;
   FModuleChart.ListBox1.Items.Assign(FModuleChart.StrHolder1.Strings);
   FModuleChart.DBChart1.Title.Text.Clear;
   FModuleChart.TTytul.Lines.Clear;
   FModuleChart.TTytul.Lines.Add(T);
   FModuleChart.Widoczne.Checked:=FModuleChart.DBChart1.LeftAxis.Visible;
   FModuleChart.Osiatka.Checked:=FModuleChart.DBChart1.LeftAxis.Grid.Visible;
   FModuleChart.Tpolozenie.Value:=FModuleChart.DBChart1.LeftAxis.Title.Angle;
   FModuleChart.OTytul.Text:=FModuleChart.DBChart1.LeftAxis.Title.Caption;
  end;
  FModuleChart.ShowModal;
  SaveChartToFile(MyFullPath);
  PIC_SCIEZKA:='';
 finally
  FModuleChart.Destroy;
 end;
end;

procedure TFModuleChart.Button1Click(Sender: TObject);
begin
 if (ListBox1.Items.Count>0) and (ListBoxX.Items.count<1) then
  begin
   try
    ListBoxX.Items.Add(ListBox1.Items.Strings[ListBox1.ItemIndex]);
    ListBox1.Items.Delete(ListBox1.ItemIndex);
   except
   end;
  end;
end;

procedure TFModuleChart.Button3Click(Sender: TObject);
begin
try
if ListBoxX.Items.Count>0 then
 begin
  StrHolder1.Strings.Clear;
  StrHolder1.Strings.Assign(ListBox1.Items);
  StrHolder1.Strings.Add(ListBoxX.Items.Strings[ListBoxX.ItemIndex]);
  ListBox1.Items.Clear;
  ListBox1.Items.Assign(StrHolder1.Strings);
  ListBoxX.Items.Delete(ListBoxX.ItemIndex);
 end;
except
end;
end;

procedure TFModuleChart.Button2Click(Sender: TObject);
begin
 if (ListBox1.Items.Count>0) and (ListBoxY.Items.count<1) then
  begin
   try
    ListBoxY.Items.Add(ListBox1.Items.Strings[ListBox1.ItemIndex]);
    ListBox1.Items.Delete(ListBox1.ItemIndex);
   except
   end;
  end;
end;

procedure TFModuleChart.Button4Click(Sender: TObject);
begin
try
if ListBoxY.Items.Count>0 then
 begin
  StrHolder1.Strings.Clear;
  StrHolder1.Strings.Assign(ListBox1.Items);
  StrHolder1.Strings.Add(ListBoxY.Items.Strings[ListBoxY.ItemIndex]);
  ListBox1.Items.Clear;
  ListBox1.Items.Assign(StrHolder1.Strings);
  ListBoxY.Items.Delete(ListBoxY.ItemIndex);
 end;
except
end;
end;


procedure TFModuleChart.LMarginesChange(Sender: TObject);
begin
 if (Lpolozenie.ItemIndex=0) or (Lpolozenie.ItemIndex=1) then
  DBChart1.Legend.HorizMargin:=LMargines.Value
 else
  DBChart1.Legend.VertMargin:=LMargines.Value;
end;

procedure TFModuleChart.OsieClick(Sender: TObject);
begin
 if Osie.ItemIndex=0 then
  begin
   Widoczne.Checked:=DBChart1.LeftAxis.Visible;
   OTytul.Text:=DBChart1.LeftAxis.Title.Caption;
   OSiatka.Checked:=DBChart1.LeftAxis.Grid.Visible;
   TPolozenie.value:=DBChart1.LeftAxis.Title.Angle;
   SAutomatyczna.Checked:=DBChart1.LeftAxis.Automatic;
   SAutomatycznaX.Checked:=DBChart1.LeftAxis.AutomaticMaximum;
   SAutomatycznaY.Checked:=DBChart1.LeftAxis.AutomaticMinimum;
  end;
 if Osie.ItemIndex=1 then
  begin
   Widoczne.Checked:=DBChart1.RightAxis.Visible;
   OTytul.Text:=DBChart1.RightAxis.Title.Caption;
   OSiatka.Checked:=DBChart1.RightAxis.Grid.Visible;
   TPolozenie.value:=DBChart1.RightAxis.Title.Angle;
   SAutomatyczna.Checked:=DBChart1.RightAxis.Automatic;
   SAutomatycznaX.Checked:=DBChart1.RightAxis.AutomaticMaximum;
   SAutomatycznaY.Checked:=DBChart1.RightAxis.AutomaticMinimum;
  end;
 if Osie.ItemIndex=2 then
  begin
   Widoczne.Checked:=DBChart1.TopAxis.Visible;
   OTytul.Text:=DBChart1.TopAxis.Title.Caption;
   OSiatka.Checked:=DBChart1.TopAxis.Grid.Visible;
   TPolozenie.value:=DBChart1.TopAxis.Title.Angle;
   SAutomatyczna.Checked:=DBChart1.TopAxis.Automatic;
   SAutomatycznaX.Checked:=DBChart1.TopAxis.AutomaticMaximum;
   SAutomatycznaY.Checked:=DBChart1.TopAxis.AutomaticMinimum;
  end;
 if Osie.ItemIndex=3 then
  begin
   Widoczne.Checked:=DBChart1.BottomAxis.Visible;
   OTytul.Text:=DBChart1.BottomAxis.Title.Caption;
   OSiatka.Checked:=DBChart1.BottomAxis.Grid.Visible;
   TPolozenie.value:=DBChart1.BottomAxis.Title.Angle;
   SAutomatyczna.Checked:=DBChart1.BottomAxis.Automatic;
   SAutomatycznaX.Checked:=DBChart1.BottomAxis.AutomaticMaximum;
   SAutomatycznaY.Checked:=DBChart1.BottomAxis.AutomaticMinimum;
  end;
end;


procedure TFModuleChart.TPolozenieChange(Sender: TObject);
begin
 if Osie.ItemIndex=0 then
  DBChart1.LeftAxis.Title.Angle:=TPolozenie.value;
 if Osie.ItemIndex=1 then
  DBChart1.RightAxis.Title.Angle:=TPolozenie.value;
 if Osie.ItemIndex=2 then
  DBChart1.TopAxis.Title.Angle:=TPolozenie.value;
 if Osie.ItemIndex=3 then
  DBChart1.BottomAxis.Title.Angle:=TPolozenie.value;

end;

procedure TFModuleChart.ZapiszClick(Sender: TObject);
begin
 SaveDialog1.DefaultExt:='*.wyk';
 SaveDialog1.Filter:='Plik konfiguracyjny (*.WYK) |*.WYK';
 if SaveDialog1.Execute then
  begin
   SaveChartToFile(SaveDialog1.FileName);
  end;
end;

procedure TFModuleChart.ListBox1DblClick(Sender: TObject);
begin
 if (ListBox1.Items.Count>0) and (ListBoxY.Items.count<1) then
  begin
   try
    ListBoxY.Items.Add(ListBox1.Items.Strings[ListBox1.ItemIndex]);
    ListBox1.Items.Delete(ListBox1.ItemIndex);
   except
   end;
  end
 else if (ListBox1.Items.Count>0) and (ListBoxX.Items.count<1) then
  begin
   try
    ListBoxX.Items.Add(ListBox1.Items.Strings[ListBox1.ItemIndex]);
    ListBox1.Items.Delete(ListBox1.ItemIndex);
   except
   end;
  end;
end;

procedure TFModuleChart.ListBoxXDblClick(Sender: TObject);
begin
try
if ListBoxX.Items.Count>0 then
 begin
  StrHolder1.Strings.Clear;
  StrHolder1.Strings.Assign(ListBox1.Items);
  StrHolder1.Strings.Add(ListBoxX.Items.Strings[ListBoxX.ItemIndex]);
  ListBox1.Items.Clear;
  ListBox1.Items.Assign(StrHolder1.Strings);
  ListBoxX.Items.Delete(ListBoxX.ItemIndex);
 end;
except
end;
end;

procedure TFModuleChart.ListBoxYDblClick(Sender: TObject);
begin
try
if ListBoxY.Items.Count>0 then
 begin
  StrHolder1.Strings.Clear;
  StrHolder1.Strings.Assign(ListBox1.Items);
  StrHolder1.Strings.Add(ListBoxY.Items.Strings[ListBoxY.ItemIndex]);
  ListBox1.Items.Clear;
  ListBox1.Items.Assign(StrHolder1.Strings);
  ListBoxY.Items.Delete(ListBoxY.ItemIndex);
 end;
except
end;
end;

procedure TFModuleChart.OtworzClick(Sender: TObject);
begin
 OpenDialog1.DefaultExt:='*.wyk';
 OpenDialog1.Filter:='Plik konfiguracyjny (*.WYK) |*.WYK';
 if OpenDialog1.Execute then
  begin
   LoadChartFromFile(OpenDialog1.FileName);
  end;
end;


procedure TFModuleChart.FormResize(Sender: TObject);
begin
 if FModuleChart.Width>540 then
  begin
   Zamknij.Left:=FModuleChart.Width-110;
   Otworz.Left:=FModuleChart.Width-210;
   Zapisz.Left:=FModuleChart.Width-310;
   OdswiezWyk.Left:=FModuleChart.Width-410;
  end;
end;

procedure TFModuleChart.Pokazszczeg1Click(Sender: TObject);
begin
 if szczegoly.Checked then
  szczegoly.Checked:=False
 else
  szczegoly.Checked:=True;
end;

procedure TFModuleChart.Eksportdopliku1Click(Sender: TObject);
begin
 SaveDialog1.DefaultExt:='*.bmp';
 SaveDialog1.Filter:='Plik BMP (*.BMP) |*.BMP';
 if SaveDialog1.Execute then
  begin
   try
    DBChart1.SaveToBitmapFile(SaveDialog1.FileName);
   except
   end;
  end;
end;

procedure TFModuleChart.Drukuj1Click(Sender: TObject);
begin
 DDrukClick(Nil);
end;

procedure TFModuleChart.OdswiezWykClick(Sender: TObject);
var
 i : integer;
begin
if (DBChart1.SeriesCount>0) and ((ListBoxX.Items.Count=1) or (ListBoxY.Items.Count=1)) then
 begin
 DBChart1.Series[0].DataSource:=nil;
 DBChart1.Series[0].XValues.ValueSource:='';
 DBChart1.Series[0].YValues.ValueSource:='';
 DBChart1.Series[0].DataSource:=MWQ;
 DBChart1.LeftAxis.Automatic:=True;
 DBChart1.RightAxis.Automatic:=True;
 DBChart1.TopAxis.Automatic:=True;
 DBChart1.BottomAxis.Automatic:=True;
 if ListBoxX.Items.Count>0 then
  begin
   for i:=0 to MWQ.FieldCount-1 do
    begin
     if ListBoxX.Items[0]=MWQ.Fields[i].DisplayLabel then
      begin
       if (MWQ.Fields[i].DataType=ftInteger) or (MWQ.Fields[i].DataType=ftWord) or  (MWQ.Fields[i].DataType=ftFloat) then
        DBChart1.Series[0].XValues.ValueSource:=MWQ.Fields[i].FieldName;
       DBChart1.Series[0].XLabelsSource:=MWQ.Fields[i].FieldName;
      end;
    end;
  end;

 if ListBoxY.Items.Count>0 then
  begin
   for i:=0 to MWQ.FieldCount-1 do
    begin
     if ListBoxY.Items[0]=MWQ.Fields[i].DisplayLabel then
      DBChart1.Series[0].YValues.ValueSource:=MWQ.Fields[i].FieldName;
    end;
  end;
 DBChart1.Series[0].Repaint;
 DBChart1.Repaint;
 end;
end; 

End.
