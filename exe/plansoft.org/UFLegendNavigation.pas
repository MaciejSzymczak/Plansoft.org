unit UFLegendNavigation;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons;

type
  TFLegendNavigation = class(TForm)
    dspL: TLabel;
    dspG: TLabel;
    dspR: TLabel;
    dspS: TLabel;
    dspF: TLabel;
    Bcancel: TBitBtn;
    procedure dspLMouseEnter(Sender: TObject);
    procedure dspLMouseLeave(Sender: TObject);
    procedure dspLClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BcancelClick(Sender: TObject);
  private
    { Private declarations }
  public
    itemClicked : string;
    function Open(idL, idG, idR, idF, idS : String; dspL, dspG, dspR, dspF, dspS : String) : tModalResult;
  end;

var
  FLegendNavigation: TFLegendNavigation;

implementation

{$R *.dfm}

{ TFLegendNavigation }

function TFLegendNavigation.Open(
  idL, idG, idR, idF, idS,
  dspL, dspG, dspR, dspF, dspS: String) : tModalResult;
begin
   self.dspL.caption := dspL;
   self.dspG.caption := dspG;
   self.dspR.caption := dspR;
   self.dspS.caption := dspS;
   self.dspF.caption := dspF;
   With self do begin
     if  dspL.Caption <> '' then begin dspL.Hint := 'Kliknij aby przejœæ do rozk³adu';  dspL.Caption:=dspL.Caption+' >>'; end;
     if  dspG.Caption <> '' then begin dspG.Hint := 'Kliknij aby przejœæ do rozk³adu';  dspG.Caption:=dspG.Caption+' >>'; end;
     if  dspR.Caption <> '' then begin dspR.Hint := 'Kliknij aby przejœæ do rozk³adu';  dspR.Caption:=dspR.Caption+' >>'; end;
     if  dspS.Caption <> '' then begin dspS.Hint := 'Kliknij aby wyró¿niæ na rozk³adzie'; dspS.Caption:=dspS.Caption+' *'; end;
     if  dspF.Caption <> '' then begin dspF.Hint := 'Kliknij aby wyró¿niæ na rozk³adzie'; dspF.Caption:=dspF.Caption+' *'; end;
     ShowModal;
   end;
end;

procedure TFLegendNavigation.dspLMouseEnter(Sender: TObject);
begin
  (Sender as TLabel).Font.Color := clBlue;
  (Sender as TLabel).Font.Style := [fsUnderline];
end;

procedure TFLegendNavigation.dspLMouseLeave(Sender: TObject);
begin
  (Sender as TLabel).Font.Color := clBlack;
  (Sender as TLabel).Font.Style := [];
end;

procedure TFLegendNavigation.dspLClick(Sender: TObject);
begin
  itemClicked := (Sender as TLabel).Name;
  Close;
end;

procedure TFLegendNavigation.FormShow(Sender: TObject);
begin
  itemClicked := '';
end;

procedure TFLegendNavigation.BcancelClick(Sender: TObject);
begin
 Close;
end;

end.
