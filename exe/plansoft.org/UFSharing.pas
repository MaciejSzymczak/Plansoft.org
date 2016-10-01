unit UFSharing;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormConfig, StdCtrls, CheckLst, Buttons, ExtCtrls;

type
  TFSharing = class(TFormConfig)
    CheckListBox: TCheckListBox;
    Panel1: TPanel;
    BUpdOK: TBitBtn;
    BUpdCancel: TBitBtn;
    Panel2: TPanel;
    ChangeAll: TCheckBox;
    procedure ChangeAllClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FSharing: TFSharing;

implementation

{$R *.dfm}

procedure TFSharing.ChangeAllClick(Sender: TObject);
var t : integer;
begin
 for t := 0 to FSharing.CheckListBox.Count - 1 do begin
   FSharing.CheckListBox.Checked[t] := ChangeAll.Checked;
 end;
end;

end.
