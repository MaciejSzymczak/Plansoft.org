unit UFModulePrint;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons,Quickrpt,QRCtrls,Db,DBTables,DBGrids,
  UFModulePrintAdvanced, StrHlder,Printers, ADODB;

type
  TFModulePrint = class(TForm)
    Bevel1: TBevel;
    Label1: TLabel;
    Label2: TLabel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Label3: TLabel;
    Shape1: TShape;
    Shape2: TShape;
    Shape3: TShape;
    Shape4: TShape;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    ListBox1: TListBox;
    ListBox2: TListBox;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    Edit1: TEdit;
    Edit2: TEdit;
    BitBtn5: TBitBtn;
    BitBtn6: TBitBtn;
    BitBtn7: TBitBtn;
    BitBtn8: TBitBtn;
    FontDialog1: TFontDialog;
    ColorDialog1: TColorDialog;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    StrHolder: TStrHolder;
    StrHolder1: TStrHolder;
    MemoStopka: TMemo;
    Label11: TLabel;
    GroupBox1: TGroupBox;
    MemoAdres: TMemo;
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    BitBtn9: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn2: TBitBtn;
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure ListBox2EndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure Edit1Change(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure Shape1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Shape2MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Shape3MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Shape4MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure BitBtn5Click(Sender: TObject);
    procedure BitBtn7Click(Sender: TObject);
    procedure BitBtn6Click(Sender: TObject);
    procedure BitBtn8Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure BitBtn9Click(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
    procedure ListBox2DblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  procedure Exportuj(Q : TADOQuery ; G : TDBGrid; Title : string;MFullPath : string);
const
 wf=8;
var
  FModulePrint: TFModulePrint;
  //Czcionki uzywane przy budowie raportu
  //1-Nag³ówek,2-Tytó³,3-Nag³ówek kolumny,4-Stopka,5-Defaul(elementy raportu
  F  : array [1..6] of TFont;
  //Colory
  C  : array [1..6] of TColor;
  //Teksty
  T : array [1..5] of string;
  MQ : TADOQuery;
  MG : TDBGrid;
implementation

{$R *.DFM}

Uses UUtilityParent;

procedure TFModulePrint.Button1Click(Sender: TObject);
begin
 if FontDialog1.Execute then
  F[2].Assign(FontDialog1.Font)
end;

function SaveToFile( MFullPath : string ) : Boolean;
var
 i,j,z : integer;
 fi : TextFile;
 s : string;
 t_font : shortint;
begin
 try
   AssignFile(fi,MFullPath);
   Rewrite(fi);
   writeln(fi,MQ.FieldCount);
   for i:=0 to MQ.FieldCount-1 do
    begin
     writeln(fi,MQ.Fields[i].FieldName);
    end;
   writeln(fi,FModulePrint.MemoAdres.Lines.Count);
   for i:=0 to FModulePrint.MemoAdres.Lines.Count-1 do
    writeln(fi,FModulePrint.MemoAdres.Lines[i]);
   if OK_DATA_ADRES then
    writeln(fi,'1')
   else
    writeln(fi,'0');
   if OK_G_KRESKA then
    writeln(fi,'1')
   else
    writeln(fi,'0');
   if OK_D_KRESKA then
    writeln(fi,'1')
   else
    writeln(fi,'0');
   if OK_LP then
    writeln(fi,'1')
   else
    writeln(fi,'0');
   if OK_OPZ then
    writeln(fi,'1')
   else
    writeln(fi,'0');
   if OK_ICO then
    writeln(fi,'1')
   else
    writeln(fi,'0');
   writeln(fi,ICO_SCIEZKA);
   writeln(fi,CENT_N);
   writeln(fi,CENT_S);
   for i:=1 to 5 do
    begin
     t_font:=0;
     if FModulePrint.CheckBox1.Checked then
      writeln(fi,1)
     else
      writeln(fi,0);
     if FModulePrint.CheckBox2.Checked then
      writeln(fi,1)
     else
      writeln(fi,0);
     writeln(fi,F[i].PixelsPerInch);
     writeln(fi,ABS(F[i].Height));
     writeln(fi,F[i].Color);
     writeln(fi,F[i].Size);
     if fsBold in F[i].Style then t_font:=t_font+1;
     if fsItalic in F[i].Style then t_font:=t_font+2;
     if fsUnderline in F[i].Style then t_font:=t_font+4;
     if fsStrikeOut in F[i].Style then t_font:=t_font+8;
     s:=IntToStr(t_font);
     writeln(fi,s);
     writeln(fi,F[i].Name);
     writeln(fi,F[i].Charset);
     writeln(fi,C[i]);
     writeln(fi,T[i]);
     if i=4 then
      begin
       writeln(fi,FModulePrint.MemoStopka.Lines.Count);
       for z:=0 to FModulePrint.MemoStopka.Lines.Count-1 do
        writeln(fi,FModulePrint.MemoStopka.Lines[z]);
      end
    end;
   writeln(fi,FModulePrint.ListBox1.Items.Count);
   for i:=0 to FModulePrint.ListBox1.Items.Count-1 do
    begin
     writeln(fi,FModulePrint.ListBox1.Items.Strings[i]);
     j:=0;
     while j<=MQ.FieldCount-1 do
      begin
       if MQ.Fields[j].DisplayLabel=FModulePrint.ListBox1.Items.Strings[i] then
        begin
         writeln(fi,MQ.Fields[j].FieldName);
         writeln(fi,MQ.Fields[j].DisplayWidth);
         j:=MQ.FieldCount;
        end;
        j:=j+1;
      end;
    end;
   writeln(fi,FModulePrint.ListBox2.Items.Count);
   for i:=0 to FModulePrint.ListBox2.Items.Count-1 do
    begin
     writeln(fi,FModulePrint.ListBox2.Items.Strings[i]);
     for j:=0 to MQ.FieldCount-1 do
      begin
       if MQ.Fields[j].DisplayLabel=FModulePrint.ListBox2.Items.Strings[i] then
        begin
         writeln(fi,MQ.Fields[j].FieldName);
         writeln(fi,MQ.Fields[j].DisplayWidth);
        end;
      end;
    end;
   CloseFile(fi);
   SaveToFile:=True;
  except
   SaveToFile:=False;
  end;
end;

procedure TFModulePrint.Button3Click(Sender: TObject);
begin
 if FModulePrint.SaveDialog1.Execute then
  begin
   SaveToFile(FModulePrint.SaveDialog1.FileName);
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
   while j<MQ.FieldCount do
    begin
     if MQ.Fields[j].FieldName=s then
      begin
       w:=True;
       j:=MQ.FieldCount;
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

function LoadFromFile(MFullPath : string) : Boolean;
var
 i,j,z,zz : integer;
 fi : TextFile;
 s,s1,s2 : string;
 FC : integer;
 t_font : shortint;
begin
 try
  AssignFile(fi,MFullPath);
  Reset(fi);
  readln(fi,s);
  if CheckQuery(fi,StrToInt(s)) then
   begin
    readln(fi,s);
    zz:=StrToInt(s);
    FModulePrint.MemoAdres.Lines.Clear;
    for i:=0 to zz-1 do
     begin
      readln(fi,s);
      FModulePrint.MemoAdres.Lines.add(s);
     end;
    readln(fi,s);
    if s='1' then
     OK_DATA_ADRES:=True
    else
     OK_DATA_ADRES:=False;
    readln(fi,s);
    if s='1' then
     OK_G_KRESKA:=True
    else
     OK_G_KRESKA:=False;
    readln(fi,s);
    if s='1' then
     OK_D_KRESKA:=True
    else
     OK_D_KRESKA:=False;
    readln(fi,s);
    if s='1' then
     OK_LP:=True
    else
     OK_LP:=False;
    readln(fi,s);
    if s='1' then
     OK_OPZ:=True
    else
     OK_OPZ:=False;
    readln(fi,s);
    if s='1' then
     OK_ICO:=True
    else
     OK_ICO:=False;
    readln(fi,s);
    ICO_SCIEZKA:=s;
    readln(fi,s);
    CENT_N:=StrToInt(s);
    readln(fi,s);
    CENT_S:=StrToInt(s);
    for i:=1 to 5 do
     begin
      readln(fi,s);
      if s='1' then
       FModulePrint.CheckBox1.Checked:=True
      else
       FModulePrint.CheckBox1.Checked:=False;
      readln(fi,s);
      if s='1' then
       FModulePrint.CheckBox2.Checked:=True
      else
       FModulePrint.CheckBox2.Checked:=False;

      if Not Assigned(F[i]) then
       F[i]:=TFont.Create;
      readln(fi,s);
      F[i].PixelsPerInch:=StrToInt(s);
      readln(fi,s);
      F[i].Height:=-1*StrToInt(s);
      readln(fi,s);
      F[i].Color:=StrToInt(s);
      readln(fi,s);
      F[i].Size:=StrToInt(s);
      readln(fi,s);
      t_font:=StrToInt(s);
      if (t_font AND 1)=1 then F[i].Style:=F[i].Style + [fsBold];
      if (t_font AND 2)=2 then F[i].Style:=F[i].Style + [fsItalic] ;
      if (t_font AND 4)=4 then F[i].Style:=F[i].Style + [fsUnderline];
      if (t_font AND 8)=8 then F[i].Style:=F[i].Style + [fsStrikeOut];
      readln(fi,s);
      F[i].Name:=s;
      readln(fi,s);
      F[i].Charset:=StrToInt(s);
      readln(fi,s);
      C[i]:=StrToInt(s);
      if i=1 then
       FModulePrint.Shape1.Brush.Color:=StrToInt(s);
      if i=2 then
       FModulePrint.Shape2.Brush.Color:=StrToInt(s);
      if i=3 then
       FModulePrint.Shape3.Brush.Color:=StrToInt(s);
      if i=4 then
       FModulePrint.Shape4.Brush.Color:=StrToInt(s);
      readln(fi,T[i]);
      if i=1 then
       FModulePrint.Edit2.Text:=T[1];
      if i=2 then
       FModulePrint.Edit1.Text:=T[2];
      if i=4 then
       begin
        readln(fi,s);
        zz:=StrToInt(s);
        FModulePrint.MemoStopka.Lines.Clear;
        for z:=1 to zz do
         begin
          readln(fi,s);
          FModulePrint.MemoStopka.Lines.Add(s);
         end;
       end;
     end;
    readln(fi,s);
    FC:=StrToInt(s);
    FModulePrint.ListBox1.Items.Clear;
    FModulePrint.ListBox2.Items.Clear;
    for i:=0 to FC-1 do
     begin
      readln(fi,s);
      FModulePrint.ListBox1.Items.Add(s);
      readln(fi,s1);
      readln(fi,s2);
      for j:=0 to MQ.FieldCount-1 do
       begin
        if MQ.Fields[j].FieldName=s1 then
         begin
          MQ.Fields[j].DisplayLabel:=s;
          MQ.Fields[j].DisplayWidth:=StrToInt(s2);
         end;
       end;
     end;
    readln(fi,s);
    FC:=StrToInt(s);
    for i:=0 to FC-1 do
     begin
      readln(fi,s);
      FModulePrint.ListBox2.Items.Add(s);
      readln(fi,s1);
      readln(fi,s2);
      for j:=0 to MQ.FieldCount-1 do
       begin
        if MQ.Fields[j].FieldName=s1 then
         begin
          MQ.Fields[j].DisplayLabel:=s;
          MQ.Fields[j].DisplayWidth:=StrToInt(s2);
         end;
       end;
     end;
    CloseFile(fi);
    LoadFromFile:=True;
   end
  else
   begin
    CloseFile(fi);
    ShowMessage(FModulePrint.StrHolder.Strings[0]);
   end;
 except
  LoadFromFile:=False;
 end;
end;

procedure TFModulePrint.Button2Click(Sender: TObject);
begin
 if FModulePrint.OpenDialog1.Execute then
 begin
  LoadFromFile(FModulePrint.OpenDialog1.FileName);
 end;
end;

procedure TFModulePrint.CheckBox1Click(Sender: TObject);
begin
  if CheckBox1.Checked then
   begin
    Edit2.Visible:=True;
    Label8.Visible:=True;
    BitBtn5.Enabled:=True;
   end
  else
   begin
    Edit2.Visible:=False;
    Label8.Visible:=False;
    BitBtn5.Enabled:=False;
    T[1]:='';
    Edit2.Text:=T[1];
   end;
end;

procedure TFModulePrint.CheckBox2Click(Sender: TObject);
begin
 if CheckBox2.Checked then
  begin
    MemoStopka.Visible:=True;
    Label9.Visible:=True;
    BitBtn6.Enabled:=True;
  end
 else
  begin
   //T[4]:='';
   MemoStopka.Lines.Clear;
   MemoStopka.Visible:=False;
   Label9.Visible:=False;
   BitBtn6.Enabled:=False;
   //Edit3.Text:=T[4];
  end;
end;


procedure InitLabel( var L : TQRLabel; E : string; X : integer; Y : integer;
                       P : TWinControl; F : TFont; C : TColor; A : TAlignment; W : integer);
begin
 L:=TQRLabel.Create(nil);
  with L do
   begin
    Parent:=P;
    Left := X;
    Top := Y;
    Caption := E;
    Color := C;
    Font.Assign(F);
    Alignment:=A;
    Width:=W;
   end;
end;

procedure SetLabel( var L : TQRLabel; E : string; X : integer; Y : integer;
                      P : TWinControl; F : TFont; C : TColor; A : TAlignment; W : integer);
begin
  with L do
   begin
    Parent:=P;
    Left := X;
    Top := Y;
    Caption := E;
    Color := C;
    Font.Assign(F);
    Alignment:=A;
    Width:=W
   end;
end;

procedure InitSys( var L : TQRSysData; D : TQRSysDatatype; E : string; X : integer; Y : integer;
                      P : TWinControl; F : TFont; C : TColor);
begin
 L:=TQRSysData.Create(nil);
  with L do
   begin
    Parent:=P;
    Data:=D;
    Left := X;
    Top := Y;
    Caption := E;
    Color := C;
    Font.Assign(F);
   end;
end;

procedure InitMemo( var L : TQRMemo; E : TStrings; X : integer; Y : integer; H : integer;
                      P : TWinControl; F : TFont; C : TColor; A : TAlignment; W : integer );
var
 i : integer;
begin
 L:=TQRMemo.Create(nil);
  with L do
   begin
    Parent:=P;
    Left := X;
    Top := Y;
    Height := H;
    for i:=0 to E.Count-1 do
     Lines.Add(E.Strings[i]);
    Color := C;
    Font.Assign(F);
    Alignment:=A;
    Width:=W;
   end;
end;

procedure InitShape( var L : TQRShape; S : TQRShapeType ; X : integer; Y : integer; H : integer;
                      P : TWinControl; B : integer; C : TColor;  W : integer );
begin
 L:=TQRShape.Create(nil);
  with L do
   begin
    Parent:=P;
    Left := X;
    Top := Y;
    Height := H;
    Pen.Color := C;
    Pen.Width:=B;
    Width:=W;
   end;
end;


procedure InitFieldText( var L : TQRDBText; D : TDataSet; E : string; X : integer; Y : integer;
                      P : TWinControl; F : TFont; C : TColor);
begin
  L:=TQRDBText.Create(nil);
  with L do
   begin
    Parent:=P;
    Left := X;
    Top := Y;
    DataSet:=D;
    DataField:= E;
    Color := C;
    Font.Assign(F);
    AutoStretch:=True;
   end;
end;

procedure SetFieldText( var L : TQRDBText; D : TDataSet; E : string; X : integer; Y : integer;
                      P : TWinControl; F : TFont; C : TColor);
begin
  with L do
   begin
    Parent:=P;
    Left := X;
    Top := Y;
    DataSet:=D;
    DataField:= E;
    Color := C;
    Font.Assign(F);
    AutoStretch:=True;
   end;
end;

procedure InitBand( B : TQRCustomBand; T : integer; H: integer;
                      P : TWinControl);
begin
  with B do
   begin
    Parent:=P;
    Height:= H;
    Top := T;
   end;
end;

function InitImage( var I : TQRImage;P : TWinControl; T : integer; L : integer; S : String):Boolean;
begin
 try
 I:=TQRImage.Create(nil);
 with I do
  begin
   Parent:=P;
   Picture.LoadFromFile(ICO_SCIEZKA);
   Top:=T;
   Left:=L;
   Height:=Picture.Height;
   Width:=Picture.Width;
   Stretch:=True;
  end;
  InitImage:=True;
 except
  InitImage:=False;
 end;
end;

procedure BuildReport( Q : TADOQuery; G : TDBGrid; Title : string);
var
 QuickReport3 : TQuickRep;
 QRImage1 : TQRImage;
 et : array [1..50] of TQRLabel;
 pl  : array [1..50] of TQRDBText;
 sys : array [1..5] of TQRsysData;
 mem : array [1..5] of TQRMemo;
 sha : array [1..2] of TQRShape;
 H : array [1..5] of integer;
 ile,i,j,s,H5,HA : integer;
 w,wn : integer;
 dlx,dly,dlyl,maxdlx : integer;
begin
 w:=700;H5:=0;HA:=0;
 for i:=0 to FModulePrint.MemoAdres.Lines.Count-1 do
  HA:=HA+round(F[5].Size*F[5].PixelsPerInch/72);
 QuickReport3:=TQuickRep.Create(nil);
 QuickReport3.DataSet:=Q;
 if OK_OPZ then
  begin
   QuickReport3.Page.Orientation:=poLandscape;
   w:=1050;
  end;
  if OK_DATA_ADRES then
  begin
   HA:=HA;
   wn:=w-150;
  end
 else
  begin
   HA:=17;
   wn:=w;
  end;
 ile:=Q.FieldCount;
 //NAG£ÓWEK
 QuickReport3.Bands.HasPageHeader:=True;
 if OK_ICO then
  begin
   if InitImage(QRImage1,QuickReport3.Bands.PageHeaderBand,17,5,ICO_SCIEZKA) then
    begin
     if ABS(F[1].Height)>ABS(QRImage1.Height) then
      begin
       QRImage1.Top:=17+(ABS(F[1].Height)-ABS(QRImage1.Height));
       if CENT_N=0 then
        InitLabel(et[1],T[1],QRImage1.Width+5,17,QuickReport3.Bands.PageHeaderBand,F[1],C[1],taLeftJustify,wn-(QRImage1.Width+5));
       if CENT_N=1 then
        InitLabel(et[1],T[1],QRImage1.Width+5,17,QuickReport3.Bands.PageHeaderBand,F[1],C[1],taCenter,wn-(QRImage1.Width+5));
       if CENT_N=2 then
        InitLabel(et[1],T[1],QRImage1.Width+5,17,QuickReport3.Bands.PageHeaderBand,F[1],C[1],taRightJustify,wn-(QRImage1.Width+5));
      end
     else
      begin
       if CENT_N=0 then
        InitLabel(et[1],T[1],QRImage1.Width+5,17+(ABS(QRImage1.Height)-ABS(F[1].Height)),QuickReport3.Bands.PageHeaderBand,F[1],C[1],taLeftJustify,wn-(QRImage1.Width+5));
       if CENT_N=1 then
        InitLabel(et[1],T[1],QRImage1.Width+5,17+(ABS(QRImage1.Height)-ABS(F[1].Height)),QuickReport3.Bands.PageHeaderBand,F[1],C[1],taCenter,wn-(QRImage1.Width+5));
       if CENT_N=2 then
        InitLabel(et[1],T[1],QRImage1.Width+5,17+(ABS(QRImage1.Height)-ABS(F[1].Height)),QuickReport3.Bands.PageHeaderBand,F[1],C[1],taRightJustify,wn-(QRImage1.Width+5));
      end;
    end;
    H[1]:=round(F[5].Size*F[5].PixelsPerInch/72)+4+ABS(QRImage1.Height);
    if T[1]<>'' then
     H[1]:=H[1]+round((F[1].Size*F[1].PixelsPerInch/72))+4;
  end
 else
  begin
   if CENT_N=0 then
    InitLabel(et[1],T[1],5,HA,QuickReport3.Bands.PageHeaderBand,F[1],C[1],taLeftJustify,wn);
   if CENT_N=1 then
    InitLabel(et[1],T[1],5,HA,QuickReport3.Bands.PageHeaderBand,F[1],C[1],taCenter,wn);
   if CENT_N=2 then
    InitLabel(et[1],T[1],5,HA,QuickReport3.Bands.PageHeaderBand,F[1],C[1],taRightJustify,wn);
   H[1]:=HA+round(F[5].Size*F[5].PixelsPerInch/72)+4;
   if T[1]<>'' then
    H[1]:=H[1]+round((F[1].Size*F[1].PixelsPerInch/72))+6;
  end;
 if OK_OPZ then
  if not OK_DATA_ADRES then
   InitSys(sys[1],qrsDate,'Data wykonania :',1005,0,QuickReport3.Bands.PageHeaderBand,F[5],C[5])
  else
   InitMemo(mem[1],FModulePrint.MemoAdres.Lines,905,0,78,QuickReport3.Bands.PageHeaderBand,F[5],C[5],taLeftJustify,110)
 else
  if not OK_DATA_ADRES then
   InitSys(sys[1],qrsDate,'Data wykonania :',660,0,QuickReport3.Bands.PageHeaderBand,F[5],C[5])
  else
   InitMemo(mem[1],FModulePrint.MemoAdres.Lines,555,0,78,QuickReport3.Bands.PageHeaderBand,F[5],C[5],taLeftJustify,110);
 if OK_G_KRESKA then
  begin
   InitShape(sha[1],qrsHorLine,10,H[1],2,QuickReport3.Bands.PageHeaderBand,2,clBlack,w-10);
   H[1]:=H[1]+5;
  end
 else
  begin
   H[1]:=H[1];
  end;

 InitBand(QuickReport3.Bands.PageHeaderBand,38,H[1],QuickReport3);

 QuickReport3.Bands.HasTitle:=True;
 InitLabel(et[2],T[2],5,0,QuickReport3.Bands.TitleBand,F[2],C[2],taCenter,w);
 H[2]:=round(F[2].Size*F[2].PixelsPerInch/72)+4;
 InitBand(QuickReport3.Bands.TitleBand,38+H[1],H[2],QuickReport3);

 QuickReport3.Bands.HasColumnHeader:=True;
 QuickReport3.Bands.HasDetail:=True;
 if OK_LP then
  dlx:=round(3*wf*(F[3].Size/10))
 else
  dlx:=2;
 if OK_OPZ then
  maxdlx:=1100
 else
  maxdlx:=700;
 dly:=0;dlyl:=0;s:=0;
 for i:=0 to FModulePrint.ListBox2.Items.Count-1 do
  begin
   InitLabel(et[i+5],FModulePrint.ListBox2.Items.Strings[i],dlx,dlyl,QuickReport3.Bands.ColumnHeaderBand,F[3],C[3],taLeftJustify,QuickReport3.TextWidth(F[3],FModulePrint.ListBox2.Items.Strings[i]));
   for j:=0 to ile-1 do
    begin
     if Q.Fields[j].DisplayName=FModulePrint.ListBox2.Items.Strings[i] then
      begin
       s:=s+1;
       if (dlx+round((Q.Fields[j].DisplayWidth*wf*(F[3].Size/10)))>maxdlx) and (s>1) then
        begin
         s:=1;
         dlyl:=dlyl+round(F[3].Size*F[3].PixelsPerInch/72)+4;
         dly:=dly+round(F[5].Size*F[5].PixelsPerInch/72)+4;
          if OK_LP then
           dlx:=round(3*wf*(F[3].Size/10))
          else
           dlx:=2;
         //ShowMessage('1'+IntToStr(dlx)+' '+IntToStr(dlyl)+' '+FModulePrint.ListBox2.Items.Strings[i]);
         SetLabel(et[i+5],FModulePrint.ListBox2.Items.Strings[i],dlx,dlyl,QuickReport3.Bands.ColumnHeaderBand,F[3],C[3],taLeftJustify,QuickReport3.TextWidth(F[3],FModulePrint.ListBox2.Items.Strings[i]));
         InitFieldText(pl[i+1],Q,Q.Fields[j].FieldName,dlx,dly,QuickReport3.Bands.DetailBand,F[5],C[5]);
         dlx:=dlx+round((Q.Fields[j].DisplayWidth*wf*(F[3].Size/10)));
        end
       else
        begin
         //s:=s+1;
         //howMessage('2'+IntToStr(dlx)+' '+IntToStr(dlyl)+' '+FModulePrint.ListBox2.Items.Strings[i]);
         SetLabel(et[i+5],FModulePrint.ListBox2.Items.Strings[i],dlx,dlyl,QuickReport3.Bands.ColumnHeaderBand,F[3],C[3],taLeftJustify,QuickReport3.TextWidth(F[3],FModulePrint.ListBox2.Items.Strings[i]));
         InitFieldText(pl[i+1],Q,Q.Fields[j].FieldName,dlx,dly,QuickReport3.Bands.DetailBand,F[5],C[5]);
         dlx:=dlx+round((Q.Fields[j].DisplayWidth*wf*(F[3].Size/10)));
        end;
      end;
    end;
  end;
  QuickReport3.Bands.HasColumnHeader:=True;
  H[3]:=round(F[3].Size*F[3].PixelsPerInch/72)+4+dlyl;
  InitBand(QuickReport3.Bands.ColumnHeaderBand,38+H[1]+H[2],H[3],QuickReport3);
  if OK_LP then
   InitLabel(et[5],'Lp',5,0,QuickReport3.Bands.ColumnHeaderBand,F[3],C[3],taLeftJustify,round(3*wf*(F[3].Size/10)));
  QuickReport3.Bands.HasDetail:=True;
  H[4]:=round(F[5].Size*F[5].PixelsPerInch/72)+4+dly;
  InitBand(QuickReport3.Bands.DetailBand,38+H[1]+H[2]+H[3],H[4],QuickReport3);
  if OK_LP then
   InitSys(sys[2],qrsDetailNo,'',5,0,QuickReport3.Bands.DetailBand,F[5],C[5]);


  QuickReport3.Bands.HasPageFooter:=True;
  H[5]:=round(F[5].Size*F[5].PixelsPerInch/72)+8;//+round(F[4].Size*F[4].PixelsPerInch/72)+8;
  for j:=0 to FModulePrint.MemoStopka.Lines.Count-1 do
   H5:=H5+round(F[4].Size*F[4].PixelsPerInch/72)+4;
  if OK_D_KRESKA then
   begin
    InitShape(sha[2],qrsHorLine,10,0,2,QuickReport3.Bands.PageFooterBand,2,clBlack,w-10);
    H[5]:=H[5]+H5+5;
   end
  else
   begin
    H[5]:=H[5]+H5;
   end;
  InitBand(QuickReport3.Bands.PageFooterBand,38+H[1]+H[2]+H[3]+H[4],H[5],QuickReport3);

  if CENT_S=0 then
   InitMemo(mem[2],FModulePrint.MemoStopka.Lines,5,5,H5,QuickReport3.Bands.PageFooterBand,F[4],C[4],taLeftJustify,w);
   //InitLabel(et[3],T[4],5,0,QuickReport3.Bands.PageFooterBand,F[4],C[4],taLeftJustify,w);
  if CENT_S=1 then
   InitMemo(mem[2],FModulePrint.MemoStopka.Lines,5,5,H5,QuickReport3.Bands.PageFooterBand,F[4],C[4],taCenter,w);
   //InitLabel(et[3],T[4],5,0,QuickReport3.Bands.PageFooterBand,F[4],C[4],taCenter,w);
  if CENT_S=2 then
   InitMemo(mem[2],FModulePrint.MemoStopka.Lines,5,5,H5,QuickReport3.Bands.PageFooterBand,F[4],C[4],taRightJustify,w);
   //InitLabel(et[3],T[4],5,0,QuickReport3.Bands.PageFooterBand,F[4],C[4],taRightJustify,w);

  if OK_OPZ then
   InitSys(sys[2],qrsPageNumber,'Strona',570,H5+5,QuickReport3.Bands.PageFooterBand,F[5],C[5])
  else
   InitSys(sys[2],qrsPageNumber,'Strona',370,H5+5,QuickReport3.Bands.PageFooterBand,F[5],C[5]);

  QuickReport3.Preview;
end;

procedure Exportuj( Q : TADOQuery; G : TDBGrid; Title : string; MFullPath : string);
var
 i,j,ile : integer;
begin
try
FModulePrint:=TFModulePrint.Create(nil);
MQ:=Q;MG:=G;
if not LoadFromFile(MFullPath) then
 begin
  for i:=1 to 5 do
   begin
    if i=1 then
     begin
      F[i]:=TFont.Create;
      F[i].Color:=clBlack;
      F[i].Size:=20;
      F[i].style:=[]+[fsBold];
      F[i].name:='Times New Roman';
      F[i].charset:=238;
      C[i]:=clWhite;
      T[i]:='';
      FModulePrint.Edit2.Text:=T[1];
     end
    else if i=4 then
     begin
      F[i]:=TFont.Create;
      F[i].Color:=clBlack;
      F[i].Size:=9;
      F[i].style:=[];
      F[i].name:='Times New Roman';
      F[i].charset:=238;
      C[i]:=clWhite;
      FModulePrint.MemoStopka.Lines.Clear;
      FModulePrint.MemoStopka.Lines.Add(UUtilityParent.GetSystemParam('PrintFooter1'));
      FModulePrint.MemoStopka.Lines.Add(UUtilityParent.GetSystemParam('PrintFooter2'));
      FModulePrint.MemoStopka.Lines.Add(UUtilityParent.GetSystemParam('PrintFooter3'));

      FModulePrint.MemoAdres.Lines.Add(GetSystemParam('PrintCompany1'));
      FModulePrint.MemoAdres.Lines.Add(GetSystemParam('PrintCompany2'));
      FModulePrint.MemoAdres.Lines.Add(GetSystemParam('PrintCompany3'));
      FModulePrint.MemoAdres.Lines.Add(GetSystemParam('PrintCompany4'));
      FModulePrint.MemoAdres.Lines.Add(GetSystemParam('PrintCompany5'));

      T[i]:='';
     end
    else
     begin
      F[i]:=TFont.Create;
      F[i].Color:=clBlack;
      if i=2 then
       begin
        F[i].Size:=16;
        F[i].style:=[]+[fsBold];
       end
      else
       begin
        F[i].Size:=10;
        F[i].style:=[];
       end;
      F[i].style:=[];
      F[i].name:='Times New Roman';
      F[i].charset:=238;
      C[i]:=clWhite;
      T[i]:='';
     end;
   end;
    T[2]:=Title;
    FModulePrint.Edit1.Text:=T[2];
  ile:=Q.FieldCount;
  for i:=0 to ile-1 do
   begin
    for j:=0 to G.FieldCount-1 do
     begin
      if Q.Fields[i].FieldName=G.Columns[j].FieldName then
       begin
        Q.Fields[i].DisplayLabel:=G.Columns[j].Title.Caption;
        Q.Fields[i].DisplayWidth:=G.Fields[j].DisplayWidth;
       end;
     end;
   end;
   for i:=0 to ile-1 do
   begin
    //FModulePrint.ListBox1.Items.Add(Q.Fields[i].DisplayLabel);
    FModulePrint.StrHolder1.Strings.Add(Q.Fields[i].DisplayLabel);
   end;
   FModulePrint.ListBox1.Items.Assign(FModulePrint.StrHolder1.Strings);
 end;
 FModulePrint.ShowModal;
 SaveToFile(MFullPath);
 with FModulePrint do
  begin
   CheckBox1.Checked:=False;
   CheckBox2.Checked:=False;
   ListBox1.Items.Clear;
   ListBox2.Items.Clear;
  end;
finally
 FModulePrint.Free;
end;
end;


procedure TFModulePrint.Button6Click(Sender: TObject);
begin
try
 ListBox2.Items.Add(ListBox1.Items.Strings[ListBox1.ItemIndex]);
 ListBox1.Items.Delete(ListBox1.ItemIndex);
except
end;
end;

procedure TFModulePrint.Button8Click(Sender: TObject);
begin
try
 //ListBox1.Items.Add(ListBox2.Items.Strings[ListBox2.ItemIndex]);
 StrHolder1.Strings.Clear;
 StrHolder1.Strings.Assign(ListBox1.Items);
 StrHolder1.Strings.Add(ListBox2.Items.Strings[ListBox2.ItemIndex]);
 ListBox1.Items.Clear;
 ListBox1.Items.Assign(StrHolder1.Strings);
 ListBox2.Items.Delete(ListBox2.ItemIndex);
except
end;
end;

procedure TFModulePrint.Button7Click(Sender: TObject);
var
 i : integer;
begin
 //->>
 if ListBox1.Items.Count>0 then
  begin
   for i:=0 to ListBox1.Items.Count-1 do
    begin
     ListBox2.Items.Add(ListBox1.Items[i]);
    end;
     ListBox1.Items.Clear;
  end;
end;

procedure TFModulePrint.Button9Click(Sender: TObject);
var
 i : integer;
begin
 //<<-
 if ListBox2.Items.Count>0 then
  begin
   StrHolder1.Strings.Clear;
   StrHolder1.Strings.Assign(ListBox1.Items);
   for i:=0 to ListBox2.Items.Count-1 do
    begin
     StrHolder1.Strings.Add(ListBox2.Items[i]);
    end;
   ListBox1.Items.Clear;
   ListBox1.Items.Assign(StrHolder1.Strings);
   ListBox2.Items.Clear;
  end;
end;

procedure TFModulePrint.SpeedButton1Click(Sender: TObject);
begin
 if ListBox2.ItemIndex>0 then
  begin
   ListBox2.Items.Exchange(ListBox2.ItemIndex-1,ListBox2.ItemIndex);
   ListBox2.ItemIndex:=ListBox2.ItemIndex-1;
  end
end;

procedure TFModulePrint.SpeedButton2Click(Sender: TObject);
begin
 if (ListBox2.ItemIndex<ListBox2.Items.Count-1)  then
  begin
   ListBox2.Items.Exchange(ListBox2.ItemIndex+1,ListBox2.ItemIndex);
   ListBox2.ItemIndex:=ListBox2.ItemIndex+1;
  end;
end;








procedure TFModulePrint.ListBox2EndDrag(Sender, Target: TObject; X, Y: Integer);
begin
try
 ListBox2.Items.Add(ListBox1.Items.Strings[ListBox1.ItemIndex]);
 ListBox1.Items.Delete(ListBox1.ItemIndex);
except
end;
end;

procedure TFModulePrint.Edit1Change(Sender: TObject);
begin
  T[2]:=Edit1.Text
end;

procedure TFModulePrint.SpeedButton4Click(Sender: TObject);
begin
 if ColorDialog1.Execute then

end;

procedure TFModulePrint.Shape1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if ColorDialog1.Execute then
    begin
     C[1]:=ColorDialog1.Color;
     Shape1.Brush.Color:=C[1];
    end

end;

procedure TFModulePrint.Shape2MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if ColorDialog1.Execute then
   begin
    C[2]:=ColorDialog1.Color;
    Shape2.Brush.Color:=C[2];
   end;
end;

procedure TFModulePrint.Shape3MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if ColorDialog1.Execute then
   begin
    C[3]:=ColorDialog1.Color;
    Shape3.Brush.Color:=C[3];
   end;
end;

procedure TFModulePrint.Shape4MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
 if ColorDialog1.Execute then
  begin
   C[4]:=ColorDialog1.Color;
   Shape4.Brush.Color:=C[4];
  end;
end;





procedure TFModulePrint.BitBtn5Click(Sender: TObject);
begin
 FontDialog1.Font.Assign(F[1]);
 if FontDialog1.Execute then
  F[1].Assign(FontDialog1.Font)
end;

procedure TFModulePrint.BitBtn7Click(Sender: TObject);
begin
 FontDialog1.Font.Assign(F[2]);
 if FontDialog1.Execute then
  F[2].Assign(FontDialog1.Font)
end;

procedure TFModulePrint.BitBtn6Click(Sender: TObject);
begin
 FontDialog1.Font.Assign(F[4]);
 if FontDialog1.Execute then
  F[4].Assign(FontDialog1.Font)
end;

procedure TFModulePrint.BitBtn8Click(Sender: TObject);
begin
 FontDialog1.Font.Assign(F[3]);
 if FontDialog1.Execute then
  F[3].Assign(FontDialog1.Font)
end;

procedure TFModulePrint.BitBtn1Click(Sender: TObject);
begin
 if ListBox2.Items.Count>0 then
  BuildReport(MQ,MG,T[2])
 else
  ShowMessage('Nie okreœlono kolumn wyœwietlanych w raporcie');
end;

procedure TFModulePrint.Edit2Change(Sender: TObject);
begin
 T[1]:=Edit2.Text
end;

procedure TFModulePrint.BitBtn9Click(Sender: TObject);
var
 i,j,k,p : integer;
 A : array [1..50] of string;
 NotOkToLB2 : Boolean;
begin
 try
  FModulePrintAdvanced:=TFModulePrintAdvanced.Create(nil);
  FModulePrintAdvanced.StringGrid1.cells[0,0]:='Kolumna tabeli';
  FModulePrintAdvanced.StringGrid1.ColWidths[0]:=240;
  FModulePrintAdvanced.StringGrid1.cells[1,0]:='Etykieta kolumny';
  FModulePrintAdvanced.StringGrid1.ColWidths[1]:=260;
  FModulePrintAdvanced.StringGrid1.cells[2,0]:='D³ugoœæ w raporcie';
  FModulePrintAdvanced.StringGrid1.ColWidths[2]:=150;
  FModulePrintAdvanced.StringGrid1.RowCount:=MQ.FieldCount+1;
  StrHolder1.Strings.Clear;
  for i:=0 to MQ.FieldCount-1 do
   begin
    StrHolder1.Strings.Add(MQ.Fields[i].FieldName);
   end;
  for i:=0 to MQ.FieldCount-1 do
    begin
     FModulePrintAdvanced.StringGrid1.cells[0,i+1]:=StrHolder1.Strings[i];
     k:=0;
     while k<MQ.FieldCount do
      begin
       if MQ.Fields[k].FieldName=StrHolder1.Strings[i] then
        begin
         FModulePrintAdvanced.StringGrid1.cells[1,i+1]:=MQ.Fields[k].DisplayLabel;
         FModulePrintAdvanced.StringGrid1.cells[2,i+1]:=IntToStr(MQ.Fields[k].DisplayWidth);
         k:=MQ.FieldCount;
        end
       else
        k:=k+1;
      end;
    end;
  if FModulePrintAdvanced.ShowModal=mrOk then
   begin
   if ListBox2.Items.Count>0 then
    begin
     for i:=0 to ListBox2.Items.Count-1 do
      begin
       for j:=0 to MQ.FieldCount-1 do
        begin
         if ListBox2.Items.Strings[i]=MQ.Fields[j].DisplayLabel then
          begin
           a[i+1]:=MQ.Fields[j].FieldName;
          end;
         end;
       end;
    end;
    j:=ListBox2.Items.Count;
    ListBox2.Items.Clear;
    ListBox1.Items.Clear;
    StrHolder1.Strings.Clear;
    for i:=0 to MQ.FieldCount-1 do
     begin
      p:=0;
      while p<MQ.FieldCount do
       begin
        if MQ.Fields[i].FieldName=FModulePrintAdvanced.StringGrid1.cells[0,p+1] then
         begin
          MQ.Fields[i].DisplayLabel:=FModulePrintAdvanced.StringGrid1.cells[1,p+1];
          try
           MQ.Fields[i].DisplayWidth:=StrToInt(FModulePrintAdvanced.StringGrid1.cells[2,p+1]);
          except
           MQ.Fields[i].DisplayWidth:=1;
          end;
          NotOkToLB2:=True;
          if j>0 then
           begin
            for k:=0 to j-1 do
             begin
              if a[k+1]=MQ.Fields[i].FieldName then
               begin
                ListBox2.Items.Add(MQ.Fields[i].DisplayLabel);
                NotOkToLB2:=False;
               end;
             end;
           end;
           if NotOkToLB2 then
            begin
            //ListBox1.Items.Add(MQ.Fields[i].DisplayLabel);
             StrHolder1.Strings.Add(MQ.Fields[i].DisplayLabel);
            end;
           p:=MQ.FieldCount;
         end
        else
         begin
          p:=p+1;
         end;
       end;
     end;
     ListBox1.Items.Assign(StrHolder1.Strings);
   end;
 finally
  FModulePrintAdvanced.Free;
 end;
end;


procedure TFModulePrint.ListBox1DblClick(Sender: TObject);
begin
try
 ListBox2.Items.Add(ListBox1.Items.Strings[ListBox1.ItemIndex]);
 ListBox1.Items.Delete(ListBox1.ItemIndex);
except
end;
end;

procedure TFModulePrint.ListBox2DblClick(Sender: TObject);
begin
try
 //ListBox1.Items.Add(ListBox2.Items.Strings[ListBox2.ItemIndex]);
 StrHolder1.Strings.Clear;
 StrHolder1.Strings.Assign(ListBox1.Items);
 StrHolder1.Strings.Add(ListBox2.Items.Strings[ListBox2.ItemIndex]);
 ListBox1.Items.Clear;
 ListBox1.Items.Assign(StrHolder1.Strings);
 ListBox2.Items.Delete(ListBox2.ItemIndex);
except
end;
end;

end.
