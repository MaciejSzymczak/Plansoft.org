unit UFPattern;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons;

type
  TFPattern = class(TForm)
    CustomText: TEdit;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Bok: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    SpeedButton7: TSpeedButton;
    Label6: TLabel;
    Len: TLabel;
    SpeedButton8: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton9: TSpeedButton;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    SpeedButton10: TSpeedButton;
    SpeedButton11: TSpeedButton;
    bdesc1: TBitBtn;
    procedure SpeedButton1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure SpeedButton2MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure SpeedButton4MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton6MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure SpeedButton5MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure SpeedButton7MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure CustomTextChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CustomTextKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SpeedButton3MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure SpeedButton9MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure SpeedButton10MouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure SpeedButton11Click(Sender: TObject);
    procedure bdesc1Click(Sender: TObject);
    procedure BokClick(Sender: TObject);
  private
    { Private declarations }
  public
    modalResult : integer;
  end;

var
  FPattern: TFPattern;

implementation

{$R *.dfm}

uses uutilityparent, autocreate;

procedure TFPattern.SpeedButton1MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  if CustomText.Text<>'1' then CustomText.Text := '1';
end;

procedure TFPattern.SpeedButton2MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  if CustomText.Text<>'01' then CustomText.Text := '01';
end;

procedure TFPattern.SpeedButton4MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  if CustomText.Text<>'10' then CustomText.Text := '10';
end;

procedure TFPattern.SpeedButton5Click(Sender: TObject);
begin
  if CustomText.Text<>'110' then CustomText.Text := '110';
end;

procedure TFPattern.SpeedButton6MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  if CustomText.Text<>'011' then CustomText.Text := '011';
end;

procedure TFPattern.SpeedButton5MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  if CustomText.Text<>'110' then CustomText.Text := '110';
end;

procedure TFPattern.SpeedButton7MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  if CustomText.Text<>'100' then CustomText.Text := '100';
end;

procedure TFPattern.CustomTextChange(Sender: TObject);
begin
 Len.Caption := inttostr(length(CustomText.Text));
end;

procedure TFPattern.FormCreate(Sender: TObject);
begin
  modalResult := 0;
end;

procedure TFPattern.CustomTextKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if key=13 then
 BokClick(Bok);
end;

procedure TFPattern.SpeedButton3MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  if CustomText.Text<>'WC' then CustomText.Text := 'WC';
end;

procedure TFPattern.SpeedButton9MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  if CustomText.Text<>'WCL' then CustomText.Text := 'WCL';
end;

procedure TFPattern.SpeedButton10MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  if CustomText.Text<>'WC0' then CustomText.Text := 'WC0';
end;

procedure TFPattern.SpeedButton11Click(Sender: TObject);
begin
 info('Kliknij w odpowiedni przycisk aby wybraæ wzorzec powtórzeñ lub utwórz swój w³asny wzorzec w polu poni¿ej.'+cr+
''+cr+
'1=domyœlna forma zajêæ'+cr+
'0=nie planuj zajêcia'+cr+
'W=Wyk³ad'+cr+
'C=Æwiczenia'+cr+
'L=Laboratorium'+cr+
'K=Kolokwium'+cr+
'P=Projekt'+cr+
'S=Seminarium'+cr+
'E=Egzamin'+cr+
'U=Urlop');
end;

procedure TFPattern.bdesc1Click(Sender: TObject);
Var KeyValue : ShortString;
begin
  KeyValue := '';
  If FIN_LOOKUP_VALUESShowModalAsMultiselectExt('1010',KeyValue) = mrOK Then begin
      CustomText.Text := KeyValue;
      BokClick(Bok);
  end;
end;

procedure TFPattern.BokClick(Sender: TObject);
begin
 CustomText.Text := upperCase(CustomText.Text);
 modalResult := (Sender as TSpeedbutton).tag;

 if Length(uutilityparent.replace(
           uutilityparent.replace(
           uutilityparent.replace(
           uutilityparent.replace(
           uutilityparent.replace(
           uutilityparent.replace(
           uutilityparent.replace(
           uutilityparent.replace(
           uutilityparent.replace(
           uutilityparent.replace(CustomText.Text
           ,'0','')
           ,'1','')
           ,'W','')
           ,'C','')
           ,'L','')
           ,'K','')
           ,'P','')
           ,'S','')
           ,'E','')
           ,'U','')
           )<>0 then begin
   info('W polu mo¿na wpisywaæ tylko wartoœci: 0,1,W,C,L,K,P,S,E,U');
   exit;
 end;

 if Length(CustomText.Text)=0 then begin
   info('W polu trzeba wpisaæ wartoœæ');
   exit;
 end;

 close;
end;

end.
