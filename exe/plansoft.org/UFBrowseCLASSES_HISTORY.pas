unit UFBrowseCLASSES_HISTORY;

interface

uses                       
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UFBrowseParent, ExtCtrls, StrHlder, Menus, Db, DBTables, RxQuery,
  ComCtrls, Grids, DBGrids, RXDBCtrl, StdCtrls, Buttons, ToolEdit, Mask,
  DBCtrls, AutoCreate, ImgList, ADODB, UFGenericFilter, OleServer, ExcelXP;

type
  TFBrowseCLASSES_HISTORY = class(TFBrowseParent)
    _ID: TDBEdit;
    LabelID: TLabel;
    DAY: TDBDateEdit;
    LabelDAY: TLabel;
    HOUR: TDBEdit;
    LabelHOUR: TLabel;
    CALC_LECTURERS: TDBEdit;
    LabelCALC_LECTURERS: TLabel;
    CALC_GROUPS: TDBEdit;
    LabelCALC_GROUPS: TLabel;
    CALC_ROOMS: TDBEdit;
    LabelCALC_ROOMS: TLabel;
    SUB_ID: TDBEdit;
    LabelSUB_ID: TLabel;
    FOR_ID: TDBEdit;
    LabelFOR_ID: TLabel;
    FILL: TDBEdit;
    LabelFILL: TLabel;
    DESC1: TDBEdit;
    LabelDESC1: TLabel;
    DESC2: TDBEdit;
    LabelDESC2: TLabel;
    GenericFilter: TFGenericFilter;
    PanelDates: TPanel;
    fastQueryString: TMemo;
    PanelHistory: TPanel;
    HistoryMode: TComboBox;
    historyFrom: TDateEdit;
    Label3: TLabel;
    historyTo: TDateEdit;
    historyLabel: TLabel;
    ChSelectedDates: TCheckBox;
    FHOUR: TComboBox;
    FDAY_TO: TDateEdit;
    LDAYTO_Label: TLabel;
    FDAY_FROM: TDateEdit;
    Label2: TLabel;
    BitBtn1: TBitBtn;
    showMore: TCheckBox;
    Own: TCheckBox;
    BUndo: TBitBtn;
    FHelp: TSpeedButton;
    procedure CONPERIODChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FGenericFilter1conlChange(Sender: TObject);
    procedure GenericFilterconsChange(Sender: TObject);
    procedure GenericFiltercongChange(Sender: TObject);
    procedure GenericFilterconfChange(Sender: TObject);
    procedure GenericFilterconResCat0Change(Sender: TObject);
    procedure GenericFilterconPerChange(Sender: TObject);
    procedure GenericFilterconResCat1Change(Sender: TObject);
    procedure GenericFilterconPlaChange(Sender: TObject);
    procedure historyFromChange(Sender: TObject);
    procedure historyToChange(Sender: TObject);
    procedure ConflictWithReservationsChange(Sender: TObject);
    procedure GenericFilterMenuItem5Click(Sender: TObject);
    procedure GenericFilterMenuItem6Click(Sender: TObject);
    procedure GenericFilterbClearLClick(Sender: TObject);
    procedure GenericFilterbClearSClick(Sender: TObject);
    procedure GenericFilterbClearGClick(Sender: TObject);
    procedure GenericFilterbClearFClick(Sender: TObject);
    procedure GenericFilterbClearPeriodClick(Sender: TObject);
    procedure GenericFilterMenuItem7Click(Sender: TObject);
    procedure GenericFilterMenuItem8Click(Sender: TObject);
    procedure GenericFilterMenuItem11Click(Sender: TObject);
    procedure GenericFilterMenuItem12Click(Sender: TObject);
    procedure GenericFilterMenuItem13Click(Sender: TObject);
    procedure GenericFilterMenuItem14Click(Sender: TObject);
    procedure GenericFilterFiltrprosty1Click(Sender: TObject);
    procedure GenericFilterFiltrzaawansowany1Click(Sender: TObject);
    procedure GenericFilterbClearRes0Click(Sender: TObject);
    procedure GenericFilterbClearRes1Click(Sender: TObject);
    procedure GenericFiltermir0eClick(Sender: TObject);
    procedure GenericFiltermir0aClick(Sender: TObject);
    procedure GenericFiltermir1eClick(Sender: TObject);
    procedure GenericFiltermir1aClick(Sender: TObject);
    procedure FHOURChange(Sender: TObject);
    procedure FDAY_FROMChange(Sender: TObject);
    procedure ChSelectedDatesClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure showMoreClick(Sender: TObject);
    procedure OwnClick(Sender: TObject);
    procedure ComboSortOrderChange(Sender: TObject);
    procedure BUndoClick(Sender: TObject);
    procedure FHelpClick(Sender: TObject);
  private
    { Private declarations }
  public
   ClassesTableName : string[30];
   SkipRefresh : boolean;
   HideEdit   : boolean;
   Function  CanEditIntegrity : Boolean;          override;
   Function  CanEditPermission : Boolean;         override;
   Function  CanInsert    : Boolean;              override;
   Procedure CustomConditions;                    override;
   Function  CanDelete    : Boolean;              override;
   Procedure ShowModalAsBrowser(Filter : String); override;
   Procedure GetTableName;                        override;
    Procedure editClick;                     override;

   Procedure deleteClick;                         override;
   Function  execute(aCurrOperation : Integer; aID : ShortString) : TModalResult; override;
   Function  getSearchFilter : string;  override;
   function  getFindCaption : string;   override;

  end;

