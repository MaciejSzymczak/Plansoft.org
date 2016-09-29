unit UFReadDate;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, Mask, ToolEdit, UFormConfig, ComCtrls;

type
  TFReadDate = class(TFormConfig)
    Panel1: TPanel;
    BOK: TBitBtn;
    BAnuluj: TBitBtn;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    BitBtn6: TBitBtn;
    BitBtn7: TBitBtn;
    BitBtn8: TBitBtn;
    BitBtn9: TBitBtn;
    BitBtn10: TBitBtn;
    BitBtn11: TBitBtn;
    BitBtn12: TBitBtn;
    BitBtn13: TBitBtn;
    BitBtn14: TBitBtn;
    BitBtn15: TBitBtn;
    BitBtn16: TBitBtn;
    BitBtn17: TBitBtn;
    BitBtn18: TBitBtn;
    BitBtn19: TBitBtn;
    BitBtn20: TBitBtn;
    BitBtn21: TBitBtn;
    BitBtn22: TBitBtn;
    BitBtn23: TBitBtn;
    BitBtn24: TBitBtn;
    BitBtn25: TBitBtn;
    BitBtn26: TBitBtn;
    BitBtn27: TBitBtn;
    BitBtn28: TBitBtn;
    BitBtn29: TBitBtn;
    BitBtn30: TBitBtn;
    BitBtn31: TBitBtn;
    BitBtn32: TBitBtn;
    BitBtn33: TBitBtn;
    BitBtn34: TBitBtn;
    BitBtn35: TBitBtn;
    BitBtn36: TBitBtn;
    BitBtn37: TBitBtn;
    BitBtn38: TBitBtn;
    BitBtn39: TBitBtn;
    BitBtn40: TBitBtn;
    BitBtn41: TBitBtn;
    BitBtn42: TBitBtn;
    BitBtn43: TBitBtn;
    BitBtn44: TBitBtn;
    BitBtn45: TBitBtn;
    BitBtn46: TBitBtn;
    BitBtn47: TBitBtn;
    BitBtn48: TBitBtn;
    BitBtn49: TBitBtn;
    BitBtn50: TBitBtn;
    BitBtn51: TBitBtn;
    BitBtn52: TBitBtn;
    BitBtn53: TBitBtn;
    BitBtn54: TBitBtn;
    BitBtn55: TBitBtn;
    BitBtn56: TBitBtn;
    BitBtn57: TBitBtn;
    BitBtn58: TBitBtn;
    BitBtn59: TBitBtn;
    BitBtn60: TBitBtn;
    BitBtn61: TBitBtn;
    BitBtn62: TBitBtn;
    BitBtn63: TBitBtn;
    BitBtn64: TBitBtn;
    BitBtn65: TBitBtn;
    BitBtn66: TBitBtn;
    BitBtn67: TBitBtn;
    BitBtn68: TBitBtn;
    BitBtn69: TBitBtn;
    BitBtn70: TBitBtn;
    BitBtn71: TBitBtn;
    BitBtn72: TBitBtn;
    BitBtn73: TBitBtn;
    BitBtn74: TBitBtn;
    BitBtn75: TBitBtn;
    BitBtn76: TBitBtn;
    BitBtn77: TBitBtn;
    BitBtn78: TBitBtn;
    BitBtn79: TBitBtn;
    BitBtn80: TBitBtn;
    BitBtn81: TBitBtn;
    BitBtn82: TBitBtn;
    BitBtn83: TBitBtn;
    BitBtn84: TBitBtn;
    BitBtn85: TBitBtn;
    BitBtn86: TBitBtn;
    BitBtn87: TBitBtn;
    BitBtn88: TBitBtn;
    BitBtn89: TBitBtn;
    BitBtn90: TBitBtn;
    BitBtn91: TBitBtn;
    BitBtn92: TBitBtn;
    BitBtn93: TBitBtn;
    BitBtn94: TBitBtn;
    BitBtn95: TBitBtn;
    BitBtn96: TBitBtn;
    BitBtn97: TBitBtn;
    BitBtn98: TBitBtn;
    BitBtn99: TBitBtn;
    BitBtn100: TBitBtn;
    Label1: TLabel;
    D: TMonthCalendar;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    _CanEmpty : Boolean;
  public
    { Public declarations }
  end;

var
  FReadDate: TFReadDate;

Function ReadDate(Caption : ShortString; Var Date : TDateTime; CanEmpty : Boolean) : TModalResult;

implementation

{$R *.DFM}

uses UUtilityParent;

Function ReadDate(Caption : ShortString; Var Date : TDateTime; CanEmpty : Boolean) : TModalResult;
Begin

 FReadDate := TFReadDate.Create(Application);
 FReadDate._CanEmpty      := CanEmpty;
 If Date = 0 Then Date := now();
 FReadDate.D.Date         := Date;
 FReadDate.Caption := Caption;
 Result := FReadDate.ShowModal;
 Date := FReadDate.D.Date;
 FReadDate.Free;
End;


procedure TFReadDate.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
 If ModalResult = mrOK Then Begin
   If Not _CanEmpty Then
    If D.Date =0 Then Begin SError('Enter date'); CanClose := False; End;
 End;
end;

procedure TFReadDate.BitBtn1Click(Sender: TObject);
begin
  inherited;
  D.Date := D.Date + TBitBtn(Sender).Tag;
end;

procedure TFReadDate.FormCreate(Sender: TObject);
var t: integer;
begin
  inherited;
   For T := 0 To self.ComponentCount-1 Do
   Begin
     If self.Components[T] is TBitBtn Then Begin
      if TBitBtn(self.Components[T]).Tag > 0 Then TBitBtn(self.Components[T]).Caption := IntToStr(TBitBtn(self.Components[T]).Tag);
     end;
   End;
end;

end.
