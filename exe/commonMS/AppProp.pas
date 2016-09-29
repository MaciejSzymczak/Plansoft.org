unit AppProp;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Registry, DAppProp;

type
  TRegRoot=(rrCLASSES_ROOT,rrCURRENT_USER,rrLOCAL_MACHINE,rrUSERS,rrPERFORMANCE_DATA,rrCURRENT_CONFIG,rrDYN_DATA);
  THintProperties = class(TComponent)
  private
    FCaption:STRING;
    FRegPath:STRING;
    FRegRoot:TRegRoot;
  protected
  public
    constructor Create(AOwner:TComponent);override;
    function Execute:Boolean;
    function ReadFromRegistry:Boolean;
    function WriteToRegistry:Boolean;
  published
    property Caption:STRING read FCaption write FCaption;
    property RegisteryPath:STRING read FRegPath write FRegPath;
    property RegistryRoot:TRegRoot read FRegRoot write FRegRoot default rrCURRENT_USER;
  end;

procedure Register;

implementation

{$R *.DCR}

procedure Register;
begin
  RegisterComponents('Kamil', [THintProperties]);
end;

constructor THintProperties.Create(AOwner:TComponent);
begin
  inherited Create(AOwner);
  FCaption:='Hint settings ...';
  FRegRoot:=rrLOCAL_MACHINE;
  FRegPath:='SOFTWARE\KAMIL\AppsSettings';
  ReadFromRegistry;
end;

function THintProperties.Execute:Boolean;
var D:TAppPropDial;
begin
  D:=TAppPropDial.Create(self);
  D.Caption:=FCaption;
  if D.ShowModal=mrOK then begin
    if D.Save.Checked then WriteToRegistry;
    Result:=TRUE;
  end else Result:=FALSE;
  D.Destroy;
end;

function THintProperties.ReadFromRegistry:Boolean;
var R:TRegistry;
    i:Integer;
begin
  Result:=TRUE;
  R:=TRegistry.Create;
  R.RootKey:=Ord(FRegRoot)+$80000000;
  if R.OpenKey(FRegPath,FALSE) then begin
    try
      i:=R.ReadInteger('HintColor');
    except
      i:=$FFFF;
      Result:=FALSE;
    end;
    Application.HintColor:=i;
    try
      i:=R.ReadInteger('HintPause');
    except
      i:=500;
      Result:=FALSE;
    end;
    Application.HintPause:=i;
    try
      i:=R.ReadInteger('HintHidePause');
    except
      i:=2500;
      Result:=FALSE;
    end;
    Application.HintHidePause:=i;
    try
      i:=R.ReadInteger('HintShortPause');
    except
      i:=50;
      Result:=FALSE;
    end;
    Application.HintShortPause:=i;
  end else Result:=FALSE;
  R.destroy;
end;

function THintProperties.WriteToRegistry:Boolean;
var R:TRegistry;
begin
  Result:=TRUE;
  R:=TRegistry.Create;
  R.RootKey:=Ord(FRegRoot)+$80000000;
  if R.OpenKey(FRegPath,TRUE) then begin
    try
      R.WriteInteger('HintColor',Application.HintColor);
    except
      Result:=FALSE;
    end;
    try
      R.WriteInteger('HintPause',Application.HintPause);
    except
      Result:=FALSE;
    end;
    try
      R.WriteInteger('HintHidePause',Application.HintHidePause);
    except
      Result:=FALSE;
    end;
    try
      R.WriteInteger('HintShortPause',Application.HintShortPause);
    except
      Result:=FALSE;
    end;
  end else Result:=FALSE;
end;
  
end.
