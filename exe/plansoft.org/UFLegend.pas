unit UFLegend;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UFormConfig, StdCtrls, Buttons, ExtCtrls, Db, DBTables, Grids, DBGrids,
  ComCtrls, uutilityParent, ADODB, Menus,
  {used by export to excel} ActiveX, TlHelp32, OleServer,ExcelXP, Variants,
  ImgList, CheckLst, DBCtrls;

type
  TFLegend = class(TFormConfig)
    PageControl: TPageControl;
    TabSheetL: TTabSheet;
    TabSheetG: TTabSheet;
    TabSheetR: TTabSheet;
    TabSheetS: TTabSheet;
    GridL: TDBGrid;
    GRIDG: TDBGrid;
    GRIDR: TDBGrid;
    GRIDS: TDBGrid;
    DSL: TDataSource;
    DSG: TDataSource;
    DSR: TDataSource;
    DSS: TDataSource;
    bottomPanel: TPanel;
    FindMode: TRadioGroup;
    TabSheetCOUNTER: TTabSheet;
    gridCounter: TDBGrid;
    DSCounter: TDataSource;
    groupByForm: TCheckBox;
    SelectedSubOnly: TCheckBox;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    QueryL: TADOQuery;
    QueryG: TADOQuery;
    QueryR: TADOQuery;
    QueryS: TADOQuery;
    QueryCOUNTER: TADOQuery;
    bClose: TBitBtn;
    BRefresh: TSpeedButton;
    groupByDesc1: TCheckBox;
    groupByDesc2: TCheckBox;
    groupByDesc3: TCheckBox;
    groupByDesc4: TCheckBox;
    upperPanel: TPanel;
    Filter: TEdit;
    BOleExport: TBitBtn;
    ppexport: TPopupMenu;
    ExportEasy: TMenuItem;
    ExportHtml: TMenuItem;
    ExcelApplication1: TExcelApplication;
    ImageList: TImageList;
    SqlR: TMemo;
    RoomAdvPanel: TPanel;
    Splitter1: TSplitter;
    SpeedButton3: TSpeedButton;
    RMore: TSpeedButton;
    FormsList: TCheckListBox;
    Label1: TLabel;
    Label2: TLabel;
    HoursList: TCheckListBox;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    SpeedButton7: TSpeedButton;
    Label3: TLabel;
    ClassesSelectedTotal: TEdit;
    MinusReservations: TCheckBox;
    groupByLDesc1: TCheckBox;
    groupByLDesc2: TCheckBox;
    groupByLDesc3: TCheckBox;
    groupByLDesc4: TCheckBox;
    groupByL: TCheckBox;
    addRollUp: TCheckBox;
    TabsheetTimetableNotes: TTabSheet;
    GroupBox1: TGroupBox;
    Splitter2: TSplitter;
    GroupBox2: TGroupBox;
    Splitter3: TSplitter;
    GroupBox3: TGroupBox;
    QueryTimetableNotes: TADOQuery;
    DSTimetableNotes: TDataSource;
    notes_before: TDBMemo;
    notes_after: TDBMemo;
    internal_notes: TDBMemo;
    SpeedButton8: TSpeedButton;
    BEditor: TSpeedButton;
    SpeedButton9: TSpeedButton;
    groupByG: TCheckBox;
    groupByR: TCheckBox;
    groupByS: TCheckBox;
    procedure GridLDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure GRIDGDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure GRIDRDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure GRIDSDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure FormCreate(Sender: TObject);
    procedure FindModeClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure PageControlChange(Sender: TObject);
    procedure groupByFormClick(Sender: TObject);
    procedure SelectedSubOnlyClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure QueryCOUNTERAfterOpen(DataSet: TDataSet);
    procedure QueryLAfterOpen(DataSet: TDataSet);
    procedure QueryGAfterOpen(DataSet: TDataSet);
    procedure QueryRAfterOpen(DataSet: TDataSet);
    procedure QuerySAfterOpen(DataSet: TDataSet);
    procedure QueryCOUNTERBeforeOpen(DataSet: TDataSet);
    procedure PageControlChanging(Sender: TObject;
      var AllowChange: Boolean);
    procedure BRefreshClick(Sender: TObject);
    procedure FilterChange(Sender: TObject);
    procedure gridCounterDblClick(Sender: TObject);
    procedure BOleExportClick(Sender: TObject);
    procedure ExportEasyClick(Sender: TObject);
    procedure ExportHtmlClick(Sender: TObject);
    procedure RMoreClick(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure SpeedButton7Click(Sender: TObject);
    procedure HoursListClick(Sender: TObject);
    procedure FormsListClick(Sender: TObject);
    procedure MinusReservationsClick(Sender: TObject);
    procedure GRIDRMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SpeedButton8Click(Sender: TObject);
    procedure BEditorClick(Sender: TObject);
    procedure SpeedButton9Click(Sender: TObject);
  private
    gridsFontSize : integer;
    refreshAllowed : boolean;
    procedure refreshGridSize;
    function getFileName ( g : tdbgrid ) : shortstring;
  public
    CondL, CondG, CondR : String;
    FormsListIds : Array of string;
    HoursListIds : Array of string;
    Procedure SetWheres(aCondL, aCondG, aCondR : String);
    procedure saveFormSettings;
    Procedure ExportToHtml(aGrid : TDBGrid );
    procedure getFilters(var forms_filter : string; var hours_filter : string);
    Procedure SaveTimeTableNotes;
  end;

var
  FLegend: TFLegend;

implementation

uses UFMain, DM, UFProgramSettings;

{$R *.DFM}

procedure TFLegend.GridLDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
  inherited;
 If Column.FieldName = 'COLOUR' Then
 Begin
   GridL.Canvas.Brush.Color := QUERYL.FieldByName('COLOUR').AsInteger;
   GridL.Canvas.FillRect(Rect);
 End;

 {
 if column.FieldName = 'AVAILABLE_LEC' then
 begin
   GridL.Canvas.Font.Color := clBlack;
   str := QUERYL.FieldByName(column.FieldName).AsString;

   GridL.Canvas.TextOut(rect.Left + 10 //+ ( (rect.Left-rect.right) - GridL.Canvas.TextWidth(str) ) div 2
                       ,rect.Top + 2
                       , str );
   GridL.Canvas.pen.mode := pmXor;
   GridL.Canvas.pen.Color := clRed;
   for t := rect.Top to rect.Bottom do
   begin
    GridL.Canvas.LineTo(rect.left,t);
    GridL.Canvas.MoveTo(rect.Right,t);
   end;
 end;
 }

end;

procedure TFLegend.GRIDGDrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  inherited;
 If Column.FieldName = 'COLOUR' Then
  Begin
   GridG.Canvas.Brush.Color := QUERYG.FieldByName('COLOUR').AsInteger;
   GridG.Canvas.FillRect(Rect);
  End;
end;

procedure TFLegend.GRIDRDrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
 If Column.FieldName = 'COLOUR' Then
  Begin
   GridR.Canvas.Brush.Color := QUERYR.FieldByName('COLOUR').AsInteger;
   GridR.Canvas.FillRect(Rect);
  End;
end;

procedure TFLegend.GRIDSDrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  inherited;
 If Column.FieldName = 'COLOUR' Then
  Begin
   GridS.Canvas.Brush.Color := QUERYS.FieldByName('COLOUR').AsInteger;
   GridS.Canvas.FillRect(Rect);
  End;
end;

procedure TFLegend.FormCreate(Sender: TObject);
begin
  inherited;
  //self.AlphaBlend := true;
  self.AlphaBlendValue := 230;
  CondL := '0=0';
  CondG := '0=0';
  CondR := '0=0';
end;

Procedure TFLegend.SetWheres(aCondL, aCondG, aCondR : String);
Var HaveToRefresh : Boolean;
Begin
 //2010.04.28 CondL contains select clause not ids anymoore
 //HaveToRefresh := (CondL <> aCondL) or (CondG <> aCondG) or (CondR <> aCondR);
 HaveToRefresh := true;
 CondL := aCondL;
 CondG := aCondG;
 CondR := aCondR;
 if HaveToRefresh then BRefreshClick(nil);
End;


function getWhereClause : string;
 var days : string;
     whereClause : string;
begin
    if not strIsEmpty(fmain.CONPERIOD.Text) then begin
      days := '';
      whereClause :=
        'CLA.DAY BETWEEN (SELECT DATE_FROM FROM PERIODS WHERE ID = '+nvl(fmain.CONPERIOD.Text,'-1')+') AND ' + CR +
        '            (SELECT DATE_TO   FROM PERIODS WHERE ID = '  +nvl(fmain.CONPERIOD.Text,'-1')+')     ' + CR;

      with DModule do Begin
        OPENSQL('SELECT SHOW_MON,SHOW_TUE,SHOW_WED,SHOW_THU,SHOW_FRI,SHOW_SAT,SHOW_SUN, hours_per_day  FROM PERIODS WHERE ID = ' + fmain.CONPERIOD.Text);
        if QWork.Fields[0].AsString = '+' then days := merge(days, '1', ',');
        if QWork.Fields[1].AsString = '+' then days := merge(days, '2', ',');
        if QWork.Fields[2].AsString = '+' then days := merge(days, '3', ',');
        if QWork.Fields[3].AsString = '+' then days := merge(days, '4', ',');
        if QWork.Fields[4].AsString = '+' then days := merge(days, '5', ',');
        if QWork.Fields[5].AsString = '+' then days := merge(days, '6', ',');
        if QWork.Fields[6].AsString = '+' then days := merge(days, '7', ',');

        whereClause := merge(whereClause, 'CLA.HOUR <=' + QWork.Fields[7].AsString, ' AND ');
      end;
      if not strIsEmpty(days) then whereClause := merge(whereClause, 'TO_CHAR(CLA.DAY,''D'') IN ('+days+')', ' AND ');
    end else whereClause := '0=0';
    result :=  '(' + whereClause + ')';
end;

procedure TFLegend.FindModeClick(Sender: TObject);
begin
  inherited;
  FMain.refreshLegend;
end;

procedure TFLegend.FormShow(Sender: TObject);
begin
  UpperPanel.Visible := PageControl.ActivePage <> TabsheetTimetableNotes;
  BottomPanel.Visible := PageControl.ActivePage <> TabsheetTimetableNotes;

  refreshAllowed := false;
  inherited;
  if flegend.Floating then begin
    FLegend.Left   := strToInt( getSystemParam('FLegend.Left'  ,intToStr(flegend.left))   );
    FLegend.Top    := strToInt( getSystemParam('FLegend.Top'   ,intToStr(flegend.top))    );
    FLegend.Width  := strToInt( getSystemParam('FLegend.Width' ,intToStr(flegend.width))  );
    FLegend.Height := strToInt( getSystemParam('FLegend.Height',intToStr(flegend.height)) );
  end;

  groupByForm.checked := StrToBool( getSystemParam('FLegend.groupByForm.checked' ));
  addRollUp.checked := StrToBool( getSystemParam('FLegend.addRollUp.checked' ));
  minusReservations.checked := StrToBool( getSystemParam('FLegend.minusReservations.checked' ));
  groupByDesc1.checked := StrToBool( getSystemParam('FLegend.groupByDesc1.checked' ));
  groupByDesc2.checked := StrToBool( getSystemParam('FLegend.groupByDesc2.checked' ));
  groupByDesc3.checked := StrToBool( getSystemParam('FLegend.groupByDesc3.checked' ));
  groupByDesc4.checked := StrToBool( getSystemParam('FLegend.groupByDesc4.checked' ));
  groupByL.checked      := StrToBool( getSystemParam('FLegend.groupByL.checked' ));
  groupByG.checked      := StrToBool( getSystemParam('FLegend.groupByG.checked' ));
  groupByS.checked      := StrToBool( getSystemParam('FLegend.groupByS.checked','+'));
  groupByR.checked      := StrToBool( getSystemParam('FLegend.groupByR.checked' ));
  SelectedSubOnly.checked := StrToBool( getSystemParam('FLegend.groupByR.SelectedSubOnly' ));
  groupByLDesc1.checked := StrToBool( getSystemParam('FLegend.groupByLDesc1.checked' ));
  groupByLDesc2.checked := StrToBool( getSystemParam('FLegend.groupByLDesc2.checked' ));
  groupByLDesc3.checked := StrToBool( getSystemParam('FLegend.groupByLDesc3.checked' ));
  groupByLDesc4.checked := StrToBool( getSystemParam('FLegend.groupByLDesc4.checked' ));

  gridsFontSize := strToInt ( getSystemParam('FLegend.gridsFontSize','9') );
  refreshGridSize;
  refreshAllowed := true;
  BRefreshClick(nil);
end;

procedure TFLegend.PageControlChange(Sender: TObject);
begin
  UpperPanel.Visible  := PageControl.ActivePage <> TabsheetTimetableNotes;
  BottomPanel.Visible := PageControl.ActivePage <> TabsheetTimetableNotes;
  BRefreshClick(nil);
end;

procedure TFLegend.groupByFormClick(Sender: TObject);
begin
  if not refreshAllowed then exit;
  saveFormSettings;
  BRefreshClick(nil);
end;

procedure TFLegend.SelectedSubOnlyClick(Sender: TObject);
begin
  inherited;
  BRefreshClick(nil);
end;

procedure TFLegend.refreshGridSize;
begin
  GRIDL.Font.Size := gridsFontSize;
  GRIDG.Font.Size := gridsFontSize;
  GRIDR.Font.Size := gridsFontSize;
  GRIDS.Font.Size := gridsFontSize;
  gridCounter.Font.Size := gridsFontSize;
end;


procedure TFLegend.SpeedButton1Click(Sender: TObject);
begin
  gridsFontSize := gridsFontSize + 1;
  refreshGridSize;
end;

procedure TFLegend.SpeedButton2Click(Sender: TObject);
begin
  if gridsFontSize > 1 then
    gridsFontSize := gridsFontSize - 1;
  refreshGridSize;
end;

procedure TFLegend.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveFormSettings;

  with fmain do
  begin
   Legend.Down := false;
   //Legenda1.Checked := Legend.Down;
  end;

  if not flegend.Floating then
    if HostDockSite.VisibleDockClientCount <= 1 then
      HostDockSite.Width := 1;
end;

function TFLegend.getFileName(g: tdbgrid): shortstring;
var i : integer;
    s : string;
begin
  s := '';
  for i := 0 to g.FieldCount-1 do begin
    //if g.columns[i].Visible then
      s := s + '.'+g.columns[i].FieldName;
  end;
  Result := UUtilityParent.StringsPATH + extractFileName(Application.ExeName) + '.' + self.Name + '.' +  g.name + '.' + s + '.bin';
end;

procedure TFLegend.QueryCOUNTERAfterOpen(DataSet: TDataSet);
var i : integer;
    //s : string;
begin
    //s := '';
    //for i := 0 to gridCounter.FieldCount-1 do begin
    //  s := s + ','+gridCounter.columns[i].FieldName;
    //end;
    //info ( s );

  if fileExists( getFileName(gridCounter) ) then
    gridCounter.Columns.LoadFromFile( getFileName(gridCounter) )
  else begin
    for i := 0 to gridCounter.FieldCount-1 do begin
      if gridCounter.columns[i].FieldName = 'Przedmiot' then gridCounter.Columns[i].Width := 150;
      if gridCounter.columns[i].FieldName = 'Forma' then gridCounter.Columns[i].Width := 100;
      if gridCounter.columns[i].FieldName = 'Liczba godzin' then gridCounter.Columns[i].Width := 60;
      if gridCounter.columns[i].FieldName =  fprogramSettings.getClassDescPlural(1) then gridCounter.Columns[i].Width := 60;
      if gridCounter.columns[i].FieldName =  fprogramSettings.getClassDescPlural(2) then gridCounter.Columns[i].Width := 60;
      if gridCounter.columns[i].FieldName =  fprogramSettings.getClassDescPlural(3) then gridCounter.Columns[i].Width := 60;
      if gridCounter.columns[i].FieldName =  fprogramSettings.getClassDescPlural(4) then gridCounter.Columns[i].Width := 60;
    end;
  end;

  for i := 0 to gridCounter.FieldCount-1 do begin
    if gridCounter.Columns[i].Width>150 then gridCounter.Columns[i].Width := 150;
  end;

end;

procedure TFLegend.QueryLAfterOpen(DataSet: TDataSet);
begin
  if fileExists( getFileName(gridL) ) then gridL.Columns.LoadFromFile( getFileName(gridL) ) ;
end;

procedure TFLegend.QueryGAfterOpen(DataSet: TDataSet);
begin
  if fileExists( getFileName(gridG) ) then gridG.Columns.LoadFromFile( getFileName(gridG) ) ;
end;

procedure TFLegend.QueryRAfterOpen(DataSet: TDataSet);
var fileName : string;
begin
  fileName := getFileName(gridR);
  if fileExists( fileName )
    then gridR.Columns.LoadFromFile( fileName ) else
  begin
  end;
end;

procedure TFLegend.QuerySAfterOpen(DataSet: TDataSet);
begin
  if fileExists( getFileName(gridS) ) then gridS.Columns.LoadFromFile( getFileName(gridS) ) ;
end;

procedure TFLegend.QueryCOUNTERBeforeOpen(DataSet: TDataSet);
begin
  gridCounter.Columns.Clear;
end;

procedure TFLegend.saveFormSettings;
begin
  gridCounter.Columns.SaveToFile( getFileName(gridCounter) ) ;
  gridL.Columns.SaveToFile( getFileName(gridL) ) ;
  gridG.Columns.SaveToFile( getFileName(gridG) ) ;
  gridR.Columns.SaveToFile( getFileName(gridR) ) ;
  gridS.Columns.SaveToFile( getFileName(gridS) ) ;

  setSystemParam('FLegend.gridsFontSize',intToStr (gridsFontSize) );

  setSystemParam('FLegend.Left'  ,intToStr ( FLegend.Left  ) );
  setSystemParam('FLegend.Top'   ,intToStr ( FLegend.Top   ) );
  setSystemParam('FLegend.Width' ,intToStr ( FLegend.Width ) );
  setSystemParam('FLegend.Height',intToStr ( FLegend.Height ) );

  setSystemParam('FLegend.groupByForm.checked',BoolToStr ( FLegend.groupByForm.checked ) );
  setSystemParam('FLegend.addRollUp.checked',BoolToStr ( FLegend.addRollUp.checked ) );
  setSystemParam('FLegend.minusReservations.checked',BoolToStr ( FLegend.minusReservations.checked ) );
  setSystemParam('FLegend.groupByDesc1.checked',BoolToStr ( FLegend.groupByDesc1.checked ) );
  setSystemParam('FLegend.groupByDesc2.checked',BoolToStr ( FLegend.groupByDesc2.checked ) );
  setSystemParam('FLegend.groupByDesc3.checked',BoolToStr ( FLegend.groupByDesc3.checked ) );
  setSystemParam('FLegend.groupByDesc4.checked',BoolToStr ( FLegend.groupByDesc4.checked ) );
  //
  setSystemParam('FLegend.groupByL.checked',BoolToStr ( FLegend.groupByL.checked ) );
  setSystemParam('FLegend.groupByG.checked',BoolToStr ( FLegend.groupByG.checked ) );
  setSystemParam('FLegend.groupByS.checked',BoolToStr ( FLegend.groupByS.checked ) );
  setSystemParam('FLegend.groupByR.checked',BoolToStr ( FLegend.groupByR.checked ) );
  setSystemParam('FLegend.SelectedSubOnly.checked',BoolToStr ( FLegend.SelectedSubOnly.checked ) );
  setSystemParam('FLegend.groupByLDesc1.checked',BoolToStr ( FLegend.groupByLDesc1.checked ) );
  setSystemParam('FLegend.groupByLDesc2.checked',BoolToStr ( FLegend.groupByLDesc2.checked ) );
  setSystemParam('FLegend.groupByLDesc3.checked',BoolToStr ( FLegend.groupByLDesc3.checked ) );
  setSystemParam('FLegend.groupByLDesc4.checked',BoolToStr ( FLegend.groupByLDesc4.checked ) );

  if FormsList.Items.Count>0 then
   setSystemParam('FLegend.formsList.checked',checkListBoxToText(formsList) );

  if FormsList.Items.Count>0 then
   setSystemParam('FLegend.hoursList.checked',checkListBoxToText(hoursList) );

end;

procedure TFLegend.PageControlChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
  saveFormSettings;
end;

procedure TFLegend.BRefreshClick(Sender: TObject);
Var forms_filter,hours_filter : string;
    groupByClause : string;
    orderByClause : string;
begin
  if not refreshAllowed then exit;
  //LTotal.Visible := false;
  FindMode.Visible := PageControl.ActivePage <> tabSheetCounter;
  groupByForm.Visible := (PageControl.ActivePage = tabSheetCounter) and (not manySubjectsFlag);
  RMore.Visible := (PageControl.ActivePage = tabSheetR) and (RoomAdvPanel.Visible=false);
  groupByDesc1.Visible := (PageControl.ActivePage = tabSheetCounter) and (fprogramsettings.getClassDescPlural(1)<>'');
  groupByDesc2.Visible := (PageControl.ActivePage = tabSheetCounter) and (fprogramsettings.getClassDescPlural(2)<>'');
  groupByDesc3.Visible := (PageControl.ActivePage = tabSheetCounter) and (fprogramsettings.getClassDescPlural(3)<>'');
  groupByDesc4.Visible := (PageControl.ActivePage = tabSheetCounter) and (fprogramsettings.getClassDescPlural(4)<>'');
  //
  groupByL.Visible      := (PageControl.ActivePage = tabSheetCounter);
  groupByG.Visible      := (PageControl.ActivePage = tabSheetCounter);
  groupByS.Visible      := (PageControl.ActivePage = tabSheetCounter);
  groupByR.Visible      := (PageControl.ActivePage = tabSheetCounter);
  groupByLDesc1.Visible := (PageControl.ActivePage = tabSheetCounter) and (fprogramsettings.getClassDescSingular(1)<>'');
  groupByLDesc2.Visible := (PageControl.ActivePage = tabSheetCounter) and (fprogramsettings.getClassDescSingular(2)<>'');
  groupByLDesc3.Visible := (PageControl.ActivePage = tabSheetCounter) and (fprogramsettings.getClassDescSingular(3)<>'');
  groupByLDesc4.Visible := (PageControl.ActivePage = tabSheetCounter) and (fprogramsettings.getClassDescSingular(4)<>'');
  //
  SelectedSubOnly.Visible := (PageControl.ActivePage = tabSheetCounter) and (not manySubjectsFlag);
  addRollUp.visible := PageControl.ActivePage = tabSheetCounter;
  //
  if manySubjectsFlag then begin
    groupByForm.Visible := false;
    groupByForm.checked := false;
    groupByS.Visible := false;
    groupByS.checked := false;
    SelectedSubOnly.Visible := false;
    SelectedSubOnly.Checked := false;
  end;

  dmodule.resetConnection ( QueryCOUNTER );

  //required by planner_utils.get_available_lec function
  if FindMode.ItemIndex = 0 then fmain.set_tmp_selected_dates;

  if PageControl.ActivePage = TabsheetL       then begin
    dmodule.resetConnection ( QueryL );
    QueryL.SQL.Clear;
    QueryL.SQL.Add('SELECT lecturers.*, planner_utils.get_available_lec(lecturers.id) available_lec FROM LECTURERS, LEC_PLA WHERE '+CondL+' AND LEC_PLA.LEC_ID = LECTURERS.ID AND PLA_ID = '+FMain.getUserOrRoleID+' AND '+fmain.getWhereFastFilter(self.filter.text, 'LECTURERS')+' ORDER BY LAST_NAME');
    QueryL.Open;
  end;

  if PageControl.ActivePage = TabsheetG       then begin
    dmodule.resetConnection ( QueryG );
    QueryG.SQL.Clear;
    QueryG.SQL.Add('SELECT groups.*, planner_utils.get_available_gro(groups.id) available_gro FROM GROUPS, GRO_PLA WHERE '+CondG+' AND GRO_PLA.GRO_ID = GROUPS.ID AND PLA_ID = '+FMain.getUserOrRoleID+' AND '+fmain.getWhereFastFilter(self.filter.text, 'GROUPS')+' ORDER BY NAME');
    QueryG.Open;
  end;

  if PageControl.ActivePage = TabsheetR       then begin
    dmodule.resetConnection ( QueryR );
    getFilters(forms_filter,hours_filter);
    ClassesSelectedTotal.Text :=
    dmodule.SingleValue(
    SearchAndReplace(SearchAndReplace(
    'select count(1) from (select day, hour from tmp_selected_dates where sessionid = userenv(''sessionid'') and :hours_filter :minus_reservations)'
    ,':hours_filter',hours_filter)
    ,':minus_reservations',iif(MinusReservations.checked,'minus select day,hour from reservations',''))
    );
    QueryR.SQL.Clear;
    QueryR.SQL.Add(
      SearchAndReplace(SearchAndReplace(SearchAndReplace(SearchAndReplace(SearchAndReplace(SearchAndReplace(SearchAndReplace(SearchAndReplace(
      SqlR.Lines.Text
        ,':CondR',CondR)
        ,':UserOrRoleID',FMain.getUserOrRoleID)
        ,':fast_filter',fmain.getWhereFastFilter(self.filter.text, 'ROOMS'))
        ,':order_by',sql_ResCat0NAME)
        ,':forms_filter',forms_filter)
        ,':hours_filter',hours_filter)
        ,':ClassesSelectedTotal',ClassesSelectedTotal.Text)
        ,':minus_reservations',iif(MinusReservations.checked,'minus select day,hour from reservations',''))
    );
    QueryR.Open;
  end;
  if PageControl.ActivePage = TabsheetS       then begin
    dmodule.resetConnection ( QueryS );
    QueryS.SQL.Clear;
    QueryS.SQL.Add('SELECT * FROM SUBJECTS WHERE '+fmain.getWhereFastFilter(self.filter.text, 'SUBJECTS')+' order by name');
    QueryS.Open;
  end;

  if PageControl.ActivePage = TabsheetCounter then begin
    QueryCOUNTER.SQL.Clear;
    groupbyClause := mergeStrings(',',[
         iif(groupByS.Checked,'SUB.NAME ','')
        ,iif(groupByForm.Checked,'FR.NAME','')
        ,iif(groupByDesc1.Checked,'CLA.DESC1','')
        ,iif(groupByDesc2.Checked,'CLA.DESC2','')
        ,iif(groupByDesc3.Checked,'CLA.DESC3','')
        ,iif(groupByDesc4.Checked,'CLA.DESC4','')
        //
        ,iif(groupByL.Checked,'LEC.TITLE||'' ''||LEC.FIRST_NAME||'' ''||LEC.LAST_NAME','')
        ,iif(groupByG.Checked,'GRO.NAME','')
        ,iif(groupByR.Checked,'ROM.NAME','')
        ,iif(groupBylDesc1.Checked,'LEC_CLA.DESC1','')
        ,iif(groupBylDesc2.Checked,'LEC_CLA.DESC2','')
        ,iif(groupBylDesc3.Checked,'LEC_CLA.DESC3','')
        ,iif(groupBylDesc4.Checked,'LEC_CLA.DESC4','')
    ]);
    groupbyClause := nvl(groupbyClause,'null');
    orderByClause := groupbyClause;
    if addRollUp.checked then groupbyClause := 'GROUP BY ROLLUP('+groupbyClause+ ')'
                         else groupbyClause := 'GROUP BY '+groupbyClause;

    QueryCOUNTER.SQL.Add(
    'SELECT '+mergeStrings(',',[
          iif(groupByS.Checked, 'NVL(SUB.NAME,''--'') "Przedmiot" ','')
        , iif(groupByForm.Checked, 'NVL(FR.NAME,''--'') "Forma"','')
        , iif(groupByDesc1.Checked, 'NVL(CLA.DESC1,''--'') "'+fprogramSettings.getClassDescPlural(1)+'"','')
        , iif(groupByDesc2.Checked, 'NVL(CLA.DESC2,''--'') "'+fprogramSettings.getClassDescPlural(2)+'"','')
        , iif(groupByDesc3.Checked, 'NVL(CLA.DESC3,''--'') "'+fprogramSettings.getClassDescPlural(3)+'"','')
        , iif(groupByDesc4.Checked, 'NVL(CLA.DESC4,''--'') "'+fprogramSettings.getClassDescPlural(4)+'"','')
        //
        , iif(groupByL.Checked, 'NVL(LEC.TITLE||'' ''||LEC.FIRST_NAME||'' ''||LEC.LAST_NAME,''--'') "Wyk³adowca"','')
        , iif(groupByG.Checked, 'NVL(GRO.NAME,''--'') "Grupa"','')
        , iif(groupByR.Checked, 'NVL(ROM.NAME,''--'') "Zasób"','')
        //
        , iif(groupByLDesc1.Checked, 'NVL(LEC_CLA.DESC1,''--'') "'+fprogramSettings.getClassDescSingular(1)+'"','')
        , iif(groupByLDesc2.Checked, 'NVL(LEC_CLA.DESC2,''--'') "'+fprogramSettings.getClassDescSingular(2)+'"','')
        , iif(groupByLDesc3.Checked, 'NVL(LEC_CLA.DESC3,''--'') "'+fprogramSettings.getClassDescSingular(3)+'"','')
        , iif(groupByLDesc4.Checked, 'NVL(LEC_CLA.DESC4,''--'') "'+fprogramSettings.getClassDescSingular(4)+'"','')
        //
        ,'SUM (GRIDS.DURATION*FILL/100) "Liczba godzin"'
        ])+
    ' FROM CLASSES  CLA ' + CR +
          ',SUBJECTS SUB ' + CR +
          ',FORMS    FR' + CR +
          ',GRIDS' + CR +
          iif( groupByLDesc1.Checked or groupByLDesc2.Checked or groupByLDesc3.Checked or groupByLDesc4.Checked or groupByL.Checked, ',LEC_CLA, LECTURERS LEC ' + CR,'')+
          iif( groupByG.Checked, ',GRO_CLA, GROUPS GRO ' + CR,'')+
          iif( groupByR.Checked, ',ROM_CLA, ROOMS ROM ' + CR,'')+
    ' WHERE '+ getwhereClause + CR +
      ' AND ('
          + fmain.getWhereFastFilter(self.filter.text, 'SUB')
          + ' or ' + fmain.getWhereFastFilter(self.filter.text, 'FR')
          + iif(groupByLDesc1.Checked or groupByLDesc2.Checked or groupByLDesc3.Checked or groupByLDesc4.Checked  or groupByL.Checked,
              ' or ' + fmain.getWhereFastFilter(self.filter.text, 'LEC')
            + ' or xxmsz_tools.erasePolishChars(upper(LEC_CLA.DESC1)) LIKE '''+replacePolishChars( ansiuppercase(self.filter.text))+'%'''
            + ' or xxmsz_tools.erasePolishChars(upper(LEC_CLA.DESC2)) LIKE '''+replacePolishChars( ansiuppercase(self.filter.text))+'%'''
            + ' or xxmsz_tools.erasePolishChars(upper(LEC_CLA.DESC3)) LIKE '''+replacePolishChars( ansiuppercase(self.filter.text))+'%'''
            + ' or xxmsz_tools.erasePolishChars(upper(LEC_CLA.DESC4)) LIKE '''+replacePolishChars( ansiuppercase(self.filter.text))+'%'''
          , '')
          + iif(groupByG.Checked,
              ' or ' + fmain.getWhereFastFilter(self.filter.text, 'GRO')
          , '')
          + iif(groupByR.Checked,
              ' or ' + fmain.getWhereFastFilter(self.filter.text, 'ROM')
          , '')
      +' ) '+CR+
      iif(groupByLDesc1.Checked or groupByLDesc2.Checked or groupByLDesc3.Checked or groupByLDesc4.Checked  or groupByL.Checked, ' AND LEC_CLA.CLA_ID(+) = CLA.ID AND LEC_CLA.LEC_ID=LEC.ID(+)' + CR,'')+
      iif(groupByG.Checked, ' AND GRO_CLA.CLA_ID(+) = CLA.ID AND GRO_CLA.GRO_ID=GRO.ID(+)' + CR,'')+
      iif(groupByR.Checked, ' AND ROM_CLA.CLA_ID(+) = CLA.ID AND ROM_CLA.ROM_ID=ROM.ID(+)' + CR,'')+
      ' AND SUB.ID(+) = CLA.SUB_ID' + CR +
      ' AND FR.ID = CLA.FOR_ID' + CR +
      ' AND GRIDS.NO = CLA.HOUR' + CR +
    iif( (fmain.TabViewType.TabIndex = 0) and (fmain.BViewByWeek.down), ' and cla.id in (select cla_id from lec_cla where '+getwhereClause+' and lec_id='+ExtractWord(1,Nvl(fmain.ConLecturer.Text,'-1'),[';'])+')','') + CR +
    iif( (fmain.TabViewType.TabIndex = 1) and (fmain.BViewByWeek.down), ' and cla.id in (select cla_id from gro_cla where '+getwhereClause+' and gro_id='+ExtractWord(1,Nvl(fmain.ConGroup.Text,'-1'),[';'])+')','') + CR +
    iif( (fmain.TabViewType.TabIndex = 2) and (fmain.BViewByWeek.down), ' and cla.id in (select cla_id from rom_cla where '+getwhereClause+' and rom_id='+ExtractWord(1,Nvl(fmain.conResCat0.Text,'-1'),[';'])+')','') + CR +
    iif( (fmain.TabViewType.TabIndex = 3) and (fmain.BViewByWeek.down), ' and cla.id in (select cla_id from rom_cla where '+getwhereClause+' and rom_id='+ExtractWord(1,Nvl(fmain.ConResCat1.Text,'-1'),[';'])+')','') + CR +
    iif ( SelectedSubOnly.Checked, iif( not strIsEmpty(fmain.ConSubject.Text),'   AND sub_id = '+fmain.ConSubject.Text+' ','')
                     , 'and 0=0') + CR +
    groupbyClause+ CR +
    'ORDER BY '+orderByClause
    );
    //info('debug mode');
    QueryCOUNTER.Open;
  end;

  if PageControl.ActivePage = TabsheetTimetableNotes  then begin
    SaveTimeTableNotes;
    dmodule.resetConnection ( QueryTimetableNotes );
    dmodule.openSQL(
         QueryTimetableNotes
         ,'select id, per_id, res_id, notes_before, notes_after, internal_notes from timetable_notes where per_id=:per_id and res_id=:res_id' ,
         'per_id='+ fmain.conPeriod.Text+
         ';res_id='+ intToStr(fmain.getCurrentObjectId)
         );
    if QueryTimetableNotes.RecordCount = 0 then begin
      if (fmain.conPeriod.Text<>'') and (fmain.getCurrentObjectId<>1) then begin
        QueryTimetableNotes.Insert;
        QueryTimetableNotes['ID'] := DModule.SingleValue('select main_seq.nextval from dual');
        QueryTimetableNotes['per_id'] := fmain.conPeriod.Text;
        QueryTimetableNotes['res_id'] := intToStr(fmain.getCurrentObjectId);
      end;  
    End;
  end;

  if PageControl.ActivePage = TabsheetR then begin
      if RoomAdvPanel.Visible then begin
        gridR.Columns[1].visible := true;
        gridR.Columns[2].visible := true;
        gridR.Columns[3].visible := true;
        gridR.Columns[4].visible := true;
        gridR.Columns[1].Width := strToInt( getSystemParam('FLegend.gridR.Column1.Width'  ,'56')   );
        gridR.Columns[2].Width := strToInt( getSystemParam('FLegend.gridR.Column2.Width'  ,'56')   );
        gridR.Columns[3].Width := strToInt( getSystemParam('FLegend.gridR.Column3.Width'  ,'64')   );
        gridR.Columns[4].Width := strToInt( getSystemParam('FLegend.gridR.Column4.Width'  ,'64')   );
      end else begin
        gridR.Columns[1].visible := false;
        gridR.Columns[2].visible := false;
        gridR.Columns[3].visible := false;
        gridR.Columns[4].visible := false;
      end;
      gridR.Columns[ 0].Width := strToInt( getSystemParam('FLegend.gridR.Column0.Width'  ,'69')   );
      gridR.Columns[ 5].Width := strToInt( getSystemParam('FLegend.gridR.Column5.Width'  ,'89')   );
      gridR.Columns[ 6].Width := strToInt( getSystemParam('FLegend.gridR.Column6.Width'  ,'49')   );
      gridR.Columns[ 7].Width := strToInt( getSystemParam('FLegend.gridR.Column7.Width'  ,'65')   );
      gridR.Columns[ 8].Width := strToInt( getSystemParam('FLegend.gridR.Column8.Width'  ,'64')   );
      gridR.Columns[ 9].Width := strToInt( getSystemParam('FLegend.gridR.Column9.Width'  ,'63')   );
      gridR.Columns[10].Width := strToInt( getSystemParam('FLegend.gridR.Column10.Width'  ,'63')   );
  end;

  saveFormSettings;
end;

procedure TFLegend.FilterChange(Sender: TObject);
begin
  BRefreshClick(nil);
end;

procedure TFLegend.gridCounterDblClick(Sender: TObject);
begin
copyToclipboard(QueryCOUNTER.SQL.Text);
end;

procedure TFLegend.BOleExportClick(Sender: TObject);
var point : tpoint;
    btn   : tcontrol;
begin
 btn     := sender as tcontrol;
 Point.x := 0;
 Point.y := btn.Height;
 Point   := btn.ClientToScreen(Point);
 ppexport.Popup(Point.X,Point.Y);
end;

{*** @@@!!! Exact copy from FBrowseParent, should be consolidated ***}
Procedure TFLegend.ExportToHtml(aGrid : TDBGrid );
    var FileName : string;
        F : TextFile;
        aQuery : TADOQuery;

    Procedure doExport;
    var LineNumber : Integer;
        LineString : string;
        t : integer;
        index : integer;
        headers : array of String;
        {------------------------------------}
        procedure flush(tag : string);
        var t : integer;
        begin
          Writeln(f, '<tr>');
          for t := 0 to index-1 do begin
              writeLn(f, '<'+tag+'>'+headers[t]+'</'+tag+'>');
          end;
          Writeln(f, '</tr>');
        end;
    begin
          DeleteFile( FileName );

          AssignFile(F, FileName);
          ReWrite(F);

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

              index := 0;
              for t := 0 to agrid.Columns.Count-1 do
                if (aGrid.Columns.Items[t].Visible) and (aGrid.Columns.Items[t].Width>1) then begin
                    inc ( index );
                end;
              setlength(headers, index);

              index := 0;
              for t := 0 to agrid.Columns.Count-1 do
                if (aGrid.Columns.Items[t].Visible) and (aGrid.Columns.Items[t].Width>1) then begin
                    headers[index] := agrid.Columns[t].Title.Caption;
                    inc ( index );
                end;
              flush('th');

              LineNumber := 1;
              aQuery.First;
              While not aQuery.Eof do
              begin
                Inc(lineNumber);

                index := 0;
                for t := 0 to agrid.Columns.Count-1 do
                  if (aGrid.Columns.Items[t].Visible) and (aGrid.Columns.Items[t].Width>1) then begin
                  if aQuery.FieldByName(aGrid.Columns.Items[t].FieldName).IsNull then
                    headers[index] := ''
                  else
                    Case aGrid.Columns.Items[t].Field.DataType of
                      //ftUnknown    : ;
                      ftString     : headers[index] := aQuery.FieldByName(aGrid.Columns.Items[t].FieldName).Value;
                      //ftSmallint   : ;
                      //ftInteger    : ;
                      //ftWord       : ;
                      //ftBoolean    : ;
                      //ftFloat      : ;
                      //ftCurrency   : ;
                      //ftBCD        : ;
                      //ftDate       : ;
                      //ftTime       : ;
                      ftDateTime   : headers[index] := FormatDateTime('yyyy-mm-dd', aQuery.FieldByName(aGrid.Columns.Items[t].FieldName).Value );
                      //ftBytes      : ;
                      //ftVarBytes   : ;
                      //ftAutoInc    : ;
                      //ftBlob       : ;
                      //ftMemo       : ;
                      //ftGraphic    : ;
                      //ftFmtMemo    : ;
                      //ftParadoxOle : ;
                      //ftDBaseOle   : ;
                      //ftTypedBinary: ;
                      //ftCursor     : ;
                      //ftFixedChar  : ;
                      ftWideString : headers[index] := aQuery.FieldByName(aGrid.Columns.Items[t].FieldName).Value;
                      //ftLargeint   : ;
                      //ftADT        : ;
                      //ftArray      : ;
                      //ftReference  : ;
                      //ftDataSet    : ;
                      //ftOraBlob    : ;
                      //ftOraClob    : ;
                      //ftVariant    : ;
                      //ftInterface  : ;
                      //ftIDispatch  : ;
                      //ftGuid       : ;
                      //ftTimeStamp  : ;
                      else headers[index] := aQuery.FieldByName(aGrid.Columns.Items[t].FieldName).Value;
                     End;
                  inc(index);
                  end;

                LineString := IntToStr(LineNumber);
                flush('td');
                aQuery.Next;
              end;
              LineString := IntToStr(LineNumber);

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

     Writeln(f, '</BODY></HTML>');
     CloseFile(F);

     ExecuteFile(FileName,'','',SW_SHOWMAXIMIZED);
    end;

Begin
 FProgramSettings.generateJsFiles;
 FileName:= uutilityParent.ApplicationDocumentsPath + '\temp.html';
 aQuery  := TADOQuery( aGrid.DataSource.DataSet );

 If Not aQuery.Active Then Begin
  Exit;
 End;

 aQuery.DisableControls;
 doExport;
 aQuery.EnableControls;
End;

procedure TFLegend.ExportEasyClick(Sender: TObject);
var aGrid : TDBGrid;
begin
 if not elementEnabled('"Prosty eksport do Excela"','2015.08.06', false) then exit;
 if PageControl.ActivePage = TabsheetCounter then aGrid := gridCounter;
 if PageControl.ActivePage = TabsheetL then aGrid := gridL;
 if PageControl.ActivePage = TabsheetG then aGrid := gridG;
 if PageControl.ActivePage = TabsheetR then aGrid := gridR;
 if PageControl.ActivePage = TabsheetS then aGrid := gridS;
 dmodule.ExportToExcel(aGrid);
end;

procedure TFLegend.ExportHtmlClick(Sender: TObject);
var aGrid : TDBGrid;
begin
 if not elementEnabled('"Prosty eksport do Excela"','2015.08.06', false) then exit;
 if PageControl.ActivePage = TabsheetCounter then aGrid := gridCounter;
 if PageControl.ActivePage = TabsheetL then aGrid := gridL;
 if PageControl.ActivePage = TabsheetG then aGrid := gridG;
 if PageControl.ActivePage = TabsheetR then aGrid := gridR;
 if PageControl.ActivePage = TabsheetS then aGrid := gridS;
 ExportToHTML(aGrid);
end;

procedure TFLegend.RMoreClick(Sender: TObject);
var i :  integer;
    savedValues: string;
begin
  RoomAdvPanel.Visible := true;
  RMore.Visible := false;

  dmodule.OpenSQL('select abbreviation,id from forms where id in (select for_id from for_pla where pla_id='+fmain.getUserOrRoleID+') order by 1');
  SetLength(FormsListIds, dmodule.QWork.RecordCount);
  FormsList.Items.Clear;
  i :=0;
  with dmodule.QWork do begin
    first;
    while not eof do begin
      FormsList.AddItem(fieldByName('abbreviation').AsString,nil);
      FormsListIds[i] := fieldByName('id').AsString;
      next;
      i := i + 1;
    end;
  end;

  for i := 0 to FormsList.Items.Count-1 Do
    FormsList.Checked[i] := true;

  savedValues := getSystemParam('FLegend.formsList.checked');
  if length(savedValues)=formslist.Items.Count then
    checkListBoxToBool(formslist,savedValues);

  dmodule.OpenSQL('select caption,no from grids order by 2');
  SetLength(HoursListIds, dmodule.QWork.RecordCount);
  HoursList.Items.Clear;
  i :=0;
  with dmodule.QWork do begin
    first;
    while not eof do begin
      HoursList.AddItem(fieldByName('caption').AsString,nil);
      HoursListIds[i] := fieldByName('no').AsString;
      next;
      i := i + 1;
    end;
  end;

  for i := 0 to HoursList.Items.Count-1 Do
    HoursList.Checked[i] := true;

  savedValues := getSystemParam('FLegend.hoursList.checked');
  if length(savedValues)=hoursList.Items.Count then
    checkListBoxToBool(hoursList,savedValues);

  BRefreshClick(nil);
end;

procedure TFLegend.SpeedButton3Click(Sender: TObject);
begin
  RoomAdvPanel.Visible := false;
  RMore.Visible := true;
  BRefreshClick(nil);
end;

procedure TFLegend.getFilters(var forms_filter : string; var hours_filter : string);
var FormIds : string;
    HourIds : string;
    i : integer;
    allFormsChecked : boolean;
    allHoursChecked : boolean;
    noFormsChecked : boolean;
    noHoursChecked : boolean;
begin
 FormIds := '';
 allFormsChecked := true;
 noFormsChecked := true;
 for i := 0 to FormsList.items.Count-1 do begin
   if FormsList.Checked[i]
     then begin
       FormIds := merge(FormIds,FormsListIds[i],',');
       noFormsChecked := false;
     end
     else allFormsChecked := false;
 end;

 HourIds := '';
 allHoursChecked := true;
 noHoursChecked := true;
 for i := 0 to HoursList.items.Count-1 do begin
   if HoursList.Checked[i]
     then begin
       HourIds := merge(HourIds,HoursListIds[i],',');
       noHoursChecked := false;
     end
     else allHoursChecked := false;
 end;

 if (allFormsChecked) or (noFormsChecked) or(not RoomAdvPanel.visible)
 then forms_filter := '0=0'
 else  forms_filter :=  'for_id in ('+FormIds+')';

 if (allHoursChecked) or (noHoursChecked)or(not RoomAdvPanel.visible)
 then hours_filter := '0=0'
 else  hours_filter :=  'hour in ('+HourIds+')';

end;

procedure TFLegend.SpeedButton4Click(Sender: TObject);
var i : integer;
begin
  for i := 0 to FormsList.Items.Count-1 Do
    FormsList.Checked[i] := true;
end;

procedure TFLegend.SpeedButton5Click(Sender: TObject);
var i : integer;
begin
  for i := 0 to FormsList.Items.Count-1 Do
    FormsList.Checked[i] := false;
end;

procedure TFLegend.SpeedButton6Click(Sender: TObject);
var i : integer;
begin
  for i := 0 to HoursList.Items.Count-1 Do
    HoursList.Checked[i] := true;
end;

procedure TFLegend.SpeedButton7Click(Sender: TObject);
var i : integer;
begin
  for i := 0 to HoursList.Items.Count-1 Do
    HoursList.Checked[i] := false;
end;

procedure TFLegend.HoursListClick(Sender: TObject);
begin
  BRefreshClick(nil);
end;

procedure TFLegend.FormsListClick(Sender: TObject);
begin
  BRefreshClick(nil);
end;

procedure TFLegend.MinusReservationsClick(Sender: TObject);
begin
  BRefreshClick(nil);
end;

procedure TFLegend.GRIDRMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if RoomAdvPanel.Visible then begin
    setSystemParam('FLegend.gridR.Column1.Width',intToStr(gridR.Columns[1].Width));
    setSystemParam('FLegend.gridR.Column2.Width',intToStr(gridR.Columns[2].Width));
    setSystemParam('FLegend.gridR.Column3.Width',intToStr(gridR.Columns[3].Width));
    setSystemParam('FLegend.gridR.Column4.Width',intToStr(gridR.Columns[4].Width));
  end;
  setSystemParam('FLegend.gridR.Column0.Width',intToStr(gridR.Columns[0].Width));
  setSystemParam('FLegend.gridR.Column5.Width',intToStr(gridR.Columns[5].Width));
  setSystemParam('FLegend.gridR.Column6.Width',intToStr(gridR.Columns[6].Width));
  setSystemParam('FLegend.gridR.Column7.Width',intToStr(gridR.Columns[7].Width));
  setSystemParam('FLegend.gridR.Column8.Width',intToStr(gridR.Columns[8].Width));
  setSystemParam('FLegend.gridR.Column9.Width',intToStr(gridR.Columns[9].Width));
  setSystemParam('FLegend.gridR.Column10.Width',intToStr(gridR.Columns[10].Width));
end;

Procedure TFLegend.SaveTimeTableNotes;
begin
 if dm.dmodule.ADOConnection.Connected then
    If (QueryTimetableNotes.State = dsEdit) Or (QueryTimetableNotes.State = dsInsert) Then QueryTimetableNotes.Post;
end;

procedure TFLegend.SpeedButton8Click(Sender: TObject);
begin
  If (QueryTimetableNotes.State = dsEdit) Or (QueryTimetableNotes.State = dsInsert) Then
    QueryTimetableNotes.Cancel;
end;

procedure TFLegend.BEditorClick(Sender: TObject);
begin

  info(
'Twórz profesjonalnie wygl¹daj¹ce nag³ówki i stopki za pomoc¹ prostego edytora tekstu, który zaraz zostanie uruchomiony.'+cr+
'Edytor sk³ada siê z dwóch okien: lewego i prawego.'+cr+
'W lewym oknie utwórz nag³ówek (stopkê).'+cr+
'Zawartoœæ prawego okna skopiuj do pola w aplikacji Plansoft.org.'+cr+
'To wszystko, powodzenia!',showMonthly);

ExecuteFile('http://html-online.com/editor/','','',SW_SHOWMAXIMIZED);
end;

procedure TFLegend.SpeedButton9Click(Sender: TObject);
begin
  FMain.Ustawieniaprogramu1Click(nil);
end;

end.
