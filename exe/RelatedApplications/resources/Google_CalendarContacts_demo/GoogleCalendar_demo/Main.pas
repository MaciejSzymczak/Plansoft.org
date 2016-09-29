unit Main;

interface

uses Classes, Controls, Forms, StdCtrls;

type
  TMainForm = class(TForm)
    Label1: TLabel;
    EmailEd: TEdit;
    PasswordEd: TEdit;
    ConnectBtn: TButton;
    GroupBox1: TGroupBox;
    CalendarsLB: TListBox;
    CalAddBtn: TButton;
    CalEditBtn: TButton;
    CalDeleteBtn: TButton;
    CalRefreshBtn: TButton;
    EventsLB: TListBox;
    EventAddBtn: TButton;
    EventEditBtn: TButton;
    EventDeleteBtn: TButton;
    EventRefreshBtn: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ConnectBtnClick(Sender: TObject);
    procedure CalendarsLBClick(Sender: TObject);
    procedure CalAddBtnClick(Sender: TObject);
    procedure CalEditBtnClick(Sender: TObject);
    procedure CalDeleteBtnClick(Sender: TObject);
    procedure EventsLBClick(Sender: TObject);
    procedure EventAddBtnClick(Sender: TObject);
    procedure EventEditBtnClick(Sender: TObject);
    procedure EventDeleteBtnClick(Sender: TObject);
    procedure CalRefreshBtnClick(Sender: TObject);
    procedure EventRefreshBtnClick(Sender: TObject);
  private
    procedure UpdateCalendars;
    procedure UpdateCalButtons;
    procedure UpdateEvents;
    procedure UpdateEventButtons;
  end;

var
  MainForm: TMainForm;

implementation

uses GoogleCal, SysUtils, EditCal, EditEvent;

{$R *.dfm}

var
  GCalendars: TGCalendars;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  GCalendars := TGCalendars.Create;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  GCalendars.Free;
end;

procedure TMainForm.UpdateCalendars;
var
  I: Integer;
begin
  CalendarsLB.Clear;
  for I := 0 to GCalendars.CalendarCount - 1 do
    CalendarsLB.Items.Add(GCalendars.Calendars[I].Name);
  UpdateCalButtons;
  UpdateEvents;
end;

procedure TMainForm.UpdateCalButtons;
begin
  CalEditBtn.Enabled := CalendarsLB.ItemIndex >= 0;
  CalDeleteBtn.Enabled := CalendarsLB.ItemIndex >= 0;
end;

procedure TMainForm.UpdateEvents;
var
  I: Integer;
begin
  EventsLB.Clear;
  if CalendarsLB.ItemIndex >= 0 then
  begin
    Screen.Cursor := crHourGlass;
    try
      GCalendars[CalendarsLB.ItemIndex].LoadEvents;
      for I := 0 to GCalendars[CalendarsLB.ItemIndex].EventCount - 1 do
        with GCalendars[CalendarsLB.ItemIndex].Events[I] do
          EventsLB.Items.Add(Format('%s - %s  %s', [DateTimeToStr(StartTime), DateTimeToStr(EndTime), Title]));
    finally
      Screen.Cursor := crDefault;
    end;
  end;
  UpdateEventButtons;
end;

procedure TMainForm.UpdateEventButtons;
begin
  EventAddBtn.Enabled := CalendarsLB.ItemIndex >= 0;
  EventEditBtn.Enabled := EventsLB.ItemIndex >= 0;
  EventDeleteBtn.Enabled := EventsLB.ItemIndex >= 0;
end;

procedure TMainForm.ConnectBtnClick(Sender: TObject);
begin
  GCalendars.Connect(EmailEd.Text, PasswordEd.Text);
  GCalendars.LoadCalendars;
  CalAddBtn.Enabled := True;
  UpdateCalendars;
end;

procedure TMainForm.CalendarsLBClick(Sender: TObject);
begin
  UpdateCalButtons;
  UpdateEvents;
end;

procedure TMainForm.CalAddBtnClick(Sender: TObject);
begin
  EditCalForm.Calendars := GCalendars;
  EditCalForm.Calendar := nil;
  if EditCalForm.ShowModal = mrOK then
    CalendarsLB.Items.Add(EditCalForm.Calendar.Name);
end;

procedure TMainForm.CalEditBtnClick(Sender: TObject);
begin
  EditCalForm.Calendars := GCalendars;
  EditCalForm.Calendar := GCalendars[CalendarsLB.ItemIndex];
  if EditCalForm.ShowModal = mrOK then
    CalendarsLB.Items[CalendarsLB.ItemIndex] := GCalendars[CalendarsLB.ItemIndex].Name;
end;

procedure TMainForm.CalDeleteBtnClick(Sender: TObject);
begin
  GCalendars.DeleteCalendar(CalendarsLB.ItemIndex);
  CalendarsLB.Items.Delete(CalendarsLB.ItemIndex);
  UpdateCalButtons;
  UpdateEvents;
end;

procedure TMainForm.CalRefreshBtnClick(Sender: TObject);
begin
  UpdateCalendars;
end;

procedure TMainForm.EventsLBClick(Sender: TObject);
begin
  UpdateEventButtons;
end;

procedure TMainForm.EventAddBtnClick(Sender: TObject);
begin
  EditEventForm.Event := GCalendars[CalendarsLB.ItemIndex].NewEvent;
  if EditEventForm.ShowModal = mrOK then
  begin
    EventsLB.Items.Add(Format('%s - %s  %s', [DateTimeToStr(EditEventForm.Event.StartTime),
      DateTimeToStr(EditEventForm.Event.EndTime), EditEventForm.Event.Title]));
    UpdateEventButtons;
  end
  else
    GCalendars[CalendarsLB.ItemIndex].DeleteEvent(GCalendars[CalendarsLB.ItemIndex].EventCount - 1);
end;

procedure TMainForm.EventEditBtnClick(Sender: TObject);
begin
  EditEventForm.Event := GCalendars[CalendarsLB.ItemIndex].Events[EventsLB.ItemIndex];
  if EditEventForm.ShowModal = mrOK then
    EventsLB.Items[EventsLB.ItemIndex] := Format('%s - %s  %s', [DateTimeToStr(EditEventForm.Event.StartTime),
      DateTimeToStr(EditEventForm.Event.EndTime), EditEventForm.Event.Title]);
end;

procedure TMainForm.EventDeleteBtnClick(Sender: TObject);
begin
  GCalendars[CalendarsLB.ItemIndex].DeleteEvent(EventsLB.ItemIndex);
  EventsLB.Items.Delete(EventsLB.ItemIndex);
  UpdateEventButtons;
end;

procedure TMainForm.EventRefreshBtnClick(Sender: TObject);
begin
  UpdateEvents;
end;

end.
