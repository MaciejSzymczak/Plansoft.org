unit UFSUSOS;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormConfig, StdCtrls, Buttons, ExtCtrls, Grids, DBGrids,
  RXDBCtrl, DB, ADODB, ComCtrls;

type
  TFUSOS = class(TFormConfig)
    Panel1: TPanel;
    BZamknij: TBitBtn;
    Panel2: TPanel;
    Grid: TRxDBGrid;
    Source: TDataSource;
    Query: TADOQuery;
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
    procedure BZamknijClick(Sender: TObject);
    procedure RESCAT_COMB_IDSelClick(Sender: TObject);
    procedure RESCAT_COMB_IDChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    Procedure SaveParams;
  public
    { Public declarations }
  end;

var
  FUSOS: TFUSOS;

implementation

{$R *.dfm}

Uses AutoCreate, DM;

procedure TFUSOS.BZamknijClick(Sender: TObject);
begin
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
  USOS_CYKL.text          := dmodule.dbgetSystemParam('USOS_CYKL');
  RESCAT_COMB_ID.text     := dmodule.dbgetSystemParam('USOS_RESCAT_COMB_ID');
  USOS_HOURS_PER_DAY.text := dmodule.dbgetSystemParam('USOS_HOURS_PER_DAY');
  USOS_INTEGRATION_USER.text := dmodule.dbgetSystemParam('USOS_INTEGRATION_USER');
  USOS_ONLINE.text := dmodule.dbgetSystemParam('USOS_ONLINE');
  Query.Active := true;
end;

procedure TFUSOS.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  SaveParams;
end;

procedure TFUSOS.BitBtn2Click(Sender: TObject);
begin
    SaveParams;
    dmodule.sql('begin integration_from_usos (:pCleanYpMode ); end;'
            ,'pCleanYpMode=Y'
    );
    Query.Close;
    Query.Open;
end;

procedure TFUSOS.SaveParams;
begin
  dmodule.dbSetSystemParam('USOS_CYKL', USOS_CYKL.text);
  dmodule.dbSetSystemParam('USOS_RESCAT_COMB_ID', RESCAT_COMB_ID.text);
  dmodule.dbSetSystemParam('USOS_HOURS_PER_DAY', USOS_HOURS_PER_DAY.text);
  dmodule.dbSetSystemParam('USOS_INTEGRATION_USER', USOS_INTEGRATION_USER.text);
  dmodule.dbSetSystemParam('USOS_ONLINE', USOS_ONLINE.text);
end;

procedure TFUSOS.BitBtn1Click(Sender: TObject);
begin
    SaveParams;
    dmodule.sql('begin integration_to_usos (:pCleanYpMode ); end;'
            ,'pCleanYpMode=Y'
    );
    Query.Close;
    Query.Open;
end;

end.
