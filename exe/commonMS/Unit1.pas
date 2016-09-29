unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, Db, DBTables, ExtCtrls, Grids, DBGrids, ComCtrls,
  Placemnt, DBLists, Paldial, ToolWin, ShellApi, StrHlder;

type
  TFMain = class(TForm)
    Query1: TQuery;
    Panel1: TPanel;
    Edit1: TEdit;
    Label1: TLabel;
    Database1: TDatabase;
    OpenDialog1: TOpenDialog;
    BitBtn2: TBitBtn;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    DBGrid1: TDBGrid;
    Panel2: TPanel;
    BWykonaj: TBitBtn;
    DS1: TDataSource;
    Memo1: TMemo;
    Storage: TFormStorage;
    BPolacz: TBitBtn;
    TabSheet3: TTabSheet;
    BDEItems: TBDEItems;
    DBGrid2: TDBGrid;
    BDEItemsNAME: TStringField;
    BDEItemsDESCRIPTION: TStringField;
    BDEItemsPHYNAME: TStringField;
    BDEItemsDBTYPE: TStringField;
    BDE: TDataSource;
    Panel3: TPanel;
    BitBtn1: TBitBtn;
    TabSheet4: TTabSheet;
    DBItems: TDatabaseItems;
    Tabele: TDataSource;
    Panel4: TPanel;
    RefreshTables: TBitBtn;
    Etems: TDBGrid;
    PD: TPaletteDial;
    FD: TFontDialog;
    ToolBar1: TToolBar;
    BExecSQL: TBitBtn;
    Paleta: TBitBtn;
    Load: TBitBtn;
    Save: TBitBtn;
    Font: TBitBtn;
    Ask: TSpeedButton;
    Send: TBitBtn;
    SaveAs: TBitBtn;
    SD: TSaveDialog;
    ToolBar2: TToolBar;
    F: TBitBtn;
    PDKomendySQL: TPaletteDial;
    PanelJeden: TPanel;
    P: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    SQL3: TEdit;
    SQL2: TEdit;
    SQL1: TEdit;
    PanelDwa: TPanel;
    Splitter1: TSplitter;
    BitBtn6: TBitBtn;
    SQL4: TEdit;
    BitBtn7: TBitBtn;
    SQL5: TEdit;
    BitBtn8: TBitBtn;
    SQL6: TEdit;
    StartTransaction: TBitBtn;
    Commit: TBitBtn;
    Rollback: TBitBtn;
    InTransaction: TLabel;
    Notatki: TTabSheet;
    N: TMemo;
    Historia: TTabSheet;
    H: TMemo;
    Zamknij: TBitBtn;
    EPREFIX: TEdit;
    Prefix: TLabel;
    Full: TTabSheet;
    DBGrid3: TDBGrid;
    PFULL: TPanel;
    Splitter2: TSplitter;
    Panel6: TPanel;
    BitBtn3: TBitBtn;
    QueryFull: TQuery;
    DSFULL: TDataSource;
    PAGESQL: TPageControl;
    T1: TTabSheet;
    T2: TTabSheet;
    T3: TTabSheet;
    T4: TTabSheet;
    T5: TTabSheet;
    T6: TTabSheet;
    FULLSQL6: TMemo;
    FULLSQL1: TMemo;
    FULLSQL2: TMemo;
    FULLSQL3: TMemo;
    FULLSQL4: TMemo;
    FULLSQL5: TMemo;
    robo: TTabSheet;
    FULLSQL: TMemo;
    SDialog: TSaveDialog;
    BitBtn9: TBitBtn;
    TABELA: TLabel;
    Splitter3: TSplitter;
    DBTabele: TDBGrid;
    TableItems: TTableItems;
    DSTableItems: TDataSource;
    RefreshItems: TBitBtn;
    BitBtn10: TBitBtn;
    BitBtn11: TBitBtn;
    procedure BExecSQLClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure LoadClick(Sender: TObject);
    procedure SaveClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BitBtn2Click(Sender: TObject);
    procedure BWykonajClick(Sender: TObject);
    procedure BPolaczClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure RefreshTablesClick(Sender: TObject);
    procedure PaletaClick(Sender: TObject);
    procedure FontClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure AskClick(Sender: TObject);
    procedure SendClick(Sender: TObject);
    procedure SaveAsClick(Sender: TObject);
    procedure PClick(Sender: TObject);
    procedure FClick(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure BitBtn6Click(Sender: TObject);
    procedure BitBtn7Click(Sender: TObject);
    procedure BitBtn8Click(Sender: TObject);
    procedure StartTransactionClick(Sender: TObject);
    procedure CommitClick(Sender: TObject);
    procedure RollbackClick(Sender: TObject);
    procedure InTransactionClick(Sender: TObject);
    procedure PanelJedenResize(Sender: TObject);
    Function  ZachowajPlik :Boolean;
    procedure ZamknijClick(Sender: TObject);
    procedure SQL1Change(Sender: TObject);
    procedure SQL1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn9Click(Sender: TObject);
    procedure Memo1Change(Sender: TObject);
    procedure RefreshItemsClick(Sender: TObject);
    procedure BitBtn10Click(Sender: TObject);
    procedure BitBtn11Click(Sender: TObject);
  private
    ExitChange : Boolean;
  public
  end;

var
  FMain: TFMain;

implementation

uses UFInfo, CommonUtility;

{$R *.DFM}

Procedure ExecSQL;
Begin

End;

procedure TFMain.BExecSQLClick(Sender: TObject);
Var T : Integer;
    Text : String;
 Procedure RUN;
 Begin
  If Trim(Query1.SQL.CommaText)<>'' Then Begin
    try
     FMain.Query1.ExecSQL;
    except
     on E:EDatabaseError Do Begin
      ShowMessage('Wywo³anie ' + Query1.SQL.CommaText + ' nie powiod³o siê !' + #13 + #10 + E.Message);
     End Else ShowMessage('Wywo³anie ' + Query1.SQL.CommaText + ' nie powiod³o siê !' + #13 + #10 + 'B³¹d inny ni¿ EDataBaseError');
    end;
    Query1.SQL.Clear;
   End;
 End;
begin
 If Not DataBase1.Connected Then BPolaczClick(nil);
 Query1.SQL.Clear;
 For t:=0 To Memo1.Lines.Count-1 Do Begin
  Text := Memo1.Lines.Strings[t];
  If (UpperCase(Copy(Text,1,3)) <> 'REM') and (UpperCase(Copy(Text,1,6)) <> 'PROMPT') And (UpperCase(Copy(Text,1,1)) <> ';') Then Begin
   If Length(Text)<>0 Then Query1.SQL.Add(Text)
    Else RUN;
  End;
 End;
 RUN;
 ShowMessage('OK !');
end;

procedure TFMain.FormCreate(Sender: TObject);
{Var t : Integer;}
begin
 {Combo.Items.Clear;
 For t:= 0 To Session.DatabaseCount -1 Do
  Combo.Items.Add(Session.Databases[t].DatabaseName)}
end;

procedure TFMain.LoadClick(Sender: TObject);
begin
 If Not ZachowajPlik Then Abort;
 With OpenDialog1 Do
 If Execute Then
  Begin
   Memo1.Lines.LoadFromFile(FileName);
   Save.Enabled := True;
   BExecSQL.Enabled := True;
   SaveAs.Enabled := True;
   Zamknij.Enabled := True;
   Memo1.Visible := True;
   ActiveControl := Memo1;
   Self.Caption := 'Turbo SQL. Plik:'+FileName;
  End;
end;


procedure TFMain.SaveClick(Sender: TObject);
begin
 Memo1.Lines.SaveToFile(OpenDialog1.FileName);
end;

Function TFMain.ZachowajPlik :Boolean;
Var S : String;
    I : Integer;
begin
 S := 'Czy zachowaæ plik '+OpenDialog1.FileName+' ?' + CHar(0);
 If Save.Enabled Then Begin
  I := MessageBox(0, @S[1],'',MB_YESNOCANCEL);
  If  I = ID_YES Then Memo1.Lines.SaveToFile(OpenDialog1.FileName);
  If I = ID_CANCEL Then Result := False Else Result := True;
 End;
end;

procedure TFMain.FormClose(Sender: TObject; var Action: TCloseAction);
Begin
 If Not ZachowajPlik Then Abort;
End;

procedure TFMain.BitBtn2Click(Sender: TObject);
Var t,i : Integer;
begin
 For t:=0 To Memo1.Lines.Count-1 Do Begin
  i := Pos(' : ',Memo1.Lines.Strings[t]);
  If i<>0 Then Memo1.Lines.Strings[t] := 'ReadLn(F,' + Copy(Memo1.Lines.Strings[t], 1, i-1) + ');'
          Else Memo1.Lines.Strings[t] := '';
 End;
end;

procedure TFMain.BWykonajClick(Sender: TObject);
Var Str : String;
begin
 If  (ActiveControl <> SQL1) And  (ActiveControl<>SQL2) And (ActiveControl<> SQL3) And (ActiveControl<> SQL4)And (ActiveControl<> SQL5) And (ActiveControl<> SQL6) Then Exit;
  If Not DataBase1.Connected Then BPolaczClick(nil);
 Query1.SQL.Clear;
 If ActiveControl = SQL1 Then Str := SQL1.Text;
 If ActiveControl = SQL2 Then Str := SQL2.Text;
 If ActiveControl = SQL3 Then Str := SQL3.Text;
 If ActiveControl = SQL4 Then Str := SQL4.Text;
 If ActiveControl = SQL5 Then Str := SQL5.Text;
 If ActiveControl = SQL6 Then Str := SQL6.Text;

 Query1.SQL.Add(Str);
 try
  H.Lines.Add(Str);
  Query1.Open;
 except
  on E:EDatabaseError Do Begin
   If E.Message <> 'Error creating cursor handle' Then Begin
    ShowMessage(E.Message);
    H.Lines.Add(E.Message);
   End Else Begin
    ShowMessage('OK !');
   End;
  End Else Begin ShowMessage('B³¹d inny ni¿ EDataBaseError'); Raise; End;
 end;


end;

procedure TFMain.BPolaczClick(Sender: TObject);
begin
 DataBase1.Connected := False;
 DataBase1.AliasName := Edit1.Text;
 DataBase1.Connected := True;
 RefreshTablesClick(nil);
end;


procedure TFMain.BitBtn1Click(Sender: TObject);
begin
 BDEItems.Active := False;
 BDEItems.Active := True;
end;

procedure TFMain.RefreshTablesClick(Sender: TObject);
begin
 DBItems.Active := False;
 DBItems.Active := True;
end;



procedure TFMain.PaletaClick(Sender: TObject);
begin
 If PD.Exec Then Begin
  OpenDialog1.FileName := PD.Result_;
  Memo1.Lines.LoadFromFile(PD.Result_);
  Save.Enabled := True;
  BExecSQL.Enabled := True;
  SaveAs.Enabled := True;
  Zamknij.Enabled := True;
  Memo1.Visible := True;
  ActiveControl := Memo1;
  Self.Caption := 'Turbo SQL. Plik:'+PD.Result_;
 End;
end;

procedure TFMain.FontClick(Sender: TObject);
begin
 FD.Font := Memo1.Font;
 If FD.Execute Then Memo1.Font := FD.Font;
end;






procedure TFMain.FormShow(Sender: TObject);
begin
 InTransactionClick(nil);
 ExitChange := False;
end;

procedure TFMain.AskClick(Sender: TObject);
begin
 FInfo.ShowModal;
end;


function ExecuteFile(const FileName, Params, DefaultDir: string;
  ShowCmd: Integer): THandle;
var
  zFileName, zParams, zDir: array[0..79] of Char;
begin
  Result := ShellExecute(Application.MainForm.Handle, nil,
    StrPCopy(zFileName, FileName), StrPCopy(zParams, Params),
    StrPCopy(zDir, DefaultDir), ShowCmd);
end;

procedure TFMain.SendClick(Sender: TObject);
begin
 If ExtractFileName(OpenDialog1.FileName) <> '' Then Begin
  SaveClick(nil);
  ExecuteFile('NotePad.exe',OpenDialog1.FileName,'',SW_SHOW);
  LoadClick(nil);
 End;
end;


procedure TFMain.SaveAsClick(Sender: TObject);
begin
 If SD.Execute Then Begin
  Memo1.Lines.SaveToFile(SD.FileName);
  OpenDialog1.FileName := SD.FileName;
  With OpenDialog1 Do
  {If Execute Then}
   Begin
    Memo1.Lines.LoadFromFile(FileName);
    Save.Enabled := True;
    BExecSQL.Enabled := True;
    SaveAs.Enabled := True;    
    Zamknij.Enabled := True;
    Memo1.Visible := True;
    ActiveControl := Memo1;
    Self.Caption := 'Turbo SQL. Plik:'+FileName;
   End;
  End;
end;




procedure TFMain.PClick(Sender: TObject);
begin
 If PDKomendySQL.Exec Then Begin
  SQL1.Text := PDKomendySQL.Result_;
  ActiveControl := SQL1;
 End;
end;

procedure TFMain.FClick(Sender: TObject);
begin
 FD.Font := DBGrid1.Font;
 If FD.Execute Then DBGrid1.Font := FD.Font;
end;




procedure TFMain.BitBtn4Click(Sender: TObject);
begin
 If PDKomendySQL.Exec Then Begin
  SQL2.Text := PDKomendySQL.Result_;
  ActiveControl := SQL2;
 End;

end;

procedure TFMain.BitBtn5Click(Sender: TObject);
begin
 If PDKomendySQL.Exec Then Begin
  SQL3.Text := PDKomendySQL.Result_;
  ActiveControl := SQL3;
 End;
end;








procedure TFMain.BitBtn6Click(Sender: TObject);
begin
 If PDKomendySQL.Exec Then Begin
  SQL4.Text := PDKomendySQL.Result_;
  ActiveControl := SQL4;
 End;

end;

procedure TFMain.BitBtn7Click(Sender: TObject);
begin
 If PDKomendySQL.Exec Then Begin
  SQL5.Text := PDKomendySQL.Result_;
  ActiveControl := SQL5;
 End;
end;

procedure TFMain.BitBtn8Click(Sender: TObject);
begin
 If PDKomendySQL.Exec Then Begin
  SQL6.Text := PDKomendySQL.Result_;
  ActiveControl := SQL6;
 End;
end;






Const BoolToStr : Array[False..True] of ShortString = ('Nie','Tak');

procedure TFMain.StartTransactionClick(Sender: TObject);
begin
 Database1.StartTransaction;
 InTransactionClick(nil);
end;



procedure TFMain.CommitClick(Sender: TObject);
begin
 Database1.Commit;
 InTransactionClick(nil);
end;

procedure TFMain.RollbackClick(Sender: TObject);
begin
 Database1.Rollback;
 InTransactionClick(nil);
end;

procedure TFMain.InTransactionClick(Sender: TObject);
begin
 InTransaction.Caption := 'W transakcji:'+BoolToStr[Database1.InTransaction];
 If Database1.InTransaction Then Begin
  StartTransaction.Enabled := False;
  Commit.Enabled := True;
  Rollback.Enabled := True;
 End
 Else Begin
  StartTransaction.Enabled := True;
  Commit.Enabled := False;
  Rollback.Enabled := False;
 End;
end;

procedure TFMain.PanelJedenResize(Sender: TObject);
begin
 SQL1.Width := PanelJeden.Width - 32;
 SQL2.Width := PanelJeden.Width - 32;
 SQL3.Width := PanelJeden.Width - 32;
end;



procedure TFMain.ZamknijClick(Sender: TObject);
begin
 If Not ZachowajPlik Then Abort;
 Memo1.Clear;
 Save.Enabled := False;
 BExecSQL.Enabled := False;
 SaveAs.Enabled := False;
 Zamknij.Enabled := False;
 Memo1.Visible := False;
end;


procedure TFMain.SQL1Change(Sender: TObject);
Var P : Integer;
    W : ShortString;
Function NazwaTabeli : ShortString;
Begin
  If POS(EPREFIX.Text, DBItems.FieldByName('NAME').AsString)=1 Then
   Result := Copy(DBItems.FieldByName('NAME').AsString, Length(EPREFIX.Text)+1, 65000)
  Else
   Result := DBItems.FieldByName('NAME').AsString;
End;

Procedure Autokorekta(SearchString, NewString : ShortString);
Begin
 If POS(SearchString, UPPERCASE((Sender as TEdit).Text)) = 1 Then Begin
  (Sender as TEdit).Text := NewString + COPY((Sender as TEdit).Text, Length(SearchString),65000);
  (Sender as TEdit).SelStart := Length((Sender as TEdit).Text);
 End;
End;

begin
 If ExitChange Then Begin
  ExitChange := False;
  Exit;
 End;

 Autokorekta('S ','SELECT * FROM ');
 Autokorekta('SC ','SELECT COUNT(*) FROM ');
 Autokorekta('SD ','SELECT DISTINCT * FROM ');
 Autokorekta('U ','UPDATE  SET ');
 Autokorekta('D ','DELETE FROM  WHERE ');
 Autokorekta('I ','INSERT INTO  VALUES ');

 TABELA.Caption := '';
 P := Length((Sender as TEdit).Text);
 If P >= 1 Then Begin
  W := '';
  While (P>=1) And ((Sender as TEdit).Text[P]<>' ') Do Begin
   W := (Sender as TEdit).Text[P] + W;
   P := P - 1;
  End;

   If DBItems.Active Then Begin
    W := UPPERCASE(W);
    DBItems.First;
    While Not DBItems.EOF Do Begin
     If POS(W,NazwaTabeli) = 1 Then Begin
      TABELA.Caption := COPY(NazwaTabeli, Length(W)+1,65000);
     End;
     DBItems.Next;
    End;
   End;
 End;

 If Length(TABELA.Caption) <> 0 Then Begin
   P := Length((Sender as TEdit).Text);
   ExitChange := True;
  (Sender as TEdit).Text := (Sender as TEdit).Text + TABELA.Caption;
  (Sender as TEdit).SelStart := P;
  (Sender as TEdit).SelLength := Length(TABELA.Caption);
 End;
end;

procedure TFMain.SQL1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 If Key = 45 Then (Sender as TEdit).Text := (Sender as TEdit).Text + TABELA.Caption;
end;

procedure TFMain.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 If ((Key = 46) Or (Key = 8)) And
 ((ActiveControl = SQL1) Or (ActiveControl = SQL2) Or(ActiveControl = SQL3) Or(ActiveControl = SQL4) Or(ActiveControl = SQL5) Or(ActiveControl = SQL6))
  Then ExitChange := True;
end;







procedure TFMain.BitBtn3Click(Sender: TObject);
begin
 If PAGESQL.ActivePage = T1 Then FullSQL.Lines.Assign(FullSQL1.Lines);
 If PAGESQL.ActivePage = T2 Then FullSQL.Lines.Assign(FullSQL2.Lines);
 If PAGESQL.ActivePage = T3 Then FullSQL.Lines.Assign(FullSQL3.Lines);
 If PAGESQL.ActivePage = T4 Then FullSQL.Lines.Assign(FullSQL4.Lines);
 If PAGESQL.ActivePage = T5 Then FullSQL.Lines.Assign(FullSQL5.Lines);
 If PAGESQL.ActivePage = T6 Then FullSQL.Lines.Assign(FullSQL6.Lines);

 If Not DataBase1.Connected Then BPolaczClick(nil);
 QueryFull.SQL.Assign(FullSQL.Lines);
 try
  H.Lines.AddStrings(FullSQL.Lines);
  QueryFull.Open;
 except
  on E:EDatabaseError Do Begin
   If E.Message <> 'Error creating cursor handle' Then Begin
    ShowMessage(E.Message);
    H.Lines.Add(E.Message);
   End Else Begin
    ShowMessage('OK !');
   End;
  End Else ShowMessage('B³¹d inny ni¿ EDataBaseError');
 end;

end;




















procedure TFMain.BitBtn9Click(Sender: TObject);
Var F : TextFile;
    L : Integer;
    LiczbaKolumn : Integer;
begin
 If SDialog.Execute Then Begin
  Query1.DisableControls;
  AssignFile(F, SDialog.FileName);
  ReWrite(F);

  LiczbaKolumn := DBGrid1.Columns.Count - 1;
  For L := 0 To LiczbaKolumn Do Write(F, DBGrid1.Columns[L].Title.Caption + #9);
  WriteLn(F);

  Query1.First;
  While Not Query1.EOF Do Begin
   For L := 0 To LiczbaKolumn Do Write(F, Query1.FieldByName(DBGrid1.Columns[L].FieldName).AsString+ #9);
   WriteLn(F);
   Query1.Next;
  End;
  Query1.EnableControls;
  CloseFile(F);
 End;
end;



procedure TFMain.Memo1Change(Sender: TObject);
begin
 //Info('OnChange');
end;


procedure TFMain.RefreshItemsClick(Sender: TObject);
begin
 TableItems.TableName := DBItems.Fields[0].AsString;
 TableItems.Close;
 TableItems.Open;
end;

procedure TFMain.BitBtn10Click(Sender: TObject);
begin
 FInfo.ShowModal;
end;


procedure TFMain.BitBtn11Click(Sender: TObject);
Var TABLE, Res : String;
    t : Integer;
begin
 If Not DataBase1.Connected Then BPolaczClick(nil);
 TABLE := InputBox('Nazwa tabeli','','');
 Query1.SQL.Clear;
 Query1.SQL.Add('Select * from '+TABLE);
 Query1.Open;
 Res := '';
 For t:=0 To Query1.FieldCount-1 Do Begin
  If Res <>'' Then Res := Res + ', ';
  Res := Res + Query1.Fields[t].FieldName;
 End;
 SQL1.Text := 'SELECT '+RES+' FROM '+TABLE;
end;

end.
