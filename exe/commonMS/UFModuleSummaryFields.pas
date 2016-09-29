unit UFModuleSummaryFields;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls,Grids,DBTables,Db, ADODB;

type
  TFModuleSummaryFields = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    SGPola: TStringGrid;
    procedure SGPolaDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function MyShowPola(Q : TADOQuery; var StrGrid : TStringGrid) : Boolean;

var
  FModuleSummaryFields: TFModuleSummaryFields;

implementation
function MyShowPola(Q : TADOQuery; var StrGrid : TStringGrid) : Boolean;
var
 i,j : integer;
 w : Boolean;
 wp : Boolean;
begin
 try
  FModuleSummaryFields:=TFModuleSummaryFields.Create(nil);
  FModuleSummaryFields.SGPola.ColWidths[0]:=1;
  FModuleSummaryFields.SGPola.cells[1,0]:='Dostêpne pola';
  for i:=0 to Q.FieldCount-1 do
   begin
    if (Q.Fields[i].DataType=ftInteger) or (Q.Fields[i].DataType=ftWord) or (Q.Fields[i].DataType=ftFloat) then
     begin
      j:=0;
      wp:=False;
      while j<StrGrid.RowCount do
       begin
        if Q.Fields[i].FieldName=StrGrid.Cells[0,j+1]then
         begin
          wp:=True;
          j:=StrGrid.RowCount;
         end;
        j:=j+1;
       end;
      if not wp then
       begin
        FModuleSummaryFields.SGPola.Cells[0,FModuleSummaryFields.SGPola.RowCount-1]:=Q.Fields[i].FieldName;
        FModuleSummaryFields.SGPola.Cells[1,FModuleSummaryFields.SGPola.RowCount-1]:=Q.Fields[i].DisplayLabel;
        FModuleSummaryFields.SGPola.RowCount:=FModuleSummaryFields.SGPola.RowCount+1;
       end;
     end;
   end;
  if FModuleSummaryFields.ShowModal=mrOk then
   begin
    if FModuleSummaryFields.SGPola.Cells[0,FModuleSummaryFields.SGPola.Row] <> '' then
     begin
      StrGrid.cells[0,StrGrid.RowCount]:=FModuleSummaryFields.SGPola.Cells[0,FModuleSummaryFields.SGPola.Row];
      StrGrid.cells[1,StrGrid.RowCount]:=FModuleSummaryFields.SGPola.Cells[1,FModuleSummaryFields.SGPola.Row];
      StrGrid.RowCount:=StrGrid.RowCount+1;
      w:=True;
     end; 
   end
  else
   W:=False;
 finally
  FModuleSummaryFields.Destroy;
  Result:=w;
 end;
end;
{$R *.DFM}

procedure TFModuleSummaryFields.SGPolaDblClick(Sender: TObject);
begin
 FModuleSummaryFields.ModalResult:=mrOk;
end;

end.
