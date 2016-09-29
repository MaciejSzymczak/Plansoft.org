unit EditCont;

interface

{$I Options.inc}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, GoogleCont, ComCtrls, Grids, ExtCtrls;

type
  TEditContForm = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Label2: TLabel;
    FNameEd: TEdit;
    Label4: TLabel;
    LNameEd: TEdit;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    MobileEd: TEdit;
    Label1: TLabel;
    PhoneEd: TEdit;
    Label3: TLabel;
    EMailEd: TEdit;
    Label5: TLabel;
    AddressEd: TEdit;
    Label6: TLabel;
    CityEd: TEdit;
    Label7: TLabel;
    StateEd: TEdit;
    Label8: TLabel;
    PostalEd: TEdit;
    Label9: TLabel;
    CountryEd: TEdit;
    Label10: TLabel;
    Label11: TLabel;
    FullNameEd: TEdit;
    Label12: TLabel;
    FAddressMM: TMemo;
    ICQEd: TEdit;
    Label13: TLabel;
    MSNEd: TEdit;
    Label14: TLabel;
    WebPageEd: TEdit;
    Label15: TLabel;
    Label16: TLabel;
    BirthdayTP: TDateTimePicker;
    TabSheet2: TTabSheet;
    CompanyEd: TEdit;
    Label17: TLabel;
    JobTitleEd: TEdit;
    Label18: TLabel;
    BusFaxEd: TEdit;
    Label19: TLabel;
    BusPhoneEd: TEdit;
    Label20: TLabel;
    BusEMailEd: TEdit;
    Label21: TLabel;
    Label22: TLabel;
    BusWebPageEd: TEdit;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    BusFAddressMM: TMemo;
    BusCountryEd: TEdit;
    BusPostalEd: TEdit;
    BusStateEd: TEdit;
    BusCityEd: TEdit;
    BusAddressEd: TEdit;
    Label29: TLabel;
    BusMobileEd: TEdit;
    TabSheet3: TTabSheet;
    UserFieldsGR: TStringGrid;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    TabSheet4: TTabSheet;
    EventsGR: TStringGrid;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    TabSheet5: TTabSheet;
    NotesMM: TMemo;
    TabSheet6: TTabSheet;
    PhotoIM: TImage;
    Button7: TButton;
    PhotoOD: TOpenDialog;
    Button8: TButton;
    Button9: TButton;
    procedure FormShow(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure BirthdayTPClick(Sender: TObject);
    procedure RefreshUserFields;
    procedure RefreshEvents;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure UserFieldsGRDblClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure EventsGRDblClick(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
  private
    procedure ShowPhoto;
  public
    Contact: TGContact;
    Group: TGGroup;
    Contacts: TGContacts;
  end;

var
  EditContForm: TEditContForm;

implementation

uses EditUserField, EditContactEvent,
{$IFDEF USEPNG}
  PNGImage,
{$ENDIF}
  Jpeg;

{$R *.dfm}

procedure TEditContForm.FormShow(Sender: TObject);
begin
  if Contact = nil then
  begin
    Caption := 'Create contact';
    FNameEd.Text := '';
    LNameEd.Text := '';
    FullNameEd.Text := '';
    MobileEd.Text := '';
    PhoneEd.Text := '';
    EMailEd.Text := '';
    AddressEd.Text := '';
    CityEd.Text := '';
    StateEd.Text := '';
    PostalEd.Text := '';
    CountryEd.Text := '';
    FAddressMM.Lines.Text := '';
    ICQEd.Text := '';
    MSNEd.Text := '';
    WebPageEd.Text := '';
    BirthdayTP.DateTime := 0;
    BirthdayTP.Checked := false;
    CompanyEd.Text := '';
    JobTitleEd.Text := '';
    BusFaxEd.Text := '';
    BusPhoneEd.Text := '';
    BusEMailEd.Text := '';
    BusWebPageEd.Text := '';
    BusAddressEd.Text := '';
    BusCityEd.Text := '';
    BusStateEd.Text := '';
    BusPostalEd.Text := '';
    BusCountryEd.Text := '';
    BusFAddressMM.Lines.Text := '';
    BusMobileEd.Text := '';
    NotesMM.Text := '';
    PhotoIM.Picture.Graphic := nil;
    Contact := Contacts.NewContact;
  end
  else
    with Contact do
    begin
      Caption := 'Edit contact';
      FNameEd.Text := FirstName;
      LNameEd.Text := LastName;
      FullNameEd.Text := FullName;
      MobileEd.Text := Mobile;
      PhoneEd.Text := Phone;
      EMailEd.Text := EMail;
      AddressEd.Text := Address;
      CityEd.Text := City;
      StateEd.Text := State;
      PostalEd.Text := Postal;
      CountryEd.Text := Country;
      FAddressMM.Lines.Text := FormattedAddress;
      ICQEd.Text := ICQ;
      MSNEd.Text := MSN;
      WebPageEd.Text := WebPage;
      BirthdayTP.DateTime := Birthday;
      BirthdayTP.Checked := BirthdayTP.DateTime <> 0;
      CompanyEd.Text := Company;
      JobTitleEd.Text := JobTitle;
      BusFaxEd.Text := BusinessFax;
      BusPhoneEd.Text := BusinessPhone;
      BusEMailEd.Text := BusinessEMail;
      BusWebPageEd.Text := BusinessWebPage;
      BusAddressEd.Text := BusinessAddress;
      BusCityEd.Text := BusinessCity;
      BusStateEd.Text := BusinessState;
      BusPostalEd.Text := BusinessPostal;
      BusCountryEd.Text := BusinessCountry;
      BusFAddressMM.Lines.Text := BusinessFormattedAddress;
      BusMobileEd.Text := BusinessMobile;
      NotesMM.Text := Notes;
      LoadPhoto;
      ShowPhoto;
    end;
  RefreshUserFields;
  RefreshEvents;
  PageControl1.TabIndex := 0;
  FNameEd.SetFocus;
end;

procedure TEditContForm.OKBtnClick(Sender: TObject);
begin
  if Trim(FNameEd.Text + LNameEd.Text + FullNameEd.Text) = '' then
  begin
    Showmessage('Please enter at least one name');
    ModalResult := mrNone;
    Exit;
  end;
  with Contact do
  begin
    FirstName := FNameEd.Text;
    LastName := LNameEd.Text;
    FullName := FullNameEd.Text;
    Mobile := MobileEd.Text;
    Phone := PhoneEd.Text;
    EMail := EMailEd.Text;
    Address := AddressEd.Text;
    City := CityEd.Text;
    State := StateEd.Text;
    Postal := PostalEd.Text;
    Country := CountryEd.Text;
    FormattedAddress := FAddressMM.Lines.Text;
    ICQ := ICQEd.Text;
    MSN := MSNEd.Text;
    WebPage := WebPageEd.Text;
    Birthday := BirthdayTP.DateTime;
    Company := CompanyEd.Text;
    JobTitle := JobTitleEd.Text;
    BusinessFax := BusFaxEd.Text;
    BusinessPhone := BusPhoneEd.Text;
    BusinessEMail := BusEMailEd.Text;
    BusinessWebPage := BusWebPageEd.Text;
    BusinessAddress := BusAddressEd.Text;
    BusinessCity := BusCityEd.Text;
    BusinessState := BusStateEd.Text;
    BusinessPostal := BusPostalEd.Text;
    BusinessCountry := BusCountryEd.Text;
    BusinessFormattedAddress := BusFAddressMM.Lines.Text;
    BusinessMobile := BusMobileEd.Text;
    Notes := NotesMM.Text;
    if TButton(Sender).Name = 'OKBtn' then
    begin
      if Group = nil then
        Store
      else
        AddToGroup(Group);
    end
    else if Group <> nil then
      AddToGroup(Group, False);
  end;
end;

procedure TEditContForm.BirthdayTPClick(Sender: TObject);
begin
  with BirthdayTP do
    if not Checked then
    begin
      DateTime := 0;
      Checked := false;
    end;
end;

procedure TEditContForm.RefreshUserFields;
var
  I: Integer;
begin
  with UserFieldsGR do
  begin
    RowCount := 2;
    Rows[0].Strings[0] := 'Field name';
    Rows[0].Strings[1] := 'Field value';
    Rows[1].Clear;
    FixedRows := 1;
    with Contact do
      for I := 0 to UserFieldsCount - 1 do
      begin
        RowCount := I + 2;
        Rows[I + 1].Strings[0] := GetUserField(I).Name;
        Rows[I + 1].Strings[1] := GetUserField(I).Value;
      end;
  end;
end;

procedure TEditContForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if (Caption = 'Create contact') and (ModalResult <> mrOK) then
    Contact.Delete;
end;

procedure TEditContForm.Button1Click(Sender: TObject);
begin
  with EditUserFieldFrm do
  begin
    Caption := 'Add field';
    NameEd.Text := '';
    ValueEd.Text := '';
    if ShowModal <> mrOK then
      Exit;
    // if can't add field (f.ex. if name or value is empty) then AddUserField returns -1
    if Contact.AddUserField(NameEd.Text, ValueEd.Text) < 0 then
      Exit;
  end;
  RefreshUserFields;
  UserFieldsGR.SetFocus;
end;

procedure TEditContForm.Button2Click(Sender: TObject);
begin
  with UserFieldsGR do
  begin
    if Trim(Rows[Row].Text) = '' then
      Exit;
    with EditUserFieldFrm do
    begin
      Caption := 'Edit field';
      NameEd.Text := Contact.GetUserField(Row - 1).Name;
      ValueEd.Text := Contact.GetUserField(Row - 1).Value;
      if ShowModal <> mrOK then
        Exit;
      Contact.UpdateUserField(Row - 1, NameEd.Text, ValueEd.Text);
    end;
    RefreshUserFields;
    SetFocus;
  end;
end;

procedure TEditContForm.UserFieldsGRDblClick(Sender: TObject);
begin
  Button2Click(Sender);
end;

procedure TEditContForm.Button3Click(Sender: TObject);
begin
  with UserFieldsGR do
  begin
    if Trim(Rows[Row].Text) = '' then
      Exit;
    Contact.DeleteUserField(Row - 1);
    RefreshUserFields;
    SetFocus;
  end;
end;

procedure TEditContForm.RefreshEvents;
var
  I: Integer;
begin
  with EventsGR do
  begin
    RowCount := 2;
    Rows[0].Strings[0] := 'Event name';
    Rows[0].Strings[1] := 'Event time';
    Rows[1].Clear;
    FixedRows := 1;
    with Contact do
      for I := 0 to EventsCount - 1 do
      begin
        RowCount := I + 2;
        Rows[I + 1].Strings[0] := GetEvent(I).Name;
        Rows[I + 1].Strings[1] := DateToStr(GetEvent(I).Time);
      end;
  end;
end;

procedure TEditContForm.EventsGRDblClick(Sender: TObject);
begin
  Button5Click(Sender);
end;

procedure TEditContForm.Button4Click(Sender: TObject);
begin
  with EditContactEventFrm do
  begin
    Caption := 'Add event';
    NameEd.Text := '';
    TimeDTP.DateTime := Now;
    if ShowModal <> mrOK then
      Exit;
    //if can't add field (f.ex. if name is empty) then AddEvent returns -1
    if Contact.AddEvent(NameEd.Text, TimeDTP.DateTime) < 0 then
      Exit;
  end;
  RefreshEvents;
  EventsGR.SetFocus;
end;

procedure TEditContForm.Button5Click(Sender: TObject);
begin
  with EventsGR do
  begin
    if Trim(Rows[Row].Text) = '' then
      Exit;
    with EditContactEventFrm do
    begin
      Caption := 'Edit field';
      NameEd.Text := Contact.GetEvent(Row - 1).Name;
      TimeDTP.DateTime := Contact.GetEvent(Row - 1).Time;
      if ShowModal <> mrOK then
        Exit;
      Contact.UpdateEvent(Row - 1, NameEd.Text, TimeDTP.DateTime);
    end;
    RefreshEvents;
    SetFocus;
  end;
end;

procedure TEditContForm.Button6Click(Sender: TObject);
begin
  with EventsGR do
  begin
    if Trim(Rows[Row].Text) = '' then
      Exit;
    Contact.DeleteEvent(Row - 1);
    RefreshEvents;
    SetFocus;
  end;
end;

procedure TEditContForm.Button7Click(Sender: TObject);
var
  Photo: TGraphic;
begin
{$IFDEF USEPNG}
  PhotoOD.Filter := 'All supported|*.bmp;*.jpg;*.jpeg;*.png|Bitmap image|*.bmp|JPEG Image|*.jpeg;*.jpg|PNG Image|*.png';
{$ELSE}
  PhotoOD.Filter := 'All supported|*.bmp;*.jpg;*.jpeg|Bitmap image|*.bmp|JPEG Image|*.jpeg;*.jpg';
{$ENDIF}
  if PhotoOD.Execute then
  begin
    if LowerCase(ExtractFileExt(PhotoOD.FileName)) = '.bmp' then
      Photo := TBitmap.Create
{$IFDEF USEPNG}
    else if LowerCase(ExtractFileExt(PhotoOD.FileName)) = '.png' then
      Photo := TPNGObject.Create
{$ENDIF}
    else
      Photo := TJPEGImage.Create;
    try
      Photo.LoadFromFile(PhotoOD.FileName);
      Contact.Photo := Photo;
      ShowPhoto;
    finally
      Photo.Free;
    end;
  end;
end;

procedure TEditContForm.ShowPhoto;
begin
  PhotoIM.Picture.Assign(Contact.Photo);
  if Contact.Photo = nil then
  begin
    PhotoIM.Canvas.Font := Self.Font;
    PhotoIM.Canvas.TextOut(10, 10, 'No image or image is in other format than supported');
  end;
end;

procedure TEditContForm.Button8Click(Sender: TObject);
begin
  Contact.DeletePhoto;
  ShowPhoto;
end;

end.

