unit UFWeekVisibility;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, CheckLst;

type
  TFWeekVisibility = class(TForm)
    CheckListBox1: TCheckListBox;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
  private
    mr : TModalResult;
  public
    function ShowModalWithDefaults(DateFrom, DateTo : TDateTime; var weekVisibility : string) : TModalResult;
  end;

var
  FWeekVisibility: TFWeekVisibility;

implementation

{$R *.dfm}

Const MAX_WEEKS = 40;

Function MondayOfDate(D : TDateTime) : TDateTime;
Var dw : Integer;
Begin
  dw := DayOfWeek(D); // konwencja Delphi: 1=niedziela..7=sobota, 2=poniedzialek
  Result := Trunc(D) - ((dw - 2 + 7) mod 7);
End;

procedure TFWeekVisibility.SpeedButton1Click(Sender: TObject);
begin
 mr := mrOk;
 Close;
end;

procedure TFWeekVisibility.SpeedButton2Click(Sender: TObject);
begin
 mr := mrCancel;
 Close;
end;

function TFWeekVisibility.ShowModalWithDefaults(DateFrom, DateTo : TDateTime; var weekVisibility : string) : TModalResult;
Var
  i, NumWeeks : Integer;
  StartMonday, WMonday : TDateTime;
  ch : Char;
Begin
  StartMonday := MondayOfDate(DateFrom);
  NumWeeks := Trunc(MondayOfDate(DateTo) - StartMonday) div 7 + 1;

  If NumWeeks > MAX_WEEKS Then Begin
    ShowMessage('Ukrywanie tygodni jest dostêpne maksymalnie dla '+IntToStr(MAX_WEEKS)+' tygodni (1 rok). Ten okres obejmuje '+IntToStr(NumWeeks)+' tygodni.');
    Result := mrCancel;
    Exit;
  End;

  CheckListBox1.Items.Clear;
  For i := 0 to NumWeeks - 1 do Begin
    WMonday := StartMonday + i * 7;
    CheckListBox1.Items.Add('Tydzieñ '+IntToStr(i+1)+':   '+FormatDateTime('dd.mm.yyyy', WMonday)+' - '+FormatDateTime('dd.mm.yyyy', WMonday+6));
    If (i+1 <= Length(weekVisibility)) Then ch := weekVisibility[i+1] Else ch := '+';
    CheckListBox1.Checked[i] := (ch <> '-');
  End;

  mr := mrCancel;
  ShowModal;

  If mr = mrOk Then Begin
    weekVisibility := '';
    For i := 0 to CheckListBox1.Items.Count - 1 do
      If CheckListBox1.Checked[i] Then weekVisibility := weekVisibility + '+' Else weekVisibility := weekVisibility + '-';
  End;

  Result := mr;
End;

end.
