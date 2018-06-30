unit UFWarning;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormConfig, StdCtrls, ExtCtrls, Buttons;

type
  TFWarning = class(TFormConfig)
    Image1: TImage;
    Memo: TMemo;
    Panel1: TPanel;
    bClose: TBitBtn;
    chShowOnceADay: TCheckBox;
    Label1: TLabel;
    procedure bCloseClick(Sender: TObject);
    procedure chShowOnceADayClick(Sender: TObject);
  private
    { Private declarations }
  public
    infoID : String;
    Procedure showMessage(pinfoID : String; message: string);
  end;

var
  FWarning: TFWarning;

implementation

{$R *.dfm}

Uses UUtilityParent, dm;

procedure TFWarning.bCloseClick(Sender: TObject);
begin
  if  chShowOnceADay.Checked then SetSystemParam('MESSAGE.' + infoID,DateToYYYYMMDD(Date));
  chShowOnceADay.Checked := false;
  close;
end;

procedure TFWarning.showMessage(pinfoID : String; message: string);
begin
    infoID := pinfoID;
    If GetSystemParam('MESSAGE.' + infoID) <> DateToYYYYMMDD(Date) Then Begin
      FWarning.Memo.Lines.Text :=   message;
      FWarning.ShowModal;
    End;
end;

procedure TFWarning.chShowOnceADayClick(Sender: TObject);
begin
  if chShowOnceADay.Checked then
    if (not elementEnabled('"Ukrywanie komunikatów"','2018.06.26', false)) then  chShowOnceADay.Checked := false;
  Label1.Visible := chShowOnceADay.Checked;
end;

end.
