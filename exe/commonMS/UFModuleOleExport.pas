unit UFModuleOleExport;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UFormConfig, StdCtrls, Buttons, ExtCtrls, ComObj, dbTables, Grids,
  DBGrids, RXDBCtrl, StrHlder, UUtilityParent, StrUtils, rxDualList, Menus, db, ADODB;

Type  TKindOfExport = Integer;
Const NotePadExport = 0;
      ExcelExport   = 1;
      WordExport    = 2;
      wwwExport     = 3;

type
  TFModuleOleExport = class(TFormConfig)
    BottomPanel: TPanel;
    BitBtnClose: TBitBtn;
    BEksportWord: TBitBtn;
    BEksportExcel: TBitBtn;
    BEksportNotatnik: TBitBtn;
    FNAME: TRadioGroup;
    Holder: TStrHolder;
    STATUSPANEL: TPanel;
    Panel1: TPanel;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    TempCOLUMNS: TStrHolder;
    BitBtn1: TBitBtn;
    Panel2: TPanel;
    IncludeBtn: TSpeedButton;
    IncAllBtn: TSpeedButton;
    ExcludeBtn: TSpeedButton;
    ExAllBtn: TSpeedButton;
    INCLUDE: TListBox;
    NONINCLUDE: TListBox;
    procedure BEksportWordClick(Sender: TObject);
    procedure BEksportExcelClick(Sender: TObject);
    procedure BEksportNotatnikClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure IncludeBtnClick(Sender: TObject);
    procedure IncAllBtnClick(Sender: TObject);
    procedure ExcludeBtnClick(Sender: TObject);
    procedure ExAllBtnClick(Sender: TObject);
    procedure INCLUDEDblClick(Sender: TObject);
    procedure NONINCLUDEDblClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    OrderOfColumns : String;
    DefinitionOfColumns : TStrings;
    Query : TADOQuery;
    Grid  : TRxDbGrid;
    FileName : TFileName;
    Procedure afterCreate(KindOfExport : TKindOfExport);
    Function  getFileName(KindOfExport : TKindOfExport) : Boolean;
    Procedure updStatus(S : String);
    Procedure refreshFields;
    Function  replaceColumnCaptionToNumber(S : ShortString) : ShortString;
    Procedure getColumnsToExport(S : TStrings);
    Procedure getCaptionsToExport(S : TStrings);
    Procedure privateGetToExport(i : Integer; S : TStrings);
    procedure moveSelected(List: TCustomListBox; Items: TStrings);
    procedure setItem(List: TListBox; Index: Integer);
    function  getFirstSelection(List: TCustomListBox): Integer;
    procedure setButtons;
    procedure applyChanges;
  public
  end;

var
  FModuleOleExport: TFModuleOleExport;

Procedure ShowModal(Var _OrderOfColumns : String; _DefinitionOfColumns : TStrings; _Query : TADOQuery; _Grid : TRxDbGrid; AutoExport : Boolean);

implementation

uses UFProgramSettings;

{$R *.DFM}

Procedure ShowModal(Var _OrderOfColumns : String; _DefinitionOfColumns : TStrings; _Query : TADOQuery; _Grid : TRxDbGrid; AutoExport : Boolean);
Var t : Integer;

Function GetIndex(S : String ) : Integer;
Var L : Integer;
Begin
 Result := -1;
 For L:=0 To _Query.FieldCount - 1 Do Begin
  If _Query.Fields[L].FieldName = S Then Begin
   Result := L; Break;
  End;
 End;
End;

Function isInGrid(FieldName : ShortString) : Boolean;
Var L : Integer;
Begin
 For L:=0 To _Grid.Columns.Count - 1 Do Begin
  If _Grid.Columns[L].FieldName = FieldName Then Begin Result := True; Exit; End;
 End;
 Result := False;
End;

Var tmpInclude, tmpNotInclude : String;

