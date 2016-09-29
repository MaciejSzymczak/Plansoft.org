unit UFAbolitionTime;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormConfig, StdCtrls, Buttons, ExtCtrls, uutilityparent;

type
  TFAbolitionTime = class(TFormConfig)
    Label1: TLabel;
    Panel1: TPanel;
    BClose: TBitBtn;
    Panel2: TPanel;
    Label3: TLabel;
    abolitionTime: TEdit;
    Panel3: TPanel;
    Label2: TLabel;
    code: TEdit;
    BApply: TBitBtn;
    Label4: TLabel;
    procedure FormShow(Sender: TObject);
    procedure BApplyClick(Sender: TObject);
    procedure BCloseClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FAbolitionTime: TFAbolitionTime;

implementation

uses DM;

{$R *.dfm}

procedure TFAbolitionTime.FormShow(Sender: TObject);
begin
  inherited;
  abolitionTime.Text := dmodule.dbEncGetSystemParam('ABOLITION_TIME');
end;

procedure TFAbolitionTime.BApplyClick(Sender: TObject);
begin
  BApply.Enabled := false;
  BApply.Refresh;
  sleep(1000 * 5 ); //avoid brutalforce guessing procedure
  BApply.Enabled := true;
  BApply.Refresh;

  if copy(DecryptShortString(1,code.Text, dm.gpassString),5,1) <> '.' then begin
    serror('Podany kod nie jest prawid³owy ');
    exit;
  end;

  dmodule.DbSetSystemParam( 'ABOLITION_TIME', code.Text );
  dmodule.pAbolitionTime := dmodule.dbEncGetSystemParam( 'ABOLITION_TIME' ) ;
  FormShow(nil);
  info('Zarejestrowano czas trwania us³ugi serwisowej do dnia: ' + dmodule.pAbolitionTime);
end;

procedure TFAbolitionTime.BCloseClick(Sender: TObject);
begin
  inherited;
  Close;
end;

end.
