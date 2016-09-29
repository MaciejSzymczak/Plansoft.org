unit EditGroup;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, GoogleCont;

type
  TEditGroupForm = class(TForm)
    Label1: TLabel;
    NameEd: TEdit;
    OKBtn: TButton;
    CancelBtn: TButton;
    procedure FormShow(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
  public
    Group: TGGroup;
    Contacts: TGContacts;
  end;

var
  EditGroupForm: TEditGroupForm;

implementation

{$R *.dfm}

procedure TEditGroupForm.FormShow(Sender: TObject);
begin
  if Group = nil then
  begin
    NameEd.Text := '';
    Caption := 'Create group';
  end
  else
  begin
    NameEd.Text := Group.Name;
    Caption := 'Edit group';
  end;
  NameEd.SetFocus;
end;

procedure TEditGroupForm.OKBtnClick(Sender: TObject);
begin
  if Trim(NameEd.Text) = '' then
  begin
    Showmessage('Please enter the name');
    ModalResult := mrNone;
    Exit;
  end;
  if Group = nil then
    Group := Contacts.NewGroup;
  Group.Name := NameEd.Text;
  Group.Store;
end;

end.

