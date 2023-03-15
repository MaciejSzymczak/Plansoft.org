unit UFBrowseSUBJECTS;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UFBrowseParent, ExtCtrls, StrHlder, Menus, Db, DBTables, RxQuery,
  ComCtrls, Grids, DBGrids, RXDBCtrl, StdCtrls, Buttons, Mask, DBCtrls,
  ToolEdit, ImgList, ADODB, OleServer, ExcelXP, UFLookupWindow;

type
  TFBrowseSUBJECTS = class(TFBrowseParent)
    ID_: TDBEdit;
    LabelID: TLabel;
    ABBREVIATION: TDBEdit;
    LabelABBREVIATION: TLabel;
    NAME: TDBEdit;
    LabelNAME: TLabel;
    LabelCOLOUR: TLabel;
    ColorDialog: TColorDialog;
    Shape1: TShape;
    Label2: TLabel;
    DESC1: TDBEdit;
    Label3: TLabel;
    DESC2: TDBEdit;
    ttEnabledFlag: TCheckBox;
    BMassImport: TBitBtn;
    LabelORGUNI_ID: TLabel;
    ORGUNI_ID: TDBEdit;
    ORGUNI_ID_VALUE: TEdit;
    BSelectORGUNI_ID: TBitBtn;
    BClearORGUNI_ID: TBitBtn;
    Label5: TLabel;
    CON_ORGUNI_ID: TEdit;
    CON_ORGUNI_ID_VALUE: TEdit;
    BSelOU: TBitBtn;
    BitBtn6: TBitBtn;
    SpeedButton3: TSpeedButton;
    QParents: TADOQuery;
    DSParents: TDataSource;
    QDetails: TADOQuery;
    DSDetails: TDataSource;
    TimerDetails: TTimer;
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
    Splitter1: TSplitter;
    DIFF_NOTIFICATIONS: TDBCheckBox;
    BMassEdit: TBitBtn;
    procedure Shape1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure QueryBeforeEdit(DataSet: TDataSet);
    procedure GridDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure ttEnabledFlagClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BMassImportClick(Sender: TObject);
    procedure BUpdChild1Click(Sender: TObject);
    procedure BUpdChild2Click(Sender: TObject);
    procedure ORGUNI_IDChange(Sender: TObject);
    procedure BSelectORGUNI_IDClick(Sender: TObject);
    procedure BClearORGUNI_IDClick(Sender: TObject);
    procedure CON_ORGUNI_IDChange(Sender: TObject);
    procedure BSelOUClick(Sender: TObject);
    procedure BitBtn6Click(Sender: TObject);
    procedure CON_ORGUNI_ID_VALUEClick(Sender: TObject);
    procedure ORGUNI_ID_VALUEClick(Sender: TObject);
    procedure BUpdChild3Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure TimerDetailsTimer(Sender: TObject);
    procedure QueryAfterScroll(DataSet: TDataSet);
    procedure FormCreate(Sender: TObject);
    procedure str_name_lovChange(Sender: TObject);
    procedure AddParentClick(Sender: TObject);
    procedure DelParentClick(Sender: TObject);
    procedure AddDetailClick(Sender: TObject);
    procedure delDetailClick(Sender: TObject);
    procedure BMassEditClick(Sender: TObject);
  private
    { Private declarations }
    Counter  : Integer;
    procedure refreshDetails;
    procedure insert_str_elem(parent : boolean);
    procedure delete_str_elem(parent : boolean);
    function  getStrNameLov : shortString;
  public
    Function  CheckRecord : Boolean; override;
    Procedure DefaultValues; override;
    Procedure CustomConditions; override;
    Procedure AfterPost; override;
    Function  getSearchFilter : string;  override;
    function  getFindCaption : string;   override;
    Function  canEditPermission : Boolean;   override;
    Function  canInsert    : Boolean;        override;
    Function  canDelete    : Boolean;        override;  end;

