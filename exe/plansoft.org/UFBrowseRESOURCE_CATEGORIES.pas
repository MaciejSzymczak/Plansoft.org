unit UFBrowseRESOURCE_CATEGORIES;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFBrowseParent, ExtCtrls, StrHlder, Menus, DB, DBTables,
  RxQuery, ComCtrls, Grids, DBGrids, RXDBCtrl, StdCtrls, Buttons, Mask,
  DBCtrls, ToolEdit, ImgList, ADODB, OleServer, ExcelXP;

type
  TFBrowseRESOURCE_CATEGORIES = class(TFBrowseParent)
    ID_: TDBEdit;
    LabelID: TLabel;
    NAME: TDBEdit;
    LabelNAME: TLabel;
    DESC1: TDBEdit;
    LabelDESC1: TLabel;
    DESC2: TDBEdit;
    LabelDESC2: TLabel;
    DESC3: TDBEdit;
    LabelDESC3: TLabel;
    DESC4: TDBEdit;
    LabelDESC4: TLabel;
    DESC5: TDBEdit;
    LabelDESC5: TLabel;
    DESC6: TDBEdit;
    LabelDESC6: TLabel;
    DESC7: TDBEdit;
    LabelDESC7: TLabel;
    DESC8: TDBEdit;
    LabelDESC8: TLabel;
    DESC9: TDBEdit;
    LabelDESC9: TLabel;
    DESC10: TDBEdit;
    LabelDESC10: TLabel;
    procedure BPodrzedne1Click(Sender: TObject);
  private
    { Private declarations }
  public
    Function  CheckRecord : Boolean;         override;
    Procedure DefaultValues;                 override;
    Function  CanEditPermission : Boolean;   override;
    Function  CanInsert    : Boolean;        override;
    Function  CanDelete    : Boolean;        override;
  end;

var
  FBrowseRESOURCE_CATEGORIES: TFBrowseRESOURCE_CATEGORIES;

implementation

{$R *.dfm}

uses autoCreate, DM, UUtilityParent;

procedure TFBrowseRESOURCE_CATEGORIES.BPodrzedne1Click(Sender: TObject);
begin
  inherited;
  AutoCreate.ROOMSShowModalAsBrowser(Query['ID'],'');
end;

Function  TFBrowseRESOURCE_CATEGORIES.CheckRecord : Boolean;
Begin
  Result := CheckValid.ReducRestrictEmpty(Self, [NAME]);
End;

Procedure TFBrowseRESOURCE_CATEGORIES.DefaultValues;
Begin
 Query['ID'] := DModule.SingleValue('SELECT RESCAT_SEQ.NEXTVAL FROM DUAL');
End;

Function  TFBrowseRESOURCE_CATEGORIES.CanEditPermission : Boolean;
begin
 result := true;
 If not isAdmin Then Begin
  Info('Ta funkcja mo¿e byæ uruchamiana tylko przez u¿ytkownika o uprawnieniach administratora');
  result := false;
 End;
end;

Function  TFBrowseRESOURCE_CATEGORIES.CanInsert    : Boolean;
begin
 result := true;
 If not isAdmin Then Begin
  Info('Ta funkcja mo¿e byæ uruchamiana tylko przez u¿ytkownika o uprawnieniach administratora');
  result := false;
 End;
end;

Function  TFBrowseRESOURCE_CATEGORIES.CanDelete    : Boolean;
begin
 result := true;
 If strtoint(ID) < 0 then begin
  Info('Nie mo¿na tej kategorii zasobów. Jest to systemowa kategoria zasobów, która nie mo¿e zostaæ skasowana');
  result := false;
  exit;
 end;
 If not isAdmin Then Begin
  Info('Ta funkcja mo¿e byæ uruchamiana tylko przez u¿ytkownika o uprawnieniach administratora');
  result := false;
 End;
end;

end.
