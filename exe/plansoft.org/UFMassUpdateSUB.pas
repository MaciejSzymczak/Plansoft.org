unit UFMassUpdateSUB;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormConfig, StdCtrls, Buttons, ExtCtrls;

type
  TFMassUpdateSUB = class(TFormConfig)
    Label1: TLabel;
    LCnt: TLabel;
    mrYes: TButton;
    mrNo: TButton;
    BUpdCancel: TBitBtn;
    procedure mrYesClick(Sender: TObject);
    procedure mrNoClick(Sender: TObject);
    procedure BUpdCancelClick(Sender: TObject);
  private
    successFlag : boolean;
  public
    ids : string;
    tableName: string;
    function execute (ptableName: string; pids : string) : boolean;
    procedure doUpdate(newVal : string);
  end;

var
  FMassUpdateSUB: TFMassUpdateSUB;

implementation

uses DM, UUtilityParent;

{$R *.dfm}

{ TFMassUpdateSUB }

function TFMassUpdateSUB.execute(ptableName: string; pids: string) : boolean;
begin
  ids := pids;
  tableName := ptableName;
  showModal;
  result := successFlag;
end;

procedure TFMassUpdateSUB.doUpdate(newVal: string);
begin
 dmodule.SQL('begin update '+tableName+' set DIFF_NOTIFICATIONS=:newVal where id in ('+ids+'); commit; end;', 'newVal='+newVal);
end;

procedure TFMassUpdateSUB.mrYesClick(Sender: TObject);
begin
  doUpdate('+');
  info('Zrobione. Emaile bêd¹ wysy³ane.');
  successFlag := true;
end;

procedure TFMassUpdateSUB.mrNoClick(Sender: TObject);
begin
  doUpdate('-');
  info('Zrobione. Emaile NIE bêd¹ wysy³ane.');
  successFlag := true;
end;

procedure TFMassUpdateSUB.BUpdCancelClick(Sender: TObject);
begin
  successFlag := false;
end;

end.
