unit UFModuleSummaryDlgOptions;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, 
  Buttons, ExtCtrls, RXCtrls,Math,UFModuleSummaryConfig;

type
  TFModuleSummaryDlgOptions = class(TForm)
    Bevel1: TBevel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    WyborOpcji: TRxCheckListBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;
function MyShowOpcje( FieldLabel : string) : Boolean;
var
  FModuleSummaryDlgOptions: TFModuleSummaryDlgOptions;

implementation

Uses UFModuleSummary;

function MyShowOpcje( FieldLabel : string) : Boolean;
var
 k,i,j : integer;
begin
try
 FModuleSummaryDlgOptions:=TFModuleSummaryDlgOptions.Create(nil);
 FModuleSummaryDlgOptions.WyborOpcji.Items.Clear;
 FModuleSummaryDlgOptions.Caption:='Opcje dla pola '+FieldLabel;
 for i:=0 to LKK-1 do
  begin
   FModuleSummaryDlgOptions.WyborOpcji.Items.Add(EKP[i].Caption);
  end;
 i:=0;
 while i<LK do
  begin
   if KR[i].FieldName=FModuleSummary.MainGrid.cells[0,FModuleSummary.MainGrid.Row] then
    begin
     for j:=0 to FModuleSummaryDlgOptions.WyborOpcji.Items.Count-1 do
      begin
       if (KR[i].Key AND round(Power(2,j+1))=round(Power(2,j+1))) then FModuleSummaryDlgOptions.WyborOpcji.Checked[j]:=True;
      end;
      i:=LK;
    end;
   i:=i+1;
 end;
 if FModuleSummaryDlgOptions.ShowModal=mrOK then
  begin
   k:=0;
   for j:=0 to FModuleSummaryDlgOptions.WyborOpcji.Items.Count-1 do
    begin
       if FModuleSummaryDlgOptions.WyborOpcji.Checked[j] then k:=k+round(Power(2,j+1));
    end;
   i:=0;
   while i<LK do
    begin
      if KR[i].FieldName=FModuleSummary.MainGrid.cells[0,FModuleSummary.MainGrid.Row] then
       begin
         KR[i].Key:=k;
         i:=LK;
       end;
      i:=i+1;
    end;
  end;
 FModuleSummaryDlgOptions.Free;
 Result:=True;
except
 FModuleSummaryDlgOptions.Free;
 Result:=False;
end;
end;
{$R *.DFM}


end.
