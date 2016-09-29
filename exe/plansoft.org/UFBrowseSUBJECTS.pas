unit UFBrowseSUBJECTS;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UFBrowseParent, ExtCtrls, StrHlder, Menus, Db, DBTables, RxQuery,
  ComCtrls, Grids, DBGrids, RXDBCtrl, StdCtrls, Buttons, Mask, DBCtrls,
  ToolEdit, ImgList, ADODB, OleServer, ExcelXP, UFLookupWindow;

type
  TFBrowseSUBJECTS = class(TFBrowseParent)
    ID: TDBEdit;
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
    ttEnabled: TCheckBox;
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
    procedure Shape1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure QueryBeforeEdit(DataSet: TDataSet);
    procedure GridDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure ttEnabledClick(Sender: TObject);
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
  private
    { Private declarations }
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

uses DM, UUtilityParent, UFMain, UCommon, UFProgramSettings, UFMassImport, AutoCreate;

Function  TFBrowseSUBJECTS.CheckRecord : Boolean;
Begin
  Result := CheckValid.ReducRestrictEmpty(Self, [ABBREVIATION, NAME, ORGUNI_ID]);
End;

Procedure TFBrowseSUBJECTS.DefaultValues;
Var c : Integer;
Begin
 Query['ID'] := DModule.SingleValue('select main_seq.nextval from dual');
 c := Random(256) + 256*Random(256) + 256*256*Random(256);
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

 if ttEnabled.Checked then DM.macros.setMacro( Query, 'TTENABLED', '(SUBJECTS.ID IN (SELECT ID FROM TT_IDS WHERE TT_FOUND IS NOT NULL) OR (SELECT COUNT(1) FROM TT_IDS)=0)')
                      else DM.macros.setMacro( Query, 'TTENABLED', '0=0');

 If CON_ORGUNI_ID.Text = '' Then DM.macros.setMacro( Query, 'CON_ORGUNI_ID', '0=0')
                            Else DM.macros.setMacro( Query, 'CON_ORGUNI_ID', 'ORGUNI_ID IN ( SELECT ID FROM ORG_UNITS WHERE STRUCT_CODE LIKE '''+dmodule.singleValue('SELECT STRUCT_CODE FROM ORG_UNITS WHERE ID = '+CON_ORGUNI_ID.Text)+'%'')');

End;

Procedure TFBrowseSUBJECTS.AfterPost;
Begin
 If CurrOperation in [AInsert,ACopy] Then begin
   DModule.SQL('INSERT INTO SUB_PLA (ID, PLA_ID, SUB_ID) VALUES (SUBPLA_SEQ.NEXTVAL, '+IntToStr(UserID)+','+ID.Text+')');

   if not strIsEmpty(FMain.CONROLE.Text) then begin
     DModule.SQL('INSERT INTO SUB_PLA (ID, PLA_ID, SUB_ID) VALUES (SUBPLA_SEQ.NEXTVAL, '+FMain.CONROLE.Text+','+ID.Text+')');
   end;

   dmodule.CommitTrans;
 end;
End;


procedure TFBrowseSUBJECTS.ttEnabledClick(Sender: TObject);
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
 FMain.massImportClick(nil);
 BRefreshClick(nil);
end;

procedure TFBrowseSUBJECTS.BUpdChild1Click(Sender: TObject);
begin
  AutoCreate.FIN_PARTIESShowModalAsBrowser( 'PLANSOFT:' + Query.fieldByName('ID').AsString );
end;

procedure TFBrowseSUBJECTS.BUpdChild2Click(Sender: TObject);
begin
  AutoCreate.CLASSESShowModalAsBrowser('CLASSES', '', '', '', '',Query['Id'],'','',false);
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
  If LookupWindow(DModule.ADOConnection, 'ORG_UNITS','','SUBSTR(NAME ||'' (''||STRUCT_CODE||'')'',1,63)','NAZWA I KOD STRUKTURY','NAME','0=0','',ID) = mrOK Then Query.FieldByName('ORGUNI_ID').AsString := ID;
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
  If LookupWindow(DModule.ADOConnection, 'ORG_UNITS','','SUBSTR(NAME ||'' (''||STRUCT_CODE||'')'',1,63)','NAZWA I KOD STRUKTURY','NAME','0=0','',ID) = mrOK Then CON_ORGUNI_ID.Text := ID;
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
 result := '(xxmsz_tools.erasePolishChars(upper(org_units.name||subjects.abbreviation||subjects.desc1||subjects.desc2||subjects.name|| subjects.attribs_01||subjects.attribs_02||subjects.attribs_03||subjects.attribs_04||subjects.attribs_05'+
           '||subjects.attribs_06||subjects.attribs_07||subjects.attribs_08||subjects.attribs_09||subjects.attribs_10||subjects.attribs_11||subjects.attribs_12||subjects.attribs_13||subjects.attribs_14||subjects.attribs_15)) like ''%'+replacePolishChars( ansiuppercase(trim(ESearch.Text)) )+'%'')';
end;

function TFBrowseSUBJECTS.getFindCaption: string;
begin
 Result := 'Dowolna fraza';
end;

function TFBrowseSUBJECTS.canDelete: Boolean;
begin
 result := strIsEmpty(confineCalendarId);
end;

function TFBrowseSUBJECTS.canEditPermission: Boolean;
begin
 result := strIsEmpty(confineCalendarId);
end;

function TFBrowseSUBJECTS.canInsert: Boolean;
begin
 result := strIsEmpty(confineCalendarId);
end;

end.
