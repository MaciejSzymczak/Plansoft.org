unit UFEksport;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, ComCtrls, dbtables, Grids, DBGrids, UUtilityPArent,
  Menus, db, Placemnt, adodb;

type
  TFEksport = class(TForm)
    Panel1: TPanel;
    BClose: TBitBtn;
    PageControl: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Label1: TLabel;
    FileName: TEdit;
    Label2: TLabel;
    Sep: TEdit;
    Label3: TLabel;
    Ogranicznik: TEdit;
    Label4: TLabel;
    FileName2: TEdit;
    SDialogTxt: TSaveDialog;
    BitBtn1: TBitBtn;
    Transpon: TCheckBox;
    RunAfterGenerating: TCheckBox;
    BitBtn3: TBitBtn;
    RunAfterGenerating2: TCheckBox;
    TABLENAME: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    InsertCR: TEdit;
    Label7: TLabel;
    EmptyValue: TEdit;
    Srednik: TCheckBox;
    EmptyLine: TCheckBox;
    CreateTable: TCheckBox;
    Configuration: TStringGrid;
    BitBtn4: TBitBtn;
    CheckBox1: TCheckBox;
    PopupMenu: TPopupMenu;
    OracleVARCHAR21: TMenuItem;
    OracleNUMBER1: TMenuItem;
    OracleNUMBER142kwota1: TMenuItem;
    OracleDATA1: TMenuItem;
    Panel2: TPanel;
    BitBtn5: TBitBtn;
    BitBtn6: TBitBtn;
    BitBtn7: TBitBtn;
    BitBtn8: TBitBtn;
    SDialogSQL: TSaveDialog;
    BitBtn9: TBitBtn;
    BOpen: TBitBtn;
    BSaveAs: TBitBtn;
    SDialogCFG: TSaveDialog;
    ODialogCFG: TOpenDialog;
    Edit1: TEdit;
    Storage: TFormStorage;
    CHBLOCK: TCheckBox;
    Image1: TImage;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure OracleVARCHAR21Click(Sender: TObject);
    procedure OracleNUMBER1Click(Sender: TObject);
    procedure OracleNUMBER142kwota1Click(Sender: TObject);
    procedure OracleDATA1Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure BitBtn6Click(Sender: TObject);
    procedure BitBtn8Click(Sender: TObject);
    procedure BitBtn7Click(Sender: TObject);
    procedure BitBtn9Click(Sender: TObject);
    procedure BSaveAsClick(Sender: TObject);
    procedure BOpenClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BCloseClick(Sender: TObject);
  private
    Query : TADOQuery;
    Grid  : TDBGrid;

    Procedure Export1;
    Procedure Export2;
  public
    Procedure ReadFile(FileName : TFileName);
  end;

var
  FEksport: TFEksport;

Const Visibled : Boolean = False;

Procedure Show(aQuery : TADOQuery; aGrid : TDBGrid; FName : TFileName);

implementation

{$R *.DFM}

Procedure Show(aQuery : TADOQuery; aGrid : TDBGrid; FName : TFileName);
Begin
 If Visibled Then Begin
  Info('Eksport jest ju¿ uruchomiony');
 End;
 Visibled := True;
 //Application.CreateForm(TFEksport, FEksport);
 FEksport.Query := aQuery;
 FEksport.Grid := aGrid;

 With FEksport Do Begin
  Configuration.Cells[0,0] := 'Nazwa pola';
  Configuration.Cells[1,0] := 'Typ pola';
  Configuration.Cells[2,0] := 'Przedrostek';
  Configuration.Cells[3,0] := 'Przyrostek';
  Configuration.Cells[4,0] := 'Status';

  TABLENAME.Text := GetTableName(Query.SQL.Text);
  BitBtn4Click(NIL);

  If Trim(FName) <> '' Then Begin
   ReadFile(FName);
   BitBtn9Click(nil);
   Application.Terminate;
   Close;
  End;

  FEksport.Show;
 End;
 //FEksport.Free;
 //Visible := False; - w on close formularza
End;

Function X(S, Delimiter : String) : String;
Var Temp : String;
    T    : Integer;

Begin
 Temp := '';
 For T := 1 To Length(S) Do
  If S[t] = Copy(Delimiter,1,1) Then Temp := Temp + S[t] + S[t]
                                Else Temp := Temp + S[t];

 Result := Delimiter + Temp + Delimiter;
End;

Function Aphostrofe(S : String) : String;
Var Temp : String;
    T    : Integer;
