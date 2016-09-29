unit UFMultiselect;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, checklst, Buttons, ExtCtrls, StrHlder, UUtilityParent, UFReadString,
  UFormConfig;

type
  TFMultiselect = class(TFormConfig)
    Panel1: TPanel;
    BAnuluj: TBitBtn;
    BWybierz: TBitBtn;
    CheckListBox: TCheckListBox;
    BUsun: TBitBtn;
    DEdytuj: TBitBtn;
    DDodaj: TBitBtn;
    All: TStrHolder;
    Sel: TStrHolder;
    Komunikaty: TStrHolder;
    procedure DDodajClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DEdytujClick(Sender: TObject);
    procedure BUsunClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CheckListBoxDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FMultiselect: TFMultiselect;

Function ShowModal(FileName : ShortString; Var Str : String; CanModify : Boolean) : TModalResult;
//FileName - podawaæ bez rozszerzenia

implementation

{$R *.DFM}

Function ShowModal(FileName : ShortString; Var Str : String; CanModify : Boolean) : TModalResult;
Var F    : TextFile;
    Temp : String;
    T,T2 : Integer;
Begin
  FMultiselect := TFMultiselect.Create(Application);

  //Próba wczytania pliku
  With FMultiselect Do Begin
   DDodaj.Visible  := CanModify;
   DEdytuj.Visible := CanModify;
   BUsun.Visible   := CanModify;

   Sel.Strings.Text := Str;
   AssignFile(F, FileName + '.msl');

   Try
    Reset(F);
    ReadLn(F, Temp);
    Caption := Temp;
    ReadLn(F, Temp);
    All.Strings.CommaText := Temp;
    CloseFile(F);
   Except
    Caption := FileName;
    All.Strings.Clear;
   End;

   // Przepisanie SEL do ALL
   For T:=0 To Sel.Strings.Count - 1 Do Begin
    All.Strings.Add(Sel.Strings[T]);
   End;

   // Przepisanie ALL do CheckListBox
   CheckListBox.Items.Assign(All.Strings);

   // Zaznaczenie SEL w CheckListBox
   For T:=0 To Sel.Strings.Count - 1 Do Begin
    For T2 := 0 To CheckListBox.Items.Count - 1 Do Begin
     If CheckListBox.Items[T2]=Sel.Strings[T] Then Begin CheckListBox.Checked[T2] := True; Break; End;
    End;
   End;

   Result := ShowModal;

   If ModalResult = mrOK Then Begin
    ReWrite(F);
    WriteLn(F, Caption);
    WriteLn(F, All.Strings.CommaText);
    CloseFile(F);

    Str := '';
    For T := 0 To CheckListBox.Items.Count - 1 Do
     If CheckListBox.Checked[T] Then Begin
      If Str <> '' Then Str := Str + CR;
      Str := Str + CheckListBox.Items[T];
     End;
   End;

  End;
 FMultiselect.Free;
End;

procedure TFMultiselect.DDodajClick(Sender: TObject);
Var S     : String;
    T, T2 : Integer;
begin
 If Not DDodaj.Visible Then Exit;
 If UFReadString.ReadString(Komunikaty.Strings[0], S, #0) = mrOK Then Begin
  Try
   All.Duplicates := dupError;
   All.Strings.Add(S);
   All.Duplicates := dupIgnore;
  Except
   Warning(Komunikaty.Strings[1]+S+Komunikaty.Strings[2]);
   All.Duplicates := dupIgnore;
   Exit;
  End;
  // Przechowanie zaznaczeñ w SEL
  SEL.Strings.Clear;
  For T := 0 To CheckListBox.Items.Count - 1 Do
   If CheckListBox.Checked[T] Then Begin
    SEL.Strings.Add(CheckListBox.Items[T]);
   End;
  // Przepisanie ALL do CheckBoxList
  CheckListBox.Items.Assign(All.Strings);
  // Zaznaczenie SEL w CheckListBox
  For T:=0 To Sel.Strings.Count - 1 Do Begin
   For T2 := 0 To CheckListBox.Items.Count - 1 Do Begin
    If CheckListBox.Items[T2]=Sel.Strings[T] Then Begin CheckListBox.Checked[T2] := True; Break; End;
   End;
  End;

 End;
end;

procedure TFMultiselect.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 Case Key Of
  {DeleteHotKey=}46:BUsunClick(Nil);
  {InsertHotKey=}45:DDodajClick(Nil);
 End;

end;

procedure TFMultiselect.DEdytujClick(Sender: TObject);
Var S : String;
    T, T2 : Integer;
begin
 If CheckListBox.ItemIndex = -1 Then Exit;
 If Not DEdytuj.Visible Then Exit;
 S := All.Strings[CheckListBox.ItemIndex];
 If UFReadString.ReadString(Komunikaty.Strings[3], S, #0) = mrOK Then Begin
  Try
   All.Sorted := False;
   All.Duplicates := dupError;
   All.Strings[CheckListBox.ItemIndex] := S;
   All.Duplicates := dupIgnore;
   All.Sorted := True;
  Except
   Warning(Komunikaty.Strings[1]+S+Komunikaty.Strings[2]);
   All.Duplicates := dupIgnore;
   All.Sorted := True;
   Exit;
  End;
  // Przechowanie zaznaczeñ w SEL
  SEL.Strings.Clear;
  For T := 0 To CheckListBox.Items.Count - 1 Do
   If CheckListBox.Checked[T] Then Begin
    SEL.Strings.Add(CheckListBox.Items[T]);
   End;
  // Przepisanie ALL do CheckBoxList
  CheckListBox.Items.Assign(All.Strings);
  // Zaznaczenie SEL w CheckListBox
  For T:=0 To Sel.Strings.Count - 1 Do Begin
   For T2 := 0 To CheckListBox.Items.Count - 1 Do Begin
    If CheckListBox.Items[T2]=Sel.Strings[T] Then Begin CheckListBox.Checked[T2] := True; Break; End;
   End;
  End;
 End;
end;

procedure TFMultiselect.BUsunClick(Sender: TObject);
Var S : String;
    T, T2 : Integer;
begin
  If CheckListBox.ItemIndex = -1 Then Exit;
  If Not BUsun.Visible Then Exit;
  S := All.Strings[CheckListBox.ItemIndex];
  If Question(Komunikaty.Strings[4]+S+Komunikaty.Strings[5]) = mrYes Then Begin
    All.Strings.Delete(CheckListBox.ItemIndex);
   // Przechowanie zaznaczeñ w SEL
   SEL.Strings.Clear;
   For T := 0 To CheckListBox.Items.Count - 1 Do
    If CheckListBox.Checked[T] Then Begin
     SEL.Strings.Add(CheckListBox.Items[T]);
    End;
   // Przepisanie ALL do CheckBoxList
   CheckListBox.Items.Assign(All.Strings);
   // Zaznaczenie SEL w CheckListBox
   For T:=0 To Sel.Strings.Count - 1 Do Begin
    For T2 := 0 To CheckListBox.Items.Count - 1 Do Begin
     If CheckListBox.Items[T2]=Sel.Strings[T] Then Begin CheckListBox.Checked[T2] := True; Break; End;
    End;
   End;
  End;
end;

procedure TFMultiselect.FormShow(Sender: TObject);
begin
 ActiveControl := CheckListBox;
end;

procedure TFMultiselect.CheckListBoxDblClick(Sender: TObject);
begin
 DEdytujClick(Nil);
end;

end.
