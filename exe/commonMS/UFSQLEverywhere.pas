unit UFSQLEverywhere;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, Db, DBTables, ExtCtrls, Grids, DBGrids, ComCtrls,
  Placemnt, DBLists, ToolWin, ShellApi, StrHlder, DBCtrls, Menus, UUtilityParent,
  UFMemoToolbar, mxstore, mxDB, mxtables, mxgrid, mxpivsrc, UFCountRecords, UFMultifileEksport,
  UFSQLEverywhereModuleExpandQuery;

type
  TFSQLEverywhere = class(TForm)
    MainQuery: TQuery;
    Panel1: TPanel;
    Label1: TLabel;
    Database: TDatabase;
    OpenDialog1: TOpenDialog;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Grid: TDBGrid;
    Panel2: TPanel;
    DS1: TDataSource;
    Storage: TFormStorage;
    TabSheet3: TTabSheet;
    BDEItems: TBDEItems;
    DBGrid2: TDBGrid;
    BDEItemsNAME: TStringField;
    BDEItemsDESCRIPTION: TStringField;
    BDEItemsPHYNAME: TStringField;
    BDEItemsDBTYPE: TStringField;
    BDE: TDataSource;
    Panel3: TPanel;
    BRefreshBDEAliases: TBitBtn;
    TabSheet4: TTabSheet;
    DBItems: TDatabaseItems;
    Tabele: TDataSource;
    Panel4: TPanel;
    RefreshTables: TBitBtn;
    Etems: TDBGrid;
    FD: TFontDialog;
    SD: TSaveDialog;
    S: TToolBar;
    TSNotes: TTabSheet;
    N: TMemo;
    TSQueriesHistory: TTabSheet;
    H: TMemo;
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
    TABELA: TLabel;
    Splitter3: TSplitter;
    DBTabele: TDBGrid;
    TableItems: TTableItems;
    DSTableItems: TDataSource;
    RefreshItems: TBitBtn;
    TabSheet5: TTabSheet;
    Panel5: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    NazwaTabeli: TComboBox;
    WHERE: TEdit;
    ORDER: TEdit;
    GridAktualizacja: TDBGrid;
    QueryAktualizacja: TQuery;
    DSAktualizacja: TDataSource;
    DBNavigator1: TDBNavigator;
    BWykonajAktualizacja: TBitBtn;
    DatabaseName: TComboBox;
    PopupMenu: TPopupMenu;
    Zapiszwynik1: TMenuItem;
    Panel7: TPanel;
    AssistMemo: TMemo;
    Splitter4: TSplitter;
    Panel8: TPanel;
    MErrorsAndWarnings: TMemo;
    Panel9: TPanel;
    Label5: TLabel;
    ChStopOnError: TCheckBox;
    Panel10: TPanel;
    ScriptStatusBar: TStatusBar;
    BNew: TSpeedButton;
    Bload: TSpeedButton;
    BSave: TSpeedButton;
    BSaveAs: TSpeedButton;
    BExecSQL: TSpeedButton;
    BFontChange: TSpeedButton;
    BNotePad: TSpeedButton;
    BZamknij: TSpeedButton;
    BStartTransaction: TSpeedButton;
    BCommit: TSpeedButton;
    BRollback: TSpeedButton;
    MainMenu: TMainMenu;
    Plik1: TMenuItem;
    Edycja1: TMenuItem;
    Pomoc1: TMenuItem;
    Oprogramie1: TMenuItem;
    Zakocz1: TMenuItem;
    BConnect: TSpeedButton;
    Transakcje1: TMenuItem;
    MIStartTransaction: TMenuItem;
    MICommit: TMenuItem;
    MIRollback: TMenuItem;
    TabSheet6: TTabSheet;
    KindOfHint: TRadioGroup;
    BFont: TSpeedButton;
    BSQL: TSpeedButton;
    BExport: TSpeedButton;
    BTool: TSpeedButton;
    TabSheet7: TTabSheet;
    DecisionPivot: TDecisionPivot;
    DecisionSource: TDecisionSource;
    DecisionGrid1: TDecisionGrid;
    DecisionQuery: TDecisionQuery;
    DecisionCube: TDecisionCube;
    Panel11: TPanel;
    DecisionSQL: TMemo;
    Panel12: TPanel;
    SpeedButton1: TSpeedButton;
    GroupBox1: TGroupBox;
    HINTS: TMemo;
    AfterClickInColumn: TRadioGroup;
    TSOracle: TTabSheet;
    LFileName: TLabel;
    ObtainInExpression: TRadioGroup;
    Splitter5: TSplitter;
    EScript: TMemo;
    BWykonaj: TBitBtn;
    SQL1: TEdit;
    SQL2: TEdit;
    SQL3: TEdit;
    SQL4: TEdit;
    SQL5: TEdit;
    SQL6: TEdit;
    Panel13: TPanel;
    StatusBar: TStatusBar;
    Zliczaj: TBitBtn;
    Shape1: TShape;
    Light: TShape;
    EUserName: TEdit;
    EPassword: TEdit;
    Label6: TLabel;
    Label7: TLabel;
    BSuperUnion: TSpeedButton;
    SpeedButton2: TSpeedButton;
    BMultifileExport: TSpeedButton;
    DirectCoefficient: TEdit;
    CacheDirectCoefficient: TEdit;
    CacheDictionaryDirectCoefficient: TEdit;
    BitBtn1: TBitBtn;
    Memo1: TMemo;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    Utilities1: TMenuItem;
    MemoryStatus1: TMenuItem;
    DisksStatus1: TMenuItem;
    PackFilesinonefileonearchivemode1: TMenuItem;
    Converter1: TMenuItem;
    ExpandQuery: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BWykonajClick(Sender: TObject);
    procedure BRefreshBDEAliasesClick(Sender: TObject);
    procedure RefreshTablesClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure PClick(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure BitBtn6Click(Sender: TObject);
    procedure BitBtn7Click(Sender: TObject);
    procedure BitBtn8Click(Sender: TObject);
    procedure InTransactionClick(Sender: TObject);
    procedure PanelJedenResize(Sender: TObject);
    Function  ZachowajPlik :Boolean;
    procedure SQL1Change(Sender: TObject);
    procedure SQL1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure BitBtn3Click(Sender: TObject);
    procedure RefreshItemsClick(Sender: TObject);
    procedure BWykonajAktualizacjaClick(Sender: TObject);
    procedure NazwaTabeliChange(Sender: TObject);
    procedure Zapiszwynik1Click(Sender: TObject);
    procedure NazwaTabeliEnter(Sender: TObject);
    procedure GridTitleClick(Column: TColumn);
    procedure BNewClick(Sender: TObject);
    procedure BloadClick(Sender: TObject);
    procedure BPaletaClick(Sender: TObject);
    procedure BSaveClick(Sender: TObject);
    procedure BSaveAsClick(Sender: TObject);
    procedure BExecSQLClick(Sender: TObject);
    procedure BFontChangeClick(Sender: TObject);
    procedure BNotePadClick(Sender: TObject);
    procedure BZamknijClick(Sender: TObject);
    procedure BStartTransactionClick(Sender: TObject);
    procedure BCommitClick(Sender: TObject);
    procedure BRollbackClick(Sender: TObject);
    procedure Zakocz1Click(Sender: TObject);
    procedure BConnectClick(Sender: TObject);
    procedure MIStartTransactionClick(Sender: TObject);
    procedure MICommitClick(Sender: TObject);
    procedure MIRollbackClick(Sender: TObject);
    procedure BFontClick(Sender: TObject);
    procedure BSQLClick(Sender: TObject);
    procedure BExportClick(Sender: TObject);
    procedure BSuperUnionClick(Sender: TObject);
    procedure BToolClick(Sender: TObject);
    procedure AssistMemoChange(Sender: TObject);
    procedure AssistMemoKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure AssistMemoClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure ZliczajClick(Sender: TObject);
    procedure BMultifileExportClick(Sender: TObject);
    procedure DatabaseLogin(Database: TDatabase; LoginParams: TStrings);
    procedure Oprogramie1Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure ExpandQueryClick(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure MemoryStatus1Click(Sender: TObject);
    procedure DisksStatus1Click(Sender: TObject);
    procedure PackFilesinonefileonearchivemode1Click(Sender: TObject);
    procedure Converter1Click(Sender: TObject);
  private
    ExitChange : Boolean;
    Procedure SetStatusBar(S : String);
    Function TryConnect : Boolean;
    Procedure RefreshScriptStatusBar;
  public
    Function  SingleValue(S : String) : String;
  end;

var
  FSQLEverywhere: TFSQLEverywhere;

implementation

uses UFEksport, UFSuperUnion, UFIntro, UFInfo, UFKonwerter, UFCreateSQL,
  UFCreatingUniqueIndexes, UFMemoryStatus, UFGetDisksStatuses,
  UFPackManyFiles;

{$R *.DFM}

Procedure ExecSQL;
Begin

End;

Procedure TFSQLEverywhere.SetStatusBar(S : String);
Begin
 StatusBar.Panels[2].Text := S;       
End;


procedure TFSQLEverywhere.FormCreate(Sender: TObject);
{Var t : Integer;}
begin
 {Combo.Items.Clear;
 For t:= 0 To Session.DatabaseCount -1 Do
  Combo.Items.Add(Session.Databases[t].DatabaseName)}
end;

Function TFSQLEverywhere.ZachowajPlik :Boolean;
Var S : String;
    I : Integer;
begin
 If Not EScript.Modified Then Begin
  Result := True;
  Exit;
 End;
 S := 'Do you wish save file '+OpenDialog1.FileName+' ?' + #0;
 If BSave.Enabled Then Begin
  I := MessageBox(0, @S[1],'',MB_YESNOCANCEL);
  If  I = ID_YES Then EScript.Lines.SaveToFile(OpenDialog1.FileName);
  If I = ID_CANCEL Then Result := False Else Result := True;
 End;
end;

procedure TFSQLEverywhere.FormClose(Sender: TObject; var Action: TCloseAction);
Begin
 If Not ZachowajPlik Then Abort;
End;

procedure TFSQLEverywhere.BWykonajClick(Sender: TObject);

function MakeItAString(I: Extended): string;
var
  S: Shortstring;
begin
  I := I * 100 * 60 * 24;
  Str(I:5:5, S);
  Result:=S;
end;

Var Str : String;
    StartTime, EndTime : TDateTime;


begin
 If  (ActiveControl <> SQL1) And  (ActiveControl<>SQL2) And (ActiveControl<> SQL3) And (ActiveControl<> SQL4)And (ActiveControl<> SQL5) And (ActiveControl<> SQL6) Then Exit;
 If Not TryConnect Then Exit;
 MainQuery.SQL.Clear;
 If ActiveControl = SQL1 Then Str := SQL1.Text;
 If ActiveControl = SQL2 Then Str := SQL2.Text;
 If ActiveControl = SQL3 Then Str := SQL3.Text;
 If ActiveControl = SQL4 Then Str := SQL4.Text;
 If ActiveControl = SQL5 Then Str := SQL5.Text;
 If ActiveControl = SQL6 Then Str := SQL6.Text;

 MainQuery.SQL.Add(Str);
 Light.Brush.Color := clRed;
 Light.Refresh;
 try
  H.Lines.Add(Str);

  StartTime := Now;
  MainQuery.Open;
  EndTime := Now;


  StatusBar.Panels[1].Text := MakeItAString(EndTime - StartTime);
 except
  on E:exception Do Begin
   If E.Message <> 'Error creating cursor handle' Then Begin
    ShowMessage(E.Message);
    H.Lines.Add(E.Message);
   End Else Begin
    ShowMessage('OK !');
   End;
  End Else Begin ShowMessage('Error different that exception'); Raise; End;
 end;
 Light.Brush.Color := clGreen;

end;

procedure TFSQLEverywhere.BRefreshBDEAliasesClick(Sender: TObject);
begin
 BDEItems.Active := False;
 BDEItems.Active := True;

 DatabaseName.Items.Clear;
 BDEItems.First;
 While Not BDEItems.EOF Do Begin
  DatabaseName.Items.Add(BDEItems.Fields[0].AsString);
  BDEItems.Next;
 End;

end;

procedure TFSQLEverywhere.RefreshTablesClick(Sender: TObject);
Var mr : TModalResult;
begin
 If Not TryConnect Then Exit;

 DBItems.Active := False;
 DBItems.Active := True;

 mr := KindOfHint.ItemIndex;

 //HINTS.Visible := True;
 Refresh;
 Case mr of
  0:Begin
       //Hints.Lines.Clear;
       //Session.GetTableNames('X','',False,True,Hints.Lines); - wywala program przy zamykaniu !
       DBItems.DisableControls;
       Hints.Lines.Clear;
       DBItems.First;
       While Not DBItems.EOF Do Begin
         Hints.Lines.Add(UpperCase(DBItems.FieldByName('NAME').AsString));
         DBItems.Next;
       End;
       DBItems.EnableControls;
      End;
  1:Begin
       DBItems.DisableControls;
       TableItems.DisableControls;
       Hints.Lines.Clear;
       DBItems.First;
       While Not DBItems.EOF Do Begin
         Hints.Lines.Add(UpperCase(DBItems.FieldByName('NAME').AsString));
         Try
           TableItems.TableName := DBItems.FieldByName('NAME').AsString;
           TableItems.Close;
           TableItems.Open;
           TableItems.First;
            While Not TableItems.EOF Do Begin
              Hints.Lines.Add(UpperCase(DBItems.FieldByName('NAME').AsString+'.'+TableItems.Fields[1].AsString));
              TableItems.Next;
            End;
         Except
          // niektore tebele systemowe nie daja sie czytac (np. w accesie)
         End;
         DBItems.Next;
       End;
       DBItems.EnableControls;
       TableItems.EnableControls;
      End;
  2:Begin Hints.Lines.Clear; End;
 End;
 //HINTS.Visible := False;
end;

procedure TFSQLEverywhere.FormShow(Sender: TObject);
Var S : String;
    Alias: ShortString;
    Command : ShortString;
    L,T : Integer;
    ARGS : String;
begin
 InTransactionClick(nil);
 ExitChange := False;
 BRefreshBDEAliasesClick(nil);
 Try FIntro.Free; Except End;
 BNewClick(nil);

 If UpperCase(Application.Title) = 'SQLEVERYWHERE' Then Begin

 For T := 1 To ParamCount Do Begin
  S := ParamStr(T);
  Command := UpperCase(ExtractWord(1,S,['=']));

  If Command = 'ALIAS' Then Begin
   Alias := ExtractWord(2,S,['=']);
   For L := 0 To DatabaseName.Items.Count - 1 Do Begin
    If DatabaseName.Items.Strings[L] = Alias Then Break;
   End;
   DatabaseName.ItemIndex := L;
   BConnectClick(nil);
  End Else
  If Command = 'USERNAME' Then Begin
   EUserName.Text := ExtractWord(2,S,['=']);
  End Else
  If Command = 'PASSWORD' Then Begin
   EPassword.Text := ExtractWord(2,S,['=']);
  End Else
  If Command = 'EXPORT' Then Begin
   ARGS      := ExtractWord(2,S,['=']);
   SQL1.Text := ExtractWord(1,ARGS,[';']);
   ActiveControl := SQL1;
   BWykonajClick(nil);
   UFEksport.Show(MainQuery,Grid,ExtractWord(2,ARGS,[';']));
   Application.Terminate;
  End Else
  SError('Unrecognized command:'+Command);
 End;
 End;
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

procedure TFSQLEverywhere.PClick(Sender: TObject);
begin
// If PDKomendySQL.Exec Then Begin
//  SQL1.Text := PDKomendySQL.Result_;
//  ActiveControl := SQL1;
// End;
end;

procedure TFSQLEverywhere.BitBtn4Click(Sender: TObject);
begin
// If PDKomendySQL.Exec Then Begin
//  SQL2.Text := PDKomendySQL.Result_;
//  ActiveControl := SQL2;
// End;

end;

procedure TFSQLEverywhere.BitBtn5Click(Sender: TObject);
begin
// If PDKomendySQL.Exec Then Begin
//  SQL3.Text := PDKomendySQL.Result_;
//  ActiveControl := SQL3;
// End;
end;

procedure TFSQLEverywhere.BitBtn6Click(Sender: TObject);
begin
// If PDKomendySQL.Exec Then Begin
//  SQL4.Text := PDKomendySQL.Result_;
//  ActiveControl := SQL4;
// End;

end;

procedure TFSQLEverywhere.BitBtn7Click(Sender: TObject);
begin
// If PDKomendySQL.Exec Then Begin
//  SQL5.Text := PDKomendySQL.Result_;
//  ActiveControl := SQL5;
// End;
end;

procedure TFSQLEverywhere.BitBtn8Click(Sender: TObject);
begin
// If PDKomendySQL.Exec Then Begin
//  SQL6.Text := PDKomendySQL.Result_;
//  ActiveControl := SQL6;
// End;
end;






Const BoolToStr : Array[False..True] of ShortString = ('No','Yes');

procedure TFSQLEverywhere.InTransactionClick(Sender: TObject);
begin
 //InTransaction.Caption := 'W transakcji:'+BoolToStr[Database.InTransaction];
 If Database.InTransaction Then Begin
  BStartTransaction.Enabled := False;
  BCommit.Enabled := True;
  BRollback.Enabled := True;
  MIStartTransaction.Enabled := False;
  MICommit.Enabled := True;
  MIRollback.Enabled := True;
 End
 Else Begin
  BStartTransaction.Enabled := True;
  BCommit.Enabled := False;
  BRollback.Enabled := False;
  MIStartTransaction.Enabled := True;
  MICommit.Enabled := False;
  MIRollback.Enabled := False;
 End;
end;

procedure TFSQLEverywhere.PanelJedenResize(Sender: TObject);
begin
{ SQL1.Width := PanelJeden.Width - 32;
 SQL2.Width := PanelJeden.Width - 32;
 SQL3.Width := PanelJeden.Width - 32;}
end;



procedure TFSQLEverywhere.SQL1Change(Sender: TObject);
Var P : Integer;
    W : ShortString;
    L : Integer;

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
    W := UPPERCASE(W);
    For L := 0 To HINTS.Lines.Count - 1 Do Begin
     If POS(W,HINTS.Lines.Strings[L]) = 1 Then Begin
      TABELA.Caption := COPY(HINTS.Lines.Strings[L], Length(W)+1,65000);
      Break;
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

procedure TFSQLEverywhere.SQL1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 If Key = 45 Then (Sender as TEdit).Text := (Sender as TEdit).Text + TABELA.Caption;
end;

procedure TFSQLEverywhere.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 If ((Key = 46) Or (Key = 8)) And
 ((ActiveControl = SQL1) Or (ActiveControl = SQL2) Or(ActiveControl = SQL3) Or(ActiveControl = SQL4) Or(ActiveControl = SQL5) Or(ActiveControl = SQL6))
  Then ExitChange := True;
end;

procedure TFSQLEverywhere.BitBtn3Click(Sender: TObject);
begin
 If PAGESQL.ActivePage = T1 Then FullSQL.Lines.Assign(FullSQL1.Lines);
 If PAGESQL.ActivePage = T2 Then FullSQL.Lines.Assign(FullSQL2.Lines);
 If PAGESQL.ActivePage = T3 Then FullSQL.Lines.Assign(FullSQL3.Lines);
 If PAGESQL.ActivePage = T4 Then FullSQL.Lines.Assign(FullSQL4.Lines);
 If PAGESQL.ActivePage = T5 Then FullSQL.Lines.Assign(FullSQL5.Lines);
 If PAGESQL.ActivePage = T6 Then FullSQL.Lines.Assign(FullSQL6.Lines);

 If Not TryConnect Then Exit;
 QueryFull.SQL.Assign(FullSQL.Lines);
 try
  H.Lines.AddStrings(FullSQL.Lines);
  QueryFull.Open;
 except
  on E:exception Do Begin
   If E.Message <> 'Error creating cursor handle' Then Begin
    ShowMessage(E.Message);
    H.Lines.Add(E.Message);
   End Else Begin
    ShowMessage('OK !');
   End;
  End;
 end;

end;

procedure TFSQLEverywhere.RefreshItemsClick(Sender: TObject);
begin
 If Not TryConnect Then Exit;

 TableItems.TableName := DBItems.Fields[0].AsString;
 TableItems.Close;
 TableItems.Open;
end;

procedure TFSQLEverywhere.BWykonajAktualizacjaClick(Sender: TObject);
begin
 If Not TryConnect Then Exit;
 QueryAktualizacja.SQL.Clear;
 QueryAktualizacja.SQL.Add('SELECT * FROM '+NazwaTabeli.Text);
 If Trim(Where.Text) <> '' Then QueryAktualizacja.SQL.Add(' Where '+WHERE.Text);
 If Trim(ORDER.Text) <> '' Then QueryAktualizacja.SQL.Add(' ORDER BY '+ORDER.Text);
 QueryAktualizacja.Open;
end;

procedure TFSQLEverywhere.NazwaTabeliChange(Sender: TObject);
begin
 //BWykonajAktualizacjaClick(nil);
end;

procedure TFSQLEverywhere.Zapiszwynik1Click(Sender: TObject);
begin
 BExportClick(nil);
end;

procedure TFSQLEverywhere.NazwaTabeliEnter(Sender: TObject);
begin
 If NazwaTabeli.Items.Count = 0 Then Begin
 If Not TryConnect Then Exit;
   //Session.GetTableNames('X','',False,True,NazwaTabeli.Items);

       DBItems.DisableControls;
       NazwaTabeli.Items.Clear;
       DBItems.First;
       While Not DBItems.EOF Do Begin
         NazwaTabeli.Items.Add(UpperCase(DBItems.FieldByName('NAME').AsString));
         DBItems.Next;
       End;
       DBItems.EnableControls;
 End;
end;

{..
  .If  Field Is TStringField   Then Begin FieldType := 'VARCHAR2('+DS+')'; Sep1:='''';         Sep2:='''';                 Status := ''; End Else
  .If  Field Is TMemoField     Then Begin FieldType := 'VARCHAR2(2000)';             Sep1:='''';           Sep2:='''';                   Status := 'Pole typu MEMO'; End Else
  If  Field Is TFloatField    Then Begin FieldType := 'NUMBER('+DS+',2)'; Sep1:='';           Sep2:='';                   Status := 'W¹tpliwa d³ugoœæ pola'; End Else
  .Begin FieldType := 'VARCHAR2('+DS+')'; Sep1:='''';         Sep2:='''';   Status := 'Nieznany typ pola';                End;
..}

procedure TFSQLEverywhere.GridTitleClick(Column: TColumn);
 Function FieldIsText(F : TField) : Boolean;
 Begin
  Result := Not ((F is TIntegerField) Or  (F is TDateTimeField) Or (F is TFloatField));
 End;

Function Aphostrofe(S : String) : String;
Var Temp : String;
    T    : Integer;
Begin
 If Trim(S)='' Then Begin Result := ''; Exit; End;
 Temp := '';
 For T := 1 To Length(S) Do
  If S[t] = '''' Then Temp := Temp + S[t] + S[t]
                 Else Temp := Temp + S[t];

 Result := ''''+Temp+'''';
End;

Var IsText : Boolean;
    Token  : String;
    Tokens : String;
    Counter: Integer;
    TokensSeparator : String[2];

begin
If AfterClickInColumn.ItemIndex in [1,2,3] Then Begin
 Case AfterClickInColumn.ItemIndex Of
  1: TokensSeparator := ',';
  2: TokensSeparator := ',';
  3: TokensSeparator := CR;
 End;

 Case ObtainInExpression.ItemIndex Of
  0: IsText :=  FieldIsText(Column.Field);
  1: IsText :=  True;
  2: IsText :=  False;
 End;

 Tokens := '';
 With MainQuery Do Begin
  DisableControls;
  First;
  Counter := 0;
  While Not EOF Do Begin
    If IsText Then  Token := Aphostrofe(FieldByName(Column.FieldName).AsString)
              Else  Token := FieldByName(Column.FieldName).AsString;
    If Trim(Token) <> '' Then Begin
     If Tokens <> '' Then Tokens := Tokens + TokensSeparator + Token
                     Else Tokens := Token;
    End;
    Next;
    Inc(Counter);
    If Counter = 256 Then
     If Question('Expression has already reached 256 pieces. Do you want to continue ?') = ID_NO Then Last;
  End;
  EnableControls;
 End;

 Case AfterClickInColumn.ItemIndex Of
  1: UUtilityParent.CopyToClipBoard(Column.FieldName+' in ('+tokens+')');
  2: UUtilityParent.CopyToClipBoard(tokens);
  3: UUtilityParent.CopyToClipBoard(tokens);
 End;
 SetStatusBar('Result was set in the clipboard');
End
Else Begin
 If AfterClickInColumn.ItemIndex <>0 Then Info('Option ');
 If Trim(Column.Title.Caption)='' Then Exit;
 UUtilityParent.CopyToClipBoard(Column.Title.Caption);
 SetStatusBar('There is the text in the clipboard : '+Column.Title.Caption);
End;
end;

Function TFSQLEverywhere.TryConnect : Boolean;
// true = poloczany , false=nie polaczany
Begin
 If Not DataBase.Connected Then BConnectClick(nil);
 Result := DataBase.Connected;
End;

procedure TFSQLEverywhere.BNewClick(Sender: TObject);
begin
 If Not ZachowajPlik Then Abort;
 OpenDialog1.FileName := 'c:\noname.sql';
 With OpenDialog1 Do
  Begin
   EScript.Lines.Clear;
   BSave.Enabled := True;
   BExecSQL.Enabled := True;
   BSaveAs.Enabled := True;
   BZamknij.Enabled := True;
   EScript.Enabled := True;
   AssistMemo.Enabled := True;
   MErrorsAndWarnings.Enabled := True;
   try EScript.SetFocus; except end;
   LFileName.Caption := FileName;
  End;
end;

procedure TFSQLEverywhere.BloadClick(Sender: TObject);
begin
 If Not ZachowajPlik Then Abort;
 With OpenDialog1 Do
 If Execute Then
  Begin
   EScript.Lines.LoadFromFile(FileName);
   BSave.Enabled := True;
   BExecSQL.Enabled := True;
   BSaveAs.Enabled := True;
   BZamknij.Enabled := True;
   EScript.Enabled := True;
   AssistMemo.Enabled := True;
   MErrorsAndWarnings.Enabled := True;
   ActiveControl := EScript;
   LFileName.Caption := FileName;
  End;
end;

procedure TFSQLEverywhere.BPaletaClick(Sender: TObject);
begin
// If PD.Exec Then Begin
//  OpenDialog1.FileName := PD.Result_;
//  EScript.Lines.LoadFromFile(PD.Result_);
//  BSave.Enabled := True;
//  BExecSQL.Enabled := True;
//  BSaveAs.Enabled := True;
//  BZamknij.Enabled := True;
//  EScript.Enabled := True;
//  AssistMemo.Enabled := True;
//  MErrorsAndWarnings.Enabled := True;
//  ActiveControl := EScript;
//  LFileName.Caption := PD.Result_;
// End;
end;

procedure TFSQLEverywhere.BSaveClick(Sender: TObject);
begin
 EScript.Lines.SaveToFile(OpenDialog1.FileName);
end;

procedure TFSQLEverywhere.BSaveAsClick(Sender: TObject);
begin
 If SD.Execute Then Begin
  EScript.Lines.SaveToFile(SD.FileName);
  OpenDialog1.FileName := SD.FileName;
  With OpenDialog1 Do
  {If Execute Then}
   Begin
    EScript.Lines.LoadFromFile(FileName);
    BSave.Enabled := True;
    BExecSQL.Enabled := True;
    BSaveAs.Enabled := True;
    BZamknij.Enabled := True;
    EScript.Enabled := True;
    AssistMemo.Enabled := True;
    MErrorsAndWarnings.Enabled := True;
    ActiveControl := EScript;
    LFileName.Caption := FileName;
   End;
  End;
end;

procedure TFSQLEverywhere.BExecSQLClick(Sender: TObject);
Var T : Integer;
    Text : String;
    CanRun : Boolean;
    ErrorInRun : Boolean;
 Function RUN : Boolean;
 Begin
  Result := True;
  If Trim(MainQuery.SQL.CommaText)<>'' Then Begin
    try
     FSQLEveryWhere.MainQuery.ExecSQL;
     Result := False;
    except
     on E:exception Do Begin
      MErrorsAndWarnings.Lines.Add('Error: ' + MainQuery.SQL.CommaText + #13 + #10 + E.Message);
     End Else MErrorsAndWarnings.Lines.Add('Error: ' + MainQuery.SQL.CommaText + #13 + #10 + 'Error different that exception');
    end;
    MainQuery.SQL.Clear;
   End;
 End;
begin
 If Not TryConnect Then Exit;
 MErrorsAndWarnings.Lines.Clear;

 MainQuery.SQL.Clear;
 For t:=0 To EScript.Lines.Count-1 Do Begin
  Text := EScript.Lines.Strings[t];
  If (UpperCase(Copy(Text,1,3)) <> 'REM') and (UpperCase(Copy(Text,1,6)) <> 'PROMPT') And (UpperCase(Copy(Text,1,1)) <> ';') And (UpperCase(Copy(Text,1,1)) <> '//') And (UpperCase(Copy(Text,1,1)) <> '--') Then Begin
   CanRun := False;
   If Copy(Text,Length(Text),1) = ';' Then Begin
    Text := Copy(Text,1,Length(Text)-1);
    CanRun := True;
   End;
   MainQuery.SQL.Add(Text);
   If CanRUN Then ErrorInRun := RUN;
   If (ErrorInRun) And (ChStopOnError.Checked) Then Break;
  End;
 End;
 If Not ((ErrorInRun) And (ChStopOnError.Checked)) Then RUN;
 If (ErrorInRun) And (ChStopOnError.Checked) Then
  SError('Executing of the script has benn stopped due error')
 Else Info('Executing of the script is over');
end;

procedure TFSQLEverywhere.BFontChangeClick(Sender: TObject);
begin
 FD.Font := EScript.Font;
 If FD.Execute Then EScript.Font := FD.Font;
end;

procedure TFSQLEverywhere.BNotePadClick(Sender: TObject);
begin
 If ExtractFileName(OpenDialog1.FileName) <> '' Then Begin
  BSaveClick(nil);
  ExecuteFile('NotePad.exe',OpenDialog1.FileName,'',SW_SHOW);
  BLoadClick(nil);
 End;
end;

procedure TFSQLEverywhere.BZamknijClick(Sender: TObject);
begin
 If Not ZachowajPlik Then Abort;
 EScript.Clear;
 BSave.Enabled := False;
 BExecSQL.Enabled := False;
 BSaveAs.Enabled := False;
 BZamknij.Enabled := False;
 EScript.Enabled := False;
 AssistMemo.Enabled := False;
 MErrorsAndWarnings.Enabled := False;
end;

procedure TFSQLEverywhere.BStartTransactionClick(Sender: TObject);
begin
 If Not TryConnect Then Exit;

 Database.StartTransaction;
 InTransactionClick(nil);
end;

procedure TFSQLEverywhere.BCommitClick(Sender: TObject);
begin
 Database.Commit;
 InTransactionClick(nil);
end;

procedure TFSQLEverywhere.BRollbackClick(Sender: TObject);
begin
 Database.Rollback;
 InTransactionClick(nil);
end;

procedure TFSQLEverywhere.Zakocz1Click(Sender: TObject);
begin
 Close;
end;

procedure TFSQLEverywhere.BConnectClick(Sender: TObject);
begin
 If Trim(DatabaseName.Items.Strings[DatabaseName.ItemIndex]) = '' Then Begin
  Info('Enter the database name');
  Exit;
 End;
 DataBase.Close;
 DataBase.AliasName := DatabaseName.Items.Strings[DatabaseName.ItemIndex];
 DataBase.Open;
 RefreshTablesClick(nil);
end;

procedure TFSQLEverywhere.MIStartTransactionClick(Sender: TObject);
begin
 BStartTransactionClick(nil);
end;

procedure TFSQLEverywhere.MICommitClick(Sender: TObject);
begin
 BCommitClick(nil);
end;

procedure TFSQLEverywhere.MIRollbackClick(Sender: TObject);
begin
 BRollbackClick(nil);
end;

procedure TFSQLEverywhere.BFontClick(Sender: TObject);
begin
 FD.Font := Grid.Font;
 If FD.Execute Then Grid.Font := FD.Font;
end;

procedure TFSQLEverywhere.BSQLClick(Sender: TObject);
Var TABLE, Res : String;
    t : Integer;
begin
 If Not TryConnect Then Exit;
 TABLE := InputBox('Table name','','');
 MainQuery.SQL.Clear;
 MainQuery.SQL.Add('Select * from '+TABLE);
 MainQuery.Open;
 Res := '';
 For t:=0 To MainQuery.FieldCount-1 Do Begin
  If Res <>'' Then Res := Res + ', ';
  Res := Res + MainQuery.Fields[t].FieldName;
 End;
 SQL1.Text := 'SELECT '+RES+' FROM '+TABLE;
end;

procedure TFSQLEverywhere.BExportClick(Sender: TObject);
begin
 If Not MainQuery.Active Then Begin
  ShowMessage('No data to export');
  Exit;
 End;
 UFEksport.Show(MainQuery,Grid,'');
end;

procedure TFSQLEverywhere.BSuperUnionClick(Sender: TObject);
begin
 If Not TryConnect Then Exit;
 UFSuperUnion.ShowModal('X', Hints.Lines);
end;

procedure TFSQLEverywhere.BToolClick(Sender: TObject);
begin
 If BTool.Down Then UFMemoToolbar.ShowTool(EScript, AssistMemo, BTool)
               Else UFMemoToolbar.HideTool;
end;

Procedure TFSQLEverywhere.RefreshScriptStatusBar;
Var Wiersz, Kolumna : Integer;
begin
 ScriptStatusBar.Panels[2].Text := IntToStr(EScript.Lines.Count);
 with EScript do
 begin
  Wiersz := Perform(EM_LINEFROMCHAR, SelStart, 0);
  Kolumna := SelStart - Perform(EM_LINEINDEX, Wiersz, 0);

  ScriptStatusBar.Panels[0].Text := IntToStr(wiersz+1);
  ScriptStatusBar.Panels[1].Text := IntToStr(kolumna+1);
 end;
 //Info('OnChange');
end;


procedure TFSQLEverywhere.AssistMemoChange(Sender: TObject);
begin
RefreshScriptStatusBar;
end;

procedure TFSQLEverywhere.AssistMemoKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 RefreshScriptStatusBar;
end;

procedure TFSQLEverywhere.AssistMemoClick(Sender: TObject);
begin
 RefreshScriptStatusBar;
end;

procedure TFSQLEverywhere.SpeedButton1Click(Sender: TObject);
begin
 If Not TryConnect Then Exit;
 With DecisionQuery Do Begin
  DecisionPivot.Visible := False;
  Close;
  SQL.Clear;
  SQL.Assign(DecisionSQL.Lines);
  DecisionCube.ShowCubeDialog;
  Open;
  DecisionPivot.Visible := True;
 End;
end;





procedure TFSQLEverywhere.PageControl1Change(Sender: TObject);
begin
 If BTool.Down Then Begin
  BTool.Down := False;
  BToolClick(nil);
 End;
end;

procedure TFSQLEverywhere.SpeedButton2Click(Sender: TObject);
begin
 If Not TryConnect Then Exit;
 UFCountRecords.ShowModal('X', Hints.Lines);
end;

procedure TFSQLEverywhere.ZliczajClick(Sender: TObject);
Var I : Integer;
    S : String;
begin
Try
 With MainQuery Do Begin
  S := Bookmark;
  DisableControls;
  First;
  I := 0;
  While Not EOF Do Begin
   I := I + 1;
   Next;
  End;
  BookMark := S;
  EnableControls;
 End;
 StatusBar.Panels[0].Text := IntToStr(I);
Except
 StatusBar.Panels[0].Text := '';
End;
end;


procedure TFSQLEverywhere.BMultifileExportClick(Sender: TObject);
begin
 If Not TryConnect Then Exit;
 UFMultifileEksport.ShowModal;
end;

procedure TFSQLEverywhere.DatabaseLogin(Database: TDatabase; LoginParams: TStrings);
Var UserName, Password : ShortString;
begin
 UserName := EUserName.Text;
 Password := EPassword.Text;
 LoginParams.Values['USER NAME'] := UserName;
 LoginParams.Values['PASSWORD']  := Password;
end;
 
procedure TFSQLEverywhere.Oprogramie1Click(Sender: TObject);
begin
 If UpperCase(Application.Title) = 'SQLEVERYWHERE' Then FInfo.ShowModal;
end;

Function  TFSQLEverywhere.SingleValue(S : String) : String;
Begin
 MainQuery.SQL.Clear;
 MainQuery.SQL.Add(S);
 MainQuery.Open;
 Result := MainQuery.Fields[0].AsString;
End;

procedure TFSQLEverywhere.BitBtn1Click(Sender: TObject);
begin
 DirectCoefficient.Text :=
 SingleValue(
' SELECT'+
'(SUM(DECODE(NAME,''consistent gets'',VALUE,0))+SUM(DECODE(NAME,''db block gets'',VALUE,0))-SUM(DECODE(NAME,''physical reads'',VALUE,0)))/'+
'(SUM(DECODE(NAME,''consistent gets'',VALUE,0))+(SUM(DECODE(NAME,''db block gets'',VALUE,0)))*100) "Hit Ratio"'+
'FROM V$SYSSTAT');

 CacheDirectCoefficient.Text  := SingleValue('SELECT SUM(PINS) / (SUM( PINS) + SUM(RELOADS)*100) FROM V$LIBRARYCACHE');
 CacheDictionaryDirectCoefficient.Text := SingleValue('SELECT (1 - (SUM(GETMISSES)/SUM(COUNT)))*100 FROM V$ROWCACHE');

end;

procedure TFSQLEverywhere.ExpandQueryClick(Sender: TObject);
begin
 FSQLEverywhereModuleExpandQuery := TFSQLEverywhereModuleExpandQuery.Create(Application);
 FSQLEverywhereModuleExpandQuery.Query := MainQuery; 
 FSQLEverywhereModuleExpandQuery.ShowModal;
 FSQLEverywhereModuleExpandQuery.Free;
end;

procedure TFSQLEverywhere.SpeedButton4Click(Sender: TObject);
begin
 FCreateSimpleData.ShowModal;
end;

procedure TFSQLEverywhere.SpeedButton5Click(Sender: TObject);
begin
 FCreatingUniqueIndexes.ShowModal;
end;

procedure TFSQLEverywhere.MemoryStatus1Click(Sender: TObject);
begin
 FMemoryStatus := TFMemoryStatus.Create(Application);
 FMemoryStatus.ShowModal;
 FMemoryStatus.Free;
end;

procedure TFSQLEverywhere.DisksStatus1Click(Sender: TObject);
begin
 FGetDisksStatuses := TFGetDisksStatuses.Create(Application);
 FGetDisksStatuses.ShowModal;
 FGetDisksStatuses.Free;
end;

procedure TFSQLEverywhere.PackFilesinonefileonearchivemode1Click(
  Sender: TObject);
begin
 FPackManyFiles := TFPackManyFiles.Create(Application);
 FPackManyFiles.ShowModal;
 FPackManyFiles.Free;
end;

procedure TFSQLEverywhere.Converter1Click(Sender: TObject);
begin
 FKonwerter.ShowModal;
end;

end.
