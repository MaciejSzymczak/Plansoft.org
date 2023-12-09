unit UFIntegration;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormConfig, StdCtrls, Buttons, ExtCtrls, DB, ADODB, Grids,
  DBGrids, RXDBCtrl, ComCtrls, Menus;

type
  TFIntegration = class(TFormConfig)
    Panel2: TPanel;
    BZamknij: TBitBtn;
    Panel3: TPanel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Label1: TLabel;
    INT_PERIOD_NAME: TEdit;
    TabSheet2: TTabSheet;
    LRESCAT_COMB_ID: TLabel;
    INT_RESCAT_COMB_ID_VALUE: TEdit;
    RESCAT_COMB_IDSel: TBitBtn;
    INT_RESCAT_COMB_ID: TEdit;
    Source: TDataSource;
    QueryLog: TADOQuery;
    BitBtn2: TBitBtn;
    BReport: TBitBtn;
    RunIntFromPlansoft: TBitBtn;
    BConfirmation2: TLabel;
    Refresh: TTimer;
    RunIntToPlansoftPlan: TBitBtn;
    BConfirmation1: TLabel;
    PageControl2: TPageControl;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    GridDuplicates: TRxDBGrid;
    Panel4: TPanel;
    BitBtn4: TBitBtn;
    Grid: TRxDBGrid;
    QDuplicates: TADOQuery;
    DSDuplicates: TDataSource;
    PPDuplicates: TPopupMenu;
    ExportEasy: TMenuItem;
    ExportHtml: TMenuItem;
    TabSheet5: TTabSheet;
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    GridNotSent: TRxDBGrid;
    QNotSent: TADOQuery;
    DSNotSent: TDataSource;
    PPNotSent: TPopupMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    procedure INT_RESCAT_COMB_IDChange(Sender: TObject);
    procedure RESCAT_COMB_IDSelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BitBtn2Click(Sender: TObject);
    procedure RunIntFromPlansoftClick(Sender: TObject);
    procedure BReportClick(Sender: TObject);
    procedure RefreshTimer(Sender: TObject);
    procedure RunIntToPlansoftPlanClick(Sender: TObject);
    procedure ExportEasyClick(Sender: TObject);
    procedure ExportHtmlClick(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure PageControl2Change(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    Procedure SaveParams;
  public
    { Public declarations }
  end;

var
  FIntegration: TFIntegration;

implementation

uses DM, AutoCreate, UUtilityParent;

{$R *.dfm}

procedure TFIntegration.INT_RESCAT_COMB_IDChange(Sender: TObject);
begin
    if  (INT_RESCAT_COMB_ID.text <> '') then dmodule.RefreshLookupEdit(Self, TControl(Sender).Name,'tt_planner.get_resource_cat_names(ID)','TT_RESCAT_COMBINATIONS','');
end;

procedure TFIntegration.RESCAT_COMB_IDSelClick(Sender: TObject);
Var ID : ShortString;
begin
  ID := INT_RESCAT_COMB_ID.Text;
  If TT_RESCAT_COMBINATIONSShowModalAsSelect(ID) = mrOK Then INT_RESCAT_COMB_ID.Text := ID;
end;

procedure TFIntegration.FormShow(Sender: TObject);
begin
  INT_RESCAT_COMB_ID.text  := dmodule.dbgetSystemParam('INT_RESCAT_COMB_ID');
  INT_PERIOD_NAME.text     := dmodule.dbgetSystemParam('INT_PERIOD_NAME');
  QueryLog.Active := true;

  RefreshTimer(nil);
  Refresh.Enabled := true;
end;

procedure TFIntegration.SaveParams;
begin
  dmodule.dbSetSystemParam('INT_RESCAT_COMB_ID', INT_RESCAT_COMB_ID.text);
  dmodule.dbSetSystemParam('INT_PERIOD_NAME', INT_PERIOD_NAME.text);
end;

procedure TFIntegration.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  SaveParams;
end;

procedure TFIntegration.BitBtn2Click(Sender: TObject);
begin
    //SaveParams;
    //dmodule.sql('begin integration.int_to_plansoft_dict (:pCleanYpMode ); end;'
    //        ,'pCleanYpMode='+iif(CleanUpMode.Checked,'Y','N')
    //);
    //Query.Close;
    //Query.Open;
end;


procedure TFIntegration.RunIntFromPlansoftClick(Sender: TObject);
var tmpFile : textfile;
    sqlstmt : string;
    query : tadoquery;
begin
  RunIntFromPlansoft.Enabled := false;
  query := tadoquery.Create(self);
  dmodule.resetConnection ( query );
  sqlstmt := 'begin insert into system_parameters (name, value) values(''RUN_INT_FROM_PLANSOFT'',''YES''); commit; end;';
  try
   query.SQL.clear;
   query.SQL.Add(sqlstmt);
   query.execSQL;
   query.Free;
  except
   on e:exception do begin
       copyToClipboard( sqlstmt );
       raise;
   end;
  end;
  BConfirmation2.Visible := true;
end;


procedure TFIntegration.BReportClick(Sender: TObject);
var tmpFile : textfile;
    sqlstmt : string;
    query : tadoquery;
    backup : string;
begin
  backup := BReport.Caption;
  BReport.Caption := 'Trwa generowanie....';
  BReport.refresh;
  query := tadoquery.Create(self);
  dmodule.resetConnection ( query );
  sqlstmt := 'begin rep_bazus.prepare(); end;';
  try
   query.SQL.clear;
   query.SQL.Add(sqlstmt);
   query.execSQL;
   query.Free;
  except
   on e:exception do begin
       copyToClipboard( sqlstmt );
       raise;
   end;
  end;


  AssignFile(tmpFile,  uutilityParent.ApplicationDocumentsPath +'Bazus_errors.html');
  rewrite(tmpFile);

  query := tadoquery.Create(self);
  dmodule.resetConnection ( query );
  query.SQL.Clear;
  query.SQL.Add( 'select rep_Bazus.getList from dual' );
  query.Open;
  writeln(tmpFile, UTF8Encode (query.Fields[0].AsString));

  closeFile(tmpFile);
  BReport.Caption :=  backup;
  ExecuteFile(uutilityParent.ApplicationDocumentsPath +'Bazus_errors.html','','',SW_SHOWMAXIMIZED);
end;

procedure TFIntegration.RefreshTimer(Sender: TObject);
var flag : String;
begin
  //
  flag := dmodule.SingleValue('select Value from system_parameters where name = ''RUN_INT_TO_PLANSOFT_PLAN'' and value=''YES''');
  RunIntToPlansoftPlan.Enabled := flag <> 'YES';
  BConfirmation1.Visible := flag = 'YES';
  //
  flag := dmodule.SingleValue('select Value from system_parameters where name = ''RUN_INT_FROM_PLANSOFT'' and value=''YES''');
  RunIntFromPlansoft.Enabled := flag <> 'YES';
  BConfirmation2.Visible := flag = 'YES';
  //
  QueryLog.Close;
  QueryLog.Open;
end;

procedure TFIntegration.RunIntToPlansoftPlanClick(Sender: TObject);
var tmpFile : textfile;
    sqlstmt : string;
    query : tadoquery;
begin
  RunIntToPlansoftPlan.Enabled := false;
  query := tadoquery.Create(self);
  dmodule.resetConnection ( query );
  sqlstmt := 'begin insert into system_parameters (name, value) values(''RUN_INT_TO_PLANSOFT_PLAN'',''YES''); commit; end;';
  try
   query.SQL.clear;
   query.SQL.Add(sqlstmt);
   query.execSQL;
   query.Free;
  except
   on e:exception do begin
       copyToClipboard( sqlstmt );
       raise;
   end;
  end;
  BConfirmation1.Visible := true;
end;

procedure TFIntegration.ExportEasyClick(Sender: TObject);
begin
 dmodule.ExportToExcel(GridDuplicates);
end;

procedure TFIntegration.ExportHtmlClick(Sender: TObject);
begin
 dmodule.ExportToHtml(GridDuplicates);
end;

procedure TFIntegration.BitBtn4Click(Sender: TObject);
var point : tpoint;
    btn   : tcontrol;
begin
 btn     := sender as tcontrol;
 Point.x := 0;
 Point.y := btn.Height;
 Point   := btn.ClientToScreen(Point);
 PPDuplicates.Popup(Point.X,Point.Y);
end;

procedure TFIntegration.PageControl2Change(Sender: TObject);
Var activeTab : integer;
begin
  activeTab := PageControl2.TabIndex;

  if (activeTab=0) then begin
   QueryLog.Close;
   QueryLog.Open;
  end;

  if (activeTab=1) then begin
   QDuplicates.Close;
   try
   QDuplicates.Open;
   except
     copyToClipboard(  QDuplicates.SQL.Text);
     raise;
   end;
  end;

  if (activeTab=2) then begin
   QNotSent.Close;
   try
   QNotSent.Open;
   except
     copyToClipboard(  QNotSent.SQL.Text);
     raise;
   end;
  end;


end;

procedure TFIntegration.MenuItem1Click(Sender: TObject);
begin
 dmodule.ExportToExcel(GridNotSent);
end;

procedure TFIntegration.MenuItem2Click(Sender: TObject);
begin
 dmodule.ExportToHtml(GridNotSent);
end;

procedure TFIntegration.BitBtn1Click(Sender: TObject);
var point : tpoint;
    btn   : tcontrol;
begin
 btn     := sender as tcontrol;
 Point.x := 0;
 Point.y := btn.Height;
 Point   := btn.ClientToScreen(Point);
 PPNotSent.Popup(Point.X,Point.Y);
end;

end.
