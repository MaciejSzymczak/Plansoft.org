unit UFBrowseLECTURERS;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UFBrowseParent, ExtCtrls, StrHlder, Menus, Db, DBTables, RxQuery,
  ComCtrls, Grids, DBGrids, RXDBCtrl, StdCtrls, Buttons, Mask, DBCtrls, Ucommon,
  UFlex, ToolEdit, ImgList, ADODB, OleServer, ExcelXP;

type
  TFBrowseLECTURERS = class(TFBrowseParent)
    ID_: TDBEdit;
    LabelID: TLabel;
    TITLE: TDBEdit;
    LabelTITLE: TLabel;
    ABBREVIATION: TDBEdit;
    LabelABBREVIATION: TLabel;
    FIRST_NAME: TDBEdit;
    LabelFIRST_NAME: TLabel;
    LAST_NAME: TDBEdit;
    LabelLAST_NAME: TLabel;
    LabelCOLOUR: TLabel;
    Shape1: TShape;
    ColorDialog: TColorDialog;
    Label2: TLabel;
    Label3: TLabel;
    DESC1: TDBEdit;
    DESC2: TDBEdit;
    Label4: TLabel;
    Label5: TLabel;
    CON_ORGUNI_ID: TEdit;
    CON_ORGUNI_ID_VALUE: TEdit;
    BSelOU: TBitBtn;
    BitBtn6: TBitBtn;
    LabelORGUNI_ID: TLabel;
    ORGUNI_ID: TDBEdit;
    ORGUNI_ID_VALUE: TEdit;
    BSelectORGUNI_ID: TBitBtn;
    BKonsolidate: TBitBtn;
    DSParents: TDataSource;
    TimerDetails: TTimer;
    DSDetails: TDataSource;
    Splitter1: TSplitter;
    RightPage: TPageControl;
    Hierarchy: TTabSheet;
    rightPane: TPanel;
    Splitter2: TSplitter;
    pparents: TPanel;
    PanelDetails: TPanel;
    Panel4: TPanel;
    AddParent: TBitBtn;
    DelParent: TBitBtn;
    GParents: TRxDBGrid;
    pdetails: TPanel;
    PanelORDERS: TPanel;
    Panel3: TPanel;
    AddDetail: TBitBtn;
    delDetail: TBitBtn;
    GDetails: TRxDBGrid;
    Panel5: TPanel;
    Label6: TLabel;
    str_name_lov: TComboBox;
    QParents: TADOQuery;
    QDetails: TADOQuery;
    ttEnabled: TCheckBox;
    BMassImport: TBitBtn;
    EMAIL: TDBEdit;
    LEmail: TLabel;
    LabelROL_ID: TLabel;
    ROL_ID: TDBEdit;
    ROL_ID_VALUE: TEdit;
    AvailableDsp: TLabel;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    procedure GridDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure Shape1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure QueryBeforeEdit(DataSet: TDataSet);
    procedure ORGUNI_IDChange(Sender: TObject);
    procedure BSelectORGUNI_IDClick(Sender: TObject);
    procedure CON_ORGUNI_IDChange(Sender: TObject);
    procedure BSelOUClick(Sender: TObject);
    procedure BitBtn6Click(Sender: TObject);
    procedure BKonsolidateClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure QueryAfterScroll(DataSet: TDataSet);
    procedure TimerDetailsTimer(Sender: TObject);
    procedure AddParentClick(Sender: TObject);
    procedure AddDetailClick(Sender: TObject);
    procedure DelParentClick(Sender: TObject);
    procedure delDetailClick(Sender: TObject);
    procedure str_name_lovChange(Sender: TObject);
    procedure RightPageMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure BUpdChild1Click(Sender: TObject);
    procedure ttEnabledClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BMassImportClick(Sender: TObject);
    procedure BUpdChild2Click(Sender: TObject);
    procedure ORGUNI_ID_VALUEClick(Sender: TObject);
    procedure CON_ORGUNI_ID_VALUEClick(Sender: TObject);
    procedure BUpdChild3Click(Sender: TObject);
    procedure ROL_IDChange(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
  private
    Counter  : Integer;
    procedure refreshDetails;
    procedure insert_str_elem(parent : boolean);
    procedure delete_str_elem(parent : boolean);
    function  getStrNameLov : shortString;
  public
    available: string;
    Function  CheckRecord : Boolean; override;
    Procedure DefaultValues;         override;
    Procedure CustomConditions;      override;
    Procedure AfterPost;             override;
    Procedure deleteClick;           override;
    Procedure AddClick;              override;
    Function  getSearchFilter : string;  override;
    function  getFindCaption : string;   override;

   Function  canEditPermission : Boolean;   override;
   Function  canInsert    : Boolean;        override;
   Function  canDelete    : Boolean;        override;

  end;

var
  FBrowseLECTURERS: TFBrowseLECTURERS;

implementation

uses DM, UUtilityParent, UFMain, AutoCreate, ufLookupWindow,
  UFProgramSettings, UFMassImport, UFSharing, UFExclusiveParent;

{$R *.DFM}

Function  TFBrowseLECTURERS.CheckRecord : Boolean;
Begin
  Result := CheckValid.ReducRestrictEmpty(Self, [ABBREVIATION, TITLE, FIRST_NAME, LAST_NAME, ORGUNI_ID]);
End;

Procedure TFBrowseLECTURERS.DefaultValues;
Var c : Integer;
Begin
 Query['ID'] := DModule.SingleValue('select main_seq.nextval from dual');
 if CON_ORGUNI_ID.Text <> '' then
   Query['ORGUNI_ID'] := CON_ORGUNI_ID.Text;
 c := getRandomColor;
 QUERY['COLOUR'] := c;
 Shape1.Brush.Color := c;
End;

procedure TFBrowseLECTURERS.GridDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
  inherited;
 If Column.FieldName = 'COLOUR' Then
  Begin
   Grid.Canvas.Brush.Color := QUERY.FieldByName('COLOUR').AsInteger;
   Grid.Canvas.FillRect(Rect);
  End;
end;

procedure TFBrowseLECTURERS.Shape1MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
 ColorDialog.Color  := QUERY.FieldByName('COLOUR').AsInteger;
 If ColorDialog.Execute Then
  Begin
   QUERY.FieldByName('COLOUR').AsInteger  := ColorDialog.Color;
   Shape1.Brush.Color := QUERY.FieldByName('COLOUR').AsInteger;
  End;
end;

procedure TFBrowseLECTURERS.QueryBeforeEdit(DataSet: TDataSet);
begin
  inherited;
  Shape1.Brush.Color := QUERY.FieldByName('COLOUR').AsInteger;
end;

Procedure TFBrowseLECTURERS.CustomConditions;
Begin
 DM.macros.setMacro( Query, 'CONPERMISSIONS', getWhereClause(tableName));
 DM.macros.setMacro( Query, 'AVAILABLE', available);

 if ttEnabled.Checked then DM.macros.setMacro( Query, 'TTENABLED', '(LECTURERS.ID IN (SELECT  ID FROM TT_IDS WHERE TT_FOUND IS NOT NULL) OR (SELECT COUNT(1) FROM TT_IDS)=0)')
                      else DM.macros.setMacro( Query, 'TTENABLED', '0=0');

 If CON_ORGUNI_ID.Text = '' Then DM.macros.setMacro( Query, 'CON_ORGUNI_ID', '0=0')
                            Else DM.macros.setMacro( Query, 'CON_ORGUNI_ID', 'ORGUNI_ID IN ( SELECT ID FROM ORG_UNITS WHERE STRUCT_CODE LIKE '''+dmodule.singleValue('SELECT STRUCT_CODE FROM ORG_UNITS WHERE ID = '+CON_ORGUNI_ID.Text)+'%'')');

End;


procedure TFBrowseLECTURERS.ORGUNI_IDChange(Sender: TObject);
begin
    DModule.RefreshLookupEdit(Self, TControl(Sender).Name,'NAME','ORG_UNITS','');
end;

procedure TFBrowseLECTURERS.BSelectORGUNI_IDClick(Sender: TObject);
Var ID : ShortString;
begin
  ID := ORGUNI_ID.Text;
  //If AutoCreate.ORG_UNITSShowModalAsSelect(ID) = mrOK Then Query.FieldByName('ORGUNI_ID').AsString := ID;
  If LookupWindow(false, DModule.ADOConnection, 'ORG_UNITS','','SUBSTR(NAME ||'' (''||STRUCT_CODE||'')'',1,63)','NAZWA I KOD STRUKTURY','NAME','0=0','',ID) = mrOK Then Query.FieldByName('ORGUNI_ID').AsString := ID;
end;

procedure TFBrowseLECTURERS.CON_ORGUNI_IDChange(Sender: TObject);
begin
  If Trim(CON_ORGUNI_ID.TEXT) <> '' Then CON_ORGUNI_ID_VALUE.Text := DMOdule.SingleValue('SELECT NAME FROM ORG_UNITS WHERE ID='+CON_ORGUNI_ID.TEXT)
                                    Else CON_ORGUNI_ID_VALUE.Text := '';
  BRefreshClick(nil);
end;

procedure TFBrowseLECTURERS.BSelOUClick(Sender: TObject);
Var ID : ShortString;
begin
  ID := CON_ORGUNI_ID.Text;
  If LookupWindow(false, DModule.ADOConnection, 'ORG_UNITS','','SUBSTR(NAME ||'' (''||STRUCT_CODE||'')'',1,63)','NAZWA I KOD STRUKTURY','NAME','0=0','',ID) = mrOK Then CON_ORGUNI_ID.Text := ID;
end;

procedure TFBrowseLECTURERS.BitBtn6Click(Sender: TObject);
begin
  CON_ORGUNI_ID.Text := '';
end;

procedure TFBrowseLECTURERS.BKonsolidateClick(Sender: TObject);
begin
  inherited;
  CONSOLIDATIONShowModalAsBrowser(0);
end;

procedure TFBrowseLECTURERS.FormCreate(Sender: TObject);
begin
  inherited;
  Counter := 3;
end;

procedure TFBrowseLECTURERS.QueryAfterScroll(DataSet: TDataSet);
begin
  inherited;
  Counter := 2;
end;

function TFBrowseLECTURERS.getStrNameLov : shortString;
const str_name_lovs : array[0..2] of shortString = ('STREAM','ORG','OTHER');
begin
  if str_name_lov.ItemIndex = -1 then str_name_lov.ItemIndex := 0;
  result := str_name_lovs [ str_name_lov.ItemIndex ];
end;


procedure TFBrowseLECTURERS.refreshDetails;
begin

  QDetails.Close;
  If Query.IsEmpty Then Begin
    QDetails.Parameters.paramByName('ID').value   := '-1';
  End Else Begin
    ID := NVL(Query.FieldByName('ID').AsString,'-1');
    QDetails.Parameters.paramByName('ID').value             := ID;
    QDetails.Parameters.paramByName('STR_NAME_LOV1').value  := getStrNameLov;
    QDetails.Parameters.paramByName('STR_NAME_LOV2').value  := getStrNameLov;
  End;
  QDetails.Open;

  QParents.Close;
  If Query.IsEmpty Then Begin
    QParents.Parameters.paramByName('ID').value   := '-1';
  End Else Begin
    ID := NVL(Query.FieldByName('ID').AsString,'-1');
    QParents.Parameters.paramByName('ID').value             := ID;
    QParents.Parameters.paramByName('STR_NAME_LOV1').value   := getStrNameLov;
    QParents.Parameters.paramByName('STR_NAME_LOV2').value   := getStrNameLov;
  End;
  QParents.Open;

  Counter := 1;
end;


procedure TFBrowseLECTURERS.TimerDetailsTimer(Sender: TObject);
begin
  inherited;
  If Counter > 0 Then Counter := Counter - 1;
  If Counter = 1 Then refreshDetails;
end;

procedure TFBrowseLECTURERS.insert_str_elem(parent : boolean);
Var
    keyValues: ShortString;
    keyValue : ShortString;
    resultValue : string;
    mr : tmodalresult;
    pexclusive_parent : shortString;
    t : integer;
    checkSQL : string;
    currentParent : string;
begin
  mr := FExclusiveParent.showModal;
  if mr = mrYes then pexclusive_parent := '+';
  if mr = mrNo then  pexclusive_parent := '-';
  if (mr <> mrNo) and (mr <> mrYes) then exit;

  keyValue := '';
  If LookupWindow(True, DModule.ADOConnection, 'LECTURERS LEC, LEC_PLA','LEC.ID','LAST_NAME||'' ''||FIRST_NAME','Nazwa','LAST_NAME||'' ''||FIRST_NAME','LEC_PLA.LEC_ID = LEC.ID AND PLA_ID = '+FMain.getUserOrRoleID,'',KeyValues,'500,100') = mrOK Then Begin

   for t := 1 to wordCount(KeyValues, [',']) do begin
     KeyValue := extractWord(t,KeyValues, [',']);
     checkSQL := fmain.sqlCheckConflicts.Lines.Text;
     checkSQL := Replace(checkSQL,'%RESTYPE','LEC');
     checkSQL := Replace(checkSQL,':id1',keyValue);
     checkSQL := Replace(checkSQL,':id2',query.FieldByName('ID').asString);
     resultValue := dmodule.SingleValue(checkSQL);
     if (resultValue<>'') then begin
       info(KeyValue+': Nie mo¿na utworzyæ relacji, poniewa¿ spowodowa³aby ona konflikty: Wyk³adowca podrzêdny oraz wy³adowca nadrzêdny maj¹ ju¿ zajêcia w tym samym czasie, o np. '+resultValue);
       Exit;
     End;
   end;
   
   for t := 1 to wordCount(KeyValues, [',']) do begin
   KeyValue := extractWord(t,KeyValues, [',']);
    with dmodule.QWork do begin
      SQL.Clear;
      SQL.Add('begin planner_utils.insert_str_elem (:pparent_id, :pchild_id, :pstr_name_lov, :pexclusive_parent); end;');
      if parent then begin
        Parameters.ParamByName('pparent_id').Value   := keyValue;
        currentParent := keyValue;
        Parameters.ParamByName('pchild_id').value     := query.FieldByName('ID').asString;
      end
      else
      begin
        Parameters.ParamByName('pchild_id').value    := keyValue;
        Parameters.ParamByName('pparent_id').value     := query.FieldByName('ID').asString;
        currentParent := query.FieldByName('ID').asString;
      end;
      Parameters.ParamByName('pexclusive_parent').value     := pexclusive_parent;
      Parameters.ParamByName('pstr_name_lov').value := getStrNameLov;
      execSQL;
    end;
    fmain.propagateDependencyChanges(currentParent, 'L');
   end;
   resultValue := dmodule.SingleValue('select planner_utils.get_output_param_char1 from dual');
   if resultValue <> '' then info (resultValue) else refreshDetails;
  end;
end;


procedure TFBrowseLECTURERS.AddParentClick(Sender: TObject);
begin
  inherited;
 insert_str_elem(true);
end;

procedure TFBrowseLECTURERS.AddDetailClick(Sender: TObject);
begin
  inherited;
 insert_str_elem(false);
end;

procedure TFBrowseLECTURERS.delete_str_elem(parent : boolean);
var id : shortString;
    parentId : shortString;
begin
 if parent then id := qparents.FieldByName('id').AsString
           else id := qdetails.FieldByName('id').AsString;
 if id='' then exit;
 if question
    ('Czy na pewno chcesz usun¹æ nastêpuj¹cy rekord ?'+cr+
     dmodule.SingleValue('select ''Podrzêdny: ''|| child_dsp|| chr(13)||chr(10)||''Nadrzêdny: '' ||parent_dsp from str_elems_v where id =' + id )
    ) = id_yes
 then begin
  parentId := dmodule.SingleValue('select parent_id from str_elems_v where id =' + id );
  dmodule.SQL('delete from str_elems where id = '  + id );
  fmain.propagateDependencyChanges(parentId, 'G');
  refreshDetails;
 end;
end;

procedure TFBrowseLECTURERS.DelParentClick(Sender: TObject);
begin
  inherited;
  delete_str_elem(true);
end;

procedure TFBrowseLECTURERS.delDetailClick(Sender: TObject);
begin
  inherited;
  delete_str_elem(false);
end;

procedure TFBrowseLECTURERS.str_name_lovChange(Sender: TObject);
begin
  inherited;
  refreshDetails;
end;

procedure TFBrowseLECTURERS.deleteClick;
begin
  if activeControl = GParents then begin delete_str_elem(true);  exit; end;
  if activeControl = Gdetails then begin delete_str_elem(false); exit; end;
  inherited;
end;

procedure TFBrowseLECTURERS.AddClick;
begin
  if activeControl = GParents then begin insert_str_elem(true);  exit; end;
  if activeControl = Gdetails then begin insert_str_elem(false); exit; end;
  inherited;
end;

procedure TFBrowseLECTURERS.RightPageMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if RightPage.Width < 430
    then RightPage.Width := 430
    else RightPage.Width := 24;
end;

procedure TFBrowseLECTURERS.BUpdChild1Click(Sender: TObject);
begin
  AutoCreate.CLASSESShowModalAsBrowser('CLASSES', Query['Id'] ,'', '', '','','','',false);
end;

procedure TFBrowseLECTURERS.ttEnabledClick(Sender: TObject);
begin
  BRefreshClick(nil);
end;

procedure TFBrowseLECTURERS.FormShow(Sender: TObject);
begin
  inherited;

 with fprogramsettings do begin
  self.Caption           := fprogramsettings.profileObjectNameLs.Text;
  BChild1.Caption        := profileObjectNameClasses.Text;
  BUpdChild1.Caption     := profileObjectNameClasses.Text;
  if profileType.ItemIndex <> 0 then begin
    BMassImport.Visible  := false;
  end;
 end;

end;

procedure TFBrowseLECTURERS.BMassImportClick(Sender: TObject);
begin
 dmodule.CommitTrans;
 FMain.RunMassImport(0); //LEC
 BRefreshClick(nil);
end;

procedure TFBrowseLECTURERS.BUpdChild2Click(Sender: TObject);
begin
  AutoCreate.FIN_PARTIESShowModalAsBrowser( 'PLANSOFT:' + Query.fieldByName('ID').AsString );
end;

procedure TFBrowseLECTURERS.ORGUNI_ID_VALUEClick(Sender: TObject);
begin
  BSelectORGUNI_IDClick( nil );
end;

procedure TFBrowseLECTURERS.CON_ORGUNI_ID_VALUEClick(Sender: TObject);
begin
  BSelOUClick( nil );
end;

function TFBrowseLECTURERS.getSearchFilter: string;
begin
 result := '(xxmsz_tools.erasePolishChars(upper(org_units.name||lecturers.abbreviation||lecturers.title||'' ''||lecturers.first_name||'' ''||lecturers.last_name||lecturers.email|| lecturers.attribs_01||lecturers.attribs_02||lecturers.attribs_03||lecturers.attribs_04'+
           '||lecturers.attribs_05||lecturers.attribs_06||lecturers.attribs_07||lecturers.attribs_08||lecturers.attribs_09||lecturers.attribs_10||lecturers.attribs_11||lecturers.attribs_12||lecturers.attribs_13||lecturers.attribs_14||lecturers.attribs_15'+
           '||lecturers.desc1||lecturers.desc2)) like ''%'+replacePolishChars( ansiuppercase(trim(ESearch.Text)) )+'%'')';
end;

function TFBrowseLECTURERS.getFindCaption: string;
begin
 Result := 'Dowolna fraza';
end;

function TFBrowseLECTURERS.canDelete: Boolean;
begin
 result := isBlank(confineCalendarId);
end;

function TFBrowseLECTURERS.canEditPermission: Boolean;
begin
 result := isBlank(confineCalendarId);
end;

function TFBrowseLECTURERS.canInsert: Boolean;
begin
 result := isBlank(confineCalendarId);
end;

Procedure TFBrowseLECTURERS.AfterPost;
Begin
 If CurrOperation in [AInsert,ACopy] Then begin
    FSharing.init('I','LEC',ID_.Text, QUERY.FieldByName('TITLE').AsString +' '+ QUERY.FieldByName('FIRST_NAME').AsString +' '+ QUERY.FieldByName('LAST_NAME').AsString);
    dmodule.CommitTrans;
 end;
End;

procedure TFBrowseLECTURERS.BUpdChild3Click(Sender: TObject);
begin
   FSharing.init('U','LEC',ID_.Text, QUERY.FieldByName('TITLE').AsString +' '+ QUERY.FieldByName('FIRST_NAME').AsString +' '+ QUERY.FieldByName('LAST_NAME').AsString);
   dmodule.CommitTrans;
end;

procedure TFBrowseLECTURERS.ROL_IDChange(Sender: TObject);
begin
  DModule.RefreshLookupEdit(Self, TControl(Sender).Name,'NAME','PLANNERS','');
end;

procedure TFBrowseLECTURERS.SpeedButton3Click(Sender: TObject);
begin
  info('Wpisz dowolne s³owa kluczowe w formacie "#ABD, #XYZ".'+cr+'Nastêpnie wyszukuj wyk³adowców przez wpisanie #<s³owo kluczowe> w dowolnym miejscu w Aplikacji');
end;

procedure TFBrowseLECTURERS.SpeedButton2Click(Sender: TObject);
begin
  info('Wpisz przedmioty w formacie "#Matematyka #Fizyka".'+cr+'Nastêpnie wyszukuj wyk³adowców przez wpisanie #nazwa przedmiotu w dowolnym miejscu w Aplikacji');
end;

end.
