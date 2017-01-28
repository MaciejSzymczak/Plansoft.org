unit UFBrowseORG_UNITS;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFBrowseParent, ExtCtrls, StrHlder, Menus, DB, DBTables,
  RxQuery, ComCtrls, Grids, DBGrids, RXDBCtrl, StdCtrls, Buttons, DBCtrls,
  Mask, ToolEdit, ImgList, ADODB, OleServer, ExcelXP;

type
  TFBrowseORG_UNITS = class(TFBrowseParent)
    ID: TDBEdit;
    LabelID: TLabel;
    NAME: TDBEdit;
    LabelNAME: TLabel;
    CODE: TDBEdit;
    LabelCODE: TLabel;
    PARENT_ID: TDBEdit;
    LabelPARENT_ID: TLabel;
    STRUCT_CODE: TDBMemo;
    LabelSTRUCT_CODE: TLabel;
    DESC1: TDBEdit;
    DESC2: TDBEdit;
    Label3: TLabel;
    Label2: TLabel;
    PARENT_ID_VALUE: TEdit;
    BClearPARENT_ID: TBitBtn;
    Label4: TLabel;
    CON_PARENT_ID: TEdit;
    CON_PARENT_ID_VALUE: TEdit;
    BSelOU: TBitBtn;
    BitBtn6: TBitBtn;
    BOrgChart: TButton;
    googleChart: TADOQuery;
    PPOrgChart: TPopupMenu;
    Wywietl1: TMenuItem;
    Wicejopcji1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure QueryBeforePost(DataSet: TDataSet);
    procedure PARENT_IDChange(Sender: TObject);
    procedure BClearPARENT_IDClick(Sender: TObject);
    procedure CON_PARENT_IDChange(Sender: TObject);
    procedure BSelOUClick(Sender: TObject);
    procedure CON_PARENT_ID_VALUEDblClick(Sender: TObject);
    procedure BitBtn6Click(Sender: TObject);
    procedure BUpdChild1Click(Sender: TObject);
    procedure BUpdChild2Click(Sender: TObject);
    procedure BUpdChild3Click(Sender: TObject);
    procedure BUpdChild4Click(Sender: TObject);
    procedure BUpdChild5Click(Sender: TObject);
    procedure BOrgChartClick(Sender: TObject);
    procedure Wywietl1Click(Sender: TObject);
    procedure Wicejopcji1Click(Sender: TObject);
    procedure PARENT_ID_VALUEClick(Sender: TObject);
  private
    { Private declarations }
  public
    Function  CheckRecord : Boolean; override;
    Procedure DefaultValues; override;
    Procedure CustomConditions; override;
    procedure generateOrgChart(
   pinclude_lec
  ,pinclude_sub
  ,pinclude_gro
  ,pinclude_rom
  ,ppla_id
  ,pentire_db
  ,pstruct_code : string);
  end;

var
  FBrowseORG_UNITS: TFBrowseORG_UNITS;

implementation

uses DM, uutilityParent, UFLookupWindow, AutoCreate, UFMain,
  UFGoogleOrgChart;

{$R *.dfm}

Function  TFBrowseORG_UNITS.CheckRecord : Boolean;
Begin
 With UUtilityParent.CheckValid Do Begin //Metody: Init, addError(S : String), AddWarning(S : String),   ShowMessage : Boolean = czy wszystko jest ok ?
   Init(Self);
   RestrictEmpty([NAME, CODE ]);
   If ID.Text = parent_id.Text Then addError(MESSAGES.Strings[0]);
   Result := ShowMessage;
 End;

End;

Procedure TFBrowseORG_UNITS.DefaultValues;
Begin
 Query['ID'] := DModule.SingleValue('SELECT ORGUNI_SEQ.NEXTVAL FROM DUAL');
 IF CON_PARENT_ID.Text <>'' THEN Query['PARENT_ID'] := CON_PARENT_ID.Text;
End;

