unit uFBrowsePERIODS;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UFBrowseParent, ExtCtrls, StrHlder, Menus, Db, DBTables, RxQuery,
  ComCtrls, Grids, DBGrids, RXDBCtrl, StdCtrls, Buttons, ToolEdit, Mask,
  DBCtrls, ufLookupWindow, ImgList, ADODB, OleServer, ExcelXP;

type
  TFBrowsePERIODS = class(TFBrowseParent)
    ID: TDBEdit;
    LabelID: TLabel;
    NAME: TDBEdit;
    LabelNAME: TLabel;
    DATE_FROM: TDBDateEdit;
    LabelDATE_FROM: TLabel;
    DATE_TO: TDBDateEdit;
    LabelDATE_TO: TLabel;
    GroupBox1: TGroupBox;
    SHOW_MON: TDBCheckBox;
    SHOW_TUE: TDBCheckBox;
    SHOW_WED: TDBCheckBox;
    SHOW_THU: TDBCheckBox;
    SHOW_FRI: TDBCheckBox;
    SHOW_SAT: TDBCheckBox;
    SHOW_SUN: TDBCheckBox;
    Label2: TLabel;
    HOURS_PER_DAY: TDBEdit;
    LabelROL_ID: TLabel;
    ROL_ID: TDBEdit;
    ROL_ID_VALUE: TEdit;
    BClearROL_ID: TBitBtn;
    ChLokedFlag: TDBCheckBox;
    HIDE_ROWS: TDBEdit;
    HIDE_ROWS_BTN: TSpeedButton;
    Label1: TLabel;
    SpeedButton4: TSpeedButton;
    Label3: TLabel;
    GRID_LABELS: TDBEdit;
    FHelp: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Label4: TLabel;
    PER_ORGUNI_ID: TDBEdit;
    PER_ORGUNI_ID_VALUE: TEdit;
    Label5: TLabel;
    WEEK_VISIBILITY: TDBEdit;
    WEEK_VISIBILITY_BTN: TSpeedButton;
    LabelPARENT_PER_ID: TLabel;
    PARENT_PER_ID: TDBEdit;
    PARENT_PER_ID_VALUE: TEdit;
    BClearPARENT_PER_ID: TBitBtn;
    SpeedButton5: TSpeedButton;
    procedure BUsunClick(Sender: TObject);
    procedure BUsunAllClick(Sender: TObject);
    procedure ROL_IDChange(Sender: TObject);
    procedure BClearROL_IDClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BUpdChild1Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure FHelpClick(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure BUpdChild2Click(Sender: TObject);
    procedure BUpdChild3Click(Sender: TObject);
    procedure PER_ORGUNI_IDChange(Sender: TObject);
    procedure PER_ORGUNI_ID_VALUEClick(Sender: TObject);
    procedure ROL_ID_VALUEClick(Sender: TObject);
    procedure ChLokedFlagClick(Sender: TObject);
    procedure WEEK_VISIBILITY_BTNClick(Sender: TObject);
    procedure HIDE_ROWS_BTNClick(Sender: TObject);
    procedure PARENT_PER_IDChange(Sender: TObject);
    procedure PARENT_PER_ID_VALUEClick(Sender: TObject);
    procedure BClearPARENT_PER_IDClick(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
  private
    ParentPerIdChanged : Boolean;
  public
    Procedure GetTableName;  override;
    Function  CheckRecord : Boolean;       override;
    Procedure DefaultValues;               override;
    Procedure CustomConditions;      override;
    Procedure AfterPost;             override;
    Function  CanEditPermission : Boolean; override;
    Function  IsRecordReadOnly : Boolean;   override;
    Function  CanDelete    : Boolean;      override;
    Function  CanDeleteRecord    : Boolean;      override;
    Function  getSearchFilter : string;  override;
    function  getFindCaption : string;   override;
  end;

var
  FBrowsePERIODS: TFBrowsePERIODS;

implementation

uses DM, UUtilityParent, UUtilities, UFProgramSettings, AutoCreate, UFMain,
  UFFloatingMessage, UCommon, UFSharing, UFWeekVisibility, UFHideRows;

{$R *.DFM}

Function  TFBrowsePERIODS.CheckRecord : Boolean;
Begin
  With UUtilityParent.CheckValid Do Begin
    Init(Self);
    RestrictEmpty([NAME, DATE_FROM, DATE_TO]);

    if DATE_FROM.Date >= DATE_TO.Date  then addError('Data rozpoczêcia musi byæ mniejsza od daty zakoñczenia');

    Try
      StrToInt(HOURS_PER_DAY.Text);
    Except
     addError(HOURS_PER_DAY.HINT+' musi byæ liczb¹');
    End;

    If Not ((SHOW_MON.Checked) Or  (SHOW_TUE.Checked) Or (SHOW_WED.Checked)  Or (SHOW_THU.Checked)  Or (SHOW_FRI.Checked)  Or (SHOW_SAT.Checked) Or (SHOW_SUN.Checked)) Then
    addError('Okres musi zawieraæ przynajmniej jeden dzieñ');

    If (WEEK_VISIBILITY.Text <> '') and (Pos('+', WEEK_VISIBILITY.Text) = 0) Then
    addError('Widocznoœæ tygodni musi zawieraæ przynajmniej jeden widoczny tydzieñ (znak +)');

    Result := ShowMessage;
  End;
End;

Procedure TFBrowsePERIODS.DefaultValues;
Begin
 Query['ID'] := DModule.SingleValue('select main_seq.nextval from dual');
 //Query['HOURS_PER_DAY'] := '8';
 Query['SHOW_MON']    := '+';
 Query['SHOW_TUE']    := '+';
 Query['SHOW_WED']    := '+';
 Query['SHOW_THU']    := '+';
 Query['SHOW_FRI']    := '+';
 Query['SHOW_SAT']    := '+';
 Query['SHOW_SUN']    := '+';
 Query['LOCKED_FLAG'] := '-';
 Query['CREATED_BY'] := dm.UserName;
End;

Function  TFBrowsePERIODS.CanEditPermission : Boolean;
begin
 result := true;
 //If (not UUtilities.isOwnerSupervisor(Query.FieldByName('CREATED_BY').AsString)) and (Query.FieldByName('CREATED_BY').AsString<>currentUserName) Then Begin
 // Info('Rekord mo¿e modyfikowaæ tylko u¿ytkownik, który utworzy³ rekord:'+Query.FieldByName('CREATED_BY').AsString);
 // result := false;
 //End;
end;

function TFBrowsePERIODS.IsRecordReadOnly: Boolean;
begin
 result := isReadOnlyAccess('PERIODS', TFBrowseParent(Self).ID);
end;

Function  TFBrowsePERIODS.CanDelete    : Boolean;
begin
 result := isBlank(confineCalendarId) and isIntegrated=false;
end;

Function  TFBrowsePERIODS.CanDeleteRecord    : Boolean;
begin
 result := true;
 //ownership/supervisor restriction removed 2026.07.16 - Access_Type (per_pla) is now the sole gate, see IsRecordReadOnly
end;


procedure TFBrowsePERIODS.BUsunClick(Sender: TObject);
begin
  inherited;
  DeleteOrphanedClasses;
end;

procedure TFBrowsePERIODS.BUsunAllClick(Sender: TObject);
begin
Exit;
  inherited;
end;

procedure TFBrowsePERIODS.ROL_IDChange(Sender: TObject);
begin
  DModule.RefreshLookupEdit(Self, TControl(Sender).Name,'NAME','PLANNERS','');
end;

procedure TFBrowsePERIODS.BClearROL_IDClick(Sender: TObject);
begin
 Query.FieldByName('ROL_ID').Clear;
end;

procedure TFBrowsePERIODS.FormShow(Sender: TObject);
begin
  inherited;
  self.Caption := fprogramsettings.profileObjectNamePeriods.Text;
end;

procedure TFBrowsePERIODS.BUpdChild1Click(Sender: TObject);
begin
  AutoCreate.FIN_PARTIESShowModalAsBrowser( 'PLANSOFT:' + Query.fieldByName('ID').AsString );
end;

function TFBrowsePERIODS.getSearchFilter: string;
begin
 result := buildFilter(sql_PER_SEARCH, ESearch.Text);
end;

function TFBrowsePERIODS.getFindCaption: string;
begin
 Result := 'Dowolna fraza';
end;

Procedure TFBrowsePERIODS.GetTableName;
Begin
  Self.TableName := 'PERIODS';
End;


procedure TFBrowsePERIODS.SpeedButton4Click(Sender: TObject);
begin
 //FFloatingMessage.showModal
 SError('Ukrywanie zbêdnych wierszy, np. gdy korzystamy z siatki piêtnastominutowej to ci¹g znaków +--- oznacza, ¿e pelne godziny s¹ pokazywane, a pozostale s¹ ukrywane. Znak "-" oznacza ukrycie');
end;

procedure TFBrowsePERIODS.FHelpClick(Sender: TObject);
begin
  SError('Zalecany sposób nazywania okresów:'+cr+' Kod wydzia³u + rodzaj studiów + okres'+cr+' np. WEL_STAC_2030Z');
end;

procedure TFBrowsePERIODS.SpeedButton2Click(Sender: TObject);
begin
  SError('Zaleca siê, aby autoryzacja mia³a dok³adnie tak¹ sam¹ nazwê co okres.'+cr+
''+cr+
'W oknie "Planiœci/Autoryzacje" utwórz autoryzacjê.'+cr+
'W oknie Uprawnienia wska¿, które zasoby bêd¹ widoczne po wybraniu autoryzacji.'+cr+
'Równie¿ w oknie Uprawnienia wska¿, którzy planiœci bêd¹ te autoryzacje widzieli.');

end;

procedure TFBrowsePERIODS.CustomConditions;
begin
  inherited;
 DM.macros.setMacro( Query, 'CONPERMISSIONS', getWhereClause(tableName));
end;

procedure TFBrowsePERIODS.BUpdChild2Click(Sender: TObject);
begin
   FSharing.init('U','PER',ID.Text, QUERY.FieldByName('NAME').AsString);
   dmodule.CommitTrans;
end;

procedure TFBrowsePERIODS.BUpdChild3Click(Sender: TObject);
begin
  if question('Czy utworzyæ tygodniowe okresy dla bie¿¹cego okresu?') = id_yes then begin
    Dmodule.QWork.ParamCheck := false;
    DModule.SQL(searchAndReplace(searchAndReplace(FMain.SQLCreateWeeks.Text, ':pid',ID.Text), ':plaid',FMain.getUserOrRoleID));
    info('Zrobione. Aby zobaczyæ tygodnie, uruchom funkcje Uprawnienia i nadaj sobie uprawnienia');
  end;
end;

procedure TFBrowsePERIODS.AfterPost;
begin
 If CurrOperation in [AInsert,ACopy] Then begin
    FSharing.init('I','PER',ID.Text, QUERY.FieldByName('NAME').AsString);
    dmodule.CommitTrans;
 end;
 If ParentPerIdChanged Then begin
    DModule.SQL('INSERT INTO Waiting_tasks (id, code, per_id) VALUES (MAIN_SEQ.nextval, ''CLONE_HOLIDAYS_TO_CHILDS'', '+Query.FieldByName('PARENT_PER_ID').AsString+')');
    ParentPerIdChanged := False;
 end;
end;

procedure TFBrowsePERIODS.PER_ORGUNI_IDChange(Sender: TObject);
begin
    DModule.RefreshLookupEdit(Self, TControl(Sender).Name,'NAME','ORG_UNITS','');
end;

procedure TFBrowsePERIODS.PER_ORGUNI_ID_VALUEClick(Sender: TObject);
Var ID : ShortString;
begin
  ID := PER_ORGUNI_ID.Text;
  //If AutoCreate.ORG_UNITSShowModalAsSelect(ID) = mrOK Then Query.FieldByName('ORGUNI_ID').AsString := ID;
  If LookupWindow(false, DModule.ADOConnection, 'ORG_UNITS','','SUBSTR(NAME ||'' (''||STRUCT_CODE||'')'',1,63)','NAZWA I KOD STRUKTURY','NAME','0=0','',ID) = mrOK Then Query.FieldByName('PER_ORGUNI_ID').AsString := ID;
end;

procedure TFBrowsePERIODS.PARENT_PER_IDChange(Sender: TObject);
begin
    DModule.RefreshLookupEdit(Self, TControl(Sender).Name,'NAME','PERIODS','');
end;

procedure TFBrowsePERIODS.PARENT_PER_ID_VALUEClick(Sender: TObject);
Var ID : ShortString;
    Filter : String;
begin
  ID := PARENT_PER_ID.Text;
  if Self.ID.Text <> '' then Filter := 'ID<>'+Self.ID.Text else Filter := '0=0';
  If LookupWindow(false, DModule.ADOConnection, 'PERIODS','','NAME','NAZWA OKRESU','NAME',Filter,'',ID) = mrOK Then begin
    Query.FieldByName('PARENT_PER_ID').AsString := ID;
    ParentPerIdChanged := True;
  end;
end;

procedure TFBrowsePERIODS.BClearPARENT_PER_IDClick(Sender: TObject);
begin
 Query.FieldByName('PARENT_PER_ID').Clear;
end;

procedure TFBrowsePERIODS.SpeedButton5Click(Sender: TObject);
begin
  SError('Wybierz okres nadrzêdny, je¿eli chcesz aby dni wolne (ka¿da zmiana) automatycznie kopiowa³y siê z wybranego okresu nadrzêdnego. Zmiany s¹ aktualizowane z 5min opóŸnieniem.');
end;

procedure TFBrowsePERIODS.ROL_ID_VALUEClick(Sender: TObject);
Var ID : ShortString;
begin
  ID := ROL_ID.Text;
  If LookupWindow(false, DModule.ADOConnection, 'PLANNERS','','NAME','NAZWA','NAME','(TYPE=''ROLE'' AND ID IN (SELECT ROL_ID FROM ROL_PLA WHERE PLA_ID = '+UserID+'))','',ID) = mrOK Then
    Query.FieldByName('ROL_ID').AsString := ID;
end;

procedure TFBrowsePERIODS.ChLokedFlagClick(Sender: TObject);
begin
  inherited;
 if isAdmin = true and ChLokedFlag.Checked then begin
   ChLokedFlag.Checked := false;
   info('Ta funkcja jest dostêpna tylko dla administratora systemu');
 end;
end;

procedure TFBrowsePERIODS.WEEK_VISIBILITY_BTNClick(Sender: TObject);
Var s : String;
begin
  s := WEEK_VISIBILITY.Text;
  if FWeekVisibility = nil then Application.CreateForm(TFWeekVisibility, FWeekVisibility);
  if FWeekVisibility.ShowModalWithDefaults(DATE_FROM.Date, DATE_TO.Date, s) = mrOk then begin
    if not (Query.State in [dsEdit, dsInsert]) then Query.Edit;
    Query.FieldByName('ATTRIBS_13').AsString := s;
  end;
end;

procedure TFBrowsePERIODS.HIDE_ROWS_BTNClick(Sender: TObject);
Var s : String;
begin
  s := HIDE_ROWS.Text;
  if FHideRows = nil then Application.CreateForm(TFHideRows, FHideRows);
  if FHideRows.ShowModalWithDefaults(StrToIntDef(HOURS_PER_DAY.Text, dm.maxHours), s) = mrOk then begin
    if not (Query.State in [dsEdit, dsInsert]) then Query.Edit;
    Query.FieldByName('ATTRIBS_15').AsString := s;
  end;
end;

end.
