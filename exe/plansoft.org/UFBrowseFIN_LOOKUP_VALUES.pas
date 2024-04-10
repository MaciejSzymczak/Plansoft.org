unit UFBrowseFIN_LOOKUP_VALUES;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFBrowseParent, DB, ADODB, ImgList, ExtCtrls, StrHlder, Menus,
  ToolEdit, RXDBCtrl, Mask, DBCtrls, StdCtrls, ComCtrls, Grids, DBGrids,
  Buttons, OleServer, ExcelXP;

type
  TFBrowseFIN_LOOKUP_VALUES = class(TFBrowseParent)
    _ID: TDBEdit;
    LabelID: TLabel;
    LOOKUP_TYPE: TDBEdit;
    LabelLOOKUP_TYPE: TLabel;
    DESCRIPTION: TDBEdit;
    LabelDESCRIPTION: TLabel;
    STR_KEY: TDBEdit;
    LabelSTR_KEY: TLabel;
    AUX_DESC1: TDBEdit;
    LabelAUX_DESC1: TLabel;
    AUX_DESC2: TDBEdit;
    LabelAUX_DESC2: TLabel;
    con_label: TLabel;
    CON_LOOKUP_TYPE: TEdit;
    con_clear: TBitBtn;
    procedure con_clearClick(Sender: TObject);
    procedure CON_LOOKUP_TYPEChange(Sender: TObject);
  private
    { Private declarations }
  public
    Function  CheckRecord : Boolean; override;
    Procedure DefaultValues; override;
    Procedure CustomConditions;      override;
    Function ShowModalAsMultiselectExt(Var aIDs : ShortString) : TModalResult;
    Function  getSearchFilter : string;  override;
    function  getFindCaption : string;   override;
  end;

var
  FBrowseFIN_LOOKUP_VALUES: TFBrowseFIN_LOOKUP_VALUES;

implementation

uses DM, UUtilityParent;

{$R *.dfm}

Function  TFBrowseFIN_LOOKUP_VALUES.CheckRecord : Boolean;
Begin
  Result := CheckValid.ReducRestrictEmpty(Self, [LOOKUP_TYPE, DESCRIPTION]);
End;

Procedure TFBrowseFIN_LOOKUP_VALUES.DefaultValues;
Begin
 Query['ID'] := DModule.SingleValue('select main_seq.nextval from dual');
 Query.FieldByName('LOOKUP_TYPE').AsString := CON_LOOKUP_TYPE.Text;
End;

Procedure TFBrowseFIN_LOOKUP_VALUES.CustomConditions;
Begin
 If CON_LOOKUP_TYPE.Text = ''
     Then DM.macros.setMacro(query, 'CON_LOOKUP_TYPE', '0=0')
     Else DM.macros.setMacro(query, 'CON_LOOKUP_TYPE', 'LOOKUP_TYPE LIKE '''+CON_LOOKUP_TYPE.Text+'%''');
End;

procedure TFBrowseFIN_LOOKUP_VALUES.con_clearClick(Sender: TObject);
begin
  CON_LOOKUP_TYPE.Text := '';
end;

procedure TFBrowseFIN_LOOKUP_VALUES.CON_LOOKUP_TYPEChange(Sender: TObject);
begin
  BRefreshClick(nil);
end;

Function TFBrowseFIN_LOOKUP_VALUES.ShowModalAsMultiselectExt(Var aIDs : ShortString) : TModalResult;
Var t : Integer;
Begin
 If Not DModule.ADOConnection.Connected Then Begin
  SError(Komunikaty.Strings[15]);
  result := mrCancel;
  Exit;
 End;

 If Not CanShow Then Begin
  Warning(Komunikaty.Strings[0]);
  result := mrCancel;
  Exit;
 End;

 If Visible Then Begin
  Info(Komunikaty.Strings[23]);
  Result := mrCancel;
  Exit;
 End;

 if flexEnabled then flexSynchronize;

 Browse.TabVisible   := True;
 Update.TabVisible   := Not Browse.TabVisible;
 MainPage.ActivePage := Browse;
 Browse.Caption      := Komunikaty.Strings[28];

 SingleMode := False;
 Mode := 1; //=select
 ID := '';
 BRefreshClick(nil);
 Grid.Options := Grid.Options + [dgMultiSelect];
 Grid.Options := Grid.Options + [dgIndicator];
 MR := mrCancel;
 ShowModal;

 if Grid.SelectedRows.Count = 0
  then aIDs := Query.FieldByName(Grid.Columns[findFirstVisibleColumn].FieldName).AsString;

 For t := 0 To Grid.SelectedRows.Count - 1 Do Begin
  Query.Bookmark := Grid.SelectedRows.Items[t];
  If aIDs <> '' Then aIDs :=  aIDs + ',';
  aIDs := aIDs + Query.FieldByName(Grid.Columns[findFirstVisibleColumn].FieldName).AsString;
 End;

 Grid.Options := Grid.Options - [dgMultiSelect];
 Grid.Options := Grid.Options - [dgIndicator];
 Result := MR;

 // to aviod "Nie mo¿na zmieniæ w³aœciwoœci ActiveConnection obiektu Recordset, którego Ÿród³em jest obiekt Command"
 // error occured during closing aplication
 Query.Close;
End;

function TFBrowseFIN_LOOKUP_VALUES.getFindCaption: string;
begin
 Result := 'Dowolna fraza';
end;

function TFBrowseFIN_LOOKUP_VALUES.getSearchFilter: string;
begin
 result := buildFilter(sql_LOOKUP_SEARCH, ESearch.Text);
end;

end.
