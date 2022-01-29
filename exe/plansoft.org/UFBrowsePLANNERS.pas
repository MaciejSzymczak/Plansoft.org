unit UFBrowsePLANNERS;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UFBrowseParent, Mask, DBCtrls, ExtCtrls, StrHlder, Menus, Db, DBTables,
  RxQuery, ComCtrls, Grids, DBGrids, RXDBCtrl, StdCtrls, Buttons, ToolEdit,
  ImgList, ADODB, OleServer, ExcelXP;

type
  TFBrowsePLANNERS = class(TFBrowseParent)
    ID_: TDBEdit;
    NAME: TDBEdit;
    LabelNAME: TLabel;
    PLANNERTYPE: TDBRadioGroup;
    LabelCOLOUR: TLabel;
    Shape1: TShape;
    ColorDialog: TColorDialog;
    ttEnabled: TCheckBox;
    DBCheckBox1: TDBCheckBox;
    BPlannerPermissions: TBitBtn;
    LabelORGUNI_ID: TLabel;
    CAL_ID: TDBEdit;
    CAL_ID_VALUE: TEdit;
    BClearS: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Label1: TLabel;
    PARENT: TDBEdit;
    SpeedButton4: TSpeedButton;
    LRec: TLabel;
    ROL_ID: TDBEdit;
    ROL_ID_VALUE: TEdit;
    BClearROL_ID: TSpeedButton;
    hrol: TSpeedButton;
    LLec: TLabel;
    LEC_ID: TDBEdit;
    LEC_ID_VALUE: TEdit;
    BClearLEC_ID: TSpeedButton;
    hlec: TSpeedButton;
    SystemPrivs: TGroupBox;
    DBCheckBox2: TDBCheckBox;
    DBCheckBox3: TDBCheckBox;
    first_Resource_Flag: TDBCheckBox;
    chbIsAdmin: TDBCheckBox;
    chbCanEditOrgUnits: TDBCheckBox;
    chbCanEditAttribiutes: TDBCheckBox;
    edit_sharing: TDBCheckBox;
    EDIT_RESERVATIONS: TDBCheckBox;
    DBCheckBox4: TDBCheckBox;
    DBCheckBox5: TDBCheckBox;
    DBCheckBox6: TDBCheckBox;
    DBCheckBox7: TDBCheckBox;
    DBCheckBox8: TDBCheckBox;
    DBCheckBox9: TDBCheckBox;
    DBCheckBox10: TDBCheckBox;
    DBCheckBox11: TDBCheckBox;
    DBCheckBox12: TDBCheckBox;
    SetPassword: TBitBtn;
    password_sha1: TDBEdit;
    SelectOwner: TBitBtn;
    procedure BCheckDatabaseClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Shape1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure GridDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure QueryBeforeEdit(DataSet: TDataSet);
    procedure ttEnabledClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BUpdChild1Click(Sender: TObject);
    procedure BUpdChild2Click(Sender: TObject);
    procedure BPlannerPermissionsClick(Sender: TObject);
    procedure CAL_IDChange(Sender: TObject);
    procedure CAL_ID_VALUEClick(Sender: TObject);
    procedure BClearSClick(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure ROL_IDChange(Sender: TObject);
    procedure ROL_ID_VALUEClick(Sender: TObject);
    procedure BClearROL_IDClick(Sender: TObject);
    procedure hrolClick(Sender: TObject);
    procedure LEC_IDChange(Sender: TObject);
    procedure LEC_ID_VALUEClick(Sender: TObject);
    procedure PLANNERTYPEChange(Sender: TObject);
    procedure BClearLEC_IDClick(Sender: TObject);
    procedure SetPasswordClick(Sender: TObject);
    procedure SelectOwnerClick(Sender: TObject);
  private
  public
    Function  CheckRecord : Boolean; override;
    Procedure DefaultValues; override;
    Procedure CustomConditions;    override;
    Procedure GetTableName;                        override;

   Function  CanEditIntegrity : Boolean; override;
   Function  CanEditPermission : Boolean; override;
   Function  CanInsert    : Boolean; override;
   Function  CanDelete    : Boolean; override;
  end;

var
  FBrowsePLANNERS: TFBrowsePLANNERS;

implementation

{$R *.DFM}

Uses UUtilityParent, DM, UFProgramSettings, AutoCreate, UFPlannerPermissions, UFLookupWindow,
  UFChangePassword, UFMain;

function TFBrowsePLANNERS.CanDelete: Boolean;
begin
  if Query.fieldByName('name').AsString = CurrentUserName then begin
    info('Nie mo¿na usun¹æ konta zalogowanego u¿ytkownika');
  end
  else
  if Query.fieldByName('name').AsString = 'PLANNER' then begin
    info('Nie mo¿na usun¹æ konta u¿ytkownika o nazwie planner');
  end;

  Result := IsAdmin and (Query.fieldByName('name').AsString <> CurrentUserName) and (Query.fieldByName('name').AsString <> 'PLANNER');
end;

function TFBrowsePLANNERS.CanEditIntegrity: Boolean;
begin
  Result := IsAdmin;
end;

function TFBrowsePLANNERS.CanEditPermission: Boolean;
begin
  Result := IsAdmin;
end;

function TFBrowsePLANNERS.CanInsert: Boolean;
begin
  Result := IsAdmin;
end;

Function  TFBrowsePLANNERS.CheckRecord : Boolean;
var WinControls : Array of TWinControl;
Begin

  if  (PLANNERTYPE.ItemIndex = 2) then begin
      //portal user
      SetLength(WinControls, 5);
      WinControls[0] := Name;
      WinControls[1] := password_sha1;
      WinControls[2] := ROL_ID;
      WinControls[3] := PARENT;
      WinControls[4] := CAL_ID;
  end
  else begin
      SetLength(WinControls, 1);
      WinControls[0] := Name;
  end;

  Result := CheckValid.ReducRestrictEmpty(Self, WinControls);

End;

Procedure TFBrowsePLANNERS.DefaultValues;
Var c : Integer;
Begin
 Query['ID']   := DModule.SingleValue('select main_seq.nextval from dual');
 Query['TYPE'] := 'USER';
 c := getRandomColor;
 QUERY['COLOUR'] := c;
 Shape1.Brush.Color := c;
 Query['ACTIVE_FLAG'] := '+';
 QUERY['IS_ADMIN'] := '+';
 QUERY['EDIT_ORG_UNITS'] := '+';
 QUERY['EDIT_FLEX'] := '+';
 QUERY['LOG_CHANGES'] := '-';
 QUERY['EDIT_RESERVATIONS'] := '-';
 QUERY['many_subjects_flag'] := '-';
 QUERY['edit_sharing'] := '-';
 QUERY['Can_Insert'] := '+';
 QUERY['Can_Delete'] := '+';
 QUERY['Can_Edit_L'] := '+';
 QUERY['Can_Edit_G'] := '+';
 QUERY['Can_Edit_R'] := '+';
 QUERY['Can_Edit_S'] := '+';
 QUERY['Can_Edit_F'] := '+';
 QUERY['Can_Edit_O'] := '+';
 QUERY['Can_Edit_D'] := '+';
 QUERY['first_Resource_Flag'] := '+';
End;

procedure TFBrowsePLANNERS.BCheckDatabaseClick(Sender: TObject);
Var C : Integer;
begin
  inherited;
  With DModule Do Begin
   DModule.OPENSQL('SELECT * FROM PLANNERS WHERE TYPE = ''USER'' ');
   QWork.First;
   While Not QWork.Eof Do Begin
     // sprawdzenie czy jest user --> ew. dodanie
     C := StrToInt(SingleValue2('SELECT COUNT(1) FROM SYS.ALL_USERS WHERE USERNAME = '''+QWork.FieldByName('NAME').AsString+''''));
     If C = 0 Then Begin
      Info('U¿ytkownik '+QWork.FieldByName('NAME').AsString+' nie istnieje. U¿ytkownik zostanie utworzony');
       SQL2('CREATE USER "'+QWork.FieldByName('NAME').AsString+'" IDENTIFIED BY "'+QWork.FieldByName('NAME').AsString+'"');
       SQL2('GRANT CONNECT TO "'+QWork.FieldByName('NAME').AsString+'" with admin option');
       SQL2('GRANT PLA_PERMISSION TO "'+QWork.FieldByName('NAME').AsString+'"');
       SQL2('ALTER USER "'+QWork.FieldByName('NAME').AsString+'" DEFAULT ROLE ALL EXCEPT PLA_PERMISSION');
       Info('Sukces');
     End Else Begin
       SingleValue2('select * from SYS.DBA_ROLE_PRIVS WHERE GRANTEE='''+QWork.FieldByName('NAME').AsString+''' AND GRANTED_ROLE=''PLA_PERMISSION''');
       C:= QWork2.RecordCount;
       If C = 0 Then Begin
         // sprawdzenie czy ma role -> ew. dodanie
         Info('U¿ytkownik '+QWork.FieldByName('NAME').AsString+' istnieje, ale nie ma przydzielonych uprawnieñ. Uprawnienia zostan¹ mu nadane');
         SQL2('GRANT PLA_PERMISSION TO "'+QWork.FieldByName('NAME').AsString+'"');
         SQL2('ALTER USER "'+QWork.FieldByName('NAME').AsString+'" DEFAULT ROLE ALL EXCEPT PLA_PERMISSION');
         Info('Sukces');
       End Else Begin
         // sprawdzenie czy rola zabezpieczona has³em -> ew. dodanie
         If QWork2.FieldByName('DEFAULT_ROLE').AsString = 'YES' Then Begin
           Info('U¿ytkownik '+QWork.FieldByName('NAME').AsString+' istnieje, ale ma uprawnienia nie chronione has³em. Uprawnienia zostan¹ zabezpieczone has³em');
           SQL2('ALTER USER "'+QWork.FieldByName('NAME').AsString+'" DEFAULT ROLE ALL EXCEPT PLA_PERMISSION');
           Info('Sukces');
         End;
       End;
     End;
    QWork.Next;
   End;
  End;

  // +podczepienie funkcji do add/delete/update user
  // +okno logowania
  // +uaktywanie roli
  // +spr. czy user ma role i w tabeli planners
end;

procedure TFBrowsePLANNERS.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  BCheckDatabaseClick(nil);
end;

procedure TFBrowsePLANNERS.Shape1MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
 ColorDialog.Color  := QUERY.FieldByName('COLOUR').AsInteger;
 If ColorDialog.Execute Then
  Begin
   QUERY.FieldByName('COLOUR').AsInteger  := ColorDialog.Color;
   Shape1.Brush.Color := QUERY.FieldByName('COLOUR').AsInteger;
  End;
end;

procedure TFBrowsePLANNERS.GridDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
  inherited;
 If Column.FieldName = 'COLOUR' Then
  Begin
   Grid.Canvas.Brush.Color := QUERY.FieldByName('COLOUR').AsInteger;
   Grid.Canvas.FillRect(Rect);
  End;
end;

procedure TFBrowsePLANNERS.QueryBeforeEdit(DataSet: TDataSet);
begin
  Shape1.Brush.Color    := QUERY.FieldByName('COLOUR').AsInteger;
end;

procedure TFBrowsePLANNERS.CustomConditions;
begin
 if ttEnabled.Checked then DM.macros.setMacro( Query, 'TTENABLED', '(PLANNERS.ID IN (SELECT  ID FROM TT_IDS WHERE TT_FOUND IS NOT NULL) OR (SELECT COUNT(1) FROM TT_IDS)=0)')
                      else DM.macros.setMacro( Query, 'TTENABLED', '0=0');
end;

procedure TFBrowsePLANNERS.ttEnabledClick(Sender: TObject);
begin
  BRefreshClick(nil);
end;

procedure TFBrowsePLANNERS.FormShow(Sender: TObject);
begin
  inherited;
  self.Caption := fprogramsettings.profileObjectNamePlanners.Text;
end;

procedure TFBrowsePLANNERS.BUpdChild1Click(Sender: TObject);
begin
  AutoCreate.FIN_PARTIESShowModalAsBrowser( 'PLANSOFT:' + Query.fieldByName('ID').AsString );
end;

procedure TFBrowsePLANNERS.BUpdChild2Click(Sender: TObject);
begin
  AutoCreate.CLASSESShowModalAsBrowser('CLASSES', '', '', '', '','','',Query['ID'],false);
end;

procedure TFBrowsePLANNERS.BPlannerPermissionsClick(Sender: TObject);
begin
  UFPlannerPermissions.ShowModal;
end;

procedure TFBrowsePLANNERS.CAL_IDChange(Sender: TObject);
begin
  DModule.RefreshLookupEdit(Self, TControl(Sender).Name,'NAME','ROOMS','');
end;

procedure TFBrowsePLANNERS.CAL_ID_VALUEClick(Sender: TObject);
Var KeyValue : ShortString;
begin
  KeyValue := CAL_ID.Text;
  If AutoCreate.ROOMSShowModalAsSelect('-9','',KeyValue,'0=0','') = mrOK Then CAL_ID.Text := KeyValue;
end;

procedure TFBrowsePLANNERS.BClearSClick(Sender: TObject);
begin
  CAL_ID.text := '';
end;

procedure TFBrowsePLANNERS.GetTableName;
begin
  Self.TableName := 'PLANNERS';
end;

procedure TFBrowsePLANNERS.SpeedButton4Click(Sender: TObject);
begin
 info('Cz³onek zespo³u mo¿e zmieniaæ Twoje zajêcia');
end;

procedure TFBrowsePLANNERS.SpeedButton2Click(Sender: TObject);
begin
 info(
'Mo¿esz ograniczyæ mo¿liwoœæ planowania tego planisty tylko do wybranych terminów. W tym celu wybierz kalendarz dni dostêpnych w tym polu'+cr+
'Wprowadzenie wartoœci w polu Planowanie ograniczone spowoduje, ¿e nastêpuj¹ce funkcje zostan¹ wy³¹czone:'+cr+
'- U¿ytkownik bêdzie móg³ planowaæ zajêcia tylko w okreœlonym oknie czasowym;'+cr+
'- Nie bêdzie móg³ edytowaæ kalendarzy szczególnych,'+cr+
'- Nie bêdzie móg³ dodawaæ/edytowaæ ani kasowaæ wyk³adowców,grupy, zasobów, przedmiotów ani form zajêæ;'+cr+
'  Nie bêdzie móg³ tak¿e importowaæ danych z programu Excel ani scalaæ rekordów;'+cr+
'- Nie bêdzie móg³ wprowadzaæ notatek do planu zajêæ;'+cr+
'- Nie bêdzie móg³ ustawiaæ preferencji poza okreœlonym oknem czasowym;'+cr+
'- Nie bêdzie móg³ u¿ywaæ funkcji kopiowania rozk³adów zajêæ.'
);
end;

procedure TFBrowsePLANNERS.ROL_IDChange(Sender: TObject);
begin
  DModule.RefreshLookupEdit(Self, TControl(Sender).Name,'NAME','PLANNERS','');
end;

procedure TFBrowsePLANNERS.ROL_ID_VALUEClick(Sender: TObject);
Var id : ShortString;
begin
  id := ROL_ID.Text;
  If LookupWindow(false, DModule.ADOConnection, 'PLANNERS','','NAME','NAZWA','NAME','(ID IN (SELECT ROL_ID FROM ROL_PLA WHERE PLA_ID = '+UserID+'))','',id) = mrOK Then
    Query.FieldByName('ROL_ID').AsString := id;
end;

procedure TFBrowsePLANNERS.BClearROL_IDClick(Sender: TObject);
begin
 Query.FieldByName('ROL_ID').Clear;
end;

procedure TFBrowsePLANNERS.hrolClick(Sender: TObject);
begin
 info('Je¿eli wybierzesz wyk³adowcê w tym polu, wówczas ograniczysz planowanie dla tego u¿ytkownika tylko do wybranego wyk³adowcy');
end;

procedure TFBrowsePLANNERS.LEC_IDChange(Sender: TObject);
begin
  DModule.RefreshLookupEdit(Self, TControl(Sender).Name,sql_LECNAME,'LECTURERS','');

end;

procedure TFBrowsePLANNERS.LEC_ID_VALUEClick(Sender: TObject);
Var KeyValue  : shortstring;
begin
  If LECTURERSShowModalAsSelect(KeyValue ,'','0=0','' ) = mrOK  Then
    Query.FieldByName('LEC_ID').AsString := KeyValue;
end;

procedure TFBrowsePLANNERS.PLANNERTYPEChange(Sender: TObject);
begin
  SystemPrivs.Visible := (PLANNERTYPE.ItemIndex = 0) or (PLANNERTYPE.ItemIndex = 1);
  LRec.Visible        :=  PLANNERTYPE.ItemIndex = 2;
  LLec.Visible        :=  PLANNERTYPE.ItemIndex = 2;
  ROL_ID_VALUE.Visible:=  PLANNERTYPE.ItemIndex = 2;
  LEC_ID_VALUE.Visible:=  PLANNERTYPE.ItemIndex = 2;
  BClearROL_ID.Visible:=  PLANNERTYPE.ItemIndex = 2;
  BClearLEC_ID.Visible:=  PLANNERTYPE.ItemIndex = 2;
  hrol.Visible        :=  PLANNERTYPE.ItemIndex = 2;
  hlec.Visible        :=  PLANNERTYPE.ItemIndex = 2;
  SetPassword.visible :=  PLANNERTYPE.ItemIndex = 2;
end;

procedure TFBrowsePLANNERS.BClearLEC_IDClick(Sender: TObject);
begin
 Query.FieldByName('LEC_ID').Clear;
end;

procedure TFBrowsePLANNERS.SetPasswordClick(Sender: TObject);
begin
   Application.CreateForm(TFChangePassword, FChangePassword);
   if fchangepassword.showmodal = mrOK then begin
     password_sha1.Text := dmodule.SingleValue('select getSHA1('''+fchangepassword.ENewPassword.Text+''') from dual');
     info ('Has³o zosta³o poprawnie zmienione');
   end;
   fchangepassword.Free;
   fchangepassword := nil;
end;

procedure TFBrowsePLANNERS.SelectOwnerClick(Sender: TObject);
Var KeyValue : ShortString;
begin
  KeyValue := '';

  If LookupWindow(false, DModule.ADOConnection, 'PLANNERS','Id','NAME','Nazwa','NAME','0=0','',KeyValue) = mrOK Then Begin
    KeyValue := DModule.SingleValue('SELECT NAME FROM PLANNERS WHERE ID='+KeyValue);
    if ExistsValue(PARENT.Text, [';'], KeyValue)
      then //
      else PARENT.Text := Merge(PARENT.Text, KeyValue, ';');
  End;
end;

end.