Procedure TFBrowseORG_UNITS.CustomConditions;
Begin
 If CON_PARENT_ID.Text = '' Then DM.macros.setMacro(query, 'CON_PARENT_ID', '0=0')
                            Else DM.macros.setMacro(query, 'CON_PARENT_ID', 'ORG_UNITS.STRUCT_CODE LIKE '''+dmodule.singleValue('SELECT STRUCT_CODE FROM ORG_UNITS WHERE ID = '+CON_PARENT_ID.Text)+'%''');
End;

procedure TFBrowseORG_UNITS.FormCreate(Sender: TObject);
begin
  inherited;
  SetNotUpdatable([CODE, PARENT_ID, PARENT_ID_VALUE, BClearPARENT_ID], [LabelCODE, LabelPARENT_ID]);
end;

procedure TFBrowseORG_UNITS.QueryBeforePost(DataSet: TDataSet);
begin
  inherited;
  Query['STRUCT_CODE'] := MERGE( DModule.SingleValue('SELECT STRUCT_CODE FROM ORG_UNITS WHERE ID = ' + NVL(PARENT_ID.Text, '-1')), CODE.TEXT, '.');
end;

procedure TFBrowseORG_UNITS.PARENT_IDChange(Sender: TObject);
begin
  DModule.RefreshLookupEdit(Self, TControl(Sender).Name,'NAME','ORG_UNITS','');
end;

procedure TFBrowseORG_UNITS.BClearPARENT_IDClick(Sender: TObject);
begin
  inherited;
 Query.FieldByName('PARENT_ID').Clear;
end;

procedure TFBrowseORG_UNITS.CON_PARENT_IDChange(Sender: TObject);
begin
  inherited;
  If Trim(CON_PARENT_ID.TEXT) <> '' Then CON_PARENT_ID_VALUE.Text := DMOdule.SingleValue('SELECT NAME FROM ORG_UNITS WHERE ID='+CON_PARENT_ID.TEXT)
                                    Else CON_PARENT_ID_VALUE.Text := '';
  BRefreshClick(nil);
end;

procedure TFBrowseORG_UNITS.BSelOUClick(Sender: TObject);
Var ID : ShortString;
begin
  ID := CON_PARENT_ID.Text;
  If LookupWindow(DModule.ADOConnection, 'ORG_UNITS','','SUBSTR(NAME ||'' (''||STRUCT_CODE||'')'',1,63)','NAZWA I KOD STRUKTURY','NAME','0=0','',ID) = mrOK Then CON_PARENT_ID.Text := ID;
end;

procedure TFBrowseORG_UNITS.CON_PARENT_ID_VALUEDblClick(Sender: TObject);
begin
  BSelOUClick(nil);
end;

procedure TFBrowseORG_UNITS.BitBtn6Click(Sender: TObject);
begin
  inherited;
  CON_PARENT_ID.Text := '';
end;

procedure TFBrowseORG_UNITS.BUpdChild1Click(Sender: TObject);
begin
  AutoCreate.LECTURERSShowModalAsBrowser(Query['ID']);
end;

procedure TFBrowseORG_UNITS.BUpdChild2Click(Sender: TObject);
begin
  AutoCreate.FIN_PARTIESShowModalAsBrowser('PLANSOFT:' + Query.fieldByName('ID').AsString );
end;

procedure TFBrowseORG_UNITS.BUpdChild3Click(Sender: TObject);
begin
  AutoCreate.SUBJECTSShowModalAsBrowser(Query['ID']);
end;

procedure TFBrowseORG_UNITS.BUpdChild4Click(Sender: TObject);
begin
  AutoCreate.GROUPSShowModalAsBrowser(Query['ID']);
end;

procedure TFBrowseORG_UNITS.BUpdChild5Click(Sender: TObject);
begin
  AutoCreate.ROOMSShowModalAsBrowser('',Query['ID']);
end;

procedure TFBrowseORG_UNITS.BOrgChartClick(Sender: TObject);
var point : tpoint;
    btn   : tcontrol;