var
  FBrowseCLASSES_HISTORY: TFBrowseCLASSES_HISTORY;

implementation

uses DM, UUtilities, UUtilityParent, UFMain, UCommon, UFProgramSettings,
  UProgress;

{$R *.DFM}

{ TFBrowseCLASSES }

//------------------------------------------------------------------
Function TFBrowseCLASSES_HISTORY.execute(aCurrOperation : Integer; aID : ShortString): TModalResult;
  var del_id : string;
  //--------------------------
  Procedure DeleteRecord(aID : String);
  Begin
      ID := aID;
      Try BeforeDelete; Except Info(Komunikaty.Strings[26]); End;
      Try
          //DModule.SQL('DELETE FROM '+TableName+' WHERE '+KeyField+'='+ID);
          //based on uutilities.deleteClass
          dmodule.sql('begin api.delete_class (:id ); end;'
                     ,'id='+ID
          );
       Try AfterDelete; Except Info(Komunikaty.Strings[27]); End;
      Except
       on E:exception do Begin
         errorMessage(ADelete, Self, E.Message);
       End Else SError(Komunikaty.Strings[14]);
      End;
  End;
  //--------------------------
Begin
  CurrOperation := aCurrOperation;

  With DModule Do Begin
   If CurrOperation <> AInsert Then begin
         id := Query.FieldByName(KeyField).AsString;
     del_id := Query.FieldByName(KeyField).AsString;
   end;
   If CurrOperation = ADelete  Then  Begin
     Query.Next;  // not for visual effect only, it changes records in loop delete all
     DeleteRecord(del_id);
     Exit;
   End;
  End;

  Query.Close;
  SwitchQueryToDetails;
  Result  := PrepareQueryOnDetailsForm;

  If Result <> mrAbort Then Begin
   SwitchFormToDetails;
  End
  Else Begin
   SwitchQueryToGrid;
   BRefreshClick(nil);
  End;
  flexRefreshFormView;
End;

//------------------------------------------------------------------
Procedure TFBrowseCLASSES_HISTORY.deleteClick;
Var t : Integer;
Begin
  id := Query.FieldByName(KeyField).AsString;
  //
  If Not BDelete.Enabled Then Exit;
  If Not CanDelete Then Begin
    Warning(Komunikaty.Strings[3]);
    Exit;
  End;
  If Question(Komunikaty.Strings[8]) = idYes Then Begin
   If Grid.SelectedRows.Count = 0 Then
     Execute(ADelete,'')
   Else Begin
     For t := 0 To Grid.SelectedRows.Count - 1 Do Begin
      Query.Bookmark := Grid.SelectedRows.Items[t];
      dmodule.sql('begin api.delete_class (:id ); end;'
                  ,'id='+Query.FieldByName(KeyField).AsString
      );
     End;
   End;
   BRefreshClick(nil);
  End;
