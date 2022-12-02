unit UFIntegration;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormConfig, StdCtrls, Buttons, ExtCtrls, DB, ADODB, Grids,
  DBGrids, RXDBCtrl, ComCtrls;

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
    Grid: TRxDBGrid;
    Source: TDataSource;
    Query: TADOQuery;
    BitBtn2: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn3: TBitBtn;
    CleanUpMode: TCheckBox;
    BReport: TBitBtn;
    procedure INT_RESCAT_COMB_IDChange(Sender: TObject);
    procedure RESCAT_COMB_IDSelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BReportClick(Sender: TObject);
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
  Query.Active := true;
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
    SaveParams;
    dmodule.sql('begin integration.int_to_plansoft_dict (:pCleanYpMode ); end;'
            ,'pCleanYpMode='+iif(CleanUpMode.Checked,'Y','N')
    );
    Query.Close;
    Query.Open;
end;


procedure TFIntegration.BitBtn4Click(Sender: TObject);
begin
    SaveParams;
    dmodule.sql('begin integration.int_to_plansoft_plan (:pCleanYpMode ); end;'
            ,'pCleanYpMode='+iif(CleanUpMode.Checked,'Y','N')
    );
    Query.Close;
    Query.Open;
end;

procedure TFIntegration.BitBtn3Click(Sender: TObject);
begin
  info('Ten element nie zostal jeszcze wykonany, przepraszamy');
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

end.
