unit UFDetails;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UFormConfig, RXSlider, StdCtrls, RxLookup, Mask, DBCtrls, Buttons,
  ExtCtrls, ComCtrls, UFLookupWindow, Menus, ImgList;

type
  TFDetails = class(TFormConfig)
    Panel2: TPanel;
    PC: TPageControl;
    TSReservation: TTabSheet;
    TSClasses: TTabSheet;
    LL1: TLabel;
    LF1: TLabel;
    LS1: TLabel;
    LRescat0_1: TLabel;
    LG1: TLabel;
    Label8: TLabel;
    Label6: TLabel;
    F1: TEdit;
    S1: TEdit;
    rescat0_1: TEdit;
    G1: TEdit;
    F_value1: TEdit;
    L1: TEdit;
    L_value1: TEdit;
    SelectL1: TBitBtn;
    ValidL: TBitBtn;
    notL: TCheckBox;
    notG: TCheckBox;
    NotResCat0_1: TCheckBox;
    ValidR: TBitBtn;
    ValidG: TBitBtn;
    SelectG1: TBitBtn;
    selectResCat0_1: TBitBtn;
    SelectS1: TBitBtn;
    SelectF1: TBitBtn;
    S_value1: TEdit;
    rescat0_1_value: TEdit;
    G_value1: TEdit;
    FILL1: TComboBox;
    LL2: TLabel;
    L2: TEdit;
    L_value2: TEdit;
    SelectL2: TBitBtn;
    ValidL2: TBitBtn;
    LG2: TLabel;
    G2: TEdit;
    G_value2: TEdit;
    SelectG2: TBitBtn;
    ValidG2: TBitBtn;
    LRescat0_2: TLabel;
    rescat0_2: TEdit;
    rescat0_2_value: TEdit;
    sr2: TBitBtn;
    ValidR2: TBitBtn;
    LF2: TLabel;
    F2: TEdit;
    F_value2: TEdit;
    selectF2: TBitBtn;
    rgReservationFor: TRadioGroup;
    Label12: TLabel;
    Created_by_: TEdit;
    SelectOwner: TBitBtn;
    Label13: TLabel;
    Owner_: TEdit;
    Panel1: TPanel;
    Label18: TLabel;
    Label19: TLabel;
    DATE: TLabel;
    HOUR: TLabel;
    BAddLec: TPopupMenu;
    Dodajwykadowc1: TMenuItem;
    SelectLF: TMenuItem;
    BAddGro: TPopupMenu;
    selectGF: TMenuItem;
    MenuItem2: TMenuItem;
    BAddRes: TPopupMenu;
    SelectRF: TMenuItem;
    MenuItem4: TMenuItem;
    PLEC: TSpeedButton;
    PGRO: TSpeedButton;
    PRESCAT0_1: TSpeedButton;
    Dodajwykadowcsporddostpnychktrykolwiektermin1: TMenuItem;
    Dodajgrupsporddostpnychktrykolwiektermin1: TMenuItem;
    Dodajzasbsporddostpnychktrykolwiektermin1: TMenuItem;
    Label20: TLabel;
    colour1: TShape;
    colour2: TShape;
    ColorDialog: TColorDialog;
    bcolpopup1: TSpeedButton;
    bcolpopup2: TSpeedButton;
    colourPopup: TPopupMenu;
    Wicejkolorw1: TMenuItem;
    Zielony1: TMenuItem;
    N1: TMenuItem;
    Czerwony1: TMenuItem;
    ImageList: TImageList;
    Label21: TLabel;
    LRescat1_1: TLabel;
    LRescat1_2: TLabel;
    rescat1_1: TEdit;
    rescat1_1_value: TEdit;
    selectResCat1_1: TBitBtn;
    PRESCAT1_1: TSpeedButton;
    notResCat1_1: TCheckBox;
    validResCat1_1: TBitBtn;
    BAddResCat1: TPopupMenu;
    MenuItem1: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem5: TMenuItem;
    validResCat1_2: TBitBtn;
    selectResCat1_2: TBitBtn;
    rescat1_2_value: TEdit;
    rescat1_2: TEdit;
    BSelectComb: TBitBtn;
    PanelDesc: TPanel;
    desc1: TEdit;
    desc2: TEdit;
    desc3: TEdit;
    desc4: TEdit;
    ldesc2: TLabel;
    ldesc1: TLabel;
    ldesc3: TLabel;
    ldesc4: TLabel;
    bdesc1: TBitBtn;
    bdesc2: TBitBtn;
    bdesc3: TBitBtn;
    bdesc4: TBitBtn;
    BCopy: TBitBtn;
    BPaste: TBitBtn;
    Panel3: TPanel;
    Label1: TLabel;
    CPattern: TEdit;
    Label2: TLabel;
    CCounter: TComboBox;
    BOK: TBitBtn;
    BitBtn1: TBitBtn;
    LCal: TLabel;
    CALID: TEdit;
    CALID_VALUE: TEdit;
    BClearCal: TSpeedButton;
    procedure notLClick(Sender: TObject);
    procedure SelectS1Click(Sender: TObject);
    procedure SelectF1Click(Sender: TObject);
    procedure L1Change(Sender: TObject);
    procedure ValidLClick(Sender: TObject);
    procedure ValidGClick(Sender: TObject);
    procedure ValidSClick(Sender: TObject);
    procedure ValidFClick(Sender: TObject);
    procedure G1Change(Sender: TObject);
    procedure rescat0_1Change(Sender: TObject);
    procedure S1Change(Sender: TObject);
    procedure F1Change(Sender: TObject);
    procedure ValidRClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BCopyClick(Sender: TObject);
    procedure BPasteClick(Sender: TObject);
    procedure selectF2Click(Sender: TObject);
    procedure L2Change(Sender: TObject);
    procedure G2Change(Sender: TObject);
    procedure rescat0_2Change(Sender: TObject);
    procedure F2Change(Sender: TObject);
    procedure ValidL2Click(Sender: TObject);
    procedure ValidG2Click(Sender: TObject);
    procedure ValidR2Click(Sender: TObject);
    procedure ValidF2Click(Sender: TObject);
    procedure SelectL2Click(Sender: TObject);
    procedure SelectG2Click(Sender: TObject);
    procedure sr2Click(Sender: TObject);
    procedure rgReservationForClick(Sender: TObject);
    procedure SelectOwnerClick(Sender: TObject);
    procedure L_value1Exit(Sender: TObject);
    procedure G_value1Exit(Sender: TObject);
    procedure rescat0_1_valueExit(Sender: TObject);
    procedure PLECClick(Sender: TObject);
    procedure SelectLFClick(Sender: TObject);
    procedure Dodajwykadowc1Click(Sender: TObject);
    procedure selectGFClick(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure SelectRFClick(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure SelectL1Click(Sender: TObject);
    procedure SelectG1Click(Sender: TObject);
    procedure selectResCat0_1Click(Sender: TObject);
    procedure Dodajwykadowcsporddostpnychktrykolwiektermin1Click(
      Sender: TObject);
    procedure Dodajgrupsporddostpnychktrykolwiektermin1Click(
      Sender: TObject);
    procedure Dodajzasbsporddostpnychktrykolwiektermin1Click(
      Sender: TObject);
    procedure colour1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure bcolpopup1Click(Sender: TObject);
    procedure Zielony1Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure Czerwony1Click(Sender: TObject);
    procedure Wicejkolorw1Click(Sender: TObject);
    procedure rescat1_1Change(Sender: TObject);
    procedure rescat1_1_valueExit(Sender: TObject);
    procedure selectResCat1_1Click(Sender: TObject);
    procedure validResCat1_1Click(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
    procedure rescat1_2Change(Sender: TObject);
    procedure selectResCat1_2Click(Sender: TObject);
    procedure validResCat1_2Click(Sender: TObject);
    procedure BSelectCombClick(Sender: TObject);
    procedure L_value2Exit(Sender: TObject);
    procedure G_value2Exit(Sender: TObject);
    procedure rescat0_2_valueExit(Sender: TObject);
    procedure rescat1_2_valueExit(Sender: TObject);
    procedure bdesc1Click(Sender: TObject);
    procedure bdesc2Click(Sender: TObject);
    procedure bdesc3Click(Sender: TObject);
    procedure bdesc4Click(Sender: TObject);
    procedure S_value1Click(Sender: TObject);
    procedure F_value1Click(Sender: TObject);
    procedure F_value2Click(Sender: TObject);
    procedure CWeeksChange(Sender: TObject);
    procedure CPatternClick(Sender: TObject);
    procedure CALIDChange(Sender: TObject);
    procedure CALID_VALUEClick(Sender: TObject);
    procedure BClearCalClick(Sender: TObject);
  private
    procedure selectLEC;
    procedure selectGRO;
    procedure selectRES;
    procedure selectResCat1;
    procedure selectLECAvail     ( pctAvailable : string );
    procedure selectGROAvail     ( pctAvailable : string );
    procedure selectResCat0Avail ( pctAvailable : string );
    procedure selectResCat1Avail ( pctAvailable : string );
    procedure setResLimitation   ( p_rescat_id : integer );
    procedure subjectChange(eventName : string);
    procedure formChange(eventName : string);
  public
    CanPaste : Boolean;
    Clipboard_L1 : String;
    Clipboard_G1 : String;
    Clipboard_ResCat0_1 : String;
    Clipboard_ResCat1_1 : String;
    Clipboard_S1 : String;
    Clipboard_F1 : String;
    Clipboard_Fill1 : String;
    Clipboard_L2 : String;
    Clipboard_G2 : String;
    Clipboard_ResCat0_2 : String;
    Clipboard_ResCat1_2 : String;
    Clipboard_F2 : String;
    Clipboard_Colour1 : integer;
    Clipboard_Colour2 : integer;
    Clipboard_Desc1 : string;
    Clipboard_Desc2 : string;
    Clipboard_Desc3 : string;
    Clipboard_Desc4 : string;
    CanRefresh   : Boolean;
    TS : TTimeStamp;
    Zajecia: Integer;
    oldCalName : string;

    procedure setValues(aTS : TTimeStamp; aZajecia: Integer; L, G, R, Rtypes : string; S, F, Fill, colour : Integer; Kind : string; ReservationFor : Integer; Created_by, Owner, pdesc1, pdesc2, pdesc3, pdesc4 : String);
    //Je¿eli Zajecia<>-1 (warunek Zajecia=-1 oznacza wiele terminow) to w na formularzu wyœwietla siê data i godzina zajêæ i dzia³aj¹ przyciski do wybierania wolnych wyk³adówców, grup, zasobow

    procedure getValues( Var L, G, R : string; var S, F, Fill, colour : integer; var Created_by, Owner, pdesc1, pdesc2, pdesc3, pdesc4 : string);
  end;

var
  FDetails: TFDetails;

implementation

{$R *.DFM}

Uses UUtilityParent, AutoCreate, DM, UCommon, UFMain, UFProgramSettings,
  UFPattern;


Procedure TFDetails.SetValues(aTS : TTimeStamp; aZajecia: Integer; L, G, R, Rtypes : String; S, F, Fill, colour : Integer; Kind : String; ReservationFor : Integer; Created_by, Owner, pdesc1, pdesc2, pdesc3, pdesc4 : String);
Begin
 CanRefresh := False;

 TS := aTS;
 Zajecia := aZajecia;

 if Zajecia <> -1 then begin
  DATE.Caption := DateTimeToStr(TimeStampToDateTime(TS));
  HOUR.Caption := IntToStr(Zajecia);
 end else begin
  DATE.Caption := '<kilka rekodów>';
  HOUR.Caption := '<kilka rekordów>';
 end;

 Created_by_.Text := Created_by;
 Owner_.Text      := Owner;

 If KIND = 'R' Then Begin PC.ActivePage := TSReservation; If f<>0 Then F2.Text := intToStr(F); End;
 If KIND = 'C' Then Begin PC.ActivePage := TSClasses;     If f<>0 Then F1.Text := intToStr(F); End;

 L1.Text        := L;
 G1.Text        := G;
 rescat0_1.Text := UCommon.getResourcesByType(dmodule.pResCatId0, Rtypes, R);
 rescat1_1.Text := UCommon.getResourcesByType(dmodule.pResCatId1, Rtypes, R);
 S1.Text        := intToStr(S);


 Fill1.ItemIndex := (Fill div 10)-1;
 Colour1.Brush.Color := colour;
 Colour2.Brush.Color := colour;

 L2.Text := L;
 G2.Text := G;
 rescat0_2.Text := UCommon.getResourcesByType(dmodule.pResCatId0, Rtypes, R);
 rescat1_2.Text := UCommon.getResourcesByType(dmodule.pResCatId1, Rtypes, R);

 desc1.Text := pdesc1;
 desc2.Text := pdesc2;
 desc3.Text := pdesc3;
 desc4.Text := pdesc4;

 CanRefresh := True;
 L1Change(nil);
 G1Change(nil);
 rescat0_1Change(nil);
 rescat1_1Change(nil);
 S1Change(nil);
 F1Change(nil);

 L2Change(nil);
 G2Change(nil);
 rescat0_2Change(nil);
 rescat1_2Change(nil);
 F2Change(nil);

 rgReservationFor.ItemIndex := ReservationFor;
End;

Procedure TFDetails.GetValues (Var L, G, R : string; var S, F, Fill, colour : integer; var Created_by, Owner, pdesc1, pdesc2, pdesc3, pdesc4 : string);
var tmpR1, tmpR2 : string;
begin
 Created_by := Created_by_.Text;
 Owner      := Owner_.Text;

 pdesc1 := desc1.Text;
 pdesc2 := desc2.Text;
 pdesc3 := desc3.Text;
 pdesc4 := desc4.Text;

 if PC.ActivePage = TSReservation Then Begin
   If rgReservationFor.ItemIndex = 0 Then L := L2.Text        Else L         := '';
   If rgReservationFor.ItemIndex = 1 Then G := G2.Text        Else G         := '';
   If rgReservationFor.ItemIndex = 2 Then R := rescat0_2.Text Else R         := '';
   If rgReservationFor.ItemIndex = 3 Then R := rescat1_2.Text Else rescat1_1.text := '';
   S    := 0;
   F    := strToInt(F2.Text);
   Fill := 100;
   Colour := colour1.Brush.Color;
 end else begin
   If        notL.Checked Then L     := '' Else     L := L1.Text;
   If        notG.Checked Then G     := '' Else     G := G1.Text;
   If notResCat0_1.Checked Then tmpR1 := '' Else tmpR1 := rescat0_1.Text;
   If notResCat1_1.Checked Then tmpR2 := '' Else tmpR2 := rescat1_1.Text;
   R := merge(tmpR1, tmpR2, ';');
   S    := strToInt(S1.Text); //s1 cannot be null-see check record
   F    := strToInt(F1.Text);
   Fill := strToInt(Fill1.Text);
   Colour := colour2.Brush.Color;
 end;
end;

procedure TFDetails.notLClick(Sender: TObject);
begin
 If (notL.Checked) And (notG.Checked) And (NotResCat0_1.Checked) and (notResCat1_1.Checked) Then
  Begin
   ShowMessage( format('Nie mo¿na zapisaæ rekordu bez %s, %s lub zasobu', [ fprogramsettings.profileObjectNameLgen.Text, fprogramsettings.profileObjectNameGgen.Text ] ) );
   notL.Checked        := True;
   notG.Checked        := True;
   notResCat0_1.Checked := True;
   notResCat1_1.Checked := True;
   TCheckBox(Sender).Checked := False;
  End;

  L_value1.Visible := Not notL.Checked;
  LL1.Visible      := Not notL.Checked;
  SelectL1.Visible := Not notL.Checked;
  //ValidL.Visible   := Not notL.Checked;
  plec.Visible     := Not notL.Checked;
  //
  G_value1.Visible := Not notG.Checked;
  LG1.Visible      := Not notG.Checked;
  SelectG1.Visible := Not notG.Checked;
  //ValidG.Visible   := Not notG.Checked;
  pgro.Visible     := Not notG.Checked;
  //
  rescat0_1_value.Visible  := Not notResCat0_1.Checked;
  LRescat0_1.Visible       := Not notResCat0_1.Checked;
  selectResCat0_1.Visible  := Not notResCat0_1.Checked;
  //ValidR.Visible           := Not notResCat0_1.Checked;
  PRESCAT0_1.Visible       := Not notResCat0_1.Checked;
  //
  rescat1_1_value.Visible  := Not notResCat1_1.Checked;
  LRescat1_1.Visible       := Not notResCat1_1.Checked;
  selectResCat1_1.Visible  := Not notResCat1_1.Checked;
  validResCat1_1.Visible   := Not notResCat1_1.Checked;
  PRESCAT1_1.Visible       := Not notResCat1_1.Checked;
end;

procedure TFDetails.selectLEC;
Var KeyValues : String;
    KeyValue  : string;
    t         : integer;
begin
  KeyValues := '';
  setResLimitation(g_lecturer);
  If LECTURERSShowModalAsMultiSelect(KeyValues,'','0=0','') = mrOK then begin
   for t := 1 to wordCount(KeyValues, [',']) do begin
     KeyValue := extractWord(t,KeyValues, [',']);
     if ExistsValue(L1.Text, [';'], KeyValue)
      then Info('Nie mo¿na wybraæ ponownie tego samego : ' + fprogramsettings.profileObjectNameL.Text)
      else L1.Text := Merge(L1.Text, KeyValue, ';');
   end;
  end;
end;

procedure TFDetails.selectGRO;
Var KeyValues : String;
    KeyValue  : string;
    t         : integer;
begin
  KeyValue := '';
  setResLimitation(g_group);
  If GROUPSShowModalAsMultiselect(KeyValues,'','0=0','') = mrOK Then Begin
   for t := 1 to wordCount(KeyValues, [',']) do begin
     KeyValue := extractWord(t,KeyValues, [',']);
     If ExistsValue(G1.Text, [';'], KeyValue)
      Then Info('Nie mo¿na wybraæ ponownie tego samego: ' + fprogramsettings.profileObjectNameG.Text)
      Else G1.Text := Merge(G1.Text, KeyValue, ';');
   end;
  End;
end;

procedure TFDetails.selectRES;
Var KeyValues : String;
    KeyValue  : string;
    t         : integer;
begin
  KeyValue := '';
  setResLimitation( strToInt(dmodule.pResCatId0) );
  If ROOMSShowModalAsMultiselect(dmodule.pResCatId0,'',KeyValues,'0=0','') = mrOK Then  Begin
   for t := 1 to wordCount(KeyValues, [',']) do begin
     KeyValue := extractWord(t,KeyValues, [',']);
     If ExistsValue(ResCat0_1.Text, [';'], KeyValue)
      Then Info('Nie mo¿na wybraæ ponownie tego samego zasobu')
      Else ResCat0_1.Text := Merge(ResCat0_1.Text, KeyValue, ';');
   end;
  End;
end;

procedure TFDetails.selectResCat1;
Var KeyValues : String;
    KeyValue  : string;
    t         : integer;
begin
  KeyValue := '';
  setResLimitation( strToInt(dmodule.pResCatId1) );
  If ROOMSShowModalAsMultiselect(dmodule.pResCatId1,'',KeyValues,'0=0','') = mrOK Then  Begin
   for t := 1 to wordCount(KeyValues, [',']) do begin
     KeyValue := extractWord(t,KeyValues, [',']);
     If ExistsValue(ResCat1_1.Text, [';'], KeyValue)
      Then Info('Nie mo¿na wybraæ ponownie tego samego zasobu')
      Else ResCat1_1.Text := Merge(ResCat1_1.Text, KeyValue, ';');
   end;
  End;
end;

function getText ( pctAvailable : string ) : string;
begin
 if pctAvailable = '100'
   then result := 'Pokazuje dostêpne we wszystkich zaznaczonych terminach'
   else result := 'Pokazuje dostêpne w którymkolwiek z zaznaczonych terminów';
end;

procedure TFDetails.selectLECAvail;
Var KeyValues : String;
    KeyValue  : string;
    t         : integer;
    CONDL, CONDG, CONDR : String;
begin
  GetEnabledLGR(L1.Text, '', '', '', '', User , true, CONDL, CONDG, CONDR, pctAvailable, 'L');
  KeyValues := '';
  setResLimitation(g_lecturer);
  If LECTURERSShowModalAsMultiSelect(KeyValues,'',CONDL, getText(pctAvailable) ) = mrOK then begin
   for t := 1 to wordCount(KeyValues, [',']) do begin
     KeyValue := extractWord(t,KeyValues, [',']);
     if ExistsValue(L1.Text, [';'], KeyValue)
      then Info('Nie mo¿na wybraæ ponownie tego samego :' + fprogramsettings.profileObjectNameL.Text )
      else L1.Text := Merge(L1.Text, KeyValue, ';');
   end;
  end;
end;

procedure TFDetails.selectGROAvail;
Var KeyValues : String;
    KeyValue  : string;
    t         : integer;
    CONDL, CONDG, CONDR : String;
begin
  GetEnabledLGR('', G1.Text, '', '', '', User , true, CONDL, CONDG, CONDR, pctAvailable, 'G');
  KeyValue := '';
  setResLimitation(g_group);
  If GROUPSShowModalAsMultiselect(KeyValues,'',CONDG, getText(pctAvailable) ) = mrOK Then Begin
   for t := 1 to wordCount(KeyValues, [',']) do begin
     KeyValue := extractWord(t,KeyValues, [',']);
     If ExistsValue(G1.Text, [';'], KeyValue)
      Then Info('Nie mo¿na wybraæ ponownie tego samego :' + fprogramsettings.profileObjectNameG.Text)
      Else G1.Text := Merge(G1.Text, KeyValue, ';');
   end;
  End;
end;

procedure TFDetails.selectResCat0Avail;
Var KeyValues : String;
    KeyValue  : string;
    t         : integer;
    CONDL, CONDG, CONDR : String;
begin
  GetEnabledLGR('', '', ResCat0_1.Text, '', '', User , true, CONDL, CONDG, CONDR, pctAvailable, 'R');
  KeyValue := '';
  setResLimitation( strToInt(dmodule.pResCatId0) );
  if ROOMSShowModalAsMultiselect(dmodule.pResCatId0,'',KeyValues,CONDR, getText(pctAvailable) ) = mrOK Then  Begin
   for t := 1 to wordCount(KeyValues, [',']) do begin
     KeyValue := extractWord(t,KeyValues, [',']);
     if ExistsValue(ResCat0_1.Text, [';'], KeyValue)
      then Info('Nie mo¿na wybraæ ponownie tego samego zasobu')
      else ResCat0_1.Text := Merge(ResCat0_1.Text, KeyValue, ';');
   end;
  End;
end;

procedure TFDetails.selectResCat1Avail;
Var KeyValues : String;
    KeyValue  : string;
    t         : integer;
    CONDL, CONDG, CONDR : String;
begin
  GetEnabledLGR('', '', ResCat1_1.Text, '', '', User , true, CONDL, CONDG, CONDR, pctAvailable, 'R');
  KeyValue := '';
  setResLimitation( strToInt(dmodule.pResCatId1) );
  if ROOMSShowModalAsMultiselect(dmodule.pResCatId1,'',KeyValues,CONDR, getText(pctAvailable) ) = mrOK Then  Begin
   for t := 1 to wordCount(KeyValues, [',']) do begin
     KeyValue := extractWord(t,KeyValues, [',']);
     if ExistsValue(ResCat1_1.Text, [';'], KeyValue)
      then Info('Nie mo¿na wybraæ ponownie tego samego zasobu')
      else ResCat1_1.Text := Merge(ResCat1_1.Text, KeyValue, ';');
   end;
  End;
end;

procedure TFDetails.SelectS1Click(Sender: TObject);
Var KeyValue : ShortString;
begin
  KeyValue := S1.Text;
  setResLimitation(g_subject);
  If SUBJECTSShowModalAsSelect(KeyValue,'') = mrOK Then begin
    S1.Text := KeyValue;
    subjectChange('change');
  end;  
end;

procedure TFDetails.SelectF1Click(Sender: TObject);
Var KeyValue : ShortString;
begin
  //If LookupWindow(DModule.Database, 'FORMS F, FOR_PLA','F.ID'      ,'NAME'        ,'NAZWA','NAME'        ,'(KIND<>''R'' OR KIND IS NULL) AND FOR_PLA.FOR_ID = F.ID AND PLA_ID = '+FMain.getUserOrRoleID ,'',KeyValue) = mrOK Then F1.Text := KeyValue;
  KeyValue := F1.Text;
  setResLimitation(g_form);
  If FORMSShowModalAsSelect(KeyValue,'C') = mrOK Then begin
    F1.Text := KeyValue;
    formChange('change');
  end;
end;

procedure TFDetails.L1Change(Sender: TObject);
begin
  If Not CanRefresh Then Exit;
  FChange(L1, L_value1, dm.sql_LECDESC );
end;

procedure TFDetails.ValidLClick(Sender: TObject);
Var Values, IDs : String;
begin
  inherited;
 Values := L_value1.Text;
 ValidValues('LECTURERS',Values,sql_LECNAME,IDs);
 L_value1.Text := Values;
 L1.Text := IDs;
end;

procedure TFDetails.ValidGClick(Sender: TObject);
Var Values, IDs : String;
begin
  inherited;
 Values := G_value1.Text;
 ValidValues('GROUPS',Values,sql_GRONAME,IDs);
 G_value1.Text := Values;
 G1.Text := IDs;
end;

procedure TFDetails.ValidSClick(Sender: TObject);
Var Values, IDs : String;
begin
  inherited;
 Values := S_value1.Text;
 ValidValues('SUBJECTS',Values,sql_SUBNAME,IDs);
 S_value1.Text := Values;
 S1.Text := IDs;
end;

procedure TFDetails.ValidFClick(Sender: TObject);
Var Values, IDs : String;
begin
  inherited;
 Values := F_value1.Text;
 ValidValues('FORMS',Values,sql_FORNAME,IDs);
 F_value1.Text := Values;
 F1.Text := IDs;
end;

procedure TFDetails.G1Change(Sender: TObject);
begin
  If Not CanRefresh Then Exit;
  FChange(G1, G_value1, dm.sql_GRODESC );
end;

procedure TFDetails.rescat0_1Change(Sender: TObject);
begin
  If Not CanRefresh Then Exit;
  FChange(ResCat0_1, ResCat0_1_value, sql_ResCat0DESC );
end;

procedure TFDetails.S1Change(Sender: TObject);
begin
  If Not CanRefresh Then Exit;
  FChange(S1, S_value1, dm.sql_SUBDESC );
end;

procedure TFDetails.F1Change(Sender: TObject);
begin
  If Not CanRefresh Then Exit;
  FChange(F1, F_value1, dm.sql_FORDESC);
end;

procedure TFDetails.ValidRClick(Sender: TObject);
Var Values, IDs : String;
begin
 Values := rescat0_1_value.Text;
 ValidValues('ROOMS',Values,sql_ResCat0NAME,IDs);
 rescat0_1_value.Text := Values;
 rescat0_1.Text := IDs;
end;

procedure TFDetails.validResCat1_1Click(Sender: TObject);
var Values, IDs : String;
begin
 Values := resCat1_1_value.Text;
 ValidValues('ROOMS',Values,sql_ResCat1NAME,IDs);
 resCat1_1_value.Text := Values;
 resCat1_1.Text := IDs;
end;

procedure TFDetails.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  Function HasPermissionL(L : String) : Boolean;  Begin Result := WordCount(L,[';']) = StrToInt(DModule.SingleValue('SELECT COUNT(1) FROM LEC_PLA WHERE PLA_ID = '+FMain.getUserOrRoleID+' AND LEC_ID IN ('+SearchAndReplace(L,';',',')+')')); End;
  Function HasPermissionG(G : String) : Boolean;  Begin Result := WordCount(G,[';']) = StrToInt(DModule.SingleValue('SELECT COUNT(1) FROM GRO_PLA WHERE PLA_ID = '+FMain.getUserOrRoleID+' AND GRO_ID IN ('+SearchAndReplace(G,';',',')+')')); End;
  Function HasPermissionR(R : String) : Boolean;  Begin Result := WordCount(R,[';']) = StrToInt(DModule.SingleValue('SELECT COUNT(1) FROM ROM_PLA WHERE PLA_ID = '+FMain.getUserOrRoleID+' AND ROM_ID IN ('+SearchAndReplace(R,';',',')+')')); End;
  var stringTokenizer : TStringTokenizer;
  function countTokens (s : string) : integer;
  begin
    with stringTokenizer do begin
      s := searchAndReplace(s, ';', ',');
      init(s);
      result := count;
      close;
    end;
  end;
  var cd1, cd2, cd3, cd4, cl : integer;
      serror, ferror : string;
begin
  inherited;
  If ModalResult = mrOK Then
   Begin
    With UUtilityParent.CheckValid Do Begin //Metody: Init, addError(S : String), AddWarning(S : String),   ShowMessage : Boolean = czy wszystko jest ok ?
    Init(Self);

    If PC.ActivePage = TSClasses Then Begin
      ValidLClick(nil);
      ValidGClick(nil);
      ValidRClick(nil);
      ValidSClick(nil);
      ValidFClick(nil);
      If not notL.Checked Then Begin
        If strIsEmpty(L_value1.TEXT) Then addError(  format('%s musi zostaæ wybrane. Jeœli nie chcesz okreœlaæ %s zaznacz pole wyboru "Bez %s"',[L_value1.Hint, fprogramsettings.profileObjectNameLgen.Text, fprogramsettings.profileObjectNameLgen.Text]));
        If Not strIsEmpty(L1.TEXT) Then If Not HasPermissionL(L1.TEXT) Then addError('Nie masz uprawnieñ do planowania dla '+fprogramsettings.profileObjectNameLgen.Text);
      End;
      If not notG.Checked Then Begin
        If strIsEmpty(G_value1.TEXT) Then addError(  format('%s musi zostaæ wybrane. Jeœli nie chcesz okreœlaæ %s zaznacz pole wyboru "Bez %s"',[g_value1.Hint, fprogramsettings.profileObjectNameGgen.Text, fprogramsettings.profileObjectNameGgen.Text]));
        If Not strIsEmpty(G1.TEXT) Then If Not HasPermissionG(G1.TEXT) Then addError('Nie masz uprawnieñ do planowania dla '+fprogramsettings.profileObjectNameLgen.Text);
      End;
      If not notResCat0_1.Checked Then If strIsEmpty(rescat0_1_value.TEXT) Then Begin
        addError(rescat0_1_value.Hint + ' musi zostaæ wybrane. Jeœli nie chcesz okreœlaæ sal zaznacz pole wyboru "Bez tego zasobu"');
        If Not strIsEmpty(rescat0_1.TEXT) Then If Not HasPermissionR(rescat0_1.TEXT) Then addError('Nie masz uprawnieñ do planowania dla tego zasobu');
      End;
      If not notResCat1_1.Checked Then If strIsEmpty(rescat1_1_value.TEXT) Then Begin
        addError(rescat1_1_value.Hint + ' musi zostaæ wybrane. Jeœli nie chcesz okreœlaæ zasobów zaznacz pole wyboru "Bez tego zasobu"');
        If Not strIsEmpty(resCat1_1.TEXT) Then If Not HasPermissionR(resCat1_1.TEXT) Then addError('Nie masz uprawnieñ do planowania dla tego zasobu');
      End;

      RestrictEmpty([S_value1, F_value1 ]);
      If strIsEmpty(FILL1.TEXT) Then addError(FILL1.Hint + ' musi zostaæ wybrane');

      if (not notL.Checked) then begin
        stringTokenizer := TStringTokenizer.Create;
        cl := countTokens(L_value1.Text);
        cd1 := countTokens(desc1.text);
        cd2 := countTokens(desc2.text);
        cd3 := countTokens(desc3.text);
        cd4 := countTokens(desc4.text);
        serror := 'Liczba wyk³adowców('+intToStr(cl)+') nie zgadza siê z liczb¹ przedmiotów';
        ferror := 'Liczba wyk³adowców('+intToStr(cl)+') nie zgadza siê z liczb¹ form zajêæ';
        if fprogramSettings.CopyField1.ItemIndex = 2 then if (cl <> cd1) and (cd1<>1) then addError(serror+'('+intToStr(cd1)+')');
        if fprogramSettings.CopyField2.ItemIndex = 2 then if (cl <> cd2) and (cd2<>1) then addError(serror+'('+intToStr(cd2)+')');
        if fprogramSettings.CopyField3.ItemIndex = 2 then if (cl <> cd3) and (cd3<>1) then addError(serror+'('+intToStr(cd3)+')');
        if fprogramSettings.CopyField4.ItemIndex = 2 then if (cl <> cd4) and (cd4<>1) then addError(serror+'('+intToStr(cd4)+')');
        //
        if fprogramSettings.CopyField1.ItemIndex = 3 then if (cl <> cd1) and (cd1<>1) then addError(ferror+'('+intToStr(cd1)+')');
        if fprogramSettings.CopyField2.ItemIndex = 3 then if (cl <> cd2) and (cd2<>1) then addError(ferror+'('+intToStr(cd2)+')');
        if fprogramSettings.CopyField3.ItemIndex = 3 then if (cl <> cd3) and (cd3<>1) then addError(ferror+'('+intToStr(cd3)+')');
        if fprogramSettings.CopyField4.ItemIndex = 3 then if (cl <> cd4) and (cd4<>1) then addError(ferror+'('+intToStr(cd4)+')');
        stringTokenizer.free;
      end;

    End Else Begin
      ValidL2Click(nil);
      ValidG2Click(nil);
      ValidR2Click(nil);
      //ValidS2Click(nil);
      ValidF2Click(nil);
      If (rgReservationFor.ItemIndex = 0) Then Begin
        If strIsEmpty(L_value2.TEXT) Then addError(L_value2.Hint + ' musi zostaæ wybrane');
        If Not strIsEmpty(L2.TEXT) Then If Not HasPermissionL(L2.TEXT) Then AddError('Nie masz uprawnieñ do planowania dla '+fprogramsettings.profileObjectNameLgen.Text);
      End;
      If (rgReservationFor.ItemIndex = 1) Then Begin
        If strIsEmpty(g_value2.TEXT) Then addError(g_value2.Hint + ' musi zostaæ wybrane');
        If Not strIsEmpty(G2.TEXT) Then If Not HasPermissionG(G2.TEXT) Then addError('Nie masz uprawnieñ do planowania dla '+fprogramsettings.profileObjectNameGgen.Text);
      End;
      If (rgReservationFor.ItemIndex = 2) Then Begin
        If strIsEmpty(rescat0_2_value.TEXT) Then addError(rescat0_2_value.Hint + ' musi zostaæ wybrane');
        If Not strIsEmpty(rescat0_2.TEXT) Then If Not HasPermissionR(rescat0_2.TEXT) Then addError('Nie masz uprawnieñ do planowania dla tego zasobu');
      End;
      If (rgReservationFor.ItemIndex = 3) Then Begin
        If strIsEmpty(rescat1_2_value.TEXT) Then addError(rescat1_2_value.Hint + ' musi zostaæ wybrane');
        If Not strIsEmpty(rescat1_2.TEXT) Then If Not HasPermissionR(rescat1_2.TEXT) Then addError('Nie masz uprawnieñ do planowania dla tego zasobu');
      End;
      RestrictEmpty([F_value2]);

      if rgReservationFor.ItemIndex = 0 then begin
        stringTokenizer := TStringTokenizer.Create;
        cl := countTokens(L_value2.Text);
        cd1 := countTokens(desc1.text);
        cd2 := countTokens(desc2.text);
        cd3 := countTokens(desc3.text);
        cd4 := countTokens(desc4.text);
        ferror := 'Liczba wyk³adowców('+intToStr(cl)+') nie zgadza siê z liczb¹ rezerwacji/form zajêæ';
        if fprogramSettings.CopyField1.ItemIndex = 3 then if (cl <> cd1) and (cd1<>1) then addError(ferror+'('+intToStr(cd1)+')');
        if fprogramSettings.CopyField2.ItemIndex = 3 then if (cl <> cd2) and (cd2<>1) then addError(ferror+'('+intToStr(cd2)+')');
        if fprogramSettings.CopyField3.ItemIndex = 3 then if (cl <> cd3) and (cd3<>1) then addError(ferror+'('+intToStr(cd3)+')');
        if fprogramSettings.CopyField4.ItemIndex = 3 then if (cl <> cd4) and (cd4<>1) then addError(ferror+'('+intToStr(cd4)+')');
        stringTokenizer.free;
      end;

    End;
    CanClose := ShowMessage;
    End;
  End;
end;

procedure TFDetails.FormShow(Sender: TObject);
begin
  inherited;
  PanelDesc.Visible := (FProgramSettings.getClassDescPlural(1)<>'') or (FProgramSettings.getClassDescPlural(2)<>'') or (FProgramSettings.getClassDescPlural(3)<>'') or (FProgramSettings.getClassDescPlural(4)<>'');
  ldesc1.Caption := FProgramSettings.getClassDescPlural(1);
  ldesc2.Caption := FProgramSettings.getClassDescPlural(2);
  ldesc3.Caption := FProgramSettings.getClassDescPlural(3);
  ldesc4.Caption := FProgramSettings.getClassDescPlural(4);
  desc1.Visible  := FProgramSettings.getClassDescPlural(1)<>'';
  desc2.Visible  := FProgramSettings.getClassDescPlural(2)<>'';
  desc3.Visible  := FProgramSettings.getClassDescPlural(3)<>'';
  desc4.Visible  := FProgramSettings.getClassDescPlural(4)<>'';
  bdesc1.Visible  := FProgramSettings.getClassDescPlural(1)<>'';
  bdesc2.Visible  := FProgramSettings.getClassDescPlural(2)<>'';
  bdesc3.Visible  := FProgramSettings.getClassDescPlural(3)<>'';
  bdesc4.Visible  := FProgramSettings.getClassDescPlural(4)<>'';

  LRescat0_1.Caption := dmodule.pResCatName0;
  rescat0_1_value.Hint:= ansiUpperCase( dmodule.pResCatName0 );
  rescat0_2_value.Hint:= ansiUpperCase( dmodule.pResCatName0 );
  LRescat0_2.Caption := dmodule.pResCatName0;

  LRescat1_1.Caption := dmodule.pResCatName1;
  rescat1_1_value.Hint:= ansiUpperCase( dmodule.pResCatName1 );
  rescat1_2_value.Hint:= ansiUpperCase( dmodule.pResCatName1 );
  LRescat1_2.Caption := dmodule.pResCatName1;

  If nvl(Owner_.Text, User) = User Then Begin
    Owner_.Color        := ClWindow;
    SelectOwner.Enabled := True;
    //pc.Enabled          := True;
    BOK.Enabled         := True;
  End Else Begin
    Owner_.Color        := clMenu;
    SelectOwner.Enabled := False;
    //PC.Enabled          := False;
    BOK.Enabled         := False;
  End;

         notL.Checked := strIsEmpty(L1.Text);
         notG.Checked := strIsEmpty(G1.Text);
         notResCat0_1.Checked := strIsEmpty(resCat0_1.Text);
  notResCat1_1.Checked := strIsEmpty(resCat1_1.Text);
  rgReservationForClick(nil);
  CWeeksChange(nil);
  formChange('formShow');
  subjectChange('formShow');

  CCounter.Enabled :=  elementEnabled('"Kalendarze szczególne"','2015.07.05', true);
  CPattern.Enabled :=  elementEnabled('"Kalendarze szczególne"','2015.07.05', true);
end;

procedure TFDetails.FormCreate(Sender: TObject);
begin
  inherited;
  CanPaste := False;
  oldCalName := '';
end;

procedure TFDetails.BCopyClick(Sender: TObject);
begin
  inherited;
  CanPaste      := True;

  uutilityParent.copyToClipBoard(
    'Data: '+ DATE.Caption + cr+
    'Blok: '+HOUR.Caption+cr+
    fprogramsettings.profileObjectNameLs.Text + ':' + nvl(L_value1.Text,L_value2.Text) + cr +
    fprogramsettings.profileObjectNameGs.Text + ':' + nvl(g_value1.Text,g_value2.Text) + cr +
    dmodule.pResCatName0 + nvl(rescat0_1_value.Text,rescat0_2_value.Text) + cr +
    dmodule.pResCatName1 + nvl(rescat1_1_value.Text, rescat1_2_value.Text) + cr +
    fprogramsettings.profileObjectNameC1.Text + ':'         + nvl(s_value1.Text,'')+ cr +
    fprogramsettings.profileObjectNameC2.Text + ':'       + nvl(f_value1.Text,'') + cr +
    FProgramSettings.getClassDescPlural(1)+':' + desc1.Text + cr +
    FProgramSettings.getClassDescPlural(2)+':' + desc2.Text + cr +
    FProgramSettings.getClassDescPlural(3)+':' + desc3.Text + cr +
    FProgramSettings.getClassDescPlural(4)+':' + desc4.Text
  );

  Clipboard_L1      := L1.Text;
  Clipboard_G1      := G1.Text;
  Clipboard_ResCat0_1 := ResCat0_1.Text;
  Clipboard_ResCat1_1 := ResCat1_1.Text;
  Clipboard_S1      := S1.Text;
  Clipboard_F1      := F1.Text;
  Clipboard_Fill1   := Fill1.Text;
  Clipboard_L2      := L2.Text;
  Clipboard_G2      := G2.Text;
  Clipboard_ResCat0_2 := ResCat0_2.Text;
  Clipboard_ResCat1_2 := ResCat1_2.Text;
  Clipboard_F2      := F2.Text;
  Clipboard_Colour1 := Colour1.brush.color;
  Clipboard_Colour2 := Colour2.brush.color;

  if elementEnabled('"Schowek opisy"','2016.03.20', true) then begin
    Clipboard_Desc1   := desc1.Text;
    Clipboard_Desc2   := desc2.Text;
    Clipboard_Desc3   := desc3.Text;
    Clipboard_Desc4   := desc4.Text;
  end;
end;

procedure TFDetails.BPasteClick(Sender: TObject);
begin
  inherited;
 If Not CanPaste Then Info('Brak danych do wklejenia')
 Else Begin
  L1.Text             := Clipboard_L1;
  G1.Text             := Clipboard_G1;
  resCat0_1.Text      := Clipboard_Rescat0_1;
  resCat1_1.Text      := Clipboard_Rescat1_1;
  S1.Text             := Clipboard_S1;
  F1.Text             := Clipboard_F1;
  FILL1.ItemIndex     := (StrToInt(Clipboard_Fill1) div 10)-1;
  Colour1.Brush.Color := Clipboard_Colour1;

  L2.Text             := Clipboard_L2;
  G2.Text             := Clipboard_G2;
  resCat0_2.Text      := Clipboard_Rescat0_2;
  resCat1_2.Text      := Clipboard_Rescat1_2;
  F2.Text             := Clipboard_F2;
  Colour2.Brush.Color := Clipboard_Colour2;

  notL.checked        :=  Clipboard_L1 = '';
  notG.checked        :=  Clipboard_G1 = '';
  NotResCat0_1.checked:=  Clipboard_Rescat0_1 = '';
  notResCat1_1.checked:=  Clipboard_Rescat1_1 = '';

  if elementEnabled('"Schowek opisy"','2016.03.20', true) then begin
    desc1.Text          := Clipboard_Desc1;
    desc2.Text          := Clipboard_Desc2;
    desc3.Text          := Clipboard_Desc3;
    desc4.Text          := Clipboard_Desc4;
  end;
 End;
end;

procedure TFDetails.selectF2Click(Sender: TObject);
Var KeyValue : ShortString;
begin
  //If LookupWindow(DModule.Database, 'FORMS F, FOR_PLA','F.ID'      ,'NAME'        ,'NAZWA','NAME'        ,'KIND=''R'' AND FOR_PLA.FOR_ID = F.ID AND PLA_ID = '+FMain.getUserOrRoleID ,'',KeyValue) = mrOK Then F2.Text := KeyValue;
  KeyValue := F2.Text;
  setResLimitation(g_form);
  If FORMSShowModalAsSelect(KeyValue,'R') = mrOK Then begin
    F2.Text := KeyValue;
    formChange('change');
  end;
end;

procedure TFDetails.L2Change(Sender: TObject);
begin
  inherited;
  If Not CanRefresh Then Exit;
  FChange(L2, L_value2, dm.sql_LECDESC );
end;

procedure TFDetails.G2Change(Sender: TObject);
begin
  inherited;
  If Not CanRefresh Then Exit;
  FChange(G2, G_value2, dm.sql_GRODESC );
end;

procedure TFDetails.rescat0_2Change(Sender: TObject);
begin
  inherited;
  If Not CanRefresh Then Exit;
  FChange(rescat0_2, rescat0_2_value, dm.sql_ResCat0DESC );
end;

procedure TFDetails.F2Change(Sender: TObject);
begin
  If Not CanRefresh Then Exit;
  FChange(F2, F_value2, dm.sql_FORDESC );
end;

procedure TFDetails.ValidL2Click(Sender: TObject);
Var Values, IDs : String;
begin
  inherited;
 Values := L_value2.Text;
 ValidValues('LECTURERS',Values,sql_LECNAME,IDs);
 L_value2.Text := Values;
 L2.Text := IDs;
end;

procedure TFDetails.ValidG2Click(Sender: TObject);
Var Values, IDs : String;
begin
  inherited;
 Values := G_value2.Text;
 ValidValues('GROUPS',Values,sql_GRONAME,IDs);
 G_value2.Text := Values;
 G2.Text := IDs;
end;

procedure TFDetails.ValidR2Click(Sender: TObject);
Var Values, IDs : String;
begin
 Values := rescat0_2_value.Text;
 ValidValues('ROOMS',Values,sql_ResCat0NAME,IDs);
 rescat0_2_value.Text := Values;
 rescat0_2.Text := IDs;
end;

procedure TFDetails.ValidF2Click(Sender: TObject);
Var Values, IDs : String;
begin
  inherited;
 Values := F_value2.Text;
 ValidValues('FORMS',Values,sql_FORNAME,IDs);
 F_value2.Text := Values;
 F2.Text := IDs;
end;

procedure TFDetails.SelectL2Click(Sender: TObject);
Var KeyValues : String;
    KeyValue  : string;
    t         : integer;
begin
  KeyValues := '';
  setResLimitation(g_lecturer);
  If LECTURERSShowModalAsMultiSelect(KeyValues,'','0=0','') = mrOK Then Begin
   for t := 1 to wordCount(KeyValues, [',']) do begin
     KeyValue := extractWord(t,KeyValues, [',']);
     If ExistsValue(L2.Text, [';'], KeyValue)
      Then Info('Nie mo¿na wybraæ ponownie tego samego : '+fprogramsettings.profileObjectNameL.Text)
      Else L2.Text := Merge(L2.Text, KeyValue, ';');
   end;
  End;
end;

procedure TFDetails.SelectG2Click(Sender: TObject);
Var KeyValues : String;
    KeyValue  : string;
    t         : integer;
begin
  KeyValue := '';
  setResLimitation(g_group);
  If GROUPSShowModalAsMultiselect(KeyValues,'','0=0','') = mrOK Then Begin
   for t := 1 to wordCount(KeyValues, [',']) do begin
     KeyValue := extractWord(t,KeyValues, [',']);
     If ExistsValue(G2.Text, [';'], KeyValue)
      Then Info('Nie mo¿na wybraæ ponownie tego samego : '+fprogramsettings.profileObjectNameG.Text)
      Else G2.Text := Merge(G2.Text, KeyValue, ';');
   end;
  End;
end;

procedure TFDetails.sr2Click(Sender: TObject);
Var KeyValues : String;
    KeyValue  : string;
    t         : integer;
begin
  KeyValue := '';
  setResLimitation( strToInt(dmodule.pResCatId0) );
  If ROOMSShowModalAsMultiselect(dmodule.pResCatId0,'',KeyValues,'0=0','') = mrOK Then  Begin
   for t := 1 to wordCount(KeyValues, [',']) do begin
     KeyValue := extractWord(t,KeyValues, [',']);
     If ExistsValue(rescat0_2.Text, [';'], KeyValue)
      Then Info('Nie mo¿na wybraæ ponownie tego samego zasobu')
      Else rescat0_2.Text := Merge(rescat0_2.Text, KeyValue, ';');
   end;
  End;
end;

procedure TFDetails.rgReservationForClick(Sender: TObject);
begin
  inherited;
  LL2.Visible      := rgReservationFor.ItemIndex  = 0;
  L_value2.Visible := rgReservationFor.ItemIndex  = 0;
  SelectL2.Visible  := rgReservationFor.ItemIndex  = 0;
  ValidL2.Visible  := rgReservationFor.ItemIndex  = 0;

  LG2.Visible      := rgReservationFor.ItemIndex  = 1;
  G_value2.Visible := rgReservationFor.ItemIndex  = 1;
  SelectG2.Visible := rgReservationFor.ItemIndex  = 1;
  ValidG2.Visible  := rgReservationFor.ItemIndex  = 1;

  LRescat0_2.Visible      := rgReservationFor.ItemIndex  = 2;
  rescat0_2_value.Visible := rgReservationFor.ItemIndex  = 2;
  SR2.Visible             := rgReservationFor.ItemIndex  = 2;
  ValidR2.Visible         := rgReservationFor.ItemIndex  = 2;

  LRescat1_2.Visible      := rgReservationFor.ItemIndex  = 3;
  rescat1_2_value.Visible := rgReservationFor.ItemIndex  = 3;
  selectResCat1_2.Visible := rgReservationFor.ItemIndex  = 3;
  validResCat1_2.Visible  := rgReservationFor.ItemIndex  = 3;
end;

procedure TFDetails.SelectOwnerClick(Sender: TObject);
Var KeyValue : ShortString;
begin
  KeyValue := '';
  setResLimitation(g_planner);
  If PLANNERSShowModalAsSelect(KeyValue) = mrOK Then Begin
    Owner_.Text := DModule.SingleValue('SELECT NAME FROM PLANNERS WHERE ID='+KeyValue);
  End;
end;

procedure TFDetails.L_value1Exit(Sender: TObject);
begin
  ValidLClick(nil);
end;

procedure TFDetails.G_value1Exit(Sender: TObject);
begin
    ValidGClick(nil);
end;

procedure TFDetails.rescat0_1_valueExit(Sender: TObject);
begin
  ValidRClick(nil);
end;

procedure TFDetails.PLECClick(Sender: TObject);
var point : tpoint;
begin
 Point.x:= 0;
 Point.y:= (sender as tspeedbutton).Height;
 Point:=(sender as tspeedbutton).ClientToScreen(Point);
 if (sender as tspeedbutton).Name = 'PLEC' then BAddLec.Popup( Point.X, Point.Y );
 if (sender as tspeedbutton).Name = 'PGRO' then BAddGro.Popup( Point.X, Point.Y );
 if (sender as tspeedbutton).Name = 'PRESCAT0_1' then BAddRes.Popup( Point.X, Point.Y );
 if (sender as tspeedbutton).Name = 'PRESCAT1_1' then BAddResCat1.Popup( Point.X, Point.Y );
end;

procedure TFDetails.SelectL1Click(Sender: TObject);
begin
 ValidLClick(nil);
 selectLECAvail('100');
end;

procedure TFDetails.SelectG1Click(Sender: TObject);
begin
 ValidGClick(nil);
 selectGROAvail('100');
end;

procedure TFDetails.selectResCat0_1Click(Sender: TObject);
begin
 ValidRClick(nil);
 selectResCat0Avail('100');
end;

procedure TFDetails.SelectLFClick(Sender: TObject);
begin
 ValidLClick(nil);
 selectLECAvail('100');
end;

procedure TFDetails.selectGFClick(Sender: TObject);
begin
 ValidGClick(nil);
 selectGROAvail('100');
end;

procedure TFDetails.SelectRFClick(Sender: TObject);
begin
 ValidRClick(nil);
 selectResCat0Avail('100');
end;

procedure TFDetails.Dodajwykadowc1Click(Sender: TObject);
begin
 ValidLClick(nil);
 selectLEC;
end;

procedure TFDetails.MenuItem2Click(Sender: TObject);
begin
 ValidGClick(nil);
 selectGRO;
end;

procedure TFDetails.MenuItem4Click(Sender: TObject);
begin
 ValidRClick(nil);
 selectRES;
end;


procedure TFDetails.Dodajwykadowcsporddostpnychktrykolwiektermin1Click(
  Sender: TObject);
begin
 ValidLClick(nil);
 selectLECAvail('1');
end;

procedure TFDetails.Dodajgrupsporddostpnychktrykolwiektermin1Click(
  Sender: TObject);
begin
 ValidGClick(nil);
 selectGROAvail('1');
end;

procedure TFDetails.Dodajzasbsporddostpnychktrykolwiektermin1Click(
  Sender: TObject);
begin
 ValidRClick(nil);
 selectResCat0Avail('1');
end;

procedure TFDetails.colour1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
 ColorDialog.Color  := colour1.Brush.Color;
 If ColorDialog.Execute Then
  Begin
   colour1.Brush.Color  := ColorDialog.Color;
   colour2.Brush.Color  := ColorDialog.Color;
  End;
end;

procedure TFDetails.bcolpopup1Click(Sender: TObject);
var point : tpoint;
    btn   : tcontrol;
begin
 btn := sender as tcontrol;
 Point.x:= 0;
 Point.y:= btn.Height;
 Point:=btn.ClientToScreen(Point);
 if btn.Name = 'bcolpopup1'      then colourPopup.Popup(Point.X,Point.Y);
 if btn.Name = 'bcolpopup2'      then colourPopup.Popup(Point.X,Point.Y);
end;

procedure TFDetails.Zielony1Click(Sender: TObject);
begin
  colour1.Brush.Color  := clGreen;
  colour2.Brush.Color  := clGreen;
end;

procedure TFDetails.N1Click(Sender: TObject);
begin
  colour1.Brush.Color  := clYellow;
  colour2.Brush.Color  := clYellow;
end;

procedure TFDetails.Czerwony1Click(Sender: TObject);
begin
  colour1.Brush.Color  := clRed;
  colour2.Brush.Color  := clRed;
end;

procedure TFDetails.Wicejkolorw1Click(Sender: TObject);
begin
  colour1MouseUp(nil, mbLeft,[],0,0);
end;

procedure TFDetails.rescat1_1Change(Sender: TObject);
begin
  If Not CanRefresh Then Exit;
  FChange(rescat1_1, rescat1_1_value, dm.sql_ResCat1DESC );
end;

procedure TFDetails.rescat1_1_valueExit(Sender: TObject);
begin
  ValidResCat1_1Click(nil);
end;

procedure TFDetails.selectResCat1_1Click(Sender: TObject);
begin
 ValidRescat1_1Click(nil);
 selectResCat1Avail('100');
end;


procedure TFDetails.MenuItem1Click(Sender: TObject);
begin
 ValidResCat1_1Click(nil);
 selectResCat1Avail('100');
end;

procedure TFDetails.MenuItem3Click(Sender: TObject);
begin
 ValidResCat1_1Click(nil);
 selectResCat1Avail('1');
end;

procedure TFDetails.MenuItem5Click(Sender: TObject);
begin
 ValidResCat1_1Click(nil);
 selectResCat1;
end;

procedure TFDetails.rescat1_2Change(Sender: TObject);
begin
  If Not CanRefresh Then Exit;
  FChange(rescat1_2, rescat1_2_value, dm.sql_ResCat1DESC );
end;

procedure TFDetails.selectResCat1_2Click(Sender: TObject);
Var KeyValue  : shortstring;
begin
  KeyValue := '';
  setResLimitation( strToInt(dmodule.pResCatId1) );
  If ROOMSShowModalAsSelect(dmodule.pResCatId1,'',KeyValue,'0=0','') = mrOK Then  Begin
   If ExistsValue(rescat1_2.Text, [';'], KeyValue)
    Then Info('Nie mo¿na wybraæ ponownie tego samego zasobu')
    Else rescat1_2.Text := Merge(rescat1_2.Text, KeyValue, ';');
  End;
end;

procedure TFDetails.validResCat1_2Click(Sender: TObject);
Var Values, IDs : String;
begin
 Values := rescat1_2_value.text;
 ValidValues('ROOMS',Values,sql_ResCat1NAME,IDs);
 rescat1_2_value.Text := Values;
 rescat1_2.Text      := IDs;
end;

procedure TFDetails.setResLimitation(p_rescat_id: integer);
  function getResIds: string;
  begin
    result    := '';
    result := merge( result , iif(notL.Checked,        '', L1.Text)    , ',');
    result := merge( result , iif(notG.Checked,        '', G1.Text    ), ',');
    result := merge( result , iif(notResCat0_1.Checked, '', rescat0_1.Text), ',');
    result := merge( result , iif(notResCat1_1.checked, '', rescat1_1.Text), ',');
    result := merge( result , iif(false,                '', iif(S1.Text='0','',S1.Text)    ), ',');
    result := merge( result , iif(false,                '', F1.Text    ), ',');
    result := merge( result , iif(false,                '', fmain.conperiod.Text    ), ',');
    result := merge( result , iif(false,                '', fmain.getUserOrRoleID  ), ',');
    result := replace(result,';',',');
  end;
begin
  if wordCount(getResIds,[','])>=16 then
    info('Ze wzglêdu na liczbê wybranych zasobów (>=16), sprawdzenie dostêpnych kombinacji zasobów nie zostanie zostanie przeprowadzone, gdy¿ zajê³oby to zbyt wiele czasu' , showOnceaday)
  else
    dmodule.sql('begin tt_planner.set_res_limitation (:p_pla_id, :p_res_ids, :p_rescat_id ); end;'
               ,'p_pla_id='+fmain.getUserOrRoleId+';p_res_ids='+getResIds+';p_rescat_id='+intToStr(p_rescat_id)
    );
end;

procedure TFDetails.BSelectCombClick(Sender: TObject);
Var KeyValue  : ShortString;
    rescat_id : Integer;
    res_id    : String;
    //
    bf1             : boolean;
    bs1             : boolean;
    bl1             : boolean;
    bg1             : boolean;
    brescat0_1      : boolean;
    brescat1_1      : boolean;

begin
  KeyValue := '';
  If TT_COMBINATIONSShowModalAsSelect(KeyValue) = mrOK Then
   with dmodule do begin
     canRefresh := false;
     opensql(
      'select id, res_id, tt_planner.get_rescat_id(res_id) rescat_id from tt_resource_lists where tt_comb_id = '+ KeyValue +cr+
      'order by 1');
     qwork.First;

     bf1            := true;
     bs1            := true;
     bl1            := true;
     bg1            := true;
     brescat0_1     := true;
     brescat1_1     := true;

     while not qwork.Eof do begin
       rescat_id := qwork.fieldbyname('rescat_id').AsInteger;
       res_id    := qwork.fieldbyname('res_id').AsString;

       case rescat_id of
         g_form      : begin if bf1        then begin f1.Text        := ''; bf1        := false; end; f1.Text := merge(f1.Text, res_id, ';'); end;
         g_subject   : begin if bs1        then begin s1.Text        := ''; bs1        := false; end; s1.Text := merge(s1.Text, res_id, ';'); end;
         g_lecturer  : begin if bl1        then begin l1.Text        := ''; bl1        := false; end; l1.Text := merge(l1.Text, res_id, ';'); end;
         g_group     : begin if bg1        then begin g1.Text        := ''; bg1        := false; end; g1.Text := merge(g1.Text, res_id, ';'); end;
         //not valid in this context
         //g_planner   : conpla.Text := merge(conpla.Text, res_id, ';');
         //g_period    : conper.Text := merge(conper.Text, res_id, ';');
         //g_date_hour : forAll.Checked := true
         else
           if rescat_id = strToInt(dmodule.pResCatId0) then begin if brescat0_1 then begin rescat0_1.Text := ''; brescat0_1 := false; end; rescat0_1.Text := merge(rescat0_1.Text, res_id, ';') end else
           if rescat_id = strToInt(dmodule.pResCatId1) then begin if brescat1_1 then begin rescat1_1.Text := ''; brescat1_1 := false; end; rescat1_1.Text := merge(rescat1_1.Text, res_id, ';'); end;
       end;
       qwork.Next;
     end;

     if l1.Text        <> '' then notL.checked         := false;
     if g1.Text        <> '' then notG.checked         := false;
     if rescat0_1.Text <> '' then NotResCat0_1.checked := false;
     if rescat1_1.Text <> '' then notResCat1_1.checked  := false;

     canRefresh := true;
     L1Change(nil);
     G1Change(nil);
     rescat0_1Change(nil);
     rescat1_1Change(nil);
     S1Change(nil);
     F1Change(nil);
   end;
end;


procedure TFDetails.L_value2Exit(Sender: TObject);
begin
  ValidL2Click(nil);
end;

procedure TFDetails.G_value2Exit(Sender: TObject);
begin
    ValidG2Click(nil);
end;

procedure TFDetails.rescat0_2_valueExit(Sender: TObject);
begin
  ValidR2Click(nil);
end;

procedure TFDetails.rescat1_2_valueExit(Sender: TObject);
begin
  ValidResCat1_2Click(nil);
end;

procedure TFDetails.bdesc1Click(Sender: TObject);
Var KeyValue : ShortString;
    stringTokenizer : TStringTokenizer;
begin
  KeyValue := '';
  If FIN_LOOKUP_VALUESShowModalAsMultiselectExt(ldesc1.Caption,KeyValue) = mrOK Then begin
    stringTokenizer := TStringTokenizer.Create;
    with stringTokenizer do begin
      init(desc1.Text);
      addToken(KeyValue,false,false);
      desc1.Text := get;
      close;
    end;
    stringTokenizer.Free;
  end;
end;

procedure TFDetails.bdesc2Click(Sender: TObject);
Var KeyValue : ShortString;
    stringTokenizer : TStringTokenizer;
begin
  KeyValue := '';
  If FIN_LOOKUP_VALUESShowModalAsMultiselectExt(ldesc2.Caption,KeyValue) = mrOK Then begin
    stringTokenizer := TStringTokenizer.Create;
    with stringTokenizer do begin
      init(desc2.Text);
      addToken(KeyValue,false,false);
      desc2.Text := get;
      close;
    end;
    stringTokenizer.Free;
  end;
end;

procedure TFDetails.bdesc3Click(Sender: TObject);
Var KeyValue : ShortString;
    stringTokenizer : TStringTokenizer;
begin
  KeyValue := '';
  If FIN_LOOKUP_VALUESShowModalAsMultiselectExt(ldesc3.Caption,KeyValue) = mrOK Then begin
    stringTokenizer := TStringTokenizer.Create;
    with stringTokenizer do begin
      init(desc3.Text);
      addToken(KeyValue,false,false);
      desc3.Text := get;
      close;
    end;
    stringTokenizer.Free;
  end;
end;

procedure TFDetails.bdesc4Click(Sender: TObject);
Var KeyValue : ShortString;
    stringTokenizer : TStringTokenizer;
begin
  KeyValue := '';
  If FIN_LOOKUP_VALUESShowModalAsMultiselectExt(ldesc4.Caption,KeyValue) = mrOK Then begin
    stringTokenizer := TStringTokenizer.Create;
    with stringTokenizer do begin
      init(desc4.Text);
      addToken(KeyValue,false,false);
      desc4.Text := get;
      close;
    end;
    stringTokenizer.Free;
  end;  
end;

procedure TFDetails.S_value1Click(Sender: TObject);
begin
  SelectS1Click(nil);
end;

procedure TFDetails.F_value1Click(Sender: TObject);
begin
  SelectF1Click(nil);
end;

procedure TFDetails.F_value2Click(Sender: TObject);
begin
  selectF2Click(nil);

end;

procedure TFDetails.CWeeksChange(Sender: TObject);
  var stringTokenizer : TStringTokenizer;
  procedure copyValue(settingId : integer; var field : TEdit);
  begin
    //1=Calendar
    if settingId=1 then
    with stringTokenizer do begin
      init(field.text);
      deleteToken(oldCalName);
      addToken(CALID_VALUE.Text,true,true);
      field.text := get;
      close;
    end;
  end;
  //--------------------------------------------
begin
  if extractWord(1,CPattern.Text,[' '])='1' then
    CCounter.ItemIndex := 0;

  stringTokenizer := TStringTokenizer.Create;
  copyValue(Fprogramsettings.CopyField1.itemindex, desc1);
  copyValue(Fprogramsettings.CopyField2.itemindex, desc2);
  copyValue(Fprogramsettings.CopyField3.itemindex, desc3);
  copyValue(Fprogramsettings.CopyField4.itemindex, desc4);
  stringTokenizer.free;

end;

procedure TFDetails.CPatternClick(Sender: TObject);
var point : tpoint;
    btn   : tcontrol;
begin
  btn     := sender as tedit;
  Point.x := 0;
  Point.y := btn.Height;
  Point   := btn.ClientToScreen(Point);
  FPattern.Left := Point.X;
  FPattern.Top := Point.Y;
  FPattern.showModal;
  if FPattern.modalResult = 1 then
   CPattern.Text := FPattern.CustomText.Text;

  if CPattern.Text='1' then CPattern.Text := '1 Wszystkie tygodnie';
  if CPattern.Text='01' then CPattern.Text := '01 Parzyste tygodnie';
  if CPattern.Text='10' then CPattern.Text := '10 Nieparzyste tygodnie';
  if CPattern.Text='100' then CPattern.Text := '100 Co trzeci tydzieñ';
  if CPattern.Text='110' then CPattern.Text := '110 Cyklicznie';
  if CPattern.Text='011' then CPattern.Text := '001 Cyklicznie';
end;

procedure TFDetails.CALIDChange(Sender: TObject);
begin
  DModule.RefreshLookupEdit(Self, TControl(Sender).Name,'NAME','ROOMS','');
  BClearCal.Visible := not strIsEmpty(TEdit(Sender).Text);
  CWeeksChange(nil);
end;

procedure TFDetails.CALID_VALUEClick(Sender: TObject);
Var KeyValue : ShortString;
begin
  KeyValue := CALID.Text;
  If AutoCreate.ROOMSShowModalAsSelect('-9','',KeyValue,'0=0','') = mrOK Then begin
      oldCalName := CALID_VALUE.Text;
      CALID.Text := KeyValue;
  end;
end;

procedure TFDetails.BClearCalClick(Sender: TObject);
begin
 CALID.Text := '-1';
 TEdit(Sender).hide;
end;

procedure TFDetails.formChange;
  var stringTokenizer : TStringTokenizer;
      fromValue : string;
  procedure copyValue(settingId : integer; var toField : TEdit);
  begin
    //3=Form
    if settingId=3 then begin
      //Edit mode. Do not populate field on event formShow
      if (toField.Text<>'') and (eventName='formShow') then exit;
      with stringTokenizer do begin
        init(toField.text);
        //deleteToken(oldCalName);
        addToken(fromValue,false,true);
        toField.text := get;
        close;
      end;
    end;
  end;
  //--------------------------------------------
begin
  if PC.ActivePage = TSClasses Then fromValue := F_value1.Text;
  if PC.ActivePage = TSReservation Then fromValue := F_value2.Text;
  if fromValue='' then exit;
  stringTokenizer := TStringTokenizer.Create;
  copyValue(Fprogramsettings.CopyField1.itemindex, desc1);
  copyValue(Fprogramsettings.CopyField2.itemindex, desc2);
  copyValue(Fprogramsettings.CopyField3.itemindex, desc3);
  copyValue(Fprogramsettings.CopyField4.itemindex, desc4);
  stringTokenizer.free;
end;

procedure TFDetails.subjectChange;
  var stringTokenizer : TStringTokenizer;
  procedure copyValue(settingId : integer; var toField : TEdit);
  begin
    //2=Subject
    if settingId=2 then begin
      //Edit mode. Do not populate field on event formShow
      if (toField.Text<>'') and (eventName='formShow') then exit;
      with stringTokenizer do begin
        init(toField.text);
        //deleteToken(oldCalName);
        addToken(S_value1.Text,false,true);
        toField.text := get;
        close;
      end;
    end;
  end;
  //--------------------------------------------
begin
  if PC.ActivePage <> TSClasses Then exit;
  if s_value1.Text='' then exit;
  stringTokenizer := TStringTokenizer.Create;
  copyValue(Fprogramsettings.CopyField1.itemindex, desc1);
  copyValue(Fprogramsettings.CopyField2.itemindex, desc2);
  copyValue(Fprogramsettings.CopyField3.itemindex, desc3);
  copyValue(Fprogramsettings.CopyField4.itemindex, desc4);
  stringTokenizer.free;

end;


end.