End;


//------------------------------------------------------------------
Procedure TFBrowseCLASSES_HISTORY.ShowModalAsBrowser(Filter : String);
    Function ColNo(FieldName : ShortString) : Integer;
    Var L : Integer;
    Begin
     For L:=0 To Grid.Columns.Count - 1 Do Begin
      If Grid.Columns[L].FieldName = FieldName Then Begin Result := L; Exit; End;
     End;
     Result := -1;
    End;
begin
  with fprogramSettings do begin
    grid.Columns[ColNo('SUB_NAME')].Title.caption := profileObjectNameC1.Text;
    grid.Columns[ColNo('FRM_NAME')].Title.caption := profileObjectNameC2.Text;
    grid.Columns[ColNo('CALC_LECTURERS')].Title.caption := profileObjectNameL.Text;
    grid.Columns[ColNo('CALC_GROUPS')].Title.caption := profileObjectNameG.Text;

    grid.Columns[ColNo('DESC1')].Title.caption := nvl(fprogramSettings.getClassDescPlural(1),'<brak>');
    grid.Columns[ColNo('DESC2')].Title.caption := nvl(fprogramSettings.getClassDescPlural(2),'<brak>');
    grid.Columns[ColNo('DESC3')].Title.caption := nvl(fprogramSettings.getClassDescPlural(3),'<brak>');
    grid.Columns[ColNo('DESC4')].Title.caption := nvl(fprogramSettings.getClassDescPlural(4),'<brak>');

    GridLayout.Strings.Clear;
    ConditionsWhereClause.Strings.Clear;
    AvailColumnsWhereClause.Strings.Clear;
    CreateGridLayout;

    PanelHistory.Visible := true;
  end;

 Grid.Columns[ ColNo('CALC_LECTURERS') ].visible := false;
 Grid.Columns[ ColNo('CALC_LECTURERS_SHORT') ].visible := true;
 Grid.Columns[ ColNo('LAST_UPDATED_BY') ].visible := true;
 Grid.Columns[ ColNo('OPERATION_FLAG_DSP') ].visible := true;
 Grid.Columns[ ColNo('EFFECTIVE_START_DATE') ].visible := true;
 Grid.Columns[ ColNo('EFFECTIVE_END_DATE') ].visible := true;
 BDelete.Visible :=   classesTableName = 'CLASSES';

 inherited;
end;


function TFBrowseCLASSES_HISTORY.CanEditIntegrity: Boolean;
begin
 Result := False;
end;

function TFBrowseCLASSES_HISTORY.CanEditPermission: Boolean;
begin
 Result := true;
end;

function TFBrowseCLASSES_HISTORY.CanInsert: Boolean;
begin
 Result := False;
end;

function TFBrowseCLASSES_HISTORY.CanDelete: Boolean;
begin
 Result := False;
end;

Procedure TFBrowseCLASSES_HISTORY.CustomConditions;
Var tablePostfix     : string;
    sqll             : string;
    sqlg             : string;
    sqls             : string;
    sqlf             : string;
    sqlp             : string;
    sqlr0            : string;
    sqlr1            : string;
    IsBlankDateFrom : boolean;
    IsBlankDateTo   : boolean;
    DAY_FILTER      : string;

  Function getPeriod ( pdateFrom, pdateTo : String ) : string;
  var c : string;
  begin
    //c := '((CLASSES.EFFECTIVE_START_DATE <= :FROM AND CLASSES.EFFECTIVE_END_DATE BETWEEN :FROM AND :TO) OR (CLASSES.EFFECTIVE_START_DATE BETWEEN :FROM AND :TO AND NVL(CLASSES.EFFECTIVE_END_DATE, DATE''3000-01-01'') >= :TO ))';
    c := '(CLASSES.EFFECTIVE_START_DATE BETWEEN :FROM AND :TO OR CLASSES.EFFECTIVE_END_DATE BETWEEN :FROM AND :TO )';
    c :=  searchAndReplace(c,':FROM',pDateFrom);
    c :=  searchAndReplace(c,':TO',pDateTo);
    result := c;
  end;
