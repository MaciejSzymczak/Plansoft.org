unit UFDatabaseLoginWithCard;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UFormConfig, StdCtrls, Buttons, ExtCtrls, StrHlder, UUtilityParent;

type
  TFDatabaseLoginWithCard = class(TFormConfig)
    Panel1: TPanel;
    BAnuluj: TBitBtn;
    Bok: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Database: TEdit;
    UserName: TEdit;
    Password: TEdit;
    ID: TPanel;
    BWybierz: TBitBtn;
    OpenDialog: TOpenDialog;
    procedure BWybierzClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FDatabaseLoginWithCard: TFDatabaseLoginWithCard;

Function Login(DataBaseName : ShortString; Var aUserName, aPassword, Path : ShortString) : TModalResult;

implementation

{$R *.DFM}

Function Login(DataBaseName : ShortString; Var aUserName, aPassword, Path : ShortString) : TModalResult;
Begin
 FDatabaseLoginWithCard :=  TFDatabaseLoginWithCard.Create(Application);

 With FDatabaseLoginWithCard Do Begin
  Database.Text := DataBaseName;
  //UserName.Text := aUserName;
  Password.Text := aPassword;

  Result := ShowModal;

  Path      := ID.Caption;
  aUserName := UserName.Text;
  aPassword := Password.Text;
  Free;
 End;
End;

procedure TFDatabaseLoginWithCard.BWybierzClick(Sender: TObject);
begin
  inherited;
  OpenDialog.FileName := ID.Caption;
  If OpenDialog.Execute Then Begin
    ID.Caption := OpenDialog.FileName;
  End;
end;


end.
