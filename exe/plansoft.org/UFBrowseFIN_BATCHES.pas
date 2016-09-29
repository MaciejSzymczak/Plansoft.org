unit UFBrowseFIN_BATCHES;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFBrowseParent, DB, ADODB, ImgList, ExtCtrls, StrHlder, Menus,
  ToolEdit, RXDBCtrl, Mask, DBCtrls, StdCtrls, ComCtrls, Grids, DBGrids,
  Buttons, OleServer, ExcelXP;

type
  TFBrowseFIN_BATCHES = class(TFBrowseParent)
    DESCRIPTION: TDBEdit;
    LabelDESCRIPTION: TLabel;
    STR_KEY: TDBEdit;
    LabelSTR_KEY: TLabel;
    FEEDER_SYSTEM_REF: TDBEdit;
    LabelFEEDER_SYSTEM_REF: TLabel;
    AUX_DESC1: TDBEdit;
    LabelAUX_DESC1: TLabel;
    AUX_DESC2: TDBEdit;
    LabelAUX_DESC2: TLabel;
    ID: TDBEdit;
    LabelID: TLabel;
    procedure BUpdChild1Click(Sender: TObject);
  private
    { Private declarations }
  public
    Function  CheckRecord : Boolean; override;
    Procedure DefaultValues; override;
  end;

var
  FBrowseFIN_BATCHES: TFBrowseFIN_BATCHES;

implementation

uses DM, UUtilityParent, AutoCreate;

{$R *.dfm}


Function  TFBrowseFIN_BATCHES.CheckRecord : Boolean;
Begin
  Result := CheckValid.ReducRestrictEmpty(Self, [DESCRIPTION]);
End;

Procedure TFBrowseFIN_BATCHES.DefaultValues;
Begin
 Query['ID'] := DModule.SingleValue('select main_seq.nextval from dual');
End;


procedure TFBrowseFIN_BATCHES.BUpdChild1Click(Sender: TObject);
begin
  AutoCreate.FIN_DOCSShowModalAsBrowser( Query['Id'] ,'', '');
end;

end.