Begin
 DM.macros.setMacro(query, 'TABLENAME', ClassesTableName);

   case HistoryMode.ItemIndex of
   {Wszystkie zmiany
    Zmiany wykonane dzisiaj
    Zmiany wykonane wczoraj
    Zmiany wykonane przedwczoraj
    Zmiany - ostatnie 3 dni
    Zmiany - ostatnich 7 dni
    Zmiany - ostatnich 14 dni
    Zmiany - ostatnich 30 dni
    Zmiany w innym okresie}
    0:DM.macros.setMacro(query, 'HIST_FILTER', '0=0');
    1:DM.macros.setMacro(query, 'HIST_FILTER', getPeriod('trunc(sysdate)-0','trunc(sysdate)+1-NumTodsInterval(1, ''second'')'));
    2:DM.macros.setMacro(query, 'HIST_FILTER', getPeriod('trunc(sysdate)-1','trunc(sysdate)+0-NumTodsInterval(1, ''second'')'));
    3:DM.macros.setMacro(query, 'HIST_FILTER', getPeriod('trunc(sysdate)-2','trunc(sysdate)-1-NumTodsInterval(1, ''second'')'));
    4:DM.macros.setMacro(query, 'HIST_FILTER', getPeriod('trunc(sysdate)-2','trunc(sysdate)+1-NumTodsInterval(1, ''second'')'));
    5:DM.macros.setMacro(query, 'HIST_FILTER', getPeriod('trunc(sysdate)-6','trunc(sysdate)+1-NumTodsInterval(1, ''second'')'));
    6:DM.macros.setMacro(query, 'HIST_FILTER', getPeriod('trunc(sysdate)-13','trunc(sysdate)+1-NumTodsInterval(1, ''second'')'));
    7:DM.macros.setMacro(query, 'HIST_FILTER', getPeriod('trunc(sysdate)-29','trunc(sysdate)+1-NumTodsInterval(1, ''second'')'));
    8:DM.macros.setMacro(query, 'HIST_FILTER', getPeriod( DateToOracle(historyFrom.Date-1) , DateToOracle(historyTo.Date+1)  ));
   end;
   tablePostfix := '_HISTORY';

 // -------------- | ---------------- | -----------------

 sqll := GenericFilter.sqlL(tablePostfix);
 sqlg := GenericFilter.sqlG(tablePostfix);
 sqls := GenericFilter.sqlS(tablePostfix);
 sqlf := GenericFilter.sqlF(tablePostfix);
 sqlp := GenericFilter.sqlP(tablePostfix);
 sqlr0 := GenericFilter.sqlr0(tablePostfix);
 sqlr1 := GenericFilter.sqlr1(tablePostfix);

 DM.macros.setMacro(query, 'CONL', sqll );
 DM.macros.setMacro(query, 'CONG', sqlg );
 DM.macros.setMacro(query, 'CONS', sqls);
 DM.macros.setMacro(query, 'CONF', sqlf);
 DM.macros.setMacro(query, 'CONPERIOD', sqlp);
 DM.macros.setMacro(query, 'CONRESCAT0', sqlr0);
 DM.macros.setMacro(query, 'CONRESCAT1', sqlr1);

 if ChSelectedDates.Checked then begin
   DM.macros.setMacro(query, 'SELECTED_DATES', '( CLASSES.DAY,CLASSES.HOUR ) in ( select day,hour from tmp_selected_dates where sessionid = userenv(''SESSIONID'') )');
   FDAY_FROM.Visible := false;
   FDAY_TO.Visible := false;
   LDAYTO_Label.Visible := false;
   FHOUR.Visible := false;
   SkipRefresh := true; FDAY_FROM.Clear;
   SkipRefresh := true; FDAY_TO.Clear;
   FHOUR.ItemIndex:=-1;
 end
 else begin
   DM.macros.setMacro(query, 'SELECTED_DATES', '0=0');
   FDAY_FROM.Visible := true;
   FDAY_TO.Visible := true;
   LDAYTO_Label.Visible := true;
   FHOUR.Visible := true;
 end;

 //IsBlankDateFrom := DateToOracle(FDAY_FROM.Date) = 'TO_DATE(''1899.12.30'',''YYYY.MM.DD'')';
 //IsBlankDateTo   := DateToOracle(FDAY_TO.Date) = 'TO_DATE(''1899.12.30'',''YYYY.MM.DD'')';
 //if (IsBlankDateFrom=false) and (IsBlankDateTo=true)  then begin SkipRefresh := true; FDAY_TO.Text :=  FDAY_FROM.Text;  end;
 //if (IsBlankDateFrom=true) and (IsBlankDateTo=false)  then begin SkipRefresh := true; FDAY_FROM.Text :=  FDAY_TO.Text;  end;

 IsBlankDateFrom := DateToOracle(FDAY_FROM.Date) = 'TO_DATE(''1899.12.30'',''YYYY.MM.DD'')';
 IsBlankDateTo   := DateToOracle(FDAY_TO.Date) = 'TO_DATE(''1899.12.30'',''YYYY.MM.DD'')';
 SkipRefresh := false;
 if (IsBlankDateFrom=false) and (IsBlankDateTo=false) then DAY_FILTER:= 'DAY BETWEEN '+DateToOracle(FDAY_FROM.Date)+' AND '+DateToOracle(FDAY_TO.Date);
 if (IsBlankDateFrom=false) and (IsBlankDateTo=true)  then begin DAY_FILTER:= 'DAY >= '+DateToOracle(FDAY_FROM.Date);  end;
 if (IsBlankDateFrom=true) and (IsBlankDateTo=false)  then begin DAY_FILTER:= 'DAY <= '+DateToOracle(FDAY_TO.Date);   end;
 if (IsBlankDateFrom=true) and (IsBlankDateTo=true)   then DAY_FILTER:= '0=0';
 DM.macros.setMacro(query, 'DAY_FILTER1', DAY_FILTER);
 DM.macros.setMacro(query, 'DAY_FILTER2', DAY_FILTER);


 if Own.Checked then DM.macros.setMacro(query, 'OWN_CLASSES_ONLY', 'CLASSES.CREATED_BY=USER')
                else DM.macros.setMacro(query, 'OWN_CLASSES_ONLY', '0=0');

 if FHOUR.Text<>'' then
   DM.macros.setMacro(query, 'HOUR_FILTER', 'CLASSES.HOUR='+FHOUR.Text)
 else
   DM.macros.setMacro(query, 'HOUR_FILTER', '0=0');

 If GenericFilter.CONPLA.Text = '' Then DM.macros.setMacro(query, 'CONPLA', '0=0')
                   Else DM.macros.setMacro(query, 'CONPLA',  'CLASSES.LAST_UPDATED_BY = (SELECT NAME FROM PLANNERS WHERE ID ='+GenericFilter.CONPLA.Text+')' );

