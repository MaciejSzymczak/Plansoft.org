unit UFMemoToolbar;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, StdCtrls, StrUtils, UUtilityParent, TextNum, rxStrUtils;

type
  TFMemoToolbar = class(TForm)
    ELitPre: TEdit;
    Label6: TLabel;
    ELitPost: TEdit;
    EPowiel: TEdit;
    BClose: TSpeedButton;
    BTrim: TSpeedButton;
    SpeedButton1: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton6: TSpeedButton;
    ReplaceDialog: TReplaceDialog;
    SpeedButton4: TSpeedButton;
    SpeedButton7: TSpeedButton;
    ExtractWord1: TEdit;
    ExtractWord2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    SpeedButton8: TSpeedButton;
    SpeedButton9: TSpeedButton;
    SpeedButton10: TSpeedButton;
    SpeedButton11: TSpeedButton;
    SpeedButton12: TSpeedButton;
    SpeedButton13: TSpeedButton;
    SpeedButton14: TSpeedButton;
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure BCloseClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BTrimClick(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure ReplaceDialogReplace(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton7Click(Sender: TObject);
    procedure SpeedButton8Click(Sender: TObject);
    procedure SpeedButton9Click(Sender: TObject);
    procedure SpeedButton10Click(Sender: TObject);
    procedure SpeedButton11Click(Sender: TObject);
    procedure SpeedButton12Click(Sender: TObject);
    procedure SpeedButton13Click(Sender: TObject);
    procedure SpeedButton14Click(Sender: TObject);
  private
    EScript : TMemo;
    AssistantMemo : TMemo;
    SwitchButton : TSpeedButton;
  public
    { Public declarations }
  end;

var
  FMemoToolbar: TFMemoToolbar;

Procedure ShowTool(Memo, AddMemo : TMemo; aSwitchButton : TSpeedButton);
Procedure HideTool;

implementation

{$R *.DFM}

Procedure ShowTool;
Begin
 FMemoToolbar.EScript := Memo;
 FMemoToolbar.AssistantMemo := AddMemo;
 FMemoToolbar.SwitchButton := aSwitchButton;
 FMemoToolbar.Show;
End;

Procedure HideTool;
Begin
 FMemoToolbar.Hide;
End;

procedure TFMemoToolbar.SpeedButton1Click(Sender: TObject);
Var t : Integer;
begin
 For t:=0 To EScript.Lines.Count-1 Do Begin
  EScript.Lines.Strings[t] := Copy(EScript.Lines.Strings[t],2,65000);
 End;
end;

procedure TFMemoToolbar.SpeedButton2Click(Sender: TObject);
Var t : Integer;
begin
 For t:=0 To EScript.Lines.Count-1 Do Begin
  EScript.Lines.Strings[t] := ELitPre.Text + EScript.Lines.Strings[t] + ELitPost.Text;
 End;
end;

procedure TFMemoToolbar.BCloseClick(Sender: TObject);
begin
 Close;
end;

procedure TFMemoToolbar.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 SwitchButton.Down := False;
end;

procedure TFMemoToolbar.BTrimClick(Sender: TObject);
Var t : Integer;
begin
 For t:=0 To EScript.Lines.Count-1 Do Begin
  EScript.Lines.Strings[t] := Trim(EScript.Lines.Strings[t]);
 End;
end;

procedure TFMemoToolbar.SpeedButton5Click(Sender: TObject);
Var t : Integer;
begin
 For t:=0 To EScript.Lines.Count-1 Do Begin
  EScript.Lines.Strings[t] := Copy(EScript.Lines.Strings[t],1,Length(EScript.Lines.Strings[t])-1);
 End;
end;

procedure TFMemoToolbar.SpeedButton3Click(Sender: TObject);
Var t : Integer;
begin
 For t:=0 To EScript.Lines.Count-1 Do Begin
  EScript.Lines.Strings[t] := EScript.Lines.Strings[t]+EPowiel.Text+EScript.Lines.Strings[t];
 End;
end;


procedure TFMemoToolbar.SpeedButton6Click(Sender: TObject);
Var t : Integer;
    maxlen : Integer;
begin
 maxlen := 0;
 For t:=0 To EScript.Lines.Count-1 Do Begin
  If Length(EScript.Lines.Strings[t]) > Maxlen Then MaxLen := Length(EScript.Lines.Strings[t]);
 End;

 //StrUtils.ReplaceStr(str, schr, with) : str;

 For t:=0 To EScript.Lines.Count-1 Do Begin
  EScript.Lines.Strings[t] := Copy(EScript.Lines.Strings[t]+rxStrUtils.MakeStr(' ',1000),1,maxlen);
 End;
end;


procedure TFMemoToolbar.ReplaceDialogReplace(Sender: TObject);
begin
 EScript.Lines.Text := rxStrUtils.ReplaceStr(EScript.Lines.Text, ReplaceDialog.FindText, ReplaceDialog.ReplaceText)
end;


procedure TFMemoToolbar.SpeedButton4Click(Sender: TObject);
begin
 ReplaceDialog.Execute;
end;




procedure TFMemoToolbar.SpeedButton7Click(Sender: TObject);
Var t : Integer;
    No : Integer;
    Delimiter : Char;
begin
 No := StrToInt(ExtractWord1.Text);
 Try
 Delimiter := ExtractWord2.Text[1];
 Except
  SError('You should set exactly 1 char in Delimiter field');
  Exit;
 End;

 AssistantMemo.Lines.Clear;
 For t:=0 To EScript.Lines.Count-1 Do Begin
  AssistantMemo.Lines.Add('');
 End;

 For t:=0 To EScript.Lines.Count-1 Do Begin
  AssistantMemo.Lines.Strings[t] := UUtilityParent.ExtractWord(No,EScript.Lines.Strings[t],[Delimiter]);
 End;
end;

procedure TFMemoToolbar.SpeedButton8Click(Sender: TObject);
Var t : Integer;
    No : Integer;
    Delimiter : Char;
begin
 No := StrToInt(ExtractWord1.Text);
 Try
 Delimiter := ExtractWord2.Text[1];
 Except
  SError('You should set exactly 1 char in Delimiter field');
  Exit;
 End;

 AssistantMemo.Lines.Clear;
 For t:=0 To EScript.Lines.Count-1 Do Begin
  AssistantMemo.Lines.Add('');
 End;

 For t:=0 To EScript.Lines.Count-1 Do Begin
  AssistantMemo.Lines.Strings[t] := IntToStr(UUtilityParent.WordCount(EScript.Lines.Strings[t],[Delimiter]));
 End;
end;

procedure TFMemoToolbar.SpeedButton9Click(Sender: TObject);
begin
 ExtractWord2.Text := #9;
end;


procedure TFMemoToolbar.SpeedButton10Click(Sender: TObject);
Var t : Integer;
begin
 For t:=1 To (EScript.Lines.Count) - (AssistantMemo.Lines.Count) Do Begin
  AssistantMemo.Lines.Add('');
 End;

 For t:=0 To (AssistantMemo.Lines.Count) - (EScript.Lines.Count) Do Begin
  EScript.Lines.Add('');
 End;

 For t:=0 To EScript.Lines.Count-1 Do Begin
  EScript.Lines.Strings[t] := EScript.Lines.Strings[t] + AssistantMemo.Lines.Strings[t];
 End;

 AssistantMemo.Lines.Clear;
 For t:=0 To EScript.Lines.Count-1 Do Begin
  AssistantMemo.Lines.Add('');
 End;
end;

procedure TFMemoToolbar.SpeedButton11Click(Sender: TObject);
Var t : Integer;
begin
 AssistantMemo.Lines.Clear;
 For t:=0 To EScript.Lines.Count-1 Do Begin
  AssistantMemo.Lines.Add('');
 End;

 For t:=0 To EScript.Lines.Count-1 Do Begin
  Try
   AssistantMemo.Lines.Strings[t] := IntToRoman(StrToInt(Trim(EScript.Lines.Strings[t])));
  Except
   AssistantMemo.Lines.Strings[t] := 'Conversion error';
  End;
 End;
end;


procedure TFMemoToolbar.SpeedButton12Click(Sender: TObject);
Var t : Integer;
begin
 AssistantMemo.Lines.Clear;
 For t:=0 To EScript.Lines.Count-1 Do Begin
  AssistantMemo.Lines.Add('');
 End;

 For t:=0 To EScript.Lines.Count-1 Do Begin
  Try
   AssistantMemo.Lines.Strings[t] := D2H(StrToInt(Trim(EScript.Lines.Strings[t])),10);
  Except
   AssistantMemo.Lines.Strings[t] := 'Conversion error';
  End;
 End;
end;

procedure TFMemoToolbar.SpeedButton13Click(Sender: TObject);
Var t : Integer;
begin
 AssistantMemo.Lines.Clear;
 For t:=0 To EScript.Lines.Count-1 Do Begin
  AssistantMemo.Lines.Add('');
 End;

 For t:=0 To EScript.Lines.Count-1 Do Begin
  Try
   AssistantMemo.Lines.Strings[t] := IntToBin(StrToInt(Trim(EScript.Lines.Strings[t])),32,0);
  Except
   AssistantMemo.Lines.Strings[t] := 'Conversion error';
  End;
 End;
end;


procedure TFMemoToolbar.SpeedButton14Click(Sender: TObject);
Var t : Integer;
begin
 AssistantMemo.Lines.Clear;
 For t:=0 To EScript.Lines.Count-1 Do Begin
  AssistantMemo.Lines.Add('');
 End;

 For t:=0 To EScript.Lines.Count-1 Do Begin
  Try
   AssistantMemo.Lines.Strings[t] := getstrnum(StrToFloat(Trim(EScript.Lines.Strings[t])));
  Except
   AssistantMemo.Lines.Strings[t] := 'Conversion error';
  End;
 End;
end;

end.