Begin
 FModuleOleExport := TFModuleOleExport.Create(Application);
 With FModuleOleExport Do Begin;
  OrderOfColumns      := _OrderOfColumns;
  DefinitionOfColumns := _DefinitionOfColumns;
  Query               := _Query;
  Grid                := _Grid;

  // Ustawienie parametrów pocz¹tkowych, je¿eli ich nie ma
  If  OrderOfColumns = '' Then Begin

       tmpinclude := '';
    tmpnotInclude := '';
    For t := 0 To _Grid.Columns.Count - 1 Do Begin
      tmpinclude := Merge(tmpinclude,IntToStr(GetIndex(_Grid.Columns[t].FieldName)),',');
    End;

    For T := 0 To Query.FieldCount -1 Do Begin
      If not isInGrid(Query.Fields[t].FieldName) Then tmpnotInclude := Merge(tmpnotInclude,IntToStr(t),',');
    End;
    OrderOfColumns := tmpinclude + '|' + tmpnotInclude;
  End;
  RefreshFields;

  If AutoExport Then Begin
    Show;
    BitBtn1Click(nil);
    Close;
  End Else Begin
    ShowModal;
    _OrderOfColumns := OrderOfColumns;
  End;
  Free;
 End;
End;

procedure TFModuleOleExport.BEksportWordClick(Sender: TObject);
Var L : Integer;
    LiczbaKolumn, LiczbaWierszy : Integer;
    X            : Variant;
begin
  inherited;
 ApplyChanges;
 UpdStatus('Otwieranie programu Word');
 X := CreateOleObject('Word.Document.8');
 UpdStatus('Tworzenie dokumentu');

 If GetFileName(WordExport) Then Begin
  Query.DisableControls;

  GetCaptionsToExport(TempCOLUMNS.Strings);
  LiczbaKolumn := TempCOLUMNS.Strings.Count;
  //X.Application.Visible := True;
  X.Application.ActiveDocument.Tables.Add(X.Application.Selection.Range, 1, LiczbaKolumn);

  LiczbaWierszy := 0;
  Query.First;
  While Not Query.EOF Do Begin
   Query.Next;
   LiczbaWierszy := LiczbaWierszy + 1;
  End;
  X.Application.Selection.InsertRows(LiczbaWierszy);

  For L := 0 To LiczbaKolumn-1 Do Begin
   X.Application.Selection.Tables.Item(1).Cell(1,L+1).Select;
   X.Application.Selection.TypeText(TempCOLUMNS.Strings[L]);
  End;

  GetColumnsToExport(TempCOLUMNS.Strings);
  LiczbaWierszy := 1;
  Query.First;
  While Not Query.EOF Do Begin
  LiczbaWierszy := LiczbaWierszy +1;

   X.Application.Selection.Tables.Item(1).Cell(LiczbaWierszy,1).Select;
   For L := 0 To LiczbaKolumn-1 Do Begin
    X.Application.Selection.TypeText(Query.FieldByName(TempCOLUMNS.Strings[L]).AsString);
    X.Application.Selection.MoveRight;
   End;
   Query.Next;
  End;

  X.Application.ActiveDocument.SaveAs(FileName);
  X.Application.Quit;

  Query.EnableControls;
  AfterCreate(WordExport);
 End;
end;

procedure TFModuleOleExport.BEksportExcelClick(Sender: TObject);
Var L : Integer;
    LiczbaKolumn, LiczbaWierszy : Integer;
    X            : Variant;
