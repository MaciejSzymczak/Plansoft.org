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
    D1: TBitBtn;
    D2: TBitBtn;
    D3: TBitBtn;
    D4: TBitBtn;
    D5: TBitBtn;
    D6: TBitBtn;
    D7: TBitBtn;
    procedure BitBtn1Click(Sender: TObject);
    procedure ButtonOKClick(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure Wczoraj1Click(Sender: TObject);
    procedure Przedwczoraj1Click(Sender: TObject);
    procedure Cdesc3Click(Sender: TObject);
    procedure Cdesc4Click(Sender: TObject);
    procedure D1Click(Sender: TObject);
    procedure D2Click(Sender: TObject);
    procedure D3Click(Sender: TObject);
    procedure D4Click(Sender: TObject);
    procedure D5Click(Sender: TObject);
    procedure D6Click(Sender: TObject);
    procedure D7Click(Sender: TObject);
    procedure dateExit(Sender: TObject);
  private
    mr : TModalResult;
  public
    function showModalWithDefault(var date: TDateTime) : TModalResult;
    function getFirstDayOfWeekInPeriod( dayOfWeek : word) : tdatetime;
  end;

var
  FSelectDate: TFSelectDate;

implementation

uses DM, DateUtils, UFMain, UUtilityParent;

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

function TFSelectDate.getFirstDayOfWeekInPeriod(
  dayOfWeek: word): tdatetime;
Var     DateFrom, DateTo : String;
      res : tdatetime;

function getFirstDay(startDate, lastDay: TDateTime; dayOfWeek: Word): TDateTime;
var
  currentDayOfWeek: Word;
  daysUntilTarget: Integer;
begin
  // Get the day of the week for startDate (1 = Sunday, 2 = Monday, ..., 7 = Saturday)
  currentDayOfWeek := DayOfTheWeek(startDate);

  // Calculate how many days to add to reach the desired dayOfWeek
  daysUntilTarget := (dayOfWeek - currentDayOfWeek + 7) mod 7;

  // Calculate the target date
  Result := startDate + daysUntilTarget;

  // Check if the result is within the specified range
  if (Result > lastDay) then
    Result := 0; // Return 0 if no valid day is found in the range
end;
begin
   With DModule do begin
     Dmodule.SingleValue('SELECT TO_CHAR(DATE_FROM,''YYYY-MM-DD''),TO_CHAR(DATE_TO,''YYYY-MM-DD''), date_to-date_from, DATE_FROM, HOURS_PER_DAY FROM PERIODS WHERE ID='+FMain.conPeriod.Text);
     DateFrom := QWork.Fields[0].AsString;
     DateTo   := QWork.Fields[1].AsString;

     result := getFirstDay( YYYYMMDDToDateTime(DateFrom) , YYYYMMDDToDateTime(DateTo), dayOfWeek);
   End;
end;

procedure TFSelectDate.D1Click(Sender: TObject);
begin
  date.DateTime :=   getFirstDayOfWeekInPeriod(1);
  ButtonOKClick(nil);
end;

procedure TFSelectDate.D2Click(Sender: TObject);
begin
  date.DateTime :=   getFirstDayOfWeekInPeriod(2);
  ButtonOKClick(nil);
end;

procedure TFSelectDate.D3Click(Sender: TObject);
begin
  date.DateTime :=   getFirstDayOfWeekInPeriod(3);
  ButtonOKClick(nil);
end;

procedure TFSelectDate.D4Click(Sender: TObject);
begin
  date.DateTime :=   getFirstDayOfWeekInPeriod(4);
  ButtonOKClick(nil);
end;

procedure TFSelectDate.D5Click(Sender: TObject);
begin
  date.DateTime :=   getFirstDayOfWeekInPeriod(5);
  ButtonOKClick(nil);
end;

procedure TFSelectDate.D6Click(Sender: TObject);
begin
  date.DateTime :=   getFirstDayOfWeekInPeriod(6);
  ButtonOKClick(nil);
end;

procedure TFSelectDate.D7Click(Sender: TObject);
begin
  date.DateTime :=   getFirstDayOfWeekInPeriod(7);
  ButtonOKClick(nil);
end;

procedure TFSelectDate.dateExit(Sender: TObject);
begin
 ButtonOKClick(nil);
end;

end.
