unit SelGroup;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TSelGroupForm = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    SelGroupLB: TListBox;
    procedure SelGroupLBDblClick(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
  end;

var
  SelGroupForm: TSelGroupForm;

implementation

{$R *.dfm}

procedure TSelGroupForm.SelGroupLBDblClick(Sender: TObject);
begin
  ModalResult := mrOK;
end;

procedure TSelGroupForm.OKBtnClick(Sender: TObject);
begin
  if SelGroupLB.ItemIndex < 0 then
  begin
    Showmessage('Please select a group');
    ModalResult := mrNone;
  end;
end;

end.