End;


procedure TFBrowseCLASSES_HISTORY.CONPERIODChange(Sender: TObject);
begin
  DModule.RefreshLookupEdit(Self, TControl(Sender).Name,sql_PERNAME,'PERIODS','');
  BRefreshClick(nil);
end;

procedure TFBrowseCLASSES_HISTORY.FormShow(Sender: TObject);
begin
  inherited;
  BEdit.Visible :=  HideEdit = false;
  BAdd.Visible :=  false;
  BCopy.Visible :=  HideEdit = false;
  SkipRefresh := false;
  showMoreClick(nil);
  BDelete.Visible := false;
  Own.Enabled := isAdmin=true;
end;

procedure TFBrowseCLASSES_HISTORY.FGenericFilter1conlChange(Sender: TObject);
begin
  GenericFilter.conlChange(Sender);
end;

procedure TFBrowseCLASSES_HISTORY.GenericFilterconsChange(Sender: TObject);
begin
  GenericFilter.consChange(Sender);
end;

procedure TFBrowseCLASSES_HISTORY.GenericFiltercongChange(Sender: TObject);
begin
  GenericFilter.congChange(Sender);
end;

procedure TFBrowseCLASSES_HISTORY.GenericFilterconfChange(Sender: TObject);
begin
  GenericFilter.confChange(Sender);
end;

