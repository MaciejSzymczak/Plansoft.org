unit UFCreateSQL;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, Db, DBTables;

type
  TFCreateSimpleData = class(TForm)
    Query: TQuery;
    Execute: TBitBtn;
    Memo: TMemo;
    TableName: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    SQL: TEdit;
    procedure ExecuteClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FCreateSimpleData: TFCreateSimpleData;

implementation

{$R *.DFM}


procedure TFCreateSimpleData.ExecuteClick(Sender: TObject);
Var I : Integer;
    NrLinii : Integer;
    Licznik : Integer;
Procedure Wstaw(S : String);
Begin
 Memo.Lines[NrLinii] := Memo.Lines[NrLinii] + S;
End;
begin
 Query.SQL.Clear;
 Query.SQL.Add(SQL.Text);
 Query.Open;
 NrLinii := 0;
 Licznik := 0;
 Wstaw('INSERT INTO '+TableName.Text+' (');
 For I := 0 To Query.FieldCount -1 Do Begin
   If I < Query.FieldCount -1 Then Wstaw(Query.Fields[I].FieldName+',')
                              Else Wstaw(Query.Fields[I].FieldName);
   Licznik := Licznik + 1;
   If (Licznik mod 5) = 0 Then NrLinii := NrLinii + 1;
 End;
 Wstaw(' ) VALUES (' );

  For I := 0 To Query.FieldCount -1 Do Begin
   Case Query.Fields[I].DataType Of
     ftString : Begin Wstaw(''''+Copy(Query.Fields[I].FieldName,1,Query.Fields[I].Size)+''''); End;
     ftDateTime : Begin Wstaw('SYSDATE'); End;
     Else Wstaw('1');
   End;
   If I < Query.FieldCount -1 Then Wstaw(',');
   Licznik := Licznik + 1;
   If (Licznik mod 5) = 0 Then NrLinii := NrLinii + 1;
 End;
 Wstaw(' )' );

end;

end.