begin
  inherited;
 ApplyChanges;
 UpdStatus('Otwieranie programu Excel');
 X := CreateOleObject('Excel.sheet');
 UpdStatus('Tworzenie dokumentu');

 If GetFileName(ExcelExport) Then Begin
  Query.DisableControls;

  GetCaptionsToExport(TempCOLUMNS.Strings);
  LiczbaKolumn := TempCOLUMNS.Strings.Count;
  //X.Application.Visible := True;

  For L := 0 To LiczbaKolumn-1 Do Begin
   X.Application.Cells[1,L+1].Value := TempCOLUMNS.Strings[L];
  End;

  GetColumnsToExport(TempCOLUMNS.Strings);
  LiczbaWierszy := 1;
  Query.First;
  While Not Query.EOF Do Begin
  LiczbaWierszy := LiczbaWierszy +1;

   For L := 0 To LiczbaKolumn-1 Do Begin
    X.Application.Cells[LiczbaWierszy,L+1].Value := Query.FieldByName(TempCOLUMNS.Strings[L]).AsString;
   End;
   Query.Next;
  End;

  X.SaveAs(FileName);
  X.Application.Quit;
  Query.EnableControls;
  AfterCreate(ExcelExport);
 End;
end;

procedure TFModuleOleExport.BEksportNotatnikClick(Sender: TObject);
Var F : TextFile;
    L : Integer;
    LiczbaKolumn : Integer;
