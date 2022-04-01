unit uFBrowseFORMS;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UFBrowseParent, ExtCtrls, StrHlder, Menus, Db, DBTables, RxQuery,
  ComCtrls, Grids, DBGrids, RXDBCtrl, StdCtrls, Buttons, Mask, DBCtrls,
  ToolEdit, ImgList, ADODB, OleServer, ExcelXP;

type
  TFBrowseFORMS = class(TFBrowseParent)
    ID: TDBEdit;
    LabelID: TLabel;
    ABBREVIATION: TDBEdit;
    LabelABBREVIATION: TLabel;
    NAME: TDBEdit;
    LabelNAME: TLabel;
    kind: TDBRadioGroup;
    LSortDesc2: TLabel;
    SORT_ORDER_ON_REPORTS: TDBEdit;
    Label3: TLabel;
    LSortDesc1: TLabel;
    Label5: TLabel;
    CON_TYPE_ID: TEdit;
    CON_TYPE_ID_VALUE: TEdit;
    BC: TBitBtn;
    BR: TBitBtn;
    BALL: TBitBtn;
    BitBtn3: TBitBtn;
    Shape1: TShape;
    LabelCOLOUR: TLabel;
    ColorDialog: TColorDialog;
    ttEnabled: TCheckBox;
    BMassImport: TBitBtn;
    Label2: TLabel;
    DESC1: TDBEdit;
    Label1: TLabel;
    DESC2: TDBEdit;
    procedure CON_TYPE_IDChange(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure CON_TYPE_ID_VALUEDblClick(Sender: TObject);
    procedure BCClick(Sender: TObject);
    procedure BRClick(Sender: TObject);
    procedure BALLClick(Sender: TObject);
    procedure Shape1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure QueryBeforeEdit(DataSet: TDataSet);
    procedure GridDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure ttEnabledClick(Sender: TObject);
    procedure BMassImportClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BUpdChild1Click(Sender: TObject);
    procedure BUpdChild2Click(Sender: TObject);
    procedure BUpdChild3Click(Sender: TObject);
  private
    { Private declarations }
  public
    Function  CheckRecord : Boolean; override;
    Procedure DefaultValues; override;
    Procedure CustomConditions; override;
    Procedure AfterPost; override;
    Function  canEditPermission : Boolean;   override;
    Function  canInsert    : Boolean;        override;
    Function  canDelete    : Boolean;        override;
    Function  getSearchFilter : string;  override;
    function getFindCaption: string;    override;
  end;

var
  FBrowseFORMS: TFBrowseFORMS;

implementation

uses DM, UUtilityParent, UCommon, UFMain, ufLookupWindow, UFMassImport,
  UFProgramSettings, AutoCreate, UFSharing;

{$R *.DFM}

Function  TFBrowseFORMS.CheckRecord : Boolean;
Begin
  Result := CheckValid.ReducRestrictEmpty(Self, [ ABBREVIATION, KIND ]);
End;

Procedure TFBrowseFORMS.DefaultValues;
Var c : Integer;
Begin
 Query['ID'] := DModule.SingleValue('select main_seq.nextval from dual');
 Query['KIND'] :=  CON_TYPE_ID.text;
 c := getRandomColor;
 QUERY['COLOUR'] := c;
 Shape1.Brush.Color := c;
End;

Procedure TFBrowseFORMS.CustomConditions;
Begin
 DM.macros.setMacro(query, 'CONPERMISSIONS', getWhereClause(tableName));

 if ttEnabled.Checked then DM.macros.setMacro( Query, 'TTENABLED', '(FORMS.ID IN (SELECT  ID FROM TT_IDS WHERE TT_FOUND IS NOT NULL) OR (SELECT COUNT(1) FROM TT_IDS)=0)')
                      else DM.macros.setMacro( Query, 'TTENABLED', '0=0');

 If CON_TYPE_ID.Text = '' Then DM.macros.setMacro(query, 'CON_TYPE', '0=0')
                          Else DM.macros.setMacro(query, 'CON_TYPE', 'KIND = ''' + CON_TYPE_ID.Text + '''');
End;


procedure TFBrowseFORMS.CON_TYPE_IDChange(Sender: TObject);
begin
  inherited;
  If Trim(CON_TYPE_ID.TEXT) <> '' Then CON_TYPE_ID_VALUE.Text := DMOdule.SingleValue('SELECT MEANING FROM LOOKUPS WHERE LOOKUP_TYPE=''FORM_TYPE'' AND CODE='''+CON_TYPE_ID.TEXT+'''')
                                  Else CON_TYPE_ID_VALUE.Text := 'Wszystkie';
  BRefreshClick(nil);
end;

procedure TFBrowseFORMS.BitBtn3Click(Sender: TObject);
Var ID : ShortString;
begin
  ID := CON_TYPE_ID.Text;
  If LookupWindow(false, DModule.ADOConnection, 'LOOKUPS','CODE','MEANING','TYP','NAME','LOOKUP_TYPE=''FORM_TYPE''','',ID) = mrOK Then CON_TYPE_ID.Text := ID;
end;

procedure TFBrowseFORMS.CON_TYPE_ID_VALUEDblClick(Sender: TObject);
begin
  if BitBtn3.Enabled then BitBtn3Click( nil );
end;

procedure TFBrowseFORMS.BCClick(Sender: TObject);
begin
  CON_TYPE_ID.Text := 'C';
end;

procedure TFBrowseFORMS.BRClick(Sender: TObject);
begin
  CON_TYPE_ID.Text := 'R';
end;

procedure TFBrowseFORMS.BALLClick(Sender: TObject);
begin
  CON_TYPE_ID.Text := '';
end;

procedure TFBrowseFORMS.Shape1MouseUp(Sender: TObject;
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

procedure TFBrowseFORMS.QueryBeforeEdit(DataSet: TDataSet);
begin
  inherited;
  Shape1.Brush.Color := QUERY.FieldByName('COLOUR').AsInteger;
end;

procedure TFBrowseFORMS.GridDrawColumnCell(Sender: TObject;
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

procedure TFBrowseFORMS.ttEnabledClick(Sender: TObject);
begin
  BRefreshClick(nil);
end;

procedure TFBrowseFORMS.BMassImportClick(Sender: TObject);
begin
 dmodule.CommitTrans;
 FMain.RunMassImport(4); //FOR
 BRefreshClick(nil);
end;

procedure TFBrowseFORMS.FormShow(Sender: TObject);
begin
  inherited;
  with fprogramsettings do begin
   self.Caption           := fprogramsettings.profileObjectNameC2s.Text;
   //BChild1.Caption        := profileObjectNameClasses.Text;
   //BUpdChild1.Caption     := profileObjectNameClasses.Text;
   if profileType.ItemIndex <> 0 then begin
     BMassImport.Visible := false;
     LSortDesc1.Visible  := false;
     BC.Caption          := profileObjectNameC2.Text;
     kind.Items[0]       := profileObjectNameC2.Text;
   end;
  end;

end;

procedure TFBrowseFORMS.BUpdChild1Click(Sender: TObject);
begin
  AutoCreate.FIN_PARTIESShowModalAsBrowser( 'PLANSOFT:' + Query.fieldByName('ID').AsString );
end;

procedure TFBrowseFORMS.BUpdChild2Click(Sender: TObject);
begin
  AutoCreate.CLASSESShowModalAsBrowser('CLASSES', '', '', '', '','',Query['Id'],'',false);
end;

function TFBrowseFORMS.canDelete: Boolean;
begin
 result := isBlank(confineCalendarId);
end;

function TFBrowseFORMS.canEditPermission: Boolean;
begin
 result := isBlank(confineCalendarId);
end;

function TFBrowseFORMS.canInsert: Boolean;
begin
 result := isBlank(confineCalendarId);
end;

Procedure TFBrowseFORMS.AfterPost;
Begin
 If CurrOperation in [AInsert,ACopy] Then begin
    FSharing.init('I','FOR',ID.Text, QUERY.FieldByName('NAME').AsString);
    dmodule.CommitTrans;
 end;
End;


procedure TFBrowseFORMS.BUpdChild3Click(Sender: TObject);
begin
   FSharing.init('U','FOR',ID.Text, QUERY.FieldByName('NAME').AsString);
   dmodule.CommitTrans;
end;

function TFBrowseFORMS.getSearchFilter: string;
begin
 result := format(sql_FOR_SEARCH, [ replacePolishChars( ansiuppercase(trim(ESearch.Text)) ) ]);    
 end;

function TFBrowseFORMS.getFindCaption: string;
begin
 Result := 'Dowolna fraza';
end;

end.
