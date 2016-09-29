unit UFKonwerter;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Placemnt, StdCtrls, Mask, ToolEdit, Buttons, ExtCtrls, ComCtrls, UUtilityParent,
  Grids;

type
  TFKonwerter = class(TForm)
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    Source: TFilenameEdit;
    Dest: TFilenameEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Storage: TFormStorage;
    BitBtn2: TBitBtn;
    BitBtn4: TBitBtn;
    Anim: TAnimate;
    PreviewSource: TBitBtn;
    PreviewDest: TBitBtn;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    K1: TEdit;
    D1: TEdit;
    Z1: TEdit;
    dz1: TEdit;
    K2: TEdit;
    d2: TEdit;
    Z2: TEdit;
    dz2: TEdit;
    K3: TEdit;
    d3: TEdit;
    Z3: TEdit;
    dz3: TEdit;
    K4: TEdit;
    d4: TEdit;
    Z4: TEdit;
    dz4: TEdit;
    K5: TEdit;
    d5: TEdit;
    Z5: TEdit;
    dz5: TEdit;
    K6: TEdit;
    d6: TEdit;
    Z6: TEdit;
    dz6: TEdit;
    K7: TEdit;
    d7: TEdit;
    Z7: TEdit;
    dz7: TEdit;
    K8: TEdit;
    d8: TEdit;
    Z8: TEdit;
    dz8: TEdit;
    K9: TEdit;
    d9: TEdit;
    Z9: TEdit;
    dz9: TEdit;
    K10: TEdit;
    d10: TEdit;
    Z10: TEdit;
    dz10: TEdit;
    K11: TEdit;
    d11: TEdit;
    Z11: TEdit;
    dz11: TEdit;
    K12: TEdit;
    d12: TEdit;
    Z12: TEdit;
    dz12: TEdit;
    BWYczysc: TBitBtn;
    Scan: TStringGrid;
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure PreviewSourceClick(Sender: TObject);
    procedure PreviewDestClick(Sender: TObject);
    procedure K1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Z1Change(Sender: TObject);
    procedure D1Change(Sender: TObject);
    procedure dz1Change(Sender: TObject);
    procedure SourceChange(Sender: TObject);
    procedure BWYczyscClick(Sender: TObject);
  private
    { Private declarations }
  public
    K, Z, D, DZ : Array[1..12] Of TEdit;
  end;

var
  FKonwerter: TFKonwerter;

implementation

uses UFCharASCI;

{$R *.DFM}

procedure TFKonwerter.BitBtn4Click(Sender: TObject);
var
  FromF, ToF: file;
  NumRead, NumWritten: Integer;
  Buf: array[1..2048] of Char;
  Co, NaCo : Char;
  L, T   : Integer;
begin
 Try
    Anim.Active := True;
    AssignFile(FromF, Source.Text);
    Reset(FromF, 1);	{ Record size = 1 }
    AssignFile(ToF, Dest.Text);	{ Open output file }

    Rewrite(ToF, 1);	{ Record size = 1 }
      {Canvas.TextOut(10, 10, 'Copying ' + IntToStr(FileSize(FromF))
        + ' bytes...');}
    repeat
      BlockRead(FromF, Buf, SizeOf(Buf), NumRead);
      For L := NumRead To 2048 Do Scan.Cells[L,0] := '';
      For L := 1 To NumRead Do Begin
        For T := 1 To 12 Do
         Try
          If (Length(Z[t].Text) = 1) And (Length(DZ[T].Text) = 1) Then
          If Buf[L] = Z[T].Text[1] Then Buf[L] := DZ[t].Text[1];
         Except End;
      Scan.Cells[L,0] := Buf[L];
      //BY£O IntToStr(Buf[L]) ??? 2002.01.09 MS
      End;
      BlockWrite(ToF, Buf, NumRead, NumWritten);
    until (NumRead = 0) or (NumWritten <> NumRead);
      CloseFile(FromF);
      CloseFile(ToF);
      Anim.Active := False;
      Info('OK');
  Except
   Anim.Active := False;
   SError('B³¹d podczas kopiawnia');
   Raise;
  End;
end;
procedure TFKonwerter.BitBtn2Click(Sender: TObject);
begin
 FCharASCI.ShowModal;
end;