Begin
 Temp := '';
 For T := 1 To Length(S) Do
  If S[t] = '''' Then Temp := Temp + S[t] + S[t]
                 Else Temp := Temp + S[t];

 Result := Temp;
End;

Function Y(S: String; NullStr, PreFix, PostFix : String) : String;
Begin
 If S = '' Then Result := NullStr
           Else Result := PreFix +  Aphostrofe(S) + PostFix;
End;

procedure TFEksport.BitBtn1Click(Sender: TObject);
begin
 SDialogTxt.FileName := FileName.Text;
 If SDialogTxt.Execute Then FileName.Text := SDialogTxt.FileName;
end;

procedure TFEksport.BitBtn3Click(Sender: TObject);
begin
 SDialogSQL.FileName := FileName2.Text;
 If SDialogSQL.Execute Then FileName2.Text := SDialogSQL.FileName;
end;

procedure TFEksport.BitBtn4Click(Sender: TObject);
Var LiczbaKolumn : Integer;
    L            : Integer;
 Procedure GetFieldTypeAndSepeartors(Name : String; Var FieldType, Sep1, Sep2, Status : String);
 Var Field : TField;
     DS    : String; {display width}
 Begin
  Field := Query.FieldByName(Name);
  DS    := IntToStr(Field.DisplayWidth);
  If  Field Is TIntegerField  Then Begin FieldType := 'NUMBER('+DS+')';   Sep1:='';           Sep2:='';                   Status := ''; End Else
  If  Field Is TStringField   Then Begin FieldType := 'VARCHAR2('+DS+')'; Sep1:='''';         Sep2:='''';                 Status := ''; End Else
  If  Field Is TDateTimeField Then Begin FieldType := 'DATE';             Sep1:='TO_DATE('''; Sep2:=''',''yyyy.mm.dd'')'; Status := 'W¹tpliwa maska pola'; End Else
  If  Field Is TMemoField     Then Begin FieldType := 'VARCHAR2(2000)';             Sep1:='''';           Sep2:='''';                   Status := 'Pole typu MEMO'; End Else
  If  Field Is TFloatField    Then Begin FieldType := 'NUMBER('+DS+',2)'; Sep1:='';           Sep2:='';                   Status := 'W¹tpliwa d³ugoœæ pola'; End Else
  Begin FieldType := 'VARCHAR2('+DS+')'; Sep1:='''';         Sep2:='''';   Status := 'Nieznany typ pola';                End;
 End;

Var FieldType, Sep1, Sep2, Status : String;

begin
  LiczbaKolumn := Grid.Columns.Count-1;
  Configuration.RowCount := LiczbaKolumn + 2;

    For L := 0 To LiczbaKolumn Do Begin
     Configuration.Cells[0,L+1] := Grid.Columns[L].Title.Caption;
     GetFieldTypeAndSepeartors(Grid.Columns[L].Title.Caption,FieldType, Sep1, Sep2, Status);
     Configuration.Cells[1,L+1] := FieldType;
     Configuration.Cells[2,L+1] := Sep1;
     Configuration.Cells[3,L+1] := Sep2;
     Configuration.Cells[4,L+1] := Status;
    End;

end;

procedure TFEksport.OracleVARCHAR21Click(Sender: TObject);
begin
 Configuration.Cells[1,Configuration.Row] := 'VARCHAR2(255)';
 Configuration.Cells[2,Configuration.Row] := '''';
 Configuration.Cells[3,Configuration.Row] := '''';
end;

procedure TFEksport.OracleNUMBER1Click(Sender: TObject);
begin
 Configuration.Cells[1,Configuration.Row] := 'NUMBER(10)';
 Configuration.Cells[2,Configuration.Row] := '';
 Configuration.Cells[3,Configuration.Row] := '';
end;

procedure TFEksport.OracleNUMBER142kwota1Click(Sender: TObject);
begin
 Configuration.Cells[1,Configuration.Row] := 'NUMBER(14,2)';
 Configuration.Cells[2,Configuration.Row] := '';
 Configuration.Cells[3,Configuration.Row] := '';
end;

procedure TFEksport.OracleDATA1Click(Sender: TObject);
begin
 Configuration.Cells[1,Configuration.Row] := 'DATE';
 Configuration.Cells[2,Configuration.Row] := 'TO_DATE(''';
 Configuration.Cells[3,Configuration.Row] := ''',''YYYY.MM.DD'')';
end;

procedure TFEksport.BitBtn5Click(Sender: TObject);
begin
OracleVARCHAR21Click(NIL);
end;

procedure TFEksport.BitBtn6Click(Sender: TObject);
begin
 OracleNUMBER1Click(nil);
end;

procedure TFEksport.BitBtn8Click(Sender: TObject);
begin
 OracleNUMBER142kwota1Click(nil);
end;

procedure TFEksport.BitBtn7Click(Sender: TObject);
begin
 OracleDATA1Click(nil);
end;

Procedure TFEksport.Export1;
Var F : TextFile;
    L : Integer;
    LiczbaKolumn : Integer;
begin
 If Transpon.Checked Then Begin
  Query.DisableControls;
  AssignFile(F, FileName.Text);
  ReWrite(F);

  LiczbaKolumn := Grid.Columns.Count - 1;
  For L := 0 To LiczbaKolumn Do Begin
   Write(F, X(Grid.Columns[L].Title.Caption,Ogranicznik.Text));
   Query.First;
   While Not Query.EOF Do Begin
     Write(F, Sep.Text);
     Write(F, X(Query.FieldByName(Grid.Columns[L].FieldName).AsString, Ogranicznik.Text));
     Query.Next;
    End;
   WriteLn(F);
  End;
  Query.EnableControls;
  CloseFile(F);
 End
 Else Begin
  Query.DisableControls;
  AssignFile(F, FileName.Text);
  ReWrite(F);

  LiczbaKolumn := Grid.Columns.Count - 1;
  For L := 0 To LiczbaKolumn Do Begin
   Write(F, X(Grid.Columns[L].Title.Caption,Ogranicznik.Text));
   If L < LiczbaKolumn Then Write(F, Sep.Text);
  End;
  WriteLn(F);

  Query.First;
  While Not Query.EOF Do Begin
   For L := 0 To LiczbaKolumn Do Begin
    Write(F, X(Query.FieldByName(Grid.Columns[L].FieldName).AsString, Ogranicznik.Text));
    If L < LiczbaKolumn Then Write(F, Sep.Text);
   End;
   WriteLn(F);
   Query.Next;
  End;
  Query.EnableControls;
  CloseFile(F);
 End;

 If RunAfterGenerating.Checked Then ExecuteFile('NotePad.exe',FileName.Text,'',SW_MAXIMIZE);
end;

Procedure TFEksport.Export2;
Var F : TextFile;
    L : Integer;
    LiczbaKolumn : Integer;
    SQL          : String;
    NInsertCR    : Integer;
    CRCount      : Integer;
begin
  If CHBLOCK.Checked Then
  For L := 1 To Configuration.RowCount-1 Do
   If Trim(Configuration.Cells[4,L]) <> '' Then Begin
     SError('S¹ kolumny o w¹tpliwym statusie. Popraw statusy tych kolumn lub wy³¹cz opcjê "Blokuj eksport, gdy statusy kolumn s¹ w¹tpliwe" i uruchom eksport ponownie');
     Exit;
   End;

  Query.DisableControls;
  AssignFile(F, FileName2.Text);
  ReWrite(F);

  NInsertCR := StrToInt(InsertCR.Text);
  CRCount := 0;

  LiczbaKolumn := Grid.Columns.Count - 1;

  If CreateTable.Checked Then Begin
    WriteLn(F, 'CREATE TABLE '+TableName.Text+' (');
    For L := 0 To LiczbaKolumn Do Begin
     Write(F, Configuration.Cells[0,L+1]+#9+Configuration.Cells[1,L+1]);
     If L < LiczbaKolumn Then WriteLn(F, ',');
    End;
   Write(F,')');
   If Srednik.Checked Then Write(F,';');
   If EmptyLine.Checked Then WriteLn(F);
   WriteLn(F);
  End;

  SQL := 'INSERT INTO '+TableName.Text+' (';
  For L := 0 To LiczbaKolumn Do Begin
   SQL := SQL +  Configuration.Cells[0,L+1];
   If L < LiczbaKolumn Then SQL := SQL +  Sep.Text;
   CrCount := CrCount + 1;
   If CrCount = NInsertCR Then Begin
    CrCount := 0;
    SQL := SQL + #13+#10;
   End;
  End;
  SQL := SQL + ') VALUES (';
  If NInsertCR <> 0 Then SQL := SQL + #13+#10;

  Query.First;
  CrCount := 0;
  While Not Query.EOF Do Begin
   Write(F, SQL);
   For L := 0 To LiczbaKolumn Do Begin
    Write(F, Y(Query.FieldByName(Grid.Columns[L].FieldName).AsString, EmptyValue.Text, Configuration.Cells[2,L+1], Configuration.Cells[3,L+1]));
    If L < LiczbaKolumn Then Write(F, Sep.Text);
    CrCount := CrCount + 1;
    If CrCount = NInsertCR Then Begin
     CrCount := 0;
     WriteLn(F);
    End;
   End;
   Write(F,')');
   If Srednik.Checked Then Write(F,';');
   If EmptyLine.Checked Then WriteLn(F);
   WriteLn(F);

   Query.Next;
  End;
  Query.EnableControls;
  CloseFile(F);

 If RunAfterGenerating2.Checked Then ExecuteFile('NotePad.exe',FileName2.Text,'',SW_MAXIMIZE);
end;

procedure TFEksport.BitBtn9Click(Sender: TObject);
begin
 If PageControl.ActivePage = TabSheet1 Then Export1
                                       Else Export2;
end;


procedure TFEksport.BSaveAsClick(Sender: TObject);
Var F : TextFile;
    L : Integer;
begin
 IF Not SDialogCFG.Execute Then Exit;

  AssignFile(F, SDialogCFG.FileName);
  ReWrite(F);

  With Configuration Do Begin
  WriteLn(F,RowCount);
  For L := 0 To RowCount-1 Do Begin
   WriteLn(F,Cells[0,L]);
   WriteLn(F,Cells[1,L]);
   WriteLn(F,Cells[2,L]);
   WriteLn(F,Cells[3,L]);
   WriteLn(F,Cells[4,L]);
  End;
  End;
  WriteLn(F, FileName2.Text);
  WriteLn(F, TABLENAME.Text);
  WriteLn(F, InsertCR.Text);
  WriteLn(F, EmptyValue.Text);
  WriteLn(F, RunAfterGenerating2.Checked);
  WriteLn(F, Srednik.Checked);
  WriteLn(F, EmptyLine.Checked);
  WriteLn(F, CreateTable.Checked);
  WriteLn(F, CheckBox1.Checked);
  WriteLn(F, CHBLOCK.Checked);

  CloseFile(F);
end;

Procedure TFEksport.ReadFile(FileName : TFileName);
Var F : TextFile;
    L, Counter : Integer;
    S  : String;
Begin
  AssignFile(F, FileName);
  FileMode := 0;
  Reset(F);

  Try
  ReadLn(F,Counter);
  Except
   Counter := -1;
  End;

  If Counter <> Configuration.RowCount Then Begin
   SError('Plik konfiguracyjny nie odpowiada zawartoœci siatki');
   CloseFile(F);
   Exit;
  End;

  CloseFile(F);
  //
  AssignFile(F, FileName);
  FileMode := 0;
  Reset(F);

  ReadLn(F,Counter);

  With Configuration Do Begin
  Configuration.RowCount := Counter;
  For L := 0 To RowCount-1 Do Begin
   ReadLn(F,S); Cells[0,L] := S;
   ReadLn(F,S); Cells[1,L] := S;
   ReadLn(F,S); Cells[2,L] := S;
   ReadLn(F,S); Cells[3,L] := S;
   ReadLn(F,S); Cells[4,L] := S;
  End;
  End;

  ReadLn(F, S); FileName2.Text              := S;
  ReadLn(F, S); TABLENAME.Text              := S;
  ReadLn(F, S); InsertCR.Text               := S;
  ReadLn(F, S); EmptyValue.Text             := S;
  ReadLn(F, S); RunAfterGenerating2.Checked := S='TRUE';
  ReadLn(F, S); Srednik.Checked             := S='TRUE';
  ReadLn(F, S); EmptyLine.Checked           := S='TRUE';
  ReadLn(F, S); CreateTable.Checked         := S='TRUE';
  ReadLn(F, S); CheckBox1.Checked           := S='TRUE';
  ReadLn(F, S); CHBLOCK.Checked             := S='TRUE';

  CloseFile(F);
End;

procedure TFEksport.BOpenClick(Sender: TObject);
begin
 IF Not ODialogCFG.Execute Then Exit;
 ReadFile(ODialogCFG.FileName);
end;


procedure TFEksport.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 Visibled := False;
end;


procedure TFEksport.BCloseClick(Sender: TObject);
begin
 Close;
end;

end.
