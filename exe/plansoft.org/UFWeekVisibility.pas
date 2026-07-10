unit UFWeekVisibility;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, CheckLst, Menus;

type
  TFWeekVisibility = class(TForm)
    LSelectAll: TLabel;
    LDeselectAll: TLabel;
    CheckListBox1: TCheckListBox;
    BOK: TBitBtn;
    BCancel: TBitBtn;
    CheckPopup: TPopupMenu;
    MSelectAll: TMenuItem;
    MDeselectAll: TMenuItem;
    procedure BOKClick(Sender: TObject);
    procedure BCancelClick(Sender: TObject);
    procedure MSelectAllClick(Sender: TObject);
    procedure MDeselectAllClick(Sender: TObject);
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

procedure TFWeekVisibility.BOKClick(Sender: TObject);
begin
 mr := mrOk;
 Close;
end;

procedure TFWeekVisibility.BCancelClick(Sender: TObject);
begin
 mr := mrCancel;
 Close;
end;

procedure TFWeekVisibility.MSelectAllClick(Sender: TObject);
Var i : Integer;
begin
  For i := 0 to CheckListBox1.Items.Count - 1 do CheckListBox1.Checked[i] := True;
end;

procedure TFWeekVisibility.MDeselectAllClick(Sender: TObject);
Var i : Integer;
begin
  For i := 0 to CheckListBox1.Items.Count - 1 do CheckListBox1.Checked[i] := False;
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
    ShowMessage('Ukrywanie tygodni jest dost'#281'pne maksymalnie dla '+IntToStr(MAX_WEEKS)+' tygodni (1 rok). Ten okres obejmuje '+IntToStr(NumWeeks)+' tygodni.');
    Result := mrCancel;
    Exit;
  End;

  CheckListBox1.Items.Clear;
  For i := 0 to NumWeeks - 1 do Begin
    WMonday := StartMonday + i * 7;
    CheckListBox1.Items.Add('Tydzieñ '+IntToStr(i+1)+':   '+FormatDateTime('dd.mm.yyyy', WMonday)+' - '+FormatDateTime('dd.mm.yyyy', WMonday+6));
    If Length(weekVisibility) = 0 Then ch := '+' Else ch := weekVisibility[(i mod Length(weekVisibility)) + 1];
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
