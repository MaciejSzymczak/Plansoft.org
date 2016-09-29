unit UFMultiFileEksport;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, DBGrids, StdCtrls, ExtCtrls, Db, DBTables, Buttons, ComCtrls,
  Placemnt;

type
  TFMultiFileEksport = class(TForm)
    GroupBox1: TGroupBox;
    SQL: TMemo;
    Query: TQuery;
    Panel1: TPanel;
    DBGrid: TDBGrid;
    BRefresh: TBitBtn;
    BExport: TBitBtn;
    DataSource: TDataSource;
    Label1: TLabel;
    EGROUP: TEdit;
    Label2: TLabel;
    EFILE: TEdit;
    Label3: TLabel;
    EPath: TEdit;
    StatusBar: TStatusBar;
    Splitter1: TSplitter;
    Label4: TLabel;
    ESep: TEdit;
    LOgranicznik: TLabel;
    EDelimiter: TEdit;
    Label5: TLabel;
    EFOLDER: TEdit;
    Label6: TLabel;
    EOrphColumns: TEdit;
    Storage: TFormStorage;
    Image1: TImage;
    BClose: TBitBtn;
    procedure BRefreshClick(Sender: TObject);
    procedure BExportClick(Sender: TObject);
    procedure BCloseClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FMultiFileEksport: TFMultiFileEksport;

Procedure ShowModal;

implementation

{$R *.DFM}

Procedure ShowModal;
Begin
 Application.CreateForm(TFMultiFileEksport, FMultiFileEksport);
 FMultiFileEksport.ShowModal;
 FMultiFileEksport.Free;
End;

procedure TFMultiFileEksport.BRefreshClick(Sender: TObject);
begin
 Query.Close;
 Query.SQL := SQL.Lines;
 Query.Open;
end;

procedure TFMultiFileEksport.BExportClick(Sender: TObject);
Var F : TextFile;
    FileName : ShortString;
    I        : Integer;
    PriorGroup : ShortString;

Function Ogranicznik(S : String) : String;
Var Ogr : Char;
    I   : Integer;
Begin
 If Length(EDelimiter.Text) > 0 Then Begin
  Ogr := EDelimiter.Text[1];
  Result := '';
   For I := 1 To Length(S) Do
     If S[I] <> Ogr Then Result := Result + S[I]
                    Else Result := Result + S[I] + S[I];

  Result := Ogr + Result + Ogr;
 End
 Else Result := S;
End;


begin
  Query.DisableControls;

  Query.First;
  PriorGroup := Query.FieldByName(EGroup.Text).AsString;

  FileName := Query.FieldByName(EFile.Text).AsString;
  {$I-} MkDir(EPath.Text+Query.FieldByName(EFOLDER.TEXT).AsString ); {$I+}
  AssignFile(F,EPath.Text+Query.FieldByName(EFOLDER.TEXT).AsString+'\'+FileName);
  Try ReWrite(F); Except End;

  // naglowek
  For I := 0 To Query.FieldCount - 1 - StrToInt(EOrphColumns.Text) Do Begin
    Write(F, Ogranicznik(Query.Fields[I].FieldName));
    If I <> Query.FieldCount - 1 - StrToInt(EOrphColumns.Text) Then Write(F, ESep.Text);
  End;
  WriteLn(F);

  // dane
  While Not Query.EOF Do Begin
   StatusBar.SimpleText := Query.FieldByName(EFile.Text).AsString;
   StatusBar.Refresh;

   For I := 0 To Query.FieldCount - 1 - StrToInt(EOrphColumns.Text) Do Begin
     Write(F, Ogranicznik(Query.Fields[I].AsString));
     If I <> Query.FieldCount - 1 - StrToInt(EOrphColumns.Text) Then Write(F, ESep.Text);
   End;
   WriteLn(F);

   Query.Next;

   If Not Query.Eof Then
   If PriorGroup <> Query.FieldByName(EGroup.Text).AsString Then Begin
    PriorGroup := Query.FieldByName(EGroup.Text).AsString;
    CloseFile(F);
    FileName := Query.FieldByName(EFile.Text).AsString;
    {$I-} MkDir(EPath.Text+Query.FieldByName(EFOLDER.TEXT).AsString ); {$I+}
    AssignFile(F,EPath.Text+Query.FieldByName(EFOLDER.TEXT).AsString+'\'+FileName);
    Try ReWrite(F); Except End;
    // naglowek
    For I := 0 To Query.FieldCount - 1 - StrToInt(EOrphColumns.Text) Do Begin
      Write(F, Ogranicznik(Query.Fields[I].FieldName));
      If I <> Query.FieldCount - 1  - StrToInt(EOrphColumns.Text) Then Write(F, ESep.Text);
    End;
    WriteLn(F);
   End;

  End;

  CloseFile(F);

  Query.EnableControls;

  ShowMessage('Eksport zakonczyl sie');
end;



procedure TFMultiFileEksport.BCloseClick(Sender: TObject);
begin
 Close;
end;

end.
