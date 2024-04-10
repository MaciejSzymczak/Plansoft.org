unit uFBrowseGROUPS;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UFBrowseParent, ExtCtrls, StrHlder, Menus, Db, DBTables, RxQuery,
  ComCtrls, Grids, DBGrids, RXDBCtrl, StdCtrls, Buttons, Mask, DBCtrls, UCommon,
  ToolEdit, ImgList, ADODB, OleServer, ExcelXP;

type
  TFBrowseGROUPS = class(TFBrowseParent)
    ID_: TDBEdit;
    LabelID: TLabel;
    ABBREVIATION: TDBEdit;
    LabelABBREVIATION: TLabel;
    NAME: TDBEdit;
    LabelNAME: TLabel;
    NUMBER_OF_PEOPLES: TDBEdit;
    LabelNUMBER_OF_PEOPLES: TLabel;
    LabelCOLOUR: TLabel;
    Shape1: TShape;
    ColorDialog: TColorDialog;
    Label2: TLabel;
    DESC1: TDBEdit;
    Label3: TLabel;
    DESC2: TDBEdit;
    Label5: TLabel;
    CON_GT_ID: TEdit;
    CON_GT_ID_VALUE: TEdit;
    BitBtn3: TBitBtn;
    BALL: TBitBtn;
    LabelGT_ID: TLabel;
    GT_ID: TDBEdit;
    GT_ID_VALUE: TEdit;
    BSelectGT_ID: TBitBtn;
    BStat: TBitBtn;
    BExtra: TBitBtn;
    B1: TBitBtn;
    B2: TBitBtn;
    B3: TBitBtn;
    BOTHER: TBitBtn;
    BKonsolidate: TBitBtn;
    DSParents: TDataSource;
    TimerDetails: TTimer;
    DSDetails: TDataSource;
    Splitter1: TSplitter;
    AvailableDsp: TLabel;
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
    Label4: TLabel;
    str_name_lov: TComboBox;
    QParents: TADOQuery;
    QDetails: TADOQuery;
    ttEnabled: TCheckBox;
    BMassImport: TBitBtn;
    BABBREVIATION: TBitBtn;
    LEmail: TLabel;
    EMAIL: TDBEdit;
    LabelROL_ID: TLabel;
    Label1: TLabel;
    ROL_ID: TDBEdit;
    ROL_ID_VALUE: TEdit;
    BSelectROL_ID: TBitBtn;
    BClearROL_ID: TBitBtn;
    LabelORGUNI_ID: TLabel;
    ORGUNI_ID: TDBEdit;
    ORGUNI_ID_VALUE: TEdit;
    BSelectORGUNI_ID: TBitBtn;
    Label6: TLabel;
    CON_ORGUNI_ID: TEdit;
    CON_ORGUNI_ID_VALUE: TEdit;
    BSelOU: TBitBtn;
    BitBtn6: TBitBtn;
    BitBtn1: TBitBtn;
    PPDiagram: TPopupMenu;
    Wszystkiegrupy1: TMenuItem;
    ylkogrupyzbiecegosemestru1: TMenuItem;
    ylkogrupypowizanezwybrangrup1: TMenuItem;
    Wicejmoliwo1: TMenuItem;
    SpeedButton2: TSpeedButton;
    LINTEGRATION_ID: TLabel;
    INTEGRATION_ID: TDBEdit;
    StructCleanUp: TMemo;
    procedure Shape1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure QueryBeforeEdit(DataSet: TDataSet);
    procedure GridDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure CON_GT_IDChange(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BALLClick(Sender: TObject);
    procedure CON_GT_ID_VALUEDblClick(Sender: TObject);
    procedure GT_IDChange(Sender: TObject);
    procedure BSelectGT_IDClick(Sender: TObject);
    procedure BClearGT_IDClick(Sender: TObject);
    procedure GT_ID_VALUEDblClick(Sender: TObject);
    procedure BStatClick(Sender: TObject);
    procedure BExtraClick(Sender: TObject);
    procedure B1Click(Sender: TObject);
    procedure B2Click(Sender: TObject);
    procedure B3Click(Sender: TObject);
    procedure BOTHERClick(Sender: TObject);
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
    procedure BABBREVIATIONClick(Sender: TObject);
    procedure BUpdChild2Click(Sender: TObject);
    procedure ROL_IDChange(Sender: TObject);
    procedure ROL_ID_VALUEDblClick(Sender: TObject);
    procedure BSelectROL_IDClick(Sender: TObject);
    procedure BClearROL_IDClick(Sender: TObject);
    procedure ORGUNI_IDChange(Sender: TObject);
    procedure BSelectORGUNI_IDClick(Sender: TObject);
    procedure CON_ORGUNI_IDChange(Sender: TObject);
    procedure BSelOUClick(Sender: TObject);
    procedure BitBtn6Click(Sender: TObject);
    procedure CON_ORGUNI_ID_VALUEClick(Sender: TObject);
    procedure ORGUNI_ID_VALUEClick(Sender: TObject);
    procedure BUpdChild3Click(Sender: TObject);
    procedure Wszystkiegrupy1Click(Sender: TObject);
    procedure ylkogrupyzbiecegosemestru1Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure ylkogrupypowizanezwybrangrup1Click(Sender: TObject);
    procedure BUpdChild4Click(Sender: TObject);
    procedure Wicejmoliwo1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
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
  FBrowseGROUPS: TFBrowseGROUPS;

implementation


uses DM, UUtilityParent, UFMain, UFLookupWindow, autocreate,
  UFProgramSettings, UFMassImport, UFSharing, UFExclusiveParent,
  UFGraphviz;

{$R *.DFM}

Function  TFBrowseGROUPS.CheckRecord : Boolean;
Begin
  Result := CheckValid.ReducRestrictEmpty(Self, [ABBREVIATION, NUMBER_OF_PEOPLES, ORGUNI_ID]);
End;

Procedure TFBrowseGROUPS.DefaultValues;
Var c : Integer;
Begin
 Query['ID'] := DModule.SingleValue('select main_seq.nextval from dual');
 Query['GROUP_TYPE'] := CON_GT_ID.text;
 c := getRandomColor;
 QUERY['COLOUR'] := c;
 Shape1.Brush.Color := c;
 if CON_ORGUNI_ID.Text <> '' then
   Query['ORGUNI_ID'] := CON_ORGUNI_ID.Text;
End;


procedure TFBrowseGROUPS.Shape1MouseUp(Sender: TObject;
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

procedure TFBrowseGROUPS.QueryBeforeEdit(DataSet: TDataSet);
begin
  inherited;
  Shape1.Brush.Color := QUERY.FieldByName('COLOUR').AsInteger;
end;

procedure TFBrowseGROUPS.GridDrawColumnCell(Sender: TObject;
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

Procedure TFBrowseGROUPS.CustomConditions;
Begin
 DM.macros.setMacro(query, 'CONPERMISSIONS', getWhereClause(tableName));
 DM.macros.setMacro(query, 'AVAILABLE', available);

 if ttEnabled.Checked then DM.macros.setMacro( Query, 'TTENABLED', '(GROUPS.ID IN (SELECT  ID FROM TT_IDS WHERE TT_FOUND IS NOT NULL) OR (SELECT COUNT(1) FROM TT_IDS)=0)')
                      else DM.macros.setMacro( Query, 'TTENABLED', '0=0');

 If CON_GT_ID.Text = '' Then DM.macros.setMacro(query, 'CON_GROUP_TYPE', '0=0')
                        Else DM.macros.setMacro(query, 'CON_GROUP_TYPE', 'GT.CODE = ''' + CON_GT_ID.Text + '''');

 If CON_ORGUNI_ID.Text = '' Then DM.macros.setMacro( Query, 'CON_ORGUNI_ID', '0=0')
                            Else DM.macros.setMacro( Query, 'CON_ORGUNI_ID', 'ORGUNI_ID IN ( SELECT ID FROM ORG_UNITS WHERE STRUCT_CODE LIKE '''+dmodule.singleValue('SELECT STRUCT_CODE FROM ORG_UNITS WHERE ID = '+CON_ORGUNI_ID.Text)+'%'')');

End;


procedure TFBrowseGROUPS.CON_GT_IDChange(Sender: TObject);
begin
  inherited;
  If Trim(CON_GT_ID.TEXT) <> '' Then CON_GT_ID_VALUE.Text := DMOdule.SingleValue('SELECT NAME FROM LOOKUPS_GROUP_TYPE WHERE CODE='''+CON_GT_ID.TEXT+'''')
                                Else CON_GT_ID_VALUE.Text := 'Wszystkie';
  BRefreshClick(nil);
end;

procedure TFBrowseGROUPS.BitBtn3Click(Sender: TObject);
Var ID : ShortString;
begin
  ID := CON_GT_ID.Text;
  If LookupWindow(false, DModule.ADOConnection, 'LOOKUPS_GROUP_TYPE','CODE','NAME','Typ','NAME','0=0','',ID) = mrOK Then CON_GT_ID.Text := ID;
end;

procedure TFBrowseGROUPS.BALLClick(Sender: TObject);
begin
  inherited;
  CON_GT_ID.Text := '';
end;

procedure TFBrowseGROUPS.CON_GT_ID_VALUEDblClick(Sender: TObject);
begin
  inherited;
  BitBtn3Click( nil );
end;

procedure TFBrowseGROUPS.GT_IDChange(Sender: TObject);
begin
  inherited;
  DModule.RefreshLookupEdit(Self, TControl(Sender).Name,'NAME','LOOKUPS_GROUP_TYPE','CODE='''+TDBEdit(Sender).TEXT+'''');
end;

procedure TFBrowseGROUPS.BSelectGT_IDClick(Sender: TObject);
Var ID : ShortString;
begin
  ID := GT_ID.Text;
  If LookupWindow(false, DModule.ADOConnection, 'LOOKUPS_GROUP_TYPE','CODE','NAME','Typ','NAME','0=0','',ID) = mrOK Then Query.FieldByName('GROUP_TYPE').AsString := ID;
end;

procedure TFBrowseGROUPS.BClearGT_IDClick(Sender: TObject);
begin
  inherited;
  Query.FieldByName('GROUP_TYPE').Clear;
end;

procedure TFBrowseGROUPS.GT_ID_VALUEDblClick(Sender: TObject);
begin
  inherited;
  BSelectGT_IDClick( nil );
end;

procedure TFBrowseGROUPS.BStatClick(Sender: TObject);
begin
  inherited;
  Query.FieldByName('GROUP_TYPE').AsString := 'STATIONARY';
end;

procedure TFBrowseGROUPS.BExtraClick(Sender: TObject);
begin
  Query.FieldByName('GROUP_TYPE').AsString := 'EXTRAMURAL';
end;

procedure TFBrowseGROUPS.B1Click(Sender: TObject);
begin
  inherited;
  CON_GT_ID.Text := 'STATIONARY';
end;

procedure TFBrowseGROUPS.B2Click(Sender: TObject);
begin
  inherited;
  CON_GT_ID.Text := 'EXTRAMURAL';
end;

procedure TFBrowseGROUPS.B3Click(Sender: TObject);
begin
  inherited;
  CON_GT_ID.Text := 'OTHER';
end;

procedure TFBrowseGROUPS.BOTHERClick(Sender: TObject);
begin
  inherited;
  Query.FieldByName('GROUP_TYPE').AsString := 'OTHER';
end;

procedure TFBrowseGROUPS.BKonsolidateClick(Sender: TObject);
begin
  inherited;
  CONSOLIDATIONShowModalAsBrowser(1);
end;


procedure TFBrowseGROUPS.QueryAfterScroll(DataSet: TDataSet);
begin
  Counter := 2;
end;

function TFBrowseGROUPS.getStrNameLov : shortString;
const str_name_lovs : array[0..2] of shortString = ('STREAM','ORG','OTHER');
begin
  if str_name_lov.ItemIndex = -1 then str_name_lov.ItemIndex := 0;
  result := str_name_lovs [ str_name_lov.ItemIndex ];
end;


procedure TFBrowseGROUPS.refreshDetails;
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


procedure TFBrowseGROUPS.TimerDetailsTimer(Sender: TObject);
begin
  If Counter > 0 Then Counter := Counter - 1;
  If Counter = 1 Then refreshDetails;
end;

procedure TFBrowseGROUPS.insert_str_elem(parent : boolean);
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
  If LookupWindow(True, DModule.ADOConnection, 'GROUPS GRO, GRO_PLA','GRO.ID','abbreviation','Nazwa','abbreviation','GRO_PLA.GRO_ID = GRO.ID AND PLA_ID = '+FMain.getUserOrRoleID,'',KeyValues,'500,100') = mrOK Then Begin

   for t := 1 to wordCount(KeyValues, [',']) do begin
     KeyValue := extractWord(t,KeyValues, [',']);
     checkSQL := fmain.sqlCheckConflicts.Lines.Text;
     checkSQL := Replace(checkSQL,'%RESTYPE','GRO');
     checkSQL := Replace(checkSQL,':id1',keyValue);
     checkSQL := Replace(checkSQL,':id2',query.FieldByName('ID').asString);
     resultValue := dmodule.SingleValue(checkSQL);
     if (resultValue<>'') then begin
       info(KeyValue+': Nie mo¿na utworzyæ relacji, poniewa¿ spowodowa³aby ona konflikty: Grupa podrzêdna oraz grupa nadrzêdna maj¹ ju¿ zajêcia w tym samym czasie, o np. '+resultValue);
       Exit;
     End;
   end;

   for t := 1 to wordCount(KeyValues, [',']) do begin
   KeyValue := extractWord(t,KeyValues, [',']);
    with dmodule.QWork do begin
      SQL.Clear;
      SQL.Add('begin planner_utils.insert_str_elem (:pparent_id, :pchild_id, :pstr_name_lov, :pexclusive_parent); end;');
      if parent then begin
        Parameters.ParamByName('pparent_id').value    := keyValue;
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
    fmain.propagateDependencyChanges(currentParent, 'G');
   end;

   resultValue := dmodule.SingleValue('select planner_utils.get_output_param_char1 from dual');
   if resultValue <> '' then info (resultValue) else refreshDetails;

  end;
end;



procedure TFBrowseGROUPS.AddParentClick(Sender: TObject);
begin
 insert_str_elem(true);
end;

procedure TFBrowseGROUPS.AddDetailClick(Sender: TObject);
begin
 insert_str_elem(false);
end;

procedure TFBrowseGROUPS.delete_str_elem(parent : boolean);
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

  //@@@todo:limit the cleanups to specific child and parent
  //@@@todo: do the same for lec and rom
  dmodule.SQL( structCleanUp.Lines.Text );

  fmain.propagateDependencyChanges(parentId, 'G');
  refreshDetails;
 end;
end;

procedure TFBrowseGROUPS.DelParentClick(Sender: TObject);
begin
  delete_str_elem(true);
end;

procedure TFBrowseGROUPS.delDetailClick(Sender: TObject);
begin
  delete_str_elem(false);
end;

procedure TFBrowseGROUPS.str_name_lovChange(Sender: TObject);
begin
  refreshDetails;
end;

procedure TFBrowseGROUPS.deleteClick;
begin
  if activeControl = GParents then begin delete_str_elem(true);  exit; end;
  if activeControl = Gdetails then begin delete_str_elem(false); exit; end;
  inherited;
end;

procedure TFBrowseGROUPS.AddClick;
begin
  if activeControl = GParents then begin insert_str_elem(true);  exit; end;
  if activeControl = Gdetails then begin insert_str_elem(false); exit; end;
  inherited;
end;


procedure TFBrowseGROUPS.RightPageMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if RightPage.Width <430
    then RightPage.Width := 430
    else RightPage.Width := 24;
end;

procedure TFBrowseGROUPS.BUpdChild1Click(Sender: TObject);
begin
  AutoCreate.CLASSESShowModalAsBrowser('CLASSES','', Query['Id'], '', '','','','',false, true);
end;

procedure TFBrowseGROUPS.ttEnabledClick(Sender: TObject);
begin
  BRefreshClick(nil);
end;

procedure TFBrowseGROUPS.FormCreate(Sender: TObject);
begin
  with fprogramsettings do begin
   if profileType.ItemIndex <> 0 then begin
     //@@@hardcoding
     grid.Columns[4].Title.caption  := 'PESEL';
     LabelNUMBER_OF_PEOPLES.Caption := 'PESEL';
     holderSortOrder.Strings[3] := 'NUMBER_OF_PEOPLES|PESEL';
   end;
  end;

  inherited;
  Counter := 3;
end;

procedure TFBrowseGROUPS.FormShow(Sender: TObject);
begin
 inherited;
 with fprogramsettings do begin
  self.Caption           := fprogramsettings.profileObjectNameGs.Text;
  BChild1.Caption        := profileObjectNameClasses.Text;
  BUpdChild1.Caption     := profileObjectNameClasses.Text;
  if profileType.ItemIndex <> 0 then begin
    //@@@hardcoding
    BMassImport.Visible := false;
    BStat.Caption       := 'Abonament';
    BExtra.Caption      := 'Jednorazowy';
    BOTHER.Caption      := 'Inny';
    B1.Caption          := 'Abonament';
    B2.Caption          := 'Jednorazowy';
    B3.Caption          := 'Inny';
    BALL.Caption        := 'Wszystkie';
  end;
 end;

end;

procedure TFBrowseGROUPS.BMassImportClick(Sender: TObject);
begin
 dmodule.CommitTrans;
 FMain.RunMassImport(1); //GRO
 BRefreshClick(nil);
end;

procedure TFBrowseGROUPS.BABBREVIATIONClick(Sender: TObject);
begin
  inherited;
  Query['ABBREVIATION'] := ID_.text;
end;

procedure TFBrowseGROUPS.BUpdChild2Click(Sender: TObject);
begin
  AutoCreate.FIN_PARTIESShowModalAsBrowser( 'PLANSOFT:' + Query.fieldByName('ID').AsString );
end;

procedure TFBrowseGROUPS.ROL_IDChange(Sender: TObject);
begin
  DModule.RefreshLookupEdit(Self, TControl(Sender).Name,'NAME','PLANNERS','');
end;

procedure TFBrowseGROUPS.ROL_ID_VALUEDblClick(Sender: TObject);
begin
  BSelectROL_IDClick(nil);
end;

procedure TFBrowseGROUPS.BSelectROL_IDClick(Sender: TObject);
Var id : ShortString;
begin
  id := ROL_ID.Text;
  If LookupWindow(false, DModule.ADOConnection, 'PLANNERS','','NAME','NAZWA','NAME','(ID IN (SELECT ROL_ID FROM ROL_PLA WHERE PLA_ID = '+UserID+'))','',id) = mrOK Then
    Query.FieldByName('ROL_ID').AsString := id;
end;

procedure TFBrowseGROUPS.BClearROL_IDClick(Sender: TObject);
begin
    Query.FieldByName('ROL_ID').Clear;
end;

procedure TFBrowseGROUPS.ORGUNI_IDChange(Sender: TObject);
begin
  DModule.RefreshLookupEdit(Self, TControl(Sender).Name,'NAME','ORG_UNITS','');
end;

procedure TFBrowseGROUPS.BSelectORGUNI_IDClick(Sender: TObject);
Var ID : ShortString;
begin
  ID := ORGUNI_ID.Text;
  //If AutoCreate.ORG_UNITSShowModalAsSelect(ID) = mrOK Then Query.FieldByName('ORGUNI_ID').AsString := ID;
  If LookupWindow(false, DModule.ADOConnection, 'ORG_UNITS','','SUBSTR(NAME ||'' (''||STRUCT_CODE||'')'',1,63)','NAZWA I KOD STRUKTURY','NAME','0=0','',ID) = mrOK Then Query.FieldByName('ORGUNI_ID').AsString := ID;
end;

procedure TFBrowseGROUPS.CON_ORGUNI_IDChange(Sender: TObject);
begin
  If Trim(CON_ORGUNI_ID.TEXT) <> '' Then CON_ORGUNI_ID_VALUE.Text := DMOdule.SingleValue('SELECT NAME FROM ORG_UNITS WHERE ID='+CON_ORGUNI_ID.TEXT)
                                    Else CON_ORGUNI_ID_VALUE.Text := '';
  BRefreshClick(nil);
end;

procedure TFBrowseGROUPS.BSelOUClick(Sender: TObject);
Var ID : ShortString;
begin
  ID := CON_ORGUNI_ID.Text;
  If LookupWindow(false, DModule.ADOConnection, 'ORG_UNITS','','SUBSTR(NAME ||'' (''||STRUCT_CODE||'')'',1,63)','NAZWA I KOD STRUKTURY','NAME','0=0','',ID) = mrOK Then CON_ORGUNI_ID.Text := ID;
end;

procedure TFBrowseGROUPS.BitBtn6Click(Sender: TObject);
begin
  CON_ORGUNI_ID.Text := '';
end;

procedure TFBrowseGROUPS.CON_ORGUNI_ID_VALUEClick(Sender: TObject);
begin
  BSelOUClick(nil);

end;

procedure TFBrowseGROUPS.ORGUNI_ID_VALUEClick(Sender: TObject);
begin
  BSelectORGUNI_IDClick(nil);

end;

function TFBrowseGROUPS.getSearchFilter: string;
begin
 result := buildFilter(sql_GRO_SEARCH, ESearch.Text);
end;

function TFBrowseGROUPS.getFindCaption: string;
begin
 Result := 'Dowolna fraza';
end;

function TFBrowseGROUPS.canDelete: Boolean;
begin
 result := isBlank(confineCalendarId);
end;

function TFBrowseGROUPS.canEditPermission: Boolean;
begin
 result := isBlank(confineCalendarId);
end;

function TFBrowseGROUPS.canInsert: Boolean;
begin
 result := isBlank(confineCalendarId);
end;

Procedure TFBrowseGROUPS.AfterPost;
Begin
 If CurrOperation in [AInsert,ACopy] Then begin
    FSharing.init('I','GRO',ID_.Text, QUERY.FieldByName('NAME').AsString);
    dmodule.CommitTrans;
 end;
End;


procedure TFBrowseGROUPS.BUpdChild3Click(Sender: TObject);
begin
   FSharing.init('U','GRO',ID_.Text, QUERY.FieldByName('NAME').AsString);
   dmodule.CommitTrans;
end;

procedure TFBrowseGROUPS.Wszystkiegrupy1Click(Sender: TObject);
begin
  fGraphviz.generateOrgChart('all', 'n/a', 0);
end;

procedure TFBrowseGROUPS.ylkogrupyzbiecegosemestru1Click(Sender: TObject);
begin
  fGraphviz.generateOrgChart('currentPeriodOnly', 'n/a', 0);
end;

procedure TFBrowseGROUPS.BitBtn1Click(Sender: TObject);
var point : tpoint;
    btn   : tcontrol;
begin
 btn     := sender as tcontrol;
 Point.x := 0;
 Point.y := btn.Height;
 Point   := btn.ClientToScreen(Point);
 PPDiagram.Popup(Point.X,Point.Y);
end;

procedure TFBrowseGROUPS.ylkogrupypowizanezwybrangrup1Click(
  Sender: TObject);
begin
  fGraphviz.generateOrgChart('currentGroup', query.FieldByName('ID').asString, 0);
end;

procedure TFBrowseGROUPS.BUpdChild4Click(Sender: TObject);
begin
 fGraphviz.generateOrgChart('currentGroup', query.FieldByName('ID').asString, 0);
end;

procedure TFBrowseGROUPS.Wicejmoliwo1Click(Sender: TObject);
begin
 FGraphviz.customshowmodal(query.FieldByName('ID').asString);
end;

procedure TFBrowseGROUPS.SpeedButton2Click(Sender: TObject);
begin
  inherited;
  info('Wpisz dowolne s³owa kluczowe w formacie "#ABD, #XYZ".'+cr+'Nastêpnie wyszukuj grupy przez wpisanie #<s³owo kluczowe> w dowolnym miejscu w Aplikacji');

end;

procedure TFBrowseGROUPS.SpeedButton1Click(Sender: TObject);
begin
  inherited;
  INTEGRATION_ID.Visible := true;
  LINTEGRATION_ID.Visible := true;
end;

end.


