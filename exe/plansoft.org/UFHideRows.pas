unit UFHideRows;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, CheckLst, Menus;

type
  TFHideRows = class(TForm)
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
    function ShowModalWithDefaults(BlocksPerDay : Integer; var hideRows : string) : TModalResult;
  end;

var
  FHideRows: TFHideRows;

implementation

uses DM;

{$R *.dfm}

procedure TFHideRows.BOKClick(Sender: TObject);
begin
 mr := mrOk;
 Close;
end;

procedure TFHideRows.BCancelClick(Sender: TObject);
begin
 mr := mrCancel;
 Close;
end;

procedure TFHideRows.MSelectAllClick(Sender: TObject);
Var i : Integer;
begin
  For i := 0 to CheckListBox1.Items.Count - 1 do CheckListBox1.Checked[i] := True;
end;

procedure TFHideRows.MDeselectAllClick(Sender: TObject);
Var i : Integer;
begin
  For i := 0 to CheckListBox1.Items.Count - 1 do CheckListBox1.Checked[i] := False;
end;

function TFHideRows.ShowModalWithDefaults(BlocksPerDay : Integer; var hideRows : string) : TModalResult;
Var
  i, no, maxNo : Integer;
  ch : Char;
Begin
  If BlocksPerDay < 1 Then BlocksPerDay := maxHours;

  CheckListBox1.Items.Clear;

  DModule.openSQL('select no, caption from grids where no <= '+IntToStr(BlocksPerDay)+' order by 1');
  With DModule.QWork do Begin
    While Not Eof Do Begin
      no := Fields[0].AsInteger;
      CheckListBox1.Items.AddObject(Fields[1].AsString, TObject(no));
      If Length(hideRows) = 0 Then ch := '+' Else ch := hideRows[((no-1) mod Length(hideRows)) + 1];
      CheckListBox1.Checked[CheckListBox1.Items.Count-1] := (ch <> '-');
      Next;
    End;
  End;

  mr := mrCancel;
  ShowModal;

  If mr = mrOk Then Begin
    maxNo := 0;
    For i := 0 to CheckListBox1.Items.Count - 1 do
      If Integer(CheckListBox1.Items.Objects[i]) > maxNo Then maxNo := Integer(CheckListBox1.Items.Objects[i]);

    hideRows := '';
    For i := 1 to maxNo do hideRows := hideRows + '+';

    For i := 0 to CheckListBox1.Items.Count - 1 do Begin
      no := Integer(CheckListBox1.Items.Objects[i]);
      If Not CheckListBox1.Checked[i] Then hideRows[no] := '-';
    End;
  End;

  Result := mr;
End;

end.