procedure TFKonwerter.PreviewSourceClick(Sender: TObject);
begin
 ExecuteFile('NotePad.exe',Source.Text,'',SW_SHOW);
end;

procedure TFKonwerter.PreviewDestClick(Sender: TObject);
begin
  ExecuteFile('NotePad.exe',Dest.Text,'',SW_SHOW);
end;

procedure TFKonwerter.K1Change(Sender: TObject);
Var Nr : Integer;
begin
 Nr := (Sender As TEdit).Tag;
 If Not (ActiveControl = K[Nr]) Then Exit;
 Try
  If StrToInt(K[Nr].Text) <= 255 Then Z[Nr].text := Char(StrToInt(K[Nr].Text))
                                 Else Z[Nr].text :=  '<b³¹d>';
 Except
  Z[Nr].text :=  '<b³¹d>';
 End;
end;

procedure TFKonwerter.FormCreate(Sender: TObject);
Var t : Integer;
begin
 K[1] := K1;
 K[2] := K2;
 K[3] := K3;
 K[4] := K4;
 K[5] := K5;
 K[6] := K6;
 K[7] := K7;
 K[8] := K8;
 K[9] := K9;
 K[10] := K10;
 K[11] := K11;
 K[12] := K12;

 Z[1] := Z1;
 Z[2] := Z2;
 Z[3] := Z3;
 Z[4] := Z4;
 Z[5] := Z5;
 Z[6] := Z6;
 Z[7] := Z7;
 Z[8] := Z8;
 Z[9] := Z9;
 Z[10] := Z10;
 Z[11] := Z11;
 Z[12] := Z12;

 D[1] := D1;
 D[2] := D2;
 D[3] := D3;
 D[4] := D4;
 D[5] := D5;
 D[6] := D6;
 D[7] := D7;
 D[8] := D8;
 D[9] := D9;
 D[10] := D10;
 D[11] := D11;
 D[12] := D12;

 DZ[1] := DZ1;
 DZ[2] := DZ2;
 DZ[3] := DZ3;
 DZ[4] := DZ4;
 DZ[5] := DZ5;
 DZ[6] := DZ6;
 DZ[7] := DZ7;
 DZ[8] := DZ8;
 DZ[9] := DZ9;
 DZ[10] := DZ10;
 DZ[11] := DZ11;
 DZ[12] := DZ12;

 For t := 1 To 12 Do K1Change(K[t]);
 For t := 1 To 12 Do D1Change(D[t]);
end;


procedure TFKonwerter.Z1Change(Sender: TObject);
Var Nr : Integer;
begin
 Nr := (Sender As TEdit).Tag;
 If Not (ActiveControl = Z[Nr]) Then Exit;
 Z[Nr].Text := Copy(Z[Nr].Text,1,1);
 Try
  K[Nr].text := IntToStr(Ord(Z[Nr].Text[1]));
 Except
  K[Nr].text :=  '<b³¹d>';
 End;
end;

procedure TFKonwerter.D1Change(Sender: TObject);
Var Nr : Integer;
begin
 Nr := (Sender As TEdit).Tag;
 If Not (ActiveControl = D[Nr]) Then Exit;
 Try
  If StrToInt(D[Nr].Text) <= 255 Then DZ[Nr].text := Char(StrToInt(D[Nr].Text))
                                 Else DZ[Nr].text :=  '<b³¹d>';
 Except
  DZ[Nr].text :=  '<b³¹d>';
 End;
end;

procedure TFKonwerter.dz1Change(Sender: TObject);
Var Nr : Integer;
begin
 Nr := (Sender As TEdit).Tag;
 If Not (ActiveControl = DZ[Nr]) Then Exit;
 DZ[Nr].Text := Copy(DZ[Nr].Text,1,1);
 Try
  D[Nr].text := IntToStr(Ord(DZ[Nr].Text[1]));
 Except
  D[Nr].text :=  '<b³¹d>';
 End;
end;


procedure TFKonwerter.SourceChange(Sender: TObject);
begin
 Dest.Text := Source.Text + '.po_konwersji.txt';
end;

procedure TFKonwerter.BWYczyscClick(Sender: TObject);
Var T : Integer;
begin
 For t := 1 To 12 Do Begin
  K[t].Text := 'pplpplplpl';
  Z[t].Text := '';
  D[t].Text := '';
  DZ[t].Text := '';
 End;
end;

end.
