unit UFPattern;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons;

type
  TFPattern = class(TForm)
    procedure bdesc1Click(Sender: TObject);
  private
    { Private declarations }
  public
    modalResult : integer;
  end;

var
  FPattern: TFPattern;

implementation

{$R *.dfm}

uses uutilityparent, autocreate;

procedure TFPattern.bdesc1Click(Sender: TObject);
Var KeyValue : ShortString;
begin
end;

end.
