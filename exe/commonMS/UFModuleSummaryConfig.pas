unit UFModuleSummaryConfig;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, 
  Buttons, ExtCtrls, Grids,UFModuleSummarySQL, Menus;

type
  TFModuleSummaryConfig = class(TForm)
    BitBtn2: TBitBtn;
    StringGrid1: TStringGrid;
    BitBtn1: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    MenuForColumnEdit: TPopupMenu;
    Edytuj1: TMenuItem;
    Dodaj1: TMenuItem;
    Usu1: TMenuItem;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure StringGrid1DblClick(Sender: TObject);
    procedure Edytuj1Click(Sender: TObject);
    procedure Dodaj1Click(Sender: TObject);
    procedure Usu1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TKratkaKonfig=record
   Caption : String;
   FunctionName : String;
  end;

function MyShowKonfigOpcje : Boolean;

var
  FModuleSummaryConfig: TFModuleSummaryConfig;
  EKP : array[0..80] of TKratkaKonfig;
  LKK : integer=0;
implementation

{$R *.DFM}
function MyShowKonfigOpcje : Boolean;
var
 w : Boolean;
 i : integer;
begin
 try
  FModuleSummaryConfig:=TFModuleSummaryConfig.Create(nil);
  FModuleSummaryConfig.StringGrid1.cells[0,0]:='Etykieta funcji';
  FModuleSummaryConfig.StringGrid1.cells[1,0]:='Funkcja SQL';
  for i:=0 to LKK-1 do
   begin
    FModuleSummaryConfig.StringGrid1.cells[0,i+1]:=EKP[i].Caption;
    FModuleSummaryConfig.StringGrid1.cells[1,i+1]:=EKP[i].FunctionName;
   end;
  FModuleSummaryConfig.StringGrid1.RowCount:=LKK+1;
  if FModuleSummaryConfig.ShowModal=mrOK then
   begin
    w:=True;
   end
  else
   w:=False;
 finally
   FModuleSummaryConfig.Destroy;
   Result:=w;
 end;
end;

procedure TFModuleSummaryConfig.BitBtn1Click(Sender: TObject);
var
 E1,E2 : string;
 i : integer;
begin
 E1:=FModuleSummaryConfig.StringGrid1.cells[0,FModuleSummaryConfig.StringGrid1.Row];
 E2:=FModuleSummaryConfig.StringGrid1.cells[1,FModuleSummaryConfig.StringGrid1.Row];
 if MyShowWMKolumn('E',E1,E2) then
  begin
   i:=0;
   while i<LKK do
    begin
     if FModuleSummaryConfig.StringGrid1.cells[0,FModuleSummaryConfig.StringGrid1.Row]=EKP[i].Caption then
      begin
       EKP[i].Caption:=E1;
       EKP[i].FunctionName:=E2;
       i:=LKK;
      end;
      i:=i+1;
    end;
   FModuleSummaryConfig.StringGrid1.cells[0,FModuleSummaryConfig.StringGrid1.Row]:=E1;
   FModuleSummaryConfig.StringGrid1.cells[1,FModuleSummaryConfig.StringGrid1.Row]:=E2;
  end;
end;

procedure TFModuleSummaryConfig.BitBtn3Click(Sender: TObject);
var
 E1,E2 : string;
begin
 if MyShowWMKolumn('W',E1,E2) then
  begin
   FModuleSummaryConfig.StringGrid1.RowCount:=FModuleSummaryConfig.StringGrid1.RowCount+1;
   FModuleSummaryConfig.StringGrid1.cells[0,FModuleSummaryConfig.StringGrid1.RowCount-1]:=E1;
   FModuleSummaryConfig.StringGrid1.cells[1,FModuleSummaryConfig.StringGrid1.RowCount-1]:=E2;
   EKP[LKK].Caption:=E1;
   EKP[LKK].FunctionName:=E2;
   LKK:=LKK+1;
   if FModuleSummaryConfig.StringGrid1.RowCount>1 then
    begin
     FModuleSummaryConfig.StringGrid1.FixedRows:=1;
     FModuleSummaryConfig.MenuForColumnEdit.Items[0].Enabled:=True;
     FModuleSummaryConfig.MenuForColumnEdit.Items[2].Enabled:=True;
     FModuleSummaryConfig.BitBtn4.Enabled:=True;
     FModuleSummaryConfig.BitBtn1.Enabled:=True;
    end;
  end;
end;

procedure TFModuleSummaryConfig.BitBtn4Click(Sender: TObject);
var
 i,j : integer;
begin
if FModuleSummaryConfig.StringGrid1.Row>0 then
 begin
 i:=0;
 while i<LKK do
  begin
   if (EKP[i].Caption=FModuleSummaryConfig.StringGrid1.cells[0,FModuleSummaryConfig.StringGrid1.Row]) and
       (EKP[i].FunctionName=FModuleSummaryConfig.StringGrid1.cells[1,FModuleSummaryConfig.StringGrid1.Row]) then
    begin
     for j:=i to LKK-2 do
      begin
       EKP[j].Caption:=EKP[j+1].Caption;
       EKP[j].FunctionName:=EKP[j+1].FunctionName;
      end;
     i:=LKK;
     LKK:=LKK-1;
    end;
   i:=i+1;
  end;
 for i:=FModuleSummaryConfig.StringGrid1.Row to FModuleSummaryConfig.StringGrid1.RowCount-2 do
  begin
   FModuleSummaryConfig.StringGrid1.cells[0,i]:=FModuleSummaryConfig.StringGrid1.cells[0,i+1];
   FModuleSummaryConfig.StringGrid1.cells[1,i]:=FModuleSummaryConfig.StringGrid1.cells[1,i+1]
  end;
 FModuleSummaryConfig.StringGrid1.RowCount:=FModuleSummaryConfig.StringGrid1.RowCount-1;
 if FModuleSummaryConfig.StringGrid1.RowCount=1 then
  begin
   FModuleSummaryConfig.MenuForColumnEdit.Items[0].Enabled:=False;
   FModuleSummaryConfig.MenuForColumnEdit.Items[2].Enabled:=False;
   FModuleSummaryConfig.BitBtn1.Enabled:=False;
   FModuleSummaryConfig.BitBtn4.Enabled:=False;
  end;
 end; 
end;

procedure TFModuleSummaryConfig.StringGrid1DblClick(Sender: TObject);
begin
BitBtn1Click(Nil);
end;

procedure TFModuleSummaryConfig.Edytuj1Click(Sender: TObject);
begin
 BitBtn1Click(nil);
end;

procedure TFModuleSummaryConfig.Dodaj1Click(Sender: TObject);
begin
 BitBtn3Click(Nil);
end;

procedure TFModuleSummaryConfig.Usu1Click(Sender: TObject);
begin
 BitBtn4Click(Nil);
end;

procedure TFModuleSummaryConfig.FormShow(Sender: TObject);
begin
 if FModuleSummaryConfig.StringGrid1.RowCount=1 then
  begin
   FModuleSummaryConfig.MenuForColumnEdit.Items[0].Enabled:=False;
   FModuleSummaryConfig.MenuForColumnEdit.Items[2].Enabled:=False;
   FModuleSummaryConfig.BitBtn4.Enabled:=False;
   FModuleSummaryConfig.BitBtn1.Enabled:=False;
  end;
end;

end.