begin
 btn     := sender as tcontrol;
 Point.x := 0;
 Point.y := btn.Height;
 Point   := btn.ClientToScreen(Point);
 PPOrgChart.Popup(Point.X,Point.Y);
end;


procedure TFBrowseORG_UNITS.Wywietl1Click(Sender: TObject);
begin
  generateOrgChart('N','N','N','N',FMain.getUserOrRoleID,'N','%');
end;

procedure TFBrowseORG_UNITS.generateOrgChart(
  pinclude_lec
  ,pinclude_sub
  ,pinclude_gro
  ,pinclude_rom
  ,ppla_id
  ,pentire_db
  ,pstruct_code : string
  );
var
    tmpFileName : string;
    tmpFile : textfile;
    htmlContent : string;
begin
  if not elementEnabled('"Diagram organizacji"','2015.03.29', false) then exit;

  dmodule.CommitTrans;
  dmodule.resetConnection(googleChart);
  try
  dmodule.SQL(googleChart,'begin google_orgchart.getOrgChart(:pinclude_lec, :pinclude_sub, :pinclude_gro, :pinclude_rom, :ppla_id, :pentire_db, :pstruct_code); end;'
  ,'pinclude_lec='+pinclude_lec+';pinclude_sub='+pinclude_sub+';pinclude_gro='+pinclude_gro+';pinclude_rom='+pinclude_rom+';ppla_id='+ppla_id+';pentire_db='+pentire_db+';pstruct_code='+pstruct_code
  );
  except on e:exception do begin
      info('Ups.. Wygl¹da na to, ¿e modu³ generowania diagramu organizacji nie zosta³ zainstalowany, skontaktuj siê administratorem systemu.'+cr+'Je¿eli posiadasz aktywn¹ umowê serwisow¹ firma Software Factory pomo¿e w rozwi¹zaniu problemu, zadzwoñ pod numer +48 604224658. '+cr+cr+e.message);
      exit;
    end;
  end;
  dmodule.openSQL(googleChart,'select value from tmp_chunkedclob order by id');
  htmlContent := '';
  while not googleChart.Eof do begin
     htmlContent := htmlContent + googleChart.Fields[0].AsString;
     googleChart.Next;
  end;
  googleChart.Close;
  Dmodule.RollbackTrans;
  
  tmpFileName := uutilityParent.ApplicationDocumentsPath +'Plansoft.org.'+nvl(iif(pstruct_code='%','ALL',pstruct_code),'ALL')+'.html';

  AssignFile(tmpFile, tmpFileName );
  rewrite(tmpFile);
  writeln(tmpFile, htmlContent);
  closeFile(tmpFile);

  ExecuteFile(tmpFileName,'','',SW_SHOWMAXIMIZED);
end;


procedure TFBrowseORG_UNITS.Wicejopcji1Click(Sender: TObject);
begin
  With FGoogleOrgChart do
  if showModal = mrOK then begin
     generateOrgChart(
       map.Lines.Values[L.Text]
      ,map.Lines.Values[S.Text]
      ,map.Lines.Values[G.Text]
      ,map.Lines.Values[R.Text]
      ,FMain.getUserOrRoleID
      ,iif(showAll.Checked,'Y','N')
      ,nvl(dmodule.SingleValue('select struct_code from org_units where id='+nvl(ORGID.Text,'-1')),'%')
      );
  end;
end;

procedure TFBrowseORG_UNITS.PARENT_ID_VALUEClick(Sender: TObject);
Var ID : ShortString;
begin
  ID := PARENT_ID.Text;
  //If AutoCreate.ORG_UNITSShowModalAsSelect(ID) = mrOK Then Query.FieldByName('PARENT_ID').AsString := ID;
  If LookupWindow(DModule.ADOConnection, 'ORG_UNITS','','SUBSTR(NAME ||'' (''||STRUCT_CODE||'')'',1,63)','NAZWA I KOD STRUKTURY','NAME','0=0','',ID) = mrOK Then Query.FieldByName('PARENT_ID').AsString := ID;
end;

end.
