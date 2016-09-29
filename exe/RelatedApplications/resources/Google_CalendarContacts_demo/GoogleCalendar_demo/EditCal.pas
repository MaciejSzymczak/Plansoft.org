unit EditCal;

interface

uses Classes, Controls, Forms, StdCtrls, GoogleCal;

type
  TEditCalForm = class(TForm)
    Label1: TLabel;
    NameEd: TEdit;
    DescriptMem: TMemo;
    LocationEd: TEdit;
    TimeZoneEd: TEdit;
    OKBtn: TButton;
    procedure FormShow(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
  public
    Calendars: TGCalendars;
    Calendar: TGCalendar;
  end;

var
  EditCalForm: TEditCalForm;

implementation

{$R *.dfm}

procedure TEditCalForm.FormShow(Sender: TObject);
begin
  if Calendar = nil then
  begin
    NameEd.Text := '';
    DescriptMem.Text := '';
    LocationEd.Text := '';
    TimeZoneEd.Text := '';
  end
  else
  begin
    NameEd.Text := Calendar.Name;
    DescriptMem.Text := Calendar.Description;
    LocationEd.Text := Calendar.Location;
    TimeZoneEd.Text := Calendar.TimeZone;
  end;
end;

procedure TEditCalForm.OKBtnClick(Sender: TObject);
begin
  if Calendar = nil then
    Calendar := Calendars.NewCalendar;
  Calendar.Name := NameEd.Text;
  Calendar.Description := DescriptMem.Text;
  Calendar.Location := LocationEd.Text;
  Calendar.Store;
end;

end.
