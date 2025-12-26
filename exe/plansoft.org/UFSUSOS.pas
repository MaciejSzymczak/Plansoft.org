unit UFSUSOS;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormConfig, StdCtrls, Buttons, ExtCtrls, Grids, DBGrids,
  RXDBCtrl, DB, ADODB, ComCtrls, Menus, ImgList;

type
  TFUSOS = class(TFormConfig)
    Panel1: TPanel;
    BZamknij: TBitBtn;
    Panel2: TPanel;
    Source: TDataSource;
    QueryLog: TADOQuery;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Label2: TLabel;
    USOS_HOURS_PER_DAY: TEdit;
    LRESCAT_COMB_ID: TLabel;
    RESCAT_COMB_ID_VALUE: TEdit;
    RESCAT_COMB_IDSel: TBitBtn;
    RESCAT_COMB_ID: TEdit;
    Label3: TLabel;
    USOS_INTEGRATION_USER: TEdit;
    USOS_CYKL: TEdit;
    Label1: TLabel;
    BitBtn2: TBitBtn;
    BitBtn1: TBitBtn;
    Label4: TLabel;
    USOS_ONLINE: TEdit;
    BitBtn3: TBitBtn;
    CleanUpMode: TCheckBox;
    PageControl2: TPageControl;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    Grid: TRxDBGrid;
    QueryNotSent: TADOQuery;
    DSQueryNotSent: TDataSource;
    GridNotSent: TRxDBGrid;
    Panel4: TPanel;
    BitBtn4: TBitBtn;
    ppexport: TPopupMenu;
    ExportEasy: TMenuItem;
    ExportHtml: TMenuItem;
    ImageList: TImageList;
    N1: TMenuItem;
    PodgldzapytaniaSQLZaawansowane1: TMenuItem;
    TabSheet5: TTabSheet;
    Panel3: TPanel;
    BitBtn5: TBitBtn;
    Panel5: TPanel;
    BitBtn6: TBitBtn;
    GridSent: TRxDBGrid;
    QuerySent: TADOQuery;
    DSSent: TDataSource;
    SpeedButton1: TSpeedButton;
    USOS_PACKAGE_NAME: TEdit;
    Label5: TLabel;
    BVersion: TBitBtn;
    procedure BZamknijClick(Sender: TObject);
    procedure RESCAT_COMB_IDSelClick(Sender: TObject);
    procedure RESCAT_COMB_IDChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure PageControl2Change(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure ExportEasyClick(Sender: TObject);
    procedure ExportHtmlClick(Sender: TObject);
    procedure PodgldzapytaniaSQLZaawansowane1Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure PageControl1Changing(Sender: TObject;
      var AllowChange: Boolean);
    procedure BVersionClick(Sender: TObject);
  private
    Procedure SaveParams;
    function rolePrivided : boolean;
  public
    { Public declarations }
  end;

var
  FUSOS: TFUSOS;

implementation

{$R *.dfm}

Uses AutoCreate, DM, UUtilityParent, UProgress, UFFloatingMessage, UFMain,
  FVersions;

procedure TFUSOS.BZamknijClick(Sender: TObject);
begin
  Status.Caption := 'Zapisywanie parametrów...';
  Status.Refresh;
  SaveParams;
  Status.Caption := 'Zamykanie okna...';
  Status.Refresh;
  Close;
end;

procedure TFUSOS.RESCAT_COMB_IDSelClick(Sender: TObject);
Var ID : ShortString;
begin
  ID := RESCAT_COMB_ID.Text;
  If TT_RESCAT_COMBINATIONSShowModalAsSelect(ID) = mrOK Then RESCAT_COMB_ID.Text := ID;
end;

procedure TFUSOS.RESCAT_COMB_IDChange(Sender: TObject);
begin
    if  (RESCAT_COMB_ID.text <> '') then dmodule.RefreshLookupEdit(Self, TControl(Sender).Name,'tt_planner.get_resource_cat_names(ID)','TT_RESCAT_COMBINATIONS','');
end;

procedure TFUSOS.FormShow(Sender: TObject);
begin
  inherited;
  PageControl2.TabIndex := 0;
  PageControl1.TabIndex := 0;
  USOS_CYKL.text          := NVL( dmodule.dbgetSystemParam(fmain.getUserOrRoleId+':USOS_CYKL'), {for backward compatibility} dmodule.dbgetSystemParam('USOS_CYKL') );
  RESCAT_COMB_ID.text     := dmodule.dbgetSystemParam('USOS_RESCAT_COMB_ID');
  USOS_HOURS_PER_DAY.text := dmodule.dbgetSystemParam('USOS_HOURS_PER_DAY');
  USOS_INTEGRATION_USER.text := dmodule.dbgetSystemParam('USOS_INTEGRATION_USER');
  USOS_ONLINE.text := dmodule.dbgetSystemParam('USOS_ONLINE');
  USOS_PACKAGE_NAME.text := dmodule.dbgetSystemParam('USOS_PACKAGE_NAME');
  QueryLog.Active := true;
end;

procedure TFUSOS.SaveParams;
  procedure progress(x : string);
  begin
    Status.Caption := x;
    Status.Refresh;
  end;
begin
  progress('USOS_CYKL');
  dmodule.dbSetSystemParam('USOS_CYKL', USOS_CYKL.text);
  dmodule.dbSetSystemParam(fmain.getUserOrRoleId+':USOS_CYKL', USOS_CYKL.text);
  progress('USOS_RESCAT_COMB_ID');
  dmodule.dbSetSystemParam('USOS_RESCAT_COMB_ID', RESCAT_COMB_ID.text);
  progress('USOS_HOURS_PER_DAY');
  dmodule.dbSetSystemParam('USOS_HOURS_PER_DAY', USOS_HOURS_PER_DAY.text);
  progress('USOS_INTEGRATION_USER');
  dmodule.dbSetSystemParam('USOS_INTEGRATION_USER', USOS_INTEGRATION_USER.text);
  progress('USOS_ONLINE');
  dmodule.dbSetSystemParam('USOS_ONLINE', USOS_ONLINE.text);
  progress('USOS_PACKAGE_NAME');
  dmodule.dbSetSystemParam('USOS_PACKAGE_NAME', USOS_PACKAGE_NAME.text);
end;


procedure TFUSOS.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  SaveParams;
end;

procedure TFUSOS.BitBtn2Click(Sender: TObject);
begin
if not rolePrivided then exit;

FProgress.Show;
FProgress.ProgressBar.Position :=  50;
FProgress.Refresh;

    SaveParams;

    if UpperCase(USOS_PACKAGE_NAME.Text)='USOS' then begin
      //old version, no parameter puserOrRoleId
      dmodule.sql('begin '+USOS_PACKAGE_NAME.Text+'.integration_from_usos_dict (:pCleanYpMode); end;'
            ,'pCleanYpMode='+iif(CleanUpMode.Checked,'Y','N')
      );
    end else begin
      //new version
      dmodule.sql('begin '+USOS_PACKAGE_NAME.Text+'.integration_from_usos_dict (:pCleanYpMode, :puserOrRoleId ); end;'
            ,'pCleanYpMode='+iif(CleanUpMode.Checked,'Y','N')
            +';puserOrRoleId='+fMain.getUserOrRoleId
      );
    end;

    QueryLog.Close;
    QueryLog.Open;
    PageControl2.TabIndex := 0;

FProgress.Hide;
end;


procedure TFUSOS.BitBtn1Click(Sender: TObject);
begin
if not rolePrivided then exit;
FProgress.Show;
FProgress.ProgressBar.Position :=  50;
FProgress.Refresh;

    PageControl2.TabIndex := 0;
    SaveParams;

    if UpperCase(USOS_PACKAGE_NAME.Text)='USOS' then begin
      //old version, no parameter puserOrRoleId
      dmodule.sql('begin '+USOS_PACKAGE_NAME.Text+'.integration_to_usos (:pCleanYpMode ); end;'
            ,'pCleanYpMode='+iif(CleanUpMode.Checked,'Y','N')
      );
    end else begin
      //new version
      dmodule.sql('begin '+USOS_PACKAGE_NAME.Text+'.integration_to_usos (:pCleanYpMode, :puserOrRoleId ); end;'
            ,'pCleanYpMode='+iif(CleanUpMode.Checked,'Y','N')
            +';puserOrRoleId='+fMain.getUserOrRoleId
      );
    end;


    QueryLog.Close;
    QueryLog.Open;
    PageControl2.TabIndex := 0;

FProgress.Hide;
end;


procedure TFUSOS.BitBtn3Click(Sender: TObject);
begin
if not rolePrivided then exit;
FProgress.Show;
FProgress.ProgressBar.Position :=  50;
FProgress.Refresh;

    SaveParams;

    if UpperCase(USOS_PACKAGE_NAME.Text)='USOS' then begin
      //old version, no parameter puserOrRoleId
      dmodule.sql('begin '+USOS_PACKAGE_NAME.Text+'.integration_from_usos_plan (:pCleanYpMode ); end;'
            ,'pCleanYpMode='+iif(CleanUpMode.Checked,'Y','N')
      );
    end else begin
      //new version
      dmodule.sql('begin '+USOS_PACKAGE_NAME.Text+'.integration_from_usos_plan (:pCleanYpMode, :puserOrRoleId ); end;'
            ,'pCleanYpMode='+iif(CleanUpMode.Checked,'Y','N')
            +';puserOrRoleId='+fMain.getUserOrRoleId
      );
    end;


    QueryLog.Close;
    QueryLog.Open;
    PageControl2.TabIndex := 0;

FProgress.Hide;
end;

procedure TFUSOS.PageControl2Change(Sender: TObject);
Var activeTab : integer;
    DateFrom : string;
    DateTo : string;
begin
FProgress.Show;
FProgress.ProgressBar.Position :=  50;
FProgress.Refresh;

  activeTab := PageControl2.TabIndex;

  if (activeTab=0) then begin
   QueryLog.Close;
   QueryLog.Open;
  end;


  if (activeTab=1) then begin
    With dmodule do begin
      //select value from system_parameters where name like ''USOS_CYKL%''
      SingleValue('select TO_CHAR(DATE_FROM,''YYYY/MM/DD''),TO_CHAR(DATE_TO,''YYYY/MM/DD'') from periods where integration_id = '''+USOS_CYKL.Text+'''');
      //SingleValue('select TO_CHAR(DATE_FROM,''YYYY/MM/DD''),TO_CHAR(DATE_TO,''YYYY/MM/DD'') from periods where rownum =1');
      if dmodule.QWork.RecordCount = 0 then begin
        FProgress.Hide;
        info('Nie odnaleziono semestru o podanym kodzie cyklu:'+USOS_CYKL.Text);
        exit;
      end;
      DateFrom := 'TO_DATE('''+QWork.Fields[0].AsString+''',''YYYY/MM/DD'')';
      DateTo   := 'TO_DATE('''+QWork.Fields[1].AsString+''',''YYYY/MM/DD'')';
    end;

    DM.macros.setMacro( QueryNotSent, 'DATE_FROM', DateFrom);
    DM.macros.setMacro( QueryNotSent, 'DATE_TO', DateTo);
    DM.macros.setMacro( QueryNotSent, 'PLA_ID', fmain.getUserOrRoleID);


    QueryNotSent.Close;
    try
    QueryNotSent.Open;
    except
      FProgress.Hide;
      copyToClipboard(  QueryNotSent.SQL.Text);
      raise;
    end;
  end;


  if (activeTab=2) then begin
    QuerySent.Close;
    try
    QuerySent.Open;
    except
      FProgress.Hide;
      copyToClipboard(  QuerySent.SQL.Text);
      raise;
    end;
  end;


FProgress.Hide;
end;

procedure TFUSOS.BitBtn4Click(Sender: TObject);
var point : tpoint;
    btn   : tcontrol;
begin
 btn     := sender as tcontrol;
 Point.x := 0;
 Point.y := btn.Height;
 Point   := btn.ClientToScreen(Point);
 ppexport.Popup(Point.X,Point.Y);
end;


procedure TFUSOS.ExportEasyClick(Sender: TObject);
var activeTab : integer;
begin
 activeTab := PageControl2.TabIndex;
 if activeTab = 0 then dmodule.ExportToExcel(Grid);
 if activeTab = 1 then dmodule.ExportToExcel(GridNotSent);
 if activeTab = 2 then dmodule.ExportToExcel(GridSent);
end;

procedure TFUSOS.ExportHtmlClick(Sender: TObject);
var activeTab : integer;
begin
 activeTab := PageControl2.TabIndex;
 if activeTab = 0 then dmodule.ExportToHTML(Grid);
 if activeTab = 1 then dmodule.ExportToHTML(GridNotSent);
 if activeTab = 2 then dmodule.ExportToHTML(GridSent);
end;

procedure TFUSOS.PodgldzapytaniaSQLZaawansowane1Click(Sender: TObject);
var activeTab : integer;
begin
 activeTab := PageControl2.TabIndex;
 if activeTab = 0 then CopyToClipboard( QueryLog.SQL.Text );
 if activeTab = 1 then CopyToClipboard( QueryNotSent.SQL.Text );
 if activeTab = 2 then CopyToClipboard( QuerySent.SQL.Text );
 Info('Skopiowano do schowka');
end;


procedure TFUSOS.SpeedButton1Click(Sender: TObject);
begin
   FFloatingMessage.showModal(
'Raport pokazuje wszystkie dane, które zosta³y przes³ane do systemu USOS, a tak¿e identyfikatory tabel w systemie usos.' +
'Je¿eli zamiast ID w kolumnie pokazuje siê s³owo "**Skasowano**", to znaczy, ¿e rekord zosta³ skasowany w systemie USOS.  ' +
'Wówczas uruchom ponownie integracjê.'
);
end;

procedure TFUSOS.PageControl1Changing(Sender: TObject;
  var AllowChange: Boolean);
begin
   AllowChange:= IsAdmin;
end;

procedure TFUSOS.BVersionClick(Sender: TObject);
begin
  if not rolePrivided then exit;
  FVersion.ShowModal;
end;

function TFUSOS.rolePrivided: boolean;
begin
  result := true;
  if (AnsiUpperCase(USOS_PACKAGE_NAME.Text)='USOS_PS') and (fmain.conRole.Text='') then begin
    Info('Wybierz autoryzacjê przed uruchomieniem integracji');
    result := false;
  End;

end;

end.
