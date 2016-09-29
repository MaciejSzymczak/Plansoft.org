unit UFBalloon;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls;

type
  TFBalloon = class(TForm)
    Shape1: TShape;
    title: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    CResCat1: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    L: TLabel;
    G: TLabel;
    R: TLabel;
    ResCat1: TLabel;
    S: TLabel;
    F: TLabel;
    O: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FBalloon: TFBalloon;

implementation

{$R *.dfm}

end.
