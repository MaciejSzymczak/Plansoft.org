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
    BSelectROL_ID: TBitBtn;
    BClearROL_ID: TBitBtn;
    ChLokedFlag: TDBCheckBox;
    procedure BUsunClick(Sender: TObject);
    procedure BUsunAllClick(Sender: TObject);
    procedure ROL_IDChange(Sender: TObject);
    procedure BSelectROL_IDClick(Sender: TObject);
    procedure BClearROL_IDClick(Sender: TObject);
    procedure ROL_ID_VALUEDblClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BUpdChild1Click(Sender: TObject);
  private
    { Private declarations }
  public
    Function  CheckRecord : Boolean;       override;
    Procedure DefaultValues;               override;
    Function  CanEditPermission : Boolean; override;
    Function  CanDelete    : Boolean;      override;
    Function  getSearchFilter : string;  override;
    function  getFindCaption : string;   override;
  end;

var
  FBrowsePERIODS: TFBrowsePERIODS;

implementation

uses DM, UUtilityParent, UUtilities, UFProgramSettings, AutoCreate, UFMain;

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
 If (not UUtilities.isOwnerSupervisor(Query.FieldByName('CREATED_BY').AsString)) and (Query.FieldByName('CREATED_BY').AsString<>currentUserName) Then Begin
  Info('Rekord mo¿e modyfikowaæ tylko u¿ytkownik, który utworzy³ rekord:'+Query.FieldByName('CREATED_BY').AsString);
  result := false;
 End;
end;

Function  TFBrowsePERIODS.CanDelete    : Boolean;
begin
 result := true;
 If (not UUtilities.IsOwner(Query.FieldByName('CREATED_BY').AsString)) Then Begin
  Info('Rekord mo¿e modyfikowaæ tylko u¿ytkownik, który utworzy³ rekord');
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

procedure TFBrowsePERIODS.BSelectROL_IDClick(Sender: TObject);
Var ID : ShortString;
begin
  ID := ROL_ID.Text;
  If LookupWindow(false, DModule.ADOConnection, 'PLANNERS','','NAME','NAZWA','NAME','(TYPE=''ROLE'' AND ID IN (SELECT ROL_ID FROM ROL_PLA WHERE PLA_ID = '+UserID+'))','',ID) = mrOK Then
    Query.FieldByName('ROL_ID').AsString := ID;
end;

procedure TFBrowsePERIODS.BClearROL_IDClick(Sender: TObject);
begin
 Query.FieldByName('ROL_ID').Clear;
end;

procedure TFBrowsePERIODS.ROL_ID_VALUEDblClick(Sender: TObject);
begin
  BSelectROL_IDClick(nil);
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
 result := '(xxmsz_tools.erasePolishChars(upper(periods.created_by||periods.name||periods.desc1||periods.desc2||periods.attribs_01||periods.attribs_02||periods.attribs_03||periods.attribs_04||periods.attribs_05||periods.attribs_06||periods.attribs_07'+
           '||periods.attribs_08||periods.attribs_09||periods.attribs_10||periods.attribs_11||periods.attribs_12||periods.attribs_13||periods.attribs_14||periods.attribs_15)) like ''%'+replacePolishChars( ansiuppercase(trim(ESearch.Text)) )+'%'')';
end;

function TFBrowsePERIODS.getFindCaption: string;
begin
 Result := 'Dowolna fraza';
end;

end.
