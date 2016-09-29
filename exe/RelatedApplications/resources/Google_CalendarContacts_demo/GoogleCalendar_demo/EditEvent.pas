unit EditEvent;

interface

uses Classes, Controls, Forms, StdCtrls, ComCtrls, GoogleCal;

type
  TEditEventForm = class(TForm)
    Label1: TLabel;
    WhatEd: TEdit;
    StartDateDTP: TDateTimePicker;
    StartTimeDTP: TDateTimePicker;
    EndDateDTP: TDateTimePicker;
    EndTimeDTP: TDateTimePicker;
    AllDayCB: TCheckBox;
    LocationEd: TEdit;
    DescriptMem: TMemo;
    OKBtn: TButton;
    GroupBox1: TGroupBox;
    RemindersLB: TListBox;
    RemAddBtn: TButton;
    RemEditBtn: TButton;
    RemDeleteBtn: TButton;
    procedure FormShow(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure AllDayCBClick(Sender: TObject);
    procedure RemindersLBClick(Sender: TObject);
    procedure RemAddBtnClick(Sender: TObject);
    procedure RemEditBtnClick(Sender: TObject);
    procedure RemDeleteBtnClick(Sender: TObject);
  protected
    procedure UpdateReminders;
    procedure UpdateReminderButtons;
  public
    Event: TGEvent;
  end;

var
  EditEventForm: TEditEventForm;

implementation

uses SysUtils, EditRem;

{$R *.dfm}

const
  ReminderMethodStr: Array[TReminderMethod] of String = ('None', 'Pop-up', 'Email', 'SMS');
  ReminderPeriodStr: Array[TReminderPeriod] of String = ('5 minutes', '10 minutes', '15 minutes',
    '20 minutes', '25 minutes', '30 minutes', '45 minutes', '1 hour', '2 hours', '3 hours', '12 hours',
    '1 day', '2 days', '1 week');

procedure TEditEventForm.FormShow(Sender: TObject);
begin
  WhatEd.Text := Event.Title;
  LocationEd.Text := Event.Location;
  DescriptMem.Text := Event.Description;
  if Event.StartTime = 0 then
  begin
    StartDateDTP.DateTime := Date;
    StartTimeDTP.DateTime := Round(Now * 24) / 24;
    EndDateDTP.DateTime := Date;
    EndTimeDTP.DateTime := StartTimeDTP.DateTime + 1 / 24;
    AllDayCB.Checked := False;
  end
  else
  begin
    StartDateDTP.DateTime := Event.StartTime;
    StartTimeDTP.DateTime := Event.StartTime;
    EndDateDTP.DateTime := Event.EndTime;
    EndTimeDTP.DateTime := Event.EndTime;
    AllDayCB.Checked := Event.AllDay;
  end;
  UpdateReminders;
end;

procedure TEditEventForm.UpdateReminders;
var
  I: Integer;
begin
  RemindersLB.Clear;
  for I := 0 to Event.ReminderCount - 1 do
    RemindersLB.Items.Add(Format('%s  %s', [ReminderMethodStr[Event.Reminders[I]^.Method],
      ReminderPeriodStr[Event.Reminders[I]^.Period]]));
  UpdateReminderButtons;
end;

procedure TEditEventForm.UpdateReminderButtons;
begin
  RemEditBtn.Enabled := RemindersLB.ItemIndex >= 0;
  RemDeleteBtn.Enabled := RemindersLB.ItemIndex >= 0;
end;

procedure TEditEventForm.OKBtnClick(Sender: TObject);
begin
  Event.Title := WhatEd.Text;
  Event.StartTime := Trunc(StartDateDTP.DateTime) + Frac(StartTimeDTP.DateTime);
  Event.EndTime := Trunc(EndDateDTP.DateTime) + Frac(EndTimeDTP.DateTime);
  Event.AllDay := AllDayCB.Checked;
  Event.Location := LocationEd.Text;
  Event.Description := DescriptMem.Text;
  Event.Store;
end;

procedure TEditEventForm.AllDayCBClick(Sender: TObject);
begin
  StartTimeDTP.Enabled := not AllDayCB.Checked;
  EndTimeDTP.Enabled := not AllDayCB.Checked;
  if AllDayCB.Checked then
  begin
    StartTimeDTP.DateTime := Date;
    EndTimeDTP.DateTime := Date;
  end
  else
  begin
    StartTimeDTP.DateTime := Round(Now * 24) / 24;
    EndTimeDTP.DateTime := StartTimeDTP.DateTime + 1 / 24;
  end
end;

procedure TEditEventForm.RemindersLBClick(Sender: TObject);
begin
  UpdateReminderButtons;
end;

procedure TEditEventForm.RemAddBtnClick(Sender: TObject);
begin
  ReminderForm.MethodCB.ItemIndex := 1;
  ReminderForm.PeriodCB.ItemIndex := 1;
  if ReminderForm.ShowModal = mrOK then
    with Event.NewReminder^ do
    begin
      Method := TReminderMethod(ReminderForm.MethodCB.ItemIndex);
      Period := TReminderPeriod(ReminderForm.PeriodCB.ItemIndex);
      UpdateReminders;
    end;
end;

procedure TEditEventForm.RemEditBtnClick(Sender: TObject);
begin
  with Event.Reminders[RemindersLB.ItemIndex]^ do
  begin
    ReminderForm.MethodCB.ItemIndex := Integer(Method);
    ReminderForm.PeriodCB.ItemIndex := Integer(Period);
    if ReminderForm.ShowModal = mrOK then
    begin
      Method := TReminderMethod(ReminderForm.MethodCB.ItemIndex);
      Period := TReminderPeriod(ReminderForm.PeriodCB.ItemIndex);
      UpdateReminders;
    end;
  end;
end;

procedure TEditEventForm.RemDeleteBtnClick(Sender: TObject);
begin
  Event.DeleteReminder(RemindersLB.ItemIndex);
  RemindersLB.Items.Delete(RemindersLB.ItemIndex);
  UpdateReminderButtons;
end;

end.
