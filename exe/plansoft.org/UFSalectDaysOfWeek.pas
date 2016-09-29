unit UFSalectDaysOfWeek;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, uutilityparent;

type
  TFSelectDaysOfWeek = class(TForm)
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    c2: TCheckBox;
    c3: TCheckBox;
    c4: TCheckBox;
    c5: TCheckBox;
    c6: TCheckBox;
    c7: TCheckBox;
    c1: TCheckBox;
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    mr : TModalResult;
  public
    function showModalWithDefaults(var daysOfWeek: string) : TModalResult;
  end;

var
  FSelectDaysOfWeek: TFSelectDaysOfWeek;

implementation

{$R *.dfm}

procedure TFSelectDaysOfWeek.SpeedButton2Click(Sender: TObject);
begin
 mr := mrCancel;
 Close;
end;

procedure TFSelectDaysOfWeek.SpeedButton1Click(Sender: TObject);
begin
 mr := mrOk;
 Close;
end;

function TFSelectDaysOfWeek.showModalWithDefaults(
  var daysOfWeek: string): TModalResult;
begin
 c1.Checked := daysOfWeek[1]='+';
 c2.Checked := daysOfWeek[2]='+';
 c3.Checked := daysOfWeek[3]='+';
 c4.Checked := daysOfWeek[4]='+';
 c5.Checked := daysOfWeek[5]='+';
 c6.Checked := daysOfWeek[6]='+';
 c7.Checked := daysOfWeek[7]='+';
 mr := mrCancel;
 showModal;
 if mr=mrOK then
   daysOfWeek :=
        BoolToStr(c1.Checked)
       +BoolToStr(c2.Checked)
       +BoolToStr(c3.Checked)
       +BoolToStr(c4.Checked)
       +BoolToStr(c5.Checked)
       +BoolToStr(c6.Checked)
       +BoolToStr(c7.Checked);
 result := mr;
end;

end.
