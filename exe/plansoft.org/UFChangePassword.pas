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

  if (ENewPassword.Text = '') or (EConfirmPassword.Text = '') then begin info('Aby kontynuowaæ wprowadŸ dwukrotnie nowe has³o'); gCanClose := false; exit; end;
  if (ENewPassword.Text <> EConfirmPassword.Text) then begin info('Has³o wprowadzone za pierwszym razem ró¿ni siê od has³a wprowadzonego za drugim razem. Aby kontynuowaæ wprowadŸ drukrotnie to samo has³o'); gCanClose := false; exit; end;

  dmodule.SQL('alter user '+DM.UserName+' identified by "'+ENewPassword.Text+'"');

  info ('Has³o dla u¿ytkownika '+DM.UserName+' zosta³o poprawnie zmienione. Stare has³o utraci³o wa¿noœæ, zapamiêtaj nowe has³o');
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
  self.Caption := 'Zmiana has³a u¿ytkownika ' + DM.UserName;
  ENewPassword.Text := '';
  EConfirmPassword.Text := '';
end;

end.
