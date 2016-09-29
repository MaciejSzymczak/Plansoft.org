unit UFIntro;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, UutilityParent, jpeg;

type
  TFIntro = class(TForm)
    Image1: TImage;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FIntro: TFIntro;

implementation

{$R *.DFM}

procedure TFIntro.FormCreate(Sender: TObject);
begin
 Hide;
 try Image1.Picture.LoadFromFile(GetD+'\Intro.jpg'); except End;
 Show;
end;

end.
