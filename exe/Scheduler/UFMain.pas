unit UFMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UFormConfig, StdCtrls, Buttons, ExtCtrls, UUtilityParent, RXClock, MaxMin, UFInfo,
  Menus, RXShell;

type
  TFMain = class(TForm)
    Panel1: TPanel;
    Clock: TRxClock;
    BConfig: TSpeedButton;
    BMinimize: TSpeedButton;
    BClose: TSpeedButton;
    BInfo: TSpeedButton;
    PopupMenu: TPopupMenu;
    Konfiguruj1: TMenuItem;
    Minimalizuj1: TMenuItem;
    Informacje1: TMenuItem;
    Zakocz1: TMenuItem;
    RxTrayIcon1: TRxTrayIcon;
    Status: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure BConfigClick(Sender: TObject);
    procedure BMinimizeClick(Sender: TObject);
    procedure BCloseClick(Sender: TObject);
    procedure ClockAlarm(Sender: TObject);
    procedure BInfoClick(Sender: TObject);
    procedure Konfiguruj1Click(Sender: TObject);
    procedure Minimalizuj1Click(Sender: TObject);
    procedure Informacje1Click(Sender: TObject);
    procedure Zakocz1Click(Sender: TObject);
    procedure RxTrayIcon1Click(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormPaint(Sender: TObject);
  private
    FirstOnPaint : Boolean;
  public
    Procedure ShowMessage;
    Procedure SetAlarm(Time : TDateTime);
    Procedure DisableAlarm;
    Function  GetAlarm : TDateTime;
    // -1 remains that there is no alarm
  end;

var
  FMain: TFMain;

implementation

uses UFConfiguration;

{$R *.DFM}
Procedure TFMain.DisableAlarm;
Begin
 Clock.AlarmEnabled := False;
End;

Procedure TFMain.SetAlarm(Time : TDateTime);
Var T, OldLongTimeFormat : ShortString;
Begin
 If Time = -1 Then Begin
  DisableAlarm;
  Status.Caption := 'Nastêpne: Brak';
  Exit;
 End;

 OldLongTimeFormat := LongTimeFormat;
 LongTimeFormat := 'hh:mm:ss';
 T := TimeToStr(Time);
 With Clock Do Begin
  AlarmEnabled:= True;
  AlarmHour   := StrToInt(Copy(T,1,2));
  AlarmMinute := StrToInt(Copy(T,4,2));
  AlarmSecond := StrToInt(Copy(T,7,2));

  Status.Caption := 'Nastêpne: '+T;
 End;
 LongTimeFormat := OldLongTimeFormat;
End;

Procedure TFMain.ShowMessage;
Begin
 DisableAlarm;
 //Application.Restore;
 //Application.BringToFront;
 Self.Show;

 UutilityParent.executeFileAndWait( FConfiguration.FProgram.text );

 //Application.Minimize;
 Self.Hide;
 SetAlarm(GetAlarm);
End;



procedure TFMain.FormCreate(Sender: TObject);
function ExtractFileNameEX(const AFileName:String): String;
 var
   I: integer;
 begin
    I := LastDelimiter('.'+PathDelim+DriveDelim,AFileName);
        if (I=0)  or  (AFileName[I] <> '.')
            then
                 I := MaxInt;
          Result := ExtractFileName(Copy(AFileName,1,I-1));
 end;
begin
 RxTrayIcon1.Hint := ExtractFileNameEX ( Application.ExeName );
 Application.ShowHint := true;
 Randomize;
 FirstOnPaint := True;
end;

procedure TFMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  inherited;
  CanClose := Question('Czy na pewno zakoñczyæ dzia³anie programu?') = ID_YES;
end;

procedure TFMain.BConfigClick(Sender: TObject);
begin
 DisableAlarm;
 FConfiguration.ShowModal;
 SetAlarm(GetAlarm);
end;

procedure TFMain.BMinimizeClick(Sender: TObject);
begin
  Self.Hide;
end;

procedure TFMain.ClockAlarm(Sender: TObject);
begin
  ShowMessage;
end;

Type TCalculateAlarm = Object
        NowTime   : TDateTime;
        NextAlarm : TDateTime;
        MinDistance : TDateTime;

        Procedure Init(aNowTime : TDateTime);
        Procedure Add(Alarm : TDateTime);
        Function  GetNextAlarm : TDateTime;
        // -1 remains that there is no alarm

        Private
        Function Distance(TimeFrom, TimeTo : TDateTime) : TDateTime;
     End;

Procedure TCalculateAlarm.Init(aNowTime : TDateTime);
Begin
 NextAlarm := -1;
 MinDistance := 1;
 NowTime   := aNowTime;
End;

Procedure TCalculateAlarm.Add(Alarm : TDateTime);
Begin
 If Distance(NowTime,Alarm) <= MinDistance Then Begin
  NextAlarm   := Alarm;
  MinDistance := Distance(NowTime,Alarm);
 End;
End;

Function  TCalculateAlarm.GetNextAlarm : TDateTime;
Begin
 Result := NextAlarm;
End;

Function TCalculateAlarm.Distance(TimeFrom, TimeTo : TDateTime) : TDateTime;
Begin
 If TimeTo >= TimeFrom Then Result := TimeTo - TimeFrom
                       Else Result := 24/24 + 00/60 - TimeFrom + TimeTo;
End;

Function  TFMain.GetAlarm : TDateTime;
  Const M : Array[0..6] Of TDateTime =
   (10       / 24 / 60 / 60,
    15  * 60 / 24 / 60 / 60,
    30  * 60 / 24 / 60 / 60,
    60  * 60 / 24 / 60 / 60,
    120 * 60 / 24 / 60 / 60,
    180 * 60 / 24 / 60 / 60,
    240 * 60 / 24 / 60 / 60);

  Function CutDate(D : TDateTime) : TDateTime;
  Begin
   Result := D - Trunc(D);
  End;

Var NextAlarm      : TDateTime;
    NowTime        : TDateTime;
    CalculateAlarm : TCalculateAlarm;
begin
 NowTime := CutDate(Now);
 With FConfiguration Do Begin
  NextAlarm := -1;
  Case Pages.ActivePageIndex Of
   0:Begin
      NextAlarm := NowTime + M[Interval.ItemIndex];
     End;
   1:Begin
       CalculateAlarm.Init(NowTime);
       If G0000.Checked Then CalculateAlarm.Add(00 / 24 + 00 /24 / 60);
       If G0030.Checked Then CalculateAlarm.Add(00 / 24 + 30 /24 / 60);
       If G0100.Checked Then CalculateAlarm.Add(1 / 24 + 00 /24 / 60);
       If G0130.Checked Then CalculateAlarm.Add(1 / 24 + 30 /24 / 60);
       If G0200.Checked Then CalculateAlarm.Add(2 / 24 + 00 /24 / 60);
       If G0230.Checked Then CalculateAlarm.Add(2 / 24 + 30 /24 / 60);
       If G0300.Checked Then CalculateAlarm.Add(3 / 24 + 00 /24 / 60);
       If G0330.Checked Then CalculateAlarm.Add(3 / 24 + 30 /24 / 60);
       If G0400.Checked Then CalculateAlarm.Add(4 / 24 + 00 /24 / 60);
       If G0430.Checked Then CalculateAlarm.Add(4 / 24 + 30 /24 / 60);
       If G0500.Checked Then CalculateAlarm.Add(5 / 24 + 00 /24 / 60);
       If G0530.Checked Then CalculateAlarm.Add(5 / 24 + 30 /24 / 60);
       If G0600.Checked Then CalculateAlarm.Add(6 / 24 + 00 /24 / 60);
       If G0630.Checked Then CalculateAlarm.Add(6 / 24 + 30 /24 / 60);
       If G0700.Checked Then CalculateAlarm.Add(7 / 24 + 00 /24 / 60);
       If G0730.Checked Then CalculateAlarm.Add(7 / 24 + 30 /24 / 60);
       If G0800.Checked Then CalculateAlarm.Add(8 / 24 + 00 /24 / 60);
       If G0830.Checked Then CalculateAlarm.Add(8 / 24 + 30 /24 / 60);
       If G0900.Checked Then CalculateAlarm.Add(9 / 24 + 00 /24 / 60);
       If G0930.Checked Then CalculateAlarm.Add(9 / 24 + 30 /24 / 60);
       If G1000.Checked Then CalculateAlarm.Add(10 / 24 + 00 /24 / 60);
       If G1030.Checked Then CalculateAlarm.Add(10 / 24 + 30 /24 / 60);
       If G1100.Checked Then CalculateAlarm.Add(11 / 24 + 00 /24 / 60);
       If G1130.Checked Then CalculateAlarm.Add(11 / 24 + 30 /24 / 60);
       If G1200.Checked Then CalculateAlarm.Add(12 / 24 + 00 /24 / 60);
       If G1230.Checked Then CalculateAlarm.Add(12 / 24 + 30 /24 / 60);
       If G1300.Checked Then CalculateAlarm.Add(13 / 24 + 00 /24 / 60);
       If G1330.Checked Then CalculateAlarm.Add(13 / 24 + 30 /24 / 60);
       If G1400.Checked Then CalculateAlarm.Add(14 / 24 + 00 /24 / 60);
       If G1430.Checked Then CalculateAlarm.Add(14 / 24 + 30 /24 / 60);
       If G1500.Checked Then CalculateAlarm.Add(15 / 24 + 00 /24 / 60);
       If G1530.Checked Then CalculateAlarm.Add(15 / 24 + 30 /24 / 60);
       If G1600.Checked Then CalculateAlarm.Add(16 / 24 + 00 /24 / 60);
       If G1630.Checked Then CalculateAlarm.Add(16 / 24 + 30 /24 / 60);
       If G1700.Checked Then CalculateAlarm.Add(17 / 24 + 00 /24 / 60);
       If G1730.Checked Then CalculateAlarm.Add(17 / 24 + 30 /24 / 60);
       If G1800.Checked Then CalculateAlarm.Add(18 / 24 + 00 /24 / 60);
       If G1830.Checked Then CalculateAlarm.Add(18 / 24 + 30 /24 / 60);
       If G1900.Checked Then CalculateAlarm.Add(19 / 24 + 00 /24 / 60);
       If G1930.Checked Then CalculateAlarm.Add(19 / 24 + 30 /24 / 60);
       If G2000.Checked Then CalculateAlarm.Add(20 / 24 + 00 /24 / 60);
       If G2030.Checked Then CalculateAlarm.Add(20 / 24 + 30 /24 / 60);
       If G2100.Checked Then CalculateAlarm.Add(21 / 24 + 00 /24 / 60);
       If G2130.Checked Then CalculateAlarm.Add(21 / 24 + 30 /24 / 60);
       If G2200.Checked Then CalculateAlarm.Add(22 / 24 + 00 /24 / 60);
       If G2230.Checked Then CalculateAlarm.Add(22 / 24 + 30 /24 / 60);
       If G2300.Checked Then CalculateAlarm.Add(23 / 24 + 00 /24 / 60);
       If G2330.Checked Then CalculateAlarm.Add(23 / 24 + 30 /24 / 60);
       NextAlarm := CalculateAlarm.GetNextAlarm;
     End;
  End;
 End;
 Result := NextAlarm;
end;


procedure TFMain.BInfoClick(Sender: TObject);
begin
  inherited;
 DisableAlarm;
 UFInfo.ShowModal;
 SetAlarm(GetAlarm);
end;

procedure TFMain.Konfiguruj1Click(Sender: TObject);
begin
  inherited;
  BConfigClick(nil);
end;

procedure TFMain.Minimalizuj1Click(Sender: TObject);
begin
  inherited;
 BMinimizeClick(nil);
end;

procedure TFMain.Informacje1Click(Sender: TObject);
begin
  inherited;
  BInfoClick(nil);
end;

procedure TFMain.Zakocz1Click(Sender: TObject);
begin
  inherited;
  BCloseClick(nil);
end;

procedure TFMain.RxTrayIcon1Click(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  Self.Show;
end;

procedure TFMain.BCloseClick(Sender: TObject);
begin
 Close;
end;


procedure TFMain.FormHide(Sender: TObject);
begin
  inherited;
  ShowWindow(Application.Handle, SW_HIDE);
end;


procedure TFMain.FormShow(Sender: TObject);
begin
 With Fconfiguration  do begin
   UUtilityParent.LoadFromIni(ApplicationDocumentsPath+'Settings.ini','Main',[Pages, FProgram, Interval, G0000,G0030,G0100,G0130,G0200,G0230,G0300,G0330,G0400,G0430,G0500,G0530,G0600,G0630,G0700,G0730,G0800,G0830,G0900,G0930,G1000,G1030,G1100,G1130,G1200,G1230,G1300,G1330,G1400,G1430,G1500,G1530,G1600,G1630,G1700,G1730,G1800,G1830,G1900,G1930,G2000,G2030,G2100,G2130,G2200,G2230,G2300,G2330]);
 end;
  SetAlarm(GetAlarm);
  ShowWindow(Application.Handle, SW_HIDE);
end;

procedure TFMain.FormPaint(Sender: TObject);
begin
  If FirstOnPaint Then Begin
   BMinimizeClick(nil);
   FirstOnPaint := False;
  End;
end;

end.
