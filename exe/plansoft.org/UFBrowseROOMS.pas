unit UFBrowseROOMS;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UFBrowseParent, ExtCtrls, StrHlder, Menus, Db, DBTables, RxQuery,
  ComCtrls, Grids, DBGrids, RXDBCtrl, StdCtrls, Buttons, Mask, DBCtrls, Ucommon,
  UFlex, ToolEdit, ImgList, ADODB, OleCtrls, SHDocVw, OleServer, ExcelXP;

type
  TFBrowseROOMS = class(TFBrowseParent)
    ID_: TDBEdit;
    LabelID: TLabel;
    NAME_: TDBEdit;
    LabelNAME: TLabel;
    LabelCOLOUR: TLabel;
    Shape1: TShape;
    ColorDialog: TColorDialog;
    Label2: TLabel;
    DESC1: TDBEdit;
    Label3: TLabel;
    DESC2: TDBEdit;
    CategoryLabel: TLabel;
    CON_RESCAT_ID: TEdit;
    CON_RESCAT_ID_VALUE: TEdit;
    BitBtn3: TBitBtn;
    ClearCategory: TBitBtn;
    LabelRESCAT_ID: TLabel;
    RESCAT_ID: TDBEdit;
    RESCAT_ID_VALUE: TEdit;
    BSelectRESCAT_ID: TBitBtn;
    BClearRESCAT_ID: TBitBtn;
    Splitter1: TSplitter;
    DSParents: TDataSource;
    DSDetails: TDataSource;
    TimerDetails: TTimer;
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
    Label5: TLabel;
    str_name_lov: TComboBox;
    QParents: TADOQuery;
    QDetails: TADOQuery;
    ttEnabled: TCheckBox;
    GroupGeolocation: TGroupBox;
    google_location: TDBEdit;
    google_locationHelp: TBitBtn;
    GoogleMapPanel: TGroupBox;
    WebBrowser1: TWebBrowser;
    btools: TBitBtn;
    ToolsPopup: TPopupMenu;
    BMassImport: TMenuItem;
    Scalaj1: TMenuItem;
    UtwrzmapGooglezzasobami1: TMenuItem;
    LabelORGUNI_ID: TLabel;
    ORGUNI_ID: TDBEdit;
    ORGUNI_ID_VALUE: TEdit;
    BSelectORGUNI_ID: TBitBtn;
    Label1: TLabel;
    CON_ORGUNI_ID: TEdit;
    CON_ORGUNI_ID_VALUE: TEdit;
    BSelOU: TBitBtn;
    BitBtn2: TBitBtn;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    procedure Shape1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure QueryBeforeEdit(DataSet: TDataSet);
    procedure GridDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure CON_RESCAT_IDChange(Sender: TObject);
    procedure CON_RESCAT_ID_VALUEDblClick(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure ClearCategoryClick(Sender: TObject);
    procedure RESCAT_IDChange(Sender: TObject);
    procedure BSelectRESCAT_IDClick(Sender: TObject);
    procedure BClearRESCAT_IDClick(Sender: TObject);
    procedure RESCAT_ID_VALUEDblClick(Sender: TObject);
    procedure QueryAfterScroll(DataSet: TDataSet);
    procedure FormCreate(Sender: TObject);
    procedure TimerDetailsTimer(Sender: TObject);
    procedure xflexClick(Sender: TObject);
    procedure AddDetailClick(Sender: TObject);
    procedure DelParentClick(Sender: TObject);
    procedure delDetailClick(Sender: TObject);
    procedure str_name_lovChange(Sender: TObject);
    procedure RightPageMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure BUpdChild1Click(Sender: TObject);
    procedure ttEnabledClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BUpdChild2Click(Sender: TObject);
    procedure google_locationChange(Sender: TObject);
    procedure google_locationHelpClick(Sender: TObject);
    procedure google_locationEnter(Sender: TObject);
    procedure google_locationExit(Sender: TObject);
    procedure btoolsClick(Sender: TObject);
    procedure BMassImportClick(Sender: TObject);
    procedure Scalaj1Click(Sender: TObject);
    procedure UtwrzmapGooglezzasobami1Click(Sender: TObject);
    procedure ORGUNI_IDChange(Sender: TObject);
    procedure ORGUNI_ID_VALUEClick(Sender: TObject);
    procedure BSelectORGUNI_IDClick(Sender: TObject);
    procedure CON_ORGUNI_IDChange(Sender: TObject);
    procedure CON_ORGUNI_ID_VALUEClick(Sender: TObject);
    procedure BSelOUClick(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure CON_RESCAT_ID_VALUEClick(Sender: TObject);
    procedure BUpdChild3Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
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
    Procedure EditClick;             override;
    procedure flexSetContextNameInListView; override;
    procedure flexSetContextNameInFormView; override;
    Function  getSearchFilter : string;  override;
   function  getFindCaption : string;   override;
    Function  canEditPermission : Boolean;   override;
    Function  canInsert    : Boolean;        override;
    Function  canDelete    : Boolean;        override;  end;

var
  FBrowseROOMS: TFBrowseROOMS;

implementation

{$R *.DFM}


uses DM, UUtilityParent, autoCreate, UFMain, uflookupWindow, UFMassImport,
  UFProgramSettings, UFSharing, UFExclusiveParent;

procedure TFBrowseROOMS.FormCreate(Sender: TObject);
begin
  Counter := 3;
  inherited;
end;

Function  TFBrowseROOMS.CheckRecord : Boolean;
Begin
  Result := CheckValid.ReducRestrictEmpty(Self, [NAME_, RESCAT_ID, ORGUNI_ID]);
End;

Procedure TFBrowseROOMS.DefaultValues;
Var c : Integer;
Begin
 Query['ID'] := DModule.SingleValue('select main_seq.nextval from dual');
 //Query['google_location'] := '52.173879,21.052895';
 Query.FieldByName('RESCAT_ID').AsString := CON_RESCAT_ID.Text;
 if CON_ORGUNI_ID.Text <> '' then
   Query['ORGUNI_ID'] := CON_ORGUNI_ID.Text;
 c := Random(256) + 256*Random(256) + 256*256*Random(256);
 QUERY['COLOUR'] := c;
 Shape1.Brush.Color := c;

 //since context field is RESCAT_ID  inherited has to be called after
 inherited;
End;

procedure TFBrowseROOMS.Shape1MouseUp(Sender: TObject;
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

procedure TFBrowseROOMS.QueryBeforeEdit(DataSet: TDataSet);
begin
  inherited;
  Shape1.Brush.Color := QUERY.FieldByName('COLOUR').AsInteger;
end;

procedure TFBrowseROOMS.GridDrawColumnCell(Sender: TObject;
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

Procedure TFBrowseROOMS.CustomConditions;
Begin
 DM.macros.setMacro(query, 'CONPERMISSIONS', getWhereClause(tableName));
 DM.macros.setMacro(query, 'AVAILABLE', available);

 if ttEnabled.Checked then DM.macros.setMacro( Query, 'TTENABLED', '(ROOMS.ID IN (SELECT  ID FROM TT_IDS WHERE TT_FOUND IS NOT NULL) OR (SELECT COUNT(1) FROM TT_IDS)=0)')
                      else DM.macros.setMacro( Query, 'TTENABLED', '0=0');

 If CON_RESCAT_ID.Text = '' Then DM.macros.setMacro(query, 'CON_RESCAT_ID', '0=0')
                            Else DM.macros.setMacro(query, 'CON_RESCAT_ID', 'RESCAT_ID ='+CON_RESCAT_ID.Text);

 If CON_ORGUNI_ID.Text = '' Then DM.macros.setMacro( Query, 'CON_ORGUNI_ID', '0=0')
                            Else DM.macros.setMacro( Query, 'CON_ORGUNI_ID', 'ORGUNI_ID IN ( SELECT ID FROM ORG_UNITS WHERE STRUCT_CODE LIKE '''+dmodule.singleValue('SELECT STRUCT_CODE FROM ORG_UNITS WHERE ID = '+CON_ORGUNI_ID.Text)+'%'')');

End;

procedure TFBrowseROOMS.CON_RESCAT_IDChange(Sender: TObject);
begin
  inherited;
  If Trim(CON_RESCAT_ID.TEXT) <> '' Then CON_RESCAT_ID_VALUE.Text := DMOdule.SingleValue('SELECT NAME FROM RESOURCE_CATEGORIES WHERE ID='+CON_RESCAT_ID.TEXT)
                                    Else CON_RESCAT_ID_VALUE.Text := '';
  BRefreshClick(nil);
end;

procedure TFBrowseROOMS.CON_RESCAT_ID_VALUEDblClick(Sender: TObject);
begin
  inherited;
 BitBtn3Click(nil);
end;

procedure TFBrowseROOMS.BitBtn3Click(Sender: TObject);
Var ID : ShortString;
begin
  ID := CON_RESCAT_ID.Text;
  If AutoCreate.RESOURCE_CATEGORIESShowModalAsSelect(ID) = mrOK Then CON_RESCAT_ID.Text := ID;
end;

procedure TFBrowseROOMS.ClearCategoryClick(Sender: TObject);
begin
  CON_RESCAT_ID.Text := '';
end;

procedure TFBrowseROOMS.RESCAT_IDChange(Sender: TObject);
begin
    DModule.RefreshLookupEdit(Self, TControl(Sender).Name,'NAME','RESOURCE_CATEGORIES','');
  //this event is called redundately, in particular when window is in browse records mode
  // as a result there are performance issues, moreover procedure setFlexContextNameInFormView is called and context has wrong value
  //this condition causes that redundant callings are ignored
  if MainPage.ActivePage.Name = 'Update' then begin
    flexRefreshFormView;
  end;
end;

procedure TFBrowseROOMS.BSelectRESCAT_IDClick(Sender: TObject);
Var ID : ShortString;
begin
  ID := RESCAT_ID.Text;
  If AutoCreate.RESOURCE_CATEGORIESShowModalAsSelect(ID) = mrOK Then Query.FieldByName('RESCAT_ID').AsString := ID;
end;

procedure TFBrowseROOMS.BClearRESCAT_IDClick(Sender: TObject);
begin
  inherited;
 Query.FieldByName('RESCAT_ID').Clear;
end;

procedure TFBrowseROOMS.RESCAT_ID_VALUEDblClick(Sender: TObject);
begin
  inherited;
  BSelectRESCAT_IDClick(nil);
end;

procedure TFBrowseROOMS.QueryAfterScroll(DataSet: TDataSet);
begin
  Counter := 2;
end;

function TFBrowseROOMS.getStrNameLov : shortString;
const str_name_lovs : array[0..2] of shortString = ('STREAM','ORG','OTHER');
begin
  if str_name_lov.ItemIndex = -1 then str_name_lov.ItemIndex := 0;
  result := str_name_lovs [ str_name_lov.ItemIndex ];
end;


procedure TFBrowseROOMS.refreshDetails;
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

procedure TFBrowseROOMS.TimerDetailsTimer(Sender: TObject);
begin
  inherited;
  If Counter > 0 Then Counter := Counter - 1;
  If Counter = 1 Then refreshDetails;
end;

procedure TFBrowseROOMS.insert_str_elem(parent : boolean);
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
  If LookupWindow(True, DModule.ADOConnection, 'ROOMS ROM, ROM_PLA','ROM.ID', sql_ResCat0NAME +', attribn_01','Zasób,Pojemnoœæ','NAME','ROM_PLA.ROM_ID = ROM.ID AND PLA_ID = '+FMain.getUserOrRoleID,'',KeyValues,'500,100') = mrOK Then Begin

   for t := 1 to wordCount(KeyValues, [',']) do begin
     KeyValue := extractWord(t,KeyValues, [',']);
     checkSQL := fmain.sqlCheckConflicts.Lines.Text;
     checkSQL := Replace(checkSQL,'%RESTYPE','ROM');
     checkSQL := Replace(checkSQL,':id1',keyValue);
     checkSQL := Replace(checkSQL,':id2',query.FieldByName('ID').asString);
     resultValue := dmodule.SingleValue(checkSQL);
     if (resultValue<>'') then begin
       info(KeyValue+': Nie mo¿na utworzyæ relacji, poniewa¿ spowodowa³aby ona konflikty: Zasób podrzêdny oraz zasób nadrzêdny maj¹ ju¿ zajêcia w tym samym czasie, o np. '+resultValue);
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
        Parameters.ParamByName('pparent_id').value   := query.FieldByName('ID').asString;
        currentParent := query.FieldByName('ID').asString;
      end;
      Parameters.ParamByName('pexclusive_parent').value     := pexclusive_parent;
      Parameters.ParamByName('pstr_name_lov').value := getStrNameLov;
      execSQL;
    end;
    fmain.propagateDependencyChanges(currentParent, 'R');
   end;
   resultValue := dmodule.SingleValue('select planner_utils.get_output_param_char1 from dual');
   if resultValue <> '' then info (resultValue) else refreshDetails;
  end;
end;


procedure TFBrowseROOMS.xflexClick(Sender: TObject);
begin
 insert_str_elem(true);
end;

procedure TFBrowseROOMS.AddDetailClick(Sender: TObject);
begin
 insert_str_elem(false);
end;

procedure TFBrowseROOMS.delete_str_elem(parent : boolean);
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

procedure TFBrowseROOMS.DelParentClick(Sender: TObject);
begin
  delete_str_elem(true);
end;

procedure TFBrowseROOMS.delDetailClick(Sender: TObject);
begin
  delete_str_elem(false);
end;

procedure TFBrowseROOMS.str_name_lovChange(Sender: TObject);
begin
  inherited;
  refreshDetails;
end;

procedure TFBrowseROOMS.deleteClick;
begin
  if activeControl = GParents then begin delete_str_elem(true);  exit; end;
  if activeControl = Gdetails then begin delete_str_elem(false); exit; end;
  inherited;
end;

procedure TFBrowseROOMS.AddClick;
begin
  if activeControl = GParents then begin insert_str_elem(true);  exit; end;
  if activeControl = Gdetails then begin insert_str_elem(false); exit; end;
  inherited;
end;

procedure TFBrowseROOMS.EditClick;
begin
  inherited;
end;

procedure TFBrowseROOMS.flexSetContextNameInListView;
begin
  flexContextName := nvl(CON_RESCAT_ID_VALUE.text,'DEFAULT');
end;

procedure TFBrowseROOMS.flexSetContextNameInFormView;
begin
  flexContextName := nvl(RESCAT_ID_VALUE.text,'DEFAULT');
end;


procedure TFBrowseROOMS.RightPageMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if RightPage.Width < 430
    then RightPage.Width := 430
    else RightPage.Width := 24;

end;

procedure TFBrowseROOMS.BUpdChild1Click(Sender: TObject);
begin
  AutoCreate.CLASSESShowModalAsBrowser('CLASSES', '','', Query['Id'], '','','','',false);
end;

procedure TFBrowseROOMS.ttEnabledClick(Sender: TObject);
begin
  BRefreshClick(nil);
end;

procedure TFBrowseROOMS.FormShow(Sender: TObject);
begin
  inherited;
  with fprogramsettings do begin
   BChild1.Caption        := profileObjectNameClasses.Text;
   BUpdChild1.Caption     := profileObjectNameClasses.Text;
   if profileType.ItemIndex <> 0 then begin
     //@@@hardcoding
     BMassImport.Visible := false;
   end;
  end;
  google_locationExit(nil);
end;

procedure TFBrowseROOMS.BUpdChild2Click(Sender: TObject);
begin
  AutoCreate.FIN_PARTIESShowModalAsBrowser( 'PLANSOFT:' + Query.fieldByName('ID').AsString );
end;

procedure TFBrowseROOMS.google_locationChange(Sender: TObject);
begin
 if activeControl = google_location then google_locationEnter(nil);
end;

procedure TFBrowseROOMS.google_locationHelpClick(Sender: TObject);
begin
  inherited;
  info ('U¿yj strony, której link w³aœnie zosta³ skopiowany do schowka, aby znaleŸæ po³o¿enie zasobu na mapie. Skopiuj link do przegl¹darki');

  //info(
  //  'W tym polu mo¿esz wpisaæ po³o¿enie zasobu na mapie.'+cr+
  //  ''+cr+
  //  'Informacja ta zostanie automatycznie przeniesiona do kalendarza Google.'+cr+
  //  'Nie wiesz jak znaleŸæ d³ugoœæ i szerokoœæ geograficzn¹ ?'+cr+
  //  'Zajrzyj tutaj:  http://support.google.com/maps/bin/answer.py?hl=pl&answer=18539'+cr+
  //  ''+cr+
  //  ''+cr+
  //  'Warto zaznaczyæ, ¿e je¿eli podamy miejsce prowadzenia zajêæ w sposób naturalny ( miejscowoœæ, ulica ), to miejsce'+cr+
  //  'równie¿ zostanie pokazane na mapie po wyeksportowaniu danych do Google Kalendarz');

  copyToClipboard('http://www.latlong.net/');
end;

procedure TFBrowseROOMS.google_locationEnter(Sender: TObject);
var
  Flags: OLEVariant;
  tmpFile : textfile;
begin
  if google_location.text <> '' then begin
  GoogleMapPanel.Visible := true;

  Flags := 0;
  AssignFile(tmpFile,  uutilityParent.ApplicationDocumentsPath +'tmpgooglemaps.html');
  rewrite(tmpFile);
  writeln(tmpFile, '<iframe width="320" height="320" frameborder="0" scrolling="no" marginheight="0" marginwidth="0" src="https://maps.google.pl/maps?q='+google_location.text+'&amp;ie=UTF8&amp;t=m&amp;'+'ll='+google_location.text+'&amp;spn=0.000493,0.000804&amp;z=14&amp;output=embed"></iframe><br />');
  //'<small><a href="https://maps.google.pl/maps?q='+google_location.text+'&amp;ie=UTF8&amp;t=m&amp;ll='+google_location.text+'&amp;spn=0.000987,0.001609&amp;z=18&amp;source=embed" style="color:#0000FF;text-align:left">Poka¿ wiêksz¹ mapê</a></small>');
  closeFile(tmpFile);

  if not assigned(WebBrowser1) then WebBrowser1 := TWebBrowser.Create(self);

  TWinControl(WebBrowser1).Name := 'WebBrowser1';
  TWinControl(WebBrowser1).Parent := GoogleMapPanel;

  WebBrowser1.Left     := 2;
  WebBrowser1.Top      := 16;
  WebBrowser1.Width    := 373;
  WebBrowser1.Height   := 359;
  WebBrowser1.Align    := alClient;
  WebBrowser1.TabOrder := 0;
  WebBrowser1.Visible  := true;
  WebBrowser1.Silent := True;

  WebBrowser1.Navigate(WideString(uutilityParent.ApplicationDocumentsPath +'tmpgooglemaps.html'), Flags, Flags, Flags, Flags);
  end;
end;

procedure TFBrowseROOMS.google_locationExit(Sender: TObject);
begin
  inherited;
  GoogleMapPanel.Visible := false;
  if assigned(WebBrowser1) then begin
    WebBrowser1.Stop;
    WebBrowser1.Free;
    WebBrowser1 := nil;
  end;
end;

procedure TFBrowseROOMS.btoolsClick(Sender: TObject);
var point : tpoint;
    btn   : tcontrol;
begin
 btn     := sender as tcontrol;
 Point.x := 0;
 Point.y := btn.Height;
 Point   := btn.ClientToScreen(Point);
 if btn.Name = 'btools'       then ToolsPopup.Popup(Point.X,Point.Y);
end;

procedure TFBrowseROOMS.BMassImportClick(Sender: TObject);
begin
 dmodule.CommitTrans;
 FMain.RunMassImport(2); //ROM
 BRefreshClick(nil);
end;

procedure TFBrowseROOMS.Scalaj1Click(Sender: TObject);
begin
  CONSOLIDATIONShowModalAsBrowser(2);
end;

procedure TFBrowseROOMS.UtwrzmapGooglezzasobami1Click(Sender: TObject);
begin
  fmain.GoogleMapEasyClick(nil);
end;

procedure TFBrowseROOMS.ORGUNI_IDChange(Sender: TObject);
begin
    DModule.RefreshLookupEdit(Self, TControl(Sender).Name,'NAME','ORG_UNITS','');
end;

procedure TFBrowseROOMS.ORGUNI_ID_VALUEClick(Sender: TObject);
begin
  BSelectORGUNI_IDClick( nil );
end;

procedure TFBrowseROOMS.BSelectORGUNI_IDClick(Sender: TObject);
Var ID : ShortString;
begin
  ID := ORGUNI_ID.Text;
  //If AutoCreate.ORG_UNITSShowModalAsSelect(ID) = mrOK Then Query.FieldByName('ORGUNI_ID').AsString := ID;
  If LookupWindow(false, DModule.ADOConnection, 'ORG_UNITS','','SUBSTR(NAME ||'' (''||STRUCT_CODE||'')'',1,63)','NAZWA I KOD STRUKTURY','NAME','0=0','',ID) = mrOK Then Query.FieldByName('ORGUNI_ID').AsString := ID;
end;

procedure TFBrowseROOMS.CON_ORGUNI_IDChange(Sender: TObject);
begin
  If Trim(CON_ORGUNI_ID.TEXT) <> '' Then CON_ORGUNI_ID_VALUE.Text := DMOdule.SingleValue('SELECT NAME FROM ORG_UNITS WHERE ID='+CON_ORGUNI_ID.TEXT)
                                    Else CON_ORGUNI_ID_VALUE.Text := '';
  BRefreshClick(nil);
end;

procedure TFBrowseROOMS.CON_ORGUNI_ID_VALUEClick(Sender: TObject);
begin
  BSelOUClick( nil );
end;

procedure TFBrowseROOMS.BSelOUClick(Sender: TObject);
Var ID : ShortString;
begin
  ID := CON_ORGUNI_ID.Text;
  If LookupWindow(false, DModule.ADOConnection, 'ORG_UNITS','','SUBSTR(NAME ||'' (''||STRUCT_CODE||'')'',1,63)','NAZWA I KOD STRUKTURY','NAME','0=0','',ID) = mrOK Then CON_ORGUNI_ID.Text := ID;
end;

procedure TFBrowseROOMS.BitBtn2Click(Sender: TObject);
begin
  CON_ORGUNI_ID.Text := '';
end;

procedure TFBrowseROOMS.CON_RESCAT_ID_VALUEClick(Sender: TObject);
begin
  BitBtn3Click(nil);

end;

function TFBrowseROOMS.getSearchFilter: string;
begin
 result := '(xxmsz_tools.erasePolishChars(upper(org_units.name||rooms.name||rooms.desc1||rooms.desc2||rooms.attribs_01||rooms.email||rooms.attribs_01||rooms.attribs_02||rooms.attribs_03||rooms.attribs_04||rooms.attribs_05||rooms.attribs_06'+
           '||rooms.attribs_07||rooms.attribs_08||rooms.attribs_09||rooms.attribs_10||rooms.attribs_11||rooms.attribs_12||rooms.attribs_13||rooms.attribs_14||rooms.attribs_15)) like ''%'+replacePolishChars( ansiuppercase(trim(ESearch.Text)) )+'%'''+
           ' OR ''#''||xxmsz_tools.erasePolishChars(upper(rooms.attribs_01)) like '''+replacePolishChars(ansiuppercase(trim(ESearch.Text)) )+'%'')';
           copyToClipboard(result);
end;

function TFBrowseROOMS.getFindCaption: string;
begin
 Result := 'Dowolna fraza';
end;

function TFBrowseROOMS.canDelete: Boolean;
begin
 result := isBlank(confineCalendarId);
end;

function TFBrowseROOMS.canEditPermission: Boolean;
begin
 result := isBlank(confineCalendarId);
end;

function TFBrowseROOMS.canInsert: Boolean;
begin
 result := isBlank(confineCalendarId);
end;

Procedure TFBrowseROOMS.AfterPost;
Begin
 If CurrOperation in [AInsert,ACopy] Then begin
    FSharing.init('I','ROM',ID_.Text, QUERY.FieldByName('NAME').AsString);
    dmodule.CommitTrans;
 end;
End;

procedure TFBrowseROOMS.BUpdChild3Click(Sender: TObject);
begin
   FSharing.init('U','ROM',ID_.Text, QUERY.FieldByName('NAME').AsString);
   dmodule.CommitTrans;
end;

procedure TFBrowseROOMS.SpeedButton1Click(Sender: TObject);
begin
  info('Wpisz dowolne s³owa kluczowe w formacie "#ABD, #XYZ".'+cr+'Nastêpnie wyszukuj sale przez wpisanie #<s³owo kluczowe> w dowolnym miejscu w Aplikacji');
end;

procedure TFBrowseROOMS.SpeedButton2Click(Sender: TObject);
begin
  info('Wpisz wyposa¿enie w formacie "#Rzutnik, #Spetrometr".'+cr+'Nastêpnie wyszukuj sale przez wpisanie #<nazwa wyposazenia> w dowolnym miejscu w Aplikacji');
end;

end.