procedure TFBrowseCLASSES_HISTORY.GenericFilterconResCat0Change(Sender: TObject);
begin
  GenericFilter.conResCat0Change(Sender);
end;

procedure TFBrowseCLASSES_HISTORY.GenericFilterconPerChange(Sender: TObject);
begin
  GenericFilter.conPeriodChange(Sender);
end;

procedure TFBrowseCLASSES_HISTORY.GenericFilterconResCat1Change(Sender: TObject);
begin
  GenericFilter.conResCat1Change(Sender);
end;

procedure TFBrowseCLASSES_HISTORY.GenericFilterconPlaChange(Sender: TObject);
begin
  GenericFilter.conPlaChange(Sender);
  BRefreshClick(nil);
end;

procedure TFBrowseCLASSES_HISTORY.historyFromChange(Sender: TObject);
begin
  BRefreshClick ( nil );
end;

procedure TFBrowseCLASSES_HISTORY.historyToChange(Sender: TObject);
begin
  BRefreshClick ( nil );
end;

Procedure TFBrowseCLASSES_HISTORY.GetTableName;
Begin
  Self.TableName := classesTableName;
End;

procedure TFBrowseCLASSES_HISTORY.ConflictWithReservationsChange(Sender: TObject);
begin
  BRefreshClick(nil);
end;

procedure TFBrowseCLASSES_HISTORY.GenericFilterMenuItem5Click(Sender: TObject);
begin
  GenericFilter.mileClick(sender);
  BRefreshClick(nil);
end;

procedure TFBrowseCLASSES_HISTORY.GenericFilterMenuItem6Click(Sender: TObject);
begin
  GenericFilter.milaClick(sender);
  BRefreshClick(nil);
end;

procedure TFBrowseCLASSES_HISTORY.GenericFilterbClearLClick(Sender: TObject);
begin
  GenericFilter.bClearLClick(Sender);
  BRefreshClick(nil);
end;

procedure TFBrowseCLASSES_HISTORY.GenericFilterbClearSClick(Sender: TObject);
begin
  GenericFilter.bClearSClick(Sender);
  BRefreshClick(nil);
end;

procedure TFBrowseCLASSES_HISTORY.GenericFilterbClearGClick(Sender: TObject);
begin
  GenericFilter.bClearGClick(Sender);
  BRefreshClick(nil);
end;

procedure TFBrowseCLASSES_HISTORY.GenericFilterbClearFClick(Sender: TObject);
begin
  GenericFilter.bClearFClick(Sender);
  BRefreshClick(nil);
end;

procedure TFBrowseCLASSES_HISTORY.GenericFilterbClearPeriodClick(Sender: TObject);
begin
  GenericFilter.bClearPeriodClick(Sender);
  BRefreshClick(nil);
end;

procedure TFBrowseCLASSES_HISTORY.GenericFilterMenuItem7Click(Sender: TObject);
begin
   GenericFilter.migeClick(sender);
   BRefreshClick(nil);
end;

procedure TFBrowseCLASSES_HISTORY.GenericFilterMenuItem8Click(Sender: TObject);
begin
   GenericFilter.migaClick(sender);
   BRefreshClick(nil);
end;

procedure TFBrowseCLASSES_HISTORY.GenericFilterMenuItem11Click(Sender: TObject);
begin
   GenericFilter.miseClick(sender);
   BRefreshClick(nil);
end;

procedure TFBrowseCLASSES_HISTORY.GenericFilterMenuItem12Click(Sender: TObject);
begin
   GenericFilter.misaClick(sender);
   BRefreshClick(nil);
end;

procedure TFBrowseCLASSES_HISTORY.GenericFilterMenuItem13Click(Sender: TObject);
begin
   GenericFilter.mifeClick(sender);
   BRefreshClick(nil);
end;

procedure TFBrowseCLASSES_HISTORY.GenericFilterMenuItem14Click(Sender: TObject);
begin
   GenericFilter.mifaClick(sender);
   BRefreshClick(nil);
end;

procedure TFBrowseCLASSES_HISTORY.GenericFilterFiltrprosty1Click(Sender: TObject);
begin
   GenericFilter.mipeClick(sender);
   BRefreshClick(nil);
end;

