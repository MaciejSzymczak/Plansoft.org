unit UFGoogleOrgChart;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormConfig, StdCtrls, Buttons, ExtCtrls, Mask, DBCtrls, UFLookupWindow;

type
  TFGoogleOrgChart = class(TFormConfig)
    Panel1: TPanel;
    BOk: TBitBtn;
    BCancel: TBitBtn;
    L: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    G: TComboBox;
    R: TComboBox;
    S: TComboBox;
    showAll: TCheckBox;
    Label5: TLabel;
    ORGID_VALUE: TEdit;
    BSelectORG: TBitBtn;
    ORGID: TEdit;
    map: TMemo;
    procedure BSelectORGClick(Sender: TObject);
    procedure ORGIDChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FGoogleOrgChart: TFGoogleOrgChart;

implementation

uses DM;

{$R *.dfm}

procedure TFGoogleOrgChart.BSelectORGClick(Sender: TObject);
Var ID : ShortString;
begin
  ID := ORGID.Text;
  //If AutoCreate.ORG_UNITSShowModalAsSelect(ID) = mrOK Then Query.FieldByName('PARENT_ID').AsString := ID;
  If LookupWindow(DModule.ADOConnection, 'ORG_UNITS','','SUBSTR(NAME ||'' (''||STRUCT_CODE||'')'',1,63)','NAZWA I KOD STRUKTURY','NAME','0=0','',ID) = mrOK
  Then ORGID.text := ID;
end;

procedure TFGoogleOrgChart.ORGIDChange(Sender: TObject);
begin
  DModule.RefreshLookupEdit(Self, TControl(Sender).Name,'NAME','ORG_UNITS','');
end;

end.
