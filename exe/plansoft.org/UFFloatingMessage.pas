unit UFFloatingMessage;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls;

type
  TFFloatingMessage = class(TForm)
    Timer: TTimer;
    message: TRichEdit;
    procedure TimerTimer(Sender: TObject);
  private
    transparency : integer;
  public
    procedure showModal(message : string);


  end;

var
  FFloatingMessage: TFFloatingMessage;

implementation

{$R *.dfm}

procedure TFFloatingMessage.showModal(message: string);
begin
 self.Message.Lines.text := #13+#10+message;
 timer.Enabled := true;
  self.AlphaBlend := true;
  transparency := 400;
  self.AlphaBlendValue := 255;
 self.Show;
end;


procedure TFFloatingMessage.TimerTimer(Sender: TObject);
var step : integer;
begin
 transparency := transparency - 10;
 if (transparency<=255)  then
     self.AlphaBlendValue := transparency;
 if (transparency<20) then begin
   self.Hide;
   timer.Enabled := false;
 end;
end;

end.
