unit UFReadString;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UFormConfig, StdCtrls, Buttons, ExtCtrls;

type
  TFReadString = class(TFormConfig)
    Panel1: TPanel;
    BOK: TBitBtn;
    BAnuluj: TBitBtn;
    S: TEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FReadString: TFReadString;

Function ReadString(aCaption : String; Var Str : String;  PasswordChar : Char) : TModalResult;

implementation

{$R *.DFM}

Function ReadString(aCaption : String; Var Str : String; PasswordChar : Char) : TModalResult;
Begin
 With FReadString Do Begin
  FReadString := TFReadString.Create(Application);
  S.PasswordChar := PasswordChar;
  S.Text := Str;
  Caption := aCaption;
  ActiveControl := S;
  S.SelStart := Length(S.Text);
  Result := ShowModal;
  Str := S.Text;
  Free;
 End;

End;


end.
