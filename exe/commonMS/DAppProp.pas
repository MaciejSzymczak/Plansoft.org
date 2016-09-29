unit DAppProp;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Buttons, ComCtrls, IntlFunc;

type
  TAppPropDial = class(TForm)
    CD: TColorDialog;
    Panel1: TPanel;
    OK: TBitBtn;
    Cancel: TBitBtn;
    Panel2: TPanel;
    Bevel1: TBevel;
    COLPRO: TShape;
    Kolor: TBitBtn;
    GroupBox1: TGroupBox;
    Panel3: TPanel;
    HPause: TTrackBar;
    StaticText1: TStaticText;
    Panel4: TPanel;
    HSPause: TTrackBar;
    StaticText2: TStaticText;
    Panel5: TPanel;
    HHPause: TTrackBar;
    StaticText3: TStaticText;
    SAVE: TCheckBox;
    procedure KolorClick(Sender: TObject);
    procedure OKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure HPauseChange(Sender: TObject);
    procedure HHPauseExit(Sender: TObject);
    procedure HSPauseExit(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AppPropDial: TAppPropDial;

implementation

{$R *.DFM}

procedure TAppPropDial.KolorClick(Sender: TObject);
begin
  CD.Color:=ColPro.Brush.Color;
  if CD.Execute then ColPro.Brush.Color:=CD.Color;
end;

procedure TAppPropDial.OKClick(Sender: TObject);
begin
  Application.HintColor:=COLPRO.Brush.Color;
  Application.HintPause:=HPause.Position;
  Application.HintHidePause:=HHPause.Position;
  Application.HintShortPause:=HSPause.Position;
  ModalResult:=mrOK;
end;

procedure TAppPropDial.FormCreate(Sender: TObject);
begin
  SetCaptionsEx('ITLLIB1.DLL',0,self);
  COLPRO.Brush.Color:=Application.HintColor;
  HPause.Position:=Application.HintPause;
  HHPause.Position:=Application.HintHidePause;
  HSPause.Position:=Application.HintShortPause;
end;

procedure TAppPropDial.HPauseChange(Sender: TObject);
begin
  if  HPause.Position mod 250<>0 then HPause.Position:=((HPause.Position+125) div 250)*250;
end;

procedure TAppPropDial.HHPauseExit(Sender: TObject);
begin
  if  HHPause.Position mod 500<>0 then HHPause.Position:=((HHPause.Position+250) div 500)*500;
end;

procedure TAppPropDial.HSPauseExit(Sender: TObject);
begin
  if  HSPause.Position mod 50<>0 then HSPause.Position:=((HSPause.Position+25) div 50)*50;
end;

end.
