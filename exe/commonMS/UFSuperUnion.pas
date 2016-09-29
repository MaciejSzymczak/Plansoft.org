unit UFSuperUnion;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, Db, DBTables, DBLists, UUtilityParent;

type
  TFSuperUnion = class(TForm)
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Panel: TPanel;
    BClose: TBitBtn;
    MTables: TMemo;
    MColumns: TMemo;
    TableItems: TTableItems;
    Query: TQuery;
    BExport: TBitBtn;
    BRefresh: TBitBtn;
    Image1: TImage;
    Label1: TLabel;
    procedure BRefreshClick(Sender: TObject);
    procedure BExportClick(Sender: TObject);
    procedure BCloseClick(Sender: TObject);
  private
    DatabaseName : String;

    SingleRecord : Array[0..1000] Of String;
    FieldsCount  : Integer;
  public
    { Public declarations }
  end;

var
  FSuperUnion: TFSuperUnion;

Procedure ShowModal(aDatabaseName : String; Tables : TStrings);

implementation

{$R *.DFM}

Procedure ShowModal(aDatabaseName : String; Tables : TStrings);
Begin
 Application.CreateForm(TFSuperUnion, FSuperUnion);
 FSuperUnion.DatabaseName  := aDatabaseName;
 FSuperUnion.TableItems.DatabaseName := aDatabaseName;
 FSuperUnion.Query.DatabaseName      := aDatabaseName;
 FSuperUnion.MTables.Lines.Assign(Tables);
 FSuperUnion.ShowModal;
 FSuperUnion.Free;
End;

procedure TFSuperUnion.BRefreshClick(Sender: TObject);

 Function NotExists(S : TStrings; Str : String) : Boolean;
 Var L : Integer;
 Begin
  Result := True;
  For L := 0 To S.Count - 1 Do Begin
    If S.Strings[L] = Str Then Begin
     Result := False;
     Break;
    End;
  End;
 End;

Var L : Integer;
begin
 MColumns.Lines.Clear;

 For L := 0 To MTables.Lines.Count - 1 Do Begin
  Try
   TableItems.TableName := MTables.Lines.Strings[L];
   TableItems.Close;
   TableItems.Open;

   TableItems.First;
   While Not TableItems.EOF Do Begin
    If NotExists(MColumns.Lines, TableItems.Fields[1].AsString) Then MColumns.Lines.Add(TableItems.Fields[1].AsString);
    TableItems.Next;
   End;
   Except
    SError('Error durning trying read columns. Table:'+MTables.Lines.Strings[L]);
   End;

 End;

end;

Function X(S : String) : String;
Var Temp : String;
    T    : Integer;
    Delimiter : String;

Begin
 Delimiter := '"';
 Temp := '';
 For T := 1 To Length(S) Do
  If S[t] = Copy(Delimiter,1,1) Then Temp := Temp + S[t] + S[t]
                                Else Temp := Temp + S[t];

 Result := Delimiter + Temp + Delimiter;
End;

procedure TFSuperUnion.BExportClick(Sender: TObject);
Var L,I   : Integer;
    Index : Integer;
    F     : TextFile;

    Procedure PutSingleRecord(Title : ShortString);
    Var L : Integer;
    Begin
      Write(F, X(Title)+',');
      For L := 0 To FieldsCount-1 Do Begin
           Write(F, X(SingleRecord[L]));
           If L < FieldsCount-1 Then Write(F, ',');
      End;
      WriteLn(F);
    End;

    Procedure ClearSingleRecord;
    Var L : Integer;
    Begin
      For L := 0 To FieldsCount-1 Do Begin
           SingleRecord[L] := '';
      End;
    End;

    Function GetIndexInStrings(S : TStrings; Str : String) : Integer;
    Var L : Integer;
    Begin
     Result := -1;
     For L := 0 To S.Count - 1 Do Begin
      If S.Strings[L] = Str Then Begin
       Result := L;
       Break;
      End;
     End;
    End;

begin
 AssignFile(F, 'c:\superunion.csv');
 ReWrite(F);

 // nag³ówek
 FieldsCount := MColumns.Lines.Count;
 For L := 0 To MColumns.Lines.Count - 1 Do Begin
  SingleRecord[L] := MColumns.Lines.Strings[L];
 End;
 PutSingleRecord('TABLE');

 For L := 0 To MTables.Lines.Count - 1 Do Begin
  Try
   Query.SQL.Clear;
   Query.SQL.Add('Select * from '+MTables.Lines.Strings[L]);
   Panel.Caption := MTables.Lines.Strings[L];
   Panel.Refresh;
   Query.Open;

   Query.First;
   While Not Query.EOF Do Begin
    ClearSingleRecord;
    For I := 0 To Query.FieldCount - 1 Do Begin
     Index := GetIndexInStrings(MColumns.Lines,Query.Fields[I].FieldName);
     If Index <> - 1 Then SingleRecord[Index] := Query.Fields[I].AsString;
    End;
    PutSingleRecord(MTables.Lines.Strings[L]);
    Query.Next;
   End;
  Except
    SError('Error durning trying read records. Table:'+MTables.Lines.Strings[L]);
  End;
 End;

 CloseFile(F);
 Panel.Caption := '';
 Panel.Refresh;

 Info('Export finished');
end;

procedure TFSuperUnion.BCloseClick(Sender: TObject);
begin
 Close;
end;

end.
