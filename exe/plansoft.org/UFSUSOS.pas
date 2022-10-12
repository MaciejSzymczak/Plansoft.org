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
  private
    Procedure SaveParams;
  public
    { Public declarations }
  end;

var
  FUSOS: TFUSOS;

implementation

{$R *.dfm}

Uses AutoCreate, DM, UUtilityParent;

procedure TFUSOS.BZamknijClick(Sender: TObject);
begin
  SaveParams;
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
  USOS_CYKL.text          := dmodule.dbgetSystemParam('USOS_CYKL');
  RESCAT_COMB_ID.text     := dmodule.dbgetSystemParam('USOS_RESCAT_COMB_ID');
  USOS_HOURS_PER_DAY.text := dmodule.dbgetSystemParam('USOS_HOURS_PER_DAY');
  USOS_INTEGRATION_USER.text := dmodule.dbgetSystemParam('USOS_INTEGRATION_USER');
  USOS_ONLINE.text := dmodule.dbgetSystemParam('USOS_ONLINE');
  QueryLog.Active := true;
end;

procedure TFUSOS.SaveParams;
begin
  dmodule.dbSetSystemParam('USOS_CYKL', USOS_CYKL.text);
  dmodule.dbSetSystemParam('USOS_RESCAT_COMB_ID', RESCAT_COMB_ID.text);
  dmodule.dbSetSystemParam('USOS_HOURS_PER_DAY', USOS_HOURS_PER_DAY.text);
  dmodule.dbSetSystemParam('USOS_INTEGRATION_USER', USOS_INTEGRATION_USER.text);
  dmodule.dbSetSystemParam('USOS_ONLINE', USOS_ONLINE.text);
end;


procedure TFUSOS.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  SaveParams;
end;

procedure TFUSOS.BitBtn2Click(Sender: TObject);
begin
    SaveParams;
    dmodule.sql('begin usos.integration_from_usos_dict (:pCleanYpMode ); end;'
            ,'pCleanYpMode='+iif(CleanUpMode.Checked,'Y','N')
    );
    QueryLog.Close;
    QueryLog.Open;
end;


procedure TFUSOS.BitBtn1Click(Sender: TObject);
begin
    PageControl2.TabIndex := 0;
    SaveParams;
    dmodule.sql('begin usos.integration_to_usos (:pCleanYpMode ); end;'
            ,'pCleanYpMode='+iif(CleanUpMode.Checked,'Y','N')
    );
    QueryLog.Close;
    QueryLog.Open;
end;


procedure TFUSOS.BitBtn3Click(Sender: TObject);
begin
    SaveParams;
    dmodule.sql('begin usos.integration_from_usos_plan (:pCleanYpMode ); end;'
            ,'pCleanYpMode='+iif(CleanUpMode.Checked,'Y','N')
    );
    QueryLog.Close;
    QueryLog.Open;
end;

procedure TFUSOS.PageControl2Change(Sender: TObject);
Var activeTab : integer;
    DateFrom : string;
    DateTo : string;
begin
  activeTab := PageControl2.TabIndex;

  if (activeTab=0) then begin
   QueryLog.Close;
   QueryLog.Open;
  end;

  With dmodule do begin
    //select value from system_parameters where name like ''USOS_CYKL%''
    SingleValue('select TO_CHAR(DATE_FROM,''YYYY/MM/DD''),TO_CHAR(DATE_TO,''YYYY/MM/DD'') from periods where integration_id = '''+USOS_CYKL.Text+'''');
    //SingleValue('select TO_CHAR(DATE_FROM,''YYYY/MM/DD''),TO_CHAR(DATE_TO,''YYYY/MM/DD'') from periods where rownum =1');
    if dmodule.QWork.RecordCount = 0 then begin
      info('Nie odnaleziono semestru o podanym kodzie cyklu:'+USOS_CYKL.Text);
      PageControl2.TabIndex := 0;
      exit;
    end;
    DateFrom := 'TO_DATE('''+QWork.Fields[0].AsString+''',''YYYY/MM/DD'')';
    DateTo   := 'TO_DATE('''+QWork.Fields[1].AsString+''',''YYYY/MM/DD'')';
  end;

  DM.macros.setMacro( QueryNotSent, 'DATE_FROM', DateFrom);
  DM.macros.setMacro( QueryNotSent, 'DATE_TO', DateTo);

  if (activeTab=1) then begin
   QueryNotSent.Close;
   try
   QueryNotSent.Open;
   except
     copyToClipboard(  QueryNotSent.SQL.Text);
     raise;
   end;
  end;
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
begin
 dmodule.ExportToExcel(GridNotSent);
end;

procedure TFUSOS.ExportHtmlClick(Sender: TObject);
begin
 dmodule.ExportToHTML(GridNotSent);
end;

end.
