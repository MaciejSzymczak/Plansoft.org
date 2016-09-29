unit UFBrowseRESERVATIONS_KINDS;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UFBrowseParent, ExtCtrls, StrHlder, Menus, Db, DBTables, RxQuery,
  ComCtrls, Grids, DBGrids, RXDBCtrl, StdCtrls, Buttons, DBCtrls, Mask,
  ToolEdit, ImgList, ADODB, OleServer, ExcelXP;

type
  TFBrowseRESERVATIONS_KINDS = class(TFBrowseParent)
    ID: TDBEdit;
    LabelID: TLabel;
    NAME: TDBEdit;
    LabelNAME: TLabel;
    ABBREVIATION: TDBEdit;
    LabelABBREVIATION: TLabel;
    FOR_LECTURER_ENABLED: TDBCheckBox;
    FOR_GROUP_ENABLED: TDBCheckBox;
    FOR_ROOM_ENABLED: TDBCheckBox;
  private
    { Private declarations }
  public
    Function  CheckRecord : Boolean; override;
    Procedure DefaultValues; override;
  end;

var
  FBrowseRESERVATIONS_KINDS: TFBrowseRESERVATIONS_KINDS;

implementation

{$R *.DFM}

uses DM, UUtilityParent;

Function  TFBrowseRESERVATIONS_KINDS.CheckRecord : Boolean;
Begin
  Result := CheckValid.ReducRestrictEmpty(Self, [NAME, ABBREVIATION]);
End;

Procedure TFBrowseRESERVATIONS_KINDS.DefaultValues;
Begin
 Query['ID'] := DModule.SingleValue('SELECT RESKND_SEQ.NEXTVAL FROM DUAL');
End;

end.
