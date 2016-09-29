unit UFChangePassword;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormConfig, StdCtrls, Buttons, ExtCtrls;

type
  TFChangePassword = class(TFormConfig)
    Label1: TLabel;
    Label2: TLabel;
    ENewPassword: TEdit;
    EConfirmPassword: TEdit;
    Panel1: TPanel;
    BCancel: TBitBtn;
    BChangePassword: TBitBtn;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    procedure BChangePasswordClick(Sender: TObject);
    procedure BCancelClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormShow(Sender: TObject);
  private
    gCanClose : boolean;
  public
    { Public declarations }
  end;

var
  FChangePassword: TFChangePassword;

implementation

{$R *.dfm}

uses uutilityParent, dm;

procedure TFChangePassword.BChangePasswordClick(Sender: TObject);
begin
  inherited;
  gCanClose := true;

  if (ENewPassword.Text = '') or (EConfirmPassword.Text = '') then begin info('Aby kontynuowa� wprowad� dwukrotnie nowe has�o'); gCanClose := false; exit; end;
  if (ENewPassword.Text <> EConfirmPassword.Text) then begin info('Has�o wprowadzone za pierwszym razem r�ni si� od has�a wprowadzonego za drugim razem. Aby kontynuowa� wprowad� drukrotnie to samo has�o'); gCanClose := false; exit; end;

  dmodule.SQL('alter user '+DM.UserName+' identified by "'+ENewPassword.Text+'"');

  info ('Has�o dla u�ytkownika '+DM.UserName+' zosta�o poprawnie zmienione. Stare has�o utraci�o wa�no��, zapami�taj nowe has�o');
end;

procedure TFChangePassword.BCancelClick(Sender: TObject);
begin
  inherited;
 gCanClose := true;
end;

procedure TFChangePassword.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  inherited;
  canClose := gCanClose;
end;

procedure TFChangePassword.FormShow(Sender: TObject);
begin
  inherited;
  gCanClose := true;
  self.Caption := 'Zmiana has�a u�ytkownika ' + DM.UserName;
  ENewPassword.Text := '';
  EConfirmPassword.Text := '';
end;

end.
