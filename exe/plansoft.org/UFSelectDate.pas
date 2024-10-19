unit UFSelectDate;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, StdCtrls, Buttons, ComCtrls;

type
  TFSelectDate = class(TForm)
    SpeedButton2: TSpeedButton;
    ButtonOK: TSpeedButton;
    date: TDateTimePicker;
    BitBtn1: TBitBtn;
    SelectDates: TPopupMenu;
    Przedwczoraj1: TMenuItem;
    Wczoraj1: TMenuItem;
    MenuItem3: TMenuItem;
    Cdesc3: TMenuItem;
    Cdesc4: TMenuItem;
    procedure BitBtn1Click(Sender: TObject);
    procedure ButtonOKClick(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure Wczoraj1Click(Sender: TObject);
    procedure Przedwczoraj1Click(Sender: TObject);
    procedure Cdesc3Click(Sender: TObject);
    procedure Cdesc4Click(Sender: TObject);
    procedure dateChange(Sender: TObject);
  private
    mr : TModalResult;
  public
    function showModalWithDefault(var date: TDateTime) : TModalResult;
  end;

var
  FSelectDate: TFSelectDate;

implementation

{$R *.dfm}

procedure TFSelectDate.BitBtn1Click(Sender: TObject);
var point : tpoint;
    btn   : tcontrol;
begin
 btn     := sender as tcontrol;
 Point.x := 0;
 Point.y := btn.Height;
 Point   := btn.ClientToScreen(Point);
 SelectDates.Popup(Point.X,Point.Y);
end;

function TFSelectDate.showModalWithDefault(
  var date: TDateTime): TModalResult;
begin
 mr := mrCancel;
 self.date.DateTime := date;
 showModal;
 result := mr;
end;

procedure TFSelectDate.ButtonOKClick(Sender: TObject);
begin                   
 mr := mrOk;
 Close;
end;

procedure TFSelectDate.SpeedButton2Click(Sender: TObject);
begin
 mr := mrCancel;
 Close;
end;

procedure TFSelectDate.MenuItem3Click(Sender: TObject);
begin
 date.Date := now;
 ButtonOKClick(nil);
end;

procedure TFSelectDate.Wczoraj1Click(Sender: TObject);
begin
 date.Date := now-1;
 ButtonOKClick(nil);
end;

procedure TFSelectDate.Przedwczoraj1Click(Sender: TObject);
begin
 date.Date := now-2;
 ButtonOKClick(nil);
end;

procedure TFSelectDate.Cdesc3Click(Sender: TObject);
begin
 date.Date := now+1;
 ButtonOKClick(nil);
end;

procedure TFSelectDate.Cdesc4Click(Sender: TObject);
begin
 date.Date := now+2;
 ButtonOKClick(nil);
end;

procedure TFSelectDate.dateChange(Sender: TObject);
begin
 ButtonOKClick(nil);
end;

end.
