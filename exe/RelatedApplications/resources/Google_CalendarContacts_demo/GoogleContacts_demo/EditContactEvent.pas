unit EditContactEvent;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, GoogleCont, ComCtrls;

type
  TEditContactEventFrm = class(TForm)
    Label1: TLabel;
    NameEd: TEdit;
    OKBtn: TButton;
    CancelBtn: TButton;
    Label2: TLabel;
    TimeDTP: TDateTimePicker;
    procedure OKBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  end;

var
  EditContactEventFrm: TEditContactEventFrm;

implementation

{$R *.dfm}

procedure TEditContactEventFrm.OKBtnClick(Sender: TObject);
begin
  if Trim(NameEd.Text) = '' then
  begin
    Showmessage('Name can not be empty!');
    ModalResult := mrNone;
    Exit;
  end;
end;

procedure TEditContactEventFrm.FormShow(Sender: TObject);
begin
  NameEd.SetFocus;
end;

end.