procedure TFBrowseCLASSES_HISTORY.GenericFilterFiltrzaawansowany1Click(
  Sender: TObject);
begin
   GenericFilter.mipaClick(sender);
   BRefreshClick(nil);
end;

procedure TFBrowseCLASSES_HISTORY.GenericFilterbClearRes0Click(Sender: TObject);
begin
  GenericFilter.bClearRes0Click(Sender);
  BRefreshClick(nil);
end;

procedure TFBrowseCLASSES_HISTORY.GenericFilterbClearRes1Click(Sender: TObject);
begin
  GenericFilter.bClearRes1Click(Sender);
  BRefreshClick(nil);
end;

procedure TFBrowseCLASSES_HISTORY.GenericFiltermir0eClick(Sender: TObject);
begin
  GenericFilter.mir0eClick(Sender);
  BRefreshClick(nil);
end;

procedure TFBrowseCLASSES_HISTORY.GenericFiltermir0aClick(Sender: TObject);
begin
  GenericFilter.mir0aClick(Sender);
  BRefreshClick(nil);
end;

procedure TFBrowseCLASSES_HISTORY.GenericFiltermir1eClick(Sender: TObject);
begin
  inherited;
  GenericFilter.mir1eClick(Sender);
  BRefreshClick(nil);
end;

procedure TFBrowseCLASSES_HISTORY.GenericFiltermir1aClick(Sender: TObject);
begin
  GenericFilter.mir1aClick(Sender);
  BRefreshClick(nil);
end;

procedure TFBrowseCLASSES_HISTORY.FHOURChange(Sender: TObject);
begin
  BRefreshClick(nil);
end;

procedure TFBrowseCLASSES_HISTORY.FDAY_FROMChange(Sender: TObject);
begin
  if SkipRefresh then begin
   SkipRefresh := false;
   exit;
  end;
  SearchCounter := 3;
end;

procedure TFBrowseCLASSES_HISTORY.ChSelectedDatesClick(Sender: TObject);
begin
 BRefreshClick(nil);
end;

function TFBrowseCLASSES_HISTORY.getSearchFilter: string;
var searchText : string;
begin
  if trim(ESearch.Text)='' then
    result := '0=0'
  else begin
    searchText := replacePolishChars( ansiuppercase(trim(EscapeApostrophes(ESearch.Text))) );
    result := fastQueryString.Lines.Text;
    result := stringreplace(result, 'var1', searchText, []);
    result := stringreplace(result, 'var2', searchText, []);
    result := stringreplace(result, 'var3', searchText, []);
    result := stringreplace(result, 'var4', searchText, []);
    result := stringreplace(result, 'var5', searchText, []);
    result := stringreplace(result, 'var6', searchText, []);
    result := stringreplace(result, 'var7', searchText, []);
    result := stringreplace(result, 'var8', searchText, []);
    result := stringreplace(result, 'var9', searchText, []);
    result := stringreplace(result, 'var10', searchText, []);
    result := stringreplace(result, 'var11', searchText, []);
  end;
  //select id from periods m where (xxmsz_tools.erasePolishChars(upper(m.name||m.desc1||m.desc2||m.attribs_01||m.attribs_02||m.attribs_03||m.attribs_04||m.attribs_05||m.attribs_06||m.attribs_07||m.attribs_08||m.attribs_09||m.attribs_10||m.attribs_11||m.attribs_12||m.attribs_13||m.attribs_14||m.attribs_15)) like '%'+replacePolishChars( ansiuppercase(trim(ESearch.Text)) )+'%' )
end;


function TFBrowseCLASSES_HISTORY.getFindCaption: string;
begin
 Result := 'Dowolna fraza';
end;

procedure TFBrowseCLASSES_HISTORY.editClick;
begin
  fmain.classForEdition := Query['Id'];
  close;
end;

procedure TFBrowseCLASSES_HISTORY.BitBtn1Click(Sender: TObject);
begin
  if ChSelectedDates.Checked then ChSelectedDates.Checked := false;
  FDAY_FROM.Visible := true;
  FDAY_TO.Visible := true;
  SkipRefresh := true; FDAY_FROM.Clear;
  SkipRefresh := true; FDAY_TO.Clear;
  BRefreshClick(nil);
