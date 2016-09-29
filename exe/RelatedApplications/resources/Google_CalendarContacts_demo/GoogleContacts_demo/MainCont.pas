unit MainCont;

interface

uses
  GoogleCont, Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin;

type
  TMainFormCont = class(TForm)
    Label1: TLabel;
    EmailEd: TEdit;
    Label2: TLabel;
    PasswordEd: TEdit;
    ConnectBtn: TButton;
    GroupBox1: TGroupBox;
    ContactsLB: TListBox;
    ConAddBtn: TButton;
    ConEditBtn: TButton;
    ConDeleteBtn: TButton;
    GroupBox2: TGroupBox;
    GroupsLB: TListBox;
    GrAddBtn: TButton;
    GrEditBtn: TButton;
    GrDeleteBtn: TButton;
    Label3: TLabel;
    Label4: TLabel;
    ConAddGrBtn: TButton;
    ConRemGrBtn: TButton;
    CheckBox1: TCheckBox;
    ProxyEd: TEdit;
    Label5: TLabel;
    PortEd: TSpinEdit;
    Button1: TButton;
    ConBDelBtn: TButton;
    procedure ConnectBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ContactsLBClick(Sender: TObject);
    procedure ConEditBtnClick(Sender: TObject);
    procedure ConAddBtnClick(Sender: TObject);
    procedure ConDeleteBtnClick(Sender: TObject);
    procedure GroupsLBClick(Sender: TObject);
    procedure GrAddBtnClick(Sender: TObject);
    procedure GrEditBtnClick(Sender: TObject);
    procedure GrDeleteBtnClick(Sender: TObject);
    procedure GroupsLBDblClick(Sender: TObject);
    procedure ContactsLBDblClick(Sender: TObject);
    procedure ConAddGrBtnClick(Sender: TObject);
    procedure ConRemGrBtnClick(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ConBDelBtnClick(Sender: TObject);
  private
    procedure UpdateContacts(Group: TGGroup);
    procedure UpdateConButtons;
    procedure UpdateGroups;
    procedure UpdateGrButtons;
  end;

var
  MainFormCont: TMainFormCont;

implementation

uses EditCont, EditGroup, SelGroup;

{$R *.dfm}

var
  GContacts: TGContacts;

procedure TMainFormCont.ConnectBtnClick(Sender: TObject);
begin
  ConAddBtn.Enabled := False;
  GrAddBtn.Enabled := False;
  GroupsLB.Items.Clear;
  ContactsLB.Items.Clear;
  Application.ProcessMessages;
  if not CheckBox1.Checked then
    GContacts.Connect(EmailEd.Text, PasswordEd.Text)
  else
    GContacts.Connect(EmailEd.Text, PasswordEd.Text, ProxyEd.Text, PortEd.Value);
  ConAddBtn.Enabled := True;
  GrAddBtn.Enabled := True;
  UpdateGroups;
  UpdateContacts(nil);
  EMailEd.Enabled := false;
  PasswordEd.Enabled := false;
  ConnectBtn.Caption := 'Refresh';
end;

procedure TMainFormCont.FormCreate(Sender: TObject);
begin
  GContacts := TGContacts.Create;
//  GContacts.LogFileName := 'GCont.log';
end;

procedure TMainFormCont.FormDestroy(Sender: TObject);
begin
  GContacts.Free;
end;

procedure TMainFormCont.UpdateConButtons;
begin
  ConEditBtn.Enabled := ContactsLB.ItemIndex >= 0;
  ConDeleteBtn.Enabled := ConEditBtn.Enabled;
  ConBDelBtn.Enabled := ConEditBtn.Enabled;
  ConAddGrBtn.Enabled := ConEditBtn.Enabled;
  ConRemGrBtn.Enabled := ConEditBtn.Enabled and (GroupsLB.SelCount > 1);
end;

procedure TMainFormCont.UpdateContacts(Group: TGGroup);
var
  I: Integer;
begin
  with ContactsLB.Items, GContacts do
  begin
    if GroupsLB.ItemIndex > 0 then
      GroupBox1.Caption := 'Contacts (' + GroupsLB.Items[GroupsLB.ItemIndex] + ')'
    else
      GroupBox1.Caption := 'Contacts (All contacts)';
    Clear;
    for I := 0 to ContactsCount - 1 do
      if (Group = nil) or Contacts[I].InGroup(Group) then
      begin
        if Contacts[I].Deleted then
          AddObject('{deleted} ' + Contacts[I].Title, Contacts[I])
        else if Contacts[I].Changed then
        begin
          if Contacts[I].ID = '' then
            AddObject('{created} ' + Contacts[I].Title, Contacts[I])
          else
            AddObject('{changed} ' + Contacts[I].Title, Contacts[I])
        end
        else
          AddObject(Contacts[I].Title, Contacts[I]);
      end;
  end;
  UpdateConButtons;
end;

procedure TMainFormCont.ContactsLBClick(Sender: TObject);
var
  I, Index: Integer;
  Contact: TGContact;
begin
  GroupsLB.MultiSelect := true;
  GrEditBtn.Enabled := false;
  GrDeleteBtn.Enabled := false;
  with ContactsLB do
    Contact := TGContact(Items.Objects[ItemIndex]);
  with GroupsLB do
  begin
    Index := ItemIndex;
    ClearSelection;
    Selected[0] := true;
    for I := 1 to Count - 1 do
      if Contact.InGroup(TGGroup(Items.Objects[I])) then
        Selected[I] := True;
    ItemIndex := Index;
  end;
  UpdateConButtons;
end;

procedure TMainFormCont.ConEditBtnClick(Sender: TObject);
begin
  with ContactsLB, EditContForm do
  begin
    Contacts := GContacts;
    Group := nil;
    Contact := TGContact(Items.Objects[ItemIndex]);
    if ShowModal = mrOK then
    begin
      if GroupsLB.ItemIndex > 0 then
        Group := TGGroup(GroupsLB.Items.Objects[GroupsLB.ItemIndex])
      else
        Group := nil;
      UpdateContacts(Group);
    end;
  end;
end;

procedure TMainFormCont.ConAddBtnClick(Sender: TObject);
begin
  with GroupsLB do
    if SelCount > 1 then
    begin
      ClearSelection;
      GroupsLBClick(Sender);
    end;
  with ContactsLB, EditContForm do
  begin
    Contacts := GContacts;
    if GroupsLB.ItemIndex > 0 then
      Group := TGGroup(GroupsLB.Items.Objects[GroupsLB.ItemIndex])
    else
      Group := nil;
    Contact := nil;
    if ShowModal = mrOK then
      UpdateContacts(Group);
  end;
end;

procedure TMainFormCont.ConDeleteBtnClick(Sender: TObject);
begin
  with ContactsLB do
  begin
    TGContact(Items.Objects[ItemIndex]).Delete;
    Items.Delete(ItemIndex);
  end;
end;

procedure TMainFormCont.UpdateGroups;
var
  I: Integer;
begin
  with GroupsLB.Items, GContacts do
  begin
    Clear;
    Add('All contacts (not a group)');
    for I := 0 to GroupsCount - 1 do
      AddObject(Groups[I].Name, Groups[I]);
  end;
  UpdateGrButtons;
end;

procedure TMainFormCont.GroupsLBClick(Sender: TObject);
begin
  UpdateGrButtons;
  with GroupsLB do
  begin
    MultiSelect := false;
    UpdateContacts(TGGroup(Items.Objects[ItemIndex]));
  end;
end;

procedure TMainFormCont.UpdateGrButtons;
begin
  with GroupsLB do
    GrEditBtn.Enabled := (ItemIndex > 0) and not (TGGroup(Items.Objects[ItemIndex]).SystemGroup);
  GrDeleteBtn.Enabled := GrEditBtn.Enabled;
end;

procedure TMainFormCont.GrAddBtnClick(Sender: TObject);
begin
  with EditGroupForm, GroupsLB do
  begin
    ClearSelection;
    Contacts := GContacts;
    Group := nil;
    if ShowModal = mrOK then
      Items.AddObject(Group.Name, Group)
  end;
end;

procedure TMainFormCont.GrEditBtnClick(Sender: TObject);
begin
  with EditGroupForm, GroupsLB do
  begin
    Contacts := GContacts;
    Group := TGGroup(Items.Objects[ItemIndex]);
    if ShowModal = mrOK then
      Items[ItemIndex] := Group.Name;
  end;
end;

procedure TMainFormCont.GrDeleteBtnClick(Sender: TObject);
begin
  with GroupsLB do
  begin
    TGGroup(Items.Objects[ItemIndex]).Delete;
    Items.Delete(ItemIndex);
  end;
end;

procedure TMainFormCont.GroupsLBDblClick(Sender: TObject);
begin
  if GrEditBtn.Enabled then
    GrEditBtnClick(Sender);
end;

procedure TMainFormCont.ContactsLBDblClick(Sender: TObject);
begin
  if ConEditBtn.Enabled then
    ConEditBtnClick(Sender);
end;

procedure TMainFormCont.ConAddGrBtnClick(Sender: TObject);
var
  I: Integer;
  Contact: TGContact;
begin
  with ContactsLB do
    Contact := TGContact(Items.Objects[ItemIndex]);
  with SelGroupForm, SelGroupLB, GContacts do
  begin
    Items.Clear;
    for I := 0 to GroupsCount - 1 do
      if not Contact.InGroup(Groups[I]) then
        Items.AddObject(Groups[I].Name, Groups[I]);
    if ShowModal = mrOK then
    begin
      Contact.AddToGroup(TGGroup(Items.Objects[ItemIndex]));
      ContactsLBClick(Sender);
    end;
  end;
end;

procedure TMainFormCont.ConRemGrBtnClick(Sender: TObject);
var
  I: Integer;
  Contact: TGContact;
  CurGroup: TGGroup;
begin
  with GroupsLB do
    CurGroup := TGGroup(Items.Objects[ItemIndex]);
  with ContactsLB do
    Contact := TGContact(Items.Objects[ItemIndex]);
  with SelGroupForm, SelGroupLB, GContacts do
  begin
    Items.Clear;
    for I := 0 to GroupsCount - 1 do
      if Contact.InGroup(Groups[I]) then
        Items.AddObject(Groups[I].Name, Groups[I]);
    if ShowModal = mrOK then
    begin
      Contact.RemoveFromGroup(TGGroup(Items.Objects[ItemIndex]));
      ContactsLBClick(Sender);
      if TGGroup(Items.Objects[ItemIndex]) = CurGroup then
        with ContactsLB do
        begin
          Items.Delete(ItemIndex);
          UpdateConButtons;
        end;
    end;
  end;
end;

procedure TMainFormCont.CheckBox1Click(Sender: TObject);
begin
  ProxyEd.Enabled := CheckBox1.Checked;
  PortEd.Enabled := ProxyEd.Enabled;
end;

procedure TMainFormCont.Button1Click(Sender: TObject);
var
  Group: TGGroup;
begin
  GContacts.Store;
  if GroupsLB.ItemIndex > 0 then
    Group := TGGroup(GroupsLB.Items.Objects[GroupsLB.ItemIndex])
  else
    Group := nil;
  UpdateContacts(Group);
end;

procedure TMainFormCont.ConBDelBtnClick(Sender: TObject);
var
  Group: TGGroup;
begin
  with ContactsLB do
  begin
    TGContact(Items.Objects[ItemIndex]).BatchDelete;
    if GroupsLB.ItemIndex > 0 then
      Group := TGGroup(GroupsLB.Items.Objects[GroupsLB.ItemIndex])
    else
      Group := nil;
    UpdateContacts(Group);
  end;
end;

end.

