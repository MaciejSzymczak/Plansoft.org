unit UFCellLayout;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, Buttons, UFMain, UFormConfig, UCommon;

type
  TFCellLayout = class(TFormConfig)
    GroupBox2: TGroupBox;
    selectFill: TSpeedButton;
    CellColor: TComboBox;
    GroupBox1: TGroupBox;
    Image1: TImage;
    BCellReset: TSpeedButton;
    BCellFont: TSpeedButton;
    ForcedCellHeight: TTrackBar;
    ForceCellWidth: TCheckBox;
    ForcedCellWidth: TTrackBar;
    ForceCellHeight: TCheckBox;
    descriptions: TGroupBox;
    D1: TComboBox;
    D2: TComboBox;
    D3: TComboBox;
    D4: TComboBox;
    D5: TComboBox;
    Shape1: TShape;
    cellTimer: TTimer;
    D6: TComboBox;
    D7: TComboBox;
    D8: TComboBox;
    HideTheSameDesc: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure cellTimerTimer(Sender: TObject);
    procedure CellColorChange(Sender: TObject);
    procedure selectFillClick(Sender: TObject);
    procedure D1Change(Sender: TObject);
    procedure ForceCellWidthClick(Sender: TObject);
    procedure ForcedCellWidthChange(Sender: TObject);
    procedure ForcedCellHeightChange(Sender: TObject);
    procedure ForceCellHeightClick(Sender: TObject);
    procedure BCellResetClick(Sender: TObject);
    procedure BCellFontClick(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure GroupBox1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure GroupBox2MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure descriptionsMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure HideTheSameDescClick(Sender: TObject);
  private
    { Private declarations }
  public
    displayFlag : boolean;
    hideDelay : integer;
    procedure displayCellLayout(immediate : boolean);
    procedure hideCellLayout(immediate : boolean);
    procedure setupWindow;
    procedure refreshLayout;
  end;

var
  FCellLayout: TFCellLayout;

implementation


{$R *.dfm}

{ TFCellLayout }

procedure TFCellLayout.setupWindow;
var point : tpoint;
begin
 Point.x := 0;
 Point.y := fmain.BShowCellLayout.Height;
 Point   := fmain.BShowCellLayout.ClientToScreen(Point);
 Left := point.X - (fcellLayout.Width div 2);
 if Left < 0 then Left := 0;
 Top  := point.Y;
 show;
end;

procedure TFCellLayout.FormCreate(Sender: TObject);
begin
  displayFlag := false;
  self.AlphaBlendValue := 0;
  self.AlphaBlend := true;
end;

procedure TFCellLayout.cellTimerTimer(Sender: TObject);

 function min(v1,v2:integer):integer;
 begin
  if v1 < v2 then result := v1 else result := v2;
 end;
 function max(v1,v2:integer):integer;
 begin
  if v1 < v2 then result := v2 else result := v1;
 end;

 var newAlpha : integer;

begin
  With FCellLayout do begin
      if displayFlag then begin
          if not Visible then setupWindow;
          if AlphaBlendValue < 255 then begin
              newAlpha := min(AlphaBlendValue + 20,255);
              AlphaBlendValue := newAlpha;
          end
          else begin
              cellTimer.Enabled := false;
          end;
      end;
      if not displayFlag then begin
        if hideDelay > 0 then begin
            hideDelay := hideDelay -1;
            exit;
        end;
        If AlphaBlendValue > 0
          then AlphaBlendValue := max(AlphaBlendValue - 20,0)
          else begin
            hide;
            cellTimer.Enabled := false;
          end;
      end;
  End;
end;

procedure TFCellLayout.CellColorChange(Sender: TObject);
begin
 Fmain.ColoringChange(sender);
end;

procedure TFCellLayout.selectFillClick(Sender: TObject);
begin
 fmain.bdelpopupClick(sender);
end;

procedure TFCellLayout.D1Change(Sender: TObject);
begin
 refreshLayout;
end;


procedure TFCellLayout.ForcedCellWidthChange(Sender: TObject);
begin
 if fmain.CanBuildCalendar then
   fmain.refreshGrid;
end;

procedure TFCellLayout.ForcedCellHeightChange(Sender: TObject);
begin
 if fmain.CanBuildCalendar then
   fmain.refreshGrid;
end;

procedure TFCellLayout.ForceCellWidthClick(Sender: TObject);
begin
 refreshLayout;
end;

procedure TFCellLayout.ForceCellHeightClick(Sender: TObject);
begin
 refreshLayout;
end;

procedure TFCellLayout.BCellResetClick(Sender: TObject);
begin
 fmain.BCellResetClick(sender);
end;

procedure TFCellLayout.BCellFontClick(Sender: TObject);
begin
 fmain.BCellFontClick(nil);
end;

procedure TFCellLayout.Image1Click(Sender: TObject);
begin
 fmain.Image1Click(sender);
end;

procedure TFCellLayout.GroupBox1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  displayCellLayout(false);
end;

procedure TFCellLayout.GroupBox2MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  displayCellLayout(false);
end;

procedure TFCellLayout.descriptionsMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  displayCellLayout(false);
end;

procedure TFCellLayout.displayCellLayout(immediate : boolean);
begin
  displayFlag := true;
  if (Visible) and (AlphaBlendValue=255) then exit;
  //window is in state "not visible and AlphaBlendValue=255" when modal window was displayed
  if not visible then AlphaBlendValue := 0;
  if immediate then begin
    AlphaBlendValue:=255;
    cellTimerTimer(self);
  end;
  cellTimer.Enabled := true;
end;

procedure TFCellLayout.hideCellLayout(immediate : boolean);
begin
  displayFlag := false;
  if not Visible then exit;
  if immediate then begin
    hideDelay :=0;
    AlphaBlendValue:=0;
    cellTimerTimer(self);
  end else
  if AlphaBlendValue=255 then hideDelay := (255 div 20);
  cellTimer.Enabled := true;
end;

procedure TFCellLayout.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
 {.}
end;

procedure TFCellLayout.refreshLayout;
begin
 With FMain do begin
	 If getCode(D1) = 'NONE' Then Begin D1.ItemIndex := D2.ItemIndex; D2.ItemIndex := getItemIndex(D2, 'NONE'); End;
	 If getCode(D2) = 'NONE' Then Begin D2.ItemIndex := D3.ItemIndex; D3.ItemIndex := getItemIndex(D3, 'NONE'); End;
	 If getCode(D3) = 'NONE' Then Begin D3.ItemIndex := D4.ItemIndex; D4.ItemIndex := getItemIndex(D4, 'NONE'); End;
	 If getCode(D4) = 'NONE' Then Begin D4.ItemIndex := D5.ItemIndex; D5.ItemIndex := getItemIndex(D5, 'NONE'); End;
	 If getCode(D5) = 'NONE' Then Begin D5.ItemIndex := D6.ItemIndex; D6.ItemIndex := getItemIndex(D6, 'NONE'); End;
	 If getCode(D6) = 'NONE' Then Begin D6.ItemIndex := D7.ItemIndex; D7.ItemIndex := getItemIndex(D7, 'NONE'); End;
	 If getCode(D7) = 'NONE' Then Begin D7.ItemIndex := D8.ItemIndex; D8.ItemIndex := getItemIndex(D8, 'NONE'); End;

	 D2.Visible := D1.ItemIndex <> getItemIndex(D1, 'NONE');
	 D3.Visible := D2.ItemIndex <> getItemIndex(D2, 'NONE');
	 D4.Visible := D3.ItemIndex <> getItemIndex(D3, 'NONE');
	 D5.Visible := D4.ItemIndex <> getItemIndex(D4, 'NONE');
	 D6.Visible := D5.ItemIndex <> getItemIndex(D5, 'NONE');
	 D7.Visible := D6.ItemIndex <> getItemIndex(D6, 'NONE');
	 D8.Visible := D7.ItemIndex <> getItemIndex(D7, 'NONE');

   FcellLayout.ForcedCellHeight.Visible := FcellLayout.ForceCellHeight.Checked;
   FcellLayout.ForcedCellWidth.Visible  := FcellLayout.ForceCellWidth.Checked;

   If CanShow Then Begin
     RefreshGrid;
   End;

 end;

end;

procedure TFCellLayout.HideTheSameDescClick(Sender: TObject);
begin
 refreshLayout;
end;

end.
