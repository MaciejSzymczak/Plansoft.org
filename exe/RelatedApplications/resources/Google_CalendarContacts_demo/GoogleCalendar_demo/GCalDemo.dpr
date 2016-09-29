program GCalDemo;

uses
  Forms,
  Main in 'Main.pas' {MainForm},
  GoogleCal in 'GoogleCal.pas',
  EditCal in 'EditCal.pas' {EditCalForm},
  EditEvent in 'EditEvent.pas' {EditEventForm},
  EditRem in 'EditRem.pas' {ReminderForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TEditCalForm, EditCalForm);
  Application.CreateForm(TEditEventForm, EditEventForm);
  Application.CreateForm(TReminderForm, ReminderForm);
  Application.Run;
end.
