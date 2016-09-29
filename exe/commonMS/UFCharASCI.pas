unit UFCharASCI;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls{, UComputerland}, UUtilityParent;

type
  TFCharASCI = class(TForm)
    E: TEdit;
    P: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    procedure EChange(Sender: TObject);
    procedure PChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FCharASCI: TFCharASCI;

implementation

{$R *.DFM}

procedure TFCharASCI.EChange(Sender: TObject);
Var L : Integer;
begin
  If Not (ActiveControl = E) Then Exit;
  P.Text := '';
  For L:=1 To Length(E.Text) Do Begin
   If Trim(P.Text) <> '' Then P.Text := P.Text + ',';
   P.text := P.Text + IntToStr(Ord(E.Text[L]));
  End;
end;


procedure TFCharASCI.PChange(Sender: TObject);
Var L : Integer;
begin
 If Not (ActiveControl = P) Then Exit;
 E.Text := '';
 For L := 1 To WordCount(P.Text, [',']) Do Begin
  try
   E.Text := E.Text + Char(StrToInt(ExtractWord(L, P.Text,[','])));
  except
   E.Text := E.Text + '<b³¹d>';
  end;
 End;
end;


end.