begin
 ApplyChanges;
 If GetFileName(NotePadExport) Then Begin
  Query.DisableControls;
  AssignFile(F, FileName);
  ReWrite(F);
  UpdStatus('Tworzenie dokumentu');

  GetCaptionsToExport(TempCOLUMNS.Strings);
  LiczbaKolumn := TempCOLUMNS.Strings.Count;
  For L := 0 To LiczbaKolumn-1 Do Write(F, TempCOLUMNS.Strings[L] + #9);
  WriteLn(F);

  GetColumnsToExport(TempCOLUMNS.Strings);
  Query.First;
  While Not Query.EOF Do Begin
   For L := 0 To LiczbaKolumn-1 Do Write(F, Query.FieldByName(TempCOLUMNS.Strings[L]).AsString + #9);
   WriteLn(F);
   Query.Next;
  End;
  Query.EnableControls;
  CloseFile(F);
  AfterCreate(NotePadExport);
 End;
end;

Procedure TFModuleOleExport.AfterCreate(KindOfExport : TKindOfExport);
Begin
   Case KindOfExport Of
     NotePadExport:Begin
                    UpdStatus('Uruchamianie programu Notatnik');
                    ExecuteFile('Notepad.exe','"'+FileName+'"','',SW_SHOWMAXIMIZED);
                   End;
     ExcelExport  :Begin
                    UpdStatus('Uruchamianie programu Excel');
                    ExecuteFile('Excel.exe','"'+FileName+'"','',SW_SHOWMAXIMIZED);
                   End;
     WordExport   :Begin
                    UpdStatus('Uruchamianie programu Winword');
                    ExecuteFile('Winword.exe','"'+FileName+'"','',SW_SHOWMAXIMIZED);
                   End;
     wwwExport   :Begin
                    UpdStatus('Uruchamianie przegl¹darki www');
                    ExecuteFile(FileName,'','',SW_SHOWMAXIMIZED);
                   End;


   End;
  UpdStatus('');
End;

Function TFModuleOleExport.GetFileName(KindOfExport : TKindOfExport) : Boolean;
Var SDialog : TSaveDialog;
Begin
 SDialog  := TSaveDialog.Create(Application);
 SDialog.Options := [ofOverwritePrompt,ofHideReadOnly];
 Case KindOfExport Of
   NotePadExport:Begin
                  SDialog.DefaultExt := 'txt';
                  SDialog.Filter  := Holder.Strings[0];
                 End;
   ExcelExport  :Begin
                  SDialog.DefaultExt := 'xls';
                  SDialog.Filter  := Holder.Strings[1];
                 End;
   WordExport   :Begin
                  SDialog.DefaultExt := 'doc';
                  SDialog.Filter  := Holder.Strings[2];
                 End;
   wwwExport   :Begin
                  SDialog.DefaultExt := 'htm';
                  SDialog.Filter  := Holder.Strings[3];
                 End;
   End;
  If FNAME.ItemIndex = 0 Then Begin
   SDialog.FileName :=  uutilityparent.ApplicationDocumentsPath + 'tmp.'+SDialog.DefaultExt;
   Result := True;
  End Else  Result :=  SDialog.Execute;

  If Result Then FileName := SDialog.FileName;
  SDialog.Free;
End;

Procedure TFModuleOleExport.UpdStatus(S : String);
Begin
 STATUSPANEL.Caption := S;
 STATUSPANEL.Refresh;
End;

Procedure TFModuleOleExport.RefreshFields;
Var IncludeColumns, NonIncludeColumns : String;
    t                                 : Integer;
Begin
 Include.Items.Clear;
 NonInclude.Items.Clear;
 IncludeColumns    := Trim(ExtractWord(1,OrderOfColumns,['|']));
 NonIncludeColumns :=      ExtractWord(2,OrderOfColumns,['|']);

 For t := 1 To WordCount(IncludeColumns,[',']) Do Begin
  try
  Include.Items.Add( ExtractWord(1
                                ,DefinitionOfColumns.Strings[StrToInt(ExtractWord(t,IncludeColumns,[','])
                                                                     )
                                                            ]
                                ,['|'])
                   );
  except
    //flex columns are ignored in DefinitionOfColumns, it can occur index out of range error
  end;
 End;

 For t := 1 To WordCount(NonIncludeColumns,[',']) Do Begin
  try
  NonInclude.Items.Add( ExtractWord(1,DefinitionOfColumns.Strings[StrToInt(ExtractWord(t,NonIncludeColumns,[',']))],['|']) );
  except
    //flex columns are ignored in DefinitionOfColumns, it can occur index out of range error
  end;
 End;

 IncludeBtn.Enabled := Include.Items.Count > 0;
 IncAllBtn.Enabled  :=  Include.Items.Count > 0;
 ExcludeBtn.Enabled := nonInclude.Items.Count > 0;
 ExAllBtn.Enabled   := nonInclude.Items.Count > 0;
End;


Function TFModuleOleExport.ReplaceColumnCaptionToNumber(S : ShortString) : ShortString;
Var t : Integer;
Begin
 For t := 0 To DefinitionOfColumns.Count -1 Do
   If ExtractWord(1,DefinitionOfColumns.Strings[t],['|']) = S Then Begin
    Result := IntToStr(t);
    Exit;
   End;
 SError('ReplaceColumnCaptionToNumber Out of range:'+S);
 Result := '-1';
End;

procedure TFModuleOleExport.ApplyChanges;
Var t : Integer;
    IncludeColumns, NonIncludeColumns : String;
begin
  inherited;
  // nie chce mi siê wnikac, co to robi, ale musi byc
      IncludeColumns := '';
      NonIncludeColumns := '';
      For t:=0 To Include.Count - 1 Do Begin
        If IncludeColumns <> '' Then IncludeColumns := IncludeColumns + ',';
        IncludeColumns := IncludeColumns + ReplaceColumnCaptionToNumber(Include.Items[t]);
      End;
      For t:=0 To NonInclude.Count - 1 Do Begin
        If NonIncludeColumns <> '' Then NonIncludeColumns := NonIncludeColumns + ',';
        NonIncludeColumns := NonIncludeColumns + ReplaceColumnCaptionToNumber(NonInclude.Items[t]);
      End;
        OrderOfColumns := ' '+IncludeColumns + '|' + NonIncludeColumns;
        RefreshFields;
end;


Procedure TFModuleOleExport.PrivateGetToExport(i : Integer; S : TStrings);
Var IncludeColumns : String;
    t                                 : Integer;
Begin
 IncludeColumns    := Trim(ExtractWord(1,OrderOfColumns,['|']));
 S.Clear;
 For t := 1 To WordCount(IncludeColumns,[',']) Do Begin
  S.Add(ExtractWord(i,DefinitionOfColumns.Strings[StrToInt(ExtractWord(t,IncludeColumns,[',']))],['|']));
 End;
End;

Procedure TFModuleOleExport.GetColumnsToExport(S : TStrings);
Begin
 PrivateGetToExport(2,S);
End;

Procedure TFModuleOleExport.GetCaptionsToExport(S : TStrings);
Begin
 PrivateGetToExport(1,S);
End;


procedure TFModuleOleExport.BitBtn1Click(Sender: TObject);
Var F : TextFile;
    L : Integer;
    LiczbaKolumn : Integer;

Var S : String;
begin
  FProgramSettings.generateJsFiles;

 ApplyChanges;
 If GetFileName(wwwExport) Then Begin
  Query.DisableControls;
  AssignFile(F, FileName);
  ReWrite(F);
  UpdStatus('Tworzenie dokumentu');

  Writeln(f, '<HTML>');
  Writeln(f, '<HEAD>');
  Writeln(f, '<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=windows-1250">');
  Writeln(f, '<TITLE>Plansoft.org - eksport danych</TITLE>');
  Writeln(f, '<style type="text/css" media="screen">');
  Writeln(f, '@import "filtergrid.css";');
  Writeln(f, 'h2{ margin-top: 50px; }');
  Writeln(f, '.mytable{');
  Writeln(f, '	width:100%; font-size:12px;');
  Writeln(f, '	border:1px solid #ccc;');
  Writeln(f, '}');
  Writeln(f, 'th{ background-color:#003366; color:#FFF; padding:2px; border:1px solid #ccc; }');
  Writeln(f, 'td{ padding:2px; border-bottom:1px solid #ccc; border-right:1px solid #ccc; }');
  Writeln(f, '</style>');
  Writeln(f, '<script language="javascript" type="text/javascript" src="actb.js"></script>');
  Writeln(f, '<script language="javascript" type="text/javascript" src="tablefilter.js"></script>');
  Writeln(f, '</HEAD>');
  Writeln(f, '<BODY>');

  WriteLn(F, '<TABLE ID="mytable">');

  GetCaptionsToExport(TempCOLUMNS.Strings);
  LiczbaKolumn := TempCOLUMNS.Strings.Count;
  S := '';
  For L := 0 To LiczbaKolumn-1 Do
   {If Query.FieldByName(TempCOLUMNS.Strings[L]).DataType <> ftMemo Then Begin}
    S := Merge(S, '<TD>'+TempCOLUMNS.Strings[L]+'</TD>', '');
   {End;}
  Writeln(F, '<TR ALIGN=center VALIGN=middle>'+S+'</TR>');

  GetColumnsToExport(TempCOLUMNS.Strings);
  Query.First;
  While Not Query.EOF Do Begin
   S := '';
   For L := 0 To LiczbaKolumn-1 Do
    {If Query.FieldByName(TempCOLUMNS.Strings[L]).DataType <> ftMemo Then Begin}
      If Query.FieldByName(TempCOLUMNS.Strings[L]).DataType = ftFloat Then S := Merge(S, '<TD>'+FormatFloat('###,###,###,##0.00',Query.FieldByName(TempCOLUMNS.Strings[L]).AsFloat)+'</TD>', '')
      Else  S := Merge(S, '<TD>'+nvl(Query.FieldByName(TempCOLUMNS.Strings[L]).AsString,'&nbsp')+'</TD>', '');
    {End;}

   //S := Merge(S, '<TD>'+Query.FieldByName(TempCOLUMNS.Strings[L]).AsString+'</TD>', '');


  Writeln(F, '<TR ALIGN=center VALIGN=middle>'+S+'</TR>');
   Query.Next;
  End;

  WriteLn(F, '</TABLE>');

  Writeln(f, '<script language="javascript" type="text/javascript">');
  Writeln(f, '//<![CDATA[');

  Writeln(f, '	var table2_Props = 	{');
  Writeln(f, '		sort_select: true,');
  Writeln(f, '		loader: true,');
  Writeln(f, '		col_0: "select",');
  Writeln(f, '		on_change: true,');
  Writeln(f, '		display_all_text: " [ Wszystkie ] ",');
  Writeln(f, '		rows_counter: true,');
  Writeln(f, '		btn_reset: true,');
  Writeln(f, '		rows_counter_text: "Liczba wierszy: ",');
  Writeln(f, '		alternate_rows: true,');
  Writeln(f, '		btn_reset_text: "Czyœæ filtr",');
  //Writeln(f, '		col_width: ["220px",null,"280px"]');
  Writeln(f, '		};');

  Writeln(f, '	setFilterGrid( "mytable",table2_Props );');
  Writeln(f, '//]]>');
  Writeln(f, '</script>');

  Query.EnableControls;
  Writeln(f, '</BODY></HTML>');
  CloseFile(F);
  AfterCreate(wwwExport);
 End;
end;

procedure TFModuleOleExport.IncludeBtnClick(Sender: TObject);
var
  Index: Integer;
begin
  Index := GetFirstSelection(Include);
  MoveSelected(Include, NonInclude.Items);
  SetItem(Include, Index);
end;

procedure TFModuleOleExport.IncAllBtnClick(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to Include.Items.Count - 1 do
    NonInclude.Items.AddObject(Include.Items[I],
      Include.Items.Objects[I]);
  Include.Items.Clear;
  SetItem(Include, 0);
end;

procedure TFModuleOleExport.ExcludeBtnClick(Sender: TObject);
var
  Index: Integer;
begin
  Index := GetFirstSelection(NonInclude);
  MoveSelected(NonInclude, Include.Items);
  SetItem(nonInclude, Index);
end;

procedure TFModuleOleExport.ExAllBtnClick(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to NonInclude.Items.Count - 1 do
    Include.Items.AddObject(nonInclude.Items[I], NonInclude.Items.Objects[I]);
  nonInclude.Items.Clear;
  SetItem(nonInclude, 0);
end;

procedure TFModuleOleExport.MoveSelected(List: TCustomListBox; Items: TStrings);
var
  I: Integer;
begin
  for I := List.Items.Count - 1 downto 0 do
    if List.Selected[I] then
    begin
      Items.AddObject(List.Items[I], List.Items.Objects[I]);
      List.Items.Delete(I);
    end;
end;

procedure TFModuleOleExport.SetButtons;
var
  SrcEmpty, DstEmpty: Boolean;
begin
  SrcEmpty := Include.Items.Count = 0;
  DstEmpty := nonInclude.Items.Count = 0;
  IncludeBtn.Enabled := not SrcEmpty;
  IncAllBtn.Enabled := not SrcEmpty;
  ExcludeBtn.Enabled := not DstEmpty;
  ExAllBtn.Enabled := not DstEmpty;
end;

function TFModuleOleExport.GetFirstSelection(List: TCustomListBox): Integer;
begin
  for Result := 0 to List.Items.Count - 1 do
    if List.Selected[Result] then Exit;
  Result := LB_ERR;
end;

procedure TFModuleOleExport.SetItem(List: TListBox; Index: Integer);
var
  MaxIndex: Integer;
begin
  with List do
  begin
    SetFocus;
    MaxIndex := List.Items.Count - 1;
    if Index = LB_ERR then Index := 0
    else if Index > MaxIndex then Index := MaxIndex;
    Selected[Index] := True;
  end;
  SetButtons;
end;

procedure TFModuleOleExport.INCLUDEDblClick(Sender: TObject);
begin
  inherited;
  If IncludeBtn.Enabled then IncludeBtnClick(nil);
end;

procedure TFModuleOleExport.NONINCLUDEDblClick(Sender: TObject);
begin
  inherited;
    If ExcludeBtn.Enabled then ExcludeBtnClick(nil);
end;

procedure TFModuleOleExport.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  ApplyChanges;

end;

end.
