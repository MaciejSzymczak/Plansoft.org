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
    Label1: TLabel;
    SpeedButton4: TSpeedButton;
    Label3: TLabel;
    GRID_LABELS: TDBEdit;
    FHelp: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Label4: TLabel;
    PER_ORGUNI_ID: TDBEdit;
    PER_ORGUNI_ID_VALUE: TEdit;
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
    procedure PER_ORGUNI_IDChange(Sender: TObject);
    procedure PER_ORGUNI_ID_VALUEClick(Sender: TObject);
    procedure ROL_ID_VALUEClick(Sender: TObject);
  private
    { Private declarations }
  public
    Procedure GetTableName;  override;
    Function  CheckRecord : Boolean;       override;
    Procedure DefaultValues;               override;
    Procedure CustomConditions;      override;
    Procedure AfterPost;             override;
    Function  CanEditPermission : Boolean; override;
    Function  CanDelete    : Boolean;      override;
    Function  CanDeleteRecord    : Boolean;      override;
    Function  getSearchFilter : string;  override;
    function  getFindCaption : string;   override;
  end;

var
  FBrowsePERIODS: TFBrowsePERIODS;

implementation

uses DM, UUtilityParent, UUtilities, UFProgramSettings, AutoCreate, UFMain,
  UFFloatingMessage, UCommon, UFSharing;

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
    addError('Semestr musi zawieraæ przynajmniej jeden dzieñ');

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
 Query['CREATED_BY'] := CurrentUserName;
End;

Function  TFBrowsePERIODS.CanEditPermission : Boolean;
begin
 result := true;
 //If (not UUtilities.isOwnerSupervisor(Query.FieldByName('CREATED_BY').AsString)) and (Query.FieldByName('CREATED_BY').AsString<>currentUserName) Then Begin
 // Info('Rekord mo¿e modyfikowaæ tylko u¿ytkownik, który utworzy³ rekord:'+Query.FieldByName('CREATED_BY').AsString);
 // result := false;
 //End;
end;

Function  TFBrowsePERIODS.CanDelete    : Boolean;
begin
 result := isBlank(confineCalendarId) and isIntegrated=false;
end;

Function  TFBrowsePERIODS.CanDeleteRecord    : Boolean;
begin
 result := true;
 if not Query.Active then exit;
 If (not UUtilities.isOwnerSupervisor(Query.FieldByName('CREATED_BY').AsString)) and (Query.FieldByName('CREATED_BY').AsString<>currentUserName) Then Begin
  //Info('Rekord mo¿e skasowaæ tylko u¿ytkownik, który utworzy³ rekord');
  result := false;
 End;
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
  SError('Zalecany sposób nazywania semestrów:'+cr+' Kod wydzia³u + rodzaj studiów + okres'+cr+' np. WEL_STAC_2030Z');
end;

procedure TFBrowsePERIODS.SpeedButton2Click(Sender: TObject);
begin
  SError('Zaleca siê, aby autoryzacja mia³a dok³adnie tak¹ sam¹ nazwê co semestr.'+cr+
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

procedure TFBrowsePERIODS.AfterPost;
begin
 If CurrOperation in [AInsert,ACopy] Then begin
    FSharing.init('I','PER',ID.Text, QUERY.FieldByName('NAME').AsString);
    dmodule.CommitTrans;
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

procedure TFBrowsePERIODS.ROL_ID_VALUEClick(Sender: TObject);
Var ID : ShortString;
begin
  ID := ROL_ID.Text;
  If LookupWindow(false, DModule.ADOConnection, 'PLANNERS','','NAME','NAZWA','NAME','(TYPE=''ROLE'' AND ID IN (SELECT ROL_ID FROM ROL_PLA WHERE PLA_ID = '+UserID+'))','',ID) = mrOK Then
    Query.FieldByName('ROL_ID').AsString := ID;
end;

end.