var
  FBrowseSUBJECTS: TFBrowseSUBJECTS;

implementation

{$R *.DFM}

uses DM, UUtilityParent, UFMain, UCommon, UFProgramSettings, UFMassImport, AutoCreate,
  UFSharing, UFExclusiveParent, UFMassUpdateSUB;

Function  TFBrowseSUBJECTS.CheckRecord : Boolean;
Begin
  Result := CheckValid.ReducRestrictEmpty(Self, [ABBREVIATION, NAME, ORGUNI_ID]);
End;

Procedure TFBrowseSUBJECTS.DefaultValues;
Var c : Integer;
Begin
 Query['ID'] := DModule.SingleValue('select main_seq.nextval from dual');
 c := getRandomColor;
 QUERY['COLOUR'] := c;
 Shape1.Brush.Color := c;
 if CON_ORGUNI_ID.Text <> '' then
   Query['ORGUNI_ID'] := CON_ORGUNI_ID.Text;
End;


procedure TFBrowseSUBJECTS.Shape1MouseUp(Sender: TObject;
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

procedure TFBrowseSUBJECTS.QueryBeforeEdit(DataSet: TDataSet);
begin
  inherited;
  Shape1.Brush.Color := QUERY.FieldByName('COLOUR').AsInteger;

end;

procedure TFBrowseSUBJECTS.GridDrawColumnCell(Sender: TObject;
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


Procedure TFBrowseSUBJECTS.CustomConditions;
Begin
 DM.macros.setMacro(query, 'CONPERMISSIONS', getWhereClause(tableName));

 if ttEnabledFlag.Checked then DM.macros.setMacro( Query, 'TTENABLED', '(SUBJECTS.ID IN (SELECT ID FROM TT_IDS WHERE TT_FOUND IS NOT NULL) OR (SELECT COUNT(1) FROM TT_IDS)=0)')
                      else DM.macros.setMacro( Query, 'TTENABLED', '0=0');

 If CON_ORGUNI_ID.Text = '' Then DM.macros.setMacro( Query, 'CON_ORGUNI_ID', '0=0')
                            Else DM.macros.setMacro( Query, 'CON_ORGUNI_ID', 'ORGUNI_ID IN ( SELECT ID FROM ORG_UNITS WHERE STRUCT_CODE LIKE '''+dmodule.singleValue('SELECT STRUCT_CODE FROM ORG_UNITS WHERE ID = '+CON_ORGUNI_ID.Text)+'%'')');

End;

procedure TFBrowseSUBJECTS.ttEnabledFlagClick(Sender: TObject);
begin
  BRefreshClick(nil);
end;

procedure TFBrowseSUBJECTS.FormShow(Sender: TObject);
begin
  inherited;

  with fprogramsettings do begin
   self.Caption           := fprogramsettings.profileObjectNameC1s.Text;
   //BChild1.Caption        := profileObjectNameClasses.Text;
   //BUpdChild1.Caption     := profileObjectNameClasses.Text;
   if profileType.ItemIndex <> 0 then begin
     BMassImport.Visible := false;
   end;
  end;

end;

procedure TFBrowseSUBJECTS.BMassImportClick(Sender: TObject);
begin
 dmodule.CommitTrans;
 FMain.RunMassImport(3); //SUB
 BRefreshClick(nil);
end;

procedure TFBrowseSUBJECTS.BUpdChild1Click(Sender: TObject);
begin
  AutoCreate.FIN_PARTIESShowModalAsBrowser( 'PLANSOFT:' + Query.fieldByName('ID').AsString );
end;

procedure TFBrowseSUBJECTS.BUpdChild2Click(Sender: TObject);
begin
  AutoCreate.CLASSESShowModalAsBrowser('CLASSES', '', '', '', '',Query['Id'],'','',false, true);
end;

procedure TFBrowseSUBJECTS.ORGUNI_IDChange(Sender: TObject);
begin
    DModule.RefreshLookupEdit(Self, TControl(Sender).Name,'NAME','ORG_UNITS','');
end;

procedure TFBrowseSUBJECTS.BSelectORGUNI_IDClick(Sender: TObject);
Var ID : ShortString;
begin
  ID := ORGUNI_ID.Text;
  //If AutoCreate.ORG_UNITSShowModalAsSelect(ID) = mrOK Then Query.FieldByName('ORGUNI_ID').AsString := ID;
  If LookupWindow(false, DModule.ADOConnection, 'ORG_UNITS','','SUBSTR(NAME ||'' (''||STRUCT_CODE||'')'',1,63)','NAZWA I KOD STRUKTURY','NAME','0=0','',ID) = mrOK Then Query.FieldByName('ORGUNI_ID').AsString := ID;
end;

procedure TFBrowseSUBJECTS.BClearORGUNI_IDClick(Sender: TObject);
begin
  Query.FieldByName('ORGUNI_ID').Clear;
end;

procedure TFBrowseSUBJECTS.CON_ORGUNI_IDChange(Sender: TObject);
begin
  If Trim(CON_ORGUNI_ID.TEXT) <> '' Then CON_ORGUNI_ID_VALUE.Text := DMOdule.SingleValue('SELECT NAME FROM ORG_UNITS WHERE ID='+CON_ORGUNI_ID.TEXT)
                                    Else CON_ORGUNI_ID_VALUE.Text := '';
  BRefreshClick(nil);
end;

procedure TFBrowseSUBJECTS.BSelOUClick(Sender: TObject);
Var ID : ShortString;
begin
  ID := CON_ORGUNI_ID.Text;
  If LookupWindow(false, DModule.ADOConnection, 'ORG_UNITS','','SUBSTR(NAME ||'' (''||STRUCT_CODE||'')'',1,63)','NAZWA I KOD STRUKTURY','NAME','0=0','',ID) = mrOK Then CON_ORGUNI_ID.Text := ID;
end;

procedure TFBrowseSUBJECTS.BitBtn6Click(Sender: TObject);
begin
  CON_ORGUNI_ID.Text := '';
end;

procedure TFBrowseSUBJECTS.CON_ORGUNI_ID_VALUEClick(Sender: TObject);
begin
  BSelOUClick(nil);
end;

procedure TFBrowseSUBJECTS.ORGUNI_ID_VALUEClick(Sender: TObject);
begin
  BSelectORGUNI_IDClick(nil);

end;

function TFBrowseSUBJECTS.getSearchFilter: string;
begin
 result := format(sql_SUB_SEARCH, [ replacePolishChars( ansiuppercase(trim(ESearch.Text)) ) ]);
end;

function TFBrowseSUBJECTS.getFindCaption: string;
begin
 Result := 'Dowolna fraza';
end;

function TFBrowseSUBJECTS.canDelete: Boolean;
begin
 result := isBlank(confineCalendarId);
end;

function TFBrowseSUBJECTS.canEditPermission: Boolean;
begin
 result := isBlank(confineCalendarId);
end;

function TFBrowseSUBJECTS.canInsert: Boolean;
begin
 result := isBlank(confineCalendarId);
end;

Procedure TFBrowseSUBJECTS.AfterPost;
Begin
 If CurrOperation in [AInsert,ACopy] Then begin
    FSharing.init('I','SUB',ID_.Text, QUERY.FieldByName('NAME').AsString);
    dmodule.CommitTrans;
 end;
End;


procedure TFBrowseSUBJECTS.BUpdChild3Click(Sender: TObject);
begin
   FSharing.init('U','SUB',ID_.Text, QUERY.FieldByName('NAME').AsString);
   dmodule.CommitTrans;
end;

procedure TFBrowseSUBJECTS.SpeedButton3Click(Sender: TObject);
begin
  info('Wpisz dowolne s³owa kluczowe w formacie "#ABD, #XYZ".'+cr+'Nastêpnie wyszukuj przemioty przez wpisanie #<s³owo kluczowe> w dowolnym miejscu w Aplikacji');
end;

procedure TFBrowseSUBJECTS.TimerDetailsTimer(Sender: TObject);
begin
  inherited;
  If Counter > 0 Then Counter := Counter - 1;
  If Counter = 1 Then refreshDetails;
end;

procedure TFBrowseSUBJECTS.QueryAfterScroll(DataSet: TDataSet);
begin
  Counter := 2;
end;

procedure TFBrowseSUBJECTS.FormCreate(Sender: TObject);
begin
  inherited;
  Counter := 3;
end;

procedure TFBrowseSUBJECTS.delete_str_elem(parent: boolean);
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

function TFBrowseSUBJECTS.getStrNameLov: shortString;
const str_name_lovs : array[0..2] of shortString = ('STREAM','ORG','OTHER');
begin
  if str_name_lov.ItemIndex = -1 then str_name_lov.ItemIndex := 0;
  result := str_name_lovs [ str_name_lov.ItemIndex ];
end;

procedure TFBrowseSUBJECTS.insert_str_elem(parent: boolean);
Var
    keyValues: ShortString;
    keyValue : ShortString;
    resultValue : string;
    mr : tmodalresult;
    pexclusive_parent : shortString;
    t : integer;
    currentParent : string;
begin
  mr := FExclusiveParent.showModal;
  if mr = mrYes then pexclusive_parent := '+';
  if mr = mrNo then  pexclusive_parent := '-';
  if (mr <> mrNo) and (mr <> mrYes) then exit;

  keyValue := '';
  If LookupWindow(True, DModule.ADOConnection, 'SUBJECTS SUB, SUB_PLA','SUB.ID','NAME','Nazwa','NAME','SUB_PLA.SUB_ID = SUB.ID AND PLA_ID = '+FMain.getUserOrRoleID,'',KeyValues,'500,100') = mrOK Then Begin

   {
   for t := 1 to wordCount(KeyValues, [',']) do begin
     KeyValue := extractWord(t,KeyValues, [',']);
     checkSQL := fmain.sqlCheckConflicts.Lines.Text;
     checkSQL := Replace(checkSQL,'%RESTYPE','GRO');
     checkSQL := Replace(checkSQL,':id1',keyValue);
     checkSQL := Replace(checkSQL,':id2',query.FieldByName('ID').asString);
     resultValue := dmodule.SingleValue(checkSQL);
     if (resultValue<>'') then begin
       info(KeyValue+': Nie mo¿na utworzyæ relacji, poniewa¿ spowodowa³aby ona konflikty: Przedmiot podrzêdny oraz przedmiot nadrzêdny maj¹ ju¿ zajêcia w tym samym czasie, o np. '+resultValue);
       Exit;
     End;
   end;
   }

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

procedure TFBrowseSUBJECTS.refreshDetails;
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

procedure TFBrowseSUBJECTS.str_name_lovChange(Sender: TObject);
begin
  refreshDetails;
end;

procedure TFBrowseSUBJECTS.AddParentClick(Sender: TObject);
begin
 insert_str_elem(true);
end;

procedure TFBrowseSUBJECTS.DelParentClick(Sender: TObject);
begin
  delete_str_elem(true);
end;

procedure TFBrowseSUBJECTS.AddDetailClick(Sender: TObject);
begin
 insert_str_elem(false);
end;

procedure TFBrowseSUBJECTS.delDetailClick(Sender: TObject);
begin
  delete_str_elem(false);
end;

procedure TFBrowseSUBJECTS.BMassEditClick(Sender: TObject);
begin

  With FMassUpdateSUB Do begin
    LCnt.Caption :=  IntToStr(Grid.SelectedRows.Count);
    mrYes.Enabled :=  Grid.SelectedRows.Count > 1;
    mrNo.Enabled :=  Grid.SelectedRows.Count > 1;
    if (execute(getSelectedIds)  ) then BRefreshClick(nil);
  End;
end;

end.
