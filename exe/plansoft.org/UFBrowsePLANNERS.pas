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
    LabelID: TLabel;
    NAME: TDBEdit;
    LabelNAME: TLabel;
    BCheckDatabase: TBitBtn;
    PLANNERTYPE: TDBRadioGroup;
    LabelCOLOUR: TLabel;
    Shape1: TShape;
    ColorDialog: TColorDialog;
    ttEnabled: TCheckBox;
    DBCheckBox1: TDBCheckBox;
    BPlannerPermissions: TBitBtn;
    chbIsAdmin: TDBCheckBox;
    chbCanEditOrgUnits: TDBCheckBox;
    chbCanEditAttribiutes: TDBCheckBox;
    DBCheckBox2: TDBCheckBox;
    DBCheckBox3: TDBCheckBox;
    LabelORGUNI_ID: TLabel;
    CAL_ID: TDBEdit;
    CAL_ID_VALUE: TEdit;
    BClearS: TSpeedButton;
    SpeedButton2: TSpeedButton;
    EDIT_RESERVATIONS: TDBCheckBox;
    edit_sharing: TDBCheckBox;
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
    procedure SpeedButton1Click(Sender: TObject);
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

Uses UUtilityParent, DM, UFProgramSettings, AutoCreate, UFPlannerPermissions;

function TFBrowsePLANNERS.CanDelete: Boolean;
begin
  if Query.fieldByName('name').AsString = user then begin
    info('Nie mo¿na usun¹æ konta zalogowanego u¿ytkownika');
  end
  else
  if Query.fieldByName('name').AsString = 'PLANNER' then begin
    info('Nie mo¿na usun¹æ konta u¿ytkownika o nazwie planner');
  end;

  Result := IsAdmin and (Query.fieldByName('name').AsString <> user) and (Query.fieldByName('name').AsString <> 'PLANNER');
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
Begin
  Result := CheckValid.ReducRestrictEmpty(Self, [NAME]);

End;

Procedure TFBrowsePLANNERS.DefaultValues;
Var c : Integer;
Begin
 Query['ID']   := DModule.SingleValue('select main_seq.nextval from dual');
 Query['TYPE'] := 'USER';
 c := Random(256) + 256*Random(256) + 256*256*Random(256);
 QUERY['COLOUR'] := c;
 Shape1.Brush.Color := c;
 Query['ACTIVE_FLAG'] := '+';
 QUERY['IS_ADMIN'] := '+';
 QUERY['EDIT_ORG_UNITS'] := '+';
 QUERY['EDIT_FLEX'] := '+';
 QUERY['LOG_CHANGES'] := '-';
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

  // niepotrzebne a nawet szkodliwe, poniewaz moze byc wiele schematow w bazie danych, nie tylko PLANNER
  // sprawdzenie czy sa inni userzy z rola. -> ew. usuniêcie im ról
  //DModule.OPENSQL('SELECT * FROM  SYS.ALL_USERS WHERE USERNAME<>''PLANNER'' AND USERNAME NOT IN (SELECT NAME FROM PLANNERS WHERE TYPE =''USER'' AND USERNAME = NAME) AND EXISTS (select * from SYS.DBA_ROLE_PRIVS WHERE GRANTEE=USERNAME AND GRANTED_ROLE=''PLA_PERMISSION'')');
  //QWork.First;
  //While Not QWork.Eof Do Begin
  //  //Info('U¿ytkownik '+QWork.FieldByName('USERNAME').AsString+' nie jest zarejestrowany w programie jako planista. U¿ytkownikowi zostan¹ zabrane uprawnienia');
  //  SQL2('REVOKE PLA_PERMISSION FROM "'+QWork.FieldByName('USERNAME').AsString+'"');
  //  Info('Sukces');
  //  QWork.Next;
  //End;

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

procedure TFBrowsePLANNERS.SpeedButton1Click(Sender: TObject);
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

end.
