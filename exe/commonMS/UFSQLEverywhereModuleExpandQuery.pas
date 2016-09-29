unit UFSQLEverywhereModuleExpandQuery;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UFormConfig, StdCtrls, Buttons, ExtCtrls, dbtables;

type
  TFSQLEverywhereModuleExpandQuery = class(TFormConfig)
    M: TMemo;
    BitBtn1: TBitBtn;
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    Query : TQuery;
  end;

var
  FSQLEverywhereModuleExpandQuery: TFSQLEverywhereModuleExpandQuery;

implementation

{$R *.DFM}

procedure TFSQLEverywhereModuleExpandQuery.BitBtn1Click(Sender: TObject);
Var i : Integer;
begin
  inherited;
  M.Lines.Clear;
  With Query Do Begin
    For i := 0 To Fields.Count -1 Do
     M.Lines.Add(Fields.Fields[i].FieldName);
  End;
end;

end.
