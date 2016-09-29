unit EditUserField;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, GoogleCont;

type
  TEditUserFieldFrm = class(TForm)
    Label1: TLabel;
    NameEd: TEdit;
    OKBtn: TButton;
    CancelBtn: TButton;
    Label2: TLabel;
    ValueEd: TEdit;
    procedure OKBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  end;

var
  EditUserFieldFrm: TEditUserFieldFrm;

implementation

{$R *.dfm}

procedure TEditUserFieldFrm.OKBtnClick(Sender: TObject);
begin
  if (Trim(NameEd.Text) = '') or (Trim(ValueEd.Text) = '') then
  begin
    Showmessage('Name and value can not be empty!');
    ModalResult := mrNone;
    Exit;
  end;
end;

procedure TEditUserFieldFrm.FormShow(Sender: TObject);
begin
  NameEd.SetFocus;
end;

end.

