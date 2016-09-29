unit SpecialCharsTest;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    MainMenu1: TMainMenu;
    Zaglja1: TMenuItem;
    Zaglja2: TMenuItem;
    Zaglja3: TMenuItem;
    Zaglja4: TMenuItem;
    Zaglja5: TMenuItem;
    Zaglja6: TMenuItem;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Zaglja3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses Unit2;

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin

 messagedlg('Za¿ó³æ gêœl¹ jaŸñ',mtError, mbOKCancel, 0);
end;

resourcestring ala = 'Za¿ó³æ gêœl¹ jaŸñ';

procedure TForm1.Zaglja3Click(Sender: TObject);
begin
 messagedlg(ala,mtError, mbOKCancel, 0);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
 form2.showmodal;
end;

end.