end;

procedure TFBrowseCLASSES_HISTORY.showMoreClick(Sender: TObject);
begin
  inherited;
  GenericFilter.Visible :=  showMore.Checked;
  PanelDates.Visible :=  showMore.Checked;

  if showMore.Checked then CustomPanel.Height := 176
   else CustomPanel.Height := 41;
end;

procedure TFBrowseCLASSES_HISTORY.OwnClick(Sender: TObject);
begin
  BRefreshClick ( nil );
end;

procedure TFBrowseCLASSES_HISTORY.ComboSortOrderChange(Sender: TObject);
begin
  inherited;
  historyFrom.Visible := HistoryMode.ItemIndex=8;
  historyTo.Visible := HistoryMode.ItemIndex=8;
  Label3.Visible := HistoryMode.ItemIndex=8;
end;

procedure TFBrowseCLASSES_HISTORY.BUndoClick(Sender: TObject);
Var tgrid   : integer;
    operation : string;
    myClass : TClass_;
    errMessage : string;

    procedure performOperation;
    begin
     if  (operation='D') then begin
      myClass := QWorkToClass (Query);
      planner_utils_insert_classes ( myClass,'',Query.FieldByName('ID').AsInteger );
      dmodule.sql('begin update classes_history set operation_flag=''d'' where attribn_01=:id; end;','id='+Query.FieldByName('attribn_01').AsString);
     end;
     if  (operation='I') then begin
          dmodule.sql('begin api.delete_class (:id ); end;'
             ,'id='+Query.FieldByName('ID').AsString
             );
          dmodule.sql('begin update classes_history set operation_flag=''i'' where attribn_01=:id; end;','id='+Query.FieldByName('attribn_01').AsString);
     end;
    end;

begin

  dmodule.CommitTrans;
  FProgress.Show;
  raiseException := true;
  quickInsertMode := true;

  try

	  if Grid.SelectedRows.Count = 0 then begin
       FProgress.ProgressBar.Position :=  50;
       FProgress.Refresh;
       operation := Query.FieldByName('OPERATION_FLAG').AsString;
       performOperation;
    end;

    //first remove inserts (delete)
	  For tgrid := 0 To Grid.SelectedRows.Count - 1 Do Begin
      FProgress.ProgressBar.Position :=  round(tgrid *  FProgress.ProgressBar.Max / Grid.SelectedRows.Count - 1);
      FProgress.Refresh;
      Query.Bookmark := Grid.SelectedRows.Items[tgrid];
      operation := Query.FieldByName('OPERATION_FLAG').AsString;
      if  (operation='I') then performOperation;
	  End;
    //then revert deletions (delete)
	  For tgrid := 0 To Grid.SelectedRows.Count - 1 Do Begin
      FProgress.ProgressBar.Position :=  round(tgrid *  FProgress.ProgressBar.Max / Grid.SelectedRows.Count - 1);
      FProgress.Refresh;
      Query.Bookmark := Grid.SelectedRows.Items[tgrid];
      operation := Query.FieldByName('OPERATION_FLAG').AsString;
      if  (operation='D') then performOperation;
	  End;

  except
       on E:exception do Begin
         FProgress.Hide;
         errMessage :=  '*** Nie mo¿na cofn¹æ operacji: '+CR+CR+'Dzieñ i godzina zajêcia:' + Query.FieldByName('DAY').AsString  +':'+ Query.FieldByName('HOUR_DSP').AsString +CR+CR+'Przyczyna: Cofniêcie operacji naruszy³oby spójnoœæ danych w bazie.'+ CR +CR + e.Message;
         fmain.wlog( errMessage);
         SError( errMessage );
         Dmodule.RollbackTrans;
       end;
  end;

  FProgress.Hide;
  quickInsertMode := false;
  raiseException := false;
  Fmain.DeepRefreshImmediate('classesHistory');
  BRefreshClick(nil);
end;
procedure TFBrowseCLASSES_HISTORY.FHelpClick(Sender: TObject);
begin
    SError('Mo¿esz zaznaczyc wiele czynnoœci.');
end;

end.
