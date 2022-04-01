unit UFPulpitSelector;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormConfig, StdCtrls, Buttons, ExtCtrls, UUtilityParent;

type
  TFPulpitSelector = class(TFormConfig)
    Cancel: TBitBtn;
    Pulpit1: TSpeedButton;
    Pulpit3: TSpeedButton;
    Pulpit2: TSpeedButton;
    Pulpit4: TSpeedButton;
    Pulpit5: TSpeedButton;
    Pulpit7: TSpeedButton;
    Pulpit6: TSpeedButton;
    FCopy: TCheckBox;
    Rename: TCheckBox;
    procedure Pulpit2Click(Sender: TObject);
    procedure CancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    currentChoice : string;
    currentPulpitName : string;
    function showPulpitSelector (activePulpit : integer) : string;
  end;

var
  FPulpitSelector: TFPulpitSelector;

implementation

{$R *.dfm}

procedure TFPulpitSelector.Pulpit2Click(Sender: TObject);
begin
  if Rename.checked then begin
    (Sender as TSpeedButton).Caption := Dialogs.InputBox('Prze³¹czenie pulpitu','Nazwij pulpit (10-20 znaków) lub nacisnij enter',(Sender as TSpeedButton).Caption);
    currentPulpitName :=  (Sender as TSpeedButton).Caption;
    Rename.checked := false;
  end;
  currentChoice :=  (Sender as TSpeedButton).Name;
  close;
end;

procedure TFPulpitSelector.CancelClick(Sender: TObject);
begin
  currentChoice := 'Cancel';
  close;
end;

function TFPulpitSelector.showPulpitSelector (activePulpit : integer): string;
begin
  if activePulpit =1 then Pulpit1.Down := true;
  if activePulpit =2 then Pulpit2.Down := true;
  if activePulpit =3 then Pulpit3.Down := true;
  if activePulpit =4 then Pulpit4.Down := true;
  if activePulpit =5 then Pulpit5.Down := true;
  if activePulpit =6 then Pulpit6.Down := true;
  if activePulpit =7 then Pulpit7.Down := true;
  showmodal;
  result := currentChoice;
end;

procedure TFPulpitSelector.FormShow(Sender: TObject);
var iniFileName : string;
begin
  inherited;
  iniFileName :=  UUtilityParent.StringsPATH + extractFileName(Application.ExeName) + '.FPulpitSelector.ini';

  if FileExists(iniFileName) then
    uutilityparent.LoadFromIni(
            iniFileName , 'FPulpitSelector',
            [ Pulpit1, Pulpit2, Pulpit3, Pulpit4, Pulpit5, Pulpit6, Pulpit7
            ], true);

end;

procedure TFPulpitSelector.FormClose(Sender: TObject;
  var Action: TCloseAction);
var iniFileName : string;
begin
  iniFileName :=  UUtilityParent.StringsPATH + extractFileName(Application.ExeName) + '.FPulpitSelector.ini';
  uutilityparent.saveToIni(
            iniFileName , 'FPulpitSelector',
            [ Pulpit1, Pulpit2, Pulpit3, Pulpit4, Pulpit5, Pulpit6, Pulpit7
            ]);
  inherited;
end;

end.
